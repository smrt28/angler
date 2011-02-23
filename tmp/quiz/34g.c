#define UHELNIK n_uhelnik

int n_uhelnik;

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>
#include <SDL/SDL.h>
#include <SDL/SDL_gfxPrimitives.h>

#define POSX 10
#define POSY 10

#define GRIDX 24 
#define GRIDY 24

#define RAD	1

#define MAXX	40
#define MAXY	25

#define MAX(x, y)	((x) > (y) ? (x) : (y))
#define MIN(x, y)	((x) < (y) ? (x) : (y))

#define MAX_LINES 2000

#define LTOP (&lstack[lstack_top - 1])

#define tform_x(x)	(((x) * GRIDX) + POSX)
#define tform_y(y)	(((y) * GRIDY) + POSY)

#define SMALL (0.00001)

#define dcmp(x, y) ((x)+SMALL > y && (x)-SMALL < y)

FILE * output = NULL;


void * lstack_bak;
int lstack_top_bak;

void * xmalloc(size_t sz)
{
    void *ret =	malloc(sz);
    if (ret == NULL)
    {
        printf("error: malloc failed...\n");
        exit(1);
    }
    return ret;
}

typedef struct 
{
    double x, y;	
} point_t;

typedef struct 
{
    point_t p1;
    point_t p2;
} line_t;

typedef struct
{
    int r, g, b, a;
} color_t;

void run(void);
void show_pg_list(void);
void show_ps(void);

int sel_x = -1;
int sel_y = -1;
SDL_Surface * screen;
color_t current_color = { 155, 155, 155, 255 };

line_t * lstack;

int lstack_top = 0;

void print_point(point_t *p) { printf("[%f, %f]", p->x, p->y); }

void emit(char *ch, ...)
{
    va_list va;
    va_start(va, ch);
    vfprintf(output, ch, va);
    fprintf(output, "");
}


void set_color(int r, int g, int b)
{
    current_color.r = r;
    current_color.g = g;
    current_color.b = b;
}

void raw_line(int x1, int y1, int x2, int y2) 
{
    if (x1 == x2 && y1 == y2) return;
    lineRGBA(screen, x1, y1, x2, y2, 
            current_color.r, current_color.g, current_color.b, current_color.a);
}


void line(int x1, int y1, int x2, int y2) 
{
    if (x1 == x2 && y1 == y2) return;
    lineRGBA(screen, tform_x(x1), tform_y(y1), tform_x(x2), tform_y(y2), 
            current_color.r, current_color.g, current_color.b, current_color.a);
}

void sline(line_t *l) 
{
    line(l->p1.x, l->p1.y, l->p2.x, l->p2.y);
}

void push_line(int x1, int y1, int x2, int y2)
{
    line_t * l;

    if (x1==x2 && y1==y2) return;
    if (lstack_top == MAX_LINES) { printf("MAX_LINES reached...\n"); exit(0); }
    l = &lstack[lstack_top]; lstack_top++;

    l->p1.x = x1;
    l->p1.y = y1;
    l->p2.x = x2;
    l->p2.y = y2;
}

void pop_line(void)
{
    if (lstack_top == 0) return;
    lstack_top--;
}

void circle(int x, int y, int rad)
{
    filledCircleRGBA(screen, tform_x(x),  tform_y(y), rad, 
            current_color.r, current_color.g, current_color.b, current_color.a);
}

void redraw(void)
{
    int i, j;
    color_t co;
    boxRGBA(screen, 0, 0, screen->w, screen->h, 0,0,0,255);
    for (i=0;i<=MAXX;i++)
        for (j=0;j<=MAXY;j++)
            circle(i, j, RAD);
    for (i=0;i<lstack_top;i++)
        sline(&lstack[i]);
    if (sel_x != -1 && sel_y != -1) 
    {
        co = current_color;
        set_color(0, 0, 200);
        circle(sel_x, sel_y, RAD);
        current_color = co;
    }
    SDL_UpdateRect(screen, 0, 0, 0, 0);
}

void any_key(void)
{
    SDL_Event event;
    do
    {
        SDL_WaitEvent(&event);
    } while(event.type!=SDL_KEYDOWN);
}

int main_loop(void)
{
    color_t co;
    int x, y;
    SDL_MouseButtonEvent *me;
    SDL_KeyboardEvent *kb;
    SDL_Event event;
    for (;;)
    {
        SDL_WaitEvent(&event);
        switch(event.type)
        {
            case SDL_KEYDOWN:
                kb = (SDL_KeyboardEvent *)&event;
                if (kb->keysym.sym == SDLK_BACKSPACE)
                {
                    if (lstack_top != 0)
                    {
                        sel_x = LTOP->p1.x;
                        sel_y = LTOP->p1.y;

                    }
                    pop_line();
                    redraw();
                    break;
                }

                if (kb->keysym.sym == SDLK_ESCAPE)
                {
                    exit(0);
                    break;
                }

                if (kb->keysym.sym == SDLK_RETURN)
                {
                    lstack_top_bak = lstack_top;
                    lstack_bak = xmalloc(sizeof(line_t[MAX_LINES]));
                    memcpy(lstack_bak, lstack, sizeof(line_t[MAX_LINES]));
                    run();
                    memcpy(lstack, lstack_bak, sizeof(line_t[MAX_LINES]));
                    lstack_top = lstack_top_bak;
                    free(lstack_bak);
                    break;
                }
                break;
            case SDL_MOUSEBUTTONDOWN:
                me = (SDL_MouseButtonEvent *)&event;
                x = (me->x - POSX + (GRIDX / 2)) / GRIDX;
                y =	(me->y - POSY + (GRIDY / 2)) / GRIDY;
                if (x < 0 || y < 0 || x > MAXX || y > MAXY) break;

                if (sel_x != -1 && sel_y != -1)
                {
                    if (me->button == SDL_BUTTON_LEFT)
                    {
                        line(sel_x, sel_y, x, y);
                        push_line(sel_x, sel_y, x, y);
                    }
                    circle(sel_x, sel_y, RAD);					
                }

                co = current_color;
                set_color(0, 0, 200);
                circle(x, y, RAD);

                current_color = co;

                sel_x = x;
                sel_y = y;
                SDL_UpdateRect(screen, 0, 0, 0, 0);
                break;

        }
    }
    return 0;
}

int cmp_points(point_t *p1, point_t *p2)
{
    if (dcmp(p1->x, p2->x) && dcmp(p1->y, p2->y)) return 1;
    return 0;
}

struct spot;

typedef struct line_to
{
    struct spot * to;
    struct line_to * next;
} line_to_t;


typedef struct spot
{
    point_t p;
    line_to_t * first;
    line_to_t * mark;
} spot_t;


int are_connected(spot_t *s1, spot_t *s2)
{
    line_to_t * lt = s1->first;
    while(lt)
    {
        if (cmp_points(&lt->to->p, &(s2->p)))
            return 1;
        lt = lt->next;
    }
    return 0;
}

spot_t * find_spot(spot_t ** sl, int len, point_t *p)
{
    int i = 0;
    while(*sl)
    {
        if (cmp_points(&(*sl)->p, p))
            return *sl;
        sl++; i++;
        if (i==len) 
        {
            printf("NSPOTS is max!\n");	
            exit(1);
        }
    }
    *sl = xmalloc(sizeof(spot_t));
    (*sl)->p = *p;
    (*sl)->first = NULL;
    (*sl)->mark = NULL;
    return *sl;
}

void connect_spots(spot_t * s1, spot_t * s2)
{
    line_to_t *lt;
    if (!are_connected(s1, s2))
    {
        lt = xmalloc(sizeof(line_to_t));
        lt->to = s2;
        lt->next = s1->first;
        s1->first = lt;
    }
    if (!are_connected(s2, s1))
    {
        lt = xmalloc(sizeof(line_to_t));
        lt->to = s1;
        lt->next = s2->first;
        s2->first = lt;
    }
}


void disconnect_spots(spot_t * s1, spot_t * s2)
{
    line_to_t *lt, *tmp;

    lt = s1->first;

    if (lt->to == s2)
    {
        tmp = lt->next;

        if (s1->mark == lt) s1->mark = NULL;

        free(lt);
        s1->first = tmp;
        return;
    }
    while (lt->next)
    {
        if (lt->next->to == s2)
        {

            tmp = lt->next->next;

            if (s1->mark == lt->next) s1->mark = lt;

            free(lt->next);
            lt->next = tmp;
            return;
        }
        lt = lt->next;
    }
}


int cmp_lines(line_t *l1, line_t *l2)
{
    if (cmp_points(&l1->p1, &l2->p1) && cmp_points(&l1->p2, &l2->p2))	return 1;
    if (cmp_points(&l1->p1, &l2->p2) && cmp_points(&l1->p2, &l2->p1))	return 1;
    return 0;
}


spot_t * next_spot(spot_t * sp, spot_t * top)
{
    if (sp->mark == NULL)
        sp->mark = sp->first;
    else
        sp->mark = sp->mark->next;

    /* uz neni dalsi naslednik / vratil jsem se tam odkut jsem vysel */
    while (sp->mark && sp->mark->to != top && sp->mark->to->mark != NULL) 
        sp->mark = sp->mark->next;


    if (sp->mark == NULL) return NULL;

    return sp->mark->to;
}


int are_in_line(spot_t * s1, spot_t * s2, spot_t * s3)
{
    double a, b;
    double x1, y1, x2, y2;

    x1 = s2->p.x - s1->p.x;
    y1 = s2->p.y - s1->p.y;
    x2 = s3->p.x - s2->p.x;
    y2 = s3->p.y - s2->p.y;

    a = (x1 * y2);	
    b = (x2 * y1);
    if (dcmp(a, b))	return 0;
    return 1;
}


void cut_lines(void);
#define NSPOTS	10000

void clear_spotlist(spot_t ** sl)
{
    line_to_t *lt, *tmp;
    for (;*sl;sl++)
    {
        lt = (*sl)->first;
        (*sl)->first = NULL;
        while(lt)
        {
            tmp = lt;
            free(lt);
            lt = tmp->next;			
        }
    }
}

#define MAX_SPOT_STACK	100
#define DEBUG


typedef struct point_group
{
    struct point_group * next;
    point_t p[4];
} point_group_t;

point_group_t * pg_list = NULL;

void clear_pg_list(void)
{
    point_group_t * tmp;
    while (pg_list)
    {
        tmp = pg_list->next;
        free(pg_list);
        pg_list = tmp;
    }
}

void mark_way(spot_t ** st)
{
    point_group_t * pg;
    int i, j, x1, y1, x2, y2, go;

    pg = xmalloc(sizeof(point_group_t) + sizeof(point_t[UHELNIK-1]));
    for (i=0, j=0;;i++)
    {
        if (i>1 && are_in_line(st[i-2],st[i-1],st[i]))
        {
#ifdef DEBUG
            if (j>=UHELNIK)
            {
                printf("INVARIANT line: %d; %d\n", __LINE__, j);
                exit(1);
            }
#endif
            pg->p[j] = st[i-1]->p;
            j++;
        }
        if (i!=0 && st[i] == st[0])
        {

            if (are_in_line(st[i-1], st[i], st[1]))
            {
#ifdef DEBUG
                if (j>=UHELNIK)
                {
                    printf("INVARIANT line: %d; %d\n", __LINE__, j);
                    exit(1);
                }
#endif
                pg->p[j] = st[i]->p;
#ifdef DEBUG
                j++;
#endif

            }
            break;
        }
    }
#ifdef DEBUG
    if (j!=UHELNIK)
    {
        printf("INVARIANT line: %d; %d\n", __LINE__, j);
        exit(1);
    }
#endif
    pg->next = pg_list;
    pg_list = pg;
}

void run(void)
{
    int sum = 0;
    spot_t * stack[MAX_SPOT_STACK];
    int curves[MAX_SPOT_STACK];

    int top = 0;

    int dep = UHELNIK;
    spot_t *s1, *s2;
    line_t * l;
    int  j, i, x;
    spot_t * slist[NSPOTS];

    clear_pg_list();	
    cut_lines();
    memset(stack, 0, sizeof(stack));
    memset(curves, 0, sizeof(curves));
    memset(slist, 0, sizeof(slist));

    for (i=0;i<lstack_top;i++)
    {
        l = &lstack[i];
        s1 = find_spot(slist, NSPOTS, &l->p1);
        s2 = find_spot(slist, NSPOTS, &l->p2);
        connect_spots(s1, s2);
    }

    i = 0; 

    for (j=0;slist[j];j++)
    {
        top=0;
        stack[top] = slist[j];
        x = 0;
        while (top >= 0)
        {
            while ((stack[top+1] = next_spot(stack[top], stack[0])) != NULL)
            {
                top++; 
                if (top+1==MAX_SPOT_STACK)
                {
                    printf("MAX_SPOT_STACK is max!\n");
                    exit(1);
                }
                if (top > 1) curves[top] = are_in_line(stack[top - 2], stack[top-1], stack[top]);
                x += curves[top];
                if (x > dep) break;
                if (stack[top] == stack[0])
                {
                    if (x + are_in_line(stack[top - 1], stack[0], stack[1])==dep) 
                    {
                        mark_way(stack);
                        sum++;
                    }
                    x -= curves[top];
                    curves[top] = 0; top--; 
                    continue;
                }
            }
            x -= curves[top];
            curves[top] = 0; top--;

            if (top==0)
            {

                disconnect_spots(stack[0], stack[1]);
                disconnect_spots(stack[1], stack[0]);
                stack[1] = NULL;

            }
        }
        slist[j]->mark++;
    }
    show_pg_list();
    show_ps();
    printf("*%d*\n", sum);
}


int get_ab(double *a, double *b, line_t *l)
{
    double vx, vy;

    vx = l->p2.x - l->p1.x;
    vy = l->p2.y - l->p1.y;

    if (dcmp(vx, 0)) 
    {
        *a = l->p1.x;
        return 1;
    }
    *a = vy / vx;
    *b = l->p2.y - (*a * l->p2.x);
    return 0;
}

int intersection(line_t * l1, line_t * l2, point_t *p)
{
    int n1, n2;
    double a1, b1, a2, b2;

    int ret = 0;

    n1 = get_ab(&a1, &b1, l1);
    n2 = get_ab(&a2, &b2, l2);

    if (dcmp(a1, a2)) return 0; // jsou rovnobezne!

    if (n1)
    {
        p->x = a1;
        p->y = a2 * p->x + b2;
    } else if (n2)
    {
        p->x = a2;
        p->y = a1 * p->x + b1;
    } else
    {
        p->x = (b2 - b1) / (a1 - a2);
        p->y = a1 * p->x + b1;
    }
    if (		MIN(l1->p1.x, l1->p2.x) < p->x + SMALL &&
            MAX(l1->p1.x, l1->p2.x) > p->x - SMALL &&

            MIN(l1->p1.y, l1->p2.y) < p->y + SMALL &&
            MAX(l1->p1.y, l1->p2.y) > p->y - SMALL &&

            MIN(l2->p1.x, l2->p2.x) < p->x + SMALL &&
            MAX(l2->p1.x, l2->p2.x) > p->x - SMALL &&

            MIN(l2->p1.y, l2->p2.y) < p->y + SMALL &&
            MAX(l2->p1.y, l2->p2.y) > p->y - SMALL )
    {

        if (!(cmp_points(&l1->p1, p) || cmp_points(&l1->p2, p)))
            ret |= (1 << 1);

        if (!(cmp_points(&l2->p1, p) || cmp_points(&l2->p2, p)))
            ret |= (1 << 0);
    }
    return ret;
}

void cut_lines(void)
{
    line_t l1, l2;
    line_t * l;
    point_t p;
    int r, i, j;

    for (i=0;i<lstack_top;i++)
    {
        l = &lstack[i];
        for (j=0;j<lstack_top;j++)
        {
            r = intersection(l, &lstack[j], &p);
            if (r & (1 << 1))
            {
                l1.p1 = l->p1;
                l1.p2 = p;

                l2.p1 = p;
                l2.p2 = l->p2;
                *l = l1;
                if (lstack_top==MAX_LINES)
                {
                    printf("MAX_LINES is max!\n");
                    exit(1);
                }
                lstack[lstack_top] = l2;
                lstack_top++;
                i--; break;
            } 
        }
    }
}

void init(void)
{
    lstack = xmalloc(sizeof(line_t[MAX_LINES]));
}

void show_pg_list(void)
{
    int i;
    point_group_t *pg = pg_list;
    while(pg)
    {
        for (i=0;i<UHELNIK;i++)
            print_point(&pg->p[i]);
        printf("\n");
        pg = pg->next;
    }
}

void show_ps(void)
{
    double xmax = 0, ymax = 0, xx, yy;
    double xmin = 9999999, ymin = 9999999;
    double width, heigh;

    int i, j, k;
    double cur_x, cur_y, x, y;
    int cur_set_flag = 0;
    point_group_t * pg = pg_list;

    if (pg == NULL)
        return;


    output = fopen("out.ps", "w");

    emit("/main_graph {\n");
    emit("0 setlinewidth\n");
    emit("0 setgray\n");

    for (i=0;i<lstack_top;i++)
    {
        xmax = MAX(lstack[i].p1.x, xmax); xmin = MIN(lstack[i].p1.x, xmin);
        ymax = MAX(lstack[i].p1.y, ymax); ymin = MIN(lstack[i].p1.y, ymin);
        xmax = MAX(lstack[i].p2.x, xmax); xmin = MIN(lstack[i].p2.x, xmin);
        ymax = MAX(lstack[i].p2.y, ymax); ymin = MIN(lstack[i].p2.y, ymin);
    }

    width = ymax - ymin; heigh = xmax - xmin;

    for (i=0;i<lstack_top;i++)
    {
        x = lstack[i].p1.x;
        y = lstack[i].p1.y;
        if (!cur_set_flag || (cur_x!=x || cur_y!=y))
            emit("%f %f moveto\n", x - xmin, y - ymin);
        x = cur_x = lstack[i].p2.x;
        y = cur_y = lstack[i].p2.y;
        emit("%f %f lineto\n", cur_x - xmin, cur_y - ymin);
        cur_set_flag = 1;
    }

    emit("closepath\n");
    emit("stroke\n");
    emit("} def\n");
    emit("20 20 translate\n");
    emit("4 4 scale\n");

    for (k=0;k<25;k++)
    {
        xx = 0;
        for (j=0;;j++)
        {
            if (xx + width + 40 > 150) break;
            if (k == 0 && j == 0) 
                emit("0 0 translate %\n", xmin); else

                    emit("%f 0 translate\n", xmax-xmin + 1);

            xx += xmax-xmin + 1;
            emit("0.1 setlinewidth\n");
            emit("0.7 setgray\n");
            emit("%f %f moveto\n", pg->p[0].x - xmin, pg->p[0].y - ymin);
            for (i=1;i<UHELNIK;i++)	emit("%f %f lineto\n", pg->p[i].x - xmin, pg->p[i].y - ymin);
            emit("closepath\n");
            emit("fill\n");
            emit("stroke\n");
            emit("main_graph\n");
            pg = pg->next;
            if (pg==NULL)
            {
                emit("showpage\n");
                break;
            }
        }
        if (pg == NULL)
            break;
        emit("-%f %f translate\n", xx, ymax - ymin + 1);
    }
    emit("showpage\n");
    fclose(output);
    //	output = stderr;
    printf("width:%f  heigh:%f\n", width, heigh);
}

int main(int argc, char **argv)
{

    if (argc!=2)
    {
        printf("Parameter is number 3-20!\n");
        exit(1);
    }
    n_uhelnik = atoi(argv[1]);
    if (n_uhelnik > 20 || n_uhelnik < 3)
    {
        printf("Correct interval is 3-20!\n");
        exit(1);
    }

    init();
    SDL_Init(SDL_INIT_TIMER);
    if ((screen = SDL_SetVideoMode(1024, 768, 16, SDL_SWSURFACE | SDL_DOUBLEBUF))==NULL)
        exit(1);

    redraw();
    main_loop();	
    return 0;
}







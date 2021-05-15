Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472E138169F
	for <lists+io-uring@lfdr.de>; Sat, 15 May 2021 09:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhEOHp5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 May 2021 03:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbhEOHpy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 May 2021 03:45:54 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD474C061756;
        Sat, 15 May 2021 00:44:41 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id m11so1581914lfg.3;
        Sat, 15 May 2021 00:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4QCKj60qV5x8KToRaAPJwYe6tYNh5QN/Ln0sgg6f6yc=;
        b=F+sUv6FBBjx+vA8SidIulIn/JBQKqJ/pXLorx8kKT6eCQcMHIung2b/eupPWRWTaBT
         pxrBB1Vr6TYq9n91SNZiuT9pZxQDsOupc/4ZhTrwBcjDCPgbVxlo6j5SWw1umvaQTHKJ
         fbVQewG7KJb6NibCAikLO8sT1dW+nq/QAeLFPCkbHP4JahWK8Kf7Ttb3SeEnfaB3Smsz
         ALJL/DFzbwhlW8AFOfUnJdb7ItG6jEeGGXGgd9bUP39Y76PiVjzftIeA+Zu7GJjIzA+i
         js+BQDRUnQswanruJJ9XryAK8KkTpY3AaYtsAxz3zm9Q/mvqR/ISyXF0bA+Dy8fHugQb
         mGJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4QCKj60qV5x8KToRaAPJwYe6tYNh5QN/Ln0sgg6f6yc=;
        b=RTfd9/eWRvTyQmfnB1E9bhES7OFE8Iwomt+koyhNeusRNQXQYOan6ZNgjSrf9QYOv3
         vgEhuaFJm9pLCg7y/6cM8yo/7f/VGYRpFRBLekNcLBe9VLaXro93A5I7Ll0OH6nrE60o
         m1jHrjG7DS7vrJwFOY4m31ql4gAEi8PSBxxwzB1wWZtZ1pceuU8rACtCkCI4Me1om2Ft
         zsdjjvbQyXxoZD/SDsUMr2pSCZ8Fntz0zlyEW/gHBS8+YE2iTkL3PI1MInZ6j0AxIp1R
         zwLn7ODEaZJ/VTKfnA2MZd/vJf71BfpZCGOc78fQzde1rvOwvt4KPonM1KGbqGk0PHaa
         Z1wg==
X-Gm-Message-State: AOAM530ZL4Yw7E9wFlPb2+zR2BwOx4rer/V3AwXVk8Ys3qLd74JoCBfb
        qp0+2yQt2L/RN18OGNxQztkp6c30XbL6lNR6DYk=
X-Google-Smtp-Source: ABdhPJx8Imx006IgslKX/ItJBqmSveth5pUWpAopL0rSMEkd5lLhhs9ixwNG6eEBZKxtVJjUFXtHPX3Jn/Qk3ENam7E=
X-Received: by 2002:a05:6512:234c:: with SMTP id p12mr35046929lfu.6.1621064680182;
 Sat, 15 May 2021 00:44:40 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000000c97e505bdd1d60e@google.com> <cfa0f9b8-91ec-4772-a6c2-c5206f32373fn@googlegroups.com>
 <53a22ab4-7a2d-4ebd-802d-9d1b4ce4e087n@googlegroups.com> <CAGyP=7fpNBhbmczjDq-vpzbSDyqwCw2jS7xQo4XO=bxwsy2ddQ@mail.gmail.com>
 <d5844c03-fa61-d256-be0d-b40446414299@gmail.com> <CAGyP=7e-3QtS-Z3KoAyFAbvm4y+9=725WR_+PyADYDi8HYxMXA@mail.gmail.com>
 <af911546-72e4-5525-6b31-1ad1f555799e@gmail.com> <CAGyP=7eoSfh7z638PnP5UF4xVKcrG1jB_qmFo6uPZ7iWfu_2sQ@mail.gmail.com>
 <4127fb94-89d2-4e36-8835-514118cb1cce@gmail.com> <7c993a83-392f-39d0-7a6f-c78f121f5ae2@gmail.com>
In-Reply-To: <7c993a83-392f-39d0-7a6f-c78f121f5ae2@gmail.com>
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Sat, 15 May 2021 13:14:27 +0530
Message-ID: <CAGyP=7cr1S462e+ZNQY_s3ygmHbYpRo6OLrx7RCLKX8h6F=OnQ@mail.gmail.com>
Subject: Re: INFO: task hung in io_uring_cancel_sqpoll
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+11bf59db879676f59e52@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, May 14, 2021 at 3:01 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 5/13/21 10:28 PM, Pavel Begunkov wrote:
> > On 5/10/21 5:47 AM, Palash Oswal wrote:
> >> On Mon, May 3, 2021 at 4:15 PM Pavel Begunkov <asml.silence@gmail.com>
> >> wrote:
> >>
> >>> On 5/3/21 5:41 AM, Palash Oswal wrote:
> >>>> On Mon, May 3, 2021 at 3:42 AM Pavel Begunkov <asml.silence@gmail.com>
> >>> wrote:
> >>>>> The test might be very useful. Would you send a patch to
> >>>>> liburing? Or mind the repro being taken as a test?
> >>>>
> >>>> Pavel,
> >>>>
> >>>> I'm working on a PR for liburing with this test. Do you know how I can
> >>>
> >>> Perfect, thanks
> >>>
> >>>> address this behavior?
> >>>
> >>> As the hang is sqpoll cancellations, it's most probably
> >>> fixed in 5.13 + again awaits to be taken for stable.
> >>>
> >>> Don't know about segfaults, but it was so for long, and
> >>> syz reproducers are ofthen faults for me, and exit with 0
> >>> in the end. So, I wouldn't worry about it.
> >>>
> >>>
> >> Hey Pavel,
> >> The bug actually fails to reproduce on 5.12 when the fork() call is made by
> >> the runtests.sh script. This causes the program to end correctly, and the
> >> hang does not occur. I verified this on 5.12 where the bug isn't patched.
> >> Just running the `sqpoll-cancel-hang` triggers the bug; whereas running it
> >> after being forked from runtests.sh does not trigger the bug.
> >
> > I see. fyi, it's always good to wait for 5 minutes, because some useful
> > logs are not generated immediately but do timeout based hang detection.
> >
> > I'd think that may be due CLONE_IO and how to whom it binds workers,
> > but can you try first:
> >
> > 1) timeout -s INT -k $TIMEOUT $TIMEOUT ./sqpoll-cancel-hang
>
> edit:
>
> timeout -s INT -k 60 60 ./sqpoll-cancel-hang
>
> And privileged, root/sudo
>
> >
> > 2) remove timeout from <liburing>/tests/Makefile and run
> > "./runtests.sh sqpoll-cancel-hang" again looking for faults?
> >
> > diff --git a/test/runtests.sh b/test/runtests.sh
> > index e8f4ae5..2b51dca 100755
> > --- a/test/runtests.sh
> > +++ b/test/runtests.sh
> > @@ -91,7 +91,8 @@ run_test()
> >       fi
> >
> >       # Run the test
> > -     timeout -s INT -k $TIMEOUT $TIMEOUT ./$test_name $dev
> > +     # timeout -s INT -k $TIMEOUT $TIMEOUT ./$test_name $dev
> > +     ./$test_name $dev
> >       local status=$?
> >
> >       # Check test status

root@syzkaller:~/liburing/test# timeout -s INT -k 60 60 ./sqpoll-cancel-hang
[   19.381358] sqpoll-cancel-h[300]: segfault at 0 ip 0000556f7fa325e3
sp 00007ffee497d980 error 6 in s]
[   19.387323] Code: 89 d8 8d 34 90 8b 45 04 ba 03 00 00 00 c1 e0 04
03 45 64 39 c6 48 0f 42 f0 45 31 c6
root@syzkaller:~/liburing/test# [  243.511620] INFO: task
iou-sqp-300:301 blocked for more than 120 sec.
[  243.514146]       Not tainted 5.12.0 #142
[  243.515301] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  243.517629] task:iou-sqp-300     state:D stack:    0 pid:  301
ppid:     1 flags:0x00004004
[  243.520155] Call Trace:
[  243.520956]  __schedule+0xb1d/0x1130
[  243.522102]  ? __sched_text_start+0x8/0x8
[  243.523195]  ? io_wq_worker_sleeping+0x145/0x500
[  243.524588]  schedule+0x131/0x1c0
[  243.525892]  io_uring_cancel_sqpoll+0x288/0x350
[  243.527610]  ? io_sq_thread_unpark+0xd0/0xd0
[  243.529084]  ? mutex_lock+0xbb/0x130
[  243.530327]  ? init_wait_entry+0xe0/0xe0
[  243.532805]  ? wait_for_completion_killable_timeout+0x20/0x20
[  243.535411]  io_sq_thread+0x174c/0x18c0
[  243.536520]  ? io_rsrc_put_work+0x380/0x380
[  243.537904]  ? init_wait_entry+0xe0/0xe0
[  243.538935]  ? _raw_spin_lock_irq+0xa5/0x180
[  243.540203]  ? _raw_spin_lock_irqsave+0x190/0x190
[  243.542398]  ? calculate_sigpending+0x6b/0xa0
[  243.543868]  ? io_rsrc_put_work+0x380/0x380
[  243.545377]  ret_from_fork+0x22/0x30
^C
root@syzkaller:~/liburing/test# ps
  PID TTY          TIME CMD
  269 ttyS0    00:00:00 login
  294 ttyS0    00:00:00 bash
  300 ttyS0    00:00:00 sqpoll-cancel-h
  305 ttyS0    00:00:00 ps


After reboot, and the runtests.sh diff applied ( to remove timeout )
root@syzkaller:~/liburing/test# ./runtests.sh sqpoll-cancel-hang
Running test sqp[   45.332140] Running test sqpoll-cancel-hang:
oll-cancel-hang:
[   45.352524] sqpoll-cancel-h[314]: segfault at 0 ip 000056025bd085e3
sp 00007fffb08e20b0 error 6 in s]
[   45.356601] Code: 89 d8 8d 34 90 8b 45 04 ba 03 00 00 00 c1 e0 04
03 45 64 39 c6 48 0f 42 f0 45 31 c6
[  243.019384] INFO: task iou-sqp-314:315 blocked for more than 120 seconds.
[  243.021483]       Not tainted 5.12.0 #142
[  243.022633] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  243.024651] task:iou-sqp-314     state:D stack:    0 pid:  315
ppid:   313 flags:0x00004004
[  243.026822] Call Trace:
[  243.027478]  __schedule+0xb1d/0x1130
[  243.028382]  ? __sched_text_start+0x8/0x8
[  243.029536]  ? io_wq_worker_sleeping+0x145/0x500
[  243.030932]  schedule+0x131/0x1c0
[  243.031920]  io_uring_cancel_sqpoll+0x288/0x350
[  243.033393]  ? io_sq_thread_unpark+0xd0/0xd0
[  243.034713]  ? mutex_lock+0xbb/0x130
[  243.035775]  ? init_wait_entry+0xe0/0xe0
[  243.037036]  ? wait_for_completion_killable_timeout+0x20/0x20
[  243.039492]  io_sq_thread+0x174c/0x18c0
[  243.040894]  ? io_rsrc_put_work+0x380/0x380
[  243.042463]  ? init_wait_entry+0xe0/0xe0
[  243.043990]  ? _raw_spin_lock_irq+0xa5/0x180
[  243.045581]  ? _raw_spin_lock_irqsave+0x190/0x190
[  243.047545]  ? calculate_sigpending+0x6b/0xa0
[  243.049262]  ? io_rsrc_put_work+0x380/0x380
[  243.050861]  ret_from_fork+0x22/0x30
^C
root@syzkaller:~/liburing/test# ps
  PID TTY          TIME CMD
  285 ttyS0    00:00:00 login
  300 ttyS0    00:00:00 bash
  314 ttyS0    00:00:00 sqpoll-cancel-h
  318 ttyS0    00:00:00 ps


runtests.sh without any changes
root@syzkaller:~/liburing/test# ./runtests.sh sqpoll-cancel-hang
[   49.634886] Running test sqpoll-cancel-hang:
Running test sqpoll-cancel-hang:
[   49.658365] sqpoll-cancel-h[302]: segfault at 0 ip 000055a76e99c5e3
sp 00007ffdc255d1a0 error 6 in s]
[   49.661703] Code: 89 d8 8d 34 90 8b 45 04 ba 03 00 00 00 c1 e0 04
03 45 64 39 c6 48 0f 42 f0 45 31 c6
Test sqpoll-cancel-hang timed out (may not be a failure)
All tests passed
root@syzkaller:~/liburing/test# ps
  PID TTY          TIME CMD
  269 ttyS0    00:00:00 login
  287 ttyS0    00:00:00 bash
  302 ttyS0    00:00:00 sqpoll-cancel-h
  309 ttyS0    00:00:00 ps
root@syzkaller:~/liburing/test# [  243.324831] INFO: task
iou-sqp-302:303 blocked for more than 120 sec.
[  243.328320]       Not tainted 5.12.0 #142
[  243.330361] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  243.333930] task:iou-sqp-302     state:D stack:    0 pid:  303
ppid:     1 flags:0x00004004
[  243.337758] Call Trace:
[  243.338926]  __schedule+0xb1d/0x1130
[  243.340801]  ? __sched_text_start+0x8/0x8
[  243.342690]  ? io_wq_worker_sleeping+0x145/0x500
[  243.344903]  schedule+0x131/0x1c0
[  243.346626]  io_uring_cancel_sqpoll+0x288/0x350
[  243.348762]  ? io_sq_thread_unpark+0xd0/0xd0
[  243.351036]  ? mutex_lock+0xbb/0x130
[  243.352737]  ? init_wait_entry+0xe0/0xe0
[  243.354673]  ? wait_for_completion_killable_timeout+0x20/0x20
[  243.356989]  io_sq_thread+0x174c/0x18c0
[  243.358559]  ? io_rsrc_put_work+0x380/0x380
[  243.359981]  ? init_wait_entry+0xe0/0xe0
[  243.361185]  ? _raw_spin_lock_irq+0x110/0x180
[  243.362958]  ? _raw_spin_lock_irqsave+0x190/0x190
[  243.364260]  ? calculate_sigpending+0x6b/0xa0
[  243.365763]  ? io_rsrc_put_work+0x380/0x380
[  243.367041]  ret_from_fork+0x22/0x30




> >
> >
> >>
> >> The segfaults are benign, but notice the "All tests passed" in the previous
> >> mail. It should not have passed, as the run was on 5.12. Therefore I wanted
> >> to ask your input on how to address this odd behaviour, where the
> >> involvement of runtests.sh actually mitigated the bug.
> >>
> >>
> >>
> >>>> root@syzkaller:~/liburing/test# ./runtests.sh sqpoll-cancel-hang
> >>>> Running test sqp[   15.310997] Running test sqpoll-cancel-hang:
> >>>> oll-cancel-hang:
> >>>> [   15.333348] sqpoll-cancel-h[305]: segfault at 0 ip 000055ad00e265e3
> >>> sp]
> >>>> [   15.334940] Code: 89 d8 8d 34 90 8b 45 04 ba 03 00 00 00 c1 e0 04 03
> >>> 46
> >>>> All tests passed
> >>>>
> >>>> root@syzkaller:~/liburing/test# ./sqpoll-cancel-hang
> >>>> [   13.572639] sqpoll-cancel-h[298]: segfault at 0 ip 00005634c4a455e3
> >>> sp]
> >>>> [   13.576506] Code: 89 d8 8d 34 90 8b 45 04 ba 03 00 00 00 c1 e0 04 03
> >>> 46
> >>>> [   23.350459] random: crng init done
> >>>> [   23.352837] random: 7 urandom warning(s) missed due to ratelimiting
> >>>> [  243.090865] INFO: task iou-sqp-298:299 blocked for more than 120
> >>> secon.
> >>>> [  243.095187]       Not tainted 5.12.0 #142
> >>>> [  243.099800] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>> disable.
> >>>> [  243.105928] task:iou-sqp-298     state:D stack:    0 pid:  299 ppid:
> >>> 4
> >>>> [  243.111044] Call Trace:
> >>>> [  243.112855]  __schedule+0xb1d/0x1130
> >>>> [  243.115549]  ? __sched_text_start+0x8/0x8
> >>>> [  243.118328]  ? io_wq_worker_sleeping+0x145/0x500
> >>>> [  243.121790]  schedule+0x131/0x1c0
> >>>> [  243.123698]  io_uring_cancel_sqpoll+0x288/0x350
> >>>> [  243.125977]  ? io_sq_thread_unpark+0xd0/0xd0
> >>>> [  243.128966]  ? mutex_lock+0xbb/0x130
> >>>> [  243.132572]  ? init_wait_entry+0xe0/0xe0
> >>>> [  243.135429]  ? wait_for_completion_killable_timeout+0x20/0x20
> >>>> [  243.138303]  io_sq_thread+0x174c/0x18c0
> >>>> [  243.140162]  ? io_rsrc_put_work+0x380/0x380
> >>>> [  243.141613]  ? init_wait_entry+0xe0/0xe0
> >>>> [  243.143686]  ? _raw_spin_lock_irq+0xa5/0x180
> >>>> [  243.145619]  ? _raw_spin_lock_irqsave+0x190/0x190
> >>>> [  243.147671]  ? calculate_sigpending+0x6b/0xa0
> >>>> [  243.149036]  ? io_rsrc_put_work+0x380/0x380
> >>>> [  243.150694]  ret_from_fork+0x22/0x30
> >>>>
> >>>> Palash
> >>>>
> >>>
> >>> --
> >>> Pavel Begunkov
> >>>
> >>
> >
>
> --
> Pavel Begunkov

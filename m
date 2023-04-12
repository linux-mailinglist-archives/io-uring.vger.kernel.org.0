Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067686DFED2
	for <lists+io-uring@lfdr.de>; Wed, 12 Apr 2023 21:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjDLTi5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Apr 2023 15:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDLTi4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Apr 2023 15:38:56 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344C85B88
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 12:38:50 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v27so2797168wra.13
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 12:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681328328; x=1683920328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NRlbmkyliocD4GVskA3DiuWAI0XqHkxknca6K2fMDG4=;
        b=FC2vTgsi9KiwnczS8qZgpD8wY6OQ+06BDgoa7t7xpkCZM/HC429cIDEUKahRi2mMf/
         4Qh8eJVYZHfzO8hP+xCJJU0rWyVidHZHj/bH2pWo5aBkJbYRDLxAt+KzZwFPTjzEwYSb
         xsapDfYXuyIJhXR7zTNKYl7mqea84Dn8e+UavFC+lMJnRcUi+S1Wk5ZU8qfkhCjQ1JQe
         mfbBJXp5j4eb9rPokccJ/8d8BZuCOIopFV3lk/Nuup59qVbQ9f648VEgYwflhVj2Ckjp
         pxFa/xDrFAEYp8uCnKTT3AaEqJivKn7ZC034aB2KsRDRD8K5KtDPPb2rfDMMJ5DRyr/q
         HWzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681328328; x=1683920328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NRlbmkyliocD4GVskA3DiuWAI0XqHkxknca6K2fMDG4=;
        b=XQ6PNlN1gmQsa4/D+0ZkPoAtR2a9HILmxhJmNINQFnKUol8iGZuwPTsOph5tf+Kp6C
         LiVjowluMtgvMYLtc4DcT5pZRPzzQqbhaSp9iww3a5MeqNSXQhrwOHhfLxlF/1f+J5w0
         KAZG/vRCyvF7k4LnrUBEHIPJUBe3GwztBHAy+vcOVLAC+PF/FcIfs92e8UcFzmOwMKzh
         5UnG2HH4JsE+YAoiWB7Ebg186nJJpeOcuMLJUD7hcjpt9phhSS0hk68l/h8ZkUrvimWK
         ryWSuB6B4ViT+jD0zQlzxJQVKOtBwYUxSv+xenl0bM2Itzi47JD6sXkk79fW+sEyJipw
         cfGA==
X-Gm-Message-State: AAQBX9d4XLdOYvoRYLTTB1TJbtEY821WduY8it0x82Pgjl6e8KT0SXBO
        t5ZnXQ2uvT22TS6x6dCy1eLrR6n6CfDpeC0cVZGL2Q==
X-Google-Smtp-Source: AKy350Y6um8j2mq8ZfvK9rdWdZVO8MQmfdYv8bZM5tLwmtuRUsJLAmgUe+ZEF/x32ZnRhSF+d4BA4Bww9OWEHiTsoJ0=
X-Received: by 2002:adf:f802:0:b0:2f4:8cbe:77b2 with SMTP id
 s2-20020adff802000000b002f48cbe77b2mr662966wrp.14.1681328328437; Wed, 12 Apr
 2023 12:38:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230308073201.3102738-1-avagin@google.com> <20230308073201.3102738-3-avagin@google.com>
 <ZDDddj50KZInqa84@chenyu5-mobl1> <CANaxB-y0eDExPB0v=LRPyoz1e-3tJ2VuuCmYJ3qkAERpnbz+aQ@mail.gmail.com>
 <CALCETrVBVTDxUdKtPuaD35KVfUWihxNbTY2Ks65oGbzf8Yfm=w@mail.gmail.com>
In-Reply-To: <CALCETrVBVTDxUdKtPuaD35KVfUWihxNbTY2Ks65oGbzf8Yfm=w@mail.gmail.com>
From:   Andrei Vagin <avagin@google.com>
Date:   Wed, 12 Apr 2023 12:38:37 -0700
Message-ID: <CAEWA0a5_eUxx9KgqdYDQALJ8cJ+_hN-xFS2VftAODOeyO-CC_g@mail.gmail.com>
Subject: Re: [PATCH 2/6] sched: add WF_CURRENT_CPU and externise ttwu
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Andrei Vagin <avagin@gmail.com>, Chen Yu <yu.c.chen@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Peter Oskolkov <posk@google.com>,
        Tycho Andersen <tycho@tycho.pizza>,
        Will Drewry <wad@chromium.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 10, 2023 at 10:27=E2=80=AFAM Andy Lutomirski <luto@kernel.org> =
wrote:
>
> On Sun, Apr 9, 2023 at 9:56=E2=80=AFPM Andrei Vagin <avagin@gmail.com> wr=
ote:
> >
> > On Fri, Apr 7, 2023 at 8:20=E2=80=AFPM Chen Yu <yu.c.chen@intel.com> wr=
ote:
> > >
> > > On 2023-03-07 at 23:31:57 -0800, Andrei Vagin wrote:
> > > > From: Peter Oskolkov <posk@google.com>
> > > >
> > > > Add WF_CURRENT_CPU wake flag that advices the scheduler to
> > > > move the wakee to the current CPU. This is useful for fast on-CPU
> > > > context switching use cases.
> > > >
> > > > In addition, make ttwu external rather than static so that
> > > > the flag could be passed to it from outside of sched/core.c.
> > > >
> > > > Signed-off-by: Peter Oskolkov <posk@google.com>
> > > > Signed-off-by: Andrei Vagin <avagin@google.com>
> > > > --- a/kernel/sched/fair.c
> > > > +++ b/kernel/sched/fair.c
> > > > @@ -7569,6 +7569,10 @@ select_task_rq_fair(struct task_struct *p, i=
nt prev_cpu, int wake_flags)
> > > >       if (wake_flags & WF_TTWU) {
> > > >               record_wakee(p);
> > > >
> > > > +             if ((wake_flags & WF_CURRENT_CPU) &&
> > > > +                 cpumask_test_cpu(cpu, p->cpus_ptr))
> > > > +                     return cpu;
> > > > +
> > > I tried to reuse WF_CURRENT_CPU to mitigate the cross-cpu wakeup, how=
ever there
> > > are regressions when running some workloads, and these workloads want=
 to be
> > > spreaded on idle CPUs whenever possible.
> > > The reason for the regression is that, above change chooses current C=
PU no matter
> > > what the load/utilization of this CPU is. So task are stacked on 1 CP=
U and hurts
> > > throughput/latency. And I believe this issue would be more severe on =
system with
> > > smaller number of CPU within 1 LLC(when compared to Intel platforms),=
 such as AMD,
> > > Arm64.
> >
> > WF_CURRENT_CPU works only in certain conditions. Maybe you saw my
> > attempt to change how WF_SYNC works:
> >
> > https://www.spinics.net/lists/kernel/msg4567650.html
> >
> > Then we've found that this idea doesn't work well, and it is a reason
> > why we have the separate WF_CURRENT_CPU flag.
> >
> > >
> > > I know WF_CURRENT_CPU benefits seccomp, and can we make this change m=
ore genefic
> > > to benefit other workloads, by making the condition to trigger WF_CUR=
RENT_CPU stricter?
> > > Say, only current CPU has 1 runnable task, and treat current CPU as t=
he last resort by
> > > checking if the wakee's previous CPU is not idle. In this way, we can=
 enable WF_CURRENT_CPU flag
> > > dynamically when some condition is met(a short task for example).
> >
> > We discussed all of these here and here:
> >
> > https://www.spinics.net/lists/kernel/msg4657545.html
> >
> > https://lore.kernel.org/lkml/CANaxB-yWkKzhhPMGXCQbtjntJbqZ40FL2qtM2hk7L=
LWE-ZpbAg@mail.gmail.com/
> >
> > I like your idea about short-duration tasks, but I think it is a
> > separate task and it has to be done in a separate patch set. Here, I
> > solve the problem of optimizing synchronous switches when one task wake=
s
> > up another one and falls asleep immediately after that. Waking up the
> > target task on the current CPU looks reasonable for a few reasons in
> > this case. First, waking up a task on the current CPU is cheaper than o=
n
> > another one and it is much cheaper than waking on an idle cpu.  Second,
> > when tasks want to do synchronous switches, they often exchange some
> > data, so memory caches can play on us.
>
> I've contemplated this on occasion for quite a few years, and I think
> that part of our issue is that the userspace ABI part doesn't exist
> widely.  In particular, most of the common ways that user tasks talk
> to each other don't have a single system call that can do the
> send-a-message-and-start-waiting part all at once.  For example, if
> task A is running and it wants to wake task B and then sleep:
>
> UNIX sockets (or other sockets): A calls send() or write() or
> sendmsg() then recv() or read() or recvmsg() or epoll_wait() or poll()
> or select().
>
> Pipes: Same as sockets except no send/recv.
>
> Shared memory: no wakeup or sleep mechanism at all. UMONITOR doesn't coun=
t :)

futex-es? Here was an attempt to add FUTEX_SWAP a few years ago:
https://www.spinics.net/lists/kernel/msg3871065.html

It hasn't been merged to the upstream repo in favor of umcg:
https://lore.kernel.org/linux-mm/20211122211327.5931-1-posk@google.com/

Both these features solve similar problems, where FUTEX_SWAP is simple
and straightforward
but umcg is wider and more complicated.

>
> I think io_uring can kind of do a write-and-wait operation, but I
> doubt it's wired up for this purpose.

I think it may be a good candidate where this logic can be placed.

>
>
> seccomp seems like it should be able to do this straightforwardly on
> the transition from the seccomp-sandboxed task to the monitor, but the
> reverse direction is tricky.
>
>
>
> Anyway, short of a massive API project, I don't see a totally
> brilliant solution.  But maybe we could take a baby step toward a
> general solution by deferring all the hard work of a wakeup a bit so
> that, as we grow syscalls and other mechanisms that do wake-and-wait,
> we can optimize them automatically.  For example, we could perhaps add
> a pending wakeup to task_struct, kind of like:
>
> struct task_struct *task_to_wake;
>
> and then, the next time we sleep or return to usermode, we handle the
> wakeup.  And if we're going to sleep, we can do it as an optimized
> synchronous wakeup.  And if we try to wake a task while task_to_wake
> is set, we just wake everything normally.

I am not sure that I understand when it has to be set and when it will
be in effect. For example, we want to do the pair write&read syscall. It
means write sets task_to_wake, then the current task is resumed without wak=
ing
the target task and only after that task_to_wake will be in effect.
In other words,
it has to be in effect after the next but one returns to user-mode.

Thanks,
Andrei

>
> (There are refcounting issues here, and maybe this wants to be percpu,
> not per task.)
>
> I think it would be really nifty if Linux could somewhat reliably do
> this style of synchronous con
>
> PeterZ, is this at all sensible or am I nuts?
>
> --Andy

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7E524A006
	for <lists+io-uring@lfdr.de>; Wed, 19 Aug 2020 15:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgHSNd3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Aug 2020 09:33:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39322 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728477AbgHSNdY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Aug 2020 09:33:24 -0400
Date:   Wed, 19 Aug 2020 15:33:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597844001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j26P1hmMzhjjiQWadqBC++aWmgqGQBIpscfoookHO7c=;
        b=hf88cTNZ1SOB3MaTW01c8emUFzoah0YdeFMG/8cV/LEODUBIeo3Qd+vjeBXJGfjyk/Mnx0
        YnVyb1ms3B8gG1aEGlYvyntvLsIk1LZGaWrx4Ibf8fX/LpyF9PkqHe/gdR8DAMjB9QaVu9
        kUk7ZSVf8757vmPHfipJZ81z9gVQ4ZDNIBKfGP9RH8SfrWT/MtozhHHzgc+VEWIVDdmg6r
        Df4Zx4EgWutcPWWZFay/EIeP8K9hd9Lll6HLcNMsSyzcol6maG4F/zCkfGnykgdCOkf8Ze
        NdqpPtyzyfgjKpMKZ9Di5lCesYXOCK83mPtTnxDOAuvr3erbpBjZHRuROhqKEQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597844001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j26P1hmMzhjjiQWadqBC++aWmgqGQBIpscfoookHO7c=;
        b=ZZUocbmvcwrAvDla1gFf7SNVdsVvxiO2q9egKN5TAEkys7fV0dn7MTVc4cWNIcmkYA86h3
        nqQo3FccIQ6Cf8Aw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     peterz@infradead.org
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] sched: Invoke io_wq_worker_sleeping() with enabled
 preemption
Message-ID: <20200819133320.bxwb3ikjswyhmsyg@linutronix.de>
References: <20200819123758.6v45rj2gvojddsnn@linutronix.de>
 <20200819131507.GC2674@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200819131507.GC2674@hirez.programming.kicks-ass.net>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020-08-19 15:15:07 [+0200], peterz@infradead.org wrote:

> > -	if (tsk->flags & (PF_WQ_WORKER | PF_IO_WORKER)) {
> > +	if (tsk->flags & PF_WQ_WORKER) {
> >  		preempt_disable();
> > -		if (tsk->flags & PF_WQ_WORKER)
> > -			wq_worker_sleeping(tsk);
> > -		else
> > -			io_wq_worker_sleeping(tsk);
> > +		wq_worker_sleeping(tsk);
> >  		preempt_enable_no_resched();
> >  	}
> > =20
> >  	if (tsk_is_pi_blocked(tsk))
> >  		return;
> > =20
> > +	if (tsk->flags & PF_IO_WORKER)
> > +		io_wq_worker_sleeping(tsk);
> > +
>=20
> Urgh, so this adds a branch in what is normally considered a fairly hot
> path.
>=20
> I'm thinking that the raw_spinlock_t option would permit leaving that
> single:
>=20
> 	if (tsk->flags & (PF_WQ_WORKER | PF_IO_WORKER))
>=20
> branch intact?

The compiler generates code to test for both flags at once. If none of
both possible flags are set then there is one branch (get out and bring
me to tst_is_pi=E2=80=A6).
And yes, with raw_spinlock_t we could keep that one branch.

If you want to optimize further, we could move PF_IO_WORKER to an lower
bit. x86 can test for both via
(gcc-10)
|         testl   $536870944, 44(%rbp)    #, _11->flags
|         jne     .L1635  #,

(clang-9)
|         testl   $536870944, 44(%rbx)    # imm =3D 0x20000020
|         je      .LBB112_6


but ARM can't and does
|          ldr     r1, [r5, #16]   @ tsk_3->flags, tsk_3->flags
|         mov     r2, #32 @ tmp157,
|         movt    r2, 8192        @ tmp157,
|         tst     r2, r1  @ tmp157, tsk_3->flags
|         beq     .L998           @,

same ARM64
|         ldr     w0, [x20, 60]   //, _11->flags
|         and     w0, w0, 1073741792      // tmp117, _11->flags,
|         and     w0, w0, -536870849      // tmp117, tmp117,
|         cbnz    w0, .L453       // tmp117,

using 0x10 for PF_IO_WORKER instead will turn this into:
|         ldr     w0, [x20, 60]   //, _11->flags
|         tst     w0, 48  // _11->flags,
|         bne     .L453           //,

ARM:
|         ldr     r2, [r5, #16]   @ tsk_3->flags, tsk_3->flags
|         tst     r2, #48 @ tsk_3->flags,
|         beq     .L998           @,

Sebastian

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0BC25FADC
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 14:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgIGM7X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 08:59:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbgIGM64 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 7 Sep 2020 08:58:56 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FB5821481;
        Mon,  7 Sep 2020 12:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599483529;
        bh=tTNxmJ4jcJ4aD21IqESGwfJw58XiGcHeIj4d4qcIdiM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NWfY8J1ZIMU4ZX4aYaDKe0hXhzsGwABV0tkTyeYkRZVLhpbrVwc54OY8ic1Vb/xux
         TIzDw1ejYj2Ue1gCnLpqxFGbmXblUZIchelxQkgS7DZvwqvL23Rc1PPICpuKhqcMzQ
         hVqiAEtb5AylhxDhE+f9OQYbOyXM35EHUzp3KS24=
Date:   Mon, 7 Sep 2020 13:58:44 +0100
From:   Will Deacon <will@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     peterz@infradead.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 1/2] sched: Bring the PF_IO_WORKER and PF_WQ_WORKER bits
 closer together
Message-ID: <20200907125843.GC12237@willie-the-truck>
References: <20200819142134.GD2674@hirez.programming.kicks-ass.net>
 <20200819195505.y3fxk72sotnrkczi@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819195505.y3fxk72sotnrkczi@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 19, 2020 at 09:55:05PM +0200, Sebastian Andrzej Siewior wrote:
> The bits PF_IO_WORKER and PF_WQ_WORKER are tested together in
> sched_submit_work() which is considered to be a hot path.
> If the two bits cross the 8 or 16 bit boundary then most architecture
> require multiple load instructions in order to create the constant
> value. Also, such a value can not be encoded within the compare opcode.
> 
> By moving the bit definition within the same block, the compiler can
> create/use one immediate value.
> 
> For some reason gcc-10 on ARM64 requires both bits to be next to each
> other in order to issue "tst reg, val; bne label". Otherwise the result
> is "mov reg1, val; tst reg, reg1; bne label".
> 
> Move PF_VCPU out of the way so that PF_IO_WORKER can be next to
> PF_WQ_WORKER.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> 
> Could someone from the ARM64 camp please verify if this a gcc "bug" or
> opcode/arch limitation? With PF_IO_WORKER as 1 (without the PF_VCPU
> swap) I get for ARM:
> 
> | tst     r2, #33 @ task_flags,
> | beq     .L998           @,
> 
> however ARM64 does here:
> | mov     w0, 33  // tmp117,
> | tst     w19, w0 // task_flags, tmp117
> | bne     .L453           //,
> 
> the extra mov operation. Moving PF_IO_WORKER next to PF_WQ_WORKER as
> this patch gives me:
> | tst     w19, 48 // task_flags,
> | bne     .L453           //,

Moving an immediate into a register really shouldn't be a performance
issue, so I don't think this is a problem. However, the reason GCC does
this is because of the slightly weird way in which immediates are encoded,
meaning that '33' can't be packed into the 'tst' alias. You can try to
decipher the "DecodeBitMasks()" pseudocode in the Arm ARM if you're
interested.

Will

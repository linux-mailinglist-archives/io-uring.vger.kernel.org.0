Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013473E111F
	for <lists+io-uring@lfdr.de>; Thu,  5 Aug 2021 11:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239909AbhHEJSL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Aug 2021 05:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239959AbhHEJSA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Aug 2021 05:18:00 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620ACC06179B;
        Thu,  5 Aug 2021 02:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EjjjkwFYj96sLMR/uhVYLccaIfMeHIDI08Rxwy4jL2w=; b=hK1EDkkWxzKxclE42S1W79/o8j
        PBm3ooShAlyy7i/pYJEMqlvY367wSVNFyCfsqyPOkKoNL9fbL6jlqSIk6j1oU8Cd31/sNbmZ5Bupr
        xfu93SXSh+LkheCfwCohWoOwY3tXFlxBiuvpbFIPIx2EL1MnumfN6Ig3USTilLBEXlR2ZJ2fNpWgE
        ukJ0fIMcMsu6YaIAI+bDmmaSkayD0af6pw7xvT8RAxOOQ47tGwpCeDSkkaK1PjI9ni6pL8WhmwDdI
        aG3Cn0bNrdjPVY7Xls8kQuYJFnpUWRJpSisHcWCHYvuBqBZeba2wYaE556L4Mmatf7HkiuerNbhH/
        wzCeRQgw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBZVW-005yqr-RM; Thu, 05 Aug 2021 09:17:43 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id BB1C19862B0; Thu,  5 Aug 2021 11:17:41 +0200 (CEST)
Date:   Thu, 5 Aug 2021 11:17:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH] io-wq: remove GFP_ATOMIC allocation off schedule out path
Message-ID: <20210805091741.GB22037@worktop.programming.kicks-ass.net>
References: <a673a130-e0e4-5aa8-4165-f35d1262fc6a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a673a130-e0e4-5aa8-4165-f35d1262fc6a@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 04, 2021 at 08:43:43AM -0600, Jens Axboe wrote:
> Daniel reports that the v5.14-rc4-rt4 kernel throws a BUG when running
> stress-ng:
> 
> | [   90.202543] BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:35
> | [   90.202549] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 2047, name: iou-wrk-2041
> | [   90.202555] CPU: 5 PID: 2047 Comm: iou-wrk-2041 Tainted: G        W         5.14.0-rc4-rt4+ #89
> | [   90.202559] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
> | [   90.202561] Call Trace:
> | [   90.202577]  dump_stack_lvl+0x34/0x44
> | [   90.202584]  ___might_sleep.cold+0x87/0x94
> | [   90.202588]  rt_spin_lock+0x19/0x70
> | [   90.202593]  ___slab_alloc+0xcb/0x7d0
> | [   90.202598]  ? newidle_balance.constprop.0+0xf5/0x3b0
> | [   90.202603]  ? dequeue_entity+0xc3/0x290
> | [   90.202605]  ? io_wqe_dec_running.isra.0+0x98/0xe0
> | [   90.202610]  ? pick_next_task_fair+0xb9/0x330
> | [   90.202612]  ? __schedule+0x670/0x1410
> | [   90.202615]  ? io_wqe_dec_running.isra.0+0x98/0xe0
> | [   90.202618]  kmem_cache_alloc_trace+0x79/0x1f0
> | [   90.202621]  io_wqe_dec_running.isra.0+0x98/0xe0
> | [   90.202625]  io_wq_worker_sleeping+0x37/0x50
> | [   90.202628]  schedule+0x30/0xd0
> | [   90.202630]  schedule_timeout+0x8f/0x1a0
> | [   90.202634]  ? __bpf_trace_tick_stop+0x10/0x10
> | [   90.202637]  io_wqe_worker+0xfd/0x320
> | [   90.202641]  ? finish_task_switch.isra.0+0xd3/0x290
> | [   90.202644]  ? io_worker_handle_work+0x670/0x670
> | [   90.202646]  ? io_worker_handle_work+0x670/0x670
> | [   90.202649]  ret_from_fork+0x22/0x30
> 
> which is due to the RT kernel not liking a GFP_ATOMIC allocation inside
> a raw spinlock. Besides that not working on RT, doing any kind of
> allocation from inside schedule() is kind of nasty and should be avoided
> if at all possible.
> 
> This particular path happens when an io-wq worker goes to sleep, and we
> need a new worker to handle pending work. We currently allocate a small
> data item to hold the information we need to create a new worker, but we
> can instead include this data in the io_worker struct itself and just
> protect it with a single bit lock. We only really need one per worker
> anyway, as we will have run pending work between to sleep cycles.
> 
> https://lore.kernel.org/lkml/20210804082418.fbibprcwtzyt5qax@beryllium.lan/
> Reported-by: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Thanks!

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

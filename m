Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE37C3E0440
	for <lists+io-uring@lfdr.de>; Wed,  4 Aug 2021 17:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239108AbhHDPdh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Aug 2021 11:33:37 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:38570 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239104AbhHDPdh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Aug 2021 11:33:37 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CA23E2017C;
        Wed,  4 Aug 2021 15:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628091203; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t1tJavoxRL8YKK5Go9RcDtEqTyvx22b83zd2R6Gnu8U=;
        b=RmB8ayOZl1h/pidOXlM38S5lgpD8pX2M2IFmCTahhR9dOvPqLhm9MIYV08kJvZwqNvcBhw
        KvIKB5tndoiZrAtMLMDHNjrJ9ndpnYjkt8pyrdyf/3/Zl3sjDIBdXXEff+ttgGHBRbJO52
        cuJP9CNnJ51PtobHdx26soQToLgr/Dw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628091203;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t1tJavoxRL8YKK5Go9RcDtEqTyvx22b83zd2R6Gnu8U=;
        b=4SEKEmtyQMijIYzn4DTfJFEh+sIfCgkx/aGXqyKx/gaZtuN4Izbw/6cOzfjqES2eDpe771
        yxM1YD9gbC6TILBQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id BC18113BD7;
        Wed,  4 Aug 2021 15:33:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id bBiLLUOzCmH8YgAAGKfGzw
        (envelope-from <dwagner@suse.de>); Wed, 04 Aug 2021 15:33:23 +0000
Date:   Wed, 4 Aug 2021 17:33:23 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] io-wq: remove GFP_ATOMIC allocation off schedule out path
Message-ID: <20210804153323.anggq6oto6x7g2rs@beryllium.lan>
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

I applied this patch on top of v5.14-rc4-rt4 and with it all looks
good.

Tested-by: Daniel Wagner <dwagner@suse.de>


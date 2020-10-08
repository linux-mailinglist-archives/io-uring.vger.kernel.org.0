Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DCD287EAB
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 00:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbgJHW16 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 18:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgJHW16 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 18:27:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FE5C0613D2;
        Thu,  8 Oct 2020 15:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=U/7r+/9BJ4fPt8BAVC3zOJpEKGbvgaJlAM2hprXcBkM=; b=hgaPCVtt0ThBQwRQPhd8Ugcc10
        w7tiEy0XHwitBEkQXKEW58eJ5TGvRja0VdTn5lZY58NxBeQcPxMjKhGgWmak+HNOPDxTcoVKZuQLT
        CB2yo5HzGjMwsXBGOwhwr0JRy+atBeINv4FNL909f7+8m9KPT99loB5WSHzJsZql7tlFyVWXb4Z56
        hFGPXRznYc68XF0Cppf0RS/Kp9yRb9xDd3AOkzT2XheEkur1B7VCLyOmq22sQov4b4UMp1VuGcWAn
        XlbykWkxLXPVxq8y/SG9nAn9gMlrHzalnorCv+xT4t/v8djHifKDO/dvxd2zdFwXyvViBuZepS6Ux
        Kcgl0Kqw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQeOA-0001g1-2i; Thu, 08 Oct 2020 22:27:54 +0000
Date:   Thu, 8 Oct 2020 23:27:53 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     syzbot <syzbot+cdcbdc0bd42e559b52b9@syzkaller.appspotmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Subject: Re: inconsistent lock state in xa_destroy
Message-ID: <20201008222753.GP20115@casper.infradead.org>
References: <00000000000045ac4605b12a1720@google.com>
 <000000000000c35f0805b12f5099@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000c35f0805b12f5099@google.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


If I understand the lockdep report here, this actually isn't an XArray
issue, although I do think there is one.

On Thu, Oct 08, 2020 at 02:14:20PM -0700, syzbot wrote:
> ================================
> WARNING: inconsistent lock state
> 5.9.0-rc8-next-20201008-syzkaller #0 Not tainted
> --------------------------------
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> swapper/0/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
> ffff888025f65018 (&xa->xa_lock#7){+.?.}-{2:2}, at: xa_destroy+0xaa/0x350 lib/xarray.c:2205
> {SOFTIRQ-ON-W} state was registered at:
>   lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5419
>   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>   spin_lock include/linux/spinlock.h:354 [inline]
>   io_uring_add_task_file fs/io_uring.c:8607 [inline]

You're using the XArray in a non-interrupt-disabling mode.

>  _raw_spin_lock_irqsave+0x94/0xd0 kernel/locking/spinlock.c:159
>  xa_destroy+0xaa/0x350 lib/xarray.c:2205
>  __io_uring_free+0x60/0xc0 fs/io_uring.c:7693
>  io_uring_free include/linux/io_uring.h:40 [inline]
>  __put_task_struct+0xff/0x3f0 kernel/fork.c:732
>  put_task_struct include/linux/sched/task.h:111 [inline]
>  delayed_put_task_struct+0x1f6/0x340 kernel/exit.c:172
>  rcu_do_batch kernel/rcu/tree.c:2484 [inline]

But you're calling xa_destroy() from in-interrupt context.
So (as far as lockdep is concerned), no matter what I do in
xa_destroy(), this potential deadlock is there.  You'd need to be
using xa_init_flags(XA_FLAGS_LOCK_IRQ) if you actually needed to call
xa_destroy() here.

Fortunately, it seems you don't need to call xa_destroy() at all, so
that problem is solved, but the patch I have here wouldn't help.

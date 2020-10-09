Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F28D288858
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 14:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388405AbgJIMMP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 08:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388404AbgJIMMP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 08:12:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3226DC0613D2;
        Fri,  9 Oct 2020 05:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CZNlQmq+OKPCGz68APmjQ2kr+Z7Wp7wJQZLN1idsatI=; b=hFpuEDKO7XXAc32ekbXZ8RUkTk
        ZQO0xsvmQvANDYbFb4d7rGV80xyiVqdEYBxa6k8jj7T0mKXIlObgC7qpk8DoViCdbUlq+eihw1Utw
        QhSPM0wGWC5vFXhmv96O51tDNg9Q/Hh/LvEmkjvOlRJhLx3P5B4lHuFkXDERPOcioFpZYx7gqZuv5
        lm2jP3qm0a3cQgKdYDPDKly5/RjTSraObxe9kjFATKtz3Q8d6TcZdY+/9C/uMeroZ5Y6N9ecMdTnq
        C54IerXjBZ3mRpm/abZDJVOlKblnwprFiP0WvuhNpo3DRFt/YTbL3+r/CmDXh5epC4sovaZ4dysMb
        e9Kr2RHA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQrFr-0005rQ-87; Fri, 09 Oct 2020 12:12:11 +0000
Date:   Fri, 9 Oct 2020 13:12:11 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     syzbot <syzbot+77efce558b2b9e6b6405@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Subject: Re: KASAN: use-after-free Read in __io_uring_files_cancel
Message-ID: <20201009121211.GQ20115@casper.infradead.org>
References: <0000000000001a684d05b1385e71@google.com>
 <3a98a77a-a507-954a-f2ec-e38af18c168f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a98a77a-a507-954a-f2ec-e38af18c168f@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 09, 2020 at 02:10:49PM +0300, Pavel Begunkov wrote:
> >  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
> >  xas_next_entry include/linux/xarray.h:1630 [inline]
> >  __io_uring_files_cancel+0x417/0x440 fs/io_uring.c:8681
> >  io_uring_files_cancel include/linux/io_uring.h:35 [inline]
> >  exit_files+0xe4/0x170 fs/file.c:456
> >  do_exit+0xae9/0x2930 kernel/exit.c:801
> >  do_group_exit+0x125/0x310 kernel/exit.c:903
> >  get_signal+0x428/0x1f00 kernel/signal.c:2757
> >  arch_do_signal+0x82/0x2470 arch/x86/kernel/signal.c:811
> >  exit_to_user_mode_loop kernel/entry/common.c:161 [inline]
> >  exit_to_user_mode_prepare+0x194/0x1f0 kernel/entry/common.c:192
> >  syscall_exit_to_user_mode+0x7a/0x2c0 kernel/entry/common.c:267
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> It seems this fails on "node->shift" in xas_next_entry(), that would
> mean that the node itself was freed while we're iterating on it.
> 
> __io_uring_files_cancel() iterates with xas_next_entry() and creates
> XA_STATE once by hand, but it also removes entries in the loop with
> io_uring_del_task_file() -> xas_store(&xas, NULL); without updating
> the iterating XA_STATE. Could it be the problem? See a diff below

No, the problem is that the lock is dropped after calling
xas_next_entry(), and at any point after calling xas_next_entry(),
the node that it's pointing to can be freed.

I don't think there's any benefit to using the advanced API here.
Since io_uring_cancel_task_requests() can sleep, we have to drop the lock
for each iteration around the loop, and so we have to walk from the top of the tree each time.  So we may as well make this easy to read:

@@ -8665,28 +8665,19 @@ static void io_uring_attempt_task_drop(struct file *file, bool exiting)
 void __io_uring_files_cancel(struct files_struct *files)
 {
        struct io_uring_task *tctx = current->io_uring;
-       XA_STATE(xas, &tctx->xa, 0);
+       struct file *file;
+       unsigned long index;
 
        /* make sure overflow events are dropped */
        tctx->in_idle = true;
 
-       do {
-               struct io_ring_ctx *ctx;
-               struct file *file;
-
-               xas_lock(&xas);
-               file = xas_next_entry(&xas, ULONG_MAX);
-               xas_unlock(&xas);
-
-               if (!file)
-                       break;
-
-               ctx = file->private_data;
+       xa_for_each(&tctx->xa, index, file) {
+               struct io_ring_ctx *ctx = file->private_data;
 
                io_uring_cancel_task_requests(ctx, files);
                if (files)
                        io_uring_del_task_file(file);
-       } while (1);
+       }
 }
 
 static inline bool io_uring_task_idle(struct io_uring_task *tctx)

I'll send a proper patch in a few minutes -- I'd like to neaten up a
few of the other XArray uses.

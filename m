Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F8A28C3DC
	for <lists+io-uring@lfdr.de>; Mon, 12 Oct 2020 23:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgJLVN5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Oct 2020 17:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgJLVN5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Oct 2020 17:13:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF52C0613D0
        for <io-uring@vger.kernel.org>; Mon, 12 Oct 2020 14:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=y6CFHxlZSmzUsdz8ZSZoegPyaS8ARC1QPEciKKwx850=; b=BoUGpg5NxkzFnB8EysRie7ZF02
        7ikLnhlrwVWbKhfPWVN+XsNXCE5wDq8uBCXCR7pkpmJA7iBPWBQ6Ipi1DAg3QUd1ROtmoLkr2Bwpl
        1DbTP6pRP2DJ+4ozvjdJn79IuZcG0GDU51K8jmwoj4CTxx65Qsv3DsBr3PBFsM+k6KB6BcRltYkCI
        bijLLfl+Z3oBPugcr2XGbgccb+ToDqvSGv796QPAUy69QISQDwSGCjkl9BDBKQIw/+vDnvmuRVlBx
        SwOrMYmTMRVqJjTj5vZmHmJgRAFjFc2+1BvluScFiIZmSFl/yDubrd+be0OCRf21QlTwmwdC59XhO
        kp6WyNpQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kS58l-00062r-8J; Mon, 12 Oct 2020 21:13:55 +0000
Date:   Mon, 12 Oct 2020 22:13:55 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     io-uring@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>
Subject: Loophole in async page I/O
Message-ID: <20201012211355.GC20115@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This one's pretty unlikely, but there's a case in buffered reads where
an IOCB_WAITQ read can end up sleeping.

generic_file_buffered_read():
                page = find_get_page(mapping, index);
...
                if (!PageUptodate(page)) {
...
                        if (iocb->ki_flags & IOCB_WAITQ) {
...
                                error = wait_on_page_locked_async(page,
                                                                iocb->ki_waitq);
wait_on_page_locked_async():
        if (!PageLocked(page))
                return 0;
(back to generic_file_buffered_read):
                        if (!mapping->a_ops->is_partially_uptodate(page,
                                                        offset, iter->count))
                                goto page_not_up_to_date_locked;

page_not_up_to_date_locked:
                if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT)) {
                        unlock_page(page);
                        put_page(page);
                        goto would_block;
                }
...
                error = mapping->a_ops->readpage(filp, page);
(will unlock page on I/O completion)
                if (!PageUptodate(page)) {
                        error = lock_page_killable(page);

So if we have IOCB_WAITQ set but IOCB_NOWAIT clear, we'll call ->readpage()
and wait for the I/O to complete.  I can't quite figure out if this is
intentional -- I think not; if I understand the semantics right, we
should be returning -EIOCBQUEUED and punting to an I/O thread to
kick off the I/O and wait.

I think the right fix is to return -EIOCBQUEUED from
wait_on_page_locked_async() if the page isn't locked.  ie this:

@@ -1258,7 +1258,7 @@ static int wait_on_page_locked_async(struct page *page,
                                     struct wait_page_queue *wait)
 {
        if (!PageLocked(page))
-               return 0;
+               return -EIOCBQUEUED;
        return __wait_on_page_locked_async(compound_head(page), wait, false);
 }
 
But as I said, I'm not sure what the semantics are supposed to be.

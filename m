Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB519331333
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 17:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhCHQRM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 11:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhCHQRG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 11:17:06 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF00C06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 08:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2MGxpkDrt9h16PSzJhYjiY/Uk0ZiPSSEYGtRh7Qr8vg=; b=Cvl9LrGqoUiM/B6SDGO+sdtl28
        NtVwbNyRQnJ24Eyy6yEXXTlsBlLJvuq/72awWdqGRt7sZIcryRfq6BOI3KF7tNQDL8eBOQR71Az4N
        wahP+bIl74Jv4dfZI9G+tS5xHwqD9Dp9Gj+tsv6b/uFiza9YrhbtRnadcUkqQylhZBi4Cg8w2rpct
        2IobgH8z2cMWRYM9yCJyVUgn76Sv4hKY0HyrbTTxFLb4WgNRKXYRqk2SEkQMMHl2SJqSzZvHYkIYG
        VXdB+q+LoZsU4fR5dfMyFskKKXEKr6/UHFWOaJ3KGXlM4uaCfZwzdHNrZagNqpuuC770wylW4+nDP
        KdIJDpfA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lJIYs-00Fgc8-9c; Mon, 08 Mar 2021 16:16:51 +0000
Date:   Mon, 8 Mar 2021 16:16:50 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        yangerkun <yangerkun@huawei.com>,
        Stefan Metzmacher <metze@samba.org>, yi.zhang@huawei.com
Subject: Re: [PATCH 5.12] io_uring: Convert personality_idr to XArray
Message-ID: <20210308161650.GC3479805@casper.infradead.org>
References: <7ccff36e1375f2b0ebf73d957f037b43becc0dde.1615212806.git.asml.silence@gmail.com>
 <803bad80-093a-5fbf-7677-754c9afad530@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <803bad80-093a-5fbf-7677-754c9afad530@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 08, 2021 at 02:22:10PM +0000, Pavel Begunkov wrote:
> On 08/03/2021 14:16, Pavel Begunkov wrote:
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > 
> > You can't call idr_remove() from within a idr_for_each() callback,
> > but you can call xa_erase() from an xa_for_each() loop, so switch the
> > entire personality_idr from the IDR to the XArray.  This manifests as a
> > use-after-free as idr_for_each() attempts to walk the rest of the node
> > after removing the last entry from it.
> 
> yangerkun, can you test it and similarly take care of buffer idr?

FWIW, I did a fairly naive conversion of the personalities IDR, because
efficiency really isn't the most important (you don't have a lot of
personalities, generally).  the buffer_idr seems like it might see a
lot more action than the personalities, so you might want to consider
something like:

+++ b/fs/io_uring.c
@@ -8543,7 +8543,8 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
        if (ctx->rings)
                __io_cqring_overflow_flush(ctx, true, NULL, NULL);
        xa_for_each(&ctx->personalities, index, creds)
-               io_unregister_personality(ctx, index);
+               put_cred(creds);
+       xa_destroy(&ctx->personalities);
        mutex_unlock(&ctx->uring_lock);
 
        io_kill_timeouts(ctx, NULL, NULL);

to be more efficient.


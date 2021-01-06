Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43312EBFAF
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 15:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbhAFOjT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 09:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbhAFOjT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 09:39:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BF1C06134C;
        Wed,  6 Jan 2021 06:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m/HQWT2Xvq5anmyI9u+6yrRl6k0+uhR5qXn/brHR0Xw=; b=Eo4OgGRRqrrvTcpvkjLaWgA+bM
        njbUJbZ/MbensOE4wUp9o7JfqfUQQDnYPRcwY7cQnCxA/lDxEn7wqsy8Cp7y12YVwwVildXkWuq4v
        t/WHfxuENygTnvvnxXkaVmRnuqt0Ua/NR9g+VVkiBqnW2gb7uqmSIWqHtXISC/AkCuL/bJTjPU1Mk
        fzY9TKBVKLEbYKndfw4kV+3USUvZjEaz8BngIc96SHcuVYA6eoGn81cHoWRWmPYt0iRy9Apa94YJd
        pM+wc9cYXvZfa6t3FGKabx935RXtxWLuue8aCtBvP5RDyB2xZjN1NLZoQMCvN2atE/+xKS9csfRwV
        oAJfymyg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kx9sv-002Q2X-9d; Wed, 06 Jan 2021 14:35:12 +0000
Date:   Wed, 6 Jan 2021 14:34:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] io_uring: fix an IS_ERR() vs NULL check
Message-ID: <20210106143401.GD175893@casper.infradead.org>
References: <X/WCTxIRT4SHLemV@mwanda>
 <c88d8500-681d-7503-77ca-ae10d230a11b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c88d8500-681d-7503-77ca-ae10d230a11b@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jan 06, 2021 at 12:32:45PM +0000, Pavel Begunkov wrote:
> On 06/01/2021 09:26, Dan Carpenter wrote:
> > The alloc_fixed_file_ref_node() function never returns NULL, it returns
> > error pointers on error.
> > 
> > Fixes: 1ffc54220c44 ("io_uring: fix io_sqe_files_unregister() hangs")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> thanks Dan,
> 
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
> Cc: stable@vger.kernel.org # 5.6+

But the only error that alloc_fixed_file_ref_node() can return is
-ENOMEM, so I think it'd be better to actually return NULL for errors.
It makes the other callers simpler:

+++ b/fs/io_uring.c
@@ -7684,12 +7684,12 @@ static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
 
        ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
        if (!ref_node)
-               return ERR_PTR(-ENOMEM);
+               return NULL;
 
        if (percpu_ref_init(&ref_node->refs, io_file_data_ref_zero,
                            0, GFP_KERNEL)) {
                kfree(ref_node);
-               return ERR_PTR(-ENOMEM);
+               return NULL;
        }
        INIT_LIST_HEAD(&ref_node->node);
        INIT_LIST_HEAD(&ref_node->file_list);
@@ -7783,9 +7783,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, 
void __user *arg,
        }
 
        ref_node = alloc_fixed_file_ref_node(ctx);
-       if (IS_ERR(ref_node)) {
+       if (!ref_node) {
                io_sqe_files_unregister(ctx);
-               return PTR_ERR(ref_node);
+               return -ENOMEM;
        }
 
        io_sqe_files_set_node(file_data, ref_node);
@@ -7885,8 +7885,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
                return -EINVAL;
 
        ref_node = alloc_fixed_file_ref_node(ctx);
-       if (IS_ERR(ref_node))
-               return PTR_ERR(ref_node);
+       if (!ref_node)
+               return -ENOMEM;
 
        done = 0;
        fds = u64_to_user_ptr(up->fds);

(not even compile tested)

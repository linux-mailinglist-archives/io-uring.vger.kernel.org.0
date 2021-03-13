Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA26E33A0C8
	for <lists+io-uring@lfdr.de>; Sat, 13 Mar 2021 20:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbhCMTye (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Mar 2021 14:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbhCMTyW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Mar 2021 14:54:22 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA02C061574
        for <io-uring@vger.kernel.org>; Sat, 13 Mar 2021 11:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AUXE/Q/+WudJkMahklOXBICYfzx6EJAprHSC1BzlggQ=; b=kmROYbYfEgP66aNYSF6kabnW9H
        oNW1/CYSi33T/7o9WyOGGWE2PnmxB0LCPeIa7OePJKRoQJ41CeWR96sNh2rGybCCPYL2Nkv8lsWAD
        uTRfCaCwsGNYIPiUftFV+7EiYMzeMuCmbiqwzl4wvjBBjX4o9ZYSed8hfzOHr/n3FCcpozNPg662o
        qSUz6zrGHCVNrE856+c8DFYzD6IDQr8rJve9AZLrXiy67RpBNpA44BqdzwQ1DE8H7Km/74xRQfY+U
        jyPMNN56ZLgRoR0i9GQmOf1yX83IEW5CSfrD/A9zWQFt3aV0dgmHdCOLbuTKUYnAOh6qV7A+Kk/DJ
        8Ez/t41g==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lLAKo-00EhuI-5t; Sat, 13 Mar 2021 19:54:04 +0000
Date:   Sat, 13 Mar 2021 19:54:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     yangerkun <yangerkun@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
        yi.zhang@huawei.com
Subject: Re: [PATCH 5.12] io_uring: Convert personality_idr to XArray
Message-ID: <20210313195402.GK2577561@casper.infradead.org>
References: <7ccff36e1375f2b0ebf73d957f037b43becc0dde.1615212806.git.asml.silence@gmail.com>
 <803bad80-093a-5fbf-7677-754c9afad530@gmail.com>
 <8b553635-b3d9-cb36-34f0-83777bec94ab@huawei.com>
 <81464ae1-cac4-df4c-cd0e-1d518461d4c3@huawei.com>
 <7a905382-8598-f351-8a5b-423d7246200a@kernel.dk>
 <e6c9ed79-827b-7a45-3ad8-9ba5a21d5780@kernel.dk>
 <d98051ba-0c85-7013-dd93-a76efc9196ad@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d98051ba-0c85-7013-dd93-a76efc9196ad@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Mar 13, 2021 at 12:30:14PM -0700, Jens Axboe wrote:
> @@ -2851,7 +2852,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
>  			list_del(&kbuf->list);
>  		} else {
>  			kbuf = head;
> -			idr_remove(&req->ctx->io_buffer_idr, bgid);
> +			__xa_erase(&req->ctx->io_buffer, bgid);

Umm ... __xa_erase()?  Did you enable all the lockdep infrastructure?
This should have tripped some of the debugging code because I don't think
you're holding the xa_lock.

> @@ -3993,21 +3994,20 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
>  
>  	lockdep_assert_held(&ctx->uring_lock);
>  
> -	list = head = idr_find(&ctx->io_buffer_idr, p->bgid);
> +	list = head = xa_load(&ctx->io_buffer, p->bgid);
>  
>  	ret = io_add_buffers(p, &head);
> -	if (ret < 0)
> -		goto out;
> +	if (ret >= 0 && !list) {
> +		u32 id = -1U;
>  
> -	if (!list) {
> -		ret = idr_alloc(&ctx->io_buffer_idr, head, p->bgid, p->bgid + 1,
> -					GFP_KERNEL);
> -		if (ret < 0) {
> +		ret = __xa_alloc_cyclic(&ctx->io_buffer, &id, head,
> +					XA_LIMIT(0, USHRT_MAX),
> +					&ctx->io_buffer_next, GFP_KERNEL);

I don't understand why this works.  The equivalent transformation here
would have been:

		ret = xa_insert(&ctx->io_buffers, p->bgid, head, GFP_KERNEL);

with various options to handle it differently.

>  static void io_destroy_buffers(struct io_ring_ctx *ctx)
>  {
> -	idr_for_each(&ctx->io_buffer_idr, __io_destroy_buffers, ctx);
> -	idr_destroy(&ctx->io_buffer_idr);
> +	struct io_buffer *buf;
> +	unsigned long index;
> +
> +	xa_for_each(&ctx->io_buffer, index, buf)
> +		__io_remove_buffers(ctx, buf, index, -1U);
> +	xa_destroy(&ctx->io_buffer);

Honestly, I'd do BUG_ON(!xa_empty(&ctx->io_buffers)) if anything.  If that
loop didn't empty the array, something is terribly wrong and we should
know about it somehow instead of making the memory leak harder to find.


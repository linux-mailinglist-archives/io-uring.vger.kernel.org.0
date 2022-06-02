Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0A453B90B
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 14:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbiFBMii (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 08:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbiFBMih (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 08:38:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25131D0FC;
        Thu,  2 Jun 2022 05:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=s5OuhuXYOeyE5UF5dmXoLvghk44rQZnLPb2h1/XcCPg=; b=CLdDZpnXhsBm2c9XM9B5FToU/M
        LyNk4DIYVj1phFej49cZkTUIX9N0diwt44Ff6V3AAWidHxpiqQOieGX/Yo6Zz60us5Gm931KmiSnQ
        xkOiHmp8M23pbLA5AjuvsK0k5SeUjKvY66a1zkj2BtuV9XT/3N6o97VijmXSCUw00txBRgKdzN2Zq
        fdQJuAkoUTA4KZXnhfn9pdiiN0SmNKPjY9p1rRLfyAMGRbHtU7otoJwe9lt9jMhs91gJRaD6RTF3T
        F16+aSgbAIAjhd9MEQ6hjBeC1a/wN2fwO3WvSegDJebimWMhSNwN9Pite5GoHG1gEEx8SxS0sTFAK
        88Qw4STA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nwk5q-0078sD-1n; Thu, 02 Jun 2022 12:38:26 +0000
Date:   Thu, 2 Jun 2022 13:38:26 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk
Subject: Re: [PATCH v7 06/15] iomap: Return error code from iomap_write_iter()
Message-ID: <YpivQhqhZxwvdDUm@casper.infradead.org>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-7-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601210141.3773402-7-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 01, 2022 at 02:01:32PM -0700, Stefan Roesch wrote:
> Change the signature of iomap_write_iter() to return an error code. In
> case we cannot allocate a page in iomap_write_begin(), we will not retry
> the memory alloction in iomap_write_begin().

loff_t can already represent an error code.  And it's already used like
that.

> @@ -829,7 +830,8 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>  		length -= status;
>  	} while (iov_iter_count(i) && length);
>  
> -	return written ? written : status;
> +	*processed = written ? written : error;
> +	return error;

I think the change you really want is:

	if (status == -EAGAIN)
		return -EAGAIN;
	if (written)
		return written;
	return status;

> @@ -843,12 +845,15 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
>  		.flags		= IOMAP_WRITE,
>  	};
>  	int ret;
> +	int error = 0;
>  
>  	if (iocb->ki_flags & IOCB_NOWAIT)
>  		iter.flags |= IOMAP_NOWAIT;
>  
> -	while ((ret = iomap_iter(&iter, ops)) > 0)
> -		iter.processed = iomap_write_iter(&iter, i);
> +	while ((ret = iomap_iter(&iter, ops)) > 0) {
> +		if (error != -EAGAIN)
> +			error = iomap_write_iter(&iter, i, &iter.processed);
> +	}

You don't need to change any of this.  Look at how iomap_iter_advance()
works.


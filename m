Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CAA3F3628
	for <lists+io-uring@lfdr.de>; Fri, 20 Aug 2021 23:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhHTVuq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 17:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhHTVuq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 17:50:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153F7C061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 14:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=v7xCXjno1vgns+obednv+F2OStXuLGtAEZP8DA9NzOA=; b=KNkDHv9/SVgXFo/OCWR4wLcYUD
        8FHoe49ZCabzlF8CxPY5kmY/eUlHxmGqB5hd5l0YQ0XkzNlRNGLvNX1vsBj5Zho2E8SmtEOUBi0/a
        8axvB+oenxQ//kDvQ8IG0mBiwk1OJNgogrNyLPwGHDmd1dZzwlCDbAB9Cz5Apn1NPIDmL2T3/Myoz
        n5sw8pIqkD6tHb9WkGmsiCcOyLfNArPOkgnPP62G+UjZdAQ5ryc9FZMjSwy4JpUWXqPGJrlZtww2f
        JX3TBeS3Uwr+JWd/wV5O9SZyIOM404Ha28FxPegjqbh7EW7yCNv0L1Tw01nAZklUAlnzFFwATOgXx
        pAJCsROw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mHCOY-0071pc-C0; Fri, 20 Aug 2021 21:49:50 +0000
Date:   Fri, 20 Aug 2021 22:49:46 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring: fix xa_alloc_cycle() error return value check
Message-ID: <YSAjeuZ0zqJOkwUm@casper.infradead.org>
References: <5ba45180-8f41-5a1f-dd23-a1fc0c52fd37@kernel.dk>
 <fc798a75-0b80-7fd7-9059-2072896038af@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc798a75-0b80-7fd7-9059-2072896038af@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 20, 2021 at 03:01:20PM -0600, Jens Axboe wrote:
>  	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
>  			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
> -	if (!ret)
> -		return id;
> -	put_cred(creds);
> -	return ret;
> +	if (ret < 0) {
> +		put_cred(creds);
> +		return ret;
> +	}
> +	return id;
>  }

Wouldn't you rather:

	if (ret >= 0)
		return id;
	put_cred(creds);
	return ret;

?

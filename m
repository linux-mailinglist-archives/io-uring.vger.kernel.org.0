Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C382D3D9A
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 09:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgLIIh2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Dec 2020 03:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgLIIh1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Dec 2020 03:37:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C86C0613CF;
        Wed,  9 Dec 2020 00:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fFBLWtE5GQnPWQPUq4v3Pa18IITk1EO6tqIDlf9HX0w=; b=CsJe9uSK26NLRe+nRPEL3mhs2+
        z28woCi5opznzDTPcWEr7i0AqWMdYRqa1Qvzy01m97ObPPoNIsiaYf1nR4naGlbWBm1s9epTv+/WA
        RtOwwjnmIrPGYOT6YR8dPamcK99HpV8C6qcKO8r+o4Y0pFdHX4LwOJ9vFfnHCkNetZrNjMsVjhKva
        I7nx0suHRNwg6HwDVf4494nunTJY4cBJrqcI1vXEvpSZYR0Am2E/bzZk9qc9FnwU8lCCiSrSMhqep
        daIobpGLtlCawki12rclHntB4QBuJp49v/pR5577U7iZ9PfqiZWXwX6AXrFUIp3wRpfNeAbNU8d2X
        /N1dOzig==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmuxp-00063F-Cw; Wed, 09 Dec 2020 08:36:45 +0000
Date:   Wed, 9 Dec 2020 08:36:45 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iov: introduce ITER_BVEC_FLAG_FIXED
Message-ID: <20201209083645.GB21968@infradead.org>
References: <cover.1607477897.git.asml.silence@gmail.com>
 <de27dbca08f8005a303e5efd81612c9a5cdcf196.1607477897.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de27dbca08f8005a303e5efd81612c9a5cdcf196.1607477897.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ok, seems like the patches made it to the lists, while oyu only
send the cover letter to my address which is very strange.

> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index 72d88566694e..af626eb970cf 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -18,6 +18,8 @@ struct kvec {
>  };
>  
>  enum iter_type {
> +	ITER_BVEC_FLAG_FIXED = 2,
> +
>  	/* iter types */
>  	ITER_IOVEC = 4,
>  	ITER_KVEC = 8,

This is making the iter type even more of a mess than it already is.
I think we at least need placeholders for 0/1 here and an explicit
flags namespace, preferably after the types.

Then again I'd much prefer if we didn't even add the flag or at best
just add it for a short-term transition and move everyone over to the
new scheme.  Otherwise the amount of different interfaces and supporting
code keeps exploding.

> @@ -29,8 +31,9 @@ enum iter_type {
>  struct iov_iter {
>  	/*
>  	 * Bit 0 is the read/write bit, set if we're writing.
> -	 * Bit 1 is the BVEC_FLAG_NO_REF bit, set if type is a bvec and
> -	 * the caller isn't expecting to drop a page reference when done.
> +	 * Bit 1 is the BVEC_FLAG_FIXED bit, set if type is a bvec and the
> +	 * caller ensures that page references and memory baking bvec won't
> +	 * go away until callees finish with them.
>  	 */
>  	unsigned int type;

I think the comment needs to move to the enum.

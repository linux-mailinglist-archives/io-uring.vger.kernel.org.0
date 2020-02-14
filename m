Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE3D815F7BA
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 21:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbgBNUbt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 15:31:49 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51665 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729682AbgBNUbs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 15:31:48 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 9050021448;
        Fri, 14 Feb 2020 15:31:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 14 Feb 2020 15:31:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=e6L9J4IhXZLktMyTc9lHpXYItoo
        8MV92MGTtjoOBrkA=; b=FzpYvIoaXgz9BPdKZFEyJMhfdRePGM9CuUpiNSoSWCv
        G3Ueno9lLm4Hre7jgvS7rglYAoOjkaq/h4jXere7X7Fz/V5TZEtr0Yv9w99cT4Cb
        HvpNK/fUzTpT3KAcFEfcvdsXioz8qQD7Hr9pxkWiYSARDCp5A8PpVP+RDR+WyxM0
        9HZ6AVS/Wz3v/Ff87IWbtFWcrlfZguXEuQ/3eEXrHHbgju3mD5vq74fuwN48wEFB
        GkVXemRJ+8xfb+HfqdfaJ2H52NjD0HgOXcEmnKAdDWz5T9B61HuiWp1dz//ZZiYy
        2dkyqoUde83N3+S2p3o+QHn/i00imjYlXmKlPhXh3hQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=e6L9J4
        IhXZLktMyTc9lHpXYItoo8MV92MGTtjoOBrkA=; b=zjoR77GYY+YpIo9iW0wfOw
        31ex15wrT4nus3nBP13NpfsdbTBaR8egUO1fxGCzQazU0elkFBdKCwMYl5yWdQUy
        7Iq3gb56r0EW90E5f4oMVS2+bJfNjYCDTGlPVib6Grgh63s9SYIS7B9kjAceVjrj
        Z58LISrdS0nzYU+tK6O4DkUW13yYBfe7xUgEqWlOfPxX0wDtqcdckqxP8ULYf15t
        WbduDnWyPof8owDTSTC/RXqBWWpDLwXQYvOLgihNKJYfoovCc0iwXfy0M3uGB6eh
        dp74SJiVm6Dwwd3krNy8UfhOkSoJqVGrhldvQg+78mDqx3us26u/xiPBZav2qLgQ
        ==
X-ME-Sender: <xms:sgNHXg9kqXOtyWe8GAQVutCzVhjnnevcbNvMTu3K98Ug1fcEBDmbcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjedtgddugedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucfkphepie
    ejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:sgNHXleLSNWSW6yE_-t7RRKXT51V0vfdIhdry91wvqbRS58Y9SrIhg>
    <xmx:sgNHXhkZYDouYpg-md5LFfmWT2x6cH9BcVzJZrLkdhQ4ZWLMP2QunA>
    <xmx:sgNHXmkxk1UwMCTCUOGreq2S_90KD-AXvQfYsZyQRNFt2AMQmUZmQg>
    <xmx:swNHXtdlUjlyN0WLp-YcGmJp-mwrH3YmyvmmFWEpbeB5YIL03LiH4Q>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id C3DD13060BE4;
        Fri, 14 Feb 2020 15:31:46 -0500 (EST)
Date:   Fri, 14 Feb 2020 12:31:40 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: Buffered IO async context overhead
Message-ID: <20200214203140.ksvbm5no654gy7yi@alap3.anarazel.de>
References: <20200214195030.cbnr6msktdl3tqhn@alap3.anarazel.de>
 <c91551b2-9694-78cb-2aa6-bc8cccc474c3@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c91551b2-9694-78cb-2aa6-bc8cccc474c3@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-02-14 13:13:35 -0700, Jens Axboe wrote:
> On 2/14/20 12:50 PM, Andres Freund wrote:
> > which I think is pretty clear evidence we're hitting fairly significant
> > contention on the queue lock.
> > 
> > 
> > I am hitting this in postgres originally, not fio, but I thought it's
> > easier to reproduce this way.  There's obviously benefit to doing things
> > in the background - but it requires odd logic around deciding when to
> > use io_uring, and when not.
> > 
> > To be clear, none of this happens with DIO, but I don't forsee switching
> > to DIO for all IO by default ever (too high demands on accurate
> > configuration).
> 
> Can you try with this added?
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 76cbf474c184..207daf83f209 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -620,6 +620,7 @@ static const struct io_op_def io_op_defs[] = {
>  		.async_ctx		= 1,
>  		.needs_mm		= 1,
>  		.needs_file		= 1,
> +		.hash_reg_file		= 1,
>  		.unbound_nonreg_file	= 1,
>  	},
>  	[IORING_OP_WRITEV] = {
> @@ -634,6 +635,7 @@ static const struct io_op_def io_op_defs[] = {
>  	},
>  	[IORING_OP_READ_FIXED] = {
>  		.needs_file		= 1,
> +		.hash_reg_file		= 1,
>  		.unbound_nonreg_file	= 1,
>  	},
>  	[IORING_OP_WRITE_FIXED] = {
> @@ -711,11 +713,13 @@ static const struct io_op_def io_op_defs[] = {
>  	[IORING_OP_READ] = {
>  		.needs_mm		= 1,
>  		.needs_file		= 1,
> +		.hash_reg_file		= 1,
>  		.unbound_nonreg_file	= 1,
>  	},
>  	[IORING_OP_WRITE] = {
>  		.needs_mm		= 1,
>  		.needs_file		= 1,
> +		.hash_reg_file		= 1,
>  		.unbound_nonreg_file	= 1,
>  	},
>  	[IORING_OP_FADVISE] = {
> @@ -955,7 +959,7 @@ static inline bool io_prep_async_work(struct io_kiocb *req,
>  	bool do_hashed = false;
>  
>  	if (req->flags & REQ_F_ISREG) {
> -		if (def->hash_reg_file)
> +		if (!(req->kiocb->ki_flags & IOCB_DIRECT) && def->hash_reg_file)
>  			do_hashed = true;
>  	} else {
>  		if (def->unbound_nonreg_file)

I can (will do Sunday, on the road till then). But I'm a bit doubtful
it'll help. This is using WRITEV after all, and I only see a single
worker?

Greetings,

Andres Freund

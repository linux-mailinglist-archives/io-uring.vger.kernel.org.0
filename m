Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B2614FC0D
	for <lists+io-uring@lfdr.de>; Sun,  2 Feb 2020 08:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgBBHOi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 Feb 2020 02:14:38 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49609 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgBBHOi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 Feb 2020 02:14:38 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 4698C21B10;
        Sun,  2 Feb 2020 02:14:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 02 Feb 2020 02:14:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=M9Dz30ZTX6O5HaMibb7km2szsUt
        1BfrAvqHLkKt3Maw=; b=SsQsuvheWRYHUhLA8y54Mmvg7/snwBNeactAMTvlhqH
        Q1wAS5178dtFde9z3twh8m/fX7984yuYmtP3cmKZdkXeYlqRRl+j9w0cxWADjAaq
        tWGVJTfpH98kziSkUs8YUzozDCbiX8j7rqaCtunp3IxqdV0ApViqyb0DNV7j+59O
        qzyqgsQ9qwV+kOrkqSBu0m2dHbUFB1Qfg532LH1gwcb5lnooEL6E2uXKfxbXmu/X
        +mqYIMo7+RIfbbvlYOQtGv1ACoeI48l9ui+opWTiONjA49bjxmmcnd2PAbn51ks1
        4tbOLRDFsjnjF2nOvHDakNJwsONVjC3n2QO19Y7XRcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=M9Dz30
        ZTX6O5HaMibb7km2szsUt1BfrAvqHLkKt3Maw=; b=yenjx75KoWe+mCYuMA9KuB
        OSexOng9OP4Njy8RhtnNIR3pLn+z3YP+4i+cWiKSAOkKDnjsdSWCUSFmAWpEI+q1
        foLjwy9wIwx0Xuz1nwid2SW9ngG4FgcnhNn8kX3ei5OBqh1VGIv1rL9SKrxiQhjt
        cBjgSMGYmTsmKEQGuzW+g80uSkXQoMFIdqwzRn8SZM0xu1GvOUKXxfM7Ye/Ks+WH
        OqNIMQLg7ztJuUFmemUFrYtw7tjQyXyg49GziQIkPcFI9RlLPvNV3SUcKijZ187n
        y5h9eS3oEQU1KsqASUWnfy1u7CMnY2jekmM3uQZynwaI3sk/XXsPyWhD+v/4eWbQ
        ==
X-ME-Sender: <xms:3HY2XvYlAIPyPLKu_hdBa93znGj7wSUPK_bH2CJnE6nLYxdt2x6Zgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrgeeggdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecukfhppedvud
    dvrdejiedrvdehfedrudejudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:3HY2XmQ4nlbP5EQFFdjjEj4UarBUGU1YZatGAdPnXf_vtwjxkzwZXg>
    <xmx:3HY2XhU662_T2QZg3oYzNABH-V-GDr0jeX0TL2cPfOCun-29LAeWrg>
    <xmx:3HY2XtYgBNMA_psS67nSXqmRALBypchR4PV1CYZz60ezZH53Fp9DdQ>
    <xmx:3XY2XpO2NF_tezUZGrMVbhmfq7iJSRooLMym-U7yD4geqhz0MzXsOQ>
Received: from intern.anarazel.de (unknown [212.76.253.171])
        by mail.messagingengine.com (Postfix) with ESMTPA id 996913280059;
        Sun,  2 Feb 2020 02:14:36 -0500 (EST)
Date:   Sat, 1 Feb 2020 23:14:35 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: io_uring force_nonblock vs POSIX_FADV_WILLNEED
Message-ID: <20200202071435.2hqg5dtqkejpjpft@alap3.anarazel.de>
References: <20200201094309.6si5dllxo4i25f4u@alap3.anarazel.de>
 <fab2fcb4-9fc2-e7db-b881-80c42f21e4bf@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fab2fcb4-9fc2-e7db-b881-80c42f21e4bf@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-02-01 09:22:45 -0700, Jens Axboe wrote:
> On 2/1/20 2:43 AM, Andres Freund wrote:
> > Seems like either WILLNEED would have to always be deferred, or
> > force_page_cache_readahead, __do_page_cache_readahead would etc need to
> > be wired up to know not to block. Including returning EAGAIN, despite
> > force_page_cache_readahead and generic_readahead() intentially ignoring
> > return values / errors.
> > 
> > I guess it's also possible to just add a separate precheck that looks
> > whether there's any IO needing to be done for the range. That could
> > potentially also be used to make DONTNEED nonblocking in case everything
> > is clean already, which seems like it could be nice. But that seems
> > weird modularity wise.
> 
> Good point, we can block on the read-ahead. Which is counter intuitive,
> but true.

> I'll queue up the below for now, better safe than sorry.
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index fb5c5b3e23f4..1464e4c9b04c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2728,8 +2728,7 @@ static int io_fadvise(struct io_kiocb *req, struct io_kiocb **nxt,
>  	struct io_fadvise *fa = &req->fadvise;
>  	int ret;
>  
> -	/* DONTNEED may block, others _should_ not */
> -	if (fa->advice == POSIX_FADV_DONTNEED && force_nonblock)
> +	if (force_nonblock)
>  		return -EAGAIN;
>  
>  	ret = vfs_fadvise(req->file, fa->offset, fa->len, fa->advice);

Hm, that seems a bit broad. It seems fairly safe to leave
POSIX_FADV_{NORMAL,RANDOM,SEQUENTIAL} as sync. I guess there's there's
the argument that that's not something one does frequently enough to
care, but it's not hard to imagine wanting to change to RANDOM for a few
reads and then back to NORMAL.

Greetings,

Andres Freund

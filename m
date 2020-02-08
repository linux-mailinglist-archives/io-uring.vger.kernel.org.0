Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4D6156733
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 19:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgBHSsL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 13:48:11 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34737 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727471AbgBHSsL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 13:48:11 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id AF09422027;
        Sat,  8 Feb 2020 13:48:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 08 Feb 2020 13:48:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=ZfFSW57hq8utcXEveHJZrGZfdRR
        3t2kGNib7bvNxAsc=; b=kQAVMhcX4Q03bSgPm1kk3WOh8w0isIHzNvwLufjrA48
        mS53I4ydJuPrTwkDhvW4oEf6zZUtUe/1UdzQiXwOX1xRTWEK9CSTqM5pyAQyleyx
        dEwmweI0qIwzCl6UJ4luQ9F9YSVXLrWulUnVv+msvJnb1u40WQcSpn/1TzHz7q0t
        MSr42RWgeje6bGLCy/rSVK709fq2vop/HWMsOn4MOERGZvy89rBzFEWV7/TJzkIJ
        VylSztkwNf3JDLU6MaCUuIi20COOFZMbJQ7j3IzQXMruaAPJwH/3iz+2E6Nj1wel
        wo5uXEp2X/UP4gpeYiEQicBtKpOWc4n9wZNL08iZyKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZfFSW5
        7hq8utcXEveHJZrGZfdRR3t2kGNib7bvNxAsc=; b=OGjJ4DbO89nPWae+Gop/sh
        hQYrnhYwvZ7/EUbQVk1DJFReoD3YNSGtxyRpcpavoLCVWLM8nARQ9J+yTlYqCIBG
        Zr8gBmXtfQNDwiDfMd0wxOWE4W41qx6Pk99Z34CTxtZwOmIymTaHiBGpVD+pzgvt
        xvY1d3fFrdqrPQ4yhv7KkfvZ1V+X6IoeqbYlbFQlrkyU0QKho9bDsIFtQqtANsya
        XNPjTdUHC27G+STn23yxHptvtalfbzeqru1O6Q0WbACfd3Fx1SeOOPGzAJk81Xhp
        9A62s+PpLlrKJlR5nFVIdvd69GPfj2fdZ2UCpsKxBgOktpZRpohkySEphZIWlSYQ
        ==
X-ME-Sender: <xms:agI_XvFY3Rk6i4NE_3tmWKfCYTkzb-7hYj094aPev8q9xPL89oOU9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheejgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucfkphepie
    ejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:agI_Xkc2UgjLbIMH2b_CWcUBPjGhJZI14Purxj-5aKS9sntyR0qOBQ>
    <xmx:agI_Xgr00cxNOXq6yOm5trQ3e7qtlqIJyig_7MIBsSKw90vCUpK63g>
    <xmx:agI_XtBiSM6DqH7WST_T_d3EFwp9-6J37FYK8RkNlhJyK5aCdtONtQ>
    <xmx:agI_XpqZ21_Bsj4ORoYUWSN5a6iU4PEUnXsOytnWBU4s4GfXVummog>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE7DA30606E9;
        Sat,  8 Feb 2020 13:48:09 -0500 (EST)
Date:   Sat, 8 Feb 2020 10:48:08 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Glauber Costa <glauber@scylladb.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Avi Kivity <avi@scylladb.com>
Subject: Re: shutdown not affecting connection?
Message-ID: <20200208184808.jxrnsl3xyoj7io6c@alap3.anarazel.de>
References: <CAD-J=zaQ2hCBKYCgsK8ehhzF4WgB0=1uMgG=p1BQ1V1YsN37_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD-J=zaQ2hCBKYCgsK8ehhzF4WgB0=1uMgG=p1BQ1V1YsN37_A@mail.gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-02-08 08:55:25 -0500, Glauber Costa wrote:
> - A connect() call is issued (and in the backend I can choose if I use
> uring or not)
> - The connection is supposed to take a while to establish.
> - I call shutdown on the file descriptor
> 
> If io_uring is not used:
> - connect() starts by  returning EINPROGRESS as expected, and after
> the shutdown the file descriptor is finally made ready for epoll. I
> call getsockopt(SOL_SOCKET, SO_ERROR), and see the error (104)
> 
> if io_uring is used:
> - if the SQE has the IOSQE_ASYNC flag on, connect() never returns.

That should be easy enough to reproduce without seastar as it sounds
deterministic - how about modifying liburing's test/connect.c test to
behave this way?

Hm, any chance you set O_NONBLOCK on the fd, before calling the async
connect?

Wonder if io_connect()
	file_flags = force_nonblock ? O_NONBLOCK : 0;

	ret = __sys_connect_file(req->file, &io->connect.address,
					req->connect.addr_len, file_flags);
	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
fully takes into account that __sys_connect_file
	err = sock->ops->connect(sock, (struct sockaddr *)address, addrlen,
				 sock->file->f_flags | file_flags);
appears to leave O_NONBLOCK set on the file in place, which'd then
not block in the wq?

Greetings,

Andres Freund

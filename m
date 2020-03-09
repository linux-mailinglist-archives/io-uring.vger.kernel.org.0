Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970EC17E546
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2020 18:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgCIRDQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Mar 2020 13:03:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39585 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727101AbgCIRDQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Mar 2020 13:03:16 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6019A220C9;
        Mon,  9 Mar 2020 13:03:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 09 Mar 2020 13:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=K4p7yttdHbuvtVbnoQF4/Ukukjb
        piqEbqRsbaQ0kMn0=; b=CxZrtnm8kKuTte41ZbwRBuCzPph2OWTTncro+2XYfgR
        XNOmNpWiDTavbXEEbaE/HUtB+uVKR5m4ynO9dcdNGXODadGt322OprUJnHO9OyKt
        IO6SKOlyRwc7YfhQBSSIeGf2NAQLZFYE8HnS9rU5iVOEHs/EkrIN/9nK/xN6DBk5
        +Mf/e2S4F5DuNbbrU/RzMY/TnEpyiOCiR7pYQsUm1/p3Epjq6N5IUmvii4BSbLt2
        vpQOKhwFljcDFXRViTNshjWSuxb74o+yVPITd26vdI2ATt02oy13ywG7urgXUF1i
        A4ebv3vjQDBpYxHvK39vHcV/frbohK1XkkJCcxnLfaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=K4p7yt
        tdHbuvtVbnoQF4/UkukjbpiqEbqRsbaQ0kMn0=; b=IF/H4TW7RfCLzIhGsfxr4k
        r25YvNGWY9/fn89maHMKO6R/v5Mq2wIGZoDIHx1yDcHWDUraC4OP9xH/FpdCPoXJ
        vkwqIUTbPTRD0c9AJoBuJ5xdZCU+IFXdqQSQie2HBZKco/ehPsp7UJfuwZREJMk1
        6X5Lz71G8slhnhmNGvt5UcyhNOlHZh5iwcnQ4FONAS++6aQ+uMR0hz3pwb1btv+l
        Xk9xevsc3azKKF1e1dbe0VrnMiPq4plvholBszrssl0/7wQlT0Yo3G8Jyum0Kobv
        FAh4oM6EwBKGF2+VU76hMTROcoFSV4z89v9n6BQem/4mLLO8UDJ6OLRb/zM8/a9g
        ==
X-ME-Sender: <xms:03ZmXlHn1_0qJG4Z3ml9WhCHYHqNVk02OkoKv6cuhlx6F5GKCcD6qQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucfkphepie
    ejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:03ZmXmZMsbZLMJdPEp9lasCwhQ9V-fWVssMXWW-WphVKZw_Fw24H8A>
    <xmx:03ZmXtHlx4xv6bIXGb2iLTLOkapAuNG9Iizikc10mueAkx6UBLBHDA>
    <xmx:03ZmXsCtlJojoqf8s-N9ZbaxmeZbfTEjb-OvkLDUWhDjgkNCFZKvxQ>
    <xmx:03ZmXuXevpoDwqf7E5ZKSzKrGEyyUtAjstKS9JM_Gv9OTTSvAPb0Ww>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id E0F953280067;
        Mon,  9 Mar 2020 13:03:14 -0400 (EDT)
Date:   Mon, 9 Mar 2020 10:03:13 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 2/6] io_uring: add IORING_OP_PROVIDE_BUFFERS
Message-ID: <20200309170313.perf4zbtdhq4jtvs@alap3.anarazel.de>
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228203053.25023-3-axboe@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I like this feature quite a bit...

Sorry for the late response.


On 2020-02-28 13:30:49 -0700, Jens Axboe wrote:
> +static int io_provide_buffers_prep(struct io_kiocb *req,
> +				   const struct io_uring_sqe *sqe)
> +{
> +	struct io_provide_buf *p = &req->pbuf;
> +	u64 tmp;
> +
> +	if (sqe->ioprio || sqe->rw_flags)
> +		return -EINVAL;
> +
> +	tmp = READ_ONCE(sqe->fd);
> +	if (!tmp || tmp > USHRT_MAX)
> +		return -EINVAL;

Hm, seems like it'd be less confusing if this didn't use
io_uring_sqe->fd, but a separate union member?


> +	p->nbufs = tmp;
> +	p->addr = READ_ONCE(sqe->addr);
> +	p->len = READ_ONCE(sqe->len);
> +
> +	if (!access_ok(u64_to_user_ptr(p->addr), p->len))
> +		return -EFAULT;
> +
> +	p->gid = READ_ONCE(sqe->buf_group);
> +	tmp = READ_ONCE(sqe->off);
> +	if (tmp > USHRT_MAX)
> +		return -EINVAL;

Would it make sense to return a distinct error for the >= USHRT_MAX
cases? E2BIG or something roughly in that direction? Seems good to be
able to recognizably refuse "large" buffer group ids.


> +static int io_add_buffers(struct io_provide_buf *pbuf, struct list_head *list)
> +{
> +	struct io_buffer *buf;
> +	u64 addr = pbuf->addr;
> +	int i, bid = pbuf->bid;
> +
> +	for (i = 0; i < pbuf->nbufs; i++) {
> +		buf = kmalloc(sizeof(*buf), GFP_KERNEL);
> +		if (!buf)
> +			break;
> +
> +		buf->addr = addr;
> +		buf->len = pbuf->len;
> +		buf->bid = bid;
> +		list_add(&buf->list, list);
> +		addr += pbuf->len;
> +		bid++;
> +	}
> +
> +	return i;
> +}

Hm, aren't you loosing an error here if you kmalloc fails for i > 0?
Afaict io_provide_buffes() only checks for ret != 0. I think userland
should know that a PROVIDE_BUFFERS failed, even if just partially (I'd
just make it fail wholesale).


> +static int io_provide_buffers(struct io_kiocb *req, struct io_kiocb **nxt,
> +			      bool force_nonblock)
> +{
> +	struct io_provide_buf *p = &req->pbuf;
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct list_head *list;
> +	int ret = 0;

> +	list = idr_find(&ctx->io_buffer_idr, p->gid);

I'd rename gid to bgid or such to distinguish from other types of group
ids, but whatever.


Greetings,

Andres Freund

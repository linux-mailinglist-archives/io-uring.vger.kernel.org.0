Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E257917E5B1
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2020 18:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgCIR2t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Mar 2020 13:28:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58121 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbgCIR2t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Mar 2020 13:28:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3706B22139;
        Mon,  9 Mar 2020 13:28:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 09 Mar 2020 13:28:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Ji9BRmhrEDmIV2NI7CwbxaAz8yS
        pg+YlqHzffUvypfg=; b=erEF4kroq78d548WIRaqGA1TEJoydx7cUj05vlMcyJD
        5WfLZchvvB137BV8i0CzUf7/5p/iRDCaxfilSxIB/49XXT8tosFQV1d35fQvTDmQ
        /8mIG9qkr8tRr4Lf/g/CmkLOy+c/WSKD2D0HwTaLcY5DNEVkMWIM2zf9t8/BpAKY
        8Bkb3JVIbm0dl8epGvEMpmDPC9RhSlCaaWb6yzhGmrgEWnm7LgfTXxpABDWEPiEG
        DEKgzWi7SqFvWqszu3xrXaW7apzy7qLjHJCEUdW1pFQfCFcfbQHImh8KXnjzrBBm
        5Da+tVVUZrM2xNPNlUn48AZ4t4jPqtx2g6CBHZO3vzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ji9BRm
        hrEDmIV2NI7CwbxaAz8ySpg+YlqHzffUvypfg=; b=IIgkRrZREfKdo32znvfmqj
        J5jiM5dfrGL+2qJ2TZ0tvv6Wm+sfELIJAm5GaMn/wPBQQ0kbwoNhuvs+bp+0Ol2P
        v0tkkCat3/BhjjN9aE3G9/kJaNbcqh2rtdDcVfAbRIwWRy2wcAVLf09kIQJytnm7
        IQryPVVR757hALYiyuy+2NYiHbxAZc7aNr03zn0cvXWfwrKteV/x9KcGJMnJTwBX
        bSmCXcTQUIM3WBUFfMFUO+BET111A6Y2vKl7lyfR1rcn8600Wb1dPPvWlRrNE/hR
        6oVAoxL0SHp9nJa1I89aIjHWMo+9QVISOGW9St7ByNGTFNWlU3re6tCpbsAsRUfg
        ==
X-ME-Sender: <xms:z3xmXljKfJyS2bNiFl8RRjQitP4u5x6w1yssyCkUNgR9Z1-QTJQ3gg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecukfhppe
    eijedrudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:z3xmXuQsMjmVlhVGpLwt4dx5uOvMExIBBET3AIuhYgScXxuwgHXhrA>
    <xmx:z3xmXgHijEqkwYqpriqwMLaIhLhfDbyIHJXGb51p1c6PGbJYV-Cm1w>
    <xmx:z3xmXukp9JYPRSG1X7vjRWBLNJmnP2kmduDFE5jg6BgezIdRMMMBiw>
    <xmx:0HxmXivbH3YpHlar_lcKQY90VSURMlDL9WCKHVPmZ2tNYVoL2VixtQ>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7B0A730618B7;
        Mon,  9 Mar 2020 13:28:47 -0400 (EDT)
Date:   Mon, 9 Mar 2020 10:28:46 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 2/6] io_uring: add IORING_OP_PROVIDE_BUFFERS
Message-ID: <20200309172846.ilh27woo7tsaqadf@alap3.anarazel.de>
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-3-axboe@kernel.dk>
 <20200309170313.perf4zbtdhq4jtvs@alap3.anarazel.de>
 <a2283eb6-4b86-b858-a440-af4a8a7c2ba9@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2283eb6-4b86-b858-a440-af4a8a7c2ba9@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-03-09 11:17:46 -0600, Jens Axboe wrote:
> >> +static int io_add_buffers(struct io_provide_buf *pbuf, struct list_head *list)
> >> +{
> >> +	struct io_buffer *buf;
> >> +	u64 addr = pbuf->addr;
> >> +	int i, bid = pbuf->bid;
> >> +
> >> +	for (i = 0; i < pbuf->nbufs; i++) {
> >> +		buf = kmalloc(sizeof(*buf), GFP_KERNEL);
> >> +		if (!buf)
> >> +			break;
> >> +
> >> +		buf->addr = addr;
> >> +		buf->len = pbuf->len;
> >> +		buf->bid = bid;
> >> +		list_add(&buf->list, list);
> >> +		addr += pbuf->len;
> >> +		bid++;
> >> +	}
> >> +
> >> +	return i;
> >> +}
> > 
> > Hm, aren't you loosing an error here if you kmalloc fails for i > 0?
> > Afaict io_provide_buffes() only checks for ret != 0. I think userland
> > should know that a PROVIDE_BUFFERS failed, even if just partially (I'd
> > just make it fail wholesale).
> 
> The above one does have the issue that we're losing the error for i ==
> 0, current one does:
> 
> return i ? i : -ENOMEM;
> 
> But this is what most interfaces end up doing, return the number
> processed, if any, or error if none of them were added. Like a short
> read, for example, and you'd get EIO if you forwarded and tried again.
> So I tend to prefer doing it like that, at least to me it seems more
> logical than unwinding. The application won't know what buffer caused
> the error if you unwind, whereas it's perfectly clear if you asked to
> add 128 and we return 64 that the issue is with the 65th buffer.

Fair enough. I was/am thinking that this'd pretty much always be a fatal
error for the application. Which does seem a bit different from the
short read/write case, where there are plenty reasons to handle them
"silently" during normal operation.

But I can error out with the current interface, so ...

Greetings,

Andres Freund

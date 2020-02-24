Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E321F169CA7
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 04:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgBXDd4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 22:33:56 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:41509 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727156AbgBXDd4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 22:33:56 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 275D7509;
        Sun, 23 Feb 2020 22:33:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 23 Feb 2020 22:33:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=cxaJ8afJxrxPW3PtDf4wY+T/3LR
        I0PJ1e8hgKQmo19s=; b=Ckw9KVGszSOauY4Piw1tJVNWY7qL/MDErv/WCrpUJgk
        akFxCF9mj3DeiAex3aHtd6n7yfqfhVfXrtqBzVjEzGEnJKV/55Rt2vk/0xOP1yce
        Ta/xYMmqm//85Lw7I1xc1lUVVowGUEWa1MowhV4jLdLhM2HSo0tkY7ONQZ8qF2NR
        qBbDccGfjKhT2woFWwra32/BNdz99K5RoiZTCj8ZHLTTAeur7ZoH45TFDhfTRlxb
        AiakFN31eJkfic2IY8ppNfaOVxjLKXwCJqT9SW1Q+eorE6Ow72nRD02CPePntGTL
        SJ0DUkkPJ+zOyKNPM6KauQCUsImUdum3q8LY90R49kg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cxaJ8a
        fJxrxPW3PtDf4wY+T/3LRI0PJ1e8hgKQmo19s=; b=38LHfBKAf7DeqXlnWr0JQ2
        +42MTuzKoQBoizaiRYRHQZJrAOo0cuePvFHFbpkl3B1Zqo7LcKEtlQN4SBZQ6DOL
        xw3sv12rO56ZXYbtonkwjR7jvpDS8d6Xq7PAe6lZf+3yYwm8qG7PU83S/uZSBkYQ
        cvbhzlg87uPre68iBVVjrD4SCTTxEx3uOLvEeFF0Xr8Sm2jsImQnbqPy1VBPI5Y5
        oVFR6q813VlVA1OQ9SR1bfb/t1pyw77FOxa+O26olQ82eyR5mvlrizYXUvKFck2c
        VMtPdra+0iJ7VSsCQKIaK8ujCFNvdI4bwH34UNLFly62rhx8Vr8uobIMzHzWnRew
        ==
X-ME-Sender: <xms:IkRTXl3gdWu9Ukzp2k5nbW62uYSmKe2-t7ZRE5xkhubrcLQ0IRKkSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeelgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecukfhppeeije
    drudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:IkRTXjV8UCnbkSFQvdi7olVt1BlL3bogiKGVLtohO9BI8u5BNcz1kA>
    <xmx:IkRTXufiQ0xn-zszXhMjQ0x25Ju68fcVEF5_XzMga6ZFWlTrOzbamA>
    <xmx:IkRTXgPGKteA6DN_5cABwsSTKFo9AysUv_C8uUyvL3OtL8a5gSbKtg>
    <xmx:IkRTXnjbsF4A1tBUMXTarR01e4S9aJAE2IMFyM8F4SHX7Dh2v34PYg>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4B1D7328005D;
        Sun, 23 Feb 2020 22:33:54 -0500 (EST)
Date:   Sun, 23 Feb 2020 19:33:52 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: Deduplicate io_*_prep calls?
Message-ID: <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-02-23 20:17:45 -0700, Jens Axboe wrote:
> > that seems a bit unnecessary. How about breaking that out into a
> > separate function?  I can write up a patch, just didn't want to do so if
> > there's a reason for the current split.
> >
> >
> > Alternatively it'd could all be just be dispatches via io_op_defs, but
> > that'd be a bigger change with potential performance implications. And
> > it'd benefit from prior deduplication anyway.
>
> The reason for the split is that if we defer a request, it has to be
> prepared up front. If the request has been deferred, then the
> io_issue_sqe() invocation has sqe == NULL. Hence we only run the prep
> handler once, and read the sqe just once.

> This could of course be compacted with some indirect function calls, but
> I didn't want to pay the overhead of doing so... The downside is that
> the code is a bit bigger.

Shouldn't need indirect function calls? At most the switch() would be
duplicated, if the compiler can't optimize it away (ok, that's an
indirect jump...).  I was just thinking of moving the io_*_prep() switch
into something like io_prep_sqe().

io_req_defer_prep() would basically move its switch into io_prep_sqe
(but not touch the rest of its code). io_issue_sqe() would have

if (sqe) {
    ret = io_prep_sqe(req, sqe, force_nonblock);
    if (ret != 0)
        return ret;
}

at the start.

Even if the added switch can't be optimized away from io_issue_sqe(),
the code for all the branches inside the opcode cases isn't free
either...

Greetings,

Andres Freund

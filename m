Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585AC214849
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2020 21:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgGDTLa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Jul 2020 15:11:30 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46647 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726791AbgGDTLa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Jul 2020 15:11:30 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 10D2D5C0090;
        Sat,  4 Jul 2020 15:11:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 04 Jul 2020 15:11:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=UThXFHWu5GZp+p0oVXJ4NvAt9ij
        CXh1jb7YKHWnaIus=; b=ZsIo6bPdSNEtqvcP8HWcVdAveGL8Iq3z5nz4iq7CqgO
        wm/wCCBEoDHOak3WzylWYt+AvMt2T+qgdU7JyjjxiRxopouK4wTM1Y3ZT/eGqn7C
        aYHEspFv5VHYo2jSJDLA5Qyj0G/Sb1HVcqIE4h/XgowgOttfxJ2glGnfoIjsaMbl
        hHTJIyh9+OL8L2vliyQsqdTgRp4n98gKqcEYeDSM5VDXEerRGljLQnqoaxlFW7yT
        tf9cZ8Q/JrN28xqYw6M7k1Zi9WmYbnzUatRwzBMD/NaN9Bjc/bC2AbAdW14ke7P8
        En7GtHntZHBGMdVCUD93j32DrM1U+ZNO1Wg9jZ9Rwfg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UThXFH
        Wu5GZp+p0oVXJ4NvAt9ijCXh1jb7YKHWnaIus=; b=SP3+ULCr0m3t8B/2fbtwfN
        h5j5aRMSL6dmE6GtBewr2JShTr/Ttpvlj1DMyDeBuQsMKNdBZN98exsDx7vApTym
        6zQAJtsyOZLMpcYmtuACNOqzhS665BJyjE9z4Q2M0hwk3mFZzhil5LnCLzeYkwjM
        w38x1+JmL+03hg9E+5Dc3YX4njKOCmSOA73EtSQTO0fvxQ659A1roOcvgP26xp/R
        aSSj1zoInHsBtTrC9IAH7rW+LTmjUKk6420LogGOZ1Wvt9RMoqJrIGqz6MbWP3gQ
        YApc/aZDre1zhBvweZ5iilhG64tBwz9XIiqUFBZfSk7Ny4fzP4Y7525VE0GhWTHQ
        ==
X-ME-Sender: <xms:YNQAXxyKORhFSVFgUH6Cy_9ArIHlZ39txq5ZjOHTwgU8ci4rua2iMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtdekgddufeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedukefhkeelueegveetheelffffjeegleeuudelfeefuedtleffueejfffh
    ueffudenucfkphepieejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdr
    uggv
X-ME-Proxy: <xmx:YNQAXxQSW-SsleomAxR6J7IG31uWz-1xsKRoGUwwbdrTADPYotJEhw>
    <xmx:YNQAX7UC1Qbk-LYFFEOM-irZMKAInCFhOjX8aJsfNqAV9TUddcOxVw>
    <xmx:YNQAXzgx4AJrDD_ZUriERL5kHhge-TqWt9SRvsqMixVc7vaNfNyFQA>
    <xmx:YdQAX2_zn3g4LM7BtL1H-AQavPKDWuPJt43vMnygMXy8G49vmzBmOA>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 398493062999;
        Sat,  4 Jul 2020 15:11:28 -0400 (EDT)
Date:   Sat, 4 Jul 2020 12:11:27 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: signals not reliably interrupting io_uring_enter anymore
Message-ID: <20200704191127.f4fqzleo4r53p647@alap3.anarazel.de>
References: <20200704000049.3elr2mralckeqmej@alap3.anarazel.de>
 <20200704001541.6isrwsr6ptvbykdq@alap3.anarazel.de>
 <70fb9308-2126-052b-730a-bc5adad552f9@kernel.dk>
 <7C9DC2D8-6FF5-477D-B539-3A9F5DE1B13B@anarazel.de>
 <f2620bef-4b4c-1a5d-a1e8-f97f445f78ef@kernel.dk>
 <c83cfb86-7b8e-550b-5c04-395c34415171@kernel.dk>
 <624c0af9-886e-0c5f-0c35-dd245496b365@kernel.dk>
 <a82e680a-7db6-3569-2b53-e43e087ef464@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a82e680a-7db6-3569-2b53-e43e087ef464@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-07-04 08:55:39 -0600, Jens Axboe wrote:
> This tests out fine for me, and it avoids TWA_SIGNAL if we're not using
> an eventfd.

I tried this variant and it does fix the problem for me, all my tests
pass again.  I assume this will eventually need to be in stable for 5.7?

Regards,

Andres

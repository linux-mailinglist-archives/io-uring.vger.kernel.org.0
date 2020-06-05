Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1926D1F02E4
	for <lists+io-uring@lfdr.de>; Sat,  6 Jun 2020 00:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgFEWas (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Jun 2020 18:30:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60427 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728157AbgFEWar (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Jun 2020 18:30:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8DEA85C01DF;
        Fri,  5 Jun 2020 18:30:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 05 Jun 2020 18:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=JQ0T9QXE+j7q+0Zzk3VcIyBO3AA
        dNqka5dcc5FHLBIU=; b=IptiNzzTDPqny+GbPDBRgd/1jA9JZWGKkwYtx5wDGF6
        n6URXZXMO+AwI9yCCdg1BAb0Fm9RP2XMt6Re0Ang4XKlX5t/OW3u74KyEhvAx1A1
        hVRJ8Oct8yUFAl8ikcZrSmmdIKRDbw056NyLa3seSIlS+cx7SJzLt9orUweLN8Ut
        +RH/wHZtS2MdEXkrF+4R184RxIaxICyc3HtgB8ceOUeWljsbdiJycOUd5Ubqluyq
        ODqkYEDhuxDMjDOW86/U2TM0dXFKOkFkMmshJiHcH39Th8PHgtaPtmKEpp+XxI2k
        nvRre4SkyYYaD68T4XxARuy4PMEEqvVz8p2BG1VSgCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JQ0T9Q
        XE+j7q+0Zzk3VcIyBO3AAdNqka5dcc5FHLBIU=; b=a8TzSgmfGjfQh4dnwzYtGL
        ULR/mfNggLyqYomsibxWX7Pids+azAeMGdLg0wRt5eskYpATWNNjF8CXtnehJWzP
        MlPkX9QWsOpVAEAq6PIjx4QQdytD8BG/03pfn1mrO5r0XM6crbzNiistvw0+TrQ2
        j+LopnkZvoTCxBeekdcdKrzGZsPoarb3BTswobgNdeAcZF1ng0q+QOuPCkZ7na5y
        1ZbuIEF3/70Ahs68+E+WIb8nzyrruwRVSfy+5jlHK1nYkgpOdiLjqnUFBOjF8ZnZ
        1l5etx3lWMz4WO96hdMA+S6k6FlXZ+3QJyMXDYt60H1ptqpDFan4z1/iU+G+IaLg
        ==
X-ME-Sender: <xms:lcfaXj-4x3xmVznYF2BeCZ2-Qj3YeSbgpzQpApvRlXRoDoO75e7U5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeggedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedukefhkeelueegveetheelffffjeegleeuudelfeefuedtleffueejfffh
    ueffudenucfkphepieejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdr
    uggv
X-ME-Proxy: <xmx:lcfaXvsonFRgPaIjZwHYvMzyctjo5lmuTetDNZCxw15A8-a7Kdsmzg>
    <xmx:lcfaXhBNE7yichwRk_S4Wq9NjIjN1Tpxpo4LbAsTHv0su4oLrBHjDw>
    <xmx:lcfaXvebF5sD4wuTsCXkAlcS_IJRho_KCiHqw0HmpGsCWM1IpnxyDA>
    <xmx:lsfaXhZRfX1AN4jJp9iyqlfrEJneTthXz3Y77ndGHLGBiQKFQ6sIWw>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id C202D3060F09;
        Fri,  5 Jun 2020 18:30:45 -0400 (EDT)
Date:   Fri, 5 Jun 2020 15:30:44 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
Message-ID: <20200605223044.tnh7qsox7zg5uk53@alap3.anarazel.de>
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200604005916.niy2mejjcsx4sv6t@alap3.anarazel.de>
 <e3072371-1d6b-8ae5-d946-d83e60427cb0@kernel.dk>
 <6eeff14f-befc-a5cc-08da-cb77f811fbdf@kernel.dk>
 <20200605202028.d57nklzpeolukni7@alap3.anarazel.de>
 <20200605203613.ogfilu2edcsfpme4@alap3.anarazel.de>
 <75bfe993-008d-71ce-7637-369f130bd984@kernel.dk>
 <3539a454-5321-0bdc-b59c-06f60cc64b56@kernel.dk>
 <34aadc75-5b8a-331e-e149-45e1547b543e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34aadc75-5b8a-331e-e149-45e1547b543e@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-06-05 15:21:34 -0600, Jens Axboe wrote:
> >> I can reproduce this, and I see what it is. I'll send out a patch soonish.
> > 
> > Thinko, can you try with this on top?
> 
> Sorry that was incomplete, please use this one!

That seems to fix it! Yay.


Bulk buffered reads somehow don't quite seem to be performing that well
though, looking into it. Could be on the pg side too.

Greetings,

Andres Freund

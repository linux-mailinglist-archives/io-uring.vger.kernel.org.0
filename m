Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A721F035A
	for <lists+io-uring@lfdr.de>; Sat,  6 Jun 2020 01:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgFEXCr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Jun 2020 19:02:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52903 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728330AbgFEXCr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Jun 2020 19:02:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id ED1B85C00E4;
        Fri,  5 Jun 2020 19:02:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 05 Jun 2020 19:02:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=JiEpPiAsCPxIyZsOENHAmfLvx6y
        ie2EoZciHMl9V7vc=; b=LbOQNyVNaZtUEVjH1wXrylZgzL2n3UOPF2YZBsesIYL
        fF85YVX2GBJHG/j234vSWyWqFYTuNdqLyFdoAEoIayEXLGgO6y460BBGrTuMLv1c
        2GbhAko23Tq+U9Np9yge8SrKBNLn0/irhFumy3Pe3Pwj0CGpnGPfd1dDcuGjJm6P
        iuICE9GLgfc7+NGq2Tx0BW5fVIQy9lh2r36ylWohfNPmdnJHbMxmzAFWgI4TkrU4
        kY6ASHJTtvf8wMopL3KSFjLkVAKmuCjNCEsfwohXoEdJHGU6D4HirZtuUKqSBVyW
        meB8ZLdiMTi/RD3r/QCxcLBl5irAyw+XTJ1VkkNLeEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JiEpPi
        AsCPxIyZsOENHAmfLvx6yie2EoZciHMl9V7vc=; b=QQ1E1eUVDxGvShEzglY7VT
        QJBJ5/rMl3+wdSunPeupIU1JGMXJ/L8kk+jX9foo76z5dVyEGlQY22ha0wmlMeUw
        PaDlI669ySojc3FtgbSeRe60eH6y2Db+M1bsinZ8feCv4Nfmn7MpBUODSofNXR8c
        QE3ita2S2kBlVKjFciwegMworpT//wI8e3ekxLg3B9E4d5hvK7xEF1AxhAAZZAk1
        tlpfqseMJYJRZBEMIIuiHq2k3YItsQWesKrDuVKWzvyueT1FpAWprj2uCtd0ZWch
        SASTFIZaa94zIudxu2Wk6QkJuBWeTJw550dVi0qq8v7ozgL5lJnWy+TUYchiF3Mw
        ==
X-ME-Sender: <xms:Fc_aXuta6gZZsoOV6PvQHFwvcbB17touCjvfW93dQYCy1qNO4ZZP1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeggedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedukefhkeelueegveetheelffffjeegleeuudelfeefuedtleffueejfffh
    ueffudenucfkphepieejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdr
    uggv
X-ME-Proxy: <xmx:Fc_aXjf0EWJ2X0ywuxEPnZzggPvzr_2q-dAJ2lyG9EGz-a1jbFyN7Q>
    <xmx:Fc_aXpy9Iq9drfpxI6F7Lbb4GmNB6tLX_lN6FId_V_lm4w1XLr8PTw>
    <xmx:Fc_aXpNP2CDpFEYTzwzO1MayvKcpWEZ51R1cvBqIU_qL0G8is8tlFQ>
    <xmx:Fc_aXgI06kf4LsFR0I8aLn6fghj7XXisPm6iNwLzob02oSlPOJf_yQ>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4EE1B3060F09;
        Fri,  5 Jun 2020 19:02:45 -0400 (EDT)
Date:   Fri, 5 Jun 2020 16:02:44 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
Message-ID: <20200605230244.u342xw4negic2nmr@alap3.anarazel.de>
References: <20200605202028.d57nklzpeolukni7@alap3.anarazel.de>
 <20200605203613.ogfilu2edcsfpme4@alap3.anarazel.de>
 <75bfe993-008d-71ce-7637-369f130bd984@kernel.dk>
 <3539a454-5321-0bdc-b59c-06f60cc64b56@kernel.dk>
 <34aadc75-5b8a-331e-e149-45e1547b543e@kernel.dk>
 <20200605223044.tnh7qsox7zg5uk53@alap3.anarazel.de>
 <20200605223635.6xesl7u4lxszvico@alap3.anarazel.de>
 <0e5b7a2d-eb0e-16e6-cc9f-c2ca5fe8cb92@kernel.dk>
 <20200605225429.s424lrrqhaseoa2h@alap3.anarazel.de>
 <0179d0bf-0b01-3f05-9221-654a00f0452d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0179d0bf-0b01-3f05-9221-654a00f0452d@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-06-05 16:56:44 -0600, Jens Axboe wrote:
> On 6/5/20 4:54 PM, Andres Freund wrote:
> > On 2020-06-05 16:49:24 -0600, Jens Axboe wrote:
> >> Yes that's expected, if we have to fallback to ->readpage(), then it'll
> >> go to a worker. read-ahead is what drives the async nature of it, as we
> >> issue the range (plus more, depending on RA window) as read-ahead for
> >> the normal read, then wait for it.
> > 
> > But I assume async would still work for files with POSIX_FADV_RANDOM
> > set, or not? Assuming the system wide setting isn't zero, of course.
> 
> Yes it'll work if FADV_RANDOM is set.

Cool.


> But just not if read-ahead is totally disabled. I guess we could make
> that work too, though not sure that it's super important.

It's not from my end. I was just trying to check if the reduced
performance I saw was related to interactions between PG prefetching and
kernel level prefetching. And changing the /sys entry seemed easier than
making postgres set POSIX_FADV_RANDOM...

Greetings,

Andres Freund

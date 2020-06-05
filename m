Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDA81F0321
	for <lists+io-uring@lfdr.de>; Sat,  6 Jun 2020 00:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgFEWyd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Jun 2020 18:54:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51173 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728310AbgFEWyc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Jun 2020 18:54:32 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8F3035C017D;
        Fri,  5 Jun 2020 18:54:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 05 Jun 2020 18:54:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=rtqU8Me6/Sah9/UID3jwrcjOeBa
        pOanB7BcyzdI38RE=; b=NGldOqjbN3gwhGRInNltcTbw4a03Y13KaM7FEMNDCfo
        TOb2UbJeNc3EbelAmBQPNfZMSPLBwkLbucwynNBPagUJvEaFLvk+/XaPAjzCRXcs
        FixtTMhl84qs8y67E5cCcIgCQK3SsrNO8VytbraR+7lumEMQBtRt35Jjjv3ERhue
        n1p21/l0y+gIjQhbLy12yMVR2ZH2Rxmwv3ar1Rf2dVgrpkudtoJbako2WW4VwfPI
        nslfIdgmeY96gJgvNz85s6feC7PnNsfNwsjiufluenxOpRQiL2q6vPXdHJURjA1b
        ve5sQRK5mFctFy7BDv7NyHOkPl+FJ98E50ft/dgph7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rtqU8M
        e6/Sah9/UID3jwrcjOeBapOanB7BcyzdI38RE=; b=X8bBfKOA148xFnBZE901pr
        O5/u9eexom9QtfZ3HOuRrscMc702mw0pVdBfxE85/Ck0E5ybn6k0s7UMrCADgoMx
        lWkmOpnqt3q+6mHWcu5buc3Pv0jsiufqyvY5VSN/zcQBBDnfHxNmcn1n9/Gi9FFc
        G3E9AHYFvdeIgBKP4CSOquQvCn2ndVAJ2J/oe+0GuA7CHBsiI3NpW5qCwpKVuoyy
        2zqqm8B5l3vY6SSvqjpxGCBI9DNA79CeaQDrXWLNqxgs/4ve729qnCXnkT3qa9uA
        Yn6mPjS41hDkXX6+gD4ON78YE8U2E9nqgVbKoIytndbxj2mtR+66U9utICzEqQug
        ==
X-ME-Sender: <xms:Js3aXgLix9CPIk7udeifvrjuYZ9Zya1Njin-lr9wB6yLgOqqiUbxcQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeggedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedukefhkeelueegveetheelffffjeegleeuudelfeefuedtleffueejfffh
    ueffudenucfkphepieejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdr
    uggv
X-ME-Proxy: <xmx:J83aXgIj99dQZzHtDFFWBQ-R7GZaQdhIeW7fI7XPmExzSJd-FT9tKg>
    <xmx:J83aXgsM5vaQ7RPrxI3SuOKl6hKzBx8JZc1tE8AWsMM7dXqHqfZ0HQ>
    <xmx:J83aXtZuzLeNBAY-lrefkuFKVop1jIUKrHlGtR-piLCldFFlYlmW-g>
    <xmx:J83aXmm_G375tnTaeYI7jbDWgSuLcUzKczU2ICynZ8u9MFQcpN_jeg>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id CF5043280064;
        Fri,  5 Jun 2020 18:54:30 -0400 (EDT)
Date:   Fri, 5 Jun 2020 15:54:29 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
Message-ID: <20200605225429.s424lrrqhaseoa2h@alap3.anarazel.de>
References: <e3072371-1d6b-8ae5-d946-d83e60427cb0@kernel.dk>
 <6eeff14f-befc-a5cc-08da-cb77f811fbdf@kernel.dk>
 <20200605202028.d57nklzpeolukni7@alap3.anarazel.de>
 <20200605203613.ogfilu2edcsfpme4@alap3.anarazel.de>
 <75bfe993-008d-71ce-7637-369f130bd984@kernel.dk>
 <3539a454-5321-0bdc-b59c-06f60cc64b56@kernel.dk>
 <34aadc75-5b8a-331e-e149-45e1547b543e@kernel.dk>
 <20200605223044.tnh7qsox7zg5uk53@alap3.anarazel.de>
 <20200605223635.6xesl7u4lxszvico@alap3.anarazel.de>
 <0e5b7a2d-eb0e-16e6-cc9f-c2ca5fe8cb92@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e5b7a2d-eb0e-16e6-cc9f-c2ca5fe8cb92@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-06-05 16:49:24 -0600, Jens Axboe wrote:
> Yes that's expected, if we have to fallback to ->readpage(), then it'll
> go to a worker. read-ahead is what drives the async nature of it, as we
> issue the range (plus more, depending on RA window) as read-ahead for
> the normal read, then wait for it.

But I assume async would still work for files with POSIX_FADV_RANDOM
set, or not? Assuming the system wide setting isn't zero, of course.

Greetings,

Andres Freund

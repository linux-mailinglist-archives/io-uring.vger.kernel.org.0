Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D17632367F
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 05:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhBXEzw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 23:55:52 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:52887 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233354AbhBXEzt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 23:55:49 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 93C1CD55;
        Tue, 23 Feb 2021 23:54:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 23 Feb 2021 23:54:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=VpJvU63JZUkuA98+A5OVC0JSrw3
        QQVa+FWXOwjRn9r8=; b=Rdp3AD13+1qAK5ZPWV3PYzLvYklqXY2sL6nK6C17PLw
        tpqVcrJmeu70OW7+biXqD2v4GAROjQTJBQXKSeQunM1PzgpmR73eVKe3dKVdQ0D5
        rmalVqA19H6Eu8y+9mQyukvM+rADt2aN2bkPDKgkwFoXegwJu0Hty0tSO3GzIJHr
        DqbFAVlAkNeH1NxsVqGoohhkiPNzTuwZwUNeaawtm4WUzO319Yn8C6hTFfJjbg/j
        vUcoA0JRxDkFyJlIpEJs5IZiKT9q1qlmK6OL8ObnJiTLc3GWTXIgP5bzu6LUrn34
        dmVrNYZYFd3QIuuSZ44TyVoki6NVcL6+i0WIw7E0mDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VpJvU6
        3JZUkuA98+A5OVC0JSrw3QQVa+FWXOwjRn9r8=; b=dFDy3jmCx0dDfhGjEWdBKQ
        erbpx8sJeQfJGc9InLg3bGhrQp5D1UlutBNfu5hrAS6LexbdJ9chCCZTB4c8bQiK
        anK7dd0pu9cknEDv4CpUKhc3/o0lbjJuoxbMFfMsaCLvA6PCKXZBeDk6wq5DJvSf
        ki6OT2tCHKMXW8X/Ak/pSfH51jTCMuXUS0Ea2GYwiyQNPh3UIFCFDGCThGEkFenw
        ipaSuKEDlYNBV7C/LSQ6PA/SqE24cdkyRZNBKhTQ04olrDqmNH5WkePt1GWOzBTf
        EinMmaWKSeHH5mLk3x1u9g88YUM9+abmxsftS17fSccD102EMhzQ/MaKN/ocsQ/Q
        ==
X-ME-Sender: <xms:Itw1YLd9BT42svG2zhqppVa03Jwwizl-WcPf89Yng_jan0iUwR_L2A>
    <xme:Itw1YBJyclZNiP05S_ZlKgzN1CeYCvJYCfZkj1j5BZqh1lSeYMVdYlhlId8KucSa8
    H-iwr8F-vEBnxWReA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeeigdejfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrth
    htvghrnhepveffjefhuefgveeivdfffedugfejieetveehtdefleeiteetiedviedulefg
    gfegnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepieejrdduiedtrddvud
    ejrddvhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mheprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:Itw1YBaz8waVI-fbxAVBHlDsDQd26IBCDDsbyZq4bfC-pxMutp1WKA>
    <xmx:Itw1YEvxm9ZdSb3n3TAj7RldazZdrnie6Lddf2f0OTpCvM9RlPUSOA>
    <xmx:Itw1YGsoUgWdKpy9GZJInCPj-0aGUGgluszDwbwmyftGpoHtOUHVZA>
    <xmx:I9w1YCUA2cUxCd5pZpko5GJVFeuRvR-jXHvZ39yDfgQMOc28cSBoHw>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE6A1240064;
        Tue, 23 Feb 2021 23:54:58 -0500 (EST)
Date:   Tue, 23 Feb 2021 20:54:56 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: io_uring_enter() returns EAGAIN after child exit in 5.12
Message-ID: <20210224045456.rt3c3pvvka7fpaln@alap3.anarazel.de>
References: <20210224032514.emataeyir7d2kxkx@alap3.anarazel.de>
 <db110327-99b5-f008-2729-d1c68483bff1@kernel.dk>
 <20210224043149.6tj6whjfjd6ihamz@alap3.anarazel.de>
 <d630c75f-51d4-abb4-46b3-c860a6105e4b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d630c75f-51d4-abb4-46b3-c860a6105e4b@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2021-02-23 21:33:38 -0700, Jens Axboe wrote:
> On 2/23/21 9:31 PM, Andres Freund wrote:
> > Jens, seems like it'd make sense to apply the test case upthread into
> > the liburing repo. Do you want me to open a PR?
> 
> I think so, it's a good addition. Either a PR or just an emailed patch,
> whatever you prefer. Well, the previous email had whitespace damage,
> so maybe a PR is safer :-)

Done https://github.com/axboe/liburing/pull/306. The damage originated
from me foolishly just copy-pasting it from the terminal :) - I wrote it
a test VM and was too lazy to copy the diff out...

Greetings,

Andres Freund

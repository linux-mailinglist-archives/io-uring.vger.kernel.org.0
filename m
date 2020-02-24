Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E0316ACB3
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 18:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgBXRIu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 12:08:50 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:35525 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727090AbgBXRIt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 12:08:49 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id D00665D4;
        Mon, 24 Feb 2020 12:08:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 24 Feb 2020 12:08:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=1dnhSSnkYegmVjXMOETf4ZoFYs5
        duKsJuwrh/9Yh4qU=; b=fcFfeMqiTF6f/ZFp1zhUPpwtd3RGnpgtNrt4bk9+E9G
        kNH3QQ+CWs/4dNtNiflTw9L5Ka4i8/owSIhVWWWD0CNgcUPw+Krp24oPTeYnpPqE
        T47R+0siyodAg8vLbLFd01+PusLuchI5krKJMdROE4aRA6Ng1VuFACLRcomvLgii
        vcqI8YEJJZz9OBtpRKM9sZgncPeuULcr6mWB41vSKffUtFy69N2gFz2ExESz0YkB
        B5b78/x9zgIhXtDJ+vY/iBuVqkiOv9QGaR6op8cDJzKAqnDD8jX7aLa5DwaIvByN
        kJiLH740ZraFR0sA7wS31xKB5QezHK1V83B/lt2Y6VA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1dnhSS
        nkYegmVjXMOETf4ZoFYs5duKsJuwrh/9Yh4qU=; b=ptwhL60B4MxWMTzM25uodz
        IkogQwuWgUJP/v8iZ7PXjJ6I12hywhkPi8d+LTfygCeOg0wxiOieTT76s3K2Eqj9
        ivJMyMqY7W+A2s3R2hDOP3mus1zgPdg3ZdWH1FIMa02FrDx4JN+9Qae6e254dQGE
        03QevBHXOoOQKwG7gWGrdNehw9IOgGLib1e9NaD04rcYbrUbGAPhzr2zrRsW/JYb
        QDNo+Bh8H6++kz91ffY0zZN+pvDueJF8bsYmJt9CftbeGsOFPLS+tccR0QGPHxOF
        4Eg+ZiePzrUDaoHd68WQbCH6velCBYzJ3M12JVPkBGQNp2RqoZiugWOe4M0B7Pqg
        ==
X-ME-Sender: <xms:IANUXipM5JTxDwu49Vujs3aDe9J2kfClndNAzaBC92fHpJSEA6AWKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrledtgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecukfhppeeije
    drudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:IANUXmp7QqMm7s9L5g5N6L0sPVJW_r0XOWycY4QoLneW3fhDf1W7Dw>
    <xmx:IANUXjqx5KJgYcxHryI-SKAjbr950yVGNslt8XekyZyRPoi8ROV7BA>
    <xmx:IANUXneyfvS8xOQgVh7OVW903tnqaNMB9S3oBA37TRpidP8Bj4c0Sg>
    <xmx:IANUXs8pfOe-spo8i1ilI_clK-rsqARtUUYWBSVXjchhkFwmi_VqTw>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id F15E33060FD3;
        Mon, 24 Feb 2020 12:08:47 -0500 (EST)
Date:   Mon, 24 Feb 2020 09:08:46 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: Deduplicate io_*_prep calls?
Message-ID: <20200224170846.o54p2uv4qv4arygj@alap3.anarazel.de>
References: <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
 <065ee992-7eaf-051a-e8c5-9e0e8731b3f1@kernel.dk>
 <746b93f0-d0b5-558a-28c7-a614b2367d91@gmail.com>
 <c17acad2-89f6-b312-f591-c9e887b4fc2b@kernel.dk>
 <ad07fe70-ea45-a1bf-21c3-9af241bdef15@gmail.com>
 <b9901cca-caab-2261-2482-9bf9f81d589d@kernel.dk>
 <aacab312-9768-3784-0608-40531e78ee2b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacab312-9768-3784-0608-40531e78ee2b@gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-02-24 19:18:26 +0300, Pavel Begunkov wrote:
> On 24/02/2020 19:02, Jens Axboe wrote:
> >> Usually doesn't work because of such possible "hackier assignments".
> >> Ok, I have to go and experiment a bit. Anyway, it probably generates a lot of
> >> useless stuff, e.g. for req->ctx
> > 
> > Tried this, and it generates the same code...
> 
> Maybe it wasn't able to optimise in the first place
> 
> E.g. for the following code any compiler generates 2 reads (thanks godbolt).
> 
> extern void foo(int);
> int bar(const int *v)
> {
>     foo(*v);
>     return *v;
> }

Yea, the compiler really can't assume anything for this kind of
thing.
a) It's valid C to cast away the const here, as long as it's guaranteed
   that v isn't pointing to to actually const memory.
b) foo() could actually have access to *v without the argument,
   e.g. through a global.
and even in the case of a const member of a struct, as far as I know
it's legal to change the values, as long as the allocation isn't const.

Greetings,

Andres Freund

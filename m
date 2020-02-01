Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9C314F933
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 18:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgBARuC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 12:50:02 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:52641 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726169AbgBARuC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 12:50:02 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id B19EB4DA;
        Sat,  1 Feb 2020 12:50:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sat, 01 Feb 2020 12:50:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:in-reply-to:references:mime-version:content-type
        :content-transfer-encoding:subject:to:from:message-id; s=fm3;
         bh=5TS5hi759PYWt+b/cjO+GMljg99HKUs0hvz9QQqZ4MI=; b=ZZ6iCw6fGIle
        HUIexnZhqHLVwMkKMpGfC7HRQMHmA5/tBhqWID5sb4CzJrmW6N0D+701MiNdOjNf
        zFkbvqoIgqlzCh/Zd+TSX4BadPKNPt7NvvVjSbit3Ga/Qe2vk8W3tLHLzFZohvpH
        L0jQ0dXnItpqDnVy/1WNUOT1OobpxkhC/Yv07xHThJ+RO2YOrIxHDIAEwAgrkR3V
        Fskx3tv1gtnq8YeOVwAAFTZ1iyoc4OG+zZ3MvOsND8uG4m6+WCNY3X/QHBR+GrdA
        eoHU0nD+KFe/bO1j680NmMPOdJ25wZ6ePTsZTXuRL8WglO31cJglUExxgQqzs9dr
        aktmMREs9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=5TS5hi759PYWt+b/cjO+GMljg99HKUs0hvz9QQqZ4
        MI=; b=SsvMrnPVRjFsA+77e9NtfUoWpssXVKfBEQdfWflO6tnGwaIDP8FDz41wp
        mYpq7cWUZU532qT19xTZjQlbutrDUNWQ/1BmSTo/v9JXXHVEE1o0acKMzJcHIdFh
        lNuZhX3BRXYAr45i+AjnsnYRWcQDc6BN2Dj+myuu02sVjYERXz1aLdwhtnJFG1iv
        MLMhWG0H6Eb1sChgkop+EqD87IQJnqfOqHy0E+F/G9x2isAzHyoZK8UNrRl4JuWe
        h1mrZU3ws3ZNMGhrsEyOY71JIQYopszSxc3OlZAKJu8XhpYHZcLIeMGky+bSaHs/
        O9+7yS6Gr1h/GCt+Y9gugP6FVJZJA==
X-ME-Sender: <xms:SLo1XsS-gAo5Cp7TqhRDsAv2GiaTwW2L9zrfFpGaO99PIWb4-HCgTQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrgedvgddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepffgfjghfgggtgffuvffhkfesthhqmhdttderjeenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecukfhppe
    dujedvrdehkedruddtjedrudekieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:Sbo1XuBGCpopsCbusvqX1-HmliXNYTYmsZAxb0_T2g_X04Olw7zWZA>
    <xmx:Sbo1Xk1aOCpPmvck62tFrA25mC7RroD5oX40-WK519jGk3Fo8bl-Fw>
    <xmx:Sbo1XkWqGq9-rj04A2jPqSQtJ6w7qUTIfrVGTY6qkXZ6thHkPoBPAA>
    <xmx:Sbo1XhdxDYGh8mzRQBgJN4mJHvRluJqtsQJ6Sg6EB8-2Cg2SiCbilQ>
Received: from [100.170.113.13] (unknown [172.58.107.186])
        by mail.messagingengine.com (Postfix) with ESMTPA id 78415328005A;
        Sat,  1 Feb 2020 12:50:00 -0500 (EST)
Date:   Sat, 01 Feb 2020 18:49:53 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <ed2fd00f-b300-6d9d-a6d5-f76bbc26435a@kernel.dk>
References: <20200201125350.vkkhezidm6ka6ux5@alap3.anarazel.de> <ed2fd00f-b300-6d9d-a6d5-f76bbc26435a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: liburing: expose syscalls?
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
From:   Andres Freund <andres@anarazel.de>
Message-ID: <78A9EC3E-0961-4EF3-A226-1FCA34FAF818@anarazel.de>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,=20

On February 1, 2020 6:39:41 PM GMT+01:00, Jens Axboe <axboe@kernel=2Edk> w=
rote:
>On 2/1/20 5:53 AM, Andres Freund wrote:
>> Hi,
>>=20
>> As long as the syscalls aren't exposed by glibc it'd be useful - at
>> least for me - to have liburing expose the syscalls without really
>going
>> through liburing facilities=2E=2E=2E
>>=20
>> Right now I'm e=2Eg=2E using a "raw"
>io_uring_enter(IORING_ENTER_GETEVENTS)
>> to be able to have multiple processes safely wait for events on the
>same
>> uring, without needing to hold the lock [1] protecting the ring [2]=2E=
=20
>It's
>> probably a good idea to add a liburing function to be able to do so,
>but
>> I'd guess there are going to continue to be cases like that=2E In a bit
>> of time it seems likely that at least open source users of uring that
>> are included in databases, have to work against multiple versions of
>> liburing (as usually embedding libs is not allowed), and sometimes
>that
>> is easier if one can backfill a function or two if necessary=2E
>>=20
>> That syscall should probably be under a name that won't conflict with
>> eventual glibc implementation of the syscall=2E
>>=20
>> Obviously I can just do the syscall() etc myself, but it seems
>> unnecessary to have a separate copy of the ifdefs for syscall numbers
>> etc=2E
>>=20
>> What do you think?
>
>Not sure what I'm missing here, but liburing already has
>__sys_io_uring_enter() for this purpose, and ditto for the register
>and setup functions?

Aren't they hidden to the outside by the symbol versioning script?

Andres
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E

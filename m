Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0342A949A
	for <lists+io-uring@lfdr.de>; Fri,  6 Nov 2020 11:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgKFKoc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Nov 2020 05:44:32 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:42593 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726010AbgKFKoc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Nov 2020 05:44:32 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id F2FB512D8;
        Fri,  6 Nov 2020 05:44:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 06 Nov 2020 05:44:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=luisgerhorst.de;
         h=from:to:cc:message-id:date:mime-version:content-type; s=
        mesmtp; bh=5G+T/V0WCUhcJscek/9OEUGZHCZrMrYv3GbUjokHwsU=; b=B5G5l
        k/ZMfBr8iKfLwuXLOWVelDwVsuGPM7lGf5jBThJ/DA+K7asZCmQj7+A7IzqEenhD
        /ja0FDDMSK/no4Bxx4nDNFscOnCZNB+lPvTbvGzDfX4/iFQix0VZInQOXCKxiyCL
        1pU/akq//z03Fh42BEoQZheSEMP+v+79gQjmhM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:message-id
        :mime-version:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=5G+T/V0WCUhcJscek/9OEUGZHCZrMrYv3GbUjokHw
        sU=; b=ELXRAtzT1XTweZtPkfHRl231HCduuz2ZvPFNxR6BxRJ1DaBT5Qc8EZYOt
        z528dFBIEWpURFiEtV3OrWUb5y+GrbiHK58RQlSPryNujy/X2fDdDuySxxHuD5Y3
        +1o9njCcYHEoV/NjSKwMh/2lr7U4VpZ7pOAsC0ljVhnF1Lj5Y4DBuSuYO7pS+WoM
        q7jYdeAREnuraGtsv6M8HaVLU9ddKInrKLaeL3PzP5tGmPNIlXV1vBLtwBStKGVq
        6SO6OK/WZtm7b6kyZ9Xyigc5D9GKNiPJTLS4yuHY9sfl8nz4HRDmBnu84FnlIpod
        WFowucUI3bum4+z1Gleq8Mu0oTbIQ==
X-ME-Sender: <xms:DSmlXzyUuVCKf0Abb01dlwGjXbtoJbMyxyn0fUBw-qzcdVILRfe2uQ>
    <xme:DSmlX7QheBEZqX6IFB9EsSCte2NAktwHEl-iufnt-4gTgumcsiUdeT2U7PIV5m2Ff
    Ge8TxZScfLyUEBskQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtledgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucfgmhhpthihuchsuhgsjhgvtghtucdluddtmdenuc
    fjughrpefhvffkffggtgesthdtredttddttdenucfhrhhomhepnfhuihhsucfivghrhhho
    rhhsthcuoehlihhnuhigqdhkvghrnhgvlheslhhuihhsghgvrhhhohhrshhtrdguvgeqne
    cuggftrfgrthhtvghrnhepieefkeelveegieetjeehheetjedtgeevgeeltdfgffejjeeg
    uedugeegkeekveefnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpghhithhhuhgsrd
    gtohhmnecukfhppeelhedrledtrddvvddtrdeiheenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehlihhnuhigqdhkvghrnhgvlheslhhuihhsgh
    gvrhhhohhrshhtrdguvg
X-ME-Proxy: <xmx:DSmlX9Vpvn9HAVrWoOnZxn_3cIeWlBzqbkgkl6l3PtKJbQQfquwxWQ>
    <xmx:DSmlX9jZZwLvNHa99CyfXhw8q32ZWPCYquM9WiNvmlf7tv-iWpD7Pw>
    <xmx:DSmlX1CVU7NQwX9qxw0c6qFvl5O9L1sKJbVsy6BfFjLTWA0D6Q-fKA>
    <xmx:DimlX4P83QhhNNR1TZdBiYilTBOa5Qw_53lqHr1Br6RI_Uaoq20cXQ>
Received: from luis-mbp.fastmail.com (ip5f5adc41.dynamic.kabel-deutschland.de [95.90.220.65])
        by mail.messagingengine.com (Postfix) with ESMTPA id C76A0306005E;
        Fri,  6 Nov 2020 05:44:28 -0500 (EST)
From:   Luis Gerhorst <linux-kernel@luisgerhorst.de>
To:     asml.silence@gmail.com
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org, metze@samba.org,
        carter.li@eoitek.com
Message-ID: <m2ft5m69z4.fsf@luisgerhorst.de>
Date:   Fri, 06 Nov 2020 11:44:27 +0100
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Pavel,

I'm from a university and am searching for a project to work on in the
upcoming year. I am looking into allowing userspace to run multiple
system calls interleaved with application-specific logic using a single
context switch.

I noticed that you, Jens Axboe, and Carter Li discussed the possibility
of integrating eBPF into io_uring earlier this year [1, 2, 3]. Is there
any WIP on this topic?

If not I am considering to implement this. Besides the fact that AOT
eBPF is only supported for priviledged processes, are there any issues
you are aware of or reasons why this was not implemented yet?

Best,
Luis

[1] https://lore.kernel.org/io-uring/67b28e66-f2f8-99a1-dfd1-14f753d11f7a@gmail.com/
[2] https://lore.kernel.org/io-uring/8b3f182c-7c4b-da41-7ec8-bb4f22429ed1@kernel.dk/
[3] https://github.com/axboe/liburing/issues/58

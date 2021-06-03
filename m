Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D13739AAA1
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 21:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhFCTF2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 15:05:28 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57431 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229576AbhFCTF0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 15:05:26 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 0EDDD5C01B2;
        Thu,  3 Jun 2021 15:03:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 03 Jun 2021 15:03:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=i85yA63Hrpapc8XvmqBhkPew63p
        noUlzHiEl9Tj5xH4=; b=R2VsRxEmcPP9SiXDiwUNTvFUz2CZlwdItv96yx+/YaL
        l6ZMUhgpVpeYCmLaoR5JK8G94pa5KhIju75m/yWnKJfL+TIsOhGjIknGFfXEUzYZ
        PudkgZ/ajaceIrg/d2okNNsnF2chVWwTMFRgFLLZ9JAM6EXZ/bxS1wW6y0CHbu2h
        NxStF62/Yu3PAJ5gmylv1RksyBNzcwH9lCfszACCt5KXLB+dbMpHVZ2DK6Xo+P9/
        ytGhdpoRDz/NjY63jh3tNCG2nOMLk71ePoZJ3JIvf8KNpXUc1kVZ+Arx15c+M99x
        Bzu1Eb70NRFTKjD88TvoHWhIkwelzzO4rOgBqqeNduQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=i85yA6
        3Hrpapc8XvmqBhkPew63pnoUlzHiEl9Tj5xH4=; b=S/gB/ekYPaxAWdhcDgbNCA
        79YEGmeVhIfVtX0DVWrkFJCEtkynv2eRFByX9pIlfXJMTwCMLJ9o34K2oVG+aofE
        1w7ngeS/gwzd5yVXkjI5AMeNyhn6pr/SRupmWsDqMC9psvBOkj8pV0W8WDHqPUyU
        qP0pvIrDv+j17OUxd1+BRZJVhpYfGeRiwOj3xltvNddtI930jC7j2ysIxzzrHMzn
        dQMxd7vSIVWR/4jJUZQJdjC+c31pYs049RjgOYopElLZqWYAIwordXVm/wss3myl
        /O8xWL/s21TOpWrrklaw9qNWfxDr075vHqisFgID44AkNI05H3Y3xGzoSWgMGX9g
        ==
X-ME-Sender: <xms:jCe5YNFaf8DCymtlKS6doxUCxkyP-qSZfsK69AmiPm6BKBbGQnxOHg>
    <xme:jCe5YCWNc6DweONlxyMXlMnsgltqyJ-Mequhb-Ipe9It7QWWTJUPtx7HpTBgHuW-O
    5Rajr19zZ4RjLksNA>
X-ME-Received: <xmr:jCe5YPKufk2LFFCg_RWtaFy3kjeGlF-IpulQ74nJV5gN7XTI8NLcIzSE1Pj4Ykjn5BE5phqw_DP1Xh4Xb74w8UIIisJIkRupCCZPvKccaHjpHM5uOZN-8W-VBTw3>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdelledgudeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrf
    grthhtvghrnhepudekhfekleeugeevteehleffffejgeelueduleeffeeutdelffeujeff
    hfeuffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:jCe5YDFVGThhiLHb65EDXfUWCv9W6XSwcykTaz06JtxTFbLvqQXpOA>
    <xmx:jCe5YDUQw-gKUcpyQmw2BLH6S7ODhUzmDcgIvFHmuwVxY3yYeUq8CQ>
    <xmx:jCe5YOMgYMMAa7xu9xqs21euUoeiFx2qv9A0Fb94FI9R8w5XrDa7Dw>
    <xmx:jSe5YKGqnmt7mk3u_4pKgzQLRcuOWuvZ604vAhF3rlUbmx5ZmYUsmQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Jun 2021 15:03:39 -0400 (EDT)
Date:   Thu, 3 Jun 2021 12:03:38 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/4] io_uring: implement futex wait
Message-ID: <20210603190338.gfykgkc7ac2akvdt@alap3.anarazel.de>
References: <cover.1622558659.git.asml.silence@gmail.com>
 <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com>
 <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk>
 <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com>
 <bdc55fcd-b172-def4-4788-8bf808ccf6d6@kernel.dk>
 <5ab4c8bd-3e82-e87b-1ae8-3b32ced72009@gmail.com>
 <87sg211ccj.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sg211ccj.ffs@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-06-01 23:53:00 +0200, Thomas Gleixner wrote:
> You surely made your point that this is well thought out.

Really impressed with your effort to generously interpret the first
version of a proof of concept patch that explicitly was aimed at getting
feedback on the basic design and the different use cases.

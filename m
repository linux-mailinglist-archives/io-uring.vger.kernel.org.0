Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8892A94B1
	for <lists+io-uring@lfdr.de>; Fri,  6 Nov 2020 11:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgKFKua (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Nov 2020 05:50:30 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:32989 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727080AbgKFKua (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Nov 2020 05:50:30 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 9C8841347;
        Fri,  6 Nov 2020 05:50:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 06 Nov 2020 05:50:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=luisgerhorst.de;
         h=content-type:mime-version:subject:from:in-reply-to:date:cc
        :content-transfer-encoding:message-id:references:to; s=mesmtp;
         bh=o3ylYpjz4ImHuuosfUblUCMr9jLzoTQmkRh2wF+lUAk=; b=otpzeVPwCS8A
        akEklYH0+WyIUreJoPSvW3j1IXcoiReAz4go3QVv0urLWkShi23KOgY25jAVVVM9
        L8HzEipFiw+lsqan2ImGL/WEK2YhrFPITBYR4JqahEOa3JNUUFGDsGLkKpRHSvO+
        UXg5MEhM80orOdgojq8wnbOAEUQPtT4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=o3ylYpjz4ImHuuosfUblUCMr9jLzoTQmkRh2wF+lU
        Ak=; b=YcOHEfb+YLhUztJSlunpAbKoahu0CCeTYBkDZDPLYdKEx0nvQv8JIhwVM
        P137nIsM9yomd2eor2/n9dB3QDleTsn5A0O6l5hG3kMiwFGmlxkDoyaGTO84l28a
        /OMNicV6RuMxwGGH1/fu4z7DptLVAmaeLIIsIWpgvmAJf94HtGGaaFncEZs/gCSg
        BtFkaOw1Tng/eZMOX3hQk6Ptv9EjVy/x9mAdkjxB4y659KHnjVHlripY68Jk5ZBy
        gX+3LK/O/ibgJX67T9iIzl7cTJ3SmSgpSqI0Uv/K6+fzZE1XD6Q5/KPnF8Y7j+G6
        RtSaaxUzvZ2t8mAje2G1aqQSNLhHw==
X-ME-Sender: <xms:dCqlX2XaH5CS8nPC5kea6sEC0hazO4Y_q49cuteUihhVUmKfG0HjTA>
    <xme:dCqlXynX2C6Mg0CExzKc837K16lb4bs24Lh62FMN0sjaQoiugRyBNFPdXfdp4ORD3
    a32SlZ5TkclAAbGDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtledgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpegtggfuhfgjfffgkfhfvffosehtqh
    hmtdhhtddvnecuhfhrohhmpehlihhnuhigqdhkvghrnhgvlheslhhuihhsghgvrhhhohhr
    shhtrdguvgenucggtffrrghtthgvrhhnpefhveegtdekheeuleeukeeguefhieduheefve
    egheehteevvdfgvefftefghfeuveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhg
    ihhthhhusgdrtghomhenucfkphepleehrdeltddrvddvtddrieehnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheplhhinhhugidqkhgvrhhnvghl
    sehluhhishhgvghrhhhorhhsthdruggv
X-ME-Proxy: <xmx:dCqlX6bKzqLKWwYqvH3qwq5FPGo3-Va7EU36GRVMlXgfirCCJby5rQ>
    <xmx:dCqlX9XYCCba-YZsrkzmIxy0-O46ZnnYkdOuWvWmM-Zahm2GCfdBTQ>
    <xmx:dCqlXwl1M_vwKsDlYSgLA_xHoiw0J8zGct8knSbLe0Qh26cbtlS7fA>
    <xmx:dSqlX1y6apVLS0sspg7PItw-wM5t__1snIdFswuIGv5m7fDIRbBzjA>
Received: from [192.168.0.160] (ip5f5adc41.dynamic.kabel-deutschland.de [95.90.220.65])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89F8E328037B;
        Fri,  6 Nov 2020 05:50:27 -0500 (EST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Integrating eBPF into io-uring
From:   linux-kernel@luisgerhorst.de
In-Reply-To: <m2ft5m69z4.fsf@luisgerhorst.de>
Date:   Fri, 6 Nov 2020 11:50:26 +0100
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org, metze@samba.org,
        carter.li@eoitek.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <1AD7207C-831D-4CA7-A759-67913129E555@luisgerhorst.de>
References: <m2ft5m69z4.fsf@luisgerhorst.de>
To:     asml.silence@gmail.com
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Forgot subject, sorry.

> On 6. Nov 2020, at 11:44, Luis Gerhorst <linux-kernel@luisgerhorst.de> =
wrote:
>=20
> Hello Pavel,
>=20
> I'm from a university and am searching for a project to work on in the
> upcoming year. I am looking into allowing userspace to run multiple
> system calls interleaved with application-specific logic using a =
single
> context switch.
>=20
> I noticed that you, Jens Axboe, and Carter Li discussed the =
possibility
> of integrating eBPF into io_uring earlier this year [1, 2, 3]. Is =
there
> any WIP on this topic?
>=20
> If not I am considering to implement this. Besides the fact that AOT
> eBPF is only supported for priviledged processes, are there any issues
> you are aware of or reasons why this was not implemented yet?
>=20
> Best,
> Luis
>=20
> [1] =
https://lore.kernel.org/io-uring/67b28e66-f2f8-99a1-dfd1-14f753d11f7a@gmai=
l.com/
> [2] =
https://lore.kernel.org/io-uring/8b3f182c-7c4b-da41-7ec8-bb4f22429ed1@kern=
el.dk/
> [3] https://github.com/axboe/liburing/issues/58


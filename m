Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF42222CA3
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 22:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgGPUUG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 16:20:06 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:50197 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728788AbgGPUUG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 16:20:06 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 49442FC0;
        Thu, 16 Jul 2020 16:20:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 16 Jul 2020 16:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=qfgNIC42NOB5kPR3PBqlqX5LDBZ
        3P4P3pWgAu3K1pRI=; b=DP/kkoYvry1u+T9LK/pQ9vANimHgXnzEEzS9trOtXWr
        ACrYvHlkyhOXsa52OWY2s++5H/egMhVlvx1/pCMyNmcGFq+CIb/wIQtmP3/UOOpf
        L8Y8/3Gn9TEjDpPW1m0BjynLQHmZHQtujwc+HjDXOQYvh7gxpdlRU96q7is1WkbY
        Nd22C7a4Wd3PLQaASUr2usT6r/8Yg4PMgLCdwuWSsBcY+/wonzZKZhiKnGsExGLp
        igNW58RzEsRZx7fBezPHZ9G/GpjNEjMQoiPr6gshZw/X9EVh8Hjm/z3glsKxf06w
        b/aRmpvbBYBDMCx8q3d7BpQ0AR6yqAGlsFoSYc6dzdg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=qfgNIC
        42NOB5kPR3PBqlqX5LDBZ3P4P3pWgAu3K1pRI=; b=d6PNevcZn28F32gibVKsHj
        8SY4Vt+KmLR6ofLtxYpQz9v+hrp3jBBl9spuS1S1NCljGHV17/3zo1UAILDefUud
        DQ85jAGJpFUPQLOpuLZzqH1TnMawjEVmy0XsHAyzLqBbqX1jYIH31SRKY4S6Rm/d
        NgW8Rz3M5e+g3+4kvlbHl0BBJ4G4u9OuuhZg2bhgdZkl5+1jndifmmf8B3UGHpJj
        NuigXYoug2yzSjuXZdYPe1ZbEItBIoh3NiQq2airmYihpIXJiMJVrYqedO7vKS8b
        smv6+UCsmTsEnybQHQdZcpVVUWmv7MnxHqKZMfyzrK5Te4M1LDM/DaLfL6ciKnXA
        ==
X-ME-Sender: <xms:dLYQX_31MjlUG79PuZnMyNbhiVmOgZfakSm9mDUkfgR2lqximceyJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfeeggddugeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedukefhkeelueegveetheelffffjeegleeuudelfeefuedtleffueejfffh
    ueffudenucfkphepieejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdr
    uggv
X-ME-Proxy: <xmx:dLYQX-Em5paH_Dtf-N8nkg2ECR0myrgJoOm9CXGAegYu8KiyRLMaNw>
    <xmx:dLYQX_4LufPHcDyCw-vbk-3ws2WcVrPoXTo2hXT5h_vMBLUgjIN7Eg>
    <xmx:dLYQX027m53rBtXuYEDjx3nZGrwnnYQL-q3Qw8ESEvTEOHxk4kAnYw>
    <xmx:dLYQX9z0GTOF79W6-PZvbQ-vOKwf8GYXJoYC5e9uQ0vLa1AKciG1ow>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5AD1B328005A;
        Thu, 16 Jul 2020 16:20:04 -0400 (EDT)
Date:   Thu, 16 Jul 2020 13:20:02 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: io_uring_setup spuriously returning ENOMEM for one user
Message-ID: <20200716202002.ccuidrqbknvzhxiv@alap3.anarazel.de>
References: <20200716200543.iyrurpmcvrycekom@alap3.anarazel.de>
 <af57a2d2-86d2-96f7-5f63-19b02d800e71@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af57a2d2-86d2-96f7-5f63-19b02d800e71@gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-07-16 23:12:41 +0300, Pavel Begunkov wrote:
> On 16/07/2020 23:05, Andres Freund wrote:
> > Hi,
> > 
> > While testing the error handling of my uring using postgres branch I
> > just encountered the situation that io_uring_setup() always fails with
> > ENOMEN.
> > 
> > It only does so for the user I did the testing on and not for other
> > users. During the testing a few io_uring using processes were kill -9'd
> > and a few core-dumped after abort(). No io_uring using processes are
> > still alive.
> > 
> > As the issue only happens to the one uid I suspect that
> > current_user()->locked_mem got corrupted, perhaps after hitting the
> > limit for real.
> 
> Any chance it's using SQPOLL mode?

No. It's a "plain" uring. The only thing that could be considered
special is that one of the rings is shared between processes (which all
run as the same user).

Greetings,

Andres Freund

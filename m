Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B32228990
	for <lists+io-uring@lfdr.de>; Tue, 21 Jul 2020 21:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbgGUT4H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jul 2020 15:56:07 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:44937 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730664AbgGUT4H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jul 2020 15:56:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 1D38EB24;
        Tue, 21 Jul 2020 15:56:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 21 Jul 2020 15:56:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=AqPj1xBhDhu20FWDwJyJBEuqNaN
        WXORj4eQ/tBPqOlo=; b=fimQshPgm3sthCqApa+djmcfCkLSFwHY7QblvbjAlcv
        fPAeBpiKsqs0mi3QLh/mXmVgdoJGl9yF7GQdobNdc899gi75MM7QXJSWdeGAzP7s
        pSqG/bclBObeMUkxz/dRBESdzacl39lEoopnuJpHNa6X9FXj5KSV36Yywu6LzFHw
        3zpOiEbxa7VY7ly3+0eWQJu/UGasSNqBBg0G6xEinO3fsdd0gj2taDBAEmvjobeS
        K5vsV8vy83764Ae5qR8ReCf/r3JLq6FCORMmJgZ/60QZzT4RIZEmQ0fN3oZb/CbS
        N9buoYDtMl3zFfWbIKyZrEurHDEhE/bkHpvmbn4Yutg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=AqPj1x
        BhDhu20FWDwJyJBEuqNaNWXORj4eQ/tBPqOlo=; b=K/5IJJUrbwW7dfc8maPE+b
        At1jqzRMcstf7E7PyDytihqi9rgeeXyx3p0UJTKG3eIJTnB02AAm+JC3CkttZ1Nd
        N5rkxvIOVIKX0sXbOw6Xl0dJ6Si2ntASsU/3OSsxiTrWjuz7m829nn7ktLAS9vJj
        1vx11jy/npcDV7Jc2zUTA74XOI1Kmtnw2OEoJCMvdXazgipT2WxsWbJ/ij9/DyHu
        FIVXQ2b1z72wtETwOJ6brF9P0Z/Q6A/Gve6m0KxtOEyKNilXxL0FjJn1JKD6gl/m
        d08EhKLjB0eiZWiicGMDLi507bD9Gf4F9WbkBlx52akc8iLr8JJURQhViOaQIvjQ
        ==
X-ME-Sender: <xms:U0gXX1BbjEuZJLnXVBMnFHroxMl5BibM0qAtr6bkg7dMLo4sON80Vw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeejgddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrth
    htvghrnhepudekhfekleeugeevteehleffffejgeelueduleeffeeutdelffeujeffhfeu
    ffdunecukfhppeeijedrudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdgu
    vg
X-ME-Proxy: <xmx:U0gXXzjdghqmMlw7WediaYzLllFxn2LxGNJllOUpgDSuqZ-hxCZbKg>
    <xmx:U0gXXwnZeFN_lhM63aiWn5O1_93UPi2dBowYmfp_xaeVgadEQpVMcg>
    <xmx:U0gXX_zqoUSlbBlfwdJaX8O4ZT4TRWw2jROrdu-Ebqc34t548T75Xw>
    <xmx:VEgXX0CFoh3getAHlxnjfGPVIDQ-t-68uLE8Ky6zUZaCy3MT4-sknx5BgGI>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 655F930600B1;
        Tue, 21 Jul 2020 15:56:03 -0400 (EDT)
Date:   Tue, 21 Jul 2020 12:56:02 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kees Cook <keescook@chromium.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Matthew Wilcox <willy@infradead.org>,
        Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        strace-devel@lists.strace.io, io-uring@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: strace of io_uring events?
Message-ID: <20200721195602.qtncgzddl7y55b6l@alap3.anarazel.de>
References: <20200716131404.bnzsaarooumrp3kx@steredhat>
 <202007160751.ED56C55@keescook>
 <20200717080157.ezxapv7pscbqykhl@steredhat.lan>
 <CALCETrXSPdiVCgh3h=q7w9RyiKnp-=8jOHoFHX=an0cWqK7bzQ@mail.gmail.com>
 <39a3378a-f8f3-6706-98c8-be7017e64ddb@kernel.dk>
 <CALCETrXAxFzuRB5EJZR7bbgfrEcNc=9_E7wwhPaZ3YGJ1=DZ0w@mail.gmail.com>
 <ba989463-c627-8af7-9234-4dc8ac4eea0e@kernel.dk>
 <CALCETrUvOuKZWiQeZhf9DXyjS4OQdyW+s1YMh+vwe605jBS3LQ@mail.gmail.com>
 <65ad6c17-37d0-da30-4121-43554ad8f51f@kernel.dk>
 <CALCETrV_tOziNJOp8xanmCU0yJEHcGQk0TBxeiK4U7AVewkgAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV_tOziNJOp8xanmCU0yJEHcGQk0TBxeiK4U7AVewkgAw@mail.gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-07-21 12:44:09 -0700, Andy Lutomirski wrote:
> Can you enlighten me?  I don't see any iov_iter_get_pages() calls or
> equivalents.  If an IO is punted, how does the data end up in the
> io_uring_enter() caller's mm?

For operations needing that io_op_def.needs_mm is true. Which is checked
by io_prep_async_work(), adding the current mm to req. On the wq side
io_wq_switch_mm() uses that mm when executing the queue entry.

Greetings,

Andres Freund

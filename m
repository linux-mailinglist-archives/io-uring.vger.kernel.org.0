Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F347F14FC1A
	for <lists+io-uring@lfdr.de>; Sun,  2 Feb 2020 08:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgBBH1g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 Feb 2020 02:27:36 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53463 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgBBH1g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 Feb 2020 02:27:36 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 4009621CDA;
        Sun,  2 Feb 2020 02:27:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 02 Feb 2020 02:27:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=fOEmjL7thS5GqJSW6mTy3gfGXpt
        pTdC1c1vk2HGKB0A=; b=FzG8VGTkfr9gRQEIJxaXZsp11/gDgY9OQY+4rTT7cSV
        zrLoyJzKfunxxOpV21rNgIbvJ+p/MWL7Mfm2NWslmXw35DarhH0P3NCIBK+4wWh3
        aH/bahrh1GTMRcse48cD+Wbh2cqGjxnQz8NI7dviJcc9CU3audb+9IchJV4ry+Ea
        cqB4U76onsSoZBF59qI27mEt93Bh+aTZkyI/dqMAb91fGfJSpUdKkyGHx4brHDrb
        Afn84JYUyzOkIcRkoZOmY/I69gwcyOW2FB+Ap3NO7PfdNBuUzg0CsTUau0rp5ExQ
        8sx5hG0Wg1JTkKYmlwpRuGXFAKurj1AvwmkHMlbzhNQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=fOEmjL
        7thS5GqJSW6mTy3gfGXptpTdC1c1vk2HGKB0A=; b=MzVg1sbkn3aLRzL7w6t7W9
        C98rla5eJ0QHGfNnthDRQc1mPq47UrtxqQfjO/mWLWoKL0LShKnWCoPKnSDsCxFs
        jscLM1XyQ6kLIqzCbApcC98rWvRDK+I8dN4wB27A6BecHK0eYQAVgj6muPtScuV/
        PoOybw2hx2//kl304vpIEAjuMNqTeYdH+fj+yf6sMvtfvRCn8kWmVee1d4ieGLFN
        BINP5Yf89sA0779GYvxCKZ7gKdlDpxG6e5boQNHOyJvdjodXeAUn3vMynlRdY5hC
        Ah6EspR0ik/+Z3D12GbYjN2ApQD3Tnu1+ijG39xyh7rUqAlUtbh0cWGJQpW/rl8w
        ==
X-ME-Sender: <xms:5nk2Xll4Qvx4seleZnaiUv0fU39nJc8xlDS9y1RMDcsGsjj3aqicUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrgeeggddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecukfhppedvud
    dvrdejiedrvdehfedrudejudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:5nk2XhtIvJ9bgROSmc5w6CCi71CHvsixWIAi8uX7tanoU-bB2hwOJA>
    <xmx:5nk2Xv2gXwE73F0WYCQmZu1ptgTXdkSMRayurV2RLzRKlpUCczcTQQ>
    <xmx:5nk2XoZU7MjhrMAfJH3Ulz-0iEM4C0sdqHYbNp3B2XIy9SG8Y9RiYg>
    <xmx:53k2XlvNrFSdDrh7G7qnSKbo5JWkH4zuRgtxBJ0lRbTOWcf6vkGatA>
Received: from intern.anarazel.de (unknown [212.76.253.171])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4B0E8328005A;
        Sun,  2 Feb 2020 02:27:34 -0500 (EST)
Date:   Sat, 1 Feb 2020 23:27:33 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: Re: liburing: expose syscalls?
Message-ID: <20200202072733.ioqdel36se2tgk3i@alap3.anarazel.de>
References: <20200201125350.vkkhezidm6ka6ux5@alap3.anarazel.de>
 <ed2fd00f-b300-6d9d-a6d5-f76bbc26435a@kernel.dk>
 <78A9EC3E-0961-4EF3-A226-1FCA34FAF818@anarazel.de>
 <aac42d1e-24d5-4c2d-d1ce-eb8ceed48b1e@kernel.dk>
 <6f5abe8a-1897-123d-d01d-d8c7c5fba7c4@gmail.com>
 <e57109e7-357f-3ab5-4fd5-0488cf2021a0@kernel.dk>
 <9644308d-ef0e-1b94-9a3b-1a4e03bfd314@gmail.com>
 <502b2b01-d691-b7bf-53f1-e7a24fb4c6d9@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502b2b01-d691-b7bf-53f1-e7a24fb4c6d9@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-02-01 20:29:39 -0700, Jens Axboe wrote:
> On 2/1/20 4:30 PM, Pavel Begunkov wrote:
> > On 02/02/2020 01:51, Jens Axboe wrote:
> >>>> So you just want to have them exposed? I'd be fine with that. I'll
> >>>> take a patch :-)
> >>>>
> >>>
> >>> Depends on how it's used, but I'd strive to inline
> >>> __sys_io_uring_enter() to remove the extra indirect call into the
> >>> shared lib. Though, not sure about packaging and all this stuff. May
> >>> be useful to do that for liburing as well.
> >>
> >> Not sure that actually matters when you're doing a syscall anyway, that
> >> should be the long pole for the operation.
> >>
> > 
> > Yeah, but they are starting to stack up (+syscall() from glibc) and can became
> > even more layered on the user side.
> 
> Not saying it's free, just that I expect the actual system call to dominate.
> But I hear what you are saying, this is exactly why the liburing hot path
> resides in static inline code, and doesn't require library calls. I did
> draw the line on anything that needs a system call, figuring that wasn't
> worth over-optimizing.

That is my intuition too, especially in my case where I'm "intending" to
block in the kernel. I just tried locally, and at least with storage (a
Samsung 970 pro NVMe, in my laptop) in the path, runtime differences are
below run to run noise, and the profile doesn't show any meaningful time
spent in the indirection.

I don't really see a reason not to move syscall.c functions into a
header however. Would allow the to remove the syscall() indirection
transparently once glibc gets around supporting the syscall too. Given
that it's essentially just kernel interface definitions, how about just
putting it into liburing/io_uring.h?

I'll open a PR.  If somebody wants to bikeshed on using a name other
than __sys_*...

Greetings,

Andres Freund

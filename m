Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6E221424E
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2020 02:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGDAPo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 20:15:44 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49255 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726258AbgGDAPn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 20:15:43 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BF3465C0109;
        Fri,  3 Jul 2020 20:15:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 03 Jul 2020 20:15:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=DoX3R3RAs1FeXHvwWOPeTzS52wr
        bGB7Ahpu4Cy2OY6Y=; b=OGdzY5bE2Lz02HmQii9hItxpLtAAxb2MG+FTRtNTMWi
        dCUPAG7Sj9cxLMEBijKPCcjejJFUdsK4IL1+LjsYpOR1JaREz/FMZ82LzNbeytjo
        PBN/3+SPDA/I0m2KN+NiopcMlZHtee5MiVpnMjMsnylu8njAAz2CcnqrurVB4hbS
        jhLG09peiUA6tpiB99+LvVoKYlflQQFJ7Y6K9624DEs7nq30AoVXim4IzvFNEN4a
        KO/hUEVWbGfGRZa+GWdtUYgq5xotzuP67km6zCUXGQ8PXW+7uwWGYuUAObMLEv6W
        EPGW3ebL+2tWrGQB+YCyxF36Z8RobOw1aejflOQadmw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DoX3R3
        RAs1FeXHvwWOPeTzS52wrbGB7Ahpu4Cy2OY6Y=; b=T301BlL5HwckFOD5HuJZqZ
        3IT3CKgSSbai31OoxKfg0+PpOJO8zXOkjbR77Hu72FNCbkPP5eYED3BkyqyjO1hj
        aOW2Hq5fkpuzoIYOMQKhoUcF2evSxtHK4ZCB/nAb3JEnyBww/2PFvyFBl4yyd2pV
        URadW/lLGnHj4quCayzLcuyHfAb7YxpQVnFQhSHb7fxBO+x3M3niVHu2eWeXuDFE
        DtObKz/4/etL/fYBsM8CcV5IE9I1yOdxlJMywq0wunsdGFqP/pCaAadJcz0cHyIb
        VpxVQxJnKNfytVZIPKN2Zv9KGAAO/heTP4BpIl6wN/X0Z1r3os1kf2pQZgj7NbdA
        ==
X-ME-Sender: <xms:Lsr_XjuE9sbpMYjc-JO7yLVKk6BJcK8xNoaUYudS0sgDDlDeCGHadw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtdejgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrth
    htvghrnhepudekhfekleeugeevteehleffffejgeelueduleeffeeutdelffeujeffhfeu
    ffdunecukfhppeeijedrudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdgu
    vg
X-ME-Proxy: <xmx:Lsr_XkdrHYpB1RpahdUGrbXXa6jBGcQrezG-SFRbLRIngkyNJT_eAA>
    <xmx:Lsr_XmzPvKv336YToqb512fqOSdxbGAS_w4TRTjwSMtylv8elvyXVA>
    <xmx:Lsr_XiPFMubzy4QZEicrxsbDepOk1vMklQNwmb9_q5teGx-kfQUaGA>
    <xmx:Lsr_XmIbvw-MWf35vPFDyoCpxGmOeqciaLVVWf2xANT7Ae77DpTmeA>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 11E923280059;
        Fri,  3 Jul 2020 20:15:42 -0400 (EDT)
Date:   Fri, 3 Jul 2020 17:15:41 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: signals not reliably interrupting io_uring_enter anymore
Message-ID: <20200704001541.6isrwsr6ptvbykdq@alap3.anarazel.de>
References: <20200704000049.3elr2mralckeqmej@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200704000049.3elr2mralckeqmej@alap3.anarazel.de>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-07-03 17:00:49 -0700, Andres Freund wrote:
> I haven't yet fully analyzed the problem, but after updating to
> cdd3bb54332f82295ed90cd0c09c78cd0c0ee822 io_uring using postgres does
> not work reliably anymore.
> 
> The symptom is that io_uring_enter(IORING_ENTER_GETEVENTS) isn't
> interrupted by signals anymore. The signal handler executes, but
> afterwards the syscall is restarted. Previously io_uring_enter reliably
> returned EINTR in that case.
> 
> Currently postgres relies on signals interrupting io_uring_enter(). We
> probably can find a way to not do so, but it'd not be entirely trivial.
> 
> I suspect the issue is
> 
> commit ce593a6c480a22acba08795be313c0c6d49dd35d (tag: io_uring-5.8-2020-07-01, linux-block/io_uring-5.8)
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   2020-06-30 12:39:05 -0600
> 
>     io_uring: use signal based task_work running
> 
> as that appears to have changed the error returned by
> io_uring_enter(GETEVENTS) after having been interrupted by a signal from
> EINTR to ERESTARTSYS.
> 
> 
> I'll check to make sure that the issue doesn't exist before the above
> commit.

Indeed, on cd77006e01b3198c75fb7819b3d0ff89709539bb the PG issue doesn't
exist, which pretty much confirms that the above commit is the issue.

What was the reason for changing EINTR to ERESTARTSYS in the above
commit? I assume trying to avoid returning spurious EINTRs to userland?

Greetings,

Andres Freund

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5D9369474
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 16:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239051AbhDWOOH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Apr 2021 10:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbhDWOOE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Apr 2021 10:14:04 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2DAC061574;
        Fri, 23 Apr 2021 07:13:27 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id y204so24724629wmg.2;
        Fri, 23 Apr 2021 07:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+xcvu/qUqC379ECYMecXBCghxgPo0LkCVkt2Sha9gI0=;
        b=gQgwCnTzceuYX9YXXn/QOmHMV11y2gRdZn+SaqQAqce3IYcX2Wu6DPsa2XTyXMwA8c
         Vcs5xo5CfyzTiBEG8jBLci4gkAg46lPW9wOna7DHauPVw3xZ76hVSl8aOT2RQITKOgag
         SJ3JbPnHe9P+PWd+SODYhml/XsWppDUqCEI64TzAToDrmy9IB1D5Oi9nQanNpAzb6LLu
         9vOF32avT/iwL3ShCQdjSqnrC5tBgNGMHi9dhlHorSlIX4yLXMvjGkb+JbIZW/I0L9UD
         n0nou87Fi8LkD1W1jeng96D6VgE+9vAvuhe2nYqHoqTQBnPWkBDqqBhFRZdjVr5jCwKj
         2wbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+xcvu/qUqC379ECYMecXBCghxgPo0LkCVkt2Sha9gI0=;
        b=Avu4Hly2pnTL4//HJpe/jOoxGDmBauAJvgyvy/x3mLkeoo6WLvpuz1MU30+BmuHkE/
         zV9yADX5exXcrseMjZ+cCliub3Eva02iMv0IkzvDi34AaZIiqim1qN3rEugZ+BIqa8md
         +JWmnfKWV+vVvRGn2LdRlImS0CEM9acy+IlCrGWicA6cVVe11RWcy7lKWLvTjQWtjAcn
         qZAIWay9k4ieLh08Gahe0CawPsijtG2XoxkVJ7CtK7Xoq5xTXpkMnJhfphFagAFjh/Hg
         Rs1VjZtCD17yRZcCwPzvSE+dYaCDhLjNlEIxhh4acCOYqTwdPEskMNtPHZcN4vKLlsZK
         T2VA==
X-Gm-Message-State: AOAM5325oqdvhBYv/jB72PxfZ6vA2uhq1yMdzYAC7oGRJ6ffG6U/3E/b
        SKTgq80CdpNtS+lwBgXbN3rapsYu7iY6LA==
X-Google-Smtp-Source: ABdhPJwGYKqIZGrnrk6Gs4g9YAaDa7qDHh64cpdd7i8Xm82tWJs9djKmU8ZbylX1l5Vqc6GiYhAgWg==
X-Received: by 2002:a05:600c:6d4:: with SMTP id b20mr5806496wmn.99.1619187206018;
        Fri, 23 Apr 2021 07:13:26 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id j12sm9135705wro.29.2021.04.23.07.13.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 07:13:25 -0700 (PDT)
Subject: Re: [PATCH liburing] examples/ucontext-cp.c: cope with variable
 SIGSTKSZ
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     io-uring@vger.kernel.org, "H.J. Lu" <hjl.tools@gmail.com>,
        libc-alpha@sourceware.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
References: <20210413150319.764600-1-stefanha@redhat.com>
 <YH2VE2RdcH0ISvxH@stefanha-x1.localdomain>
 <CAMe9rOpK08CJ5TdQ1fZJ2sGUVjHqoTHS2kT8EzDEejuodu8Ksg@mail.gmail.com>
 <YIFJDgno7deI5syK@stefanha-x1.localdomain>
 <20210422142245.evlxjvfw3emh7ivw@steredhat>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <89aaba8e-9a39-5269-201f-83d1f96e1ec0@gmail.com>
Date:   Fri, 23 Apr 2021 15:13:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210422142245.evlxjvfw3emh7ivw@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/22/21 3:22 PM, Stefano Garzarella wrote:
> +Cc: io-uring@vger.kernel.org
> +Cc: Pavel Begunkov <asml.silence@gmail.com>
> 
> Original message: https://www.spinics.net/lists/linux-block/msg67077.html
> 
> On Thu, Apr 22, 2021 at 10:59:42AM +0100, Stefan Hajnoczi wrote:
>> On Mon, Apr 19, 2021 at 11:38:07AM -0700, H.J. Lu wrote:
>>> On Mon, Apr 19, 2021 at 7:35 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>>> >
>>> > On Tue, Apr 13, 2021 at 04:03:19PM +0100, Stefan Hajnoczi wrote:
>>> > > The size of C arrays at file scope must be constant. The following
>>> > > compiler error occurs with recent upstream glibc (2.33.9000):
>>> > >
>>> > >   CC ucontext-cp
>>> > >   ucontext-cp.c:31:23: error: variably modified ‘stack_buf’ at file scope
>>> > >   31 |         unsigned char stack_buf[SIGSTKSZ];
>>> > >      |                       ^~~~~~~~~
>>> > >   make[1]: *** [Makefile:26: ucontext-cp] Error 1
>>> > >
>>> > > The following glibc commit changed SIGSTKSZ from a constant value to a
>>> > > variable:
>>> > >
>>> > >   commit 6c57d320484988e87e446e2e60ce42816bf51d53
>>> > >   Author: H.J. Lu <hjl.tools@gmail.com>
>>> > >   Date:   Mon Feb 1 11:00:38 2021 -0800
>>> > >
>>> > >     sysconf: Add _SC_MINSIGSTKSZ/_SC_SIGSTKSZ [BZ #20305]
>>> > >   ...
>>> > >   +# define SIGSTKSZ sysconf (_SC_SIGSTKSZ)
>>> > >
>>> > > Allocate the stack buffer explicitly to avoid declaring an array at file
>>> > > scope.
>>> > >
>>> > > Cc: H.J. Lu <hjl.tools@gmail.com>
>>> > > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>>> > > ---
>>> > > Perhaps the glibc change needs to be revised before releasing glibc 2.34
>>> > > since it might break applications. That's up to the glibc folks. It
>>> > > doesn't hurt for liburing to take a safer approach that copes with the
>>> > > SIGSTKSZ change in any case.
>>> >
>>> > glibc folks, please take a look. The commit referenced above broke
>>> > compilation of liburing's tests. It's possible that applications will
>>> > hit similar issues. Can you check whether the SIGSTKSZ change needs to
>>> > be reverted/fixed before releasing glibc 2.34?
>>> >
>>>
>>> It won't be changed for glibc 2.34.
>>
>> Thanks for the response, H.J. and Paul.
>>
>> In that case liburing needs this patch.
>>
> 
> I think so:
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Right, and there are already people complaining
https://github.com/axboe/liburing/issues/320


-- 
Pavel Begunkov

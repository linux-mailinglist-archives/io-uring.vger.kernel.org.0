Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9070368261
	for <lists+io-uring@lfdr.de>; Thu, 22 Apr 2021 16:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbhDVOX1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Apr 2021 10:23:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236496AbhDVOX1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Apr 2021 10:23:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619101371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6dM3vlskxaUCVoSymQo+tBQHrfX2GxQW1OumkU4YCLc=;
        b=IDkbV92cR3h6tzXj8nMckejhxPOSznY5KdfsMUp2DS5vlsuYiLc4icbWSvE3Sz+Hp/Vm2F
        vW5aZW3cEkCnXN1Xr94OxBXYWAjUUpyI2jYgG13FEmxcQE9kYHSK08rqUefY1VMku3yQKd
        h0F4lNkqxKEQS/9EZeAoiEXqP1Un4SY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-MEap3KgBOkuugFQyDrm1RQ-1; Thu, 22 Apr 2021 10:22:49 -0400
X-MC-Unique: MEap3KgBOkuugFQyDrm1RQ-1
Received: by mail-ej1-f72.google.com with SMTP id o25-20020a1709061d59b029037c94676df5so7281285ejh.7
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 07:22:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6dM3vlskxaUCVoSymQo+tBQHrfX2GxQW1OumkU4YCLc=;
        b=RHVbDEYawyOLroGX7aLMu6Rh8xhD26BZm5zj/X8StdSlwSAr5oK3Yjbl4tbtZN3nkp
         hF+GYgAL/iCVTAcFQfftwX9p7TK1HWg1iB+IeO3CLpJf7KJ0p8oaRje7i5+AtVhOUJNs
         Hw9hAXFF3CFSIxpqYtseHBoX07gCWLCXRvj/KzATMCq3XxuhBNQr8f8kYP972S0auDPT
         nEMVkFzKfGu80KKQXjJNBSk6ko/gLpazcWC8nlCVisfk/6P1hP0mVraEArESH+WDLJrM
         BfTdBnkCq6RjoXBJAnj+59XGJCGVIQ2ZkV5+eR4FK6xCYCYsP1t9d27l/iX7ZD6CljNI
         5VFg==
X-Gm-Message-State: AOAM530k9IUHu2dc4I5Tu5EOqyGcbYZ9wGMOscsdYOPI8bT50kuefv8Y
        LzZhurUs6ScpYA2i9eKf7umQpYW1tFQm4erftL8+wpz1zuIy+NWDIIocfkqfCkLBE3pc2WoLDYS
        ZvpldI4lFXGU6dWFBn6E=
X-Received: by 2002:a17:906:60d6:: with SMTP id f22mr3627822ejk.177.1619101368045;
        Thu, 22 Apr 2021 07:22:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxg6IpTdebpcD59morQGAl2NDtrxuofK+0xAYW+6pVHquUotCJVra+jBhH6twGEGfu7JKrqBg==
X-Received: by 2002:a17:906:60d6:: with SMTP id f22mr3627797ejk.177.1619101367853;
        Thu, 22 Apr 2021 07:22:47 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id ws15sm1985849ejb.38.2021.04.22.07.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 07:22:47 -0700 (PDT)
Date:   Thu, 22 Apr 2021 16:22:45 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, libc-alpha@sourceware.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH liburing] examples/ucontext-cp.c: cope with variable
 SIGSTKSZ
Message-ID: <20210422142245.evlxjvfw3emh7ivw@steredhat>
References: <20210413150319.764600-1-stefanha@redhat.com>
 <YH2VE2RdcH0ISvxH@stefanha-x1.localdomain>
 <CAMe9rOpK08CJ5TdQ1fZJ2sGUVjHqoTHS2kT8EzDEejuodu8Ksg@mail.gmail.com>
 <YIFJDgno7deI5syK@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YIFJDgno7deI5syK@stefanha-x1.localdomain>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

+Cc: io-uring@vger.kernel.org
+Cc: Pavel Begunkov <asml.silence@gmail.com>

Original message: 
https://www.spinics.net/lists/linux-block/msg67077.html

On Thu, Apr 22, 2021 at 10:59:42AM +0100, Stefan Hajnoczi wrote:
>On Mon, Apr 19, 2021 at 11:38:07AM -0700, H.J. Lu wrote:
>> On Mon, Apr 19, 2021 at 7:35 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>> >
>> > On Tue, Apr 13, 2021 at 04:03:19PM +0100, Stefan Hajnoczi wrote:
>> > > The size of C arrays at file scope must be constant. The following
>> > > compiler error occurs with recent upstream glibc (2.33.9000):
>> > >
>> > >   CC ucontext-cp
>> > >   ucontext-cp.c:31:23: error: variably modified ‘stack_buf’ at file scope
>> > >   31 |         unsigned char stack_buf[SIGSTKSZ];
>> > >      |                       ^~~~~~~~~
>> > >   make[1]: *** [Makefile:26: ucontext-cp] Error 1
>> > >
>> > > The following glibc commit changed SIGSTKSZ from a constant value to a
>> > > variable:
>> > >
>> > >   commit 6c57d320484988e87e446e2e60ce42816bf51d53
>> > >   Author: H.J. Lu <hjl.tools@gmail.com>
>> > >   Date:   Mon Feb 1 11:00:38 2021 -0800
>> > >
>> > >     sysconf: Add _SC_MINSIGSTKSZ/_SC_SIGSTKSZ [BZ #20305]
>> > >   ...
>> > >   +# define SIGSTKSZ sysconf (_SC_SIGSTKSZ)
>> > >
>> > > Allocate the stack buffer explicitly to avoid declaring an array at file
>> > > scope.
>> > >
>> > > Cc: H.J. Lu <hjl.tools@gmail.com>
>> > > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>> > > ---
>> > > Perhaps the glibc change needs to be revised before releasing glibc 2.34
>> > > since it might break applications. That's up to the glibc folks. It
>> > > doesn't hurt for liburing to take a safer approach that copes with the
>> > > SIGSTKSZ change in any case.
>> >
>> > glibc folks, please take a look. The commit referenced above broke
>> > compilation of liburing's tests. It's possible that applications will
>> > hit similar issues. Can you check whether the SIGSTKSZ change needs to
>> > be reverted/fixed before releasing glibc 2.34?
>> >
>>
>> It won't be changed for glibc 2.34.
>
>Thanks for the response, H.J. and Paul.
>
>In that case liburing needs this patch.
>

I think so:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


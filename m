Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CB340CCBC
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 20:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhIOSsF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 14:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhIOSsF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 14:48:05 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE32C061575
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 11:46:46 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id b200so4732436iof.13
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 11:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=99Kw1j1eVMbhrAgZXfGRgYVdqT/i+a0+MPLD8HFFIc4=;
        b=CsgcDCnADO5ugy7onKouza4fhG+yUV0MDOzSndd/gDrPbnCVnsz2J9QFoKjJgdlIiq
         E3LwE/FHYLp7GI8a7djMfSXSqqptBInylpqEBEd8LybqxCSj5ZNLNAHIn9HdOOD+AJc0
         Q9siDRJqOwGoR17QoQPu54YLX21JLnRCD/tF7/QkEiyo3OVe4Sq9p+1q2M3dAY0laEc1
         22sv42Qvez1aPio7GMgHXG2+lHRL3mZbnSvwZI1GfxnF37zzQrVePJLGMstki/ajdbij
         ryV/0MOXzmLApbHE6D3pSJhgeUR7WVEQ+RCBpfH1hrKIguR2X+wr6dL4dFOue9ykjDiQ
         LINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=99Kw1j1eVMbhrAgZXfGRgYVdqT/i+a0+MPLD8HFFIc4=;
        b=UID5dJJ8ABNirSccp4PE+/LOQTZctuUWCjcqGeG9aqJSM3d8Yru4xDpZNP6SK89www
         c7vBoFr1FqfWxZsvDrRVBeFkHzhgROqfwYEcfB8ioyvt+jCqIWsXYxOR3T3Moy15fnGn
         vrQuEKPwNy4BdrjRb4RIsUrxAvZkdR0ow/4v3/Qd3IT47dX6X6BUalgs3uL3y8NL3fdv
         Gbh/G829f47Dv6bL0X7yiVQAG7SZuq75lT8WAzjalSuD3aBT8qxJvj6LAap5VsBc3TF7
         EQw97WEuekNsm+jNAwGKdCbdaA+8IiKX1Fgrqwi3VfNVAEIrsHuUhqGhmCHf7Q24SbEc
         EsFg==
X-Gm-Message-State: AOAM531jMkoNOy3X5wkqtE/KsUD8bYD/lAUV22STTxLFG9G0K89dKq2o
        4fvNIonI+haqsNgL87uuijx49Q==
X-Google-Smtp-Source: ABdhPJyVmsyeTFwtvsHILTmGHuMTBRGYbKYqOePJZrL48z7bCy6x+55r/0kTd5bBtV7AnDU1ru+CLQ==
X-Received: by 2002:a6b:710f:: with SMTP id q15mr1243760iog.77.1631731605376;
        Wed, 15 Sep 2021 11:46:45 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y26sm403955iob.37.2021.09.15.11.46.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 11:46:45 -0700 (PDT)
Subject: Re: [PATCHSET v3 0/3] Add ability to save/restore iov_iter state
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210915162937.777002-1-axboe@kernel.dk>
 <CAHk-=wgtROzcks4cozeEYG33UU1Q3T4RM-k3kv-GqrdLKFMoLw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8c7c8aa0-9591-a50f-35ee-de0037df858a@kernel.dk>
Date:   Wed, 15 Sep 2021 12:46:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgtROzcks4cozeEYG33UU1Q3T4RM-k3kv-GqrdLKFMoLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/15/21 12:32 PM, Linus Torvalds wrote:
> On Wed, Sep 15, 2021 at 9:29 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> I've run this through vectored read/write with io_uring on the commonly
>> problematic cases (dm and low depth SCSI device) which trigger these
>> conditions often, and it seems to pass muster. I've also hacked in
>> faked randomly short reads and that helped find on issue with double
>> accounting. But it did validate the state handling otherwise.
> 
> Ok, so I can't see anything obviously wrong with this, or anything I
> can object to. It's still fairly complicated, and I don't love how
> hard it is to follow some of it, but I do believe it's better.

OK good

> IOW, I don't have any objections. Al was saying he was looking at the
> io_uring code, so maybe he'll find something.
> 
> Do you have these test-cases as some kind of test-suite so that this
> all stays correct?

Yep liburing has a whole bunch of regressions tests that we always run
for any change, and new cases are added as problems are found. That also
has test cases for new features, etc. This one is particularly difficult
to test and have confidence in, which is why I ended up hacking up that
faked short return so I knew I had exercised all of it. The usual tests
do end up hitting the -EAGAIN path quite easily for certain device
types, but not the short read/write.

-- 
Jens Axboe


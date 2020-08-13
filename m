Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F403924411D
	for <lists+io-uring@lfdr.de>; Fri, 14 Aug 2020 00:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgHMWIj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 18:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgHMWIj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 18:08:39 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E821DC061757
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 15:08:38 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z6so8934834iow.6
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 15:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j7MVp/jglOvgkJjCwGGzjj43QkWQif5oexDEp6CngOw=;
        b=MW2D8Acq75og7pFh8tj3HFIRd49jAAxJknM69lE9Bma36r5IW5ErPkYwmuTC8MFXFP
         b9NYRuOAyyrJ5MB6q4irUUU7TIxuODAzQrU+bv6hX1MAYPj2WJSr+kKxoHP2gy7626AI
         7hbO++DVGNUqlHIIc/xb9CB3kXC/IMwsTdBJ837mqm+gR8dJxo2Hvbomn5BGXtppJwi/
         QjVr9jDGq9+7UVhZqR4gnoUs5QK1LzmR5ql6Ud+qZtKw9JSfblcTLL2zhwrEJTdzARha
         ZyEKb0UUBtiQQnZ0yln9nTgiIJonpVDs4ZDHgAMa5wL+9nc8fLkgbtP9Cif/LLeAFWdQ
         QTqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j7MVp/jglOvgkJjCwGGzjj43QkWQif5oexDEp6CngOw=;
        b=dJ/2Qa+7pUP/C2yOJFgJHgpTr/lhSyVTENxd2d8StkMy0c1pri9uh0DSBBjqkcIOHe
         0g74mkElSXkD+YxJ78d5DHIFuTny1E+tvJbdYd3Xtb7ckZSvS7rd2BemDxKtm8pMRUs2
         +7BKl1WyeS6+wfIZmmp2T3MZ2jWWH/AebMLmo9PTO58MAmVB2zvUnlfFheMcSlYL2iAO
         hRRRlGbEYLRO7V3HR4xcDChQe6W3HYDQg3AdVR5iAiAz4ElkR7M5XrzF12a1wvMMNDwb
         OsP6HFEm6d4GBb3twioELxhaU+MlztOp02Qqpu0krj+bv4P4c+eQLPuwV3xDdMVytrUq
         0GAQ==
X-Gm-Message-State: AOAM5328eeM4YT0BwLhLoOehcmM7Nuo577LTYG0u2c3RmAOlAPYD0vQp
        iVtTmX5pjTlCquMRJmTCwikgqA==
X-Google-Smtp-Source: ABdhPJyp8TPBHh01/UdzwiH0jKrONEu/38C08LWi4IGxbrBScgAtBmSTmyW6v0A5uCQBMci3XJ2bCw==
X-Received: by 2002:a5e:9601:: with SMTP id a1mr6918277ioq.179.1597356518175;
        Thu, 13 Aug 2020 15:08:38 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j8sm3271198ilc.43.2020.08.13.15.08.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 15:08:37 -0700 (PDT)
Subject: Re: [PATCHSET 0/2] io_uring: handle short reads internally
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     io-uring@vger.kernel.org, david@fromorbit.com
References: <20200813175605.993571-1-axboe@kernel.dk>
 <x497du2z424.fsf@segfault.boston.devel.redhat.com>
 <99c39782-6523-ae04-3d48-230f40bc5d05@kernel.dk>
 <9f050b83-a64a-c112-fc26-309342076c71@kernel.dk>
 <e77644ac-2f6c-944e-0426-5580f5b6217f@kernel.dk>
 <x49364qz2yk.fsf@segfault.boston.devel.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b25ecbbd-bb43-c07d-5b08-4850797378e7@kernel.dk>
Date:   Thu, 13 Aug 2020 16:08:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <x49364qz2yk.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/13/20 2:49 PM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 8/13/20 2:37 PM, Jens Axboe wrote:
>>> On 8/13/20 2:33 PM, Jens Axboe wrote:
>>>> On 8/13/20 2:25 PM, Jeff Moyer wrote:
>>>>> Jens Axboe <axboe@kernel.dk> writes:
>>>>>
>>>>>> Since we've had a few cases of applications not dealing with this
>>>>>> appopriately, I believe the safest course of action is to ensure that
>>>>>> we don't return short reads when we really don't have to.
>>>>>>
>>>>>> The first patch is just a prep patch that retains iov_iter state over
>>>>>> retries, while the second one actually enables just doing retries if
>>>>>> we get a short read back.
>>>>>
>>>>> Have you run this through the liburing regression tests?
>>>>>
>>>>> Tests  <eeed8b54e0df-test> <timeout-overflow> <read-write> failed
>>>>>
>>>>> I'll take a look at the failures, but wanted to bring it to your
>>>>> attention sooner rather than later.  I was using your io_uring-5.9
>>>>> branch.
>>>>
>>>> The eed8b54e0df-test failure is known with this one, pretty sure it
>>>> was always racy, but I'm looking into it.
>>>>
>>>> The timeout-overflow test needs fixing, it's just an ordering thing
>>>> with the batched completions done through submit. Not new with these
>>>> patches.
> 
> OK.
> 
>>>> The read-write one I'm interested in, what did you run it on? And
>>>> what was the failure?
>>>
>>> BTW, what git sha did you run?
>>
>> I do see a failure with dm on that, I'll take a look.
> 
> I ran it on a file system atop nvme with 8 poll queues.
> 
> liburing head: 9e1d69e078ee51f253a829ff421b17cfc996d158
> linux-block head: ff1353802d86a9d8e40ef1377efb12a1d3000a20

Fixed it, and actually enabled a further cleanup.

> The error I saw was:
> 
> Running test read-write:
> Non-vectored IO not supported, skipping
> cqe res -22, wanted 2048
> test_buf_select_short vec failed
> Test read-write failed with ret 1
> 
> But I don't think it was due to these two commits.

Yeah don't think so either.

-- 
Jens Axboe


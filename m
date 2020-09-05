Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3521F25E891
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 17:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgIEPLH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 11:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbgIEPK6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 11:10:58 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182C4C061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 08:10:56 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 5so5853702pgl.4
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 08:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=AweOnh58sZBmQHGt6UjeoZ8ximjxIjYRFBv3zvxvIy4=;
        b=kH3IsxOzpjWnZXMYXInyBmuBS49vLCoAt3Ntuy66ffB+1ODQ5eOYUS+7robyWeOVgb
         RKDG+jn+J/TeNP2xxUifxzfH7NP9GllKysmBe8H/amsBctrAO1To3wpw1EU9Rp7skvhH
         ExusSmBDopZlxD9W1eH4Z6rFWpLp2egOFuTwgmnYKZ45RdmXDgj93cMDOSmUUc7aobT3
         A/yDFH9lz2YqLtMTXFyQwTsFvjSj1Eo75QtpDeMwiPcVdPoxeWkHj+Imfbby5/O6iw8U
         ho/KB6HuVbRENQOfZoNINcPmFEs2+abkOZgwfGd3LPHTlaj6n50BH31TWdawfbecVBLq
         zkDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AweOnh58sZBmQHGt6UjeoZ8ximjxIjYRFBv3zvxvIy4=;
        b=a3F96O0+gX0bHMBW7ZJBz8g1PT3U7R5Gm5Frri3cZSSIJy0NrLHRJZVAlbfBwsDr/V
         +7QBH1HV+O7clsx9QOQSt0d5bvRk3HY6Hllt0dXPBsgbIxwbVDp2DUueKKUB4jaBB7Vs
         Opbz9UUn/TX9Z4cNdQjCy5BjOP4gR++dJcQUCyqZN9QkmvSLJvapKUOfg82XFg4MdAb6
         LuWUodfvNL9e6inUn6FnJtb6IgMMew/L9lYbACQ8wX7MnCiwOJM7zD2hTRLJ+osNeM0G
         3raHz4SwVrSTuP33neB2t2gg13auWaEw8U2wGDp6iYpuZNA5cSbFdC350EZeU9+QI4vA
         i/AQ==
X-Gm-Message-State: AOAM530CHiSbM5/g3v4iOv7FkpNB1XJPiujBmG1xUtHRHKOG/eHGhISu
        49ATUs+V/bs4uwtFgoZkEqvnsewJjsuUxSyO
X-Google-Smtp-Source: ABdhPJx8Oxiyo0btRkBSruVTA4OCtJW990U9N9buOK+h7Np2/tagv8I9K0hp/nwSGJQnYepBBhCmYA==
X-Received: by 2002:a63:ff11:: with SMTP id k17mr8196570pgi.352.1599318652981;
        Sat, 05 Sep 2020 08:10:52 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y128sm9591316pfy.74.2020.09.05.08.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 08:10:52 -0700 (PDT)
Subject: Re: WRITEV with IOSQE_ASYNC broken?
To:     Pavel Begunkov <asml.silence@gmail.com>, nick@nickhill.org,
        io-uring@vger.kernel.org
References: <382946a1d3513fbb1354c8e2c875e036@nickhill.org>
 <bfd153eb-0ab9-5864-ca5d-1bc8298f7a21@kernel.dk>
 <fe3784cf-3389-6096-9dfd-f3aa8cd3a769@kernel.dk>
 <d8404079-fe7e-3f42-4460-22328b12b0fa@kernel.dk>
 <484b5876-a2e6-3e02-a566-10c5a02241e8@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <17c49959-c049-3586-6459-79c056f779ba@kernel.dk>
Date:   Sat, 5 Sep 2020 09:10:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <484b5876-a2e6-3e02-a566-10c5a02241e8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/4/20 11:50 PM, Pavel Begunkov wrote:
> On 05/09/2020 07:35, Jens Axboe wrote:
>> On 9/4/20 9:57 PM, Jens Axboe wrote:
>>> On 9/4/20 9:53 PM, Jens Axboe wrote:
>>>> On 9/4/20 9:22 PM, nick@nickhill.org wrote:
>>>>> Hi,
>>>>>
>>>>> I am helping out with the netty io_uring integration, and came across 
>>>>> some strange behaviour which seems like it might be a bug related to 
>>>>> async offload of read/write iovecs.
>>>>>
>>>>> Basically a WRITEV SQE seems to fail reliably with -BADADDRESS when the 
>>>>> IOSQE_ASYNC flag is set but works fine otherwise (everything else the 
>>>>> same). This is with 5.9.0-rc3.
>>>>
>>>> Do you see it just on 5.9-rc3, or also 5.8? Just curious... But that is
>>>> very odd in any case, ASYNC writev is even part of the regular tests.
>>>> Any sort of deferral, be it explicit via ASYNC or implicit through
>>>> needing to retry, saves all the needed details to retry without
>>>> needing any of the original context.
>>>>
>>>> Can you narrow down what exactly is being written - like file type,
>>>> buffered/O_DIRECT, etc. What file system, what device is hosting it.
>>>> The more details the better, will help me narrow down what is going on.
>>>
>>> Forgot, also size of the IO (both total, but also number of iovecs in
>>> that particular request.
>>>
>>> Essentially all the details that I would need to recreate what you're
>>> seeing.
>>
>> Turns out there was a bug in the explicit handling, new in the current
>> -rc series. Can you try and add the below?
> 
> Hah, absolutely the same patch was in a series I was going to send
> today, but with a note that it works by luck so not a bug. Apparently,
> it is :)> 
> BTW, const in iter->iov is guarding from such cases, yet another proof
> that const casts are evil.

Definitely, not a great idea to begin with...

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EEE41D94C
	for <lists+io-uring@lfdr.de>; Thu, 30 Sep 2021 14:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbhI3MG2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Sep 2021 08:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbhI3MG1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Sep 2021 08:06:27 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C59AC06176A
        for <io-uring@vger.kernel.org>; Thu, 30 Sep 2021 05:04:45 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id b204-20020a1c80d5000000b0030cd967c674so1637070wmd.0
        for <io-uring@vger.kernel.org>; Thu, 30 Sep 2021 05:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zQAgASRuKYeXyTApiTwodDWeWmu5YZfSBs2Nqmks7/8=;
        b=pay15ffcfxbINIqMAN3icgX4LGO8PtLwGc8kmrc/G047VLOo2ciEDCWIiX8bFcyT0T
         c9cDN4tGnVp6jN4LAfHOxB7RLW7pfkqq4lKVCjeGFlIjpP9s1By80zB9LIolkNX4zF1/
         85w3CRdqKdBU0KYh7EA7uUTHR+4VI68M0/DdWQOHsVBQFkZfP2n27KjumMlsh0lZn9NG
         FFAoaEz2WxCd/vBoufEwXdbxS2y7thXL+52csvZxGyLvfbJbFDOKWh2THu1uWc2ycmjg
         FFE54eyCklfQ0W/j/keXXapZOylYlc4jRl78opuxEIw9pXDQDTj/OEn/gIZRxHCdUzKT
         Y7Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:references:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zQAgASRuKYeXyTApiTwodDWeWmu5YZfSBs2Nqmks7/8=;
        b=ajCLqV6u27lptg0gFIutRiGuHobx13Ua3Q1DEwEE9Kk+XEAarcaODw4moRIvOmKgJ1
         Q6KlB9jYUyqF6OQvcFwOHG1szrSR0lONJ+plpBFMzZ/Zjx3Q1mlY97zpgEopgER5TBh9
         iIWytOWhNH8FbePsLlDT8/9s1ZlsBfH1/JvGa+4GDdmRBbNyNnpetB+8yGSLS/t+83eh
         YfMZlkvyB0zR08I+SFEhPss5DKgobdBwxog6vO42oHX/LfJgcSSANRumu+/mkaevlbJg
         pJrckjA5Pwgg4bgzt7Tnhwh2vbU+qy5ilFgr2qw1KP6HuD7gBbCSw4gwTI9rQe1S3oND
         +6Sg==
X-Gm-Message-State: AOAM532kDVIditf9MaddzOo2wE890i4g02hvKwYWMUIUVddDiASzyG5c
        bmCozd/mQ6wcHDUHazQZq3E=
X-Google-Smtp-Source: ABdhPJyeUifLp/ANQj8LsCPWJVn7KSaQm7g/Lpu1gSO3UWOffCp1rPK+/TPCJ6PMu1yl9aUYULx3ug==
X-Received: by 2002:a05:600c:22d6:: with SMTP id 22mr5050500wmg.17.1633003483686;
        Thu, 30 Sep 2021 05:04:43 -0700 (PDT)
Received: from [192.168.42.61] (82-132-226-39.dab.02.net. [82.132.226.39])
        by smtp.gmail.com with ESMTPSA id b25sm2785052wmj.9.2021.09.30.05.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 05:04:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
 <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
 <51308ac4-03b7-0f66-7f26-8678807195ca@linux.alibaba.com>
 <96ef70e8-7abf-d820-3cca-0f8aedc969d8@gmail.com>
 <0d781b5f-3d2d-5ad4-9ad3-8fabc994313a@linux.alibaba.com>
 <11c738b2-8024-1870-d54b-79e89c5bea54@gmail.com>
 <10358b7e-9eb3-290f-34b6-5f257e98bcb9@linux.alibaba.com>
 <f9c93212-1bc9-5025-f96d-510bbde84e21@gmail.com>
 <5af509fe-b9f7-7913-defd-4d32d4f98f4e@linux.alibaba.com>
 <02ea256c-bdb5-2fba-d9a3-da04236586a5@gmail.com>
Subject: Re: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of
 io_sq_thread_idle
Message-ID: <6f688741-2ffe-060e-485f-6c22d171a09c@gmail.com>
Date:   Thu, 30 Sep 2021 13:04:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <02ea256c-bdb5-2fba-d9a3-da04236586a5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/30/21 9:51 AM, Pavel Begunkov wrote:
> On 9/29/21 1:13 PM, Hao Xu wrote:
>> 在 2021/9/29 下午7:37, Pavel Begunkov 写道:
>>> On 9/29/21 10:24 AM, Hao Xu wrote:
>>>> 在 2021/9/28 下午6:51, Pavel Begunkov 写道:
>>>>> On 9/26/21 11:00 AM, Hao Xu wrote:
>>> [...]
>>>>>> I'm gonna pick this one up again, currently this patch
>>>>>> with ktime_get_ns() works good on our productions. This
>>>>>> patch makes the latency a bit higher than before, but
>>>>>> still lower than aio.
>>>>>> I haven't gotten a faster alternate for ktime_get_ns(),
>>>>>> any hints?
>>>>>
>>>>> Good, I'd suggest to look through Documentation/core-api/timekeeping.rst
>>>>> In particular coarse variants may be of interest.
>>>>> https://www.kernel.org/doc/html/latest/core-api/timekeeping.html#coarse-and-fast-ns-access
>>>>>
>>>> The coarse functions seems to be like jiffies, because they use the last
>>>> timer tick(from the explanation in that doc, it seems the timer tick is
>>>> in the same frequency as jiffies update). So I believe it is just
>>>> another format of jiffies which is low accurate.
>>>
>>> I haven't looked into the details, but it seems that unlike jiffies for
>>> the coarse mode 10ms (or whatever) is the worst case, but it _may_ be
>> Maybe I'm wrong, but for jiffies, 10ms uis also the worst case, no?
>> (say HZ = 100, then jiffies updated by 1 every 10ms)
> 
> I'm speculating, but it sounds it's updated on every call to ktime_ns()
> in the system, so if someone else calls ktime_ns() every 1us, than the
> resolution will be 1us, where with jiffies the update interval is strictly
> 10ms when HZ=100. May be not true, need to see the code.

Taking a second quick look, doesn't seem to be the case indeed. And it's
limited to your feature anyway, so the overhead of ktime_get() shouldn't
matter much.

>>> much better on average and feasible for your case, but can't predict
>>> if that's really the case in a real system and what will be the
>>> relative error comparing to normal ktime_ns().

-- 
Pavel Begunkov

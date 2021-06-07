Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B44B39E44A
	for <lists+io-uring@lfdr.de>; Mon,  7 Jun 2021 18:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhFGQrI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Jun 2021 12:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhFGQrH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Jun 2021 12:47:07 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EA2C061766
        for <io-uring@vger.kernel.org>; Mon,  7 Jun 2021 09:45:15 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id g8so27809803ejx.1
        for <io-uring@vger.kernel.org>; Mon, 07 Jun 2021 09:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BDBo5/NG5kJ7oC2wTRy5Ztj7YOrkThynC4BhahrISR0=;
        b=pFSSVJ1E5LTXeB3YKRiNGrKJEBjo4vx0qo5rA3gpTZo+vaXlf2myQxmfCC/wP3upwO
         hwTlXg/+xUnUtsEK6bCSDF3PrdpydvgIsEGN9rgpCa8DawGFq+A89HsVLffyWcGKYF64
         +oYE4XWPc2PJaglCuietRl+6A2ajlKOxr0bWMzHeI7YAhQjTOEVwYXKvzTcnVm5gGDOF
         Q+u/CLrXbTfVbo8zN7f/voKu96fxMTdcCaHbR/I7vIvOT2SHr3qh3t4B3+eIYEbUag+H
         xyGpNJ9/o6HS4XoSn1S5pTbXj3vhjFijxI22jesqtLAds6bJJl2WHYIxFkVDKotddN+1
         qlag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BDBo5/NG5kJ7oC2wTRy5Ztj7YOrkThynC4BhahrISR0=;
        b=joaeoP7WG9lH4cTUFBraAQLm3k8ARElCJGcXm5r3oiAVVJFXZ6UfLP1HYc/nitmHXB
         1wtbAZeCo/QR8PUr757iUkWZk4pYTsBn0xBffwyUOAncNKlEBqZQudcgNLM0+2sY9nBn
         M/MCH/eKSmtx5VHlnR6aPre41WGtgrcN/v7ceT+oxCd5rvt0rotb0GwyV5s/Fnwz98Il
         HsVQKeswIns6dkyKMfO8lF7qotVkbQEa5yEOxdvvSa1UBNmvH6/6me2/lEcbAYFRepfG
         P/A4uXMWB8s2x4q2xEvlFYOfxebBEm7SLc7IT8RdVTbRlupzVRdYH8bsC+dm01Q2ls6B
         YNfQ==
X-Gm-Message-State: AOAM533n++0No4Mnn53K9ERac51sOKI1+Kgf6HaM6+cyioZIo726JOm6
        Vz53fyAPR2Z7/u3nukWYKem1XMAev4lmUM6Z
X-Google-Smtp-Source: ABdhPJw859jP4xuXziy9dvWgKmNfgJSkacOTMxgRTRI4kAOZsgMtTpMWtw6yb7b24oc5Y9MUIBXseg==
X-Received: by 2002:a17:906:8319:: with SMTP id j25mr18476761ejx.479.1623084314246;
        Mon, 07 Jun 2021 09:45:14 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:5eb2])
        by smtp.gmail.com with ESMTPSA id i5sm7844392edt.11.2021.06.07.09.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 09:45:13 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <e90a3bdd-d60c-9b82-e711-c7a0b4f32c09@linux.alibaba.com>
 <f2fa9534-e07c-fd18-759e-b3ca99b714a7@kernel.dk>
 <4c341c96-8d66-eae3-ba4a-e1655ee463a8@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: Question about poll_multi_file
Message-ID: <76321c1a-c87f-10ae-1801-37afe093ec5a@gmail.com>
Date:   Mon, 7 Jun 2021 17:45:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <4c341c96-8d66-eae3-ba4a-e1655ee463a8@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/6/21 3:08 PM, Hao Xu wrote:
> 在 2021/6/4 上午2:01, Jens Axboe 写道:
>> On 6/3/21 6:53 AM, Hao Xu wrote:
>>> Hi Jens,
>>> I've a question about poll_multi_file in io_do_iopoll().
>>> It keeps spinning in f_op->iopoll() if poll_multi_file is
>>> true (and we're under the requested amount). But in my
>>> understanding, reqs may be in different hardware queues
>>> for blk-mq device even in this situation.
>>> Should we consider the hardware queue number as well? Some
>>> thing like below:
>>
>> That looks reasonable to me - do you have any performance
>> numbers to go with it?
> 
> Not very easy for me to construct a good case. I'm trying to
> mock the below situation:
> manully control uring reqs to go to 2 hardware queues, like:
>    hw_queue0     hw_queue1
>    heavy_req     simple_req
>    heavy_req     simple_req
>      ...            ...
> 
> heavy_req is some request that needs more time to complete,
> while simple_req takes less time. And make the io_do_iopoll()
> alway first spin on hw_queue0.
> any ideas?

- NVMe with #HW qs >= #CPUs, so HW to SW qs are 1-to-1.
- 2 threads pinned to different CPUs, so they submit to
different qs.

Then one thread is doing 512B rand reads, and the second
is doing 64-128 KB rand reads. So, I'd expect a latency
spike on some nine. Not tested, so just a suggestion.

The second can also be doing writes, but that would need
1) waiting for steady state
2) higher QD/load for writes because otherwise SSD
caches might hide waiting.

-- 
Pavel Begunkov

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD63D393896
	for <lists+io-uring@lfdr.de>; Fri, 28 May 2021 00:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235680AbhE0WOp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 18:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbhE0WOp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 18:14:45 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17204C061574
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 15:13:10 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r10so1290165wrj.11
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 15:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GVDzzprZ5k10HW2MbqOv2I8vQVjVo52mBlBGQnANsGc=;
        b=mbOlDgGH5auTxshlQGJJfgR3aOrHB2hkG7tRv70XobQc2tcLztJf7Dce8OPB0wqouO
         swecaJg7tZdR/eF/nx2kYE5RYHZVO9lIlwk1k4Lbv9Eo5yrVlbazp1KsWzITc6HEVROs
         M4dDowZfZ6iWDp7rN0bCvvboIg//eZcGeBdlx0iA4CUN9kSFaRV9ptjiOvUV3aSt5efO
         ZNyeCNff5PzqNDRu1kC5+4jduw96hOT7AC4lI4b+CEKXN1H+RdU4n59ivFy6o7hJumGj
         8S65Hm92t+3iHCmHG0iwHpt/lB3Q5MWHxGhawPjlB/WdVm+eXRewGpc/876cenWvgUOM
         PJVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GVDzzprZ5k10HW2MbqOv2I8vQVjVo52mBlBGQnANsGc=;
        b=A6jTXevge1ygtboT72dHEwFnDziQBpoKtnI2bt3rOLSNyuqLyWjdLX8J0PgJDGmEVA
         H4ERnROogaSa2aWUCqcKx0scbaM0fC6qJkNEObJ9n5/XzvHcWL5ENNARQuMHIHLXvYR7
         oGPT6cjvifM/KPjM8i71wuliHUWTFOvTLN7YQ1Ew15g0NDn6AbfHoHeafwqc6vafzDr/
         1ThpsKD5BEWjc9MJQG+QG7F8IKhMMS4usORBawS8TV6fEInlRdz9ERPOxKHZH05mKAHg
         ikoWn5JurinePkPIrrIqgui3p9jD0e9YkZyAwUQc1UTBBjVf1LbDaBtUvKq74aMk1Hen
         yKMg==
X-Gm-Message-State: AOAM53119LqacQI/vi5vsSn2mUsKk3KKNodhF7koyeBrfD+NB6JZBIMQ
        iZl2V7cL9f0E81OOwWvmZ9/G7oVhR0ndQoqi
X-Google-Smtp-Source: ABdhPJwSclvqhnr2u5GbIAFq/KGWNKfCW2Ws1zjCENXadUuXEKV71/2KnYf6sY+tFlTMYXUv8fCWsg==
X-Received: by 2002:a05:6000:22a:: with SMTP id l10mr3574760wrz.171.1622153588513;
        Thu, 27 May 2021 15:13:08 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.19])
        by smtp.gmail.com with ESMTPSA id n13sm5337071wrg.75.2021.05.27.15.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 15:13:08 -0700 (PDT)
Subject: Re: [PATCH 12/13] io_uring: cache task struct refs
To:     Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "open list:IO_URING" <io-uring@vger.kernel.org>
References: <cover.1621899872.git.asml.silence@gmail.com>
 <d124d2af721af9d9d5fa7c187cdee9431b7fe831.1621899872.git.asml.silence@gmail.com>
 <CAFUsyfJ-1iKiSA31C5cgZ3fDqskVEAdQmzSf8nbcVV1ParPvDA@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <5ec6ff35-50ba-2938-483e-449a4560af65@gmail.com>
Date:   Thu, 27 May 2021 23:13:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAFUsyfJ-1iKiSA31C5cgZ3fDqskVEAdQmzSf8nbcVV1ParPvDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/27/21 10:51 PM, Noah Goldstein wrote:
> On Mon, May 24, 2021 at 7:51 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
[...]
>>
>> -       percpu_counter_add(&current->io_uring->inflight, nr);
>> -       refcount_add(nr, &current->usage);
>> +       tctx = current->io_uring;
>> +       tctx->cached_refs -= nr;
>> +       if (unlikely(tctx->cached_refs < 0)) {
>> +               unsigned int refill = -tctx->cached_refs + IO_TCTX_REFS_CACHE_NR;
> 
> Might be cleared to use:
> 
> unsigned int refill =  IO_TCTX_REFS_CACHE_NR - tctx->cached_refs;

=======================================================================
Did think about it, but left as is to emphasize that it's negative and
we convert it to positive, so all operations are with positive (and
unsigned due to C rules). Code generation will be same.


>> +
>> +               percpu_counter_add(&tctx->inflight, refill);
>> +               refcount_add(refill, &current->usage);
>> +               tctx->cached_refs += refill;
>> +       }
>>         io_submit_state_start(&ctx->submit_state, nr);
>>

-- 
Pavel Begunkov

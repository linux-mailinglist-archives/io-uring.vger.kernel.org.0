Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDBF3F1DEC
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 18:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhHSQgn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 12:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhHSQgm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 12:36:42 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04426C061575
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 09:36:05 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v4so9958112wro.12
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 09:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=x+XZeyjlv8UTCzzgo9Mw/+tRSlA6H+GqBFjPtsXHjP0=;
        b=iRiiHDOz/+oxCSHFhvI89Hud+xRGE5k5Jh69YkCTyF0FKXhxqAuez2R09BqWHpbtka
         z/hD0lGMur5prg30se0G9IkSIXKmH5xNhCDfG/lsRWOAMJFC8NxMSMNzbNR/qdWoZ14x
         PzM8p+DRiv6+9RHfyRdE1vYKquSg/BI4i6oeA7kZ7WnTBDJaVLL/aDT0wrsdvRaHKsBm
         7XmHUoPc4g7yqre5X2kHDSso9edmPnZPYoP5cVo/pnpxqiaaloiMj5wW66tbXLeF7zLM
         z24b1lBn9qeXvHy/cJahhxPTa79cx4ETxX0c5njlZMwIpwWgshm0xqcQRN1xA78iJddv
         DMuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x+XZeyjlv8UTCzzgo9Mw/+tRSlA6H+GqBFjPtsXHjP0=;
        b=tslnSYW3TBX+PTlD8JnNvE/Qu3w7IlsFBDOSC1RljWgslsE1tzSbNAXTpn89az+UB3
         CiREjp8jdWrK1SNrCKHt+zhRqAg42rtj2nL1xfx1tUTlF1vGzwv5wgdlEuKe92WesxJB
         kWN3N+e9KEY/nCIlW8Rz91cHgGDfOvSVRHosQp7I82SIQadbaEkCWxxjW20SmvM+DYr0
         o32DuRQLvQki5jZPKE92tAJRUzaGhNVrgEa/VK2OiZgO9qbD7Tiz0mEK0/x8AcEkJM1J
         fwoBhnL0ULQIkFfZMSGliQsWC5l7YnS9OdW2bcij4ZY6wONWUJ+Ks2tk5+yQQLf8qnTq
         n5sg==
X-Gm-Message-State: AOAM532Xw6gTJWKg01b3l3+ZM32XkisBWQJgc1UBtKt3vu5yfoEh4RMb
        ukDKiT7h4eeFiC4+ZjmQ8r0aH0OWMy4=
X-Google-Smtp-Source: ABdhPJxXZuqWeILSDPLTTcxoIij6OYX6TAYnL/p7tN2sf81p+BefDX3WYjs7509W7hFKZyEqxbNOZg==
X-Received: by 2002:a5d:4ad2:: with SMTP id y18mr5041349wrs.110.1629390964379;
        Thu, 19 Aug 2021 09:36:04 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.21])
        by smtp.gmail.com with ESMTPSA id v12sm3425905wrq.59.2021.08.19.09.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 09:36:03 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1629286357.git.asml.silence@gmail.com>
 <018a6c73-7327-bbba-86f2-057711755487@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 0/3] tw mutex & IRQ rw completion batching
Message-ID: <3c6c1e74-dcce-04ef-888d-1892cb51a2ed@gmail.com>
Date:   Thu, 19 Aug 2021 17:35:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <018a6c73-7327-bbba-86f2-057711755487@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/21 4:53 PM, Jens Axboe wrote:
> On 8/18/21 5:42 AM, Pavel Begunkov wrote:
>> In essence, it's about two features. The first one is implemented by
>> 1-2 and saves ->uring_lock lock/unlock in a single call of
>> tctx_task_work(). Should be useful for links, apolls and BPF requests
>> at some moment.
>>
>> The second feature (3/3) is batching freeing and completing of
>> IRQ-based read/write requests.
>>
>> Haven't got numbers yet, but just throwing it for public discussion.
> 
> I ran some numbers and it looks good to me, it's a nice boost for the
> IRQ completions. It's funny how the initial move to task_work for IRQ
> completions took a small hit, but there's so many optimizations that it
> unlocks that it's already better than before.
> 
> I'd like to apply 1/3 for now, but it depends on both master and
> for-5.15/io_uring. Hence I think it'd be better to defer that one until
> after the initial batch has gone in.
> 
> For the batched locking, the principle is sound and measures out to be a
> nice win. But I have a hard time getting over the passed lock state, I
> do wonder if there's a cleaner way to accomplish this...

The initial idea was to have a request flag telling whether a task_work
function may need a lock, but setting/clearing it would be more subtle.
Then there is io_poll_task_func -> io_req_task_submit -> lock, and
reads/writes based using trylock, because otherwise I'd rather be
afraid of it hurting latency.

This version looks good enough, apart from conditional locking always
being a pain. We can hide bool into a struct, and with a bunch of
helpers leave no visibility into it. Though, I don't think it helps
anything.

-- 
Pavel Begunkov

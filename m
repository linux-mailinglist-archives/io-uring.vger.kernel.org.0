Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC72D3F7AE2
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 18:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhHYQrr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 12:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbhHYQrr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 12:47:47 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4D2C061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 09:47:01 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id g135so6107478wme.5
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 09:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aMWWCYHx0cPZB1lkVIAoC12yCeOlRIlPXQoBKDqZgl0=;
        b=cLoW6Z4NFbBjOSfDdC4cMM1Wsa8THe4GYf5nuXaBQcfhIBlbLC/NqLP81daID2SJC6
         ai+A+4gpzFPZYK0UFPwDE0jBAIsTwcQ5O9frlkBZ4zxubOdi2kSGDssba27dKl77VTrH
         j6mw1nEcqsh+gpoxPY7jv26foLYcgwgrxMOO5tvkAQXA8qvKK+v1HTBg9EaggyJc2zy/
         V/K4HNxFv0Xx+gLx7NJaJGMWtER2n6GEiVrVztoH23/Rqi7JiaWfRIthy0yPVyNRaLaj
         9VuhINdVBmaFtlKyZ28icqeD0N7L9NUZg8iZ8YKQoh/IfoYHXLxQ/fF4uWmbdy0Bm9MY
         AXPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aMWWCYHx0cPZB1lkVIAoC12yCeOlRIlPXQoBKDqZgl0=;
        b=BAD0+Bip/pNz/Vhqs94fr94Y9SQKDrLkIRFuXBzXBXPUzELH5TCQlLs3VTvNRWrq5n
         JmoVJe/BpxW9RmO7/7Tl7GiOIizBCsQDpkbt+gdxrgEz2VQY9lyGSFNblc2wKKCoLoSZ
         ECF0Qa4nVKgjb6TQ/wNJWoUPG3AO2VP1w9USPSxIOsP9OSyDcl1yqw8eKVJK4Q3B+pWX
         8ndYFI2Pa90E56V9pX0r3vXf5XP9vRZ5rb6jlVrJiH92b+29khRoPQhAQN5NvQ9H9Jj6
         NzpAxWc1Tb45gCo55RbO8xY2lPF6UCd/pWtSTuvTSDt0brw7JIq5NPeT4SPjjle+7GS7
         ni3w==
X-Gm-Message-State: AOAM532VIR+VmoCvulJA4CSnYgooh72zHioDo0eEWP/hX/fHVfLU/s3K
        IfpyscG9DaShW/tEXHK5Y6hNmYS6uOU=
X-Google-Smtp-Source: ABdhPJwsi1vZXdO5dLsFWdcQKeg8d7xlvlsI4kZ2dQKxiqgAiAuPD5n2pwlx0Dwgy83XzdRaQtcZOQ==
X-Received: by 2002:a1c:9a91:: with SMTP id c139mr10316431wme.106.1629910019934;
        Wed, 25 Aug 2021 09:46:59 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id 19sm5921697wmo.39.2021.08.25.09.46.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 09:46:59 -0700 (PDT)
Subject: Re: [RFC 0/2] io_task_work optimization
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210823183648.163361-1-haoxu@linux.alibaba.com>
 <503f1587-f7d9-13a9-a509-f9623d8748e9@kernel.dk>
 <19c77256-c83b-62b2-f3fb-7c85c882b5b2@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <39252708-3e63-b87d-553d-f201872ed68f@gmail.com>
Date:   Wed, 25 Aug 2021 17:46:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <19c77256-c83b-62b2-f3fb-7c85c882b5b2@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/21 5:39 PM, Hao Xu wrote:
> 在 2021/8/25 下午11:58, Jens Axboe 写道:
>> On 8/23/21 12:36 PM, Hao Xu wrote:
>>> running task_work may not be a big bottleneck now, but it's never worse
>>> to make it move forward a little bit.
>>> I'm trying to construct tests to prove it is better in some cases where
>>> it should be theoretically.
>>> Currently only prove it is not worse by running fio tests(sometimes a
>>> little bit better). So just put it here for comments and suggestion.
>>
>> I think this is interesting, particularly for areas where we have a mix
>> of task_work uses because obviously it won't really matter if the
>> task_work being run is homogeneous.
>>
>> That said, would be nice to have some numbers associated with it. We
>> have a few classes of types of task_work:
>>
>> 1) Work completes really fast, we want to just do those first
>> 2) Work is pretty fast, like async buffered read copy
>> 3) Work is more expensive, might require a full retry of the operation
>>
>> Might make sense to make this classification explicit. Problem is, with
>> any kind of scheduling like that, you risk introducing latency bubbles
>> because the prio1 list grows really fast, for example.
> Yes, this may intrpduce latency if overwhelming 1) comes in short time.
> I'll try more tests to see if the problem exists and if there is a
> better way, like put limited number of 1) to the front. Anyway, I'll
> update this thread when I get some data.

Not sure, but it looks that IRQ completion batching is coming to
5.15. With that you may also want to flush completions after the
IRQ sublist is exhausted.

May be worth to consider having 2 lists in the future 

-- 
Pavel Begunkov

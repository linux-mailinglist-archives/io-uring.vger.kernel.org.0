Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88843B8A24
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 23:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhF3Vla (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 17:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhF3Vl3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 17:41:29 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307C4C061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:38:59 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso5425047wmh.4
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BhoYBYlR4YwGpZD9z6mlMPSaw63MqblQQtMK367Ndc0=;
        b=rHHAJatCHnMvQfPEbrkMkn2YhRaS6FqmVh8cnBSWHby0HQqhkpdV6aXT/6Mc4O3Kbd
         DJlvvJfEdbdZBZLKzT6pMrOY1GI8vnQMfqN7JhWseO7TEene8NGR9zW//YstLB8NnjUS
         d2tTN0wgs52f+OPgGEiuGa64nvGOL/YIWuo3MM8PZaZUmssc/ihuEPSLVc4cOfGwDByV
         MzFxjqGucJXMv49CmPe/Iw1YhVdSWS+mF6j5MgABHSIDBZ0wP2AAzOK1n+WuVAkWdfsS
         yl1MWpNfyN/57mDeufVoXQtD+2+vcJo81/dOYUkgLgcu4yaOnJOMZ66uO7CDYDDKyBJl
         7gXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BhoYBYlR4YwGpZD9z6mlMPSaw63MqblQQtMK367Ndc0=;
        b=GGUkhLX0fQNZY1owZU5EdvPIrdaOfV6Lj7rCTayj6mcC9X0UocauWFCcwrJusZWo/F
         RUxb7SdbRK4xgH/GI47mrxw4uLogA4i5va8U5lACMO6HgU9diZ028qRr5AlVDcxf52Y2
         zbQnpfKuet0WZAaRk5UfklSrr+SFtxGRYqMZUU99WqkwDkqBi68ozI/cq7MlgIJ/PuwG
         SnYDd1EtzPJL4tIoC7L0EtwaRxhXsqThC92C2mthpk5VI8KMLMw15vdfRNc0iBjKGAqF
         l43eOUBoIwi+gHxZ0G5WescZHWN3zkej95wv/l06PFX05OecYsFLLmnGcoHLfx1Lj+yZ
         EgFw==
X-Gm-Message-State: AOAM531zqmTueqPRJquab6VNyZPhs1FOp8GCsZ8Zz2yNUPNOmbp9X9AM
        PvZJaJqRgBtUWLu0gZRdkfw72Zp7ecphnZbB
X-Google-Smtp-Source: ABdhPJySKTN5/3aKcZ29F1UJWZH0apRJmRsil91tHR35mKUDafV9PVklhpDdw0nW5/XY7x+W6ecoJg==
X-Received: by 2002:a7b:cd0d:: with SMTP id f13mr6490820wmj.89.1625089137686;
        Wed, 30 Jun 2021 14:38:57 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.185])
        by smtp.gmail.com with ESMTPSA id c12sm22713980wrw.46.2021.06.30.14.38.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 14:38:56 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: tweak io_req_task_work_add
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1625086418.git.asml.silence@gmail.com>
 <24b575ea075ae923992e9ce86b61e8b51629fd29.1625086418.git.asml.silence@gmail.com>
 <70c425a8-73dd-e15a-5a10-8ea640cdc7cd@kernel.dk>
 <d7f587b1-67bb-fc67-1174-91d2c8706b42@gmail.com>
 <e1b32d88-5801-b280-25ed-9902cfaa5092@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <dc8576f5-9187-c897-d2d5-04f61d54408d@gmail.com>
Date:   Wed, 30 Jun 2021 22:38:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e1b32d88-5801-b280-25ed-9902cfaa5092@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 10:22 PM, Jens Axboe wrote:
> On 6/30/21 3:19 PM, Pavel Begunkov wrote:
>> On 6/30/21 10:17 PM, Jens Axboe wrote:
>>> On 6/30/21 2:54 PM, Pavel Begunkov wrote:
>>>> Whenever possible we don't want to fallback a request. task_work_add()
>>>> will be fine if the task is exiting, so don't check for PF_EXITING,
>>>> there is anyway only a relatively small gap between setting the flag
>>>> and doing the final task_work_run().
>>>>
>>>> Also add likely for the hot path.
>>>
>>> I'm not a huge fan of likely/unlikely, and in particular constructs like:
>>>
>>>> -	if (test_bit(0, &tctx->task_state) ||
>>>> +	if (likely(test_bit(0, &tctx->task_state)) ||
>>>>  	    test_and_set_bit(0, &tctx->task_state))
>>>>  		return 0;
>>>
>>> where the state is combined. In any case, it should be a separate
>>> change. If there's an "Also" paragraph in a patch, then that's also
>>> usually a good clue that that particular change should've been
>>> separate :-)
>>
>> Not sure what's wrong with likely above, but how about drop
>> this one then?
> 
> Yep I did - we can do the exiting change separately, the commit message

I think 1-2 is good enough for 5.14, I'll just send it for-next

> just needs to be clarified a bit on why it's ok to do now. And that

It should have been ok to do before those 2 patches, but
haven't tracked where it lost actuality.

-- 
Pavel Begunkov

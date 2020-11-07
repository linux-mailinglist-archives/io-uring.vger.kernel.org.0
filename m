Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D2C2AA850
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 23:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgKGWuq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 17:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKGWup (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 17:50:45 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBE2C0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 14:50:45 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id d12so3447656wrr.13
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 14:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XI9tB+ofoH4QuAUecoFk3l19sJCOmJkzijmmmlF8nzc=;
        b=sjZ706Q5kIQP54oISlfkwB9mg3RvJNNRsI6baPA/sruepVPulrP6weK2wG5ir7Xwjr
         IE/W+dcaUZujj7elDzSzNg2K3nqeVdl7OFQqcnXUzKDDWGUuEIDtFYydoP+8djDiUv2B
         L/XDF0bY96knZwuKnFFlxv1zVu/RdBeLik5CwkxW9TySp6etfZXw6bjXWtioCKGM6cBL
         H6opENnA4plFOKr99lqH6aLFvzXGUhZVA8GrpuAryi4PwtpP7WxgbqPK2sH4nzqQVCXA
         YV05NvvvMVaLavAV1G8PBwcvvQiCAJ8lN5EckNjk/9Tvdj1KriIpZN+HR6nQlXnXPWnh
         nJ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XI9tB+ofoH4QuAUecoFk3l19sJCOmJkzijmmmlF8nzc=;
        b=ZzUjQpaqOaQ6l89wKB13YhikMjG3ZxEZg/MV2t09FrMBNe1GpVEIPUp9jItWX7Fmvs
         spPXr1To3RlF5HBtyeBrIdVvvXS7WqmVCQab1TBQBlxtyRamQRVqLhk6VvYI8JWYXWx2
         mm3Q7zjyTzsk5nx8X1v0oiNb6JQ9XbYjy+FWgKfYpGAYnHf6s5q7Tq6f100TnW0xVvVA
         PpcYKVmDCBMa+IOVa+A7kDwf4wIKO7XRM0J5X3frcTJlrnP4b452tgK+WgHsFY//rrbT
         iuYfQOzY2RlmAnuXe4MRzelJvDvApPvHGlJTDiyG7JB7he7/I2e2GG5nCaidOzJ24Ahw
         m8oA==
X-Gm-Message-State: AOAM530dAmp4ocbTvc3zgErzYGPt/oOPdnpPhTOZhf6xHn+/B0xVm8FT
        8gnmouAoEAFV1yGTbou6yHg+TdRPyZj6mQ==
X-Google-Smtp-Source: ABdhPJzQ2g/xPK8eo3k0B60x3+l8mnn31uLO25azse8gNJXYLGq7InxZ64b27X0uYPy8QjQOkK012g==
X-Received: by 2002:adf:db44:: with SMTP id f4mr9957266wrj.168.1604789444333;
        Sat, 07 Nov 2020 14:50:44 -0800 (PST)
Received: from [192.168.1.96] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id z15sm7806079wrq.24.2020.11.07.14.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 14:50:43 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josef Grieb <josef.grieb@gmail.com>
References: <24446f4e23e80803d3ab1a4d27a6d1a605e37b32.1604783766.git.asml.silence@gmail.com>
 <39db5769-5aef-96f5-305c-2a3250d9ba73@gmail.com>
 <030c3ccb-8777-9c28-1835-5afbbb1c3eb1@gmail.com>
 <97fce91e-4ace-f98b-1e7e-d41d9c15cfb8@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5.11] io_uring: NULL files dereference by SQPOLL
Message-ID: <a8a4ac73-81f9-f703-2f91-a70ff97e5094@gmail.com>
Date:   Sat, 7 Nov 2020 22:47:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <97fce91e-4ace-f98b-1e7e-d41d9c15cfb8@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/11/2020 22:28, Jens Axboe wrote:
> On 11/7/20 2:54 PM, Pavel Begunkov wrote:
>> On 07/11/2020 21:18, Pavel Begunkov wrote:
>>> On 07/11/2020 21:16, Pavel Begunkov wrote:
>>>> SQPOLL task may find sqo_task->files == NULL, so
>>>> __io_sq_thread_acquire_files() would left it unset and so all the
>>>> following fails, e.g. attempts to submit. Fail if sqo_task doesn't have
>>>> files.
>>>
>>> Josef, could you try this one?
>>
>> Hmm, as you said it happens often... IIUC there is a drawback with
>> SQPOLL -- after the creator process/thread exits most of subsequent
>> requests will start failing.
>> I'd say from application correctness POV such tasks should exit
>> only after their SQPOLL io_urings got killed.
> 
> I don't think there's anything wrong with that - if you submit requests
> and exit before they have completed, then you by definition are not
> caring about the result of them.

Other threads may use it as well thinking that this is fine as
they share mm, files, etc.

1. task1 create io_uring
2. clone(CLONE_FILES|CLONE_VM|...) -> task2
3. task1 exits
4. task2 continues to use io_uring

-- 
Pavel Begunkov

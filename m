Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A597A40205B
	for <lists+io-uring@lfdr.de>; Mon,  6 Sep 2021 21:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344050AbhIFTS1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 15:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245690AbhIFTRb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Sep 2021 15:17:31 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2280CC061575
        for <io-uring@vger.kernel.org>; Mon,  6 Sep 2021 12:16:26 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v10so11143259wrd.4
        for <io-uring@vger.kernel.org>; Mon, 06 Sep 2021 12:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YrOB87+N0VLc0mBFBv3sPk5Ttgyx/q1xYmIA+y5ThmA=;
        b=ZXJgVG5lP8FnlUvFkSgwAPSrMKmtrMx9fGxyZnTadCFCCl1Y4/B+B/RIAFBPYsf0WI
         LlPtKxDaxKTniHSnxd3HQkP8W33K85lASgo7zQXnkHBLgEG0tgFFRIImiTBtY4OQSxOI
         r4NN951sK8f6fTOBDlBSrwIWgLMvrlQLniCxECcABdp2g8seo2X7omCCafbgvyD46SsX
         Nf9fTjX3BYJdxiepyZs4tgUujNl3x9MtANhbOEqd0Y36ZTl/MtEq9dzYQr5h8HKFTGbu
         4B4ji2tb2/r6+aDpWoOE7Cai6NVN7o8kEH7CPJZ5By/e5xHy17oHIaaZtyS9Zwvq/UYL
         45mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YrOB87+N0VLc0mBFBv3sPk5Ttgyx/q1xYmIA+y5ThmA=;
        b=FOWT72zxvpJP2lqhPAznE3BoJAaIlKV2sTwQF1j2NkEdm7saqj4CWCNvzm5E4VdNcN
         oN65Ca/jSOagYGl328Hbv2x9nsbWAl3Er1NC7+AeZiKNsQp4GzWSy11HKrOzjqQXtwZO
         PPbPyE/gPDFF2fGdNJYEfIaYRTR9unWIFOtEffsTpsjTolFTZN9oka81X+l1DpB9VqxL
         By0Uytt7ho75p/te2zK2jksE76OOmspY/YgnYeCFtQQaHYjizLroQk2jyln+Q1i4MTsP
         z+7uOQ3nhwNxO4FlV9n7OaeKSNwovoz5+yiAvdX5i1XjVB4NHTnMxKeq+8eeI+UqzlX4
         eZDA==
X-Gm-Message-State: AOAM531HJWV4H+UKjQLb0uuKynU2pN0u+uJvkfrrc5IqZS4WqVausyXD
        TIqYfZY0uxMn5Ea/Zceof81Lvoq7wSM=
X-Google-Smtp-Source: ABdhPJy9c/HRdai3R6Xp7KEC7/x96o58bAujGspuZZO8YhST/2Fq/Ig7HWEGZeAx76mHOTJohWENsA==
X-Received: by 2002:a5d:6602:: with SMTP id n2mr15002097wru.289.1630955783926;
        Mon, 06 Sep 2021 12:16:23 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.4])
        by smtp.gmail.com with ESMTPSA id a77sm350652wmd.31.2021.09.06.12.16.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 12:16:23 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210906151208.206851-1-haoxu@linux.alibaba.com>
 <f3857fde-7b3d-3d4f-9248-18a5387b8f79@gmail.com>
 <702b94b7-bd2f-f89c-b835-3345b8fcaa4a@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: fix bug of wrong BUILD_BUG_ON check
Message-ID: <af3ee4c6-86bc-e8b0-227e-a109c75ae12d@gmail.com>
Date:   Mon, 6 Sep 2021 20:15:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <702b94b7-bd2f-f89c-b835-3345b8fcaa4a@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/6/21 6:03 PM, Hao Xu wrote:
> 在 2021/9/6 下午11:22, Pavel Begunkov 写道:
>> On 9/6/21 4:12 PM, Hao Xu wrote:
>>> Some check should be large than not equal or large than.
>>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   fs/io_uring.c | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 2bde732a1183..3a833037af43 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -10637,13 +10637,13 @@ static int __init io_uring_init(void)
>>>                sizeof(struct io_uring_rsrc_update2));
>>>         /* ->buf_index is u16 */
>>> -    BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
>>> +    BUILD_BUG_ON(IORING_MAX_REG_BUFFERS > (1u << 16));
>>>         /* should fit into one byte */
>>> -    BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
>>> +    BUILD_BUG_ON(SQE_VALID_FLAGS > (1 << 8));
>>
>> 0xff = 255 is the largest number fitting in u8,
>> 1<<8 = 256.
>>
>> let SQE_VALID_FLAGS = 256,
>> (256 > (1<<8)) == (256 > 256) == false,  even though it can't
>> be represented by u8.
> Isn't SQE_VALID_FLAGS = 256 a valid value for it?

SQE_VALID_FLAGS is a "bitwise OR" combination of valid flags, so
can't be go beyond 0xff

>>
>>
>>>       BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
>>> -    BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
>>> +    BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
>>>         req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
>>>                   SLAB_ACCOUNT);
>>>
>>
> 

-- 
Pavel Begunkov

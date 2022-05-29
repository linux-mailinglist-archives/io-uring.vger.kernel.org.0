Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B16537233
	for <lists+io-uring@lfdr.de>; Sun, 29 May 2022 20:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiE2Sk6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 May 2022 14:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiE2Sk4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 May 2022 14:40:56 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A546B4475E
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 11:40:55 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id f21so8754217pfa.3
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 11:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6PXCrYxKkErfgTZfnMIIWdTE5ijAK6Ln2b/LoGfkwOw=;
        b=L/FNyY69BLDtKSCr32wWaao1ICE5w5jb8W4UOAlF/RRZU7uIYWPA5jHpiXRNU6l975
         kDoTSrTQ91alkSUw3xd2EZxObCckCf8/UjLYZ8qrhuA6/bXSNKTtvGyFhxYtWXcOboMN
         5tyEITQAXfDlKnIoRpskCg8gBh3AAgDf5sMGh2GBrGsOwYz197f/Z9zaw7w+7fnWd8FJ
         Dm+b/zg+RGg9W6IXnWjY/BpO5Kg+F+8AUq6t2MgBSsh3o3NOj0//v0O0pJDOTzdvEpjR
         KeU1EHmTZqCYvkyp1d4no7mcFYKLixeOnRQexsonQl9eGZOczD0P/BYzwiwusT0uzczk
         LCqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6PXCrYxKkErfgTZfnMIIWdTE5ijAK6Ln2b/LoGfkwOw=;
        b=Y7HmouEFZJxEXCpT3nQJjGy7axP7/oXFPVZrl8zUD0psUkydZcvKpdLmHYf3z8vWeg
         GFeQKNJf439CWgzXQx5wKpGiV1DVMCG4wMEhpM0vUh0BRYeyNmybNGqaeS/1Nnsc+m8r
         LGFb41YgOBHSLL4pcTVM5qxhnwp8aES9hBBRvzF5kdAiFG6cb1J60TTCcJIr8d71QMB4
         TScYpqmOjE9TAjYaHl7bGrr5xuOaJ3+EI1tXG//Df1Z86KL1rh44dFAbrFSIBvccEKHq
         d4MkYz97m5nl11tYz45K1dxGYS37dRxV3DPnfkFI9gV7OqSdi966RJYy/oFua/JXrHC/
         BGag==
X-Gm-Message-State: AOAM532DPGu70L4acDPJnGaJbemoodAjHXRmITPAJZS3aZE2skNSbBEA
        ikWjD+mG1dVA0AkTglOZ6vejFhC9lSPq0A==
X-Google-Smtp-Source: ABdhPJzt0Y7UK+dmJ2nAkVVuraCYOX4vO/Xz/3eMwEb1Q4BIzCbLq1ty+s+ppx5lOGZMPDqtmnmrww==
X-Received: by 2002:a05:6a00:c84:b0:518:e0f6:f1af with SMTP id a4-20020a056a000c8400b00518e0f6f1afmr25306358pfv.47.1653849655130;
        Sun, 29 May 2022 11:40:55 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d13-20020a170902b70d00b0015e8d4eb263sm7437941pls.173.2022.05.29.11.40.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 May 2022 11:40:54 -0700 (PDT)
Message-ID: <2ed2d510-759b-86fb-8f31-4cb7522c77e6@kernel.dk>
Date:   Sun, 29 May 2022 12:40:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 2/2] io_uring: switch cancel_hash to use per list spinlock
Content-Language: en-US
To:     Hao Xu <haoxu.linux@icloud.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20220529162000.32489-1-haoxu.linux@icloud.com>
 <20220529162000.32489-3-haoxu.linux@icloud.com>
 <37c50986-8a47-5eb4-d416-cbbfd54497b0@kernel.dk>
 <2c7bf862-5d94-892c-4026-97e85ba78593@icloud.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2c7bf862-5d94-892c-4026-97e85ba78593@icloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/29/22 12:07 PM, Hao Xu wrote:
> On 5/30/22 00:25, Jens Axboe wrote:
>> On 5/29/22 10:20 AM, Hao Xu wrote:
>>> From: Hao Xu <howeyxu@tencent.com>
>>>
>>> From: Hao Xu <howeyxu@tencent.com>
>>>
>>> Use per list lock for cancel_hash, this removes some completion lock
>>> invocation and remove contension between different cancel_hash entries
>>
>> Interesting, do you have any numbers on this?
> 
> Just Theoretically for now, I'll do some tests tomorrow. This is
> actually RFC, forgot to change the subject.
> 
>>
>> Also, I'd make a hash bucket struct:
>>
>> struct io_hash_bucket {
>>     spinlock_t lock;
>>     struct hlist_head list;
>> };
>>
>> rather than two separate structs, that'll have nicer memory locality too
>> and should further improve it. Could be done as a prep patch with the
>> old locking in place, making the end patch doing the per-bucket lock
>> simpler as well.
> 
> Sure, if the test number make sense, I'll send v2. I'll test the
> hlist_bl list as well(the comment of it says it is much slower than
> normal spin_lock, but we may not care the efficiency of poll
> cancellation very much?).

I don't think the bit spinlocks are going to be useful, we should
stick with a spinlock for this. They are indeed slower and generally not
used for that reason. For a use case where you need a ton of locks and
saving the 4 bytes for a spinlock would make sense (or maybe not
changing some struct?), maybe they have a purpose. But not for this.

-- 
Jens Axboe


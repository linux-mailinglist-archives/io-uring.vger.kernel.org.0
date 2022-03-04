Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396C24CCBE8
	for <lists+io-uring@lfdr.de>; Fri,  4 Mar 2022 03:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiCDCoS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 21:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiCDCoO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 21:44:14 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30C4B189D
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 18:43:27 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e6so6332144pgn.2
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 18:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=xID1Vlxge20JjmW//TpaoXnSTqXeeJdZnmwCMpHQeQQ=;
        b=J1FHG1JHZOpYSaIOK5J//eNvV4Q08dfRG4YFqUjUGu8YuqraQFmS6YbotBhCo75f/I
         10MTv/9KP6EuqCMZwczqCFgCal6dZPntOs9eLvCnLBk1MUyl+ofPP4suOYLa7P/eZVhj
         tSJyAUNOlz4fHrlEqQA2VwVDZJm0X8A5pMy/w+kXfbuFZSGd+zam7VOPWVsGP/dgB1fX
         fmvDwTO5mnBPRETyvf+LKqEWh1jFUL8tG95jYQr6D3SDHNBU9OAdnnlOzUs6hyeIScK4
         W6Tf6kZspMlkBkq6TUXNMeb3y8PhTlTJJs131Hux00BtVpILlHRR6P1xQXLz6Is6K68s
         Itew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xID1Vlxge20JjmW//TpaoXnSTqXeeJdZnmwCMpHQeQQ=;
        b=b7YFxUqWUTYYi1Tc8+f4H4eYu3Gd9yOL+kfUOVyGwO1OK/0DIRa8noevM+C+sAnkAA
         Ya7OFlFZP8EdBG8lAGvw45gwH3ysqV2UFJSFqfL0PVRpZiEQp5eDuEsqZ7FtFUJ2Ny45
         63BTSZ2P/iNCJnhhu+LFfugYAVhXfGRi5nsIZtnZZYWHEGkKHp/mE3Clz+r4gKnRK7aC
         ygaJpH5JnQoFh8ou/9DW4X0JlSNqfVvl5wONn1V7YtCZAfWXy+bwRn9rMDP0xcpWf0zT
         S1anG7oRT1y4UihxTeJOcHdSP+mKJL2by8LJJ68uNLaE+8sbrUdgOTT3Ri0mAbFaTFV2
         NOQA==
X-Gm-Message-State: AOAM532+gSolp4OtKc5/HWh23sGJp9Qkq12DC7sjJTHIJbKf+twyt5Vq
        DPNFrY2vJNwDy6nYRgOu49TJaA==
X-Google-Smtp-Source: ABdhPJwDHOSSfa0O1+LF6eU0X/EZjJ6Exi9o0YtzwUxBAVqT4wlVsoAnPmC8WAgNTxJYeDHYiIUx8Q==
X-Received: by 2002:a05:6a00:181c:b0:4e1:a270:df4d with SMTP id y28-20020a056a00181c00b004e1a270df4dmr40877852pfa.71.1646361807266;
        Thu, 03 Mar 2022 18:43:27 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f4-20020a056a00238400b004e10b67e658sm3821059pfc.3.2022.03.03.18.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 18:43:26 -0800 (PST)
Message-ID: <8726251d-1bc9-f24b-120a-6a341462cbb3@kernel.dk>
Date:   Thu, 3 Mar 2022 19:43:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
 <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
 <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
 <559685fd-c8aa-d2d4-d659-f4b0ffc840d4@gmail.com>
 <bf325a86-91a4-aa70-dbda-9b12b3677a8c@kernel.dk>
 <5a0f0fe0-e180-90fc-aa23-4e0faa9896bc@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5a0f0fe0-e180-90fc-aa23-4e0faa9896bc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/3/22 7:28 PM, Pavel Begunkov wrote:
> On 3/4/22 02:18, Jens Axboe wrote:
>> On 3/3/22 6:49 PM, Pavel Begunkov wrote:
>>> On 3/3/22 16:31, Jens Axboe wrote:
>>>> On 3/3/22 7:40 AM, Jens Axboe wrote:
>>>>> On 3/3/22 7:36 AM, Jens Axboe wrote:
>>>>>> The only potential oddity here is that the fd passed back is not a
>>>>>> legitimate fd. io_uring does support poll(2) on its file descriptor, so
>>>>>> that could cause some confusion even if I don't think anyone actually
>>>>>> does poll(2) on io_uring.
>>>>>
> [...]
>>>> which is about a 15% improvement, pretty massive...
>>>
>>> Is the bench single threaded (including io-wq)? Because if it
>>> is, get/put shouldn't do any atomics and I don't see where the
>>> result comes from.
>>
>> Yes, it has a main thread and IO threads. Which is not uncommon, most
>> things are multithreaded these days...
> 
> They definitely are, just was confused by the bench as I can't
> recall t/io_uring having >1 threads for nops and/or direct bdev I/O

It has a main task that spawns a thread for each job. Even for nops
that's true. The main task just checks progress of each IO job (thread)
and prints it, sleeping most of the time.

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EB966D0D2
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 22:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjAPVSP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 16:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbjAPVSM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 16:18:12 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87E43A9D
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 13:18:11 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id b17so24005121pld.7
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 13:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1d3Xzv/SPONJd9JXDkOhzRJ+H2SbodTz2Z+6Xt/3CVw=;
        b=zGjw9GY7zbkYBeqRKpCiXOteNXSa1q7W6O9vSWVU9CSALwsbrW+/VJGztfWWTjLtc8
         zC+5dxwE4olOHKt49kYcR9X8sDGAlmXzdrUHa70LXGcEhhzn4QyVE1JK7772dPtabQDi
         P0JmCK1QdgMzUyrToO9eU9OkhPfiKOuOfi0q3FdbWL/sNHobI5+V8vkPmPg91P6R0AAc
         3bweyDLNuYJ0HomnIBLs70hBZBx8COfthGzoWKdgqmd1FM58g5QfSXTdRfIMwSOe5pZg
         pLqv+zjccSe1ePOsgQvZNlU/q3POM3CJhZtLBH8/dN4dtuzvZIDzIWIPHyEY++85KBLZ
         aYtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1d3Xzv/SPONJd9JXDkOhzRJ+H2SbodTz2Z+6Xt/3CVw=;
        b=IWf9OscTL7uFP7d5FCZ/0nTbnf5s9XjmBtKqTSLTUZ4oFr6F7G8Isz5OsAV7hxfM8P
         KaJKxELXN3enUC6LS5C3Nh+TyatrTNSoq8Srqs5K+p8Ud33s51+c+M5x+Z4H+8E3N2lQ
         9d+D11QZuahQGYMUH7h2bQQS0bqB7S0h78zUWNj2rsOgHnx3jB8RvpkpRa1K+l0Zkads
         saJnX63GjQg7g3PUZOI27SKKfQ+IXmsrfUElOtbSv5rUoH1DTUuVxSwzyFTXUNGWKkS2
         R17BVzTq03k0Ee/TbVJGZHARdMULjbsdJbJMPi12tSUa7FtGGAxfA9n9JLmJiRUgbmbN
         s1ZQ==
X-Gm-Message-State: AFqh2koKxThxRWchz/+Vuq5RRAL1pC/FRXAr2PmR5dhFYy64u4fT7eMa
        oX1bp3bfnkeahZhYB05pwKEaTeC4AOLGsfr4
X-Google-Smtp-Source: AMrXdXtyqKOUVoGemnj+G/YhzwJWnEupUtk919fmwntMFmVMbI1tXEyTBXGOUiecWwEg2Tr7rn8zJg==
X-Received: by 2002:a05:6a20:4407:b0:af:6d54:89fe with SMTP id ce7-20020a056a20440700b000af6d5489femr105317pzb.6.1673903891212;
        Mon, 16 Jan 2023 13:18:11 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b11-20020a17090a5a0b00b0022704cc03ebsm14374670pjd.41.2023.01.16.13.18.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 13:18:10 -0800 (PST)
Message-ID: <45bcbad9-f69a-66b1-a196-3bfebce08d71@kernel.dk>
Date:   Mon, 16 Jan 2023 14:18:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH for-next 1/5] io_uring: return back links tw run
 optimisation
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1673887636.git.asml.silence@gmail.com>
 <6328acdbb5e60efc762b18003382de077e6e1367.1673887636.git.asml.silence@gmail.com>
 <3b01c5b6-9b4c-0f7e-0fdf-67eb7c320bf0@kernel.dk>
 <92413c12-5cd1-7b3b-b926-0529c92a927a@gmail.com>
 <427936d0-f62b-3840-6a59-70138d278cb8@kernel.dk>
 <011cdcb4-4ab1-f680-9409-d5234acf9a1d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <011cdcb4-4ab1-f680-9409-d5234acf9a1d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/23 2:15 PM, Pavel Begunkov wrote:
> On 1/16/23 21:04, Jens Axboe wrote:
>> On 1/16/23 12:47 PM, Pavel Begunkov wrote:
>>> On 1/16/23 18:43, Jens Axboe wrote:
>>>> On 1/16/23 9:48 AM, Pavel Begunkov wrote:
>>>>> io_submit_flush_completions() may queue new requests for tw execution,
>>>>> especially true for linked requests. Recheck the tw list for emptiness
>>>>> after flushing completions.
>>>>
>>>> Did you check when it got lost? Would be nice to add a Fixes link?
>>>
>>> fwiw, not fan of putting a "Fixes" tag on sth that is not a fix.
>>
>> I'm not either as it isn't fully descriptive, but it is better than
>> not having that reference imho.
>>
>>> Looks like the optimisation was there for normal task_work, then
>>> disappeared in f88262e60bb9c ("io_uring: lockless task list").
>>> DEFERRED_TASKRUN came later and this patch handles exclusively
>>> deferred tw. I probably need to send a patch for normal tw as well.
>>
>> So maybe just use that commit? I can make a note in the message on
>> how it relates.
> 
> Yes please, thanks

Done:

https://git.kernel.dk/cgit/linux-block/commit/?h=for-6.3/io_uring&id=b48f4ef033089cf03c28bb09ae054dbfdf11635a

-- 
Jens Axboe



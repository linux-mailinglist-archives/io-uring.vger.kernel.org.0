Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C1D76B96D
	for <lists+io-uring@lfdr.de>; Tue,  1 Aug 2023 18:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbjHAQIV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Aug 2023 12:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbjHAQIR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Aug 2023 12:08:17 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486F11727;
        Tue,  1 Aug 2023 09:08:15 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-977e0fbd742so814064966b.2;
        Tue, 01 Aug 2023 09:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690906094; x=1691510894;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dm0S5N5nNRyhMSfQrHUdCAaT/Y7WRmsF/K23ENIMIFE=;
        b=MV2ovpB5GUaqs1kinTdOTIYLpfVD5VHaHjAmVuWX+MrhM+bnOHh9TBvV9UM8TrNKyS
         5e3ZPEOik80Dy0it6kgfhlbrkMlowbgXyY8IQWsAlkYEBwAfIsBrYpmbHdqb875j2S4X
         BgfiKzpPeGm8Tk69RviVqFvOk644XSlpUGFQFmFl3zYXT/e3FgUy1p1wNrChWaEdFmj4
         egSo8DJPSagEZVYtd/Ka3tRZ1h6ZRvpUUWjyob35GC/dpu/8Xi2bL6FjU18jtj0xQadL
         r/c4q/3K01xtZ1VOcUcgHS2KhxfMYf3GrA7KV+0h7SfJQiqZW/+NN5/gOLX7R3gu2W4M
         dKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690906094; x=1691510894;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dm0S5N5nNRyhMSfQrHUdCAaT/Y7WRmsF/K23ENIMIFE=;
        b=QnKOOAjvvFbvpbRRC50nkh/eiOzPMG5GpKFEqAPKA2iwb29/yFytCEosvEpAl1kWmA
         xthL8FqWSXyWvsavTYehKeEDfz4DCjuwHM5ea9mTqWef75T25jB/g2xe3ZCSdRbUNPpz
         QiU6F3VheihYCOgMLMfxsVKtwxAUm/nwziQHAO6ZuWyOU2g8RyIsNyya163KJQqlvCGW
         fh4mCvbbvUENFSraLxkqxIPnb44PS2+Nlu62kCf6vQllsiurCaKDYeGl8Qp9rPcJnBgx
         6r7ayjFPdCZ7ol3iRNJ9eTdr1MhagJsoPI8dFTO+RLOY24CFUHQGLDxCgU/JRJ7UVm7y
         wSRw==
X-Gm-Message-State: ABy/qLZ4+lm6N4Wo6xm9KeV3KjTNKpUbNnNK5oL43q0vaUlMgXKyWE7W
        +/iDE2sArPSbcPmYwmQT5Sc=
X-Google-Smtp-Source: APBJJlEhJLmDMeDuTpBA9ApKtdXMe4/obO/ZoSW7sy8z1dsaqvi6FloHPUL4+kNpAT4Ne4SMm04ftA==
X-Received: by 2002:a17:906:64c5:b0:99b:e04d:307d with SMTP id p5-20020a17090664c500b0099be04d307dmr2795655ejn.57.1690906093445;
        Tue, 01 Aug 2023 09:08:13 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:d658])
        by smtp.gmail.com with ESMTPSA id g24-20020a1709064e5800b0099316c56db9sm7810903ejw.127.2023.08.01.09.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 09:08:13 -0700 (PDT)
Message-ID: <dd4e7013-b4fc-4135-51a7-806127c2013b@gmail.com>
Date:   Tue, 1 Aug 2023 17:05:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: split req init from submit
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@meta.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20230728201449.3350962-1-kbusch@meta.com>
 <9a360c1f-dc9a-e8b4-dbb0-39c99509bb8d@gmail.com>
 <22d99997-8626-024d-fae2-791bb0a094c3@kernel.dk>
 <ce3e1cf4-40a0-adde-e66b-487048b3871d@gmail.com>
 <ZMkiHoVbdBoUSxLy@kbusch-mbp.dhcp.thefacebook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZMkiHoVbdBoUSxLy@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/1/23 16:17, Keith Busch wrote:
> On Tue, Aug 01, 2023 at 03:13:59PM +0100, Pavel Begunkov wrote:
>> On 7/31/23 22:00, Jens Axboe wrote:
>>> On 7/31/23 6:53?AM, Pavel Begunkov wrote:
>>>> On 7/28/23 21:14, Keith Busch wrote:
>>>>> From: Keith Busch <kbusch@kernel.org>
>>>>>
>>>>> Split the req initialization and link handling from the submit. This
>>>>> simplifies the submit path since everything that can fail is separate
>>>>> from it, and makes it easier to create batched submissions later.
>>>>
>>>> Keith, I don't think this prep patch does us any good, I'd rather
>>>> shove the link assembling code further out of the common path. I like
>>>> the first version more (see [1]). I'd suggest to merge it, and do
>>>> cleaning up after.
>>>>
>>>> I'll also say that IMHO the overhead is well justified. It's not only
>>>> about having multiple nvmes, the problem slows down cases mixing storage
>>>> with net and the rest of IO in a single ring.
>>>>
>>>> [1] https://lore.kernel.org/io-uring/20230504162427.1099469-1-kbusch@meta.com/
>>>
>>> The downside of that one, to me, is that it just serializes all of it
>>> and we end up looping over the submission list twice.
>>
>> Right, and there is nothing can be done if we want to know about all
>> requests in advance, at least without changing uapi and/or adding
>> userspace hints.
>>
>>> With alloc+init
>>> split, at least we get some locality wins by grouping the setup side of
>>> the requests.
>>
>> I don't think I follow, what grouping do you mean? As far as I see, v1
>> and v2 are essentially same with the difference of whether you have a
>> helper for setting up links or not, see io_setup_link() from v2. In both
>> cases it's executed in the same sequence:
>>
>> 1) init (generic init + opcode init + link setup) each request and put
>>     into a temporary list.
>> 2) go go over the list and submit them one by one
>>
>> And after inlining they should look pretty close.
> 
> The main difference in this one compared to the original version is that
> everything in the 2nd loop is just for the final dispatch. Anything that
> can fail, fallback, or defer to async happens in the first loop. I'm not
> sure that makes a difference in runtime, but having the 2nd loop handle
> only fast-path requests was what I set out to do for this version.

For performance it doesn't matter, it's a very slow path and we should
not be hitting it. And it only smears single req submission over multiple
places, for instance it won't be legal to use io_submit_sqe() without
those extra checks. Those are all minor points, but I don't think it's
anyhow better than v1 in this aspect.

-- 
Pavel Begunkov

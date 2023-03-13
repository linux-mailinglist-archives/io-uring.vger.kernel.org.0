Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A0F6B7FC4
	for <lists+io-uring@lfdr.de>; Mon, 13 Mar 2023 18:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjCMRwR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Mar 2023 13:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjCMRwQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Mar 2023 13:52:16 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1269579B27;
        Mon, 13 Mar 2023 10:51:31 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id o12so52023484edb.9;
        Mon, 13 Mar 2023 10:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678729888;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YGrBjDZ2Zc6u6UxmebWPTHkLzUzG84K3Kc3C+1OVyfU=;
        b=KrfwEl9QUf23LUJ5nCacne9i+yman/j8jfbMdcEZilQ8nizFbmInYnDjwFOFlMqL3j
         Si+Yzff+4qvB5F/lSzag5wk1rxVhgsGrF0tFmJGdfnI3e22iXkvjKtP13M0VfPq0/ILM
         /1XcMHHjjpSfGzQW5uiqx6Jp5Sn/i9dUJIU/UXAhHi+Yu12ZxEghiORbg2A/LOYRfrgJ
         mk6Bt+bRAE5IxWCjMXZb7S7YsE28EaHhOXr0jwLqx6vAVW7IBAnb4NV1XurnFWDeG0Rr
         ERTKHflE/TWWEAIezONEIaNceoK5+Acfu4udZQT85Q4RSvKZ8hQiFQh7/GxcgoxIzsss
         JJYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678729888;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YGrBjDZ2Zc6u6UxmebWPTHkLzUzG84K3Kc3C+1OVyfU=;
        b=3OiAXXYC2+krsybY+M7IXZnWSB/Vy4+Ysspl9jJxmQIdb9L+966axNUKW01J5gRC0W
         GbaUAPGrTmHWfc0dqIrVDX/4sQepRdpEEkr9yX+duhG4cqAdlc5uG5BvsUeFTKpFCvrr
         K0MJH9RVei8dgeYLB4PYV8HHhqzlLVNjKS4CxEh1rfVRJ6AsoPEP0uP0DuoL3rD56hMP
         Gyf5Xx4B3vlSi0qck+NbxEIRsgaGL5YGOhpwQZ5hw+y8F75VgailUj36DjiqPMJdKfqc
         Ch1+PQxLK+K2fKG42lxlycSBQKsPJ2W4C5ozUrHR4WjUuUXhXbhVuK7vWhAlCie54XVy
         0xdw==
X-Gm-Message-State: AO0yUKWxOf4yozBwtXTw7ZqJ5Or4TrgJyOUtc6r+66ofYJvXguYh1+vJ
        YaKRvRpcHeyh6seqH04IG+0QV2VNruI=
X-Google-Smtp-Source: AK7set9+g1jxKWeagU7B8FgLtyIzFONzuAYfgDhI1ZjV5suOx2SZ4MjD5kLiM8WMYXIen+kH/0k23g==
X-Received: by 2002:a05:6402:2d8:b0:4f9:a97d:469b with SMTP id b24-20020a05640202d800b004f9a97d469bmr9879523edx.10.1678729887965;
        Mon, 13 Mar 2023 10:51:27 -0700 (PDT)
Received: from [192.168.8.100] (188.30.129.33.threembb.co.uk. [188.30.129.33])
        by smtp.gmail.com with ESMTPSA id v12-20020a17090651cc00b008e938e98046sm61056ejk.223.2023.03.13.10.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 10:51:27 -0700 (PDT)
Message-ID: <ad5d6234-b11d-7ac6-0218-78058df99712@gmail.com>
Date:   Mon, 13 Mar 2023 17:50:28 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [RFC 0/2] optimise local-tw task resheduling
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1678474375.git.asml.silence@gmail.com>
 <9250606d-4998-96f6-aeaf-a5904d7027e3@kernel.dk>
 <ee962f58-1074-0480-333b-67b360ea8b87@gmail.com>
 <9322c9ab-6bf5-b717-9f25-f5e55954db7b@kernel.dk>
 <4ed9ee1e-db0f-b164-4558-f3afa279dd4f@gmail.com>
 <c433f8cf-57dc-52c9-9959-f6a21297d1b0@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c433f8cf-57dc-52c9-9959-f6a21297d1b0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/13/23 14:16, Jens Axboe wrote:
> On 3/12/23 9:45?PM, Pavel Begunkov wrote:
>>>>> Didn't take a closer look just yet, but I grok the concept. One
>>>>> immediate thing I'd want to change is the FACILE part of it. Let's call
>>>>> it something a bit more straightforward, perhaps LIGHT? Or LIGHTWEIGHT?
>>>>
>>>> I don't really care, will change, but let me also ask why?
>>>> They're more or less synonyms, though facile is much less
>>>> popular. Is that your reasoning?
>>
>>> Yep, it's not very common and the name should be self-explanatory
>>> immediately for most people.
>>
>> That's exactly the problem. Someone will think that it's
>> like normal tw but "better" and blindly apply it. Same happened
>> before with priority tw lists.
> 
> But the way to fix that is not through obscure naming, it's through
> better and more frequent review. Naming is hard, but naming should be
> basically self-explanatory in terms of why it differs from not setting
> that flag. LIGHTWEIGHT and friends isn't great either, maybe it should
> just be explicit in that this task_work just posts a CQE and hence it's
> pointless to wake the task to run it unless it'll then meet the criteria
> of having that task exit its wait loop as it now has enough CQEs
> available. IO_UF_TWQ_CQE_POST or something like that. Then if it at some

There are 2 expectations (will add a comment)
1) it's posts no more that 1 CQE, 0 is fine

2) it's not urgent, including that it doesn't lock out scarce
[system wide] resources. DMA mappings come to mind as an example.

IIRC is a problem even now with nvme passthrough and DEFER_TASKRUN

> point gets modified to also encompass different types of task_work that
> should not cause wakes, then it can change again. Just tossing
> suggestions out there...

I honestly don't see how LIGHTWEIGHT is better. I think a proper
name would be _LAZY_WAKE or maybe _DEFERRED_WAKE. It doesn't tell
much about why you would want it, but at least sets expectations
what it does. Only needs a comment that multishot is not supported.

-- 
Pavel Begunkov

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A233741C363
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 13:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhI2L0O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 07:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhI2L0N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 07:26:13 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E45C06161C
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 04:24:32 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id c73-20020a1c9a4c000000b0030d040bb895so1489812wme.2
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 04:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=diDHUt79MIETINud/0K6J6ATVXZv/P07NT77lC8PHlw=;
        b=T987MInpGBPgZUn5rQJb41f2al47fDIRRCKOWtVJT5X40UA1ghASaAMtOEoes2Tzmc
         k/kOH+xiFdR5p8/6dkNNTq0Gou068x84JOLMcPmzF4jRSOyjZuViur2JGhQoO3QcucIT
         Nq0nK/yzohKnVYrW0X6yxJTGiT+Gr7EnaTnC2mI+47lPm/5qwa/ygVI+GH6zeJPC1FjB
         XjrnIMB/eT76XjLA2reQxGW5RdsN5mwJC5wiaKM5WHpEtkR5F7S11esaB3aKFu4yGpqG
         fqQAiQusiwVAid1+iwzmhB0shrTkIom+hUEK9iUL26zqurkcwTdsroDBvtcsmqJpV25S
         q5hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=diDHUt79MIETINud/0K6J6ATVXZv/P07NT77lC8PHlw=;
        b=3gDU1nn3+x6dXpy0pY5p96+btGorr7znOcizVvAQjG6/KnUBe+jNVfeMeZIBD9djW6
         0p74nXjsBNFqs6xSs8Bt1yxobJZdsYvXJzOI3baaZBCp2yt7DsyN6rvNJnwlV2bPujwX
         gB903VTPjhm1XAmlrM6YXHfDfiVsxfEMOAwkqEV2nORs+4JxMC8qL6WO0uMqMFtl7301
         I4uhW/p5EnCCqw9EQMW1KVt/ZCz8ABusOYWobrukoy0FHKOO3UUal4ig3mxGV55wetXw
         r8fv1Nedz3nZc+hx7/vvH1Wx8EdGS7lgvv/1wdAJOhw/PUXCQBJJFZbd+xG43JEpR5J4
         9BIg==
X-Gm-Message-State: AOAM532UTIWfLzi/hygM0lzMQ38MyMHPSIHNhMwTiwlqBcBXs1YhsRsq
        nC25Am6en2Ov8ky1lVstJJA=
X-Google-Smtp-Source: ABdhPJxTS9sKzvdlecmJr/b8RKvUO12oqroXu8RnuAGsj7aS/EmacWuHuIPCokPa6GvO1Ahk2Ue1JQ==
X-Received: by 2002:a7b:cb8a:: with SMTP id m10mr618968wmi.194.1632914671393;
        Wed, 29 Sep 2021 04:24:31 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.229])
        by smtp.gmail.com with ESMTPSA id k17sm1996026wrq.7.2021.09.29.04.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 04:24:31 -0700 (PDT)
Subject: Re: [PATCH 2/8] io-wq: add helper to merge two wq_lists
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210927061721.180806-1-haoxu@linux.alibaba.com>
 <20210927061721.180806-3-haoxu@linux.alibaba.com>
 <e01e512d-2666-ae0d-2e26-ca5368f58aae@gmail.com>
 <2fcd4b88-af21-53e0-0f5a-e15f87182df6@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <dd3159cd-a97c-5530-ac4d-5479a4c94a25@gmail.com>
Date:   Wed, 29 Sep 2021 12:23:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <2fcd4b88-af21-53e0-0f5a-e15f87182df6@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/28/21 5:48 PM, Hao Xu wrote:
> 在 2021/9/28 下午7:10, Pavel Begunkov 写道:
>> On 9/27/21 7:17 AM, Hao Xu wrote:
>>> add a helper to merge two wq_lists, it will be useful in the next
>>> patches.
>>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   fs/io-wq.h | 20 ++++++++++++++++++++
>>>   1 file changed, 20 insertions(+)
>>>
>>> diff --git a/fs/io-wq.h b/fs/io-wq.h
>>> index 8369a51b65c0..7510b05d4a86 100644
>>> --- a/fs/io-wq.h
>>> +++ b/fs/io-wq.h
>>> @@ -39,6 +39,26 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
>>>           list->last = node;
>>>   }
>>>   +/**
>>> + * wq_list_merge - merge the second list to the first one.
>>> + * @list0: the first list
>>> + * @list1: the second list
>>> + * after merge, list0 contains the merged list.
>>> + */
>>> +static inline void wq_list_merge(struct io_wq_work_list *list0,
>>> +                     struct io_wq_work_list *list1)
>>> +{
>>> +    if (!list1)
>>> +        return;
>>> +
>>> +    if (!list0) {
>>> +        list0 = list1;
>>
>> It assigns a local var and returns, the assignment will be compiled
>> out, something is wrong
> True, I've corrected it in v2.

Was looking at a wrong version then, need to look through v2

>>
>>> +        return;
>>> +    }
>>> +    list0->last->next = list1->first;
>>> +    list0->last = list1->last;
>>> +}
>>> +
>>>   static inline void wq_list_add_tail(struct io_wq_work_node *node,
>>>                       struct io_wq_work_list *list)
>>>   {
>>>
>>
> 

-- 
Pavel Begunkov

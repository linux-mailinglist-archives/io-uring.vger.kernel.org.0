Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA08709AC4
	for <lists+io-uring@lfdr.de>; Fri, 19 May 2023 17:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbjESPBF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 May 2023 11:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjESPBE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 May 2023 11:01:04 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0755C7;
        Fri, 19 May 2023 08:01:02 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-965ddb2093bso540539466b.2;
        Fri, 19 May 2023 08:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684508461; x=1687100461;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=je43+87Nncf36gsbdool2l95YktndtS5xq/YNUWKH6A=;
        b=bDlqP6XBFDnRimjKurP0Mve8R999EqOyYO9bD9aSVaAipqV/jC8U2eTIwejgGD5/3K
         cREerVRbFJH75MZEmuz2/s6VjCBT6xotw4a9UxtmG1jyX8dUk1+P1tr8y6ZwxQniyWfv
         c5oboSnZ6b3JGSK0NYhEAooUD3iVm5GQ32PS3sPkFvD7ZBYRTkh8RLaXczGghKOnEyFQ
         FhDMJt05LMyR0oZg0m6xyXPjXBdVFcrIvez2Uj+3lAMmGoyKKffFlNHncEIMx/Jkkynk
         iN1NNeBJW7kiZnsG+kIrUiCyHMeOj6zP6h/G5l0w4c31iHGvRulSKlFYW2u3P2rQ+5t9
         CPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684508461; x=1687100461;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=je43+87Nncf36gsbdool2l95YktndtS5xq/YNUWKH6A=;
        b=DvAneIZeAZvOkckudFa2mVfG334DvtC8AL4sZ3zgA0FEjC8JTcoA7xlOEQadJwlNVu
         FAwn2SmvNmlrJqpbwGz+S+RnkZnJjB4ixfwKocM7DlNq2f8L5RLa9IHLFHx9LshbuGE2
         aEqAW0ufXmjFlf5zehRSaVIXwOad27vhEgP8sDtzVbTKG0yY9BOEiyN7kc854mHI47Or
         hwYvsrAQm6sxjPRo6yLm9skaSsuC7fsGVpb+OpMG5H6rDtAevwxaC/4i4cfNWFQFNlzB
         iNqBKEyD8yIqKhQGkOPt2T2yhlu+RMw+OZ9bhjYlR9H+4shPUN8XJDT99cjKmxGx0Zqm
         IBIg==
X-Gm-Message-State: AC+VfDxBg8a60WeBg9UkWjfW8TW9D3U1K+ML/dKGt8RN5VFNobM0oQC1
        yCI+syeCMqrY56aK/zaKioo=
X-Google-Smtp-Source: ACHHUZ5L3f619dJCgPXmv+KTPelmUebsut8MesHtZHOiUqb1tFQpIobnXzIqLxVfuIXtkey1K3uQEA==
X-Received: by 2002:a17:907:2d8d:b0:96a:78ee:7e27 with SMTP id gt13-20020a1709072d8d00b0096a78ee7e27mr1853484ejc.59.1684508460431;
        Fri, 19 May 2023 08:01:00 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:f667])
        by smtp.gmail.com with ESMTPSA id ju4-20020a17090798a400b0094f698073e0sm2347736ejc.123.2023.05.19.08.01.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 08:01:00 -0700 (PDT)
Message-ID: <c24cd0d1-3926-27c7-4858-d84293bde6d4@gmail.com>
Date:   Fri, 19 May 2023 16:00:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH for-next 1/2] io_uring/cmd: add cmd lazy tw wake helper
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me
References: <cover.1684154817.git.asml.silence@gmail.com>
 <CGME20230515125841epcas5p3e3cba6545755e95739e1561222b00b4a@epcas5p3.samsung.com>
 <5b9f6716006df7e817f18bd555aee2f8f9c8b0c3.1684154817.git.asml.silence@gmail.com>
 <20230516100000.GA26860@green245>
 <65514f94-ac70-08df-a866-fe73f95037fd@gmail.com>
 <20230517103346.GA15743@green245>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230517103346.GA15743@green245>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/23 11:33, Kanchan Joshi wrote:
> On Tue, May 16, 2023 at 07:52:23PM +0100, Pavel Begunkov wrote:
>> On 5/16/23 11:00, Kanchan Joshi wrote:
>>> On Mon, May 15, 2023 at 01:54:42PM +0100, Pavel Begunkov wrote:
>>>> We want to use IOU_F_TWQ_LAZY_WAKE in commands. First, introduce a new
>>>> cmd tw helper accepting TWQ flags, and then add
>>>> io_uring_cmd_do_in_task_laz() that will pass IOU_F_TWQ_LAZY_WAKE and
>>>> imply the "lazy" semantics, i.e. it posts no more than 1 CQE and
>>>> delaying execution of this tw should not prevent forward progress.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
[...]
>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>> index 5e32db48696d..476c7877ce58 100644
>>>> --- a/io_uring/uring_cmd.c
>>>> +++ b/io_uring/uring_cmd.c
>>>> @@ -20,16 +20,24 @@ static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
>>>>     ioucmd->task_work_cb(ioucmd, issue_flags);
>>>> }
>>>>
>>>> -void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>>>> -            void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>>>> +void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
>>>> +            void (*task_work_cb)(struct io_uring_cmd *, unsigned),
>>>> +            unsigned flags)
>>>> {
>>>>     struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
>>>>
>>>>     ioucmd->task_work_cb = task_work_cb;
>>>>     req->io_task_work.func = io_uring_cmd_work;
>>>> -    io_req_task_work_add(req);
>>>> +    __io_req_task_work_add(req, flags);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(__io_uring_cmd_do_in_task);
>>
>> --- a/include/linux/io_uring.h
>> +++ b/include/linux/io_uring.h
>>
>> +static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>> +            void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>> +{
>> +    __io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
>> +}
>>
>> That should fail for nvme unless exported.
> 
> But it does not. Give it a try.

Took the first patch, killed the export and compiled ublk
and nvme as modules:

ERROR: modpost: "__io_uring_cmd_do_in_task" [drivers/block/ublk_drv.ko] undefined!
ERROR: modpost: "__io_uring_cmd_do_in_task" [drivers/nvme/host/nvme-core.ko] undefined!


diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 476c7877ce58..3bb43122a683 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -30,7 +30,6 @@ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
  	req->io_task_work.func = io_uring_cmd_work;
  	__io_req_task_work_add(req, flags);
  }
-EXPORT_SYMBOL_GPL(__io_uring_cmd_do_in_task);
  

>>> Any reason to export this? No one is using this at the moment.
>>>> +void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
>>>> +            void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>>>> +{
>>>> +    __io_uring_cmd_do_in_task(ioucmd, task_work_cb, IOU_F_TWQ_LAZY_WAKE);
>>>> }
>>>> -EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
>>>> +EXPORT_SYMBOL_GPL(io_uring_cmd_do_in_task_lazy);
>>>
>>> Seems you did not want callers to pass the the new flag (LAZY_WAKE) and
>>> therefore this helper.
>>
>> Yep, I wouldn't mind exposing just *LAZY_WAKE but don't want
>> to let it use whatever flags there might be in the future.
>>
>> Initially I wanted to just make io_uring_cmd_complete_in_task and
>> io_uring_cmd_do_in_task_lazy static inline, but that would need
>> some code shuffling to make it clean.
>>
>>> And if you did not want callers to know about this flag (internal
>>> details of io_uring), it would be better to have two exported helpers
>>> io_uring_cmd_do_in_task_lazy() and io_uring_cmd_complete_in_task().
>>> Both will use the internal helper __io_uring_cmd_do_in_task with
>>> different flag.
>>
>> That's how it should be in this patch
> 
> Nah, in this patch __io_uring_cmd_do_in_task is exported helper. And
> io_uring_cmd_complete_in_task has been changed too (explicit export to
> header based one). Seems like bit more shuffling than what is necessary.

With the end goal to turn them into inline helpers later on
I think it's fine.

-- 
Pavel Begunkov

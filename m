Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BED264632F
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 22:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiLGVWb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Dec 2022 16:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiLGVWa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Dec 2022 16:22:30 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2027E81DA4
        for <io-uring@vger.kernel.org>; Wed,  7 Dec 2022 13:22:29 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id 3so6346324iou.12
        for <io-uring@vger.kernel.org>; Wed, 07 Dec 2022 13:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JRP5cprIoCaFgEGnHc3e9cPGdTfjfrCjauOnZo8AdxI=;
        b=ge5LeiGaCLtPqkf9qcJd9Hvjvh0XEhWMAenPvuAg7OOqbcRBeGtzAwVwn+uxlqfKJt
         HA3HFpKcuvisEcd+V1NskmV1Qbvo2o5XGHrQwsheZnbB5jDQoFfR61Vqdy4rd5HWSjkP
         frfFkVOCIcGeOzMo1TGOuZJkcdiDTfXx9mJWs7nOIGEx+jMyRNp8xIt6owXR/d0covuO
         0Y5WNaszv8tovTJiIN2Y+c8T3b1xScnxn+vJvZzm88+erWHgdKX188QRj7C1DWMk2fsL
         4GhGLvtEUjjxpR7kEOchmLSx2Tn9DSPnYmdTTz0+fkzCpHh2RBbLClL9UEMXqs8juDMG
         vwCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JRP5cprIoCaFgEGnHc3e9cPGdTfjfrCjauOnZo8AdxI=;
        b=P4+7eWpss7HgHqdFqZZZNcbZSMmSe+1LuPEmEooS6q5QJxJix5S1Mc9JF7me8RlZum
         GAb0Gs2n1i/Eg2WI7yV2XpEdyZIOE/P0D4YHpS8oYJ8DTHPsPPYispsN6juciUu+Fkxy
         QkvSz/H9CtYZhyZo3pulcnlctHUp4mZZralSDm8Ulfkl6z+FjfSuXBLBjjhioU1kEq5h
         +OATQVAcpnAdOismA2wWgLS8tOCrPLTZurvYnbrPtwGsp8TVVGoBtPg425hpkpzSPKPa
         lrumnGZJF9FYGNzyICcgF1Q/DSW3MIFfefw5JNt1E1ImxGFmTkEM58zqfs3REkfZkbQM
         jnrA==
X-Gm-Message-State: ANoB5pk7flPWQrK3urZy27wLSkucgjtiab33q9eIujhI712VXkxJk+qw
        kUxsZFnNEsF2qJ3WniBvLU+NVaLKKsbZEsv1uJQ=
X-Google-Smtp-Source: AA0mqf5l7M+PVZF7OX0TKpte5V7StFemiDSpMgV7P/X6tFHP3fu/GRtKI8sUzDY4I4mEBRqDxnSpcQ==
X-Received: by 2002:a05:6602:8c7:b0:6d9:f871:7b20 with SMTP id h7-20020a05660208c700b006d9f8717b20mr34430574ioz.152.1670448148314;
        Wed, 07 Dec 2022 13:22:28 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l7-20020a6b3e07000000b006e02c489089sm1891083ioa.32.2022.12.07.13.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 13:22:27 -0800 (PST)
Message-ID: <2843c6b4-ba9a-b67d-e0f4-957f42098489@kernel.dk>
Date:   Wed, 7 Dec 2022 14:22:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH for-next v2 11/12] io_uring: do msg_ring in target task
 via tw
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1670384893.git.asml.silence@gmail.com>
 <4d76c7b28ed5d71b520de4482fbb7f660f21cd80.1670384893.git.asml.silence@gmail.com>
 <3957b426-2391-eeaa-9e02-c8e90169ec2e@kernel.dk>
 <f36043e9-cda3-3275-d945-26d121255d2f@kernel.dk>
 <aafe218a-4d94-7126-b11d-5abd0161fe6d@gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aafe218a-4d94-7126-b11d-5abd0161fe6d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/7/22 2:18 PM, Pavel Begunkov wrote:
> On 12/7/22 15:51, Jens Axboe wrote:
>> On 12/7/22 8:31 AM, Jens Axboe wrote:
>>> On 12/6/22 8:53?PM, Pavel Begunkov wrote:
>>>> @@ -43,6 +61,15 @@ static int io_msg_ring_data(struct io_kiocb *req)
>>>>       if (msg->src_fd || msg->dst_fd || msg->flags)
>>>>           return -EINVAL;
>>>>   +    if (target_ctx->task_complete && current != target_ctx->submitter_task) {
>>>> +        init_task_work(&msg->tw, io_msg_tw_complete);
>>>> +        if (task_work_add(target_ctx->submitter_task, &msg->tw,
>>>> +                  TWA_SIGNAL))
>>>> +            return -EOWNERDEAD;
>>>> +
>>>> +        return IOU_ISSUE_SKIP_COMPLETE;
>>>> +    }
>>>> +
>>>
>>> We should probably be able to get by with TWA_SIGNAL_NO_IPI here, no?
>>
>> Considering we didn't even wake before, I'd say that's a solid yes.
> 
> I'm not so sure. It'll work, but a naive approach would also lack
> IORING_SETUP_TASKRUN_FLAG and so mess with latencies when it's not
> desirable.
> 
> option 1)
> 
> method = TWA_SIGNAL;
> if (flags & IORING_SETUP_TASKRUN_FLAG)
>     method = NO_IPI;
> 
> option 2)
> 
> task_work_add(NO_IPI);
> atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
> 
> 
> Might be better to have one of those.

I like option 2, which should be fine.

-- 
Jens Axboe



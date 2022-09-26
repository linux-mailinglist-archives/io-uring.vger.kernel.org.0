Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21665EB21F
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 22:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiIZUb1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 16:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiIZUbO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 16:31:14 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD9532D95;
        Mon, 26 Sep 2022 13:31:13 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t7so11938740wrm.10;
        Mon, 26 Sep 2022 13:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=SRmeo65OeWMznY0dSxOsTzyUV1eTXmKn6HVkSyBhq3Y=;
        b=Eyi/DWiwyeSP9DoQMmTa6k1T4sFhW52bRoc9DT4XrXIfrFzzaGuXud/P8MMwrggtha
         U/7xiEw/tu3WkF7owcWcJFvK9BGO2uoQCxV1KoPpTPCIQeCIE6pES/+/wqgq5A6Jy7fb
         GoQRGjCd7uUVpC1FMrjwEu3ijFYtA22MNqE3hDSPAf1Z/jfpxL0B7roH/u4vE4H++b9P
         YrkG8morKX8HP9Wq5oOz3y9KGII3r22AJOgHO12VPb/NxG9jQZEDx3xsiih0Y04QgYyV
         VeVbNO16lh8ZS5uD4yOWPx83IgqIf73CcLLuo6iFzgnweENRcLqfLyy/jCvELLCQTCmA
         jI2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=SRmeo65OeWMznY0dSxOsTzyUV1eTXmKn6HVkSyBhq3Y=;
        b=fmPLa0QYDN5a1YFmFM3hOH6e1QrCzGb+vHs+tZSlMDCc1wIqxG31AK2lExfaCST8HH
         HTtKGLGK5YUPqBvmI4PvdU1gsxfGonUhdCIBfiiDZ03QlPsVlFTtJBynRb+UGywy/0Pw
         SZhQ0nPtBI4YvLdFIY14GNt8yvvV4ragJv5cao4RjQDiUmzTz1XkMc1srRnoHqe/pgMk
         egv4Pu38QVYIfY8aGtVaJEWhMNWCdWKXXMuO7ReJECqPCY1bmWtsqx/0mJC9XHHL0h6d
         hYi9/+zib5HdCCkSRAGIrVsm3KUx6/q8d3DEshIetI0kIJNS8XMPuckxX2OH9iFDREWE
         oChw==
X-Gm-Message-State: ACrzQf2qScpyJ9pGP7O6ZRt9neB0fpX1Itbx6T6tx2sV/2coGycnR3Ku
        UiOSfR/Vllz3ae9GoUC8esU=
X-Google-Smtp-Source: AMsMyM4YlAsr0JbvS6P2mM2L8ncYoBB0TUYFXWvDt6YNydDvujVvVZUWIAwTp9ad3GeEx5JrlHEATw==
X-Received: by 2002:a05:6000:188a:b0:22a:e4b7:c2f4 with SMTP id a10-20020a056000188a00b0022ae4b7c2f4mr14119762wri.446.1664224271929;
        Mon, 26 Sep 2022 13:31:11 -0700 (PDT)
Received: from [192.168.8.100] (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id c1-20020a5d5281000000b002287d99b455sm14906980wrv.15.2022.09.26.13.31.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 13:31:11 -0700 (PDT)
Message-ID: <3a582199-7ee6-caf7-0314-a8a32a17b980@gmail.com>
Date:   Mon, 26 Sep 2022 21:29:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 1/3] io_uring: register single issuer task at creation
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com
References: <20220926170927.3309091-1-dylany@fb.com>
 <20220926170927.3309091-2-dylany@fb.com>
 <35d9be6b-89ca-f2a1-ce5f-53e72610db6e@gmail.com>
 <4623be74-d877-9042-f876-09feba2f0587@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4623be74-d877-9042-f876-09feba2f0587@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/22 20:40, Jens Axboe wrote:
> On 9/26/22 1:12 PM, Pavel Begunkov wrote:
>> On 9/26/22 18:09, Dylan Yudaken wrote:
>>> Instead of picking the task from the first submitter task, rather use the
>>> creator task or in the case of disabled (IORING_SETUP_R_DISABLED) the
>>> enabling task.
>>>
>>> This approach allows a lot of simplification of the logic here. This
>>> removes init logic from the submission path, which can always be a bit
>>> confusing, but also removes the need for locking to write (or read) the
>>> submitter_task.
>>>
>>> Users that want to move a ring before submitting can create the ring
>>> disabled and then enable it on the submitting task.
>>
>> I think Dylan briefly mentioned before that it might be a good
>> idea to task limit registration as well. I can't think of a use
>> case at the moment but I agree we may find some in the future.
>>
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 242d896c00f3..60a471e43fd9 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -3706,6 +3706,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>>       if (WARN_ON_ONCE(percpu_ref_is_dying(&ctx->refs)))
>>           return -ENXIO;
>>   
>> +    if (ctx->submitter_task && ctx->submitter_task != current)
>> +        return -EEXIST;
>> +
>>       if (ctx->restricted) {
>>           if (opcode >= IORING_REGISTER_LAST)
>>               return -EINVAL;
> 
> Yes, I don't see any reason why not to enforce this for registration
> too. Don't think there's currently a need to do so, but it'd be easy
> to miss once we do add that. Let's queue that up for 6.1?

6.1 + stable sounds ok, I don't have an opinion on how to how
to merge it.

-- 
Pavel Begunkov

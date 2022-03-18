Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286F34DDD15
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 16:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbiCRPhl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 11:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbiCRPhk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 11:37:40 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8672770CC1
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 08:36:21 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j18so2618074wrd.6
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 08:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=R40yylOn/eaKkKKf1ZOuRbCnSNvwPSXt9wYzkZBasTY=;
        b=F9mfMheFXmIvMF1A7qPTdmBtJ6ibzXhrbKHuzBUaHpFHje+r9hWbDrQmMVRpI34dIJ
         CORAZhb86hCLB+bIqDiuP8lnTcb5IrapN+Mr3A+M2+j5oWAAr2NrbpHpB6aCNLqf8I/V
         4+VgYBmz9vIMC2Q1aOdMNkxZ6xcTF8+VRPnLOaeOAiJprmZPgD+NlOE+J5B3NIHNSx8e
         lnXQ5hiftQrZjfiS+FPcXufFQNerY3pjPPGe/R0nfXv7kmyaJjsj1rDay8gDnnXKZfaz
         U0Wg/6f2EHDVjsu09G9Tsdbo+zLLp1WO4uXUl9E8bQDb9WpYwrDDCuSNevTumMsp/bkO
         F8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R40yylOn/eaKkKKf1ZOuRbCnSNvwPSXt9wYzkZBasTY=;
        b=gJL8VdR0ngSw+PvFD6qBZb2W+Gxf/CgZaGMVYBJRBNNIUUDuKYCV4JOPUptEOBr82V
         iYHYYRak7u89mPM3C0cL8VCNPYmotDcMT9epPHLSu61VQu/92L77xiOH9peTb8WfXIVx
         xPCKYooxWPbjHPvCa9Q79QY1FC8LTY82MCEEAt91TLsGtnW1E4mBUNtcnrYhM+9N7Jnq
         knsY7BYRdU1dKhYxdzQ947RA4lhg+CIMI8xrRl/j6eRSgUn2jPDUFDvVIUQ9cLQ6jroK
         XNXKb7furp0o8WbhXh00zNqkb/umG+N2dDoORIplKwGY85IxfRlIrlD6vNegq6pGjZIB
         0U3A==
X-Gm-Message-State: AOAM533TPXP0M+MAcI5InXGOsehfOBX2jUA/zYFlgtUC0nKQnNgJ3pPb
        5v94PgpgF7ZW7v3r70yAhYRHyfTINmOXEg==
X-Google-Smtp-Source: ABdhPJzEqY+ggrwZ85CBBqJf9IAVA5zO48WgcyNkcl+bhgOMhjud5J9oLoo3UXB9ra8x8YH9rzvGYA==
X-Received: by 2002:adf:90e2:0:b0:1e3:f5a:553c with SMTP id i89-20020adf90e2000000b001e30f5a553cmr8182649wri.476.1647617780102;
        Fri, 18 Mar 2022 08:36:20 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.234.70])
        by smtp.gmail.com with ESMTPSA id x3-20020a5d6b43000000b001e317fb86ecsm6757877wrw.57.2022.03.18.08.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 08:36:19 -0700 (PDT)
Message-ID: <a154ad37-de8a-1e84-3d65-ef78ecd88f99@gmail.com>
Date:   Fri, 18 Mar 2022 15:34:52 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [RFC 0/4] completion locking optimisation feature
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1647610155.git.asml.silence@gmail.com>
 <016bd177-1621-c6c1-80a2-adfabe929d2f@gmail.com>
 <23c1e47b-45e5-242f-a563-d257a7de88ed@kernel.dk>
 <458031c4-2eca-7a9e-ab9f-183a2497af48@gmail.com>
 <c61808ee-f583-b243-95ed-fa3739ef3411@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c61808ee-f583-b243-95ed-fa3739ef3411@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/18/22 15:22, Jens Axboe wrote:
> On 3/18/22 9:00 AM, Pavel Begunkov wrote:
>> On 3/18/22 14:52, Jens Axboe wrote:
>>> On 3/18/22 8:42 AM, Pavel Begunkov wrote:
>>>> On 3/18/22 13:52, Pavel Begunkov wrote:
>>>>> A WIP feature optimising out CQEs posting spinlocking for some use cases.
>>>>> For a more detailed description see 4/4.
>>>>>
>>>>> Quick benchmarking with fio/t/io_uring nops gives extra 4% to throughput for
>>>>> QD=1, and ~+2.5% for QD=4.
>>>>
>>>> Non-io_uring overhead (syscalls + userspace) takes ~60% of all execution
>>>> time, so the percentage should quite depend on the CPU and the kernel config.
>>>> Likely to be more than 4% for a faster setup.
>>>>
>>>> fwiw, was also usingIORING_ENTER_REGISTERED_RING, if it's not yet included
>>>> in the upstream version of the tool.
>>>
>>> But that seems to be exclusive of using PRIVATE_CQ?
>>
>> No, it's not. Let me ask to clarify the description and so, why do you
>> think it is exclusive?
> 
> Didn't dig too deep, just saw various EINVAL around registered files and
> updating/insertion. And the fact that t/io_uring gets -EINVAL on

Ah, those are for registered rsrc with tags, just because they use
fill_cqe, need to do something about them

> register with op 20 (ring fd) if I set CQ_PRIVATE, see other email.

-- 
Pavel Begunkov

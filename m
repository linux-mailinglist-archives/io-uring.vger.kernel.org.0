Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DADB50CC3D
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 18:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiDWQSA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 12:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiDWQR5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 12:17:57 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1F728F
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 09:14:57 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id r13so21804002ejd.5
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 09:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:organization:in-reply-to:content-transfer-encoding;
        bh=Gw8U7QDL7lTMi963W0t/36+CJABZiRN6b1+o731udVg=;
        b=Q6mCFIZtNdC8TS+Z/YVQLxTNKAbHkeG2r7KriwGQ1LqrMTl2aHCaztpXXMmXbHWNOW
         SNNqSUgO/Ksdr+a7zeK2SrQN+SxTWESDVWz9eNEv9iOMT908VIs/850SyaIAAmK1KA9K
         PfGmi19FQnwCMXQkO4KAp6NGbToLP1QO2xw3xU3trXOrn0D3r6SigehxjmOoyaHVFX1v
         i+eE2lKx31RtzKbZmWgKllUkR29iaLdEmwttkItEFsPgW/Y/38BE9ZeZEjNq96ydkuJg
         3fbk+ymvzSvdvI96GaGuecMxLI1FgTw07xd888yKFM160B1oR25J4A++ttafYyTS4NUe
         pC/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Gw8U7QDL7lTMi963W0t/36+CJABZiRN6b1+o731udVg=;
        b=eRhC++tH6D764njdwDSa1gnITaoKn7+a9hTJyt4IDjamPRpNldosqu0NDGPKMZdfbT
         nn8WYI92oD6LAVIop7hCqeB0z+o9RuiBy5mx32gcb/rLK9geFJjilV6z/Nsqn/nVS/9k
         Nl58Rd5VRfWIDJDyzcYTd+1hKpAtl1Aq0FrCjQFS5L0XT+MNrH0RIfnoPdFx3f1I1/ON
         KQpR3o99C0TnCWcAuqmkXsqOA7oJmNNvSJvGqKt3bj9kM5Fa33d4m32+D2lWWgqnuX9T
         yGqLzViMwdY/wjskaujY/2ntO79vvLGOQlmaeNnrmf+JUWMA8FiXmo0rwMbh3PYhhWyP
         Kljw==
X-Gm-Message-State: AOAM531NH+s1Uxuipzyi9gr7xgwBxL6WxfBPEEdayjfoaBI4EODMReTo
        yK2dFFQj3eCUgNBTrH3EeTlMfa56g2Ul2QRg
X-Google-Smtp-Source: ABdhPJzHX2eeE8qkuOctOBO3FE2+2AtvacImAbwpleKfUWtV76kl/nbhMs8kLGoZC3Qep0DI/HYYSQ==
X-Received: by 2002:a17:907:3e8a:b0:6f0:1e02:e158 with SMTP id hs10-20020a1709073e8a00b006f01e02e158mr9277448ejc.291.1650730496167;
        Sat, 23 Apr 2022 09:14:56 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id y3-20020a50ce03000000b00425bfb7f940sm2193730edi.11.2022.04.23.09.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 09:14:55 -0700 (PDT)
Message-ID: <b540b7a2-481b-016f-a2fa-7921882af0b6@scylladb.com>
Date:   Sat, 23 Apr 2022 19:14:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: memory access op ideas
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <9fef64ff-d13d-f9ff-a230-0d8fe928097e@gmail.com>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <9fef64ff-d13d-f9ff-a230-0d8fe928097e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 22/04/2022 15.52, Hao Xu wrote:
> Hi Avi,
> 在 4/13/22 6:33 PM, Avi Kivity 写道:
>> Unfortunately, only ideas, no patches. But at least the first seems 
>> very easy.
>>
>>
>> - IORING_OP_MEMCPY_IMMEDIATE - copy some payload included in the op 
>> itself (1-8 bytes) to a user memory location specified by the op.
>>
>>
>> Linked to another op, this can generate an in-memory notification 
>> useful for busy-waiters or the UMWAIT instruction
>>
>>
>> This would be useful for Seastar, which looks at a timer-managed 
>> memory location to check when to break computation loops.
>>
>>
>> - IORING_OP_MEMCPY - asynchronously copy memory
>>
>>
>> Some CPUs include a DMA engine, and io_uring is a perfect interface 
>> to exercise it. It may be difficult to find space for two iovecs though.
>
> I have a question about the 'DMA' here, do you mean DMA device for
> memory copy?


Yes. I understand some Intel server processors have them.


> My understanding is you want async memcpy so that the
> cpu can relax when the specific hardware is doing memory copy. the
> thing is for cases like busy waiting or UMAIT, the length of the memory
> to be copied is usually small(otherwise we don't use busy waiting or
> UMAIT, right?). Then making it async by io_uring's iowq may introduce
> much more overhead(the context switch).


These are two separate cases.


1. Bulk data copies (usually large), use DMA

2. small memory writes to wake up a thread that is using UMWAIT or 
busy-polling, do not use DMA


Whether to use DMA or not can be based on writes size. I'd say anything 
<= 512 bytes should be done by the CPU.



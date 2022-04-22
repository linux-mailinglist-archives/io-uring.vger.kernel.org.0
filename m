Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C86850B8AD
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 15:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447956AbiDVNlF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 09:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354189AbiDVNlC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 09:41:02 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32891583BD
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 06:38:09 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c12so10915653plr.6
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 06:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=baHKZQNFFxPXavyxq/+p7I5KK76gb7GgO/V7vB6Kof0=;
        b=RCGJaNJfXQpcplefXi1SHRLEiEjmtbA6iMxCsk1vqNqw4X70gQNMmWN8qIQAMPn7LF
         IC7iXOzvSjgM8OtnTZ+G7dYf/QAyUXkI3GqewNlBPneXH1zRXju+Z7h6zaDrrlXXFHm/
         AcjFic5P+wusCoHRG8SPVCD4XjYDRUxvvwGy1jdvpypDNuc8RJXDZVz9C7RrXZO5jz3d
         NdBtnaKBixDFwahgcO4C32x6/O8c8ojcUA+yc999EBx+aBKcXowTxRzf1RVYzBUhb5BI
         2DA5MPI5dtWIl/o7pRXFTVrOmYr7nvSF6FtEGYJA4MwFrFYASduPJyl1FXk7yBVvjpV3
         466g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=baHKZQNFFxPXavyxq/+p7I5KK76gb7GgO/V7vB6Kof0=;
        b=UvEWmUb/fALZE51CA4omTBQGWhaXJsv5GvZXr93h0cvSkBI5CxnawC9mQY4YFu61r2
         NY+3M6o2c2owOOFxYOi6XtIigS/7MgPPbm9+3n6wk81j4A6oED29NJqWg7iFU0Aj5fEq
         07MsbnJVidftJ0RWNidG3EJ+Y67sAyAzaS5Xbs8ewm8xWWGP9L3kX/4EZzH5L74UrzsP
         ddrf+8lMjG8yhwRV7O8DP/5KFwmxcUxtOj7aMlr3vmpiBwP/WqqetaO0b/IVcinrfnGt
         ySzjm7N/87e1ZhcaMz2Aqs1+23fMOppsrCHqQbu2s+vyFWTUVfTxxxnWwzAJ4nnRH+YQ
         kkjw==
X-Gm-Message-State: AOAM533XN1PG07tOb/J9x6u6d6501DZfTORVELFRPiaotEicEJ46ZLT9
        TcJdS/GXlSZiUpO4G0eDvmInHDOR58fiLTo9
X-Google-Smtp-Source: ABdhPJypIKHUVT9xLEzZCpYJ5JAKZ6LJOOaGu6rsRSptDvXjbODpAGiCDO7Z/khxDz3ZyjzZIzi4CQ==
X-Received: by 2002:a17:90b:1044:b0:1cd:2d00:9d23 with SMTP id gq4-20020a17090b104400b001cd2d009d23mr16137516pjb.124.1650634688613;
        Fri, 22 Apr 2022 06:38:08 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id r3-20020a17090a1bc300b001d75172977dsm4017335pjr.28.2022.04.22.06.38.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 06:38:08 -0700 (PDT)
Message-ID: <0bc0f745-96d4-cedc-c502-67122bc878d1@kernel.dk>
Date:   Fri, 22 Apr 2022 07:38:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: memory access op ideas
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, Avi Kivity <avi@scylladb.com>,
        io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <9fef64ff-d13d-f9ff-a230-0d8fe928097e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9fef64ff-d13d-f9ff-a230-0d8fe928097e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/22/22 6:52 AM, Hao Xu wrote:
> Hi Avi,
> ? 4/13/22 6:33 PM, Avi Kivity ??:
>> Unfortunately, only ideas, no patches. But at least the first seems very easy.
>>
>>
>> - IORING_OP_MEMCPY_IMMEDIATE - copy some payload included in the op itself (1-8 bytes) to a user memory location specified by the op.
>>
>>
>> Linked to another op, this can generate an in-memory notification useful for busy-waiters or the UMWAIT instruction
>>
>>
>> This would be useful for Seastar, which looks at a timer-managed memory location to check when to break computation loops.
>>
>>
>> - IORING_OP_MEMCPY - asynchronously copy memory
>>
>>
>> Some CPUs include a DMA engine, and io_uring is a perfect interface to exercise it. It may be difficult to find space for two iovecs though.
> 
> I have a question about the 'DMA' here, do you mean DMA device for
> memory copy? My understanding is you want async memcpy so that the
> cpu can relax when the specific hardware is doing memory copy. the
> thing is for cases like busy waiting or UMAIT, the length of the memory
> to be copied is usually small(otherwise we don't use busy waiting or
> UMAIT, right?). Then making it async by io_uring's iowq may introduce
> much more overhead(the context switch).

Nothing fast should use io-wq. But not sure why you think this would
need it, as long as you can start the operation in a sane fashion and
get notified when done, why would it need io-wq?

-- 
Jens Axboe


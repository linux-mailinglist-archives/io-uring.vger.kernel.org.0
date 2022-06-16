Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401F954DFD2
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 13:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiFPLO6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 07:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiFPLO5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 07:14:57 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D9A5C872
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 04:14:56 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id z17so1221850pff.7
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 04:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fuylfZFXsCU2D4TjYKZ9GETW85d0HHBuOZ1CQt8jeBY=;
        b=Z/R3YpPk4+AbTLW59ePIkaeYt3pM/QOO1BCezI+Qt6okcUd1oonyrc3Q86yDeiLtJn
         KX2zNhviYSavXLqloRIf72si0T/9ic9BCbwxr+joDhwCgKDClItLtvwcd/FgYVXgd58e
         LOWiZXaZqGgbY1HfYyma7yrXXPAnSz0bi+dVl35qefnRh7odMmXdbGtTXk6M44IQKwHh
         CvQxXEXX4VDjagcbH6gyIb5s8N+twLNo8dCXMp6hESt+zidjwGwjFaNj4FjM2ydx/LIR
         +JSaweAPcvBB9sVlPG3aKHyBOk11wgSzxRIrPlKh4bzjefc32bH0no+G2KcRLHHEo5mq
         +VCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fuylfZFXsCU2D4TjYKZ9GETW85d0HHBuOZ1CQt8jeBY=;
        b=PiXHkKgY2biDybgbtmvhn8Ozew5dUGI7QMcCfg6dotV5qfOiq1hWI8XVEGSxFgI+pM
         ZjNdpfg7DAipVR8vOv4jhTFAPScVSEVid0ot2Ms68IIBPYnkUP14iljiw5bGMuwFMHxA
         u7T0lMdCp0MtHowWaw5ajFF0Vns6uLUOd2SWDyX7n1aO34ekxTkKmjEyqNRXALDfyowk
         R9e2zygz5v1lGu1fdbnqcBSAbPFbtv/XBeTom+feI3e9VFMej7wO8x0ytMIMVtACIxYP
         Kr3qb9sYjZ3gWT6J1RRinON8YX17jxH8THx0VTLMv8x8U7T+HRoRbtrkojEzmqtCc87d
         4nBg==
X-Gm-Message-State: AJIora/V3obm9uk/P3aK2Apfb7sh+ce7iDXpfmRRTYcvqsWJEXrZgmBE
        qBtOOnncvmp5iu5jvQGBeXpTNw==
X-Google-Smtp-Source: AGRyM1v8cL5xSF36XYA1U+a+GcW7OaIu0Q3x8N0T5SaeBWD6IKRYj3QHfvUJdpCPmHu6EOQ2zN2qCg==
X-Received: by 2002:a62:1bd3:0:b0:51c:505b:e35 with SMTP id b202-20020a621bd3000000b0051c505b0e35mr4275322pfb.38.1655378095951;
        Thu, 16 Jun 2022 04:14:55 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p24-20020aa78618000000b0051c7038bd52sm1459906pfn.220.2022.06.16.04.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 04:14:55 -0700 (PDT)
Message-ID: <2816f687-344d-443e-c659-2f88ef4457a4@kernel.dk>
Date:   Thu, 16 Jun 2022 05:14:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] io_uring: read/readv must commit ring mapped buffers
 upfront
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <b0c9112b-15d3-052b-3880-a81bed7a5842@kernel.dk>
 <5182eae9-efe8-4271-32f5-f90033679f9e@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5182eae9-efe8-4271-32f5-f90033679f9e@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/22 10:41 PM, Hao Xu wrote:
> On 6/16/22 09:55, Jens Axboe wrote:
>> For recv/recvmsg, IO either completes immediately or gets queued for a
>> retry. This isn't the case for read/readv, if eg a normal file or a block
>> device is used. Here, an operation can get queued with the block layer.
>> If this happens, ring mapped buffers must get committed immediately to
>> avoid that the next read can consume the same buffer.
>>
>> Add an io_op_def flag for this, buffer_ring_commit. If set, when a mapped
>> buffer is selected, it is immediately committed.
>>
>> Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 5d479428d8e5..05703bcf73fd 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1098,6 +1098,8 @@ struct io_op_def {
>>       unsigned        poll_exclusive : 1;
>>       /* op supports buffer selection */
>>       unsigned        buffer_select : 1;
>> +    /* op needs immediate commit of ring mapped buffers */
>> +    unsigned        buffer_ring_commit : 1;
>>       /* do prep async if is going to be punted */
>>       unsigned        needs_async_setup : 1;
>>       /* opcode is not supported by this kernel */
>> @@ -1122,6 +1124,7 @@ static const struct io_op_def io_op_defs[] = {
>>           .unbound_nonreg_file    = 1,
>>           .pollin            = 1,
>>           .buffer_select        = 1,
>> +        .buffer_ring_commit    = 1,
>>           .needs_async_setup    = 1,
>>           .plug            = 1,
>>           .audit_skip        = 1,
>> @@ -1239,6 +1242,7 @@ static const struct io_op_def io_op_defs[] = {
>>           .unbound_nonreg_file    = 1,
>>           .pollin            = 1,
>>           .buffer_select        = 1,
>> +        .buffer_ring_commit    = 1,
>>           .plug            = 1,
>>           .audit_skip        = 1,
>>           .ioprio            = 1,
> 
> 
> This way we also commit the buffer for read(sockfd) unconditionally.
> Would it be better to commit buffer only for read(reg/blk fd) ?

Right, it will. We could potentially make it look at if the file is
pollable or not, downside is that then the logic needs to go into
io_read() - or if not, the buffer selection will need implied knowledge
of what the consumer might do.

I don't worry too much about sockets, generally I expect people to use
recv/recvmsg for those. But we do have other pollable file types, like
pipes, so it would be nice to make it consistent with the model that is
"don't consume if you did no IO and will retry".

-- 
Jens Axboe


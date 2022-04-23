Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E12650CC98
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 19:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236584AbiDWRfV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 13:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236609AbiDWRfT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 13:35:19 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901F0197D6E
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:32:21 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id g9so9897287pgc.10
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=vvkWGurzTP95FhqlBpP1gbxwDn3vDtDwvW5gpe919Uw=;
        b=fL8+vb8CMU3kyHk5bZ8VE+u1fgRZZa+AlDuonHow51qSn2UUDGTcPhRWvjcMuTbkb7
         3I3NucB6hZQDEQO6+KjI6VPmlrQrKcTV3/KdEtnNKDwy4boCBaIFx2nQupm+fAAbbw+D
         aQGOF9iN+S4Jw+wO32ii7nazVtOvel1a4nX7D97kSuxOiN4qwz4OoxWGi48aUPKh6+wP
         SV0L1rQBrwabsGKqrcltZAS/Mxrbv0j1M330rkIFkBWmFkOeW1eEc5FES540BVXqdSXC
         kHynizLmuwE7pF8vele7XqfT9ySshL2wpoK/8ATQzrSAz2nSALgcjd5W388GcAhzvgkl
         Ylhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vvkWGurzTP95FhqlBpP1gbxwDn3vDtDwvW5gpe919Uw=;
        b=RLaCE52sOawr0YceEQ9rwrGjDJ0UuRC29bVEDq2q+SbWwUMEvOLwuMqhHGd9/x28id
         V8wQPxaiUojxncgNNP2dhoFFIu8ZY/6k6gmMOOqTq8n3pq1DNm/3mFZYFRxbjMligUvf
         PkVAkKVYgXU4n/UZwLqwQA6TT63c6OCX7MT9QFaAXfLfb4OORkgOrUnJVsnQxA6emMpS
         95kRRtahPc9WaRXhiDb4m8kJFunKcaHzGljIFAOqlU6iTszgzM9zSfE86tdqCAspYNwk
         R3JE2EZsTGfcRusaKH/uB5a8s5DIPqI30m283npzB8fz1mgKBEUW4jmyqEFF4WZguy/V
         qZDQ==
X-Gm-Message-State: AOAM533tajMYddqukT81h7SQHQDmzXyauON+f3y6MtS/gPooYXNXncgs
        7PZfzbfx0rjB3mRbH7vUS0P4ii5bKRfiSwh9
X-Google-Smtp-Source: ABdhPJz2hsYkEEkJha2tchTFU4O/0UvnHCEGojmWKlLGW3pLdNqwOL3NWY10F0ph8o/pR5H8kPt5sQ==
X-Received: by 2002:a63:5c0b:0:b0:382:76f4:c768 with SMTP id q11-20020a635c0b000000b0038276f4c768mr8516378pgb.93.1650735140915;
        Sat, 23 Apr 2022 10:32:20 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p1-20020a056a000a0100b0050ac9c31b7esm6932352pfh.180.2022.04.23.10.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 10:32:20 -0700 (PDT)
Message-ID: <6041b513-0d85-c704-f1ae-c6657a3e680d@kernel.dk>
Date:   Sat, 23 Apr 2022 11:32:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: memory access op ideas
Content-Language: en-US
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
 <c663649e-674e-55d0-a59c-8f4b8f445bfa@kernel.dk>
 <27bf5faf-0b15-57dc-05ec-6a62cd789809@scylladb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <27bf5faf-0b15-57dc-05ec-6a62cd789809@scylladb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/23/22 10:30 AM, Avi Kivity wrote:
> 
> On 22/04/2022 18.03, Jens Axboe wrote:
>> On 4/22/22 8:50 AM, Jens Axboe wrote:
>>> On 4/13/22 4:33 AM, Avi Kivity wrote:
>>>> Unfortunately, only ideas, no patches. But at least the first seems very easy.
>>>>
>>>>
>>>> - IORING_OP_MEMCPY_IMMEDIATE - copy some payload included in the op
>>>> itself (1-8 bytes) to a user memory location specified by the op.
>>>>
>>>>
>>>> Linked to another op, this can generate an in-memory notification
>>>> useful for busy-waiters or the UMWAIT instruction
>>>>
>>>> This would be useful for Seastar, which looks at a timer-managed
>>>> memory location to check when to break computation loops.
>>> This one would indeed be trivial to do. If we limit the max size
>>> supported to eg 8 bytes like suggested, then it could be in the sqe
>>> itself and just copied to the user address specified.
>>>
>>> Eg have sqe->len be the length (1..8 bytes), sqe->addr the destination
>>> address, and sqe->off the data to copy.
>>>
>>> If you'll commit to testing this, I can hack it up pretty quickly...
>> Something like this, totally untested. Maybe the return value should be
>> bytes copied?
> 
> 
> Yes. It could be less than what the user expected, unless we enforce
> alignment (perhaps we should).

Yes, this is just a quick hack. Did make some changes after that,
notably just collapsing it into IORING_OP_MEMCPY and having a flag for
immediate mode or not.

>>   +static int io_memcpy_imm_prep(struct io_kiocb *req,
>> +                  const struct io_uring_sqe *sqe)
>> +{
>> +    struct io_mem *mem = &req->mem;
>> +
>> +    if (unlikely(sqe->ioprio || sqe->rw_flags || sqe->buf_index ||
>> +             sqe->splice_fd_in))
>> +        return -EINVAL;
>> +
>> +    mem->value = READ_ONCE(sqe->off);
>> +    mem->dest = u64_to_user_ptr(READ_ONCE(sqe->addr));
>> +    mem->len = READ_ONCE(sqe->len);
>> +    if (!mem->len || mem->len > sizeof(u64))
>> +        return -EINVAL;
>> +
> 
> 
> I'd also check that the length is a power-of-two to avoid having to
> deal with weird sizes if we later find it inconvenient.

Yes, that's a good idea.

>> +    return 0;
>> +}
>> +
>> +static int io_memcpy_imm(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +    struct io_mem *mem = &req->mem;
>> +    int ret = 0;
>> +
>> +    if (copy_to_user(mem->dest, &mem->value, mem->len))
>> +        ret = -EFAULT;
>> +
> 
> 
> Is copy_to_user efficient for tiny sizes? Or is it better to use a
> switch and put_user()?
> 
> 
> I guess copy_to_user saves us from having to consider endianness.

I was considering that too, definitely something that should be
investigated. Making it a 1/2/4/8 switch and using put_user() is
probably a better idea. Easy enough to benchmark.

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377494D3F2D
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 03:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbiCJCMc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 21:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiCJCMc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 21:12:32 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AA911B5C8
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 18:11:31 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id r22so5757004ljd.4
        for <io-uring@vger.kernel.org>; Wed, 09 Mar 2022 18:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=jfWpDErcbOPYsenENhlcRZONrFRTdShIdKznXMwybGw=;
        b=euEPcKpZaeeLZyCkbnwQqTo6TZtXuS9a6f7mP/inh6akrdiqZ9s2Vn308rJqT5Lyb3
         uCMEWRH8eZNqoJOE+qSsFysEE16BDQcs2pi7afmJzGjHc1Ps3cyuT3vMDU6cETUq2UQb
         7IkE/gZW7OEirm0gpDG5Eq+E1eE3x3SwogzpJ81+QMaITaJzK6LKJiAXW3asNGH++bMg
         mcG5tnL9OURYJ1kHZcM4xpSDE9lcWzZccEXckZ96p3/cHLTzJ14IMLh6xqZ6VDZ/bGK6
         k7NPiKOybc4Dl1f2zJZwZNXXfyxn5FULQyGMWCVPHbmaDQrjKqF0WvImpvp9HNhxhDoC
         nW0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jfWpDErcbOPYsenENhlcRZONrFRTdShIdKznXMwybGw=;
        b=mOCNWNgmrVi5JymY/3szSTsOtrzNGfK7ECqAPvB4YdzaSGs8ASYCBrLmVXzlaztzuD
         rqglXTKbyX4uWbaH24rajvJMx/JL3S+T4gUEDtVgahQegdREwhsPQWdgeq4V577u0BzB
         psqEY6Xxww93TR15KTa+/2d5IKZOXvnnJSAAxLrV5S0mEnO4zG2i9vWLauftHTkzgKW4
         q/EwRgiJvmERbavTHmZRHOvgxwur3wollEY/Fy+p9a3Ug9xW9cz3mgs2L3tNz9uyfLoO
         bloRMBUCrJ8+FL7SFoQ/W0yG89oHaeCXhUiyKajVWUypU7LOrYD1JmUjVmWcgLIXCCi3
         l34w==
X-Gm-Message-State: AOAM532I/wSN6fLCUyxOc4giXBnQfkBlQK18MNIpsvx4p/VFjuLfPrm3
        hyRu1v0aRBvXwvEo+DXnNw==
X-Google-Smtp-Source: ABdhPJwKyomAANbTk8sC50YAl+81r9vlu7Ho5Fzo7up2+2Aai1c7XEium/mzqkG7RD6rfeKpCe+3bA==
X-Received: by 2002:a05:651c:106e:b0:247:eb30:a39e with SMTP id y14-20020a05651c106e00b00247eb30a39emr1503618ljm.101.1646878289895;
        Wed, 09 Mar 2022 18:11:29 -0800 (PST)
Received: from [192.168.1.140] ([217.117.243.16])
        by smtp.gmail.com with ESMTPSA id t21-20020a056512209500b004483479faa8sm696927lfr.107.2022.03.09.18.11.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 18:11:29 -0800 (PST)
Message-ID: <c4a02dbd-8dff-a311-ce4a-e7daffd6a22a@gmail.com>
Date:   Thu, 10 Mar 2022 05:11:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
From:   Artyom Pavlov <newpavlov@gmail.com>
In-Reply-To: <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
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

10.03.2022 04:36, Jens Axboe wrote:
> On 3/9/22 4:49 PM, Artyom Pavlov wrote:
>> Greetings!
>>
>> A common approach for multi-threaded servers is to have a number of
>> threads equal to a number of cores and launch a separate ring in each
>> one. AFAIK currently if we want to send an event to a different ring,
>> we have to write-lock this ring, create SQE, and update the index
>> ring. Alternatively, we could use some kind of user-space message
>> passing.
>>
>> Such approaches are somewhat inefficient and I think it can be solved
>> elegantly by updating the io_uring_sqe type to allow accepting fd of a
>> ring to which CQE must be sent by kernel. It can be done by
>> introducing an IOSQE_ flag and using one of currently unused padding
>> u64s.
>>
>> Such feature could be useful for load balancing and message passing
>> between threads which would ride on top of io-uring, i.e. you could
>> send NOP with user_data pointing to a message payload.
> 
> So what you want is a NOP with 'fd' set to the fd of another ring, and
> that nop posts a CQE on that other ring? I don't think we'd need IOSQE
> flags for that, we just need a NOP that supports that. I see a few ways
> of going about that:
> 
> 1) Add a new 'NOP' that takes an fd, and validates that that fd is an
>     io_uring instance. It can then grab the completion lock on that ring
>     and post an empty CQE.
> 
> 2) We add a FEAT flag saying NOP supports taking an 'fd' argument, where
>     'fd' is another ring. Posting CQE same as above.
> 
> 3) We add a specific opcode for this. Basically the same as #2, but
>     maybe with a more descriptive name than NOP.
> 
> Might make sense to pair that with a CQE flag or something like that, as
> there's no specific user_data that could be used as it doesn't match an
> existing SQE that has been issued. IORING_CQE_F_WAKEUP for example.
> Would be applicable to all the above cases.
> 
> I kind of like #3 the best. Add a IORING_OP_RING_WAKEUP command, require
> that sqe->fd point to a ring (could even be the ring itself, doesn't
> matter). And add IORING_CQE_F_WAKEUP as a specific flag for that.
> 

No, ideally I would like to be able to send any type of SQE to a 
different ring. For example, if I see that the current ring is 
overloaded, I can create exactly the same SQEs as during usual 
operation, but with a changed recipient ring.

Your approach with a new "sendable" NOP will allow to emulate it in 
user-space, but it will involve unnecessary ring round-trip and will be 
a bit less pleasant in user code, e.g. we would need to encode a 
separate state "the task is being sent to a different ring" instead of 
simply telling io-uring "read data and report CQE on this ring" without 
any intermediate states.

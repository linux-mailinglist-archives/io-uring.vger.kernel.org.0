Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B2154C79B
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 13:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344964AbiFOLjD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 07:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242972AbiFOLjC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 07:39:02 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897163C4B0
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:39:00 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id n185so6141469wmn.4
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=W0FQAeWG5KPj8Hgt/Kbmm74CLdA9P5vL1zPEmc5kIF4=;
        b=f/lOnoUwUlaZaDpqdu71B1jJg8VS0FK0GOgrZzIV6kJJaGW7ZUrrKp3i8tos1basSZ
         OHOChKjQm5mytvi31ZM9qoj7ZDD53GkzYvxWe84mz2vGCcBRaHe8VmBuCG2JRxj2/5Ta
         GIOnnoVVGGt+7vtUWx640ktZTWl4FogWqCw1/urmnvbyofPYwwI6bGy1qHYxJ2lM3be3
         xvSTf/lYYPyhrLU0HAipkhv1YU6WL79NX8jK26wL2PuT+pdKthWqD+e3wFU+XtKzW4jn
         7/kPXTC0e6pl0qwT9vgP0bGqrAAVzt5x1cbcJgqebAi/B9OsT8bhRZ4PIM6PU2MreRSq
         jtmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W0FQAeWG5KPj8Hgt/Kbmm74CLdA9P5vL1zPEmc5kIF4=;
        b=jUgEXgNvqSMDMhEy6nC2LGd4MSmoMuJIkD6WIhYG0kXLymfNVy03XNSC1R+I8j8S7N
         8tnrHJV6U2C97IDJ1OdHLa0eCcovBWHdqcHqhflI8nP8vAOoM00xlN7ifdC3bhnHIIFU
         7ez342g+lAb2joZOOCLUcOZ9Eav5ptNNjG/2/aWXVoOobS2KkAm15cOul6gdBcyKUhz6
         N5kMkLIynoRgo2HlntwJ8s+YTeVuiC6HflIB0lhww0/RioRM6QaYIMXCff3GJJ9FPlaZ
         UB7wioov75aaOfI84iLZJxcnwO1om/rl86+aJ+nlfA0zat9qgity+em78rldNUxsiwRr
         FlrQ==
X-Gm-Message-State: AOAM533kPNwRdz++K5I0zBSdiDT0KJ9UL0uwHMo7HoQcpHjsZKHz1B3V
        EbOqGGLfF90e23ESXIBlaLE=
X-Google-Smtp-Source: ABdhPJyTVQ0mVt4lWSLM9fCHRmmjzA//0p94I44ZSMLjTQSvSxV6uJbCy5YgCweYRzNCblQkQXRpOw==
X-Received: by 2002:a05:600c:3505:b0:39c:93d4:5eec with SMTP id h5-20020a05600c350500b0039c93d45eecmr9277634wmq.179.1655293139035;
        Wed, 15 Jun 2022 04:38:59 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id m17-20020adfc591000000b0020fff0ea0a3sm14895975wrg.116.2022.06.15.04.38.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 04:38:58 -0700 (PDT)
Message-ID: <35a1fca7-a355-afbf-f115-8f154d8bdec6@gmail.com>
Date:   Wed, 15 Jun 2022 12:38:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Avi Kivity <avi@scylladb.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
 <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
 <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
 <b585d3b4-42b3-b0db-1cef-5d6c8b815bb7@kernel.dk>
 <e90bfb07-c24f-0e4d-0ac6-bd67176641fb@scylladb.com>
 <8e816c1b-213b-5812-b48a-a815c0fe2b34@kernel.dk>
 <16030f8f-67b1-dbc9-0117-47c16bf78c34@kernel.dk>
 <4008a1db-ee26-92ba-320e-140932e801c1@kernel.dk>
 <1d79b0e6-ee65-6eab-df64-3987a7f7f4e7@scylladb.com>
 <95bfb0d1-224b-7498-952a-ea2464b353d9@gmail.com>
 <991a999b-0f85-c0a3-c364-4b3ecfef9106@scylladb.com>
 <85b5d99e-69b4-15cf-dfd8-a3ea8c120e02@scylladb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <85b5d99e-69b4-15cf-dfd8-a3ea8c120e02@scylladb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/22 12:07, Avi Kivity wrote:
> Sorry, hit send too quiclky.
>>>> If this is correct (it's not unreasonable, but should be documented), then there should also be a simple way to force a kernel entry. But how to do this using liburing? IIUC if I the following apply:
>>>>
>>>>
>>>>   1. I have no pending sqes
>>>>
>>>>   2. There are pending completions
>>>>
>>>>   3. There is a completed event for which a completion has not been appended to the completion queue ring
>>>>
>>>>
>>>> Then io_uring_wait_cqe() will elide io_uring_enter() and the completed-but-not-reported event will be delayed.
>>>
>>> One way is to process all CQEs and then it'll try to enter the
>>> kernel and do the job.
> 
> 
> But I don't want it to wait. I want it to generate pending completions, and return immediately even if no completions were generated. I have some background computations I'm happy to perform if no events are pending, but I would like those events to be generated promptly.

Ok, then you may want IORING_SETUP_TASKRUN_FLAG described below.
btw IORING_SETUP_TASKRUN_FLAG has some additional overhead.


>>> Another way is to also set IORING_SETUP_TASKRUN_FLAG, then when
>>> there is work that requires to enter the kernel io_uring will
>>> set IORING_SQ_TASKRUN in sq_flags.
>>> Actually, I'm not mistaken io_uring has some automagic handling
>>> of it internally
>>>
>>> https://github.com/axboe/liburing/blob/master/src/queue.c#L36
>>>
> 
> Is there documentation about this flag?

Unfortunately, I don't see any.
Here is a link to the kernel commit if it helps:

https://git.kernel.dk/cgit/linux-block/commit/?h=ef060ea9e4fd3b763e7060a3af0a258d2d5d7c0d

I think it's more interesting what support liburing has,
but would need to look up in the code. Maybe Jens
remembers and can tell.

-- 
Pavel Begunkov

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25FA4D3FD2
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 04:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbiCJDtX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 22:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiCJDtW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 22:49:22 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B3B6D946
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 19:48:20 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id g17so7286905lfh.2
        for <io-uring@vger.kernel.org>; Wed, 09 Mar 2022 19:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=wHxbS7Uej62JiwrMsnRYinCmsBy+Qa4WU6WD8cuNm6w=;
        b=Vsd9zB1/XzTrGEapPpRZNgKbuVWR1dBiyKdjfsM4eTfzpnhINk8UVc5VAz8Le5zmcj
         9CL+GlNhtrLVC47hpdSUwp1Mj6/p3A244KJizG2PL8Ne3rhYlrf2ma9WLqhnIX2WDuBJ
         8U31HwcVIuVia/Bu/VhuAaXOSSHMDlCSOh5r9fKLundmfRNC7BgkvoV9NmxXfJU7XRBp
         6vPHPRdbReHN2Scv1iRhxPVeE4haNUE8WRgXON3Qw4LE5Dvs1+My2kIyyFnqOVsOvYzs
         kW2lazGeWK1u2/zZftjhvv/Jrgyj2Gw4iUgB6GH77WVVYhdeVuhv6qnvqhDbrzMimql4
         Mbvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wHxbS7Uej62JiwrMsnRYinCmsBy+Qa4WU6WD8cuNm6w=;
        b=ZJ1H+87q0AgR/wRVBrtGE83mVwCqldN6kltXNwGBERbBzdynt5c32Wmi9V77gIpJpg
         WXoAnwUrmC74j2ZuIFF45a1W+9qsMQYeBM/e09DkYLpeu1GNQkqYRS/ydvNnj+vXrBF9
         PgmGx8yjKWbo1e98bVuBIhP3EY95nY+veD4s7AuH7yN9Co7xRhUUrYXwu8LD8H6UrBtH
         +HH2FvAQecXES2CPlOYeQkD1xf8yb2Oe8G3JXCDm/8kg5gvnN1G8YzD46D3IprgzOByZ
         Yxt0/kRqcbU4u8fSOzuWpYKybz/zV7+mXU8qJq/r4Vtse2CgMMjwPb99Ntr0D6s2zwXY
         9AcQ==
X-Gm-Message-State: AOAM531BjIZyzT41g+sCBpgeUqXTWTQsJW/CJIpJHX6rGJUxURO0gYxu
        01BIWqArYdmn5mROlcKyqQ==
X-Google-Smtp-Source: ABdhPJzcJlZC+uOh2ZoifjZkxTWoilo0PMF/C60SjPfl/ubZ8uopxU3xjs2sKpEQL0uEzuKJti5OFQ==
X-Received: by 2002:ac2:5085:0:b0:448:64f3:4ee1 with SMTP id f5-20020ac25085000000b0044864f34ee1mr293820lfm.392.1646884098765;
        Wed, 09 Mar 2022 19:48:18 -0800 (PST)
Received: from [192.168.1.140] ([217.117.243.16])
        by smtp.gmail.com with ESMTPSA id j15-20020a2e3c0f000000b00247e9bafa20sm802477lja.99.2022.03.09.19.48.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 19:48:18 -0800 (PST)
Message-ID: <a13e9f56-0f1c-c934-9ca7-07ca8f82c6c8@gmail.com>
Date:   Thu, 10 Mar 2022 06:48:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
 <c4a02dbd-8dff-a311-ce4a-e7daffd6a22a@gmail.com>
 <478d1650-139b-f02b-bebf-7d54aa24eae2@kernel.dk>
From:   Artyom Pavlov <newpavlov@gmail.com>
In-Reply-To: <478d1650-139b-f02b-bebf-7d54aa24eae2@kernel.dk>
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

> OK, so what you're asking is to be able to submit an sqe to ring1, but
> have the completion show up in ring2? With the idea being that the rings
> are setup so that you're basing this on which thread should ultimately
> process the request when it completes, which is why you want it to
> target another ring?

Yes, to both questions.

> 1) It's a fast path code addition to every request, we'd need to check
>     some new field (sqe->completion_ring_fd) and then also grab a
>     reference to that file for use at completion time.

Since migration of tasks will be relatively rare, the relevant branch 
could be marked as cold and such branch should be relatively easy for 
CPU branch predictor. So I don't think we will see a measurable 
performance regression for the common case.

> 2) Completions are protected by the completion lock, and it isn't
>     trivial to nest these. What happens if ring1 submits an sqe with
>     ring2 as the cqe target, and ring2 submits an sqe with ring1 as the
>     cqe target? We can't safely nest these, as we could easily introduce
>     deadlocks that way.

I thought a better approach will be to copy SQE from ring1 into ring2 
internal buffer and execute it as usual (IIUC kernel copies SQEs first 
before processing them). I am not familiar with internals of io-uring 
implementation, so I can not give any practical proposals.

> My knee jerk reaction is that it'd be both simpler and cheaper to
> implement this in userspace... Unless there's an elegant solution to it,
> which I don't immediately see.

Yes, as I said in the initial post, it's certainly possible to do it in 
user-space. But I think it's a quite common problem, so it could warrant 
including a built-in solution into io-uring API. Also it could be a bit 
more efficient to do in kernel space, e.g. you would not need mutexes, 
which in the worst case may involve parking and unparking threads, thus 
stalling event loop.

 > The submitting task is the owner of the request, and will ultimately
 > be the one that ends up running eg task_work associated with the
 > request. It's not really a good way to shift work from one ring to
 > another, if the setup is such that the rings are tied to a thread and
 > the threads are in turn mostly tied to a CPU or group of CPUs.

I am not sure I understand your point here. In my understanding, the 
common approach for using io-uring is to keep in user_data a pointer to 
FSM (Finite State Machine) state together with pointer to a function 
used to drive FSM further after CQE is received (alternatively, instead 
of the function pointer a jump table could be used).

Usually, it does not matter much on which thread FSM will be driven 
since FSM state is kept on the heap. Yes, it may not be great from CPU 
cache point of view, but it's better than having unbalanced thread load.

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF844D4881
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 15:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiCJOCB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 09:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbiCJOCA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 09:02:00 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B38514E976
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 06:00:59 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id w12so9567498lfr.9
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 06:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=65P+uR8tywTIrtMqpg7cTIjPCnwNPA7Ch9lJDEY0oMs=;
        b=m4irANCDxMhzd7P65cQIbPKdtA6eY2YBchQ514tnVeGNEQAaOfuGcUic4CAfUSbR/q
         9BFobWCBCHcqY666PnsblX0C2+RbmEF2KbCTE0jRmMni04tGyCw5FFqJVcIkhxRD9KaD
         HH9ELvAg7Ptx0Z7d4IE9Giawcuj1RJIQU7O6wkw5ppM8fFItmvkHRMkOhprOa7vyPJLo
         CyPvpQhXuY3ApvQ+JLSlZSnZMJaF2WxiCaFVe2TBguN5MFg9KUwRJ6MBuK5Diq3AA4WK
         EegsRTrHxEf3U9V5Yic1NATpSK/gQFSp0FSLbzbp6REtRwW0Odw8Ge41y9B5yAXGiBkW
         /bVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=65P+uR8tywTIrtMqpg7cTIjPCnwNPA7Ch9lJDEY0oMs=;
        b=gsQl5zYI6FRj+NPLkO3CUAD7b/rIMllGbbCrTc++IeqwfOjo+/wQ1Rizj7q3WWQ/Zx
         QQ6C2J3A5Az9Vz8DPXatQ1sNz0K4G+QGYCfFLJxb/Jhs2KNFqs/KitINYs1JmXsAcN5+
         YXJOV+p8jJpVqq84k+WpN9kFJdauCUyBylLEVOwzDZ5NAsibHKIX2oN02+6J19ks3WKo
         wm4V+9oBJ4mJw2En+qI7BPUcNyEPzGtxdFq5+eDtl1x8pRdN9tIShubFWtK+wOWDkM+A
         VXQR02ZGAtP1w0IB4ISlJlIibhJRj+ut83GgjUKHmeICv/33N+ZeE57PLXDMsN2FqP+b
         JKQQ==
X-Gm-Message-State: AOAM530kxBeraYHQM22fRNbpYvEiphd3u7RjxKK97KdQApPREWH4mLLD
        udkUQmHMB+jwkA9N2fdfCg==
X-Google-Smtp-Source: ABdhPJy9j/7RgcMjD2NFcSJJe0WLDixq+W1Rh8gsLuAnU7kr0jSz268UVUiKh0Yiv31J2+yI9QUHhQ==
X-Received: by 2002:ac2:5d62:0:b0:448:6a0b:da42 with SMTP id h2-20020ac25d62000000b004486a0bda42mr817741lft.223.1646920857165;
        Thu, 10 Mar 2022 06:00:57 -0800 (PST)
Received: from [172.31.10.33] ([109.72.231.42])
        by smtp.gmail.com with ESMTPSA id f14-20020a056512092e00b004423570c03asm991562lft.287.2022.03.10.06.00.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 06:00:56 -0800 (PST)
Message-ID: <fd93cb36-6dd3-322b-7ec2-017a72e1a5f7@gmail.com>
Date:   Thu, 10 Mar 2022 17:00:55 +0300
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
 <a13e9f56-0f1c-c934-9ca7-07ca8f82c6c8@gmail.com>
 <9f8c753d-fed4-08ac-7b39-aee23b8ba04c@kernel.dk>
 <f12c2f2b-858a-421c-d663-b944b2adb472@kernel.dk>
From:   Artyom Pavlov <newpavlov@gmail.com>
In-Reply-To: <f12c2f2b-858a-421c-d663-b944b2adb472@kernel.dk>
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

> It's not the branches I'm worried about, it's the growing of the request
> to accomodate it, and the need to bring in another fd for this.
Maybe it's worth to pre-register fds of rings to which we can send CQEs 
similarly to pre-registering file fds? It would allow us to use u8 or 
u16 instead of u64 for identifying recipient ring.

> But I guess I'm still a bit confused on what this will buy is. The
> request is still being executed on the first ring (and hence the thread
> associated with it), with the suggested approach here the only thing
> you'd gain is the completion going somewhere else. Is this purely about
> the post-processing that happens when a completion is posted to a given
> ring?

As I wrote earlier, I am not familiar with internals of the io-uring 
implementation, so I am talking purely from user point of view. I will 
trust your judgment in regards of implementation complexity.

I guess, from user PoV, it does not matter on which ring the SQE will be 
executed. It can have certain performance implications, but otherwise it 
for user it's simply an implementation detail.

> How did the original thread end up with the work to begin with? Was the
> workload evenly distributed at that point, but later conditions (before
> it get issued) mean that the situation has now changed and we'd prefer
> to execute it somewhere else?

Let's talk about a concrete simplified example. Imagine a server which 
accepts from network commands to compute hash for a file with given 
path. The server executes the following algorithm:

1) Accept connection
2) Read command
3) Open file and create hasher state
4) Read chunk of data from file
5) If read data is not empty, update hasher state and go to step 4, else 
finalize hasher
6) Return the resulting hash and go to step 2

We have two places where we can balance load. First, after we accepted 
connection we should decide a ring which will process this connection. 
Second, during creation of SQE for step 4, if the current thread is 
overloaded, we can transfer task to a different thread.

The problem is that we can not predict how kernel will return read 
chunks. Even if we distributed SQEs evenly across rings, it's possible 
that kernel will return CQEs for a single ring in burst thus overloading 
it, while other threads will starve for events.

On a second thought, it looks like your solution with 
IORING_OP_WAKEUP_RING will have the following advantage: it will allow 
us to migrate task before execution of step 5 has started, while with my 
proposal we will be able to migrate tasks only on SQE creation (i.e. on 
step 4).

> One idea... You issue the request as you normally would for ring1, and
> you mark that request A with IOSQE_CQE_SKIP_SUCCESS. Then you link an
> IORING_OP_WAKEUP_RING to request A, with the fd for it set to ring2, and
> also mark that with IOSQE_CQE_SKIP_SUCCESS.

Looks interesting! I have forgot about linking and IOSQE_CQE_SKIP_SUCCESS.

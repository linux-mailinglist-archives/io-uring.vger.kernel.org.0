Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3A2539B7C
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 05:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345463AbiFAC5d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 22:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbiFAC5c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 22:57:32 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5C5DF73
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 19:57:29 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id q21so457587wra.2
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 19:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VlU6jUY7wAtm9Bs8MNKLYXFfs6AUzYRG2s9SGR//0Ic=;
        b=03ZIsGjfPkTEdzeYeGcdnGMo6XfL1Iv0dpubIloys/RgtbeqoZlCwIbqaHl7G28JHl
         PtAJhfdI98pHCxLPDqWiJ0485PIgSwsRJfl3/+T8F7dKXfnAQMiHQLDfqamJ5djC9V8L
         xMee+vtCsW+WxPsHVYw1kQZ0K5n3TMKQPTdR6SeGMWVddhbEWRf2Mr7/pzEd1aBJFGlm
         p4+rLE5Fied6Gy4sPGX3/GryftmbVmIo8ZQ/1YBV0Na+QYUeWZcU+RF7x21lhcoIa4Rp
         Ps5pMAi+lY5TIMj+IzOMV6en8poJEWlCGjBAjsXzZ917s7mMp+d+0zBM6QISj8lnbHmj
         u1gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VlU6jUY7wAtm9Bs8MNKLYXFfs6AUzYRG2s9SGR//0Ic=;
        b=ZTI6Y54HjvFtv0SpG/PLV7NIYsqAavVP6tUsB6SsIYoxnnGkbf6qLb0pUZiQF9Vxan
         H+6vKt2dr+qTpjuoNuLewf3jNt1p+xd+q2SLsdkIyIKn86Bqzh/nPCK1swJGltSwKetA
         WOSX1c/NMyq1OhmsglgrpvaRHLNelE41qWJhKnW4ZMlWhgRgz8IuvdG9hkmDXVU9poXw
         VfYfiy99VY5q/KTMazUR9hHWa3lL8zU6xoawJjMbgExXYK9LDK7fM3V6gsjXYpaXTTi6
         puRJBtavMMNGGI0tXZdD0q1W62N8fMglFt2L8UtPe52Endwj3uc23hfKHhzH/ysxHAQQ
         Giog==
X-Gm-Message-State: AOAM532WgDe9f7OjHLGLj8asnc/dhWwVIx5mC/D7CNQPSIRJqZ5wWglz
        ZDNFM2rwogbVB7KzGi7ajDIKeA==
X-Google-Smtp-Source: ABdhPJzn9nKigvqQAfDIeTCeiZNAuFUvrrmDUpOva7qD1eS6khkx2zgQ9b64RhQq+Z/ox7BE/6Nbcg==
X-Received: by 2002:adf:ef50:0:b0:20f:fc44:63e2 with SMTP id c16-20020adfef50000000b0020ffc4463e2mr27789267wrp.3.1654052248196;
        Tue, 31 May 2022 19:57:28 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id i6-20020adffc06000000b0020c5253d8dasm252906wrr.38.2022.05.31.19.57.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 19:57:27 -0700 (PDT)
Message-ID: <547fa5a1-b131-8ce6-1f5d-bdffb8d73462@kernel.dk>
Date:   Tue, 31 May 2022 20:57:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 0/5] io_uring: add opcodes for current working directory
Content-Language: en-US
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220531184125.2665210-1-usama.arif@bytedance.com>
 <da4e94f7-94ce-ad57-ad15-c9117c4fef2d@kernel.dk>
 <7a311f7e-a404-4ebe-f90b-af9068bab2fc@bytedance.com>
 <d466213e-81e0-4b0e-c1a4-824bcbe42f74@kernel.dk>
 <f7a4cdf2-78f2-fead-5a10-713e3dc9ea34@bytedance.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f7a4cdf2-78f2-fead-5a10-713e3dc9ea34@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/31/22 3:35 PM, Usama Arif wrote:
> 
> 
> On 31/05/2022 20:22, Jens Axboe wrote:
>> On 5/31/22 1:18 PM, Usama Arif wrote:
>>>
>>>
>>> On 31/05/2022 19:58, Jens Axboe wrote:
>>>> On 5/31/22 12:41 PM, Usama Arif wrote:
>>>>> This provides consistency between io_uring and the respective I/O syscall
>>>>> and avoids having the user of liburing specify the cwd in sqe when working
>>>>> with current working directory, for e.g. the user can directly call with
>>>>> IORING_OP_RENAME instead of IORING_OP_RENAMEAT and providing AT_FDCWD in
>>>>> sqe->fd and sqe->len, similar to syscall interface.
>>>>>
>>>>> This is done for rename, unlink, mkdir, symlink and link in this
>>>>> patch-series.
>>>>>
>>>>> The tests for these opcodes in liburing are present at
>>>>> https://github.com/uarif1/liburing/tree/cwd_opcodes. If the patches are
>>>>> acceptable, I am happy to create a PR in above for the tests.
>>>>
>>>> Can't we just provide prep helpers for them in liburing?
>>>>
>>>
>>> We could add a io_uring_prep_unlink with IORING_OP_UNLINKAT and
>>> AT_FDCWD in liburing. But i guess adding in kernel adds a more
>>> consistent interface? and allows to make calls bypassing liburing
>>> (although i guess people probably don't bypass liburing that much :))
>>
>> I'm not really aware of much that doesn't use the library, and even
>> those would most likely use the liburing man pages as that's all we
>> have. The kernel API is raw. If you use that, I would expect you to know
>> that you can just use AT_FDCWD!
>>
>>> Making the changes in both kernel and liburing provides more of a
>>> standard interface in my opinion so maybe it looks better. But happy
>>> to just create a PR in liburing only with prep helpers as you
>>> suggested if you think that is better?
>>
>> I don't disagree with that, but it seems silly to waste 5 opcodes on
>> something that is a strict subset of something that is already there.
>> Hence my suggestion would be to just add io_uring_prep_link() etc
>> helpers to make it simpler to use, without having to add 5 extra
>> opcodes.
>>
> 
> Thanks, I have created a PR for it on
> https://github.com/axboe/liburing/pull/588. We can review it there if
> it makes sense!

Sounds good, we'll move it there.

-- 
Jens Axboe


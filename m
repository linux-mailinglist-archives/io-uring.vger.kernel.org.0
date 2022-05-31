Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1355396ED
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 21:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347217AbiEaTW4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 15:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347207AbiEaTWz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 15:22:55 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB50253E1F
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 12:22:52 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q7so9007351wrg.5
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 12:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nUtS/Dk3AilMK7jbffkAueWMcpoEscrGw2I/RyT3Xgc=;
        b=0WgxzwVltX4wzkv4+hhv4QqgzTsXaqGWKqmv1FMD0yI/FjbnOvGKnmp35L0wJv7GY6
         4Bs0UGxYXOvUg/fNAVUHrtIkeswVzCIj9J6KJwScJgTyGA4tN584DI7HHIe2Em5D4X9s
         l8ajQqgXagl4RW3Hh4jME8n7jbCFdwCu/y8kxmW7P3lOBRrM/pLlEFF5GJJ8lyL3OH1I
         woLJy0dJLe64i4fhOI/RWgibS5K58TuHeWEv4bXwrbrCQQitN6SCkiod0bw00xVaBw7p
         orLpN1eAU8RKYprlDnRyW4lTfq/WwfZcyacz+RRkLXAPaCJl9814Yktisa2WPtWWtn7i
         QGmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nUtS/Dk3AilMK7jbffkAueWMcpoEscrGw2I/RyT3Xgc=;
        b=di2yZ2bFz3W5FoIrMS0z9EKc0HJ1gpqbkixauFs+yh46He8MgytcWn9DcgoujBrCWY
         wviHnTxyI1GoUpoxLN450NTmmaP9uEIQ6qU7wy/4tDQzft0tYVLQnquftuIGLzKjCnbw
         xeSRbZjkCL3+YgXSrt0250aKeDM6ivomcIutRirfm09wtCOOB87S+1zKM4+MSOZjhUjl
         VzFK1xod7edyqPBBySOTs9GKi4dT0Bk2y+3/kWcCPqTaSsWex6lW/oUfbbVvoJm01J/8
         EjVxcKlcLkgGo0vNDwJcfcAAoXxGk0YkV0HnlIP0M2g1fAhAUFFO9sXFiELdIZ2ibcgO
         qgXQ==
X-Gm-Message-State: AOAM531LXyFK1Ay8Lbzefk9BMKe+bT325Z01k0L5A1+GlaJOshLokj7L
        QB9oDfUEFEEL3M9GMAP+3y4/o5rpknbg1wak
X-Google-Smtp-Source: ABdhPJyBLbj0NOHGjYALnTO1kk1zSWVLt52T0cctfY8b5U/F4wY+xIN2CHyfBB+SdEtld7r/inOwGQ==
X-Received: by 2002:a5d:6d48:0:b0:20e:5f80:bd29 with SMTP id k8-20020a5d6d48000000b0020e5f80bd29mr51207529wri.428.1654024971434;
        Tue, 31 May 2022 12:22:51 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id 2-20020a056000154200b0020e615bab7bsm12684610wry.7.2022.05.31.12.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 12:22:50 -0700 (PDT)
Message-ID: <d466213e-81e0-4b0e-c1a4-824bcbe42f74@kernel.dk>
Date:   Tue, 31 May 2022 13:22:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [External] Re: [PATCH 0/5] io_uring: add opcodes for current
 working directory
Content-Language: en-US
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220531184125.2665210-1-usama.arif@bytedance.com>
 <da4e94f7-94ce-ad57-ad15-c9117c4fef2d@kernel.dk>
 <7a311f7e-a404-4ebe-f90b-af9068bab2fc@bytedance.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7a311f7e-a404-4ebe-f90b-af9068bab2fc@bytedance.com>
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

On 5/31/22 1:18 PM, Usama Arif wrote:
> 
> 
> On 31/05/2022 19:58, Jens Axboe wrote:
>> On 5/31/22 12:41 PM, Usama Arif wrote:
>>> This provides consistency between io_uring and the respective I/O syscall
>>> and avoids having the user of liburing specify the cwd in sqe when working
>>> with current working directory, for e.g. the user can directly call with
>>> IORING_OP_RENAME instead of IORING_OP_RENAMEAT and providing AT_FDCWD in
>>> sqe->fd and sqe->len, similar to syscall interface.
>>>
>>> This is done for rename, unlink, mkdir, symlink and link in this
>>> patch-series.
>>>
>>> The tests for these opcodes in liburing are present at
>>> https://github.com/uarif1/liburing/tree/cwd_opcodes. If the patches are
>>> acceptable, I am happy to create a PR in above for the tests.
>>
>> Can't we just provide prep helpers for them in liburing?
>>
> 
> We could add a io_uring_prep_unlink with IORING_OP_UNLINKAT and
> AT_FDCWD in liburing. But i guess adding in kernel adds a more
> consistent interface? and allows to make calls bypassing liburing
> (although i guess people probably don't bypass liburing that much :))

I'm not really aware of much that doesn't use the library, and even
those would most likely use the liburing man pages as that's all we
have. The kernel API is raw. If you use that, I would expect you to know
that you can just use AT_FDCWD!

> Making the changes in both kernel and liburing provides more of a
> standard interface in my opinion so maybe it looks better. But happy
> to just create a PR in liburing only with prep helpers as you
> suggested if you think that is better?

I don't disagree with that, but it seems silly to waste 5 opcodes on
something that is a strict subset of something that is already there.
Hence my suggestion would be to just add io_uring_prep_link() etc
helpers to make it simpler to use, without having to add 5 extra
opcodes.

-- 
Jens Axboe


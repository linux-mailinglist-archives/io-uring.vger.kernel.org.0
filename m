Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B4B5396D9
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 21:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347237AbiEaTSz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 15:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347236AbiEaTSy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 15:18:54 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7795C6622C
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 12:18:53 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id v4-20020a1cac04000000b00397001398c0so1768007wme.5
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 12:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QV/G4PVJExKY57XFucH9uGcNnMu76eJ/OVGsDYsOIxk=;
        b=GcC+/wChmFe5D+lixU/ePQYx0vMtmjgY9jywtGC+tExjQD07sAc/uXheAhph4pvAzO
         Sdv43qQhkTojoFFX+ZjxgmxVvX0+NMfOKTRPQv/Xt6Pf+BeM7pFrMuBoOUyGP7QXVVcf
         s+RGAFxVlgrWtwQp6NAJofgTxsyG/3PZ3t/vPzWngz2jgePhEzYZMFJ07J6MCT6QTq4K
         CSdYCUDuR3/QKpYgHLVjxtsuWsCI7UbUs1hc8zcQEOdN6xNkMd00NMQ+Xy9xkNlbQfv8
         ewmYprJTuaWmqLiLgBW9BJeEqbwfx9wBu8injJinul0Kqwoyb/wRwoGqtv/VE93GzufG
         4pWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QV/G4PVJExKY57XFucH9uGcNnMu76eJ/OVGsDYsOIxk=;
        b=KSESQ1JdHEI3alvuD0aT/5YwOLxnv/krvCVIufILK5aT5f8Vu0IqeVmXpb01v9Ovp1
         t7NbvedOXjOpjx7JvVEoLDNATRl8IY1Z57fJsu63zAclkxWNO/1z4C5xSdTE2renLQ1L
         upFKuGDYnOawcnwpcadI8XruQVGbKmChLCozELNT432FrtN+zCuu7QYZIQJDKhVkUNrp
         q6laraajtO6t8cl3NHy6yXGmBV/emKM1vCqTDt1wXHNGZtW6/G6W4e5/Wpar3bYuv2xW
         SKqj93Qv99GoMiWdayHk95pSPrJRWa5pBZLz26nlAwLCA8DywhhuHtrnzCq2KTbJrfHo
         hysw==
X-Gm-Message-State: AOAM532v7jDfDBUDT++konTygMn9JkxKcm9Y1oOk02Luu04jt7U2I5WX
        TaRKXnxF/DrrPb7wmmUoRk0y5g==
X-Google-Smtp-Source: ABdhPJwcDNCyyGGF9tXLL+3yceqJNymcMQaqK1jcouWuFSM3hjbBb4FI5vkaGlcAkdKh3wggbP0MQA==
X-Received: by 2002:a1c:c917:0:b0:399:26af:3d47 with SMTP id f23-20020a1cc917000000b0039926af3d47mr16751970wmb.143.1654024732108;
        Tue, 31 May 2022 12:18:52 -0700 (PDT)
Received: from ?IPV6:2a02:6b6a:b497:0:359:2800:e38d:e04f? ([2a02:6b6a:b497:0:359:2800:e38d:e04f])
        by smtp.gmail.com with ESMTPSA id f8-20020a5d64c8000000b0020d07958bb3sm12632620wri.3.2022.05.31.12.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 12:18:51 -0700 (PDT)
Message-ID: <7a311f7e-a404-4ebe-f90b-af9068bab2fc@bytedance.com>
Date:   Tue, 31 May 2022 20:18:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [External] Re: [PATCH 0/5] io_uring: add opcodes for current
 working directory
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220531184125.2665210-1-usama.arif@bytedance.com>
 <da4e94f7-94ce-ad57-ad15-c9117c4fef2d@kernel.dk>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <da4e94f7-94ce-ad57-ad15-c9117c4fef2d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 31/05/2022 19:58, Jens Axboe wrote:
> On 5/31/22 12:41 PM, Usama Arif wrote:
>> This provides consistency between io_uring and the respective I/O syscall
>> and avoids having the user of liburing specify the cwd in sqe when working
>> with current working directory, for e.g. the user can directly call with
>> IORING_OP_RENAME instead of IORING_OP_RENAMEAT and providing AT_FDCWD in
>> sqe->fd and sqe->len, similar to syscall interface.
>>
>> This is done for rename, unlink, mkdir, symlink and link in this
>> patch-series.
>>
>> The tests for these opcodes in liburing are present at
>> https://github.com/uarif1/liburing/tree/cwd_opcodes. If the patches are
>> acceptable, I am happy to create a PR in above for the tests.
> 
> Can't we just provide prep helpers for them in liburing?
> 

We could add a io_uring_prep_unlink with IORING_OP_UNLINKAT and AT_FDCWD 
in liburing. But i guess adding in kernel adds a more consistent 
interface? and allows to make calls bypassing liburing (although i guess 
people probably don't bypass liburing that much :))

Making the changes in both kernel and liburing provides more of a 
standard interface in my opinion so maybe it looks better. But happy to 
just create a PR in liburing only with prep helpers as you suggested if 
you think that is better?

Thanks!

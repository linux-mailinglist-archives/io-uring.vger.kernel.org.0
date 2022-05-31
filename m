Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040FD53969D
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 20:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbiEaS6U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 14:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344196AbiEaS6T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 14:58:19 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295F7562E2
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 11:58:17 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id q21so8697782wra.2
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 11:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3jqFKxuM0VdeJ/MyByEyz+wyq2IRR/BBVsyEiN0wEB8=;
        b=WEETQz6q/FWDtvpNTT4MeaxxeAJrhldu2uL5U/wiI5BGoF0Gn/2MkEqnlWTohkqfNL
         zUwt7LiMyWJxJS0M5FUEsSiecRclKm84gYN+DeZ+Ef/BbWtLVf+kpvoUai3Kp5phExa8
         NEJuRtL0p1mu6H4M1zWhFFLRldtWTBvdeX33agqaG5394MPaPY91cQ3/UYn7U4b2Kjr9
         2ulNax3VDLzItei+PR72dqILLCSQBS8Zn3XeMEwikeWWodb7dCLPPKcqytvor/+I8rj0
         mpEeMSYVX43ZatslYop6VK2XHssgPqsdwuoRTRCtwAd55TAj4ZWVh6CKxHuJKPkFhs59
         lmzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3jqFKxuM0VdeJ/MyByEyz+wyq2IRR/BBVsyEiN0wEB8=;
        b=HWwp+SiPznbnVMA9wewiVD91Ob0zwUasYQi56ttBJrpU0vrqzV13Y8CHnZ+zboUWXP
         dxS7f7EEfEonOHsdVrrbtO/67hgcqdn7j8vZQxIxui/ll+aRLMJKvBQlZR330gCOeMJl
         q818xULMWjOWODnWx3IzHOeIlKynvOkk0XiJkTyLOuDvG0ljY++VPew75ALsmU5/bngt
         N0Q2o4Hb2K4kI8Z0UMJR16g3NSO6q7mU/zsBPyo/BMHvpKWDu6bOG76eybgAWqd/tEHo
         LsLcKBRIsdHbe/YmwnEKcCQ/BYZFVHHVrLYJLBuCpYl+HessePb3J+0yFcxcym+2AM7g
         +LdA==
X-Gm-Message-State: AOAM5331+mWVzLHsfNDLJI5HvlQf8zk7KNPigngoqm/pR5Yicwry2mei
        hDX44VMCxuiSo6DhTDuL/Ocqy6pnYdnCWs74
X-Google-Smtp-Source: ABdhPJzaXozUmfTumRxUq5m+SNRdgDLpeB6YFm8blpCdw8skJx9KTpGM+HSWp+5rOpD7JsvU6/af/A==
X-Received: by 2002:a05:6000:1542:b0:20f:f4fc:4cd3 with SMTP id 2-20020a056000154200b0020ff4fc4cd3mr29118402wry.299.1654023495617;
        Tue, 31 May 2022 11:58:15 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id f8-20020a5d64c8000000b0020d07958bb3sm12599259wri.3.2022.05.31.11.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 11:58:15 -0700 (PDT)
Message-ID: <da4e94f7-94ce-ad57-ad15-c9117c4fef2d@kernel.dk>
Date:   Tue, 31 May 2022 12:58:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 0/5] io_uring: add opcodes for current working directory
Content-Language: en-US
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220531184125.2665210-1-usama.arif@bytedance.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220531184125.2665210-1-usama.arif@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/31/22 12:41 PM, Usama Arif wrote:
> This provides consistency between io_uring and the respective I/O syscall
> and avoids having the user of liburing specify the cwd in sqe when working
> with current working directory, for e.g. the user can directly call with
> IORING_OP_RENAME instead of IORING_OP_RENAMEAT and providing AT_FDCWD in
> sqe->fd and sqe->len, similar to syscall interface.
> 
> This is done for rename, unlink, mkdir, symlink and link in this
> patch-series.
> 
> The tests for these opcodes in liburing are present at
> https://github.com/uarif1/liburing/tree/cwd_opcodes. If the patches are
> acceptable, I am happy to create a PR in above for the tests.

Can't we just provide prep helpers for them in liburing?

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CBF51DD64
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 18:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443676AbiEFQSs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 12:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443671AbiEFQSq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 12:18:46 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DED313F2D
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 09:15:03 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so11205269pjb.5
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 09:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=w7Q6FHT5P7kuoH3lLIOpulNCMvZrKfSc9d1fbtcgZsM=;
        b=g0T98pkT0/A1yfrSdlv8Wdwab/TGcvY+QTB/bMbAaj13vbp6qOdkZnbYaMpuKRTQih
         uuclSGU5flfxHZMT3fPBhyg+nTeYyW816JYwNyfK64pDuBCNtg2FNEALJKMUTy6Xp156
         oKqraAV/A4Tws0wva8qLJGbJWhVqJvobkRAZUvCUEDqLU7EwAtAPUJOuok2394XWj7Vi
         Gli1rqJKL95m6Ewf1Y5ZKXo5EnnZiCIEElEl1/0TE892AnYkXVuzfwHmolBdH2rxitGR
         ZIQz1X5lQUPs6fWmSoQNeI1Mi3qgilYl/Pdg9GznDnY6mSMpSZNGrNROn8g4blOuggte
         pLAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=w7Q6FHT5P7kuoH3lLIOpulNCMvZrKfSc9d1fbtcgZsM=;
        b=7Y/bA0xSocrdSP6DEfUVUBPlWIbi7xZnO/tZt5nQZxqLu1xS4feI76GMCSL6uTNymp
         iJTVt/epPuBiZ1z3pAouNsj5055deCRRyDzlfBJd3L+sSU8UJo9orKV19CQ054Uh0qh3
         mfymPJWSazYhOoVMeKLY0NOOyiLFU+kO/GaFLlqJFsiRhpBj8eX08nZx2qQ3JKvIzcFB
         FfwAUKF7+2z1BSS5iXgcfJIqxhAMlTVondvubedQ8y/ak/bZ4XoPGXMSGlt0rG6TULJJ
         Wji6pCUQ4PGnN9+Pv1e6zC6Hn8h8q9BBFYThljGuT6lPIOwTSz9xtAlcotho9Z4VgB07
         8h9w==
X-Gm-Message-State: AOAM531ndn862YqBnkEiIi424yq5s6muXfeiO+Z0WihhShlmfGlIViZ3
        XxfpFCQXAlwo/e4SEl1D1sdoPA==
X-Google-Smtp-Source: ABdhPJwPCvubHbHQnMQNJdaL6+neV5ypGRrKA9WYKHYQz09LFlORufQb/PW30SNBJ06GCJNJKJjFJg==
X-Received: by 2002:a17:903:32c6:b0:15e:c1cc:2405 with SMTP id i6-20020a17090332c600b0015ec1cc2405mr4515091plr.117.1651853702959;
        Fri, 06 May 2022 09:15:02 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id lk17-20020a17090b33d100b001cd4989ff5esm3819354pjb.37.2022.05.06.09.15.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 09:15:02 -0700 (PDT)
Message-ID: <6c417ba7-d677-5076-5ce3-d3e174eb8899@kernel.dk>
Date:   Fri, 6 May 2022 10:15:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: linux-stable-5.10-y CVE-2022-1508 of io_uring module
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Guo Xuenan <guoxuenan@huawei.com>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com
References: <dd122760-5f87-10b1-e50d-388c2631c01a@kernel.dk>
 <20220505141159.3182874-1-guoxuenan@huawei.com>
 <7d54523e-372b-759b-1ebb-e0dbc181f18d@kernel.dk>
 <31ae3426-b835-3a3f-f6d1-aecad24066e8@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <31ae3426-b835-3a3f-f6d1-aecad24066e8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 9:57 AM, Pavel Begunkov wrote:
> On 5/6/22 03:16, Jens Axboe wrote:
>> On 5/5/22 8:11 AM, Guo Xuenan wrote:
>>> Hi, Pavel & Jens
>>>
>>> CVE-2022-1508[1] contains an patch[2] of io_uring. As Jones reported,
>>> it is not enough only apply [2] to stable-5.10.
>>> Io_uring is very valuable and active module of linux kernel.
>>> I've tried to apply these two patches[3] [4] to my local 5.10 code, I
>>> found my understanding of io_uring is not enough to resolve all conflicts.
>>>
>>> Since 5.10 is an important stable branch of linux, we would appreciate
>>> your help in solving this problem.
>>
>> Yes, this really needs to get buttoned up for 5.10. I seem to recall
>> there was a reproducer for this that was somewhat saner than the
>> syzbot one (which doesn't do anything for me). Pavel, do you have one?
> 
> No, it was the only repro and was triggering the problem
> just fine back then

I modified it a bit and I can now trigger it.

-- 
Jens Axboe


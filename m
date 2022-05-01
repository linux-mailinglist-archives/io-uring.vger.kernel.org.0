Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF18C516237
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 08:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241800AbiEAGe5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 02:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbiEAGez (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 02:34:55 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA5E12AA1;
        Sat, 30 Apr 2022 23:31:30 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c11so63861plg.13;
        Sat, 30 Apr 2022 23:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=C3fw8DIFF0S9vtq6+VZ86MGJHG+O7QFGmF8dzFDlkn0=;
        b=b50AxEBIlMAkxEuc8Xq73f92g/HVSeCn7ILG63CJBJ8YxHsInlZ7048PQdWBooTpqX
         hLCCUyzXzOMXdjTF0xcZ3g+Q0WCMyD1YI//fNd1trC4NOjZimLUwGmF2SJcA8kyfJuux
         lKsvNWlOchpbigmyhpC4/3c/VibhAjka2RUqg/cD6k6r/11ydL6/wtDlwXBnW2KoUST0
         /TIeHsyesmLkRA7J6zw8PSZBnbkEgPSaEhkXOFJBwMWfJVSGkZsunJ0Lp/kICuMuu3Yo
         2dnGMPID0hO+4H8x14/ohVo8BuhCYplSUWM7l6TiOtIlfKEOQOQvcgcG3LmNv91MmMqI
         ztSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C3fw8DIFF0S9vtq6+VZ86MGJHG+O7QFGmF8dzFDlkn0=;
        b=nzTymDs7Bxy0vPWTSenQ/a8EchX/YeWRIyJaN9wsRTOaqkEzshOBZPeemcGJO8ddZ4
         yBsoCCwnzjQrnfKfuse8eQLHuaRxV8g0ho4ETTpMP//MG0oMKrJrlk85srpxsTg17BYq
         MhgJQqS1fOiqm9uNpHBgOB7LPuWodF0+Mw94qjJQuUXei1kuNNnLEuVGTVsOuUV91IKt
         7YuySq5LV1hmWwB6GM8TUQ/iCWyMsY+49Nm/izmr6GmEyKBCF75IpcwkYT3ATyCCC+N8
         rkglUYkZJaDQpWZfWf8VVI+NJb7cWEMenPAUqBlqq3M14L3NiMxmT0jBcph5tPV+Obn0
         v1VA==
X-Gm-Message-State: AOAM532WUUpVTDJT0HjjalW3Qp1CXL7XI4Vm0JTBnEnxUxsKH3ACmMa0
        2yk1CWHNSagkyRsPXhEXgYBVf6X9jXmovYfQ
X-Google-Smtp-Source: ABdhPJzxT9dATzzPTyUZNf4N+sT4vHr6bBbiLdGX8A9LUpAGqEl7PEIOQTDpKPo2eXY8ayPjvim6UQ==
X-Received: by 2002:a17:90a:6445:b0:1d6:a69e:406c with SMTP id y5-20020a17090a644500b001d6a69e406cmr12149202pjm.49.1651386690104;
        Sat, 30 Apr 2022 23:31:30 -0700 (PDT)
Received: from [127.0.0.1] ([103.121.210.106])
        by smtp.gmail.com with ESMTPSA id j12-20020a170903028c00b0015e8d4eb1b6sm2383682plr.0.2022.04.30.23.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Apr 2022 23:31:29 -0700 (PDT)
Message-ID: <30161ae8-690a-4423-546a-8fbea9f0bdb1@gmail.com>
Date:   Sun, 1 May 2022 14:30:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC v3 0/9] fixed worker
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220429101858.90282-1-haoxu.linux@gmail.com>
 <ee61dae0-30d4-b301-a787-ea83be3f9308@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <ee61dae0-30d4-b301-a787-ea83be3f9308@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/30/22 21:11, Jens Axboe wrote:
> On 4/29/22 4:18 AM, Hao Xu wrote:
>> This is the third version of fixed worker implementation.
>> Wrote a nop test program to test it, 3 fixed-workers VS 3 normal workers.
>> normal workers:
>> ./run_nop_wqe.sh nop_wqe_normal 200000 100 3 1-3
>>          time spent: 10464397 usecs      IOPS: 1911242
>>          time spent: 9610976 usecs       IOPS: 2080954
>>          time spent: 9807361 usecs       IOPS: 2039284
>>
>> fixed workers:
>> ./run_nop_wqe.sh nop_wqe_fixed 200000 100 3 1-3
>>          time spent: 17314274 usecs      IOPS: 1155116
>>          time spent: 17016942 usecs      IOPS: 1175299
>>          time spent: 17908684 usecs      IOPS: 1116776
> 
> I saw these numbers in v2 as well, and I have to admit I don't
> understand them. Because on the surface, it sure looks like the first
> set of results (labeled "normal") are better than the second "fixed"
> set. Am I reading them wrong, or did you transpose them?
Sorry, I transposed them..
> 
> I think this patch series would benefit from a higher level description
> of what fixed workers mean in this context. How are they different from
> the existing workers, and why would it improve things.
Sure, put that in the Patch 7/9, I'll move it to the cover letter as
well.
> 
>> things to be done:
>>   - Still need some thinking about the work cancellation
> 
> Can you expand? What are the challenges with fixed workers and
> cancelation?
Currently, when a fixed worker fetch all the works from its private work
list, I use a temporary acct struct to hold them. This means at that
moment the cancellation cannot find these works which are going to run
but not in the private work list already. This won't be a big problem,
another acct member in io_worker{} should be good enough to resolve
that.
> 
>>   - not very sure IO_WORKER_F_EXIT is safe enough on synchronization
>>   - the iowq hash stuff is not compatible with fixed worker for now
> 
> We might need to extract the hashing out a bit so it's not as tied to
> the existing implementation.
> 


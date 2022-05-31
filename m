Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3587538D1F
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 10:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239278AbiEaIqo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 04:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244948AbiEaIqn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 04:46:43 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE3CFEC
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 01:46:42 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id u3so17664697wrg.3
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 01:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MuhrLMJggSHQQM7Czw436O/UqPhk6xiNeYtWruV/6nI=;
        b=PSSeP+IizzTvRHhxdsHqZgaPBZphNWT/+6IPmqrRuuG1yIvFn5rfXK0/vNmxUdQeAH
         G6ZxXEuoHAQyVuHCezTOS/l63HAtL3P1QnAsDX4bIEnEVGTP+oLybPeu1HxdK+m50c9L
         m59AjbqNfjmmtTg9v71Yhd9PNZpgHRxCd/Tbs4eFoAtfsMM5g+T17YgCw4fWt+IXuOuZ
         Gto1UTeo4ZmPY5sTm2owWvjnjqoXXV+rimXmSDllHfGPz1El/UycbyYqvTBqZB91PwGl
         g9oBWXx9TWeoeOp3FkfzyPV54s243IH4Bhv4a1OAzgUYBLyCY/xTi4pu8I5xGxTn3ym7
         a0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MuhrLMJggSHQQM7Czw436O/UqPhk6xiNeYtWruV/6nI=;
        b=Cq8yxQcUqGy8yhkuTBAxUuGpsSqvLu9V+JkFhoVtqW53mV9qxGupYptvQm15CgyEl1
         adlB0skiKY4rKrUZlRstlB7MlIFJ6xVR7FBwd1SN1qoOPjOG6bkWSYLuON38SGMct+eA
         x5LJKkydLOY46jsyNawHc3eoai5GKYXXtOgCtI62/vpSL1x0YbDEXPPIVBqb4ppkLnNe
         W/9TL1GqmCs6RyNDFnlxhu/KWzXYaEVuNeZx5Q+Zan4SonzA09Z7qrtMQnaxgj1fjZ3/
         prdwWKCxs9PZUI7ucC/Bo7CAsvGBHkLnFRAHbtapGD8ggjkAYh4SsRkJVpS8Po7wMLfJ
         pSPQ==
X-Gm-Message-State: AOAM532h6+8IOzSJzMU4J8jUdD5Zpo8LmTqO1uDJphK4i2JrmpkVXcYt
        GeRQgKJ5mgvVEwwzDYDzOxjA+g==
X-Google-Smtp-Source: ABdhPJwV75Ia+Ke0KLHZ3yU942+ECElEOg72Cj3McPoFlzKkLFlWQBrEZKuPA9UPl0L7dU9DcSHw6g==
X-Received: by 2002:a05:6000:1866:b0:20f:c0d2:a25c with SMTP id d6-20020a056000186600b0020fc0d2a25cmr42305617wri.457.1653986800649;
        Tue, 31 May 2022 01:46:40 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id l6-20020adff486000000b0020c5253d907sm10967991wro.83.2022.05.31.01.46.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 01:46:39 -0700 (PDT)
Message-ID: <6e0e18e8-79d6-92e5-99cc-0b074a04fb69@kernel.dk>
Date:   Tue, 31 May 2022 02:46:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v4 00/11] fixed worker
Content-Language: en-US
To:     Hao Xu <haoxu.linux@icloud.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20220515131230.155267-1-haoxu.linux@icloud.com>
 <1071c09c-8670-b883-5b64-2cd1fb69d943@icloud.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1071c09c-8670-b883-5b64-2cd1fb69d943@icloud.com>
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

On 5/31/22 1:05 AM, Hao Xu wrote:
> On 5/15/22 21:12, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> This is the second version of fixed worker implementation.
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
>>
>> About 2x improvement. From perf result, almost no acct->lock contension.
>> Test program: https://github.com/HowHsu/liburing/tree/fixed_worker
>> liburing/test/nop_wqe.c
>>
>> v3->v4:
>>   - make work in fixed worker's private worfixed worker
>>   - tweak the io_wqe_acct struct to make it clearer
>>
> 
> Hi Jens and Pavel,
> Any comments on this series? There are two coding style issue and I'm
> going to send v5, before this I'd like to get some comment if there is
> any.

I'll try to find some time to review it, doing a conference this week.
Rebasing on the current for-5.20/io_uring branch would be a good idea
anyway.

Also, looks like your numbers are still swapped in the above, since
fixed workers are still presented as taking longer / running slower?

-- 
Jens Axboe


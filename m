Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327E9730D2C
	for <lists+io-uring@lfdr.de>; Thu, 15 Jun 2023 04:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241083AbjFOCXd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Jun 2023 22:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237432AbjFOCXc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Jun 2023 22:23:32 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB831FCC
        for <io-uring@vger.kernel.org>; Wed, 14 Jun 2023 19:23:30 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-656bc570a05so1716818b3a.0
        for <io-uring@vger.kernel.org>; Wed, 14 Jun 2023 19:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686795810; x=1689387810;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zRVuhVOQJ05/pCBNK+aRFQeAzR+EyCp0XulegTSbfDs=;
        b=4GwSHKiD4LJdTySuuTC9+ttjblWhDY4ReN+SLBe7WNn3kH36q9Bt3G/H2yvXo2QuZ9
         1NOcrYP0wC1c6r4xMyyJKXo1iNVIBg44eEDvpmpwL15i4toSiIzfN8Q478caY8FMpZqp
         jJIZBd19vOUCrxRG5Wb1CcmCDZLOUzvjB6zL78OWGFdyymzrdFSCWGRKAaZ+8Fdahk8G
         fReDzGzooTS+K4wgLfIos+sg231m66Blujg0/QILoTlXJo3BvwWblHRAGSA5TII8xZnO
         SJEYNp9fGMGShXcpQ87X8wZWFR5hSn60dQuO6tUpJDjW8iXdOmUIp8yc8Lt2ly3HamO7
         M/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686795810; x=1689387810;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zRVuhVOQJ05/pCBNK+aRFQeAzR+EyCp0XulegTSbfDs=;
        b=gY/L7KOUIpfByUbUrf2bjd27svyn+PP04BtGGG+mOWBK7+VVoQ+y8pjnQhwhoUw1up
         EGNd9Jhe4cDXyA6jlqsEZfFrpMXrt2KzXO42WLJgY6RGanGytFNXMkCBziaEu2uYPO2e
         riiXiuq8pJa1kg8MPlvHBM6C4XZDmDUTlimjCDOxcORQsUSBsO6Ovu8XFGlcxcKprAmo
         XTbGLTyRbsbI4EHVZhlAF/ern4h9WAxnG2N5gBso+xmgfzDGMmzka+5iqolET9Viy9ct
         wCkcxYWSmiH78tKSg2c0isqjFrwjjmAn89xwCyanVFM8zqL1DRhMylFqvyCs8RzI0L3l
         5ykA==
X-Gm-Message-State: AC+VfDywTPxHHaAnoEj9mDq0GbcNlhmbXufxgVQxcd6GQGDw7XS9YQsL
        Yku13Thd6A8iJHmiX0xuwZXLaMbSF1KgneLj84Q=
X-Google-Smtp-Source: ACHHUZ599Vx288IxetUpa/SrPNjULHrlnYp8nQuIEKRVZQofanhsESw+bhDjCrKXLuJLfz5Qgbch7g==
X-Received: by 2002:a05:6a00:3406:b0:65f:2fbd:3708 with SMTP id cn6-20020a056a00340600b0065f2fbd3708mr19686783pfb.0.1686795809667;
        Wed, 14 Jun 2023 19:23:29 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n2-20020a62e502000000b006634d0fe2c6sm10911008pff.203.2023.06.14.19.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 19:23:29 -0700 (PDT)
Message-ID: <18f7cc1e-5e0c-def9-4d86-d7971df17f54@kernel.dk>
Date:   Wed, 14 Jun 2023 20:23:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring/io-wq: don't clear PF_IO_WORKER on exit
Content-Language: en-US
To:     Zorro Lang <zlang@redhat.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>
References: <2392dcb4-71f4-1109-614b-4e2083c0941e@kernel.dk>
 <20230614005449.awc2ncxl5lb2eg6m@zlang-mailbox>
 <5d5ccbb1-784c-52b3-3748-2cf7b5cf01ef@kernel.dk>
 <20230615022203.3nh7qefrbhzboz43@zlang-mailbox>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230615022203.3nh7qefrbhzboz43@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/23 8:22?PM, Zorro Lang wrote:
> On Tue, Jun 13, 2023 at 07:14:25PM -0600, Jens Axboe wrote:
>> On 6/13/23 6:54?PM, Zorro Lang wrote:
>>> On Mon, Jun 12, 2023 at 12:11:57PM -0600, Jens Axboe wrote:
>>>> A recent commit gated the core dumping task exit logic on current->flags
>>>> remaining consistent in terms of PF_{IO,USER}_WORKER at task exit time.
>>>> This exposed a problem with the io-wq handling of that, which explicitly
>>>> clears PF_IO_WORKER before calling do_exit().
>>>>
>>>> The reasons for this manual clear of PF_IO_WORKER is historical, where
>>>> io-wq used to potentially trigger a sleep on exit. As the io-wq thread
>>>> is exiting, it should not participate any further accounting. But these
>>>> days we don't need to rely on current->flags anymore, so we can safely
>>>> remove the PF_IO_WORKER clearing.
>>>>
>>>> Reported-by: Zorro Lang <zlang@redhat.com>
>>>> Reported-by: Dave Chinner <david@fromorbit.com>
>>>> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>>>> Link: https://lore.kernel.org/all/ZIZSPyzReZkGBEFy@dread.disaster.area/
>>>> Fixes: f9010dbdce91 ("fork, vhost: Use CLONE_THREAD to fix freezer/ps regression")
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>
>>>> ---
>>>
>>> Hi,
>>>
>>> This patch fix the issue I reported. The bug can be reproduced on v6.4-rc6,
>>> then test passed on v6.4-rc6 with this patch.
>>>
>>> But I found another KASAN bug [1] on aarch64 machine, by running generic/388.
>>> I hit that 3 times. And hit a panic [2] (once after that kasan bug) on a x86_64
>>> with pmem device (mount with dax=never), by running geneirc/388 too.
>>
>> Can you try with this? I suspect the preempt dance isn't really
>> necessary, but I can't quite convince myself that it isn't. In any case,
>> I think this should fix it and this was exactly what I was worried about
>> but apparently not able to easily trigger or prove...
>>
>>
>> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
>> index fe38eb0cbc82..878ec3feeba9 100644
>> --- a/io_uring/io-wq.c
>> +++ b/io_uring/io-wq.c
>> @@ -220,7 +220,9 @@ static void io_worker_exit(struct io_worker *worker)
>>  	list_del_rcu(&worker->all_list);
>>  	raw_spin_unlock(&wq->lock);
>>  	io_wq_dec_running(worker);
>> -	worker->flags = 0;
>> +	preempt_disable();
>> +	current->worker_private = NULL;
>> +	preempt_enable();
> 
> Hi,
> 
> This version looks better to me, generic/051 and generic/388 all test
> passed, no panic or hang. More fstests regression tests didn't find
> critical issues. (Just another ppc64le issue, looks like not related
> with this patch)

Good, thanks for testing!

> But I saw fd37b884003c ("io_uring/io-wq: don't clear PF_IO_WORKER on
> exit") has been merged, so this might has to be another regression
> fix.

Yep, this fix will go out tomorrow/friday.

-- 
Jens Axboe


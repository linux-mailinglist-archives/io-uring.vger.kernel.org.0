Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B633F743B
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 13:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239411AbhHYLTU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 07:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbhHYLTU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 07:19:20 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCAFC061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 04:18:34 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id q14so1711728wrp.3
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 04:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QxzAxSBh94yQywG5jps0wIgVj4eeVZKBqpESyLfptFQ=;
        b=u0Bd261WP31zZvz3+M+MCfigvqb+DW9VNg11TpyUsGsTg/bXsCYrZ3lADgm3pKcLN+
         2ao22D/yQrHTafH6YW2ei0SX1/UpCyUp+81DeIEAsMPYfLMKKFMmq5uFPVAbWWLW7hoe
         aCiJiaUer5XTedTZ1mNwafsCZv5YF935GF+ffJX0BZm3B05ehbcESt+unTdGCTf24aXz
         DgPO2xu1cuLQT1CSpP0FEI4cgVTcYcr34Bh1SgscAQ0oJA4MxtrYYuccz/2+dzXyHKoq
         pNXJOyBSpYwdoi+aeE6oXlA2sXH+YZPaJz8p6YPGZG0roIjAmnwP1//Lm/lP/voNGOoe
         SJXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QxzAxSBh94yQywG5jps0wIgVj4eeVZKBqpESyLfptFQ=;
        b=SPsieykbcg3AdWgAKlTbOpRMxRTF81/wTBWp5CWikWAWG+LnAw8zN9CLeB5rh4/HUb
         XRX/OUs2EZUhvCIsOslBjkoOFlHjR5lJXzqzye1/VRlcxJ4WyhXN8Cdk82SoJpRkY3m2
         +cHRtsLmQEzq/5nJPCTc7uVdmf7MmXRKKubyeKy22zYPnfvB6P/E+a+5K7dpzTmnLYI9
         BhNxuQGmbcsXqtUJTOQmWkh0Sd/6DXm+X4Ebq6oMKjtqS6PWxwCjTNcvF+yzsshyMbx9
         X0jnj9zX1CaPFln3WY9U6LvvdqWJhrwqa0NNVHXPW/ycdsaKOLGkr/W+QmEntBNmRnQE
         n7yw==
X-Gm-Message-State: AOAM5328mKzSgFeV6EzmwYX6XiHB5EK6WaIHXDgAVsJITu6CP9KQ9ZC/
        aRo9SEvmz/s9bHD+8HUiXt6Zp+RRcfw=
X-Google-Smtp-Source: ABdhPJzk+D7lDo2GVuzyWlRZYTHLxx5dv0KPpTooLIaX/cqBA+mEFaXg5NY+ZK09HewV92Dk9YZtQQ==
X-Received: by 2002:adf:fc45:: with SMTP id e5mr24132060wrs.127.1629890313106;
        Wed, 25 Aug 2021 04:18:33 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id n4sm5258120wro.81.2021.08.25.04.18.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 04:18:32 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210823183648.163361-1-haoxu@linux.alibaba.com>
 <20210823183648.163361-3-haoxu@linux.alibaba.com>
 <50876fd1-9e8a-baf4-e76e-7232eaae45d9@gmail.com>
 <edd2c9c4-774b-6aa2-c871-df8312067f3e@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: add irq completion work to the head of
 task_list
Message-ID: <e8d3cfe4-0dd0-7708-c660-0f4df6e2f6f7@gmail.com>
Date:   Wed, 25 Aug 2021 12:18:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <edd2c9c4-774b-6aa2-c871-df8312067f3e@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/21 4:19 AM, Hao Xu wrote:
> 在 2021/8/24 下午8:57, Pavel Begunkov 写道:
>> On 8/23/21 7:36 PM, Hao Xu wrote:
>>> Now we have a lot of task_work users, some are just to complete a req
>>> and generate a cqe. Let's put the work at the head position of the
>>> task_list, so that it can be handled quickly and thus to reduce
>>> avg req latency. an explanatory case:
>>>
>>> origin timeline:
>>>      submit_sqe-->irq-->add completion task_work
>>>      -->run heavy work0~n-->run completion task_work
>>> now timeline:
>>>      submit_sqe-->irq-->add completion task_work
>>>      -->run completion task_work-->run heavy work0~n
>>
>> Might be good. There are not so many hot tw users:
>> poll, queuing linked requests, and the new IRQ. Could be
>> BPF in the future.
> async buffered reads as well, regarding buffered reads is
> hot operation.

Good case as well, forgot about it. Should be not so hot,
as it's only when reads are served out of the buffer cache.


>> So, for the test case I'd think about some heavy-ish
>> submissions linked to your IRQ req. For instance,
>> keeping a large QD of
>>
>> read(IRQ-based) -> linked read_pipe(PAGE_SIZE);
>>
>> and running it for a while, so they get completely
>> out of sync and tw works really mix up. It reads
>> from pipes size<=PAGE_SIZE, so it completes inline,
>> but the copy takes enough of time.
> Thanks Pavel, previously I tried
> direct read-->buffered read(async buffered read)
> didn't see much difference. I'll try the above case
> you offered.

Hmm, considering that pipes have to be refilled, buffered reads
may be a better option. I'd make them all to read the same page,
+ registered buffer + reg file. And then it'd probably depend on
how fast your main SSD is.

mem = malloc_align(4096);
io_uring_register_buffer(mem, 4096);
// preferably another disk/SSD from the fast one
fd2 = open("./file");
// loop
read(fast_ssd, DIRECT, 512) -> read(fd2, fixed_buf, 4096)

Interesting what it'll yield. Probably with buffered reads
it can be experimented to have 2 * PAGE_SIZE or even slightly
more, to increase the heavy part.

btw, I'd look for latency distribution (90%, 99%) as well, it
may get the worst hit. 

>>
>> One thing is that Jens specifically wanted tw's to
>> be in FIFO order, where IRQ based will be in LIFO.
>> I don't think it's a real problem though, the
>> completion handler should be brief enough.In my latest code, the IRQ based tw are also FIFO,
> only LIFO between IRQ based tw and other tw:
> timeline: tw1 tw2 irq1 irq2
> task_list: irq1 irq2 tw1 tw2
>>
-- 
Pavel Begunkov

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC0041D5ED
	for <lists+io-uring@lfdr.de>; Thu, 30 Sep 2021 11:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348727AbhI3JE3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Sep 2021 05:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237229AbhI3JE3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Sep 2021 05:04:29 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CB0C06176A
        for <io-uring@vger.kernel.org>; Thu, 30 Sep 2021 02:02:46 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i23so8847987wrb.2
        for <io-uring@vger.kernel.org>; Thu, 30 Sep 2021 02:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cDgtvPtGqhn9GDtQPDQD7GjBBk8pv0exfjRSSpHvoo8=;
        b=CQsmCnlUxRsiR1HhvmC213ZmFX+INhMKgKCkWbwVaHh/OcW2figJEYgz3TctTWU3Gw
         H/5h8CfneB88mgn7l7rKnie0XBBo2ZnUxT7hDHDwStjqkbc7YTsexvTojslef9S0eXCp
         X1VrDfy+CupzjBmvN+u6FKFVg1bNRqeleq/0NyUWaaEOxeND0sK3k8/gBXXhzM/HkpuX
         DY7CrFtUMmnjfZJvNlIz2WCeslXKInQ966Yu1yHwsCfgu4K9pntbnP9E3k5rwzPkXOb1
         HnavU/ZkhCSm6fz3WTVmeoAei9rQD1NE+Xtr6gRm04yAbjdotyuoht0+0Accdhoao98E
         Qkrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cDgtvPtGqhn9GDtQPDQD7GjBBk8pv0exfjRSSpHvoo8=;
        b=JrSL8VMlmXCkRMbDVsjSnR8AMIyiwJk7k383+DQCOIWn5bCcJjrEUL9+IsZkE+UVTZ
         x9hihOU0Cx1oXf1OZH6Le5XEILzZCPpBHhnMU8q7sZW7ypZKEQf/Cs8aq1KPkSDr5Mv8
         rRECFqSEsSrWogg5kiOkIdl+kD8vP88kH1T7EJcrVTn+WSme6k3JcZjAWGnxYNfRrteK
         EAu1S4Cwj38/+TSu+auzV9ZcnwUcFD5ENVeh6FrWFG2/QulNaIbWHeNsP+ffl9ww0/mf
         ATavZk9QjWvw1A3HJvC2mTBigXvaf5XKFBPTr7bTELJIzMgSlbDCefPs7xQHw4EkrWOG
         xoHg==
X-Gm-Message-State: AOAM533tzW7uUqLobHCajLylrUKRJzyS9gBAZ5IXBayoFqkUdigDAn1z
        TgXFGW2KMm/pukOH3p11aEATw4m8CP0=
X-Google-Smtp-Source: ABdhPJzg9HbbiOK2Qf09jV3F3bcFj5aAFDuBidzI7cvWMuPrLOrjLsnNTDjZRFwhcYjyNc//bNMq5w==
X-Received: by 2002:adf:fb50:: with SMTP id c16mr4868008wrs.120.1632992565461;
        Thu, 30 Sep 2021 02:02:45 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.40])
        by smtp.gmail.com with ESMTPSA id j7sm2796102wrr.27.2021.09.30.02.02.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 02:02:45 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210927061721.180806-1-haoxu@linux.alibaba.com>
 <20210927061721.180806-4-haoxu@linux.alibaba.com>
 <aaabb037-01a6-0775-b5b1-2ff67cbfbe53@gmail.com>
 <5c1ffe9e-23e7-3b50-b48c-6a87c2c7d1ba@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 3/8] io_uring: add a limited tw list for irq completion
 work
Message-ID: <b61b4f03-55af-b8bc-f177-9807803e8b4e@gmail.com>
Date:   Thu, 30 Sep 2021 10:02:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <5c1ffe9e-23e7-3b50-b48c-6a87c2c7d1ba@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/29/21 12:38 PM, Hao Xu wrote:
> 在 2021/9/28 下午7:29, Pavel Begunkov 写道:
[...]
>>>   @@ -2132,12 +2136,16 @@ static void tctx_task_work(struct callback_head *cb)
>>>       while (1) {
>>>           struct io_wq_work_node *node;
>>>   -        if (!tctx->task_list.first && locked)
>>> +        if (!tctx->prior_task_list.first &&
>>> +            !tctx->task_list.first && locked)
>>>               io_submit_flush_completions(ctx);
>>>             spin_lock_irq(&tctx->task_lock);
>>> -        node = tctx->task_list.first;
>>> +        wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
>>> +        node = tctx->prior_task_list.first;
>>
>> I find all this accounting expensive, sure I'll see it for my BPF tests.
> May I ask how do you evaluate the overhead with BPF here?

It's a custom branch and apparently would need some thinking on how
to apply your stuff on top, because of yet another list in [1]. In
short, the case in mind spins inside of tctx_task_work() doing one
request at a time.
I think would be easier if I try it out myself.

[1] https://github.com/isilence/linux/commit/d6285a9817eb26aa52ad54a79584512d7efa82fd

>>
>> How about
>> 1) remove MAX_EMERGENCY_TW_RATIO and all the counters,
>> prior_nr and others.
>>
>> 2) rely solely on list merging
>>
>> So, when it enters an iteration of the loop it finds a set of requests
>> to run, it first executes all priority ones of that set and then the
>> rest (just by the fact that you merged the lists and execute all from
>> them).
>>
>> It solves the problem of total starvation of non-prio requests, e.g.
>> if new completions coming as fast as you complete previous ones. One
>> downside is that prio requests coming while we execute a previous
>> batch will be executed only after a previous batch of non-prio
>> requests, I don't think it's much of a problem but interesting to
>> see numbers.
> hmm, this probably doesn't solve the starvation, since there may be
> a number of priority TWs ahead of non-prio TWs in one iteration, in the
> case of submitting many sqes in one io_submit_sqes. That's why I keep
> just 1/3 priority TWs there.

I don't think it's a problem, they should be fast enough and we have
a forward progress guarantees for non-prio. IMHO that should be enough.


>>
>>
>>>           INIT_WQ_LIST(&tctx->task_list);
>>> +        INIT_WQ_LIST(&tctx->prior_task_list);
>>> +        tctx->nr = tctx->prior_nr = 0;
>>>           if (!node)
>>>               tctx->task_running = false;
>>>           spin_unlock_irq(&tctx->task_lock);
>>> @@ -2166,7 +2174,7 @@ static void tctx_task_work(struct callback_head *cb)
>>>       ctx_flush_and_put(ctx, &locked);
>>>   }
>>>   -static void io_req_task_work_add(struct io_kiocb *req)
>>> +static void io_req_task_work_add(struct io_kiocb *req, bool emergency)
>>
>> It think "priority" instead of "emergency" will be more accurate
>>
>>>   {
>>>       struct task_struct *tsk = req->task;
>>>       struct io_uring_task *tctx = tsk->io_uring;
>>> @@ -2178,7 +2186,13 @@ static void io_req_task_work_add(struct io_kiocb *req)
>>>       WARN_ON_ONCE(!tctx);
>>>         spin_lock_irqsave(&tctx->task_lock, flags);
>>> -    wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
>>> +    if (emergency && tctx->prior_nr * MAX_EMERGENCY_TW_RATIO < tctx->nr) {
>>> +        wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
>>> +        tctx->prior_nr++;
>>> +    } else {
>>> +        wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
>>> +    }
>>> +    tctx->nr++;
>>>       running = tctx->task_running;
>>>       if (!running)
>>>           tctx->task_running = true;
>>
>>
>>
> 

-- 
Pavel Begunkov

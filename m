Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F332141C36F
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 13:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243413AbhI2L2E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 07:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243377AbhI2L2D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 07:28:03 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8593AC06161C
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 04:26:22 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id c73-20020a1c9a4c000000b0030d040bb895so1494573wme.2
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 04:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JlGdu614tmofG32LmoJStKe4JDZdw0kkuvGL0kn6MB8=;
        b=j1RqoYYSJ7arXOGl0+fCW7vFTkv8T+JXxPTOoc4HfBQfotfKiG1klsibwKeZEdxrd5
         UzB5A9BhI+z32HDy9zZyTgLRsfsMzjewkWgWThcr6S4N7/HFVNpSfrwgsO8SRuKa+V/Z
         5u1AZDxRtrYMD1sYbJNmgs4LEYfgYpwxrOG931oVG0y82opBGsnq7IA6J6lcV+rj7jvE
         ogvYTmHJrfAvAkamLeBoO5VkbOpLiQMfyF1GiOjTEBEF8sbSMu0800Hh2Md+Y13vLwaT
         Upl+Pn5exHek2Dk8L6nPebgco59f9E65N5UgNsmtnuIp89LH3g7oIzDNKknaVIaZIlOE
         IIZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JlGdu614tmofG32LmoJStKe4JDZdw0kkuvGL0kn6MB8=;
        b=SYYoBNl4q4T8pXjJXG+lXVoj5149bGAFqtZ2SyI2rFoxqPVcRVoXp65gVNtTG5RSnb
         LmtKhXytCspfmJZZsRVhyKwktEM7E2dzY1s/LYnOiPkE8hsItwF8et0LnD7HSEelP0uS
         vAFcsE0eilzltlOrf5FSpri2xt3ksGBUFWfOEhWyaBRsXK25m6xSbr1EetSnBRdPW/KS
         lVpF4w/EFaF0HwiyAr81+RjQkoKlVKlN0gpCadeHZAbZvzgDdYQNNIj5nPZDymVPExXN
         wxo1vhRmIpTViZoR85KF7xacjJ/rIbBH6gsA4d2GvcgC9ZNLUIAIQBkgoa6yAQiGYYjG
         fAgw==
X-Gm-Message-State: AOAM531gY6PuM28MwowXIH43KXD69i8Ba35Qc+2H7+/c7ihp9e0iUE2J
        qj/5Lif3QPoXFjnZrtkS6h0=
X-Google-Smtp-Source: ABdhPJx9oHqD3J94x1wThfUjHtn965k5xnwnlcybQmpVJqYJvMyqZEdAO5qaPe2Wng1abtSOh+vKyw==
X-Received: by 2002:a05:600c:3784:: with SMTP id o4mr9904886wmr.180.1632914781188;
        Wed, 29 Sep 2021 04:26:21 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.229])
        by smtp.gmail.com with ESMTPSA id d1sm2277863wrr.72.2021.09.29.04.26.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 04:26:20 -0700 (PDT)
Subject: Re: [PATCH 3/8] io_uring: add a limited tw list for irq completion
 work
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210927061721.180806-1-haoxu@linux.alibaba.com>
 <20210927061721.180806-4-haoxu@linux.alibaba.com>
 <aaabb037-01a6-0775-b5b1-2ff67cbfbe53@gmail.com>
 <6d1aa3e2-3dc7-3ff3-abb7-2ddc744f6f18@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <fd5ee546-7749-9019-0809-ea55b7fbf047@gmail.com>
Date:   Wed, 29 Sep 2021 12:25:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <6d1aa3e2-3dc7-3ff3-abb7-2ddc744f6f18@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/28/21 5:55 PM, Hao Xu wrote:
> 在 2021/9/28 下午7:29, Pavel Begunkov 写道:
[...]
>> It solves the problem of total starvation of non-prio requests, e.g.
>> if new completions coming as fast as you complete previous ones. One
>> downside is that prio requests coming while we execute a previous
>> batch will be executed only after a previous batch of non-prio
>> requests, I don't think it's much of a problem but interesting to
>> see numbers.
> Actually this was one of my implementation, I splited it to two lists
> explicitly most because the convience of 8/8 batch the tw in prior list.
> I'll evaluate the overhead tomorrow.

I guess so because it more resembles v1 but without inverting order
of the IRQ sublist.


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

-- 
Pavel Begunkov

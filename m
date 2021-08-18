Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A283F06E2
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 16:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238593AbhHROl4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 10:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239379AbhHROlw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 10:41:52 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC02BC061764
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 07:41:17 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x12so3870153wrr.11
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 07:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bqk9WUlREf6DcH9UX7aCkBu9iFUoc3CwXeGP1rHqct0=;
        b=EUBFKpiSEQYdLguD8IbecKSurqe6joSK7AfHhApdjEGE/7W7TdwVBsQcf6jAUWyCHo
         57vfyDvK8dijaPLwTmgO2+HsEz69JXpDFt7VeF6cbiNL3Mw+KdykJs4z0Ql+J9PNOf2l
         4cHUNUmxwxabIr1cX+/yI/1FIrf6lRuAuvtXLzevLmat2m3cKV8TkY4pruUjTEysbmrX
         yeaQQr5ZIJ2i4UKD+XGOddY0jHhg3WtbrcWB965Kgd/BBrVbNOlly2ZJHSjpbJLJI/gj
         MmYDXagkB9ZKShTyBDmxvZgLUYhqyyyKotCtTBksAWCwl+EWieg82wqRvxRPKwManeZc
         OCrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bqk9WUlREf6DcH9UX7aCkBu9iFUoc3CwXeGP1rHqct0=;
        b=PjFHcHoYu/JQPa+uTiThfkLbGDStBnN8lvzqO+umY1UXvBR773yOzRCEBkhIjRrL4J
         iYQzQ6YpYhoIRge7eN7yDs78SYgK3TSubiyZMtusbnMI2MM+6JlT+KZQW93pfQvDU86E
         mMLBfcgDZVSB3wY5qowXyi+XlJktMu9rs0zBnEPu9U2Ux0YjlmE0eKhRI3Sp2xBMIoiU
         x7jCn1xVa1FR9TAUQs0GX5VQubV7y8GQ1+MkLxHLOdczjEMhzeT9lPlAlLAAFCaHr6Wk
         vCz0dfoqhf+Au7TImLzSduoQn1V4Csdg+nF7DWY0ljhNgLCmUDyCIeh4ZX8RE/sWKzG5
         CI9g==
X-Gm-Message-State: AOAM530kYcp9LaW7kjFpHWMqW/p5iJ4Wfauv3vhv8XlY63qmi9tQHMos
        vQMBZiq3ADfzclsZxljaSHY=
X-Google-Smtp-Source: ABdhPJzTwuw0WXzGFwEczeHL6EleymlMQucnYCn+e7qZvBUB2EvRPWCBXt3LtD/IC9R+fgkgoN7ZjA==
X-Received: by 2002:a5d:674c:: with SMTP id l12mr11119801wrw.112.1629297676283;
        Wed, 18 Aug 2021 07:41:16 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.2])
        by smtp.gmail.com with ESMTPSA id u5sm5888938wrr.94.2021.08.18.07.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 07:41:15 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210818074316.22347-1-haoxu@linux.alibaba.com>
 <20210818074316.22347-3-haoxu@linux.alibaba.com>
 <d23478e6-2d2f-dbc1-91c0-b091b3c6cbc9@gmail.com>
 <9a27608b-bb14-e3e8-09e3-08f182260937@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 2/3] io_uring: fix failed linkchain code logic
Message-ID: <6c8941c1-c56d-3c4e-9d71-e5ed73a9db41@gmail.com>
Date:   Wed, 18 Aug 2021 15:40:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <9a27608b-bb14-e3e8-09e3-08f182260937@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/18/21 1:22 PM, Hao Xu wrote:
> 在 2021/8/18 下午6:20, Pavel Begunkov 写道:
>> On 8/18/21 8:43 AM, Hao Xu wrote:
>>> Given a linkchain like this:
>>> req0(link_flag)-->req1(link_flag)-->...-->reqn(no link_flag)
>>>
[...]
>>>       struct io_submit_link *link = &ctx->submit_state.link;
>>> +    bool is_link = sqe->flags & (IOSQE_IO_LINK | IOSQE_IO_HARDLINK);
>>> +    struct io_kiocb *head;
>>>       int ret;
>>>   +    /*
>>> +     * we don't update link->last until we've done io_req_prep()
>>> +     * since linked timeout uses old link->last
>>> +     */
>>> +    if (link->head)
>>> +        link->last->link = req;
>>> +    else if (is_link)
>>> +        link->head = req;
>>> +    head = link->head;
>>
>> It's a horrorsome amount of overhead. How about to set the fail flag
>> if failed early and actually fail on io_queue_sqe(), as below. It's
>> not tested and a couple more bits added, but hopefully gives the idea.
> I get the idea, it's truely with less change. But why do you think the
> above code bring in more overhead, since anyway we have to link the req
> to the linkchain. I tested it with fio-direct-4k-read-with/without-sqpoll, didn't see performance regression.

Well, it's an exaggeration :) However, we were cutting the overhead,
and there is no atomics or other heavy operations left in the hot path,
just pure number of instructions a request should go through. That's
just to clear the reason why I don't want extras on the path.

For the non-linked path, first it adds 2 ifs in front and removes one
at the end. Then there is is_link, which is most likely to be saved
on stack. And same with @head which I'd expect to be saved on stack.

If we have a way to avoid it, that's great, and it looks we can.

[...]
>>   -    ret = io_req_prep(req, sqe);
>> -    if (unlikely(ret))
>> -        goto fail_req;
>>         /* don't need @sqe from now on */
>>       trace_io_uring_submit_sqe(ctx, req, req->opcode, req->user_data,
>> @@ -6670,8 +6670,10 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>           struct io_kiocb *head = link->head;
>>   
> maybe better to add an if(head & FAIL) here, since we don't need to
> prep_async if we know it will be cancelled.

Such an early fail is marginal enough to not care about performance,
but I agree that the check is needed as io_req_prep_async() won't be
able to handle it. E.g. if it failed to grab a file.

-- 
Pavel Begunkov

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2208F3529EC
	for <lists+io-uring@lfdr.de>; Fri,  2 Apr 2021 12:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhDBKwf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Apr 2021 06:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhDBKwe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Apr 2021 06:52:34 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3FAC0613E6
        for <io-uring@vger.kernel.org>; Fri,  2 Apr 2021 03:52:33 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso2205719wmi.0
        for <io-uring@vger.kernel.org>; Fri, 02 Apr 2021 03:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DGrkQZI4ipy3J7wHaVe5t+hh9ker+LZzfxH8iuAu3YY=;
        b=f+zLH5RbehsWmRH3Vqq9QMjvpREfR2oJUliQXQnVXBhEahPl8GOr7RV6dWLCCRSOBB
         +xdE7gBvI7aGZAT3zsNyCA+C2C8sleha6spUZcFskHSPyN8kIVEsbFWN3dp/zEj8Hdxu
         mLEmUGDcqOHefbRDkOVqOM29mwr68W7pyNGVSCPJtmOkMAMiAzpDJyTKBrLQ0lYjpMx1
         /CQHNl/Wm2vfByBdBk+CdysQ1HGfWMqGIN3xpBkel1/lD/pD5lZE8jEbTIZBoq35kj2j
         JW9ga9GU5dgJW3WuKN7PA0MSPyiuFgC/TGUR5EZHHDdR4iyNJPw7LetjDu8S2vRcgvk5
         A5JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DGrkQZI4ipy3J7wHaVe5t+hh9ker+LZzfxH8iuAu3YY=;
        b=mc1FpgpBumSDESm3Uhsp5K4r6o8NceE3agncGcplb/p4qeoTbZBvkwkemj762OrGKl
         fJNLBzMg16v5Y5pTPNtS2ivIoVGQdhjjqnCtoj0hjybZd81ew++YjET3DqiYFC5lcZPm
         u1j9V7iJAj1rG6/XCOPxP+33h2vghqkvvTBDmDJzxXCRJzpQLmHqppx7gsEtDdUtyP4U
         7GO9yvq6gjtJo482dMnNlSm3eD2jSuXZR0EiNNN5lq8LAltJqQF/LPJPfu2XAJChazLu
         P8SAP8MQf/eRWVaAV8ZHoB2vCiHEdZTevvjsJ6AfdubVqKk4DBOjsvu9OkRVQFMDc7Qd
         Vq2w==
X-Gm-Message-State: AOAM531t3dR+lwbqlbg0tnGBZL/1yasjJrPzK27KGIhQLlEMMLcTsdhI
        AWa5HcuoFvh8cbvYfjDHVeF/lT/F5EL9/A==
X-Google-Smtp-Source: ABdhPJwebCTHPZ7FEFqWMoZuwwOUc/5wGw5YznIJnJIT5jkrZT9VovdD6cLCNDsdXjacAHzbJNfoYQ==
X-Received: by 2002:a05:600c:4f14:: with SMTP id l20mr11969977wmq.71.1617360752175;
        Fri, 02 Apr 2021 03:52:32 -0700 (PDT)
Received: from [192.168.8.131] ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id w11sm1617750wmb.35.2021.04.02.03.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 03:52:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>
References: <a96971ea-2787-149a-a4bd-422fa696a586@kernel.dk>
 <48023516-ac7d-8393-f603-f9bf4faa722f@linux.alibaba.com>
 <a4661870-a839-f949-e5cf-18022d070384@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: don't mark S_ISBLK async work as unbounded
Message-ID: <2c0ce39f-3ccb-3e25-9dcf-d9876c30efb1@gmail.com>
Date:   Fri, 2 Apr 2021 11:48:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a4661870-a839-f949-e5cf-18022d070384@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/04/2021 11:32, Pavel Begunkov wrote:
> On 02/04/2021 09:52, Hao Xu wrote:
>> 在 2021/4/1 下午10:57, Jens Axboe 写道:
>>> S_ISBLK is marked as unbounded work for async preparation, because it
>>> doesn't match S_ISREG. That is incorrect, as any read/write to a block
>>> device is also a bounded operation. Fix it up and ensure that S_ISBLK
>>> isn't marked unbounded.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>> Hi Jens, I saw a (un)bounded work is for a (un)bounded worker to
>> execute. What is the difference between bounded and unbounded?
> 
> Unbounded works are not bounded in execution time, i.e. they may take
> forever to complete. E.g. recv depends on the other end to send something,
> that not necessarily will ever happen.

To elaborate a bit, one example of how it's used: because unbounded may
stay for long, it always spawns a new worker thread for each of them.

If app submits SQEs as below, and send's are not actually sent for execution
but stashed somewhere internally in a list, e.g. waiting for a worker thread
to get free, it would just hang from the userspace perspective.

recv(fd1), recv(fd1), send(fd1), send(fd1)


>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 6d7a1b69712b..a16b7df934d1 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -1213,7 +1213,7 @@ static void io_prep_async_work(struct io_kiocb *req)
>>>       if (req->flags & REQ_F_ISREG) {
>>>           if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
>>>               io_wq_hash_work(&req->work, file_inode(req->file));
>>> -    } else {
>>> +    } else if (!req->file || !S_ISBLK(file_inode(req->file)->i_mode)) {
>>>           if (def->unbound_nonreg_file)
>>>               req->work.flags |= IO_WQ_WORK_UNBOUND;
>>>       }

-- 
Pavel Begunkov

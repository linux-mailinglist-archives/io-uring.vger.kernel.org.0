Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986FD3C34CF
	for <lists+io-uring@lfdr.de>; Sat, 10 Jul 2021 16:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhGJOKg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Jul 2021 10:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhGJOKg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Jul 2021 10:10:36 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD963C0613DD
        for <io-uring@vger.kernel.org>; Sat, 10 Jul 2021 07:07:50 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id r11so11327281wro.9
        for <io-uring@vger.kernel.org>; Sat, 10 Jul 2021 07:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EiYaXmejgid4HbboLR/59d1Djjl5XwEAuIUw1KGTjeo=;
        b=jGM4PlYkaRTZrY3Ld+bVc5YxHCuseDb+c99TY3eQGlRBn1O1zhSRXfTCm8MvPODF5t
         WI2RSp640IA9Q9ro9KnELORkHRmLe3QwZmGhu2lDdw0CqhgrB5CpqwERY55QOd8ss3K7
         KmZ/yHzF7lYIGM+S+Urf7nFuNx4vu1kYqpT433OrK26Ba/hdmpSK3iP+TnNVOVRh0HD/
         MMdgY2LF+7s9RD6n8Xpdoa8v5/tulxC66eHyd3yPv7Wcof9IdwcRch4ESWUcY6/VNe6N
         7pfD9+4V5sM5ljIBBLuf3E9SULZcBYypjwOREzB4jIp1FrO/2yM29/LzkQpC8CcEQYox
         P9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EiYaXmejgid4HbboLR/59d1Djjl5XwEAuIUw1KGTjeo=;
        b=p0+koSvc29Dhsv1/2RteyXAzwbtaftI6DqrlbIyAf5DupjQRs0RuF/teJCrLu+dlDR
         UJmesw1qyoVDUa4jcJAH0KW40+DFLr2thlmVvHYx7wLPPct64SnN26uTmxC4JOFyp+t3
         PmuKHzilIAiUvXuwV6QvBucNkyri1INuRb681e8nH4JlUy/84jUq5uAPIRtVcHYxvuah
         TY8NmYtFWzutTZ5p0VcOC2oCPj5Ssotnxq2xL5ozt41tsuSx2/iuP+dncsoWQj9+q7eK
         k1swRkWpYvocJ7gB3Cs8PAj9/H/rQDZSjzOofXhXmXeQFIRQODy/fc5BZT9hJDPt8wyF
         Z40Q==
X-Gm-Message-State: AOAM532xmeZul2sOWJkYbpzgnYRqnnnm7DrmFLSDjEbvWdFIz/ZHfOVH
        7lyonN8b/VJaol/Mgmzn7GpWdNdDCD0=
X-Google-Smtp-Source: ABdhPJzA+7b+whmNVnJ6jfh90ONA4tKeseMms4E523w9NtHB0pphbRbV/o5GZzAI14jTcxaCle+5DQ==
X-Received: by 2002:a5d:4b44:: with SMTP id w4mr3273381wrs.275.1625926069206;
        Sat, 10 Jul 2021 07:07:49 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.39])
        by smtp.gmail.com with ESMTPSA id x9sm3376108wrm.82.2021.07.10.07.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Jul 2021 07:07:48 -0700 (PDT)
Subject: Re: [PATCH 5.14] io_uring: use right task for exiting checks
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <cb413c715bed0bc9c98b169059ea9c8a2c770715.1625881431.git.asml.silence@gmail.com>
 <7b465849-f046-530f-42a2-8e42d54bdca7@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <211e5eb7-7af0-0e15-5a03-4b1fd4958875@gmail.com>
Date:   Sat, 10 Jul 2021 15:07:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <7b465849-f046-530f-42a2-8e42d54bdca7@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/10/21 2:40 PM, Jens Axboe wrote:
> On Fri, Jul 9, 2021 at 7:46 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> When we use delayed_work for fallback execution of requests, current
>> will be not of the submitter task, and so checks in io_req_task_submit()
>> may not behave as expected. Currently, it leaves inline completions not
>> flushed, so making io_ring_exit_work() to hang. Use the submitter task
>> for all those checks.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io_uring.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 7167c61c6d1b..770fdcd7d3e4 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2016,7 +2016,7 @@ static void io_req_task_submit(struct io_kiocb *req)
>>
>>         /* ctx stays valid until unlock, even if we drop all ours ctx->refs */
>>         mutex_lock(&ctx->uring_lock);
>> -       if (!(current->flags & PF_EXITING) && !current->in_execve)
>> +       if (!(req->task->flags & PF_EXITING) && !req->task->in_execve)
>>                 __io_queue_sqe(req);
>>         else
>>                 io_req_complete_failed(req, -EFAULT);
> 
> I don't think that ->in_execve check is useful anymore now that we don't
> have weak references to the files table, so it should probably just go
> away.

Had such a thought but from the premise that on exec we wait / cancel
all requests. But I'd rather to leave it to a separate commit for-next,
don't you think so?

-- 
Pavel Begunkov

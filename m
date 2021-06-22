Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B963B0EFC
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 22:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhFVUyA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 16:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVUx7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 16:53:59 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85184C061574;
        Tue, 22 Jun 2021 13:51:43 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id m18so179263wrv.2;
        Tue, 22 Jun 2021 13:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DgOLw28e+RF+tP0cv3IOtjcn7zPRzgkIPJom+SKiGLI=;
        b=PB/2RHjRbZ0ATGIzOOKkLzEQqvqfI6ZXKQRR6ucewyFed+jCitpouOO6XZhaMUf18g
         IlCXJs64GBPoOp1Ov1gtGMQw+rkxIhGsiOb5WVy7wYJBKtDgGu6bl2TGFBN0cC3m0duj
         cZfIDTRidRFsXJnSQjHCOcZIeGLY0QGSFQAP3mjwi0ZbTBRKaQX7WYa3VV9938vmfd+T
         3cfpu8yHFiQlmlYUvul+JJOX4ush4Q/PGqu3qrK5Oqk7cHOWul09A3IyhgT7rsUmx/JO
         qZVltQVxGY1AdnNUkyQYReeYel9W6/zpUGQiGDX+KeJ0fz6xIjGGIyZDvtwp7d9yDSPZ
         dqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DgOLw28e+RF+tP0cv3IOtjcn7zPRzgkIPJom+SKiGLI=;
        b=nixCZhSUn+2D+jaIoKhAKsDurNdf1zOd39qY6CHG6XEypKQO1h8mgJ+I9Q1+hhX+n8
         8GVslz18QNsO2LoKWB9apDbMfPPz9fb9uElV/W0YVFWLv6iwUrcQBAG2PAYHajvX8KdT
         CcvrS2yRGzAa+Wqj3CJs01EeTD3Xu3IKSp1tLR2QXhzsZsZzSCkEZh8Cb1M85OmgM5yG
         xNFZodDGzN+KRoM6r9DOsCIqjFgk28UglgexHVu5TpvdgEQGniRDpNOkxc/q7ydWDhNA
         1Zi1OcP/eQPFf2OspMP8vP2yrrYPYkk8pgJqfgrW24tWEEB05yTCFHbpN3/y8cY4PH7y
         jPlg==
X-Gm-Message-State: AOAM533vdXbXhTWNPnFrQU00S1JKwOCWmuuZtm8sShZOE7F6Tla6eBJS
        RzCOh/EyILiQCk4r+phoIcPjfSxeQSuT2n37
X-Google-Smtp-Source: ABdhPJxhpytYem6NUvri3WoqqTfba47IEEXW9a6EEzKXzPyGwJfwXaKP0jj8O8OJCkkphXe3bOELzA==
X-Received: by 2002:a5d:4904:: with SMTP id x4mr7075961wrq.202.1624395102003;
        Tue, 22 Jun 2021 13:51:42 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id e15sm461965wrm.60.2021.06.22.13.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 13:51:41 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <9e8441419bb1b8f3c3fcc607b2713efecdef2136.1624364038.git.olivier@trillion01.com>
 <678deb93-c4a5-5a14-9687-9e44f0f00b5a@gmail.com>
 <7c47078a-9e2d-badf-a47d-1ca78e1a3253@gmail.com>
 <32495917a028e9c70b75357029a87ca593378dde.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v4] io_uring: reduce latency by reissueing the operation
Message-ID: <1a6a8eba-96e3-0afb-0357-3ac3b08cba36@gmail.com>
Date:   Tue, 22 Jun 2021 21:51:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <32495917a028e9c70b75357029a87ca593378dde.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 8:05 PM, Olivier Langlois wrote:
> On Tue, 2021-06-22 at 19:01 +0100, Pavel Begunkov wrote:
>> On 6/22/21 6:54 PM, Pavel Begunkov wrote:
>>> On 6/22/21 1:17 PM, Olivier Langlois wrote:
>>>>
>>>
>>>>  static bool __io_poll_remove_one(struct io_kiocb *req,
>>>> @@ -6437,6 +6445,7 @@ static void __io_queue_sqe(struct io_kiocb
>>>> *req)
>>>>         struct io_kiocb *linked_timeout =
>>>> io_prep_linked_timeout(req);
>>>>         int ret;
>>>>  
>>>> +issue_sqe:
>>>>         ret = io_issue_sqe(req,
>>>> IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
>>>>  
>>>>         /*
>>>> @@ -6456,12 +6465,16 @@ static void __io_queue_sqe(struct
>>>> io_kiocb *req)
>>>>                         io_put_req(req);
>>>>                 }
>>>>         } else if (ret == -EAGAIN && !(req->flags &
>>>> REQ_F_NOWAIT)) {
>>>> -               if (!io_arm_poll_handler(req)) {
>>>> +               switch (io_arm_poll_handler(req)) {
>>>> +               case IO_APOLL_READY:
>>>> +                       goto issue_sqe;
>>>> +               case IO_APOLL_ABORTED:
>>>>                         /*
>>>>                          * Queued up for async execution, worker
>>>> will release
>>>>                          * submit reference when the iocb is
>>>> actually submitted.
>>>>                          */
>>>>                         io_queue_async_work(req);
>>>> +                       break;
>>>
>>> Hmm, why there is a new break here? It will miscount
>>> @linked_timeout
>>> if you do that. Every io_prep_linked_timeout() should be matched
>>> with
>>> io_queue_linked_timeout().
>>
>> Never mind, I said some nonsense and apparently need some coffee
> 
> but this is a pertinant question, imho. I guess that you could get away

It appeared to me that it doesn't go down to the end of the function
but returns or so, that's the nonsense part.

> without it since it is the last case of the switch statement... I am
> not sure what kernel coding standard says about that.

breaks are preferable, and falling through should be explicitly
marked with fallthrough;
 
> However, I can tell you that there was also a break statement at the
> end of the case for IO_APOLL_READY and checkpatch.pl did complain about
> it saying that it was useless since it was following a goto statement.
> Therefore, I did remove that one.
> 
> checkpatch.pl did remain silent about the other remaining break. Hence
> this is why I left it there.

-- 
Pavel Begunkov

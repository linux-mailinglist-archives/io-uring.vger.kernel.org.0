Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317F1400EB2
	for <lists+io-uring@lfdr.de>; Sun,  5 Sep 2021 10:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbhIEI25 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Sep 2021 04:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhIEI2z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Sep 2021 04:28:55 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43282C061575
        for <io-uring@vger.kernel.org>; Sun,  5 Sep 2021 01:27:52 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l7-20020a1c2507000000b002e6be5d86b3so2520786wml.3
        for <io-uring@vger.kernel.org>; Sun, 05 Sep 2021 01:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Mh84BaYwQptQ7jWi03MJFpnDdO+nV9YadxwrPBsOog0=;
        b=nreOEd9rxt/cJC+lybv2ndG6hMCYaQBjJwFZvAb2cJdUV5friIKonBb9IlErtswiTl
         uMVqFugZvY4FIjpVzQHZEeNcovm3CovYy2wRWsie3KtEYby2NcNhm2rCxFCRr6jqQhBq
         GCRaCQid1ByieMicZyr5vLdy428awMIL1olIl5mbPsaeaGe1VVq73zL7v6q0fuV6bRCw
         5KCy9iaccQll4Z62Behz4DkBe4WIEO+shsbLawefwQzR3wz2OqFg9SHhvJzp0U/VHgFm
         3kXIXUSVsjxkHmrk99xbR3b6ypIcabEJQ888JOk1F1JxHDk203ym4TZW0mbKlLk3tUj5
         ZLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mh84BaYwQptQ7jWi03MJFpnDdO+nV9YadxwrPBsOog0=;
        b=JKICrW9IHPS9Dw8AgsrHkELHFgkJXNgKUCjEO89tD3lmnBnYBWgcbqyCD1b3XZSOLk
         tgYJ38LT++InxysNjmH2UPLjhhmdkKxe/Hccz9UNzZT5hZ3MJt9S2PHPf+J1TV/z34Vd
         rlN9c7YmpzoUlK2Rhr493j5s4OAflMenxT2RvFMKQNhbZGRyd4YFzTcz+5HaNPrXXjcn
         jNMhm8+WhT+efaHxkdI33gS9PJZkVJFwaK5zLVMS/qdqVV/wTAMlvq0x+8NNn1hlTds/
         KnJqf3vBbu9acd8PztCF0jgLX05RJa3IWkhb6j+PofgldEDHAl79Jg70aL9CjdcGGhDB
         F2Yw==
X-Gm-Message-State: AOAM533Wjw2jcF5EJXbyQVpse0a+KUYvzxoZQvRyT76LnT3logfg36W2
        +el0kQ6ALALDI3mstumBKOvs9VaW+yU=
X-Google-Smtp-Source: ABdhPJwtbfjPgJnT07+wejy0eF5scxyOXqTUJOo+5HyCcC3ZSbXuNyzADgPc6FwH9D8h7rl7yCznKQ==
X-Received: by 2002:a1c:1bc7:: with SMTP id b190mr6405085wmb.57.1630830470905;
        Sun, 05 Sep 2021 01:27:50 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.4])
        by smtp.gmail.com with ESMTPSA id w9sm4359947wrs.7.2021.09.05.01.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Sep 2021 01:27:50 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-7-haoxu@linux.alibaba.com>
 <3cdcd28b-4723-32f8-5a0f-59fab8f4af27@gmail.com>
 <1542ac87-c518-3aa4-55ca-061f2761a1db@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 6/6] io_uring: enable multishot mode for accept
Message-ID: <26a08d43-c3bf-fa24-3830-dd3f8e626f80@gmail.com>
Date:   Sun, 5 Sep 2021 09:27:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1542ac87-c518-3aa4-55ca-061f2761a1db@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/5/21 7:25 AM, Hao Xu wrote:
> 在 2021/9/5 上午6:43, Pavel Begunkov 写道:
>> On 9/3/21 12:00 PM, Hao Xu wrote:
>>> Update io_accept_prep() to enable multishot mode for accept operation.
>>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   fs/io_uring.c | 14 ++++++++++++--
>>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index eb81d37dce78..34612646ae3c 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -4861,6 +4861,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>>   static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>   {
>>>       struct io_accept *accept = &req->accept;
>>> +    bool is_multishot;
>>>         if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>           return -EINVAL;
>>> @@ -4872,14 +4873,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>       accept->flags = READ_ONCE(sqe->accept_flags);
>>>       accept->nofile = rlimit(RLIMIT_NOFILE);
>>>   +    is_multishot = accept->flags & IORING_ACCEPT_MULTISHOT;
>>> +    if (is_multishot && (req->flags & REQ_F_FORCE_ASYNC))
>>> +        return -EINVAL;
>>
>> Why REQ_F_FORCE_ASYNC is not allowed? It doesn't sound like there
>> should be any problem, would just eventually go looping
>> poll_wait + tw
> Hmm..The arm_poll facility is only on the io_submit_sqes() path. If
> FORCE_ASYNC is set, the req goes to io_wq_submit_work-->io_issue_sqe.
> Moreover, I guess theoretically poll based retry and async iowq are
> two ways for users to handle their sqes, it may not be sane to go to
> poll based retry path if a user already forcely choose iowq as their
> prefer way.

The flag is just a hint, there are already plenty of ways to trick
requests into tw. Forbidding it would be inconsistent.


>>> +
>>>       accept->file_slot = READ_ONCE(sqe->file_index);
>>>       if (accept->file_slot && ((req->open.how.flags & O_CLOEXEC) ||
>>> -                  (accept->flags & SOCK_CLOEXEC)))
>>> +                  (accept->flags & SOCK_CLOEXEC) || is_multishot))
>>>           return -EINVAL;
>>> -    if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
>>> +    if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK | IORING_ACCEPT_MULTISHOT))
>>>           return -EINVAL;
>>>       if (SOCK_NONBLOCK != O_NONBLOCK && (accept->flags & SOCK_NONBLOCK))
>>>           accept->flags = (accept->flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
>>> +    if (is_multishot) {
>>> +        req->flags |= REQ_F_APOLL_MULTISHOT;
>>> +        accept->flags &= ~IORING_ACCEPT_MULTISHOT;
>>> +    }
>>> +
>>>       return 0;
>>>   }
>>>  
>>
> 

-- 
Pavel Begunkov

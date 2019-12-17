Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5ED1232CE
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 17:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfLQQpL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 11:45:11 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:44878 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727764AbfLQQpL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 11:45:11 -0500
Received: by mail-io1-f67.google.com with SMTP id b10so11691090iof.11
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 08:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dQiPKpP3S9FIwfUkR7hFMyPyqAo/ESDrk4hUc6DOE7g=;
        b=xDp+6jX5AJTxGGaCa8cyfR1qjybto1VdGwYSW1BF03PyL3fVXXhzWactXUed7gFVcZ
         q9tdqfTSmCzDQMCvYZ360dOT4HMnKYWCS9pUyXaxAiDIRnu6TTUeLqCCIGezGa+QCk/5
         D5GqUFmoOA/Mie4p3OLbbua6y0CJOXlZOLxkc3OwUCoP/J/MeED70CQ7CPPni3fS+nx5
         aC96rGDjSTCde5jDveAXSdLUp4OlR21NJ3reMmyeLtweNYBbb+cp7YYsqWLgEjXj6onz
         fb2/+j8Z0Rl59zlGFdyLSofDb9Pz/TA1F1o8f3KhfavCYXiaSdpqefM7DS8FLi30kYMT
         tnqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dQiPKpP3S9FIwfUkR7hFMyPyqAo/ESDrk4hUc6DOE7g=;
        b=qf9D+YOUHx7SDQi5lm0Lmvxl4lJ/L1IM36JTJfgmOyS3VXbYX8QWUO5EOuyHNEtDpw
         ShI/letxvSTJetmy3WlNpdQfMl8klf+1fX7k86yDiUQWLGLZUj7wH4kPupib2UcauW7Z
         c3Qfdi25Ava3KWi0Bx2Y9+9IGQ01v1QbqePOLemuJRhevnP1N9PTKHIXxraONaUX0Mto
         A4Onuezfu5XPGecttIGtxTwW7xxEZ5IVw8Q0YYqhqzlS7IM912SQQheER5JctUQ7/1fq
         sZRZ33eMALamHMzfz2sgd17S0/UlrektXsQRampLaiohdnpmft1TnLD7sxRWuLUyojoI
         cqgA==
X-Gm-Message-State: APjAAAW/p9lEQBrtS8I9VFwKMYjro33nNqXtyQjqDDgkLohY3WUvJGYB
        od5YTaRJsJJQyPb9Jj/U/6l4pQ==
X-Google-Smtp-Source: APXvYqy/XWydDF5JeQ8nKzBD8UR6uXeZScK+GXUgfSF9B0VAa4xtLghKAa4XUhfFdzOQtqzzr1JcSw==
X-Received: by 2002:a02:c646:: with SMTP id k6mr18185938jan.34.1576601109939;
        Tue, 17 Dec 2019 08:45:09 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm4995482iod.61.2019.12.17.08.45.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 08:45:09 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: move *queue_link_head() from common path
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576538176.git.asml.silence@gmail.com>
 <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
 <17f7900c-385f-0dfa-11bf-af99d080f894@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <76917820-052d-9597-133d-424fee3edade@kernel.dk>
Date:   Tue, 17 Dec 2019 09:45:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <17f7900c-385f-0dfa-11bf-af99d080f894@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/16/19 4:38 PM, Pavel Begunkov wrote:
> On 17/12/2019 02:22, Pavel Begunkov wrote:
>> Move io_queue_link_head() to links handling code in io_submit_sqe(),
>> so it wouldn't need extra checks and would have better data locality.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io_uring.c | 32 ++++++++++++++------------------
>>  1 file changed, 14 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index bac9e711e38d..a880ed1409cb 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -3373,13 +3373,15 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>>  			  struct io_kiocb **link)
>>  {
>>  	struct io_ring_ctx *ctx = req->ctx;
>> +	unsigned int sqe_flags;
>>  	int ret;
>>  
>> +	sqe_flags = READ_ONCE(req->sqe->flags);
>>  	req->user_data = READ_ONCE(req->sqe->user_data);
>>  	trace_io_uring_submit_sqe(ctx, req->user_data, true, req->in_async);
>>  
>>  	/* enforce forwards compatibility on users */
>> -	if (unlikely(req->sqe->flags & ~SQE_VALID_FLAGS)) {
>> +	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
>>  		ret = -EINVAL;
>>  		goto err_req;
>>  	}
>> @@ -3402,10 +3404,10 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>>  	if (*link) {
>>  		struct io_kiocb *head = *link;
>>  
>> -		if (req->sqe->flags & IOSQE_IO_DRAIN)
>> +		if (sqe_flags & IOSQE_IO_DRAIN)
>>  			head->flags |= REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
>>  
>> -		if (req->sqe->flags & IOSQE_IO_HARDLINK)
>> +		if (sqe_flags & IOSQE_IO_HARDLINK)
>>  			req->flags |= REQ_F_HARDLINK;
>>  
>>  		if (io_alloc_async_ctx(req)) {
>> @@ -3421,9 +3423,15 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>>  		}
>>  		trace_io_uring_link(ctx, req, head);
>>  		list_add_tail(&req->link_list, &head->link_list);
>> -	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
>> +
>> +		/* last request of a link, enqueue the link */
>> +		if (!(sqe_flags & IOSQE_IO_LINK)) {
> 
> This looks suspicious (as well as in the current revision). Returning back
> to my questions a few days ago can sqe->flags have IOSQE_IO_HARDLINK, but not
> IOSQE_IO_LINK? I don't find any check.
> 
> In other words, should it be as follows?
> !(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))

Yeah, I think that should check for both. I'm fine with either approach
in general:

- IOSQE_IO_HARDLINK must have IOSQE_IO_LINK set

or

- IOSQE_IO_HARDLINK implies IOSQE_IO_LINK

Seems like the former is easier to verify in terms of functionality,
since we can rest easy if we check this early and -EINVAL if that isn't
the case.

What do you think?

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D58612340F
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 19:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfLQSBV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 13:01:21 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:44885 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbfLQSBV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 13:01:21 -0500
Received: by mail-io1-f65.google.com with SMTP id b10so11991891iof.11
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 10:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=uGsOqnUo6JdssnVcWsXaoer452mQ2VyC4E+orTj0tPU=;
        b=P/xz0Kxm9DCGVzJZCodObxZFaIjKhuO7WZf4EuxvlLwlYSeZ/3skdGJlB9ZDXuIKyy
         ih46Vavia00cJH0Nny4tma0Bj9mMFvZ0hqzKsYFI+aWnBc4JzdFljQOwAICDYH+ywBEq
         CfB4neA4ItJbuyqHye24xtQlTuTSIPdAEWH94Pj10zP/mpqRdZqNqHTGYzXA7ntuImOe
         UnVS9PeAJqC+I+eNwd70tWMP9Wle9GfSB+S9WKFW47MKygzOPqoYrfEZeyIgKJtaUrtl
         rfM7ANGbku1CkySHQeUyOlLffAXaNj1oGuPPQPGMSuAZr5XS+2daW+GHtBzlH8j76OyN
         OOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uGsOqnUo6JdssnVcWsXaoer452mQ2VyC4E+orTj0tPU=;
        b=GFgyyQyXsmyxkBbedCxFiu2FyahzK8OvPQC7N3WODiuyQxNenw+/C5XuLVFyDBdbVY
         8RRWDf+BJT6OPrzyJ9zT7jAM2toCY5+FmuFK9iWKfzxJ4Jg7Y+zSTa9ZZN1sGfTrDZwh
         8pVUKEs2XePFSBwgStzreUuQ5xM9wqyRYiHfdRKH+C2WpF/pTaqz8KHA5Fhr04qnJvDk
         q5+BQfoVPUOUxsGujtLxWYTwDjekUkhPCZYKl5RJCcqT4DgIXIcPa+u2hax59mnKamqt
         yUFuXwggd5AUOh+DShfClCzPEWo8sIxWeryt4jbrs3yyBayDCoex2KlbElFKuVegJuW1
         SyGw==
X-Gm-Message-State: APjAAAUiCz2vDAD6BUlkAn96HmajHN25AyEL/grQ5oR84fPhgzg6foWc
        VUQwn67MQq6puaAT2ToarSn2hQ==
X-Google-Smtp-Source: APXvYqzhl4p5P7Av3q4saBACrZiB4KgHat9V/dIkKE8qUwOTme4LjfXR+58O/mijh9KSgwASAtHSZA==
X-Received: by 2002:a02:8587:: with SMTP id d7mr18291845jai.39.1576605679832;
        Tue, 17 Dec 2019 10:01:19 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i83sm7009347ilf.65.2019.12.17.10.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 10:01:19 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: move *queue_link_head() from common path
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576538176.git.asml.silence@gmail.com>
 <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
 <17f7900c-385f-0dfa-11bf-af99d080f894@gmail.com>
 <76917820-052d-9597-133d-424fee3edade@kernel.dk>
 <5d4af2f6-26a2-b241-5131-3a0155cbbf22@kernel.dk>
 <3b5100a7-2922-a9f2-e4e2-76252318959d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7edd6631-326c-ac9c-7c5b-fa4bab3932d3@kernel.dk>
Date:   Tue, 17 Dec 2019 11:01:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3b5100a7-2922-a9f2-e4e2-76252318959d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/17/19 10:52 AM, Pavel Begunkov wrote:
> On 17/12/2019 20:37, Jens Axboe wrote:
>> On 12/17/19 9:45 AM, Jens Axboe wrote:
>>> On 12/16/19 4:38 PM, Pavel Begunkov wrote:
>>>> On 17/12/2019 02:22, Pavel Begunkov wrote:
>>>>> Move io_queue_link_head() to links handling code in io_submit_sqe(),
>>>>> so it wouldn't need extra checks and would have better data locality.
>>>>>
>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>> ---
>>>>>  fs/io_uring.c | 32 ++++++++++++++------------------
>>>>>  1 file changed, 14 insertions(+), 18 deletions(-)
>>>>>
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index bac9e711e38d..a880ed1409cb 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -3373,13 +3373,15 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>>>>>  			  struct io_kiocb **link)
>>>>>  {
>>>>>  	struct io_ring_ctx *ctx = req->ctx;
>>>>> +	unsigned int sqe_flags;
>>>>>  	int ret;
>>>>>  
>>>>> +	sqe_flags = READ_ONCE(req->sqe->flags);
>>>>>  	req->user_data = READ_ONCE(req->sqe->user_data);
>>>>>  	trace_io_uring_submit_sqe(ctx, req->user_data, true, req->in_async);
>>>>>  
>>>>>  	/* enforce forwards compatibility on users */
>>>>> -	if (unlikely(req->sqe->flags & ~SQE_VALID_FLAGS)) {
>>>>> +	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
>>>>>  		ret = -EINVAL;
>>>>>  		goto err_req;
>>>>>  	}
>>>>> @@ -3402,10 +3404,10 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>>>>>  	if (*link) {
>>>>>  		struct io_kiocb *head = *link;
>>>>>  
>>>>> -		if (req->sqe->flags & IOSQE_IO_DRAIN)
>>>>> +		if (sqe_flags & IOSQE_IO_DRAIN)
>>>>>  			head->flags |= REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
>>>>>  
>>>>> -		if (req->sqe->flags & IOSQE_IO_HARDLINK)
>>>>> +		if (sqe_flags & IOSQE_IO_HARDLINK)
>>>>>  			req->flags |= REQ_F_HARDLINK;
>>>>>  
>>>>>  		if (io_alloc_async_ctx(req)) {
>>>>> @@ -3421,9 +3423,15 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>>>>>  		}
>>>>>  		trace_io_uring_link(ctx, req, head);
>>>>>  		list_add_tail(&req->link_list, &head->link_list);
>>>>> -	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
>>>>> +
>>>>> +		/* last request of a link, enqueue the link */
>>>>> +		if (!(sqe_flags & IOSQE_IO_LINK)) {
>>>>
>>>> This looks suspicious (as well as in the current revision). Returning back
>>>> to my questions a few days ago can sqe->flags have IOSQE_IO_HARDLINK, but not
>>>> IOSQE_IO_LINK? I don't find any check.
>>>>
>>>> In other words, should it be as follows?
>>>> !(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))
>>>
>>> Yeah, I think that should check for both. I'm fine with either approach
>>> in general:
>>>
>>> - IOSQE_IO_HARDLINK must have IOSQE_IO_LINK set
>>>
>>> or
>>>
>>> - IOSQE_IO_HARDLINK implies IOSQE_IO_LINK
>>>
>>> Seems like the former is easier to verify in terms of functionality,
>>> since we can rest easy if we check this early and -EINVAL if that isn't
>>> the case.
>>>
>>> What do you think?
>>
>> If you agree, want to send in a patch for that for 5.5? Then I can respin
>> for-5.6/io_uring on top of that, and we can apply your cleanups there.
>>
> Yes, that's the idea. Already got a patch, if you haven't done it yet.

I haven't.

> Just was thinking, whether to add a check for not setting both flags
> at the same moment in the "imply" case. Would give us 1 state in 2 bits
> for future use.

Not sure I follow what you're saying here, can you elaborate?


-- 
Jens Axboe


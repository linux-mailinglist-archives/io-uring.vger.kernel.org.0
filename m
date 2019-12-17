Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E88DA123469
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 19:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbfLQSH2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 13:07:28 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:37263 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfLQSH2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 13:07:28 -0500
Received: by mail-io1-f68.google.com with SMTP id k24so10395502ioc.4
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 10:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qyoA0p/cZ5QAiEN7t6DwV8lmqImYWvN2VUSqAU0A+/U=;
        b=Zynoa/McWobuOowi9DpZyXx0B7lhdbktfpbvGiuInVR6+lBXi9IxpqbNQm4bTzcDhy
         lGL0uKOAVd7S9CJdgdDjYzQoXQFxFHKPNK3vStjTHTBOOVbXwRf+gjj5INe33MUI2nVf
         GeRVezYIte3fAykbkwfY0M3c9ZH2wsJzUquyDu5cFfFi2gWm0+ipblnVGyqqyoFYIZKh
         twrZQ+x7r3rITs/Ce8bUnvQz6LKeQY6M114Ym/temqNHztLjLBa0YicfnF57aX86vjqP
         9SGkZc2KJHw9vuPo8wMK0knhVP//so2aNoZN+T5ETFMstSnT2w+2iJCaD9/UsjJ302gO
         wo5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qyoA0p/cZ5QAiEN7t6DwV8lmqImYWvN2VUSqAU0A+/U=;
        b=ph5InyBkG9swsZjiEenmWS3EqGbMUIloevcKjnJaaBRAgO0df0Ah8+Owx3heAbFvMd
         6+Ky8ZNb6Sy1zftOxCccZjFpmJtBffSKOBQjAmzK9X1ag/kC7dPXgjs79xPV+S3B5eFd
         SB85fbhiTB0TrVhNdD54AyNsNLPm3lj6C4u1i7z4+ryYAP9d2CaDM3awjEr+F1Knq9lS
         u0JFOgkW2SR4Rilibx3tBeTvLVS7l/q/FD9KSa6eP+MTXjFxyEzdGmg+2HD0G9kifT+H
         MQRMC4pnDGIw2eayXGy28TjFFaMTEVTdPRDZqKxOlIKppTfLagGvyaE3VLn+WfpFfL8r
         LGGg==
X-Gm-Message-State: APjAAAWz4+sAF3SsSMSdWthwL0be45/zBGID7CvbWl25yqN6i0T9O7aC
        kSzeYsjqJV5L0IjOZ9GBhcWpxw==
X-Google-Smtp-Source: APXvYqwKQRwsnmavUm1FPr8hk7Iu+LljKJ1ko86TRIkIY6lDDES6qpYsq5Cyxbdhr9ySVkWRoBVHcw==
X-Received: by 2002:a5e:8b03:: with SMTP id g3mr4702472iok.279.1576606046945;
        Tue, 17 Dec 2019 10:07:26 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y75sm6991209ill.87.2019.12.17.10.07.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 10:07:26 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: move *queue_link_head() from common path
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576538176.git.asml.silence@gmail.com>
 <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
 <17f7900c-385f-0dfa-11bf-af99d080f894@gmail.com>
 <76917820-052d-9597-133d-424fee3edade@kernel.dk>
 <5d4af2f6-26a2-b241-5131-3a0155cbbf22@kernel.dk>
 <3b5100a7-2922-a9f2-e4e2-76252318959d@gmail.com>
 <7edd6631-326c-ac9c-7c5b-fa4bab3932d3@kernel.dk>
 <4f3f9b65-6e9f-b650-65b8-1e0844321697@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <69cb864c-9fa9-2d5a-7b75-f72633cb32f5@kernel.dk>
Date:   Tue, 17 Dec 2019 11:07:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4f3f9b65-6e9f-b650-65b8-1e0844321697@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/17/19 11:05 AM, Pavel Begunkov wrote:
> On 17/12/2019 21:01, Jens Axboe wrote:
>> On 12/17/19 10:52 AM, Pavel Begunkov wrote:
>>> On 17/12/2019 20:37, Jens Axboe wrote:
>>>> On 12/17/19 9:45 AM, Jens Axboe wrote:
>>>>> On 12/16/19 4:38 PM, Pavel Begunkov wrote:
>>>>>> On 17/12/2019 02:22, Pavel Begunkov wrote:
>>>>>>> Move io_queue_link_head() to links handling code in io_submit_sqe(),
>>>>>>> so it wouldn't need extra checks and would have better data locality.
>>>>>>>
>>>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>>>> ---
>>>>>>>  fs/io_uring.c | 32 ++++++++++++++------------------
>>>>>>>  1 file changed, 14 insertions(+), 18 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>>> index bac9e711e38d..a880ed1409cb 100644
>>>>>>> --- a/fs/io_uring.c
>>>>>>> +++ b/fs/io_uring.c
>>>>>>> @@ -3373,13 +3373,15 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>>>>>>>  			  struct io_kiocb **link)
>>>>>>>  {
>>>>>>>  	struct io_ring_ctx *ctx = req->ctx;
>>>>>>> +	unsigned int sqe_flags;
>>>>>>>  	int ret;
>>>>>>>  
>>>>>>> +	sqe_flags = READ_ONCE(req->sqe->flags);
>>>>>>>  	req->user_data = READ_ONCE(req->sqe->user_data);
>>>>>>>  	trace_io_uring_submit_sqe(ctx, req->user_data, true, req->in_async);
>>>>>>>  
>>>>>>>  	/* enforce forwards compatibility on users */
>>>>>>> -	if (unlikely(req->sqe->flags & ~SQE_VALID_FLAGS)) {
>>>>>>> +	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
>>>>>>>  		ret = -EINVAL;
>>>>>>>  		goto err_req;
>>>>>>>  	}
>>>>>>> @@ -3402,10 +3404,10 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>>>>>>>  	if (*link) {
>>>>>>>  		struct io_kiocb *head = *link;
>>>>>>>  
>>>>>>> -		if (req->sqe->flags & IOSQE_IO_DRAIN)
>>>>>>> +		if (sqe_flags & IOSQE_IO_DRAIN)
>>>>>>>  			head->flags |= REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
>>>>>>>  
>>>>>>> -		if (req->sqe->flags & IOSQE_IO_HARDLINK)
>>>>>>> +		if (sqe_flags & IOSQE_IO_HARDLINK)
>>>>>>>  			req->flags |= REQ_F_HARDLINK;
>>>>>>>  
>>>>>>>  		if (io_alloc_async_ctx(req)) {
>>>>>>> @@ -3421,9 +3423,15 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>>>>>>>  		}
>>>>>>>  		trace_io_uring_link(ctx, req, head);
>>>>>>>  		list_add_tail(&req->link_list, &head->link_list);
>>>>>>> -	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
>>>>>>> +
>>>>>>> +		/* last request of a link, enqueue the link */
>>>>>>> +		if (!(sqe_flags & IOSQE_IO_LINK)) {
>>>>>>
>>>>>> This looks suspicious (as well as in the current revision). Returning back
>>>>>> to my questions a few days ago can sqe->flags have IOSQE_IO_HARDLINK, but not
>>>>>> IOSQE_IO_LINK? I don't find any check.
>>>>>>
>>>>>> In other words, should it be as follows?
>>>>>> !(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))
>>>>>
>>>>> Yeah, I think that should check for both. I'm fine with either approach
>>>>> in general:
>>>>>
>>>>> - IOSQE_IO_HARDLINK must have IOSQE_IO_LINK set
>>>>>
>>>>> or
>>>>>
>>>>> - IOSQE_IO_HARDLINK implies IOSQE_IO_LINK
>>>>>
>>>>> Seems like the former is easier to verify in terms of functionality,
>>>>> since we can rest easy if we check this early and -EINVAL if that isn't
>>>>> the case.
>>>>>
>>>>> What do you think?
>>>>
>>>> If you agree, want to send in a patch for that for 5.5? Then I can respin
>>>> for-5.6/io_uring on top of that, and we can apply your cleanups there.
>>>>
>>> Yes, that's the idea. Already got a patch, if you haven't done it yet.
>>
>> I haven't.
>>
>>> Just was thinking, whether to add a check for not setting both flags
>>> at the same moment in the "imply" case. Would give us 1 state in 2 bits
>>> for future use.
>>
>> Not sure I follow what you're saying here, can you elaborate?
>>
> 
> Sure
> 
> #define IOSQE_IO_LINK		(1U << 2)	/* links next sqe */
> #define IOSQE_IO_HARDLINK	(1U << 3)	/* like LINK, but stronger */
> 
> That's 2 consequent bits, so 4 states:
> 0,0 -> not a link
> 1,0 -> common link
> 0,1 -> hard link
> 1,1 -> reserved, space for another link-quirk type
> 
> But that would require additional check, i.e.
> 
> if (flags&(LINK|HARDLINK) == (LINK|HARDLINK)) ...

Ah, I see. In terms of usability, I think it makes more sense to have

IOSQE_LINK | IOSQE_HARDLINK

be the same as just IOSQE_LINK. It would be nice to retain that for
something else, but I think it'll be more confusing to users.

-- 
Jens Axboe


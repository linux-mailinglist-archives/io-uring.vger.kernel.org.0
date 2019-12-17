Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22EDC1233AF
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 18:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfLQRhy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 12:37:54 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:34898 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLQRhy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 12:37:54 -0500
Received: by mail-io1-f67.google.com with SMTP id v18so10944495iol.2
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 09:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8P1gg2/SVE7adxEfp76dGsrvehA08bIlQpwD76iBBJg=;
        b=TVtMpeeW4hjALTDDh1OaBLJyixg5HJImE+kOINgHxXVU1v3w5itUXkD6Rroed8iQ83
         rg8b+KyCrBnwaKe3Uxr7EsZhvhE4152RlOj10RCihsSGJyAfhu8OU3KsYOl8sYGGhWFy
         kVKD5qex6CkrX4rniyqrzvTxiIgjbN52gtjQ2LJwKYu4PhwgSlyWeSHoVOmWsmjHqqsN
         7DDmdHyLuxft19iyqsqOGgrU72OsY/Vxjn3HFV6M0YwGvDJ+JRa3kN0CuRgfdAbYoAY2
         +iuYxL0acQI6WJ+bOamT3lFtvwE5M2tnzTNwHROSDxEWqHfajmWFqdu46B4RhAmsgRx2
         gBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8P1gg2/SVE7adxEfp76dGsrvehA08bIlQpwD76iBBJg=;
        b=BZIHV0uIFALjWQils5MVWMUWOfB/e/0y+c6E8YBUH4MDlSHoL57Vq1BBlyj/veXTgn
         f8sDLz20EJ905KBMIjh0iVbEjYIPJI9rCU2Cwpgy+ZI4FqyEsJs0tBi+jUPaDSeahNs5
         LUYBVrRong5bib4+BNc3qkp8tl4m+lqGDyB+Z9H2NrXLtDrQEe9hNmskBtI/JG7pfzJn
         fmk+8J7dPdXw8vlw7mLsHcAXfeXODn4VCysn9PVxcWIVVp2Rb+VbaCRRglHX3lPM7Ws9
         OlzdiK6G7g1kOU20v4uxst80I2fQLPigIpK7FAIWKxsSuP711Df9JkKlitS4BMJ3RlV3
         GovQ==
X-Gm-Message-State: APjAAAUZmzQVWB9aS3W5ObX3WY7+2Dd6OFQ7FeR2WusRe4iPwUjL1Ofi
        DkpLjUC95X2stXF6+2ZAssRHNQ==
X-Google-Smtp-Source: APXvYqyP1BewXPWRAtZxAvGN1SOVITkN4rH5poM8YZHLd6Y8yMdFjqL0V2jjstyf4RJSlS9aRazguA==
X-Received: by 2002:a02:778d:: with SMTP id g135mr18645902jac.115.1576604273401;
        Tue, 17 Dec 2019 09:37:53 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l22sm3566400ilh.37.2019.12.17.09.37.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 09:37:52 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: move *queue_link_head() from common path
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576538176.git.asml.silence@gmail.com>
 <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
 <17f7900c-385f-0dfa-11bf-af99d080f894@gmail.com>
 <76917820-052d-9597-133d-424fee3edade@kernel.dk>
Message-ID: <5d4af2f6-26a2-b241-5131-3a0155cbbf22@kernel.dk>
Date:   Tue, 17 Dec 2019 10:37:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <76917820-052d-9597-133d-424fee3edade@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/17/19 9:45 AM, Jens Axboe wrote:
> On 12/16/19 4:38 PM, Pavel Begunkov wrote:
>> On 17/12/2019 02:22, Pavel Begunkov wrote:
>>> Move io_queue_link_head() to links handling code in io_submit_sqe(),
>>> so it wouldn't need extra checks and would have better data locality.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>  fs/io_uring.c | 32 ++++++++++++++------------------
>>>  1 file changed, 14 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index bac9e711e38d..a880ed1409cb 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -3373,13 +3373,15 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>>>  			  struct io_kiocb **link)
>>>  {
>>>  	struct io_ring_ctx *ctx = req->ctx;
>>> +	unsigned int sqe_flags;
>>>  	int ret;
>>>  
>>> +	sqe_flags = READ_ONCE(req->sqe->flags);
>>>  	req->user_data = READ_ONCE(req->sqe->user_data);
>>>  	trace_io_uring_submit_sqe(ctx, req->user_data, true, req->in_async);
>>>  
>>>  	/* enforce forwards compatibility on users */
>>> -	if (unlikely(req->sqe->flags & ~SQE_VALID_FLAGS)) {
>>> +	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
>>>  		ret = -EINVAL;
>>>  		goto err_req;
>>>  	}
>>> @@ -3402,10 +3404,10 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>>>  	if (*link) {
>>>  		struct io_kiocb *head = *link;
>>>  
>>> -		if (req->sqe->flags & IOSQE_IO_DRAIN)
>>> +		if (sqe_flags & IOSQE_IO_DRAIN)
>>>  			head->flags |= REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
>>>  
>>> -		if (req->sqe->flags & IOSQE_IO_HARDLINK)
>>> +		if (sqe_flags & IOSQE_IO_HARDLINK)
>>>  			req->flags |= REQ_F_HARDLINK;
>>>  
>>>  		if (io_alloc_async_ctx(req)) {
>>> @@ -3421,9 +3423,15 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
>>>  		}
>>>  		trace_io_uring_link(ctx, req, head);
>>>  		list_add_tail(&req->link_list, &head->link_list);
>>> -	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
>>> +
>>> +		/* last request of a link, enqueue the link */
>>> +		if (!(sqe_flags & IOSQE_IO_LINK)) {
>>
>> This looks suspicious (as well as in the current revision). Returning back
>> to my questions a few days ago can sqe->flags have IOSQE_IO_HARDLINK, but not
>> IOSQE_IO_LINK? I don't find any check.
>>
>> In other words, should it be as follows?
>> !(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))
> 
> Yeah, I think that should check for both. I'm fine with either approach
> in general:
> 
> - IOSQE_IO_HARDLINK must have IOSQE_IO_LINK set
> 
> or
> 
> - IOSQE_IO_HARDLINK implies IOSQE_IO_LINK
> 
> Seems like the former is easier to verify in terms of functionality,
> since we can rest easy if we check this early and -EINVAL if that isn't
> the case.
> 
> What do you think?

If you agree, want to send in a patch for that for 5.5? Then I can respin
for-5.6/io_uring on top of that, and we can apply your cleanups there.

-- 
Jens Axboe


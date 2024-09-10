Return-Path: <io-uring+bounces-3104-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B43C97385B
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 15:12:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85CF01F25B54
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 13:12:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0783191F94;
	Tue, 10 Sep 2024 13:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hjii7mt6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E42524B4;
	Tue, 10 Sep 2024 13:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725973950; cv=none; b=oFs+9GnC5Zr59cqHfUYPE8VAs/YtqA4IEkj+S4xVJ+LbdAWA7KVaCAixzeReJfQk0A+AloDpKzYnnJF7GarcI18HrstYZFeVnDsS/3/caSmkM8q41BJz2pgwc8wfRUdzHZJWEtRey9U0M6jJfw8b/w2T6mEcmQLQ8/7Q05HCAyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725973950; c=relaxed/simple;
	bh=6FZh9PrgZbdKU2iYVPACRsatwjq6CV5cbevBKcmsQBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cSwoQidn4UOr/sjgxFHg6yQTB08QCz8cl1FYa9dZis6cyOMXNYeA+zMOKAXpQUmc5NaY4+Al/cioCp340EwiYKHVI2cpI94AfAYIb9+bSGI3vs7z+4sp9dJjZp5jBPUxIlMc+0v9oXRu8B75WKVmzAous+qJ3dhpMCoU7XCSpyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hjii7mt6; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c275491c61so6858283a12.0;
        Tue, 10 Sep 2024 06:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725973947; x=1726578747; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=11AIdOA7zCRdw1DcFC14ilrN+2IcxyqHRTjwx5zddCY=;
        b=Hjii7mt6HCJrWUOe937X0chfWtd3Dipef/78wTfS/DVuFYBSCwh3Zf72MTZcoyRSuR
         pJdWhldAHlIuw8oaNbSZzBMjydJUNpRucwm2+04YH0vQF9PT0ThzcI+EIjlaB5f0h7qI
         uWaiqgYXTJfX18F1H+N2a01ZKBQGGTUS2W4WQTc8qrEeypLg5dTHuBLP0vieQ544puVq
         UZZBdZYGm5iLfH8EWtXpvdpVLd3OofWWXEROLuZedRkwEU/7zgjw9FKSE5EfAaygGrpw
         a4HEsyo1Oc5sN75/Vg1SE0cixQfueO2KU0PDvhiKoSUSOw6WDB4OAg/oag0wZNsMWb7E
         rzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725973947; x=1726578747;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=11AIdOA7zCRdw1DcFC14ilrN+2IcxyqHRTjwx5zddCY=;
        b=k9iF9IioLqqBP9yDiQrg24WhrXbor5VtYfN074A8DqLuKy4y8HHFWW/KLrcsYiE4xT
         soAWz208jWVXeSABOLNfLlR+QhazRZu5OzSZawyIPq2DhWz9kg/OHGJgspQAGU69v1Wq
         RkcDqgps2lGueNzMFtzYRzv9cSCkUlD0Rw8HENO/qbE/1tKHaAiDChdCWFaHr3PUa/3v
         wmcwztBGwzFzW5K7vUH4SIhtSszQNdMUF/1ynlrCJRVhk9+dU6IUbuKfz3HXAxfKjk2h
         8JPyngCeZRLNoIy3j/XuxwhbBpmB08A7UllPhpIXxGBn7qAwB/vPS9eF8VQIFgLb8MfC
         2DOw==
X-Forwarded-Encrypted: i=1; AJvYcCX6vWaZmW/xx2cNgFZSOFUpRy5fetEkKmeOgcnUjo271br1MxOK7qybXRvV0wkHxC7xjxcmYYZM9A==@vger.kernel.org, AJvYcCXc+vKjlp/APBvjgIgHLc69CCRc+ZvnENlL2SHw1QvwgqIFlP+TIuhNateMDoQEXfhW0uArW6H16DjRxog=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEvRkIOL9LoimgNo/jvY99v8MaMh+X0sLjA1MM/xXBu0qDTFWV
	c7GuvvtScAxIvQBqqxv0ZPRdgUrPDfFJcoxx+uhpm+UPvsDE0MI/
X-Google-Smtp-Source: AGHT+IFCgBUqWWH+b5W/+hc9i68lO9+yrKJlEhm8eXVvrLwvTDGcB/3ZpfK71dv2BK9pn3RnXAk/ZQ==
X-Received: by 2002:a05:6402:1d4d:b0:5c4:95d:da34 with SMTP id 4fb4d7f45d1cf-5c4095ddb7cmr862617a12.26.1725973946632;
        Tue, 10 Sep 2024 06:12:26 -0700 (PDT)
Received: from [192.168.42.252] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3ebd41ba7sm4280604a12.4.2024.09.10.06.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 06:12:26 -0700 (PDT)
Message-ID: <7050796e-be88-4e01-abdb-976baba2f83b@gmail.com>
Date: Tue, 10 Sep 2024 14:12:53 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 4/8] io_uring: support SQE group
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240808162503.345913-1-ming.lei@redhat.com>
 <20240808162503.345913-5-ming.lei@redhat.com>
 <3c819871-7ca3-47ea-b752-c4a8a49f8304@gmail.com> <Zs/5Hpi16aQKlHFw@fedora>
 <36ae357b-bebe-4276-a8db-d6dccf227b61@gmail.com> <ZtweiCfLOJmdeY0Z@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZtweiCfLOJmdeY0Z@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/24 10:36, Ming Lei wrote:
...
>>> Wrt. ublk, group provides zero copy, and the ublk io(group) is generic
>>> IO, sometime IO_LINK is really needed & helpful, such as in ublk-nbd,
>>> send(tcp) requests need to be linked & zc. And we shouldn't limit IO_LINK
>>> for generic io_uring IO.
>>>
>>>> from nuances as such, which would be quite hard to track, the semantics
>>>> of IOSQE_CQE_SKIP_SUCCESS is unclear.
>>>
>>> IO group just follows every normal request.
>>
>> It tries to mimic but groups don't and essentially can't do it the
>> same way, at least in some aspects. E.g. IOSQE_CQE_SKIP_SUCCESS
>> usually means that all following will be silenced. What if a
>> member is CQE_SKIP, should it stop the leader from posting a CQE?
>> And whatever the answer is, it'll be different from the link's
>> behaviour.
> 
> Here it looks easier than link's:
> 
> - only leader's IOSQE_CQE_SKIP_SUCCESS follows linked request's rule
> - all members just respects the flag for its own, and not related with
> leader's
> 
>>
>> Regardless, let's forbid IOSQE_CQE_SKIP_SUCCESS and linked timeouts
>> for groups, that can be discussed afterwards.
> 
> It should easy to forbid IOSQE_CQE_SKIP_SUCCESS which is per-sqe, will do
> it in V6.
> 
> I am not sure if it is easy to disallow IORING_OP_LINK_TIMEOUT, which
> covers all linked sqes, and group leader could be just one of them.
> Can you share any idea about the implementation to forbid LINK_TIMEOUT
> for sqe group?

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 671d6093bf36..83b5fd64b4e9 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -542,6 +542,9 @@ static int __io_timeout_prep(struct io_kiocb *req,
  	data->mode = io_translate_timeout_mode(flags);
  	hrtimer_init(&data->timer, io_timeout_get_clock(data), data->mode);
  
+	if (is_timeout_link && req->ctx->submit_state.group.head)
+		return -EINVAL;
+
  	if (is_timeout_link) {
  		struct io_submit_link *link = &req->ctx->submit_state.link;
  

This should do, they already look into the ctx's link list. Just move
it into the "if (is_timeout_link)" block.


>>> 1) fail in linked chain
>>> - follows IO_LINK's behavior since io_fail_links() covers io group
>>>
>>> 2) otherwise
>>> - just respect IOSQE_CQE_SKIP_SUCCESS
>>>
>>>> And also it doen't work with IORING_OP_LINK_TIMEOUT.
>>>
>>> REQ_F_LINK_TIMEOUT can work on whole group(or group leader) only, and I
>>> will document it in V6.
>>
>> It would still be troublesome. When a linked timeout fires it searches
>> for the request it's attached to and cancels it, however, group leaders
>> that queued up their members are discoverable. But let's say you can find
>> them in some way, then the only sensbile thing to do is cancel members,
>> which should be doable by checking req->grp_leader, but might be easier
>> to leave it to follow up patches.
> 
> We have changed sqe group to start queuing members after leader is
> completed. link timeout will cancel leader with all its members via
> leader->grp_link, this behavior should respect IORING_OP_LINK_TIMEOUT
> completely.
> 
> Please see io_fail_links() and io_cancel_group_members().
> 
>>
>>
>>>>> +
>>>>> +		lead->grp_refs += 1;
>>>>> +		group->last->grp_link = req;
>>>>> +		group->last = req;
>>>>> +
>>>>> +		if (req->flags & REQ_F_SQE_GROUP)
>>>>> +			return NULL;
>>>>> +
>>>>> +		req->grp_link = NULL;
>>>>> +		req->flags |= REQ_F_SQE_GROUP;
>>>>> +		group->head = NULL;
>>>>> +		if (lead->flags & REQ_F_FAIL) {
>>>>> +			io_queue_sqe_fallback(lead);
>>>>
>>>> Let's say the group was in the middle of a link, it'll
>>>> complete that group and continue with assembling / executing
>>>> the link when it should've failed it and honoured the
>>>> request order.
>>>
>>> OK, here we can simply remove the above two lines, and link submit
>>> state can handle this failure in link chain.
>>
>> If you just delete then nobody would check for REQ_F_FAIL and
>> fail the request.
> 
> io_link_assembling() & io_link_sqe() checks for REQ_F_FAIL and call
> io_queue_sqe_fallback() either if it is in link chain or
> not.

The case we're talking about is failing a group, which is
also in the middle of a link.

LINK_HEAD -> {GROUP_LEAD, GROUP_MEMBER}

Let's say GROUP_MEMBER fails and sets REQ_F_FAIL to the lead,
then in v5 does:

if (lead->flags & REQ_F_FAIL) {
	io_queue_sqe_fallback(lead);
	return NULL;
}

In which case it posts cqes for GROUP_LEAD and GROUP_MEMBER,
and then try to execute LINK_HEAD (without failing it), which
is wrong. So first we need:

if (state.linked_link.head)
	req_fail_link_node(state.linked_link.head);

And then we can't just remove io_queue_sqe_fallback(), because
when a group is not linked there would be no io_link_sqe()
to fail it. You can do:


io_group_sqe()
{
	if ((lead->flags & REQ_F_FAIL) && !ctx->state.link.head) {
		io_queue_sqe_fallback(lead);
		return NULL;
	}
	...
}

but it's much cleaner to move REQ_F_FAIL out of group assembling.
We'd also want to move same REQ_F_FAIL / io_queue_sqe_fallback()
out of io_link_sqe(), but I didn't mentioned because it's not
strictly required for your set AFAIR.


>> Assuming you'd also set the fail flag to the
>> link head when appropriate, how about deleting these two line
>> and do like below? (can be further prettified)
>>
>>
>> bool io_group_assembling()
>> {
>> 	return state->group.head || (req->flags & REQ_F_SQE_GROUP);
>> }
>> bool io_link_assembling()
>> {
>> 	return state->link.head || (req->flags & IO_REQ_LINK_FLAGS);
>> }
>>
>> static inline int io_submit_sqe()
>> {
>> 	...
>> 	if (unlikely(io_link_assembling(state, req) ||
>> 				 io_group_assembling(state, req) ||
>> 				 req->flags & REQ_F_FAIL)) {
>> 		if (io_group_assembling(state, req)) {
>> 			req = io_group_sqe(&state->group, req);
>> 			if (!req)
>> 				return 0;
>> 		}
>> 		if (io_link_assembling(state, req)) {
>> 			req = io_link_sqe(&state->link, req);
>> 			if (!req)
>> 				return 0;
>> 		}
>> 		if (req->flags & REQ_F_FAIL) {
>> 			io_queue_sqe_fallback(req);
>> 			return 0;
> 
> As I mentioned above, io_link_assembling() & io_link_sqe() covers
> the failure handling.

-- 
Pavel Begunkov


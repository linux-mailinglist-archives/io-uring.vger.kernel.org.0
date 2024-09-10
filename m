Return-Path: <io-uring+bounces-3130-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1047B974414
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 22:31:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCE38282DC3
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 20:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A53817E473;
	Tue, 10 Sep 2024 20:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dejyExLh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE981AAE05;
	Tue, 10 Sep 2024 20:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726000283; cv=none; b=Rd+8zT78j8QTBmmTK54RJKyFArLiTWeT3alVPNO49+orjGhT8AUlvCyaPHycb+RyD8BdxWjCANAhUVPUtFf97t1NwP5iIb647NddHdXrK3fgxDyTdM3KDX/uxVNZQAFdaj0Hef48R3tdjpwi+9A4nhoj8d10GsIxi5fjpOHTCtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726000283; c=relaxed/simple;
	bh=d8gRAj5vL5jfkxzb01sVp5sumJst8wcVt3uxd4mgmVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MDtQ+xbt8t/ehNYT/bqbehj9sgrjdA/1D86X5+mJZgySgcV1XRTcRbjA9sFKj3C1kzIqTcoZaa+eFj5dJQtQM7PF7f8llX0WdENoGHSztPDDFUNvDIaYm9JtlO3w3D2Gr+FyAmLTZvgcCJA80diXib4MMIYw5bk07Rf45rldFOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dejyExLh; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-374c1e5fe79so3944892f8f.1;
        Tue, 10 Sep 2024 13:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726000280; x=1726605080; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XGCuJMaxTlBSqr8ys2Ha2BHyFw84iEPU3729o1sKO7A=;
        b=dejyExLhqe3nx5xYIVeeYZ3/fi8CEIopV48ef2F3Ca3C1ZmJCH+FJEEJgaRRdjXrl0
         kHQfbG0IWd0s78ZGg7dqmFnSxRhyot+NUOb8JOplWbcG5NebgC9mwpGAv+RvgTY8MEHf
         Bum6cgiPKf8QcbzkU8kQo6SCa1xmfUxBvcWSLOvjsX6Qg8ckYrqLOwyEs4FhdczzN0/W
         n/E1iImnBodGMxODyJyrnneShl0gEDsnFVjg+y8ubq+o40BmXdNWf2Da4X8GwgHj7s8u
         OJSrMe/d+Jfpwae4XVIO9vNBhZG/pyW66HBJ2myCXUwAHNfizX+0QEdAbbJ6b/ilBIkM
         MbfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726000280; x=1726605080;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XGCuJMaxTlBSqr8ys2Ha2BHyFw84iEPU3729o1sKO7A=;
        b=JJRlEXAEUMvHdHFdYr7WX/JkDVLEyOmRW98/8T4MM4fewggew1FUSPdSt1H3P7386T
         rHChnc7M4DYk/TRCr0T/5zIdAHm8AtQkAPYswzOWgE6LPS1ezjarI6ZbmKmHLoP7tJMV
         NyvybTD/x9auGr6aql0ye0plZRBHImOka1uVXbAAAgi4mPnW9ojNdEt/5zTPbnHX4Glm
         rO7toTPEMO9CxBTMbMgkqvZqbO+6uCVs1g/i7F9RKxfSI06gHC1L18Q+yZkaHrKXJI74
         LmDF3dyX+EQn9M47jGCib+nbz2Aqac5N1zTGNC4FGYW9wgIrNm5GfU2EYG5+tY6N25Ve
         9aAw==
X-Forwarded-Encrypted: i=1; AJvYcCU5ApTCiu9hexnubOXLrft9KeUjD/JYiLG3c4DAtJIjIDCUAtv8PaMqpVtqhaHiMEyojIx9MvUxCBNW2BE=@vger.kernel.org, AJvYcCUIyVY8oGuJZYloS7pgS1EuUmTgKlnObhFNxZmIRDK4I5hjtKzrhvqxeXQ7Gu0OVzgjNt5vhBCikw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0mdLk4UbjVQ60huljjVu1msDp2f4OmX2lnfpx/mN892sb8igH
	FeqY3PIntHO3YBowd52We43pcd8m8lyZ8j8FK6lZSmM9triC9rQTYoy/6CMWEgQ=
X-Google-Smtp-Source: AGHT+IGXM0t2NmLdWsfjPV7+ZKlP+NFfe3EaE0588DJklyTB8AQ6YSTGade2hGZUJf5mwKglRSXSAA==
X-Received: by 2002:a05:6000:184e:b0:378:7e74:cc25 with SMTP id ffacd0b85a97d-3788967e4e6mr14662245f8f.39.1726000279330;
        Tue, 10 Sep 2024 13:31:19 -0700 (PDT)
Received: from [192.168.42.24] ([185.69.144.178])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caeb8181csm122431855e9.33.2024.09.10.13.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 13:31:18 -0700 (PDT)
Message-ID: <dacd0c73-e97d-40b3-81a1-2e5ae42b21b7@gmail.com>
Date: Tue, 10 Sep 2024 21:31:45 +0100
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
 <7050796e-be88-4e01-abdb-976baba2f83b@gmail.com> <ZuBgCbjuED/KOFTt@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZuBgCbjuED/KOFTt@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 16:04, Ming Lei wrote:
> On Tue, Sep 10, 2024 at 02:12:53PM +0100, Pavel Begunkov wrote:
>> On 9/7/24 10:36, Ming Lei wrote:
>> ...
>>>>> Wrt. ublk, group provides zero copy, and the ublk io(group) is generic
>>>>> IO, sometime IO_LINK is really needed & helpful, such as in ublk-nbd,
>>>>> send(tcp) requests need to be linked & zc. And we shouldn't limit IO_LINK
>>>>> for generic io_uring IO.
>>>>>
>>>>>> from nuances as such, which would be quite hard to track, the semantics
>>>>>> of IOSQE_CQE_SKIP_SUCCESS is unclear.
>>>>>
>>>>> IO group just follows every normal request.
>>>>
>>>> It tries to mimic but groups don't and essentially can't do it the
>>>> same way, at least in some aspects. E.g. IOSQE_CQE_SKIP_SUCCESS
>>>> usually means that all following will be silenced. What if a
>>>> member is CQE_SKIP, should it stop the leader from posting a CQE?
>>>> And whatever the answer is, it'll be different from the link's
>>>> behaviour.
>>>
>>> Here it looks easier than link's:
>>>
>>> - only leader's IOSQE_CQE_SKIP_SUCCESS follows linked request's rule
>>> - all members just respects the flag for its own, and not related with
>>> leader's
>>>
>>>>
>>>> Regardless, let's forbid IOSQE_CQE_SKIP_SUCCESS and linked timeouts
>>>> for groups, that can be discussed afterwards.
>>>
>>> It should easy to forbid IOSQE_CQE_SKIP_SUCCESS which is per-sqe, will do
>>> it in V6.
>>>
>>> I am not sure if it is easy to disallow IORING_OP_LINK_TIMEOUT, which
>>> covers all linked sqes, and group leader could be just one of them.
>>> Can you share any idea about the implementation to forbid LINK_TIMEOUT
>>> for sqe group?
>>
>> diff --git a/io_uring/timeout.c b/io_uring/timeout.c
>> index 671d6093bf36..83b5fd64b4e9 100644
>> --- a/io_uring/timeout.c
>> +++ b/io_uring/timeout.c
>> @@ -542,6 +542,9 @@ static int __io_timeout_prep(struct io_kiocb *req,
>>   	data->mode = io_translate_timeout_mode(flags);
>>   	hrtimer_init(&data->timer, io_timeout_get_clock(data), data->mode);
>> +	if (is_timeout_link && req->ctx->submit_state.group.head)
>> +		return -EINVAL;
>> +
>>   	if (is_timeout_link) {
>>   		struct io_submit_link *link = &req->ctx->submit_state.link;
>>
>> This should do, they already look into the ctx's link list. Just move
>> it into the "if (is_timeout_link)" block.
> 
> OK.
> 
>>
>>
>>>>> 1) fail in linked chain
>>>>> - follows IO_LINK's behavior since io_fail_links() covers io group
>>>>>
>>>>> 2) otherwise
>>>>> - just respect IOSQE_CQE_SKIP_SUCCESS
>>>>>
>>>>>> And also it doen't work with IORING_OP_LINK_TIMEOUT.
>>>>>
>>>>> REQ_F_LINK_TIMEOUT can work on whole group(or group leader) only, and I
>>>>> will document it in V6.
>>>>
>>>> It would still be troublesome. When a linked timeout fires it searches
>>>> for the request it's attached to and cancels it, however, group leaders
>>>> that queued up their members are discoverable. But let's say you can find
>>>> them in some way, then the only sensbile thing to do is cancel members,
>>>> which should be doable by checking req->grp_leader, but might be easier
>>>> to leave it to follow up patches.
>>>
>>> We have changed sqe group to start queuing members after leader is
>>> completed. link timeout will cancel leader with all its members via
>>> leader->grp_link, this behavior should respect IORING_OP_LINK_TIMEOUT
>>> completely.
>>>
>>> Please see io_fail_links() and io_cancel_group_members().
>>>
>>>>
>>>>
>>>>>>> +
>>>>>>> +		lead->grp_refs += 1;
>>>>>>> +		group->last->grp_link = req;
>>>>>>> +		group->last = req;
>>>>>>> +
>>>>>>> +		if (req->flags & REQ_F_SQE_GROUP)
>>>>>>> +			return NULL;
>>>>>>> +
>>>>>>> +		req->grp_link = NULL;
>>>>>>> +		req->flags |= REQ_F_SQE_GROUP;
>>>>>>> +		group->head = NULL;
>>>>>>> +		if (lead->flags & REQ_F_FAIL) {
>>>>>>> +			io_queue_sqe_fallback(lead);
>>>>>>
>>>>>> Let's say the group was in the middle of a link, it'll
>>>>>> complete that group and continue with assembling / executing
>>>>>> the link when it should've failed it and honoured the
>>>>>> request order.
>>>>>
>>>>> OK, here we can simply remove the above two lines, and link submit
>>>>> state can handle this failure in link chain.
>>>>
>>>> If you just delete then nobody would check for REQ_F_FAIL and
>>>> fail the request.
>>>
>>> io_link_assembling() & io_link_sqe() checks for REQ_F_FAIL and call
>>> io_queue_sqe_fallback() either if it is in link chain or
>>> not.
>>
>> The case we're talking about is failing a group, which is
>> also in the middle of a link.
>>
>> LINK_HEAD -> {GROUP_LEAD, GROUP_MEMBER}
>>
>> Let's say GROUP_MEMBER fails and sets REQ_F_FAIL to the lead,
>> then in v5 does:
>>
>> if (lead->flags & REQ_F_FAIL) {
>> 	io_queue_sqe_fallback(lead);
>> 	return NULL;
>> }
>>
>> In which case it posts cqes for GROUP_LEAD and GROUP_MEMBER,
>> and then try to execute LINK_HEAD (without failing it), which
>> is wrong. So first we need:
>>
>> if (state.linked_link.head)
>> 	req_fail_link_node(state.linked_link.head);
> 
> For group leader, link advancing is always done via io_queue_next(), in
> which io_disarm_next() is called for failing the whole remained link
> if the current request is marked as FAIL.
> 
>>
>> And then we can't just remove io_queue_sqe_fallback(), because
>> when a group is not linked there would be no io_link_sqe()
>> to fail it. You can do:
> 
> If one request in group is marked as FAIL, io_link_assembling()
> will return true, and io_link_sqe() will fail it.

Hmm, you're right, even though it's not a great way of doing it,
i.e. pushing a req into io_link_sqe() even when linking has never
been requested, but that's fine. I can drop a quick patch on
top if it bothers me.

-- 
Pavel Begunkov


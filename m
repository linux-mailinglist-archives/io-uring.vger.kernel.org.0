Return-Path: <io-uring+bounces-3072-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E89D196F9CA
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 19:15:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E98E282E56
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 17:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 412861D54E1;
	Fri,  6 Sep 2024 17:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K1onWIwI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B79F1D54FC;
	Fri,  6 Sep 2024 17:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725642904; cv=none; b=iTYeW/szRjR6HjAXunoDqXm/7ffZwIXn+kGkYvzwwFUF60RnoCe669hrj8CywkNxaWNhTpFRvpO9Q5FSofiTl+9iB3DYrfSa2MgSudJfgkFEI6Dbubc4crzdd3/exWBzvyX7Wq8Iy7j4Jgc6lqkN1C8UmRPSaEMYbCpw+GlGqco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725642904; c=relaxed/simple;
	bh=hJd5D5cuQ3+OaiTp7RG2WH00nfbNJzZF8oCmgLThVn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c/+AUiYrFw9u93CTEX0bV++hjoN4hwBuFVoM5k+On9uQmq3PbMEVQKkMUrhxNbHE1Y7QgyCngJarYZr6Qpxb/ZM/4LP1EQkwJE/IBNEBRAkkiMrCh4TPm+IFVHbdYPLAibLnrCRfLJVZ5FSJq5Qs/HrvCsV42gyQ9uKRkRmoa9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K1onWIwI; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5becfd14353so2201981a12.1;
        Fri, 06 Sep 2024 10:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725642901; x=1726247701; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=286e4IecGgr8POuqiAFx6v5NK8AZ8gj4bnNOx6ufcZQ=;
        b=K1onWIwIuPI4lAuYZNNvnsGfUoIl1aB0DmaalsdYm4JhPJ8DbtQH+5XwRb6UXNfMS9
         fawLPixWNTG16zUryLjdWBKqw3uQCDlGuFBUpyERvHdslpbqBSFIrdh6ARGHDWu0mrmQ
         oRjI0tQHbGLnJPjSvJVfwD0f+Yv1sMoqdxJvXAbikqaf00mV9eQDfJ7ctUWuCpGeKR50
         RcBYFRHagTR6KHg0w8E3LXf41vlEzSA8vLDKy/E4pq7EYcPpjByXkozbMiI2VAcl3eif
         vW4k0A7xvm6+Sa+3rH6uNQetzXyBlyYNCy4jDM4hid0c3g0CRar9xnn7pXJlErq8Fd/g
         F72w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725642901; x=1726247701;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=286e4IecGgr8POuqiAFx6v5NK8AZ8gj4bnNOx6ufcZQ=;
        b=mF5CqYaKh6acanUZP2O8cGsUh5iQ+C0haFwsD12sOfrslBHKbgDpe6xYy3p9IF4zUq
         tB3NO75ZI1NKrPYb7sA4rEvbO4D+pdpszeXEp6COPCkZBGkGBoXpAKn3bXXy5b822eLx
         B/PbY8Y9YMXeKUL1zm4/sM50HkcZH2MqZEVwGncJ7jC26gP3DGebm9IPEAhivnRZImpy
         P3xqkAlVlS5VIB1qvA2/BoIW9xTt7/BkHu7EkxgJC2sqO7dqoNkEWpqUiTzVDeMOI7Ng
         2Wat5w+jMAT33gOfCQRIIg2M5uuqJrEwYpYoNf3N5bjU+o4k0JijAuysVoV7GPNOwkNE
         Lmwg==
X-Forwarded-Encrypted: i=1; AJvYcCU+0mxXGFz1cH4GS92jHH+1XQ+zY9QNyRa/2UEHTJDK7nUmryzCcN19EMwj24lkTVQeooeF3j4pmw==@vger.kernel.org, AJvYcCV37xcg/36dL9aXEuKgQNieIKlMupB3udBa3nafT1aqrGSPqyCuM3k4fG4TFM0NzWTZhMQFFGQl0hJogp8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyU+cmdAjL8GUwzQDkgN7G+7j3VKxi5wOxZFGsMYUwTcBSJtPoK
	ZiUhTIeli0NQA0pjClS55IcLqodDAx+Ya/yFHsrOoBGXibk8szsO3VasAiwx
X-Google-Smtp-Source: AGHT+IHwgQBb0JCyIo7xjY62TLND6bg2zEpb9vC3Isan2Xd8cue6/onzyWu1vzyiEjdwH9jG+PDLmw==
X-Received: by 2002:a05:6402:1d56:b0:5c3:cc6d:19df with SMTP id 4fb4d7f45d1cf-5c3cc6d1b12mr4621345a12.28.1725642900024;
        Fri, 06 Sep 2024 10:15:00 -0700 (PDT)
Received: from [192.168.42.34] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3cc56a876sm2617413a12.51.2024.09.06.10.14.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 10:14:59 -0700 (PDT)
Message-ID: <36ae357b-bebe-4276-a8db-d6dccf227b61@gmail.com>
Date: Fri, 6 Sep 2024 18:15:32 +0100
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zs/5Hpi16aQKlHFw@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/29/24 05:29, Ming Lei wrote:
...
>>> +	if (WARN_ON_ONCE(lead->grp_refs <= 0))
>>> +		return false;
>>> +
>>> +	req->flags &= ~REQ_F_SQE_GROUP;
>>
>> I'm getting completely lost when and why it clears and sets
>> back REQ_F_SQE_GROUP and REQ_F_SQE_GROUP_LEADER. Is there any
>> rule?
> 
> My fault, it should have been documented somewhere.
> 
> REQ_F_SQE_GROUP is cleared when the request is completed, but it is
> reused as flag for marking the last request in this group, so we can
> free the group leader when observing the 'last' member request.

Maybe it'd be cleaner to use a second flag?

> The only other difference about the two flags is that both are cleared
> when the group leader becomes the last one in the group, then
> this leader degenerates as normal request, which way can simplify
> group leader freeing.
> 
>>
>>> +	/*
>>> +	 * Set linked leader as failed if any member is failed, so
>>> +	 * the remained link chain can be terminated
>>> +	 */
>>> +	if (unlikely((req->flags & REQ_F_FAIL) &&
>>> +		     ((lead->flags & IO_REQ_LINK_FLAGS) && lead->link)))
>>> +		req_set_fail(lead);
>>
>> if (req->flags & REQ_F_FAIL)
>> 	req_set_fail(lead);
>>
>> REQ_F_FAIL is not specific to links, if a request fails we need
>> to mark it as such.
> 
> It is for handling group failure.
> 
> The following condition
> 
> 	((lead->flags & IO_REQ_LINK_FLAGS) && lead->link))
> 
> means that this group is in one link-chain.
> 
> If any member in this group is failed, we need to fail this group(lead),
> then the remained requests in this chain can be failed.
> 
> Otherwise, it isn't necessary to fail group leader in case of any member
> io failure.

What bad would happen if you do it like this?

if (req->flags & REQ_F_FAIL)
	req_set_fail(lead);

I'm asking because if you rely on some particular combination
of F_FAIL and F_LINK somewhere, it's likely wrong, but otherwise
we F_FAIL a larger set of requests, which should never be an
issue.

>>> +	return !--lead->grp_refs;
>>> +}
>>> +
>>> +static inline bool leader_is_the_last(struct io_kiocb *lead)
>>> +{
>>> +	return lead->grp_refs == 1 && (lead->flags & REQ_F_SQE_GROUP);
>>> +}
>>> +
>>> +static void io_complete_group_member(struct io_kiocb *req)
>>> +{
>>> +	struct io_kiocb *lead = get_group_leader(req);
>>> +
>>> +	if (WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP)))
>>> +		return;
>>> +
>>> +	/* member CQE needs to be posted first */
>>> +	if (!(req->flags & REQ_F_CQE_SKIP))
>>> +		io_req_commit_cqe(req->ctx, req);
>>> +
>>> +	if (__io_complete_group_member(req, lead)) {
>>> +		/*
>>> +		 * SQE_GROUP flag is kept for the last member, so the leader
>>> +		 * can be retrieved & freed from this last member
>>> +		 */
>>> +		req->flags |= REQ_F_SQE_GROUP;
> 
> 'req' is the last completed request, so mark it as the last one
> by reusing REQ_F_SQE_GROUP, so we can free group leader in
> io_free_batch_list() when observing the last flag.
> 
> But it should have been documented.
> 
>>> +		if (!(lead->flags & REQ_F_CQE_SKIP))
>>> +			io_req_commit_cqe(lead->ctx, lead);
>>> +	} else if (leader_is_the_last(lead)) {
>>> +		/* leader will degenerate to plain req if it is the last */
>>> +		lead->flags &= ~(REQ_F_SQE_GROUP | REQ_F_SQE_GROUP_LEADER);
>>
>> What's this chunk is about?
> 
> The leader becomes the only request not completed in group, so it is
> degenerated as normal one by clearing the two flags. This way simplifies
> logic for completing group leader.
> 
...
>>> @@ -1388,11 +1501,33 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
>>>    						    comp_list);
>>>    		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
>>> +			if (req->flags & (REQ_F_SQE_GROUP |
>>> +					  REQ_F_SQE_GROUP_LEADER)) {
>>> +				struct io_kiocb *leader;
>>> +
>>> +				/* Leader is freed via the last member */
>>> +				if (req_is_group_leader(req)) {
>>> +					node = req->comp_list.next;
>>> +					continue;
>>> +				}
>>> +
>>> +				/*
>>> +				 * Only the last member keeps GROUP flag,
>>> +				 * free leader and this member together
>>> +				 */
>>> +				leader = get_group_leader(req);
>>> +				leader->flags &= ~REQ_F_SQE_GROUP_LEADER;
>>> +				req->flags &= ~REQ_F_SQE_GROUP;
>>> +				wq_stack_add_head(&leader->comp_list,
>>> +						  &req->comp_list);
>>
>> That's quite hacky, but at least we can replace it with
>> task work if it gets in the way later on.
> 
> io_free_batch_list() is already called in task context, and it isn't
> necessary to schedule one extra tw, which hurts perf more or less.
> 
> Another way is to store these leaders into one temp list, and
> call io_free_batch_list() for this temp list one more time.

What I'm saying, it's fine to leave it as is for now. In the
future if it becomes a problem for ome reason or another, we can
do it the task_work like way.

...
>>> @@ -2101,6 +2251,62 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>    	return def->prep(req, sqe);
>>>    }
>>> +static struct io_kiocb *io_group_sqe(struct io_submit_link *group,
>>> +				     struct io_kiocb *req)
>>> +{
>>> +	/*
>>> +	 * Group chain is similar with link chain: starts with 1st sqe with
>>> +	 * REQ_F_SQE_GROUP, and ends with the 1st sqe without REQ_F_SQE_GROUP
>>> +	 */
>>> +	if (group->head) {
>>> +		struct io_kiocb *lead = group->head;
>>> +
>>> +		/* members can't be in link chain, can't be drained */
>>> +		if (req->flags & (IO_REQ_LINK_FLAGS | REQ_F_IO_DRAIN))
>>> +			req_fail_link_node(lead, -EINVAL);
>>
>> That should fail the entire link (if any) as well.
> 
> Good catch, here we should fail link head by following the logic
> in io_submit_fail_init().
> 
>>
>> I have even more doubts we even want to mix links and groups. Apart
> 
> Wrt. ublk, group provides zero copy, and the ublk io(group) is generic
> IO, sometime IO_LINK is really needed & helpful, such as in ublk-nbd,
> send(tcp) requests need to be linked & zc. And we shouldn't limit IO_LINK
> for generic io_uring IO.
> 
>> from nuances as such, which would be quite hard to track, the semantics
>> of IOSQE_CQE_SKIP_SUCCESS is unclear.
> 
> IO group just follows every normal request.

It tries to mimic but groups don't and essentially can't do it the
same way, at least in some aspects. E.g. IOSQE_CQE_SKIP_SUCCESS
usually means that all following will be silenced. What if a
member is CQE_SKIP, should it stop the leader from posting a CQE?
And whatever the answer is, it'll be different from the link's
behaviour.

Regardless, let's forbid IOSQE_CQE_SKIP_SUCCESS and linked timeouts
for groups, that can be discussed afterwards.

> 1) fail in linked chain
> - follows IO_LINK's behavior since io_fail_links() covers io group
> 
> 2) otherwise
> - just respect IOSQE_CQE_SKIP_SUCCESS
> 
>> And also it doen't work with IORING_OP_LINK_TIMEOUT.
> 
> REQ_F_LINK_TIMEOUT can work on whole group(or group leader) only, and I
> will document it in V6.

It would still be troublesome. When a linked timeout fires it searches
for the request it's attached to and cancels it, however, group leaders
that queued up their members are discoverable. But let's say you can find
them in some way, then the only sensbile thing to do is cancel members,
which should be doable by checking req->grp_leader, but might be easier
to leave it to follow up patches.


>>> +
>>> +		lead->grp_refs += 1;
>>> +		group->last->grp_link = req;
>>> +		group->last = req;
>>> +
>>> +		if (req->flags & REQ_F_SQE_GROUP)
>>> +			return NULL;
>>> +
>>> +		req->grp_link = NULL;
>>> +		req->flags |= REQ_F_SQE_GROUP;
>>> +		group->head = NULL;
>>> +		if (lead->flags & REQ_F_FAIL) {
>>> +			io_queue_sqe_fallback(lead);
>>
>> Let's say the group was in the middle of a link, it'll
>> complete that group and continue with assembling / executing
>> the link when it should've failed it and honoured the
>> request order.
> 
> OK, here we can simply remove the above two lines, and link submit
> state can handle this failure in link chain.

If you just delete then nobody would check for REQ_F_FAIL and
fail the request. Assuming you'd also set the fail flag to the
link head when appropriate, how about deleting these two line
and do like below? (can be further prettified)


bool io_group_assembling()
{
	return state->group.head || (req->flags & REQ_F_SQE_GROUP);
}
bool io_link_assembling()
{
	return state->link.head || (req->flags & IO_REQ_LINK_FLAGS);
}

static inline int io_submit_sqe()
{
	...
	if (unlikely(io_link_assembling(state, req) ||
				 io_group_assembling(state, req) ||
				 req->flags & REQ_F_FAIL)) {
		if (io_group_assembling(state, req)) {
			req = io_group_sqe(&state->group, req);
			if (!req)
				return 0;
		}
		if (io_link_assembling(state, req)) {
			req = io_link_sqe(&state->link, req);
			if (!req)
				return 0;
		}
		if (req->flags & REQ_F_FAIL) {
			io_queue_sqe_fallback(req);
			return 0;
		}
	}
	io_queue_sqe(req);
	return 0;
}


-- 
Pavel Begunkov


Return-Path: <io-uring+bounces-4089-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B7EA9B3EEB
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 01:12:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F5EC1C223B3
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 00:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E8B723CE;
	Tue, 29 Oct 2024 00:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PK1O+FoS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805B11854
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 00:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730160761; cv=none; b=SPMPFRyTy+Y5jC6Vx4RKc9KjZJTkBXlb2UhctYqzJYklrkXOu5J3/fGxo/Qwl//ontRQnrIdqbx/794iBmm9Wz/gy/OU5ReHPDrB6qzNqgwmyasTAItrhnj/d1Hpxf2eSaIXPSRxymHXi3I1Xirku17SOFsUrwuQ0EoZUExPPec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730160761; c=relaxed/simple;
	bh=Dfh6059ILmBKUOqfqOEuNDgltskB/vAAqOXIljx7UQo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RvfPLWrevhlZ9PqSzkC9wnAaBS45UI3IvBbljqiEWzU1In9H6/W0EpgS1rfQpnC9wrBf4J3WybRPq/LH873+ehD/XUlsL0VrOQ5zeZWzmKOlJUz9Uew9X9NTWHIZEWjQ/via2roaYD61TDfQZxnDaY931LFM8PsxqhL0Jf20Qho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PK1O+FoS; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-210e5369b7dso10433015ad.3
        for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 17:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730160757; x=1730765557; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s8qKWHlu9nuAcuqLVuzotLi/gmSD4/gHhTwEshGFxUM=;
        b=PK1O+FoSq6q/t4AycpRG2qghNyn6ImHEzXlwOVhVyDAEsrf4yOYEe73D91CN7F5Coz
         braXZG+OS/qMjynvUK/fngdMmOrMn7chN4SG27pBkdgLKhj9gizQSoygoIndjWWiAt3R
         5lgQ9hIs/UZEWnb1+PggFw3oc24weC7/BO6gLNM17owJCbMThGFfMCVkcFEsiz0Zpwix
         iHwJkZLeimIleFlnwH4dQUVTetsQiLj7DwGMG3YcAzkcGpeZlKrMTHgWJRMl3HwMi33w
         Ss6tSFDzn40ZW81kQgl4x023T08KaX3ilaDzGwRsYnt+twDfixxfjYLLTHKn+iTUUf1A
         teRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730160757; x=1730765557;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s8qKWHlu9nuAcuqLVuzotLi/gmSD4/gHhTwEshGFxUM=;
        b=u3sSHP0iYNNy4bkO/T+513SY0hBAlPbhgwZ/5AwLu5V1UTQmh5jgjktE+Lsd9vOTCs
         0vljba4hYSXxbUVDdeKM9eJFSNpAg4YWQfaBCnxJEDBIRziFu9F0EQzuGStUidL0JBSZ
         hjQ30D7J9gqijPFzXPOIb6/QZh2Vvag9Bz1Y8d8xetYVoYFyG0De9WSsVZ/+5IZXKEV6
         BQy//QoIYC1YPAMOeAt0+xgrMYnpI4WA4ohOfTLga+SBCNR3QT4C7Tfj3zrNvz466yeW
         //mg4WH/juvMkxOKvymKVK0qJMWsslWAymniikHONq/tgeVwQa6EqQkbaTgH+4AdtTjM
         0u6A==
X-Forwarded-Encrypted: i=1; AJvYcCVxT73iZcmn7Mjmglax7SDMcbzLz7/6XbEG/cCIemaHscGwZ8Qn1KOYiIGajr5xEZt/YroaTVqDKw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe5zsm5yRAKlBkTdXztdXRqLXo0XY992cFRCLUifXF9iwOpxAd
	Ks9+ZsrmPjLFN4e7lKgOMK8FEcdbveJ8Uu6v88KzI4OYNuAz7xHK8yXjfrnEVso=
X-Google-Smtp-Source: AGHT+IFztKnN/rPEGts6EWZftWX5Kd6cuEVK5UZoUQtqzO8B1Igsy6sILka6bWLdXowb61+wy1ucBA==
X-Received: by 2002:a17:903:32c4:b0:20c:7796:5e76 with SMTP id d9443c01a7336-210c68d82f3mr151410745ad.18.1730160756590;
        Mon, 28 Oct 2024 17:12:36 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bbf71d50sm55994615ad.72.2024.10.28.17.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 17:12:36 -0700 (PDT)
Message-ID: <5417bcc5-e766-4044-905b-da5768d69f29@kernel.dk>
Date: Mon, 28 Oct 2024 18:12:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 4/7] io_uring: support SQE group
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>, Kevin Wolf <kwolf@redhat.com>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <20241025122247.3709133-5-ming.lei@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241025122247.3709133-5-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/25/24 6:22 AM, Ming Lei wrote:
> SQE group is defined as one chain of SQEs starting with the first SQE that
> has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
> doesn't have it set, and it is similar with chain of linked SQEs.
> 
> Not like linked SQEs, each sqe is issued after the previous one is
> completed. All SQEs in one group can be submitted in parallel. To simplify
> the implementation from beginning, all members are queued after the leader
> is completed, however, this way may be changed and leader and members may
> be issued concurrently in future.
> 
> The 1st SQE is group leader, and the other SQEs are group member. The whole
> group share single IOSQE_IO_LINK and IOSQE_IO_DRAIN from group leader, and
> the two flags can't be set for group members. For the sake of
> simplicity, IORING_OP_LINK_TIMEOUT is disallowed for SQE group now.
> 
> When the group is in one link chain, this group isn't submitted until the
> previous SQE or group is completed. And the following SQE or group can't
> be started if this group isn't completed. Failure from any group member will
> fail the group leader, then the link chain can be terminated.
> 
> When IOSQE_IO_DRAIN is set for group leader, all requests in this group and
> previous requests submitted are drained. Given IOSQE_IO_DRAIN can be set for
> group leader only, we respect IO_DRAIN by always completing group leader as
> the last one in the group. Meantime it is natural to post leader's CQE
> as the last one from application viewpoint.
> 
> Working together with IOSQE_IO_LINK, SQE group provides flexible way to
> support N:M dependency, such as:
> 
> - group A is chained with group B together
> - group A has N SQEs
> - group B has M SQEs
> 
> then M SQEs in group B depend on N SQEs in group A.
> 
> N:M dependency can support some interesting use cases in efficient way:
> 
> 1) read from multiple files, then write the read data into single file
> 
> 2) read from single file, and write the read data into multiple files
> 
> 3) write same data into multiple files, and read data from multiple files and
> compare if correct data is written
> 
> Also IOSQE_SQE_GROUP takes the last bit in sqe->flags, but we still can
> extend sqe->flags with io_uring context flag, such as use __pad3 for
> non-uring_cmd OPs and part of uring_cmd_flags for uring_cmd OP.

Since it's taking the last flag, maybe a better idea to have the last
flag mean "more flags in (for example) __pad3" and put the new flag
there? Not sure you mean in terms of "io_uring context flag", would it
be an enter flag? Ring required to be setup with a certain flag? Neither
of those seem super encouraging, imho.

Apart from that, just a few minor nits below.

> +void io_fail_group_members(struct io_kiocb *req)
> +{
> +	struct io_kiocb *member = req->grp_link;
> +
> +	while (member) {
> +		struct io_kiocb *next = member->grp_link;
> +
> +		if (!(member->flags & REQ_F_FAIL)) {
> +			req_set_fail(member);
> +			io_req_set_res(member, -ECANCELED, 0);
> +		}
> +		member = next;
> +	}
> +}
> +
> +static void io_queue_group_members(struct io_kiocb *req)
> +{
> +	struct io_kiocb *member = req->grp_link;
> +
> +	if (!member)
> +		return;
> +
> +	req->grp_link = NULL;
> +	while (member) {
> +		struct io_kiocb *next = member->grp_link;
> +
> +		member->grp_leader = req;
> +		if (unlikely(member->flags & REQ_F_FAIL)) {
> +			io_req_task_queue_fail(member, member->cqe.res);
> +		} else if (unlikely(req->flags & REQ_F_FAIL)) {
> +			io_req_task_queue_fail(member, -ECANCELED);
> +		} else {
> +			io_req_task_queue(member);
> +		}
> +		member = next;
> +	}
> +}

Was going to say don't check for !member, you have the while loop. Which
is what you do in the helper above. You can also drop the parens in this
one.

> +static enum group_mem io_prep_free_group_req(struct io_kiocb *req,
> +					     struct io_kiocb **leader)
> +{
> +	/*
> +	 * Group completion is done, so clear the flag for avoiding double
> +	 * handling in case of io-wq
> +	 */
> +	req->flags &= ~REQ_F_SQE_GROUP;
> +
> +	if (req_is_group_leader(req)) {
> +		/* Queue members now */
> +		if (req->grp_link)
> +			io_queue_group_members(req);
> +		return GROUP_LEADER;
> +	} else {
> +		if (!req_is_last_group_member(req))
> +			return GROUP_OTHER_MEMBER;
> +
> +		/*
> +		 * Prepare for freeing leader which can only be found from
> +		 * the last member
> +		 */
> +		*leader = req->grp_leader;
> +		(*leader)->flags &= ~REQ_F_SQE_GROUP_LEADER;
> +		req->grp_leader = NULL;
> +		return GROUP_LAST_MEMBER;
> +	}
> +}

Just drop the second indentation here.

> @@ -927,7 +1051,8 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
>  	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
>  	 * the submitter task context, IOPOLL protects with uring_lock.
>  	 */
> -	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)) {
> +	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL) ||
> +	    (req->flags & REQ_F_SQE_GROUP)) {
>  		req->io_task_work.func = io_req_task_complete;
>  		io_req_task_work_add(req);
>  		return;

Minor detail, but might be nice with a REQ_F_* flag for this in the
future.

> @@ -1450,8 +1596,16 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>  		struct io_kiocb *req = container_of(node, struct io_kiocb,
>  					    comp_list);
>  
> -		if (!(req->flags & REQ_F_CQE_SKIP))
> -			io_req_commit_cqe(ctx, req);
> +		if (unlikely(req->flags & (REQ_F_CQE_SKIP | REQ_F_SQE_GROUP))) {
> +			if (req->flags & REQ_F_SQE_GROUP) {
> +				io_complete_group_req(req);
> +				continue;
> +			}
> +
> +			if (req->flags & REQ_F_CQE_SKIP)
> +				continue;
> +		}
> +		io_req_commit_cqe(ctx, req);
>  	}
>  	__io_cq_unlock_post(ctx);
>  
> @@ -1661,8 +1815,12 @@ static u32 io_get_sequence(struct io_kiocb *req)
>  	struct io_kiocb *cur;
>  
>  	/* need original cached_sq_head, but it was increased for each req */
> -	io_for_each_link(cur, req)
> -		seq--;
> +	io_for_each_link(cur, req) {
> +		if (req_is_group_leader(cur))
> +			seq -= cur->grp_refs;
> +		else
> +			seq--;
> +	}
>  	return seq;
>  }
>  
> @@ -2124,6 +2282,67 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  	return def->prep(req, sqe);
>  }
>  
> +static struct io_kiocb *io_group_sqe(struct io_submit_link *group,
> +				     struct io_kiocb *req)
> +{
> +	/*
> +	 * Group chain is similar with link chain: starts with 1st sqe with
> +	 * REQ_F_SQE_GROUP, and ends with the 1st sqe without REQ_F_SQE_GROUP
> +	 */
> +	if (group->head) {
> +		struct io_kiocb *lead = group->head;
> +
> +		/*
> +		 * Members can't be in link chain, can't be drained, but
> +		 * the whole group can be linked or drained by setting
> +		 * flags on group leader.
> +		 *
> +		 * IOSQE_CQE_SKIP_SUCCESS can't be set for member
> +		 * for the sake of simplicity
> +		 */
> +		if (req->flags & (IO_REQ_LINK_FLAGS | REQ_F_IO_DRAIN |
> +				REQ_F_CQE_SKIP))
> +			req_fail_link_node(lead, -EINVAL);
> +
> +		lead->grp_refs += 1;
> +		group->last->grp_link = req;
> +		group->last = req;
> +
> +		if (req->flags & REQ_F_SQE_GROUP)
> +			return NULL;
> +
> +		req->grp_link = NULL;
> +		req->flags |= REQ_F_SQE_GROUP;
> +		group->head = NULL;
> +
> +		return lead;
> +	} else {
> +		if (WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP)))
> +			return req;
> +		group->head = req;
> +		group->last = req;
> +		req->grp_refs = 1;
> +		req->flags |= REQ_F_SQE_GROUP_LEADER;
> +		return NULL;
> +	}
> +}

Same here, drop the 2nd indentation.

> diff --git a/io_uring/timeout.c b/io_uring/timeout.c
> index 9973876d91b0..ed6c74f1a475 100644
> --- a/io_uring/timeout.c
> +++ b/io_uring/timeout.c
> @@ -149,6 +149,8 @@ static void io_req_tw_fail_links(struct io_kiocb *link, struct io_tw_state *ts)
>  			res = link->cqe.res;
>  		link->link = NULL;
>  		io_req_set_res(link, res, 0);
> +		if (req_is_group_leader(link))
> +			io_fail_group_members(link);
>  		io_req_task_complete(link, ts);
>  		link = nxt;
>  	}
> @@ -543,6 +545,10 @@ static int __io_timeout_prep(struct io_kiocb *req,
>  	if (is_timeout_link) {
>  		struct io_submit_link *link = &req->ctx->submit_state.link;
>  
> +		/* so far disallow IO group link timeout */
> +		if (req->ctx->submit_state.group.head)
> +			return -EINVAL;
> +

For now, disallow IO group linked timeout

-- 
Jens Axboe


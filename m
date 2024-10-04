Return-Path: <io-uring+bounces-3414-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D0179903A0
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 15:12:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17CE62812AC
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 13:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E9B720FA95;
	Fri,  4 Oct 2024 13:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mh5o1uET"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448C279F3;
	Fri,  4 Oct 2024 13:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728047522; cv=none; b=SjVdfMtJojfS4+dnnmktEvfThIFGSl8gFxRIoaE9ukVrSZWnPV+fgyWmVJ3ATkSY5U8a+vAkEwd4i8KGLQwQixqi5wYgiztRvcDmlTQbf/ZqUeGoeg2zS/DacDHRdnyBtJaLRFRywHqwVBpr6Yrn8W+PnVlGFIaKzs5jsqWTRiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728047522; c=relaxed/simple;
	bh=N9PKPLTeWGSfz8qm954M/TcgcWGDBef//4vO4vU1/S4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c4I2M9Kp5u4KESWYUk2tECaEdlmmaMEzd7A27e+L0Xau4n50N4Yn4uOHiC2nXgKqKxA1fwlaM8lKtgfh6PyhOhNptMu2iN3cpbTZJ+vEjTlpP3+hiLt3yh5J1x9/GRDLKvQjiHrRc35TuM9x7cID2zgsV59Vx/lx3F8d+yS5tcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mh5o1uET; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a8d2b24b7a8so601110866b.1;
        Fri, 04 Oct 2024 06:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728047518; x=1728652318; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fc3X3qwck4YQiopkseGpBQwiV8nDGDLgCkjbw2S25IY=;
        b=mh5o1uETzN4m7RMNNc1BXGBAlpAS8LhgFb8aOLTFN0vT+tYTaeQTeGPlyvpDIUj7fL
         91GFmZagbg2V/w+Gf3PckkApp0uOA9Sr/5T+me/v0nLWZOPlo0cLnTPlFJeNP3IRcAwG
         SszrWLw/FryGCcdCAwvVY9ylC1b3FmcWQLy8K/o0ZFag3hauzX2J3jAtfmWzHuAxwrgw
         zx8XVgaXLMXM3MOjhSmqut4gEvQ+RqDGGJAebWSypjA6VIVQigC2t7oKTpIE0Pl0KewD
         zbnv6VG9EZSeWSThJqMn4GR668bjDVLVdZpV7HATOWY/h/yBhjdtRS0o83Hs4Gj2s3mB
         gnfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728047518; x=1728652318;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fc3X3qwck4YQiopkseGpBQwiV8nDGDLgCkjbw2S25IY=;
        b=bFqDMK51ZwgqpV9/mrQQPlkl1wy+rI8y0lJDstOC2u8zn0PJmxRksrrdsBSu62rZq6
         UYA4ay8YplCXvuV0CB6ndYRnOxyOE2sne2O6QHgdvXBKWFTy1CSoyQQlK4AkLY/kcqd/
         9NkI9pFm2j/KutY85u7vISjUlq94VJlCofxWhUFKIJVijZ1SW5VlWPy6Pjqpyi7BZmbm
         JHf2VXTp/K+MVnFw0u9C291NDtULY3IMaJV6TsDicxmZjh9ng8K7TvKaC+72mPEQrGNg
         ynagQk/V93dqaOm8NgfHVU2/ynr38WhWOWPyv9ub/nDfUoz3eSiXJVtKEBeGwuqsNUhc
         DKdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsnp7EpsGS/s3vBQSeEBysCH8Vxyb3tJErESFEbaOg1tue8o80ckti5APrOe9D0h4xUTPaD0aNAw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzIDNWVB+QNBxeSePYLVjY6/5fvIfldY3ShbD8MN4956ihrXegM
	68FuUz8NZ8OYuot2Rj4jLiV0CYpsanxW/J1CEbYVRGW6Hm+LCdPadLI8cA==
X-Google-Smtp-Source: AGHT+IEiyogmvyYzZYkVZL/D50xLIS2TaokESQ7K4HcMvvKbc7AU+u4A1Tj3SXd8nDU0EYNZ2ThOgg==
X-Received: by 2002:a17:907:6e8f:b0:a80:c0ed:2145 with SMTP id a640c23a62f3a-a991cede485mr289531566b.2.1728047518058;
        Fri, 04 Oct 2024 06:11:58 -0700 (PDT)
Received: from [192.168.42.11] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9910285a17sm225112866b.36.2024.10.04.06.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2024 06:11:57 -0700 (PDT)
Message-ID: <239e42d2-791e-4ef5-a312-8b5959af7841@gmail.com>
Date: Fri, 4 Oct 2024 14:12:28 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 4/8] io_uring: support SQE group
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-5-ming.lei@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240912104933.1875409-5-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/24 11:49, Ming Lei wrote:
...
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -111,13 +111,15 @@
...
> +static void io_complete_group_member(struct io_kiocb *req)
> +{
> +	struct io_kiocb *lead = get_group_leader(req);
> +
> +	if (WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP) ||
> +			 lead->grp_refs <= 0))
> +		return;
> +
> +	/* member CQE needs to be posted first */
> +	if (!(req->flags & REQ_F_CQE_SKIP))
> +		io_req_commit_cqe(req->ctx, req);
> +
> +	req->flags &= ~REQ_F_SQE_GROUP;

I can't say I like this implicit state machine too much,
but let's add a comment why we need to clear it. i.e.
it seems it wouldn't be needed if not for the
mark_last_group_member() below that puts it back to tunnel
the leader to io_free_batch_list().

> +
> +	/* Set leader as failed in case of any member failed */
> +	if (unlikely((req->flags & REQ_F_FAIL)))
> +		req_set_fail(lead);
> +
> +	if (!--lead->grp_refs) {
> +		mark_last_group_member(req);
> +		if (!(lead->flags & REQ_F_CQE_SKIP))
> +			io_req_commit_cqe(lead->ctx, lead);
> +	} else if (lead->grp_refs == 1 && (lead->flags & REQ_F_SQE_GROUP)) {
> +		/*
> +		 * The single uncompleted leader will degenerate to plain
> +		 * request, so group leader can be always freed via the
> +		 * last completed member.
> +		 */
> +		lead->flags &= ~REQ_F_SQE_GROUP_LEADER;

What does this try to handle? A group with a leader but no
members? If that's the case, io_group_sqe() and io_submit_state_end()
just need to fail such groups (and clear REQ_F_SQE_GROUP before
that).

> +	}
> +}
> +
> +static void io_complete_group_leader(struct io_kiocb *req)
> +{
> +	WARN_ON_ONCE(req->grp_refs <= 1);
> +	req->flags &= ~REQ_F_SQE_GROUP;
> +	req->grp_refs -= 1;
> +}
> +
> +static void io_complete_group_req(struct io_kiocb *req)
> +{
> +	if (req_is_group_leader(req))
> +		io_complete_group_leader(req);
> +	else
> +		io_complete_group_member(req);
> +}
> +
>   static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
> @@ -890,7 +1005,8 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
>   	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
>   	 * the submitter task context, IOPOLL protects with uring_lock.
>   	 */
> -	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)) {
> +	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL) ||
> +	    req_is_group_leader(req)) {

We're better to push all group requests to io_req_task_complete(),
not just a group leader. While seems to be correct, that just
overcomplicates the request's flow, it can post a CQE here, but then
still expect to do group stuff in the CQE posting loop
(flush_completions -> io_complete_group_req), which might post another
cqe for the leader, and then do yet another post processing loop in
io_free_batch_list().


>   		req->io_task_work.func = io_req_task_complete;
>   		io_req_task_work_add(req);
>   		return;
> @@ -1388,11 +1504,43 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
>   						    comp_list);
>   
>   		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
> +			if (req_is_last_group_member(req) ||
> +					req_is_group_leader(req)) {
> +				struct io_kiocb *leader;
> +
> +				/* Leader is freed via the last member */
> +				if (req_is_group_leader(req)) {
> +					if (req->grp_link)
> +						io_queue_group_members(req);
> +					node = req->comp_list.next;
> +					continue;
> +				}
> +
> +				/*
> +				 * Prepare for freeing leader since we are the
> +				 * last group member
> +				 */
> +				leader = get_group_leader(req);
> +				leader->flags &= ~REQ_F_SQE_GROUP_LEADER;
> +				req->flags &= ~REQ_F_SQE_GROUP;
> +				/*
> +				 * Link leader to current request's next,
> +				 * this way works because the iterator
> +				 * always check the next node only.
> +				 *
> +				 * Be careful when you change the iterator
> +				 * in future
> +				 */
> +				wq_stack_add_head(&leader->comp_list,
> +						  &req->comp_list);
> +			}
> +
>   			if (req->flags & REQ_F_REFCOUNT) {
>   				node = req->comp_list.next;
>   				if (!req_ref_put_and_test(req))
>   					continue;
>   			}
> +
>   			if ((req->flags & REQ_F_POLLED) && req->apoll) {
>   				struct async_poll *apoll = req->apoll;
>   
> @@ -1427,8 +1575,16 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   		struct io_kiocb *req = container_of(node, struct io_kiocb,
>   					    comp_list);
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
>   	}
>   	__io_cq_unlock_post(ctx);
>   
> @@ -1638,8 +1794,12 @@ static u32 io_get_sequence(struct io_kiocb *req)
>   	struct io_kiocb *cur;
>   
>   	/* need original cached_sq_head, but it was increased for each req */
> -	io_for_each_link(cur, req)
> -		seq--;
> +	io_for_each_link(cur, req) {
> +		if (req_is_group_leader(cur))
> +			seq -= cur->grp_refs;
> +		else
> +			seq--;
> +	}
>   	return seq;
>   }
...
> @@ -2217,8 +2470,22 @@ static void io_submit_state_end(struct io_ring_ctx *ctx)
>   {
>   	struct io_submit_state *state = &ctx->submit_state;
>   
> -	if (unlikely(state->link.head))
> -		io_queue_sqe_fallback(state->link.head);
> +	if (unlikely(state->group.head || state->link.head)) {
> +		/* the last member must set REQ_F_SQE_GROUP */
> +		if (state->group.head) {
> +			struct io_kiocb *lead = state->group.head;
> +
> +			state->group.last->grp_link = NULL;
> +			if (lead->flags & IO_REQ_LINK_FLAGS)
> +				io_link_sqe(&state->link, lead);
> +			else
> +				io_queue_sqe_fallback(lead);

req1(F_LINK), req2(F_GROUP), req3

is supposed to be turned into

req1 -> {group: req2 (lead), req3 }

but note that req2 here doesn't have F_LINK set.
I think it should be like this instead:

if (state->link.head)
	io_link_sqe();
else
	io_queue_sqe_fallback(lead);

> +		}
> +
> +		if (unlikely(state->link.head))
> +			io_queue_sqe_fallback(state->link.head);
> +	}
> +
>   	/* flush only after queuing links as they can generate completions */
>   	io_submit_flush_completions(ctx);
>   	if (state->plug_started)


-- 
Pavel Begunkov


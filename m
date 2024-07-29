Return-Path: <io-uring+bounces-2592-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7318693F71E
	for <lists+io-uring@lfdr.de>; Mon, 29 Jul 2024 15:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A8212824DF
	for <lists+io-uring@lfdr.de>; Mon, 29 Jul 2024 13:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8517F14E2CC;
	Mon, 29 Jul 2024 13:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NCL1j7XG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEC314A0B7;
	Mon, 29 Jul 2024 13:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722261511; cv=none; b=tqzGIBaw5K56u4jy9M6owkQHgib1HlNMyjGaEIvH2ofkSdB3g8NxM6Ud5G4WXVPTRMVYsZ/MzBmFv17/PbDANeTpUd+HR9YsFYtzXgquki7UU8fQF5HjXdT/csmIBvtIGrj5WNEvfwsVFyk3wC3zD7KpqkbhNpv+ugVcg26IdSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722261511; c=relaxed/simple;
	bh=Y3FVoErLg8pHHIo778KnUjfRqKfixmXt0OoIIjyMkvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qJBU4yhKp6KsjjMACW57eZZ8M9ojyp0eBB7jgxAHiX2PEiL3Mn6Gj2EJHq3Ocg6MoxsFa1k0qj4KXa/yVb/cmGIuuqUgNfZJdeTuDDPWTkQIpor+ejlLV3ZRKPt5Ej4vQEdyyd6yDDzBFc0tDJw1frQbwsi/sYEyDwJ6Xkz+BiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NCL1j7XG; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5b214865fecso1374792a12.1;
        Mon, 29 Jul 2024 06:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722261508; x=1722866308; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KtAlwwS6Q3jXDQJLkoaeRoaA8G8ZvjwN9Lzd9BzYrn8=;
        b=NCL1j7XGWlE8VIgVbadezjobZWhTit599zF571KTimyuFDP/pq/wiCSQJMG4ob2Pdj
         nZsxdY+bve6zEnqo5ZZXSBRrCg5ic74HuWgnPiSsmmj5W/fgQA5D182BIqdQTXzPIIG/
         lfUUngAIIkCCg8rBfoaV8l30u+TxBzqN7reKuMC1zwv6qXIEPRnwW/wsZArzD6fLs0Ef
         mLxoqTCMhNNl21L7Tg5LtXG0IxgByJKTHwqCvZjqXUfHCfuuThMploTcBrox6eKfRQHX
         APyVFQwrc51ReeaPGa69zbEFkV+QInFyvnmiAPkBhg4FCzB5UufOUZoWb9doN/2U4mcv
         Blkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722261508; x=1722866308;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KtAlwwS6Q3jXDQJLkoaeRoaA8G8ZvjwN9Lzd9BzYrn8=;
        b=P5ZCN5HsYSh7FWIzG0/NJBASUZ6PgsTbq3KkH5pZunp1L+B499+gIbB73ivjISjvCt
         eda3yvYz6or/kzQXuB6gzHVuFkNBij4HEGTwNyrNmyqUtL84/VQMYEcg+FOKhThFI/dl
         LHU7b2kJweGZ5WOThv5Tlh47g7wx11t3BoZwmpo54UT5y1DQxMDAHUdbM6u+c2uDTGmV
         0jE0EvU2Yl0O9onZuCRLLOgB6vG5toC5EK9HWRWN1UU/W2yc6MGLnFIe0oIjhyoQHaff
         F/4ZrHA7n98b8XTY01TBwP/ai6xgWzOXYG20Zw3hyawOHoU1z3qnJwxJ9JewM2qWpkc9
         9OQA==
X-Forwarded-Encrypted: i=1; AJvYcCUs6WSz0NAtCe9yU4CNiUoN0zqASJE/MN46cIuNREQr4l32xI0zh1xGs7NdoH1G/GJpJMAhBF8Paz80bB6eVxoZSu3ZYSSqQKaXzLh4y1S6lSE1Tl510njhe7yp9o5/svPJj8GYZw==
X-Gm-Message-State: AOJu0YydN0Awnnnkvk+x95H7V82y5M5TalaunO9MrsEAK27kc4lUTLnd
	/RLxiBIffc/PD0w0fKuD7HKOvXt4zjUYYDlHeeBLRxWL5VF5He7Xq7UlSg==
X-Google-Smtp-Source: AGHT+IHyXa4+w8GVhwadFNaevv2fD/ljvpm5R5GPgmS1se8ovEcGPMVXycYGX95hrHuiMhBKrQdNIg==
X-Received: by 2002:a50:d7d4:0:b0:58c:2a57:b1e7 with SMTP id 4fb4d7f45d1cf-5b02000c641mr4999575a12.8.1722261507833;
        Mon, 29 Jul 2024 06:58:27 -0700 (PDT)
Received: from [192.168.42.52] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ac63d4720dsm5829736a12.58.2024.07.29.06.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 06:58:27 -0700 (PDT)
Message-ID: <5fd602d8-0c0b-418a-82bc-955ab0444b1e@gmail.com>
Date: Mon, 29 Jul 2024 14:58:58 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 4/8] io_uring: support SQE group
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240706031000.310430-1-ming.lei@redhat.com>
 <20240706031000.310430-5-ming.lei@redhat.com>
 <fa5e8098-f72f-43c1-90c1-c3eaebfea3d5@gmail.com> <Zp+/hBwCBmKSGy5K@fedora>
 <0fa0c9b9-cfb9-4710-85d0-2f6b4398603c@gmail.com> <ZqIp7/Ci+abGcZLG@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZqIp7/Ci+abGcZLG@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/24 11:33, Ming Lei wrote:
> On Wed, Jul 24, 2024 at 02:41:38PM +0100, Pavel Begunkov wrote:
>> On 7/23/24 15:34, Ming Lei wrote:
...
>>> But grp_refs is dropped after io-wq request reference drops to
>>> zero, then both io-wq and nor-io-wq code path can be unified
>>> wrt. dealing with grp_refs, meantime it needn't to be updated
>>> in extra(io-wq) context.
>>
>> Let's try to describe how it can work. First, I'm only describing
>> the dep mode for simplicity. And for the argument's sake we can say
>> that all CQEs are posted via io_submit_flush_completions.
>>
>> io_req_complete_post() {
>> 	if (flags & GROUP) {
>> 		req->io_task_work.func = io_req_task_complete;
>> 		io_req_task_work_add(req);
>> 		return;
>> 	}
>> 	...
>> }
> 
> OK.
> 
> io_wq_free_work() still need to change to not deal with
> next link & ignoring skip_cqe, because group handling(

No, it doesn't need to know about all that.

> cqe posting, link advance) is completely moved into
> io_submit_flush_completions().

It has never been guaranteed that io_req_complete_post()
will be the one completing the request,
io_submit_flush_completions() can always happen.


struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
{
	...
	if (req_ref_put_and_test(req)) {
		nxt = io_req_find_next(req);
		io_free_req();
	}
}

We queue linked requests only when all refs are dropped, and
the group handling in my snippet is done before we drop the
owner's reference.

IOW, you won't hit io_free_req() in io_wq_free_work() for a
leader unless all members in its group got completed and
the leader already went through the code dropping those shared
ublk buffers.


>> You can do it this way, nobody would ever care, and it shouldn't
>> affect performance. Otherwise everything down below can probably
>> be extended to io_req_complete_post().
>>
>> To avoid confusion in terminology, what I call a member below doesn't
>> include a leader. IOW, a group leader request is not a member.
>>
>> At the init we have:
>> grp_refs = nr_members; /* doesn't include the leader */
>>
>> Let's also say that the group leader can and always goes
>> through io_submit_flush_completions() twice, just how it's
>> with your patches.
>>
>> 1) The first time we see the leader in io_submit_flush_completions()
>> is when it's done with resource preparation. For example, it was
>> doing some IO into a buffer, and now is ready to give that buffer
>> with data to group members. At this point it should queue up all group
>> members. And we also drop 1 grp_ref. There will also be no
>> io_issue_sqe() for it anymore.
> 
> Ok, then it is just the case with dependency.
> 
>>
>> 2) Members are executed and completed, in io_submit_flush_completions()
>> they drop 1 grp_leader->grp_ref reference each.
>>
>> 3) When all members complete, leader's grp_ref becomes 0. Here
>> the leader is queued for io_submit_flush_completions() a second time,
>> at which point it drops ublk buffers and such and gets destroyed.
>>
>> You can post a CQE in 1) and then set CQE_SKIP. Can also be fitted
>> into 3). A pseudo code for when we post it in step 1)
> 
> This way should work, but it confuses application because
> the leader is completed before all members:
> 
> - leader usually provide resources in group wide
> - member consumes this resource
> - leader is supposed to be completed after all consumer(member) are
> done.
> 
> Given it is UAPI, we have to be careful with CQE posting order.

That's exactly what I was telling about the uapi previously,
I don't believe we want to inverse the natural CQE order.

Regardless, the order can be inversed like this:

__io_flush_completions() {
	...
	if (req->flags & (SKIP_CQE|GROUP)) {
		if (req->flags & SKIP_CQE)
			continue;
		// post a CQE only when we see it for a 2nd time in io_flush_completion();
		if (is_leader() && !(req->flags & ALREADY_SEEN))
			continue;
	}
	post_cqe();
}


>> io_free_batch_list() {
>> 	if (req->flags & GROUP) {
>> 		if (req_is_member(req)) {
>> 			req->grp_leader->grp_refs--;
>> 			if (req->grp_leader->grp_refs == 0) {
>> 				req->io_task_work.func = io_req_task_complete;
>> 				io_req_task_work_add(req->grp_leader);
>> 				// can be done better....
>> 			}
>> 			goto free_req;
>> 		}
>> 		WARN_ON_ONCE(!req_is_leader());
>>
>> 		if (!(req->flags & SEEN_FIRST_TIME)) {
>> 			// already posted it just before coming here
>> 			req->flags |= SKIP_CQE;
>> 			// we'll see it again when grp_refs hit 0
>> 			req->flags |= SEEN_FIRST_TIME;
>>
>> 			// Don't free the req, we're leaving it alive for now.
>> 			// req->ref/REQ_F_REFCOUNT will be put next time we get here.
>> 			return; // or continue
>> 		}
>>
>> 		clean_up_request_resources(); // calls back into ublk
>> 		// and now free the leader
>> 	}
>>
>> free_req:
>> 	// the rest of io_free_batch_list()
>> 	if (flags & REQ_F_REFCOUNT) {
>> 		req_drop_ref();
>> 		....
>> 	}
>> 	...
>> }

-- 
Pavel Begunkov


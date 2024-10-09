Return-Path: <io-uring+bounces-3476-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61468996947
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 13:53:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF2F61F244F2
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 11:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3451718DF74;
	Wed,  9 Oct 2024 11:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SIzgBMn/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7031A18E343;
	Wed,  9 Oct 2024 11:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728474782; cv=none; b=NVeA4bL98KwUmIh2Di7iM8bGVo8oBuMjcUobo6qDReUJtCgR6XDKN1heZcPCbkMyqkrR4pW/IjvUtb8ZUq2hlK3oOAThApzYtZOWXj5YGwPYNSIeCx4TSOgsji2jJQPp8Iwl9/f8WaX5WdMqU8ABt6KUByiS5w5gg7/iQrMZkO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728474782; c=relaxed/simple;
	bh=XplJHMsY/rZE5Wb3LR3oWscFaiUId+MmQeZs4dRGmAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MxG8ZwmIvJl+CIZy7AsztoI8JaTpYGRIcH5T4fQWNQJ/DVHJD8VLatmk7FgPgfDT/NSHmiOuzEhCzdKaOL8m3y+SW+Yk0QZkCgruPDuBfAJrsIdU5/yOvtXav9B1hYnLLDGre7AaTfOiwqgGYvWoZLpAn1GdpETOnDjROkkeCu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SIzgBMn/; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-37d3ae4a048so397762f8f.3;
        Wed, 09 Oct 2024 04:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728474779; x=1729079579; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=khhqIPlwJBadfdybhRWW7Y5gqxa03C7W5xOqWI4I2uU=;
        b=SIzgBMn/uCCqajDh7A6KgC1OrYZuOevjzaKO0+GOPBE2tg5pR1iWol/xuhtJe9eQcO
         l0fEOIT5UD4oA4W0ZTGM3rUdyDUrk7T6HwAlWzTvYey+PEr98FaUl4qpBFZZ2bctfAcm
         Zum/nJolxDYhnxEJZgeB4L2dVm5ykDJSuBTCiEvC9JMBP+o/nrxdY/JEnIRJIqufaxWE
         6tXmJ/eaxzIwukQQyqiKZcc34oktI3fPAJCyYZxIiG9W9uSbI5NDzKPwjGT+9y8NElPe
         EbK8aXUqjYEMM1dvrU75hfPj1IrpW3QNkqFMSKi5aZ6I/lJ2AMeYoAYpSj3GN1fbZeUV
         5S0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728474779; x=1729079579;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=khhqIPlwJBadfdybhRWW7Y5gqxa03C7W5xOqWI4I2uU=;
        b=rxT7A6tKARuyiIrpMHr/NFLSGW1IhcTdSB2xRGsrFYpbrMpgrwDGg8kHR3OXI2IvBp
         6+2edyNynRHm5T3fsGaFXCoH72+wXPvZLq2fLXbEIoH2mxyCH1gDidMjlQ8/dta7FcFa
         LDhNNwmgGsX0gjZGxkQF6NW1MHZwjTgYFi6rwBiduQz6wG2JNnCoVtwGpD3yLl8CfCrz
         eFObEJARECW4XRlHOQ3kiLJ5TXdC/eOm15C/EJS4h4bkaeM+LfXO92A8Jh3iL7kz9jWj
         WSR7+Thgf3t8ju3albyjRCzDcFNdGZL8T/yjLWiCIK9vSLdjgoVQk8q70Fk+lCm/5QVk
         FQaQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/ZxPnHlXRMxEdSRi5W2mfzcw551YavT33/B7sGau7Eilw4V7MYmJU2SZIs9sSF+Z8biRKdrw/33kfPFM=@vger.kernel.org, AJvYcCWunWhEypfJj4FHiKKszwn1/jq4mVOEdVXgdmcwE0N7mNz94msyMiDfNeJHY5qxz4KZ5EugE3erLw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyrFmx7iKi+meDFJUvzOzArx7vL9aq7om0lZ8nzoV5gRIgmq243
	o02n0Wz18FMBDK+mC4bYW4B1X8+A+2Aw29dBjC5X6F06IAqLhOAH
X-Google-Smtp-Source: AGHT+IHI0zRDtnW95czknI0HrDmMEsIz4FPF1Ek731FBw+bMwW9CNNDjY3boYvw6SwgYrCf7FfMXGg==
X-Received: by 2002:adf:9b96:0:b0:37c:cf73:4bf7 with SMTP id ffacd0b85a97d-37d3aa2e27dmr1383856f8f.34.1728474778395;
        Wed, 09 Oct 2024 04:52:58 -0700 (PDT)
Received: from [192.168.42.45] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d1690f66csm10218746f8f.13.2024.10.09.04.52.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 04:52:58 -0700 (PDT)
Message-ID: <f6d34a4d-bf46-4120-8e2d-9585912a8867@gmail.com>
Date: Wed, 9 Oct 2024 12:53:34 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 4/8] io_uring: support SQE group
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-5-ming.lei@redhat.com>
 <239e42d2-791e-4ef5-a312-8b5959af7841@gmail.com> <ZwIJ4Hn52-tm22Z8@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZwIJ4Hn52-tm22Z8@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/6/24 04:54, Ming Lei wrote:
> On Fri, Oct 04, 2024 at 02:12:28PM +0100, Pavel Begunkov wrote:
>> On 9/12/24 11:49, Ming Lei wrote:
>> ...
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -111,13 +111,15 @@
>> ...
>>> +static void io_complete_group_member(struct io_kiocb *req)
>>> +{
>>> +	struct io_kiocb *lead = get_group_leader(req);
>>> +
>>> +	if (WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP) ||
>>> +			 lead->grp_refs <= 0))
>>> +		return;
>>> +
>>> +	/* member CQE needs to be posted first */
>>> +	if (!(req->flags & REQ_F_CQE_SKIP))
>>> +		io_req_commit_cqe(req->ctx, req);
>>> +
>>> +	req->flags &= ~REQ_F_SQE_GROUP;
>>
>> I can't say I like this implicit state machine too much,
>> but let's add a comment why we need to clear it. i.e.
>> it seems it wouldn't be needed if not for the
>> mark_last_group_member() below that puts it back to tunnel
>> the leader to io_free_batch_list().
> 
> Yeah, the main purpose is for reusing the flag for marking last
> member, will add comment for this usage.
> 
>>
>>> +
>>> +	/* Set leader as failed in case of any member failed */
>>> +	if (unlikely((req->flags & REQ_F_FAIL)))
>>> +		req_set_fail(lead);
>>> +
>>> +	if (!--lead->grp_refs) {
>>> +		mark_last_group_member(req);
>>> +		if (!(lead->flags & REQ_F_CQE_SKIP))
>>> +			io_req_commit_cqe(lead->ctx, lead);
>>> +	} else if (lead->grp_refs == 1 && (lead->flags & REQ_F_SQE_GROUP)) {
>>> +		/*
>>> +		 * The single uncompleted leader will degenerate to plain
>>> +		 * request, so group leader can be always freed via the
>>> +		 * last completed member.
>>> +		 */
>>> +		lead->flags &= ~REQ_F_SQE_GROUP_LEADER;
>>
>> What does this try to handle? A group with a leader but no
>> members? If that's the case, io_group_sqe() and io_submit_state_end()
>> just need to fail such groups (and clear REQ_F_SQE_GROUP before
>> that).
> 
> The code block allows to issue leader and members concurrently, but
> we have changed to always issue members after leader is completed, so
> the above code can be removed now.

One case to check, what if the user submits just a single request marked
as a group? The concern is that we create a group with a leader but
without members otherwise, and when the leader goes through
io_submit_flush_completions for the first time it drops it refs and
starts waiting for members that don't exist to "wake" it. I mentioned
above we should probably just fail it, but would be nice to have a
test for it if not already.

Forgot to mention, with the mentioned changes I believe the patch
should be good enough.

-- 
Pavel Begunkov


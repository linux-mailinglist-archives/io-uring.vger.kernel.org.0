Return-Path: <io-uring+bounces-1082-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DE7187E227
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 03:33:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B85F71C20D9F
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 02:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F708814;
	Mon, 18 Mar 2024 02:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W5Z1LzL+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AD11C10;
	Mon, 18 Mar 2024 02:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710729210; cv=none; b=OnKQtHpse2mnKHHZfKm6M6/Hb4hxEje+SaD0+AE8yITTQDInF46CE2zhd1tvrE1B0R9q3Vh6lzapmguw2omzDxjjbbeiHNFtr+Ln5Emiv1XZnBf6sLnYWim0fGQZAG3/n2QOMjJJbLJ08dSD1XZYCjRJSFpsls/aKKsI/OSvFsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710729210; c=relaxed/simple;
	bh=xNNpqMv2mXJwS3zBZHsziECKptWwVIDja7lLYo8zFRA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=etfnVmHvOF8JgehLNtQAvHYlMj/dpT3ne6+cXe96cMBr4xLNbZ4FjbMIh2JPn7IVvpjGIHHxIYDdiJHutF4Ao2Y4ICPXGYGU/LYmI2iTcWscJOTmdVfSyHkbQI8ex0Dv9HM7zkQc7Rc2ijUUvF6qaQ692+NM++gHrUXLNddcXa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W5Z1LzL+; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a468226e135so282886266b.0;
        Sun, 17 Mar 2024 19:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710729207; x=1711334007; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yq8Qaq1txH4iGZDPKvcmZFFLbz7f5qa1RKF2XMeOOdo=;
        b=W5Z1LzL+ljRsve9mLl3zu8rJegc6kh/REQNLvwgDuB2EvTxbkkfsVTGVgkhGwMWw+0
         ImWZ7IFfLz7BXoGwZqXt9ETIjuePahmunbvX/fKnGeoB2EldYO3HnasR7b08cnI1j7dm
         6/OSs76osdSPvT/spGvjgrGqVF6edzkvAmoo0GVPNNnXFXCu28Ea3yZFGuViZpbPiaZ6
         vaM0gxV1D7hUAz6NXm/r4dVsmw7t5ZQnWcfVyZdzeQ+VRknNC9kn51l4NlnMSEnexRUF
         W2sphv+P0q7LHw5d1s90zwNZv/eVMprGocu1DpV+sSCn57AD6duyA+5L23AKPicjUxym
         lVrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710729207; x=1711334007;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yq8Qaq1txH4iGZDPKvcmZFFLbz7f5qa1RKF2XMeOOdo=;
        b=DAMXZkjzsDWydQdEy9cp74uPX3Yk6qJJL5RAYKvZ6D+2R6ENSCdEQ7jYVf3MkCQIfu
         0PlOBFE46iFRgg+RQKPDDTedIUHaFDdKw0/bZAW/fgBRHUQixxIIJoDUroTHrWCQDyw3
         oo4DdG+7EeZH1k87lupfXIf2nsAwhC+dA/kK/30vs/1x5k/KLh6DcCn8WcKW8UElAIBP
         IXKcr7KEkzw2reUoi9glFzq+WfCLpKacBq6YgOkXPNwAGCt26GBFpn7Ge9c4bgi/rWQZ
         Q2hYZpTKOfchtvd0Py+xs76xa+xhurk2B8uUT+11NgsgWiVZ3uEHmcOqaQdhhrLHQZdP
         v26g==
X-Forwarded-Encrypted: i=1; AJvYcCVgiuGjCT5bR8EUV4LNj4qL1TmYmCBhw+G94yAPSB8hGe5J7Jd+tDUtmu1V7rZqu9kEYnDDIeRWAT0YT4bTXXkgpw3OVZjdMFk9ebc=
X-Gm-Message-State: AOJu0YwyhHuul3F3bgI7+V4HBolswcUBFFugCphZQtgl7A1r0Pwygi4Y
	ZHGadyYrXxTsjJduw7z9qmoYkoGISXAw6KGPabIjNeuvsXxnQYtHJZ9pSZ7F
X-Google-Smtp-Source: AGHT+IEYEsEobe8YWhrxjDxUjFN+LC5n/EO8bQ9uIgqTEkii4T+VXMFEOztRVhOfG7hD5SUw4GX4Ww==
X-Received: by 2002:a17:906:24da:b0:a46:b111:858b with SMTP id f26-20020a17090624da00b00a46b111858bmr2310436ejb.47.1710729206414;
        Sun, 17 Mar 2024 19:33:26 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id qs28-20020a170906459c00b00a4550e8ae70sm4329851ejc.63.2024.03.17.19.33.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 19:33:26 -0700 (PDT)
Message-ID: <e2167849-8034-4649-9d35-3ab266c8d0d5@gmail.com>
Date: Mon, 18 Mar 2024 02:32:11 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/14] io_uring/cmd: fix tw <-> issue_flags conversion
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <c48a7f3919eecbee0319020fd640e6b3d2e60e5f.1710720150.git.asml.silence@gmail.com>
 <Zfelt6mbVA0moyq6@fedora> <e987d48d-09c9-4b7d-9ddc-1d90f15a1bfe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e987d48d-09c9-4b7d-9ddc-1d90f15a1bfe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/24 02:25, Jens Axboe wrote:
> On 3/17/24 8:23 PM, Ming Lei wrote:
>> On Mon, Mar 18, 2024 at 12:41:47AM +0000, Pavel Begunkov wrote:
>>> !IO_URING_F_UNLOCKED does not translate to availability of the deferred
>>> completion infra, IO_URING_F_COMPLETE_DEFER does, that what we should
>>> pass and look for to use io_req_complete_defer() and other variants.
>>>
>>> Luckily, it's not a real problem as two wrongs actually made it right,
>>> at least as far as io_uring_cmd_work() goes.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> Link: https://lore.kernel.org/r/eb08e72e837106963bc7bc7dccfd93d646cc7f36.1710514702.git.asml.silence@gmail.com
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>

oops, I should've removed all the signed-offs

>>> ---
>>>   io_uring/uring_cmd.c | 10 ++++++++--
>>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>> index f197e8c22965..ec38a8d4836d 100644
>>> --- a/io_uring/uring_cmd.c
>>> +++ b/io_uring/uring_cmd.c
>>> @@ -56,7 +56,11 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
>>>   static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
>>>   {
>>>   	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>>> -	unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
>>> +	unsigned issue_flags = IO_URING_F_UNLOCKED;
>>> +
>>> +	/* locked task_work executor checks the deffered list completion */
>>> +	if (ts->locked)
>>> +		issue_flags = IO_URING_F_COMPLETE_DEFER;
>>>   
>>>   	ioucmd->task_work_cb(ioucmd, issue_flags);
>>>   }
>>> @@ -100,7 +104,9 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
>>>   	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
>>>   		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
>>>   		smp_store_release(&req->iopoll_completed, 1);
>>> -	} else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
>>> +	} else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
>>> +		if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
>>> +			return;
>>>   		io_req_complete_defer(req);
>>>   	} else {
>>>   		req->io_task_work.func = io_req_task_complete;
>>
>> 'git-bisect' shows the reported warning starts from this patch.

Thanks Ming

> 
> That does make sense, as probably:
> 
> +	/* locked task_work executor checks the deffered list completion */
> +	if (ts->locked)
> +		issue_flags = IO_URING_F_COMPLETE_DEFER;
> 
> this assumption isn't true, and that would mess with the task management
> (which is in your oops).

I'm missing it, how it's not true?


static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
{
	...
	if (ts->locked) {
		io_submit_flush_completions(ctx);
		...
	}
}

static __cold void io_fallback_req_func(struct work_struct *work)
{
	...
	mutex_lock(&ctx->uring_lock);
	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
		req->io_task_work.func(req, &ts);
	io_submit_flush_completions(ctx);
	mutex_unlock(&ctx->uring_lock);
	...
}

-- 
Pavel Begunkov


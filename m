Return-Path: <io-uring+bounces-11710-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 18AF2D1FFC2
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 16:56:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6CD5C305A45D
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 15:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD6127EFE3;
	Wed, 14 Jan 2026 15:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eUdAJUFu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f65.google.com (mail-oa1-f65.google.com [209.85.160.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659EC3A0E9A
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 15:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768405853; cv=none; b=Drf95W8P6u/cQVtDrM+qgIwocq6WQohNQ4z9lBiAhpHePIkHa2WBfT7dejDXEB4MVsCw0soeC/kJ7Hu9b6rTM9KRJ4T+pXId3bzroqG9zl0iLEST32wxoh2gnhWO2t52tv+0150pm6xvSHYM1dxiJu6PIRb50RNVh2CgdOzazIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768405853; c=relaxed/simple;
	bh=MPcw16/qKqKQW+hWDgvZUMPJs47TLTNV6gLDmgUtBP8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=IFhVQQa8UL7m2yyv9nVbPYle4QoxqV3aUR5DdTsQ36MVynqMxiGJzm6luxE4BSbsMQHYeXtdDh4I74tcq7lAcqwAQL3kAPywcxlpGJoElYN9LXqiAz2tsubm5b6uthgMGG+yYlg/voQ67eE66L9TGvmORUJxDYCTOSM7yZ5/BLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eUdAJUFu; arc=none smtp.client-ip=209.85.160.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f65.google.com with SMTP id 586e51a60fabf-3f11ad6e76fso6985705fac.1
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 07:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768405848; x=1769010648; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZlHb2lAGU0mzYo9qAxNcMGQmLi7dc7ahf21Uk4JQJ0w=;
        b=eUdAJUFu/KN39XKvVKzTbxlQZkgy01GH37m36j1cCyh4G3c+LxAxW7avNNpFysK8bE
         hmYfrMVsGsFlSGBYxfhHxk+aDN1RlwCRHN3ZKR+f+y7TwmQ044hkmaTJaYQZBzGEr2oT
         Kz6lDDtNKZidsJ729mlSh/3quFoITtlEUAiKxC2BEQZKVq1BVLMKyLJahnh1WBveKrux
         WBSIDtOQQmochfgLVHVOfis+iqenrPui8tPSoKpPmUjdz4TjxRf7zL6kHw+wbn8vj6RA
         98ZoQc/FlTN8NudTHyXiJlr0ahP1A+lpRxow0kozUW7id/ciTW/GGhZyW84xAHq38JoR
         x9aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768405848; x=1769010648;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZlHb2lAGU0mzYo9qAxNcMGQmLi7dc7ahf21Uk4JQJ0w=;
        b=fyB/Drjq6fE69m4Su9pCWGy0D1E7Ij78wjHs+jEwqT4V+NNmnO/6semRed+7SU24B+
         ShEfYZxIjJrXZfzcR/GfmGu3cAszWlvq7vfj/GtS5Kgb86hDTjO8cu3jzu0u8q/3gew+
         34vxJFAJ3xVhUSHS0ZbprbC/BsleTonfama3pYVZ0RKjV3CmbU5StSWX/HtBcgtpAdUy
         nuBiZt3BCq9OdiF138X8oVhDhxjEHlorB6yqbY/hx+gHoJ2ZXea6jPhd5XLp+imSUgOD
         wKJFmjZ4b0nOk8VXvPfSx7EKYyuVOwO01El3qRmLeNzLov5zQXIpD2k5Q3EfmoefQ7ng
         o8wQ==
X-Gm-Message-State: AOJu0YyT5wzOGyoCqvNT6TvIVurdNzEtZbEZXUf/8ASqC8W57WfKg7N0
	voG19S03ISTt4fAd60pGQbRjyZeuYlPSEG/uhJVWueYAHEb/RS74jgLurmUTv0boK0bi0LqXv+6
	Xj9TUQHE=
X-Gm-Gg: AY/fxX6Ilg6M30Hj//RPdoco0Pbj+5Jk7M2jU0aum5wGSnTKO3Qr+7d8dMw5jvq1L0B
	3EMdbHP3XKAbYAgUAf2DHCXpHXsW5U786rYqwlmhWlrxxEpASmQ2HjZpjHX1KlopjTNdn+D3tcQ
	b0ri7lJZ6db7ejvZB+R5xqTxKkCsVgCnQN9AnO2LH5vhtWG2ib/DgiA0bhQa/UdJ5SJYT47tGPd
	Zn/oyjXPEOO129zu3ya4K8oHTl8r/wSKg8m57PdbtQU/84dduCn5F35cqSEx7dApxNUqKExPhq6
	ssf3mBS6E05Uus1CXTquApJpjGQ1Bxdrj76U3BBHZ223dCehnrnFvW10cH/2QjnTVdap78p6zKP
	aCfRRa7/vVZnhOPv97S3QJaiz9Oa1c497WFwPovazG87L4j4mTwgfVk18LQJ3KWQj+jY0SbgDk8
	v+mzVejcP8aBvpcoUYow==
X-Received: by 2002:a05:6870:6489:b0:3e8:44ec:3416 with SMTP id 586e51a60fabf-404071a8a2fmr2074610fac.46.1768405847662;
        Wed, 14 Jan 2026 07:50:47 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4040997ffacsm1762110fac.6.2026.01.14.07.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 07:50:46 -0800 (PST)
Message-ID: <69f78c7d-f332-4b16-be44-532b8a98ab57@kernel.dk>
Date: Wed, 14 Jan 2026 08:50:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix IOPOLL with passthrough I/O
From: Jens Axboe <axboe@kernel.dk>
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring <io-uring@vger.kernel.org>, Yi Zhang <yi.zhang@redhat.com>
References: <b60cab06-92ad-467b-b512-1e76ec5e970e@kernel.dk>
 <aWe2-iz6eaIyuIZl@fedora> <af727108-b20a-45b0-b46c-07244be4cacb@kernel.dk>
Content-Language: en-US
In-Reply-To: <af727108-b20a-45b0-b46c-07244be4cacb@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/26 8:33 AM, Jens Axboe wrote:
> On 1/14/26 8:32 AM, Ming Lei wrote:
>> On Wed, Jan 14, 2026 at 08:12:15AM -0700, Jens Axboe wrote:
>>> A previous commit improving IOPOLL made an incorrect assumption that
>>> task_work isn't used with IOPOLL. This can cause crashes when doing
>>> passthrough I/O on nvme, where queueing the completion task_work will
>>> trample on the same memory that holds the completed list of requests.
>>>
>>> Fix it up by shuffling the members around, so we're not sharing any
>>> parts that end up getting used in this path.
>>>
>>> Fixes: 3c7d76d6128a ("io_uring: IOPOLL polling improvements")
>>> Reported-by: Yi Zhang <yi.zhang@redhat.com>
>>> Link: https://lore.kernel.org/linux-block/CAHj4cs_SLPj9v9w5MgfzHKy+983enPx3ZQY2kMuMJ1202DBefw@mail.gmail.com/
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> ---
>>>
>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>> index e4c804f99c30..211686ad89fd 100644
>>> --- a/include/linux/io_uring_types.h
>>> +++ b/include/linux/io_uring_types.h
>>> @@ -713,13 +713,10 @@ struct io_kiocb {
>>>  	atomic_t			refs;
>>>  	bool				cancel_seq_set;
>>>  
>>> -	/*
>>> -	 * IOPOLL doesn't use task_work, so use the ->iopoll_node list
>>> -	 * entry to manage pending iopoll requests.
>>> -	 */
>>>  	union {
>>>  		struct io_task_work	io_task_work;
>>> -		struct list_head	iopoll_node;
>>> +		/* For IOPOLL setup queues, with hybrid polling */
>>> +		u64                     iopoll_start;
>>>  	};
>>>  
>>>  	union {
>>> @@ -728,8 +725,8 @@ struct io_kiocb {
>>>  		 * poll
>>>  		 */
>>>  		struct hlist_node	hash_node;
>>> -		/* For IOPOLL setup queues, with hybrid polling */
>>> -		u64                     iopoll_start;
>>> +		/* IOPOLL completion handling */
>>> +		struct list_head	iopoll_node;
>>>  		/* for private io_kiocb freeing */
>>>  		struct rcu_head		rcu_head;
>>
>> ->hash_node is used by uring_cmd in
>> io_uring_cmd_mark_cancelable()/io_uring_cmd_del_cancelable(), so this
>> way may break uring_cmd if supporting iopoll and cancelable in future.
> 
> We don't support cancelation on requests that go via the block stack,
> never have and probably never will. But I should make a comment about
> that, just in case...

Should be trivial enough to just explicitly disallow it.

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 197474911f04..ee7b49f47cb5 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -104,6 +104,15 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
 	struct io_ring_ctx *ctx = req->ctx;
 
+	/*
+	 * Doing cancelations on IOPOLL requests are not supported. Both
+	 * because they can't get canceled in the block stack, but also
+	 * because iopoll completion data overlaps with the hash_node used
+	 * for tracking.
+	 */
+	if (ctx->flags & IORING_SETUP_IOPOLL)
+		return;
+
 	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE)) {
 		cmd->flags |= IORING_URING_CMD_CANCELABLE;
 		io_ring_submit_lock(ctx, issue_flags);

-- 
Jens Axboe


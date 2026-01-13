Return-Path: <io-uring+bounces-11616-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 30A92D1AD45
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 19:25:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2F7973035CCF
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 18:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6775234C130;
	Tue, 13 Jan 2026 18:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SsneDylE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FCA34BA24
	for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 18:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768328719; cv=none; b=qxR20zjZgE05Tn0rwNs10MLi5gp/Tf6nFxtc5eQ723yVSdmtk2YydhxBfUaeey5nUgsfHv7nwD706IrAcGQDOLWyYCf9b1hG80XddfauOQbtuxpeUog6LW1pzZluCxAAsfDqe8jUvQQve0S4xzEeIAWn/BkzV8r/T3GGHCcPK8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768328719; c=relaxed/simple;
	bh=BrsXlA/Ot9vtNu38RwOECNnftPpDlBBu2opUEotv63I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ltGcmpW+Eb69PCtRvSze9I1Cjd0KFli/TAYRQNLbkDLmYkAPNzxYSADjXwYATYKNeb4/7qi5lf/f5gT+bjUw0m8gIQMy4fUExHWHmNP7azspGERx3w/Umj3mqJ4PKPaXexW0rqifzxDkFuVDvifHKNMmadI6FGAinsYxZTzPVSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SsneDylE; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-65f59501dacso3998028eaf.0
        for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 10:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768328717; x=1768933517; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RDYaBbSALKBkavcRZEziw7nZlMV403DCZVV8+rolhcQ=;
        b=SsneDylERxkbOuhbqQ6vJ8r71WO/FzyecPD7F4oJlLXD8gKo5jJf3iljRzTYPRuj6E
         KukMaPQFzyT6RSWNTXBg3NMXtGmHU+DXDBHWvPmcKblR9/5Jghx6AxZqI5VEualJgvxs
         xKoLzYPvfWLIo8Stw8W9EmL//rEepzfB6BvqqqxdX3PD2n45Zg5yZCrTqrw8qeMuDqma
         H6OjvLrZjGuWmVfDmCthNJQX3C/2kUWLKVo+sw5P98bRgWGMfnEx6un94Hk3I3SVEAkj
         u9vpJyAh/DLNrEdXvi+rFCksCtE6ZUwSs6AE9haYMKE+GcQkiT1M4Rppm/vEszw2DGkU
         +pUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768328717; x=1768933517;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RDYaBbSALKBkavcRZEziw7nZlMV403DCZVV8+rolhcQ=;
        b=gkHXFOnIdqGSLGSsRn7knWMZZMUUI1qHUaX7phISdDnXwkuNwP2d1HCBj7IciFUzSB
         +jsqQV4qMfFnqEig6t6q6qlhKsv1S9dx6idp9Xdk1weXZ0kKjbyAqB0JiyvQXnX8C+pt
         Tt9dY5WvvOBipljpDSG9xer31qdnpdhaiv5BebWz6GJG0yJ0g4vnjdBFDIGhBbxItTrU
         68CGdmJfUo3hV2lUBuNXcOT8Ljzhqh7je4D7FBvdCWvkMKOcNOCpeQWPbXPFxkWIkMdP
         HC53dkfqf1daKGpdgFAmYOToQ+vVO3LDPDy0gizZGhIjWpIxsuQEiPZp8+NgU2sUuJc/
         BA9Q==
X-Gm-Message-State: AOJu0YzC3+eCpB8WKDDnq7ZzODj9qOqCwZDHspl738lZu+FbnuUjvaYS
	zR/8p+OJ3s+v9mXwEXTcHNA3944GdOvytTul0oBOC4yoFSK92WfOjh8sZ1tiZBiXlos=
X-Gm-Gg: AY/fxX5U2UoQNzYBx3UEa0TSOOYZWwHtUtvM/vGOxa0Lxe9f1FBI6+Lml850Fg2G0I8
	Dg5Gj+m2csUvF59wvEFK0QM+sA+pYSlZ7fXFzUAoTGjNnW2Fh8aWCgcJMLmY8qD1eKo9G8u8D7C
	iKizi55gI4xkuwpy6ZHXbEsTRWMYn0+HNaWSYu2KJp/vQuuxZwgkt5cFft2I2kwNKE0vp6qb+Yo
	C8ettQYAo1MCY9eFzV46m7p0TzSEGSojuB31rHzgJqWQUiGDV9qtVKF2uaqvHOwXIeejEoW0xVu
	U+UepxDNt5HemiXCzmhy0l2y9pYDSyiIShETu2S3MBTpm5PvRnlZNvmawsc4gSZkqcail5oypM7
	/EEFX6/Z5C8+P8G9cDfhdSYcpNzkrPt5y2YHkGki3KU9r8kTPlEtjB6slPpQDQVtgPw2thjG2hj
	VboNDdbz5MJPdP7ZSN6A==
X-Received: by 2002:a05:6820:2216:b0:659:9a49:8eaa with SMTP id 006d021491bc7-661006cd14emr74254eaf.46.1768328716785;
        Tue, 13 Jan 2026 10:25:16 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4de539bsm14245769fac.4.2026.01.13.10.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 10:25:16 -0800 (PST)
Message-ID: <fa2d0d7f-adbc-4e5e-a9d8-9a170ade8eaa@kernel.dk>
Date: Tue, 13 Jan 2026 11:25:15 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring/register: allow original task restrictions
 owner to unregister
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20260109185155.88150-1-axboe@kernel.dk>
 <20260109185155.88150-4-axboe@kernel.dk> <877btm4bko.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <877btm4bko.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/12/26 5:10 PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Currently any attempt to register a set of task restrictions if an
>> existing set exists will fail with -EPERM. But it is feasible to let the
>> original creator/owner performance this operation. Either to remove
>> restrictions entirely, or to replace them with a new set.
>>
>> If an existing set exists and NULL is passed for the new set, the
>> current set is unregistered. If an existing set exists and a new set is
>> supplied, the old set is dropped and replaced with the new one.
> 
> Feature-wise, I think this covers what I mentioned in the previous
> iteration.  Even though this is an RFC, I think I found two bugs that
> allow the child to escape the restrictions:
> 
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  include/linux/io_uring_types.h |  1 +
>>  io_uring/register.c            | 45 ++++++++++++++++++++++++++++------
>>  2 files changed, 38 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 196f41ec6d60..1ff7817b3535 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -222,6 +222,7 @@ struct io_rings {
>>  struct io_restriction {
>>  	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
>>  	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
>> +	pid_t pid;
>>  	refcount_t refs;
>>  	u8 sqe_flags_allowed;
>>  	u8 sqe_flags_required;
>> diff --git a/io_uring/register.c b/io_uring/register.c
>> index 552b22f6b2dc..c8b8a9edbc65 100644
>> --- a/io_uring/register.c
>> +++ b/io_uring/register.c
>> @@ -189,12 +189,19 @@ static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
>>  {
>>  	struct io_uring_task_restriction __user *ures = arg;
>>  	struct io_uring_task_restriction tres;
>> -	struct io_restriction *res;
>> +	struct io_restriction *old_res, *res;
>>  	int ret;
>>  
>>  	if (nr_args != 1)
>>  		return -EINVAL;
>>  
>> +	res = current->io_uring_restrict;
>> +	if (!ures) {
>> +		if (!res)
>> +			return -EFAULT;
>> +		goto drop_set;
>> +	}
>> +
>>  	if (copy_from_user(&tres, arg, sizeof(tres)))
>>  		return -EFAULT;
>>  
>> @@ -207,13 +214,27 @@ static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
>>  	 * Disallow if task already has registered restrictions, and we're
>>  	 * not passing in further restrictions to add to an existing set.
>>  	 */
>> -	if (current->io_uring_restrict &&
>> -	    !(tres.flags & IORING_REG_RESTRICTIONS_MASK))
>> -		return -EPERM;
>> +	old_res = NULL;
>> +	if (res && !(tres.flags & IORING_REG_RESTRICTIONS_MASK)) {
>> +		/* Not owner, may only append further restrictions */
>> +drop_set:
>> +		if (res->pid != current->pid)
>> +			return -EPERM;
> 
> This might be hard to exploit, but if the parent terminates, the pid
> can get reused.  Then, if the child forks until it gets the same pid,
> it can unregister the filter.  I suppose the fix would require holding
> a reference to the task, similar to what pidfd does. but perhaps just
> abandon the unregistering semantics?  I'm not sure it is that
> useful...

I did ponder pid reuse and considered it not an issue due to the size of
the space. But from other feedback, seems like unregistering is not a
good idea anyway, should always be cummultative. There's a valid use
case where the task is forked up front, then restrictions registered,
and then exec. We can't allow unregistering for that case.

So I think I'll just drop this particular patch for now. It's also why I
kept it separate...

>> @@ -226,14 +247,22 @@ static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
>>  				    tres.flags & IORING_REG_RESTRICTIONS_MASK);
>>  	if (ret) {
>>  		kfree(res);
>> -		return ret;
>> +		goto out;
>>  	}
>>  	if (current->io_uring_restrict &&
>>  	    refcount_dec_and_test(&current->io_uring_restrict->refs))
>>  		kfree(current->io_uring_restrict);
>> +	res->pid = current->pid;
> 
> res->pid must always point to the first task that added a
> restriction. So:
> 
> if (!current->io_uring_restrict)
>        res->pid = current->pid;
> 
> Otherwise, the child will become the owner after adding another
> restriction, and can then break out with a further unregister.  Based on
> your testcase, this escapes the filter:

Thanks for looking at that too, but I guess moot with it getting
dropped. But yes I do think you're right!

-- 
Jens Axboe


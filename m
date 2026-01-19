Return-Path: <io-uring+bounces-11819-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 87836D3B817
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 21:17:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 86C703009273
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 20:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 746BA224AED;
	Mon, 19 Jan 2026 20:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hxJQTqfh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084E921FF26
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 20:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768853862; cv=none; b=GP4dEBwxEogoNAUDbqdz7TtLnQCMpAzuia4m79Othn46yhUFVdPTCo2vz0WW0ki4TTit1jjNZxtFI4eF1vFLU8ppweKlyhqaCIs+8/54iSbV0ghQfM03Ew1UAG8lIlst4KXb3sIdGG3F9ZbIcmg7t4eKh7ph9qcV4Npp9UYysiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768853862; c=relaxed/simple;
	bh=SL1e72o5kSRG/TLc8DsbjEHVlFbHO7rxOqk5xp8vluc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oXKp2wFwtWy0l7mQBhlONMWCgkktwY4dQvpya+3Sqybo1YNxbC6jLgL0GLY6HkxSRXWaPEXxFVAEwSpdeWmRD/SJXeVn6q+jrNSmTwRLxO9vhTkIlU4Txc2Q6QJ78O5HigoHHvyLSb4AjGmJvbi1of/igCELorGgYaRWTmBthtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hxJQTqfh; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7cfd0f349c4so2948265a34.1
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 12:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768853859; x=1769458659; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pRsVU3ap76NzpGsj1VY7kfU+YqDW/CfUYOJe9pBTDTg=;
        b=hxJQTqfh945Djh1zh+oLEys9cRVXtfFflJT1pwEuIWFohE2o7/rmQTy14f1RB/7Did
         56r1Q7FPeyxb6I0mw/ROj+65+fOJizKBXVzeO0ISnOphdrVbsXNO7ydZszvLU5I+I+/y
         jId5lF9QVF6hu34nosJ8F0N375DPrQZGQenKLVIckVMEt2B2WOWzCc/GTngmMyTJiOMw
         L17Gp3najCVorbdizkczWlbAlz28XX9oAR1GB71akcmxE02a0P+kHDpmwKgXWO9yD0mQ
         cstrJV+OINKueMO7e1sZwIbFZdtacbmtJMvgc5ziOUnlrLuqqpCi5Jzy/B9jnsie6Kgk
         4quQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768853859; x=1769458659;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pRsVU3ap76NzpGsj1VY7kfU+YqDW/CfUYOJe9pBTDTg=;
        b=h/rR/filK8yRxl3o6YwYSZcDSdCpAt+s6HKFLdtuc4URsQiQ5OU/qPMQUBjxWTEV1T
         9BU5ECXZnYkF9nyZjyRQL4jX1Bd5lEF3n3S/UYSqMt3t1vRyuf5y6oeLotN7QtEoUPH1
         pYFkem6Jxgvt31QwBKRAiXSixEVH9UAvBZQhf58d4TRA1Dm+xrdVKDYryx0xjt9dDwSk
         oWTXRq6JVPvHPqAUONlsY/VvJgvV94Ohkp+SxtxqqM/WKTqECzDe83WnMtRqMC+w3NQ4
         1Hckq6reRDBV6N5Z8+sc+cufNtIpfPo8BfYRBbZncEfqVIeBFWzu8VnNcx4ZZ29aOoQv
         hrRg==
X-Gm-Message-State: AOJu0YzxjJIkZz+wmbJxU/a9twDwK/ql9LHlqnv2ddSnNOKqK6rBLj9+
	TywG2iN+qY1oiotlCQ4JUAiZu6//+PmonE9OhA4fE/hyrX9LMys+toRS4A8qeZrD9t4=
X-Gm-Gg: AY/fxX5f0713qGX0BX0L2CPdsLbGKyBLpvL+3cqyz8m+M/7oI1Ui3od3/MthJe3YRSM
	JY43Ecj0o8jOcnPtWG0iNXyaJ6jN9fuTf97ARt4ytjuW0levVG9Nz2cOG33PG6rHCLS3JaR0CnH
	5b7GFJ6FP985qZNKuRxkgkjdQu8UNRDfMOxFun8C5j+24TAgR0ls81ogjLGwJCctf3pawnTxamc
	axtqVkPOSjPWgWXiMAWdsmV2qNDsemrhybZmoMLJ+lEHUM9Cj8QdlEGXtcs10QElU2E7CZB5DBf
	4v8H7SLWo14TXUvxxtXItzhi5CWyA5dW2zXNGPnzdeVEvaDZ1QxaWGu0WiOJe3JpHEw6Ics5FP9
	jEtUosebWF+kaKwlyMjnD1/BpUSFWyCosDEPW0Ol+GzXoSgo0TBw32eimoxZZ+rxjBg2jhYm62k
	admwIRf1GTao5Ei6MatjpsGfZICe9awbCtIHhkDQfeEaQ1har/57sNA8L8baOBOGcEm+mJIO40t
	LKH86fc
X-Received: by 2002:a05:6830:2a91:b0:7cf:dd0c:2ba6 with SMTP id 46e09a7af769-7cfdee132acmr4752158a34.22.1768853858742;
        Mon, 19 Jan 2026 12:17:38 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2a5f0dsm7308640a34.24.2026.01.19.12.17.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 12:17:38 -0800 (PST)
Message-ID: <74c9786a-e9a1-4760-ade8-541a58c296cd@kernel.dk>
Date: Mon, 19 Jan 2026 13:17:37 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] io_uring: add support for BPF filtering for opcode
 restrictions
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: io-uring@vger.kernel.org, brauner@kernel.org, Kees Cook
 <kees@kernel.org>, Jann Horn <jannh@google.com>
References: <20260118172328.1067592-1-axboe@kernel.dk>
 <20260118172328.1067592-2-axboe@kernel.dk>
 <2026-01-19-tinted-shifty-storage-skulls-4614XX@cyphar.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2026-01-19-tinted-shifty-storage-skulls-4614XX@cyphar.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/19/26 11:51 AM, Aleksa Sarai wrote:
> On 2026-01-18, Jens Axboe <axboe@kernel.dk> wrote:
>> This adds support for loading BPF programs with io_uring, which can
>> restrict the opcodes executed. Unlike IORING_REGISTER_RESTRICTIONS,
>> using BPF programs allow fine grained control over both the opcode in
>> question, as well as other data associated with the request. This
>> initial patch just supports whatever is in the io_kiocb for filtering,
>> but shortly opcode specific support will be added.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  include/linux/io_uring_types.h           |   9 +
>>  include/uapi/linux/io_uring.h            |   3 +
>>  include/uapi/linux/io_uring/bpf_filter.h |  47 ++++
>>  io_uring/Kconfig                         |   5 +
>>  io_uring/Makefile                        |   1 +
>>  io_uring/bpf_filter.c                    | 328 +++++++++++++++++++++++
>>  io_uring/bpf_filter.h                    |  42 +++
>>  io_uring/io_uring.c                      |   8 +
>>  io_uring/register.c                      |   8 +
>>  9 files changed, 451 insertions(+)
>>  create mode 100644 include/uapi/linux/io_uring/bpf_filter.h
>>  create mode 100644 io_uring/bpf_filter.c
>>  create mode 100644 io_uring/bpf_filter.h
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 211686ad89fd..37f0a5f7b2f4 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -219,9 +219,18 @@ struct io_rings {
>>  	struct io_uring_cqe	cqes[] ____cacheline_aligned_in_smp;
>>  };
>>  
>> +struct io_bpf_filter;
>> +struct io_bpf_filters {
>> +	refcount_t refs;	/* ref for ->bpf_filters */
>> +	spinlock_t lock;	/* protects ->bpf_filters modifications */
>> +	struct io_bpf_filter __rcu **filters;
>> +	struct rcu_head rcu_head;
>> +};
>> +
>>  struct io_restriction {
>>  	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
>>  	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
>> +	struct io_bpf_filters *bpf_filters;
>>  	u8 sqe_flags_allowed;
>>  	u8 sqe_flags_required;
>>  	/* IORING_OP_* restrictions exist */
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index b5b23c0d5283..94669b77fee8 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -700,6 +700,9 @@ enum io_uring_register_op {
>>  	/* auxiliary zcrx configuration, see enum zcrx_ctrl_op */
>>  	IORING_REGISTER_ZCRX_CTRL		= 36,
>>  
>> +	/* register bpf filtering programs */
>> +	IORING_REGISTER_BPF_FILTER		= 37,
>> +
>>  	/* this goes last */
>>  	IORING_REGISTER_LAST,
>>  
>> diff --git a/include/uapi/linux/io_uring/bpf_filter.h b/include/uapi/linux/io_uring/bpf_filter.h
>> new file mode 100644
>> index 000000000000..14bd5b7468a7
>> --- /dev/null
>> +++ b/include/uapi/linux/io_uring/bpf_filter.h
>> @@ -0,0 +1,47 @@
>> +/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
>> +/*
>> + * Header file for the io_uring BPF filters.
>> + */
>> +#ifndef LINUX_IO_URING_BPF_FILTER_H
>> +#define LINUX_IO_URING_BPF_FILTER_H
>> +
>> +#include <linux/types.h>
>> +
>> +struct io_uring_bpf_ctx {
>> +	__u8	opcode;
>> +	__u8	sqe_flags;
>> +	__u8	pad[6];
>> +	__u64	user_data;
>> +	__u64	resv[6];
>> +};
> 
> I had more envisioned this as operating on SQEs directly, not on an
> intermediate representation.
> 
> I get why this is much simpler to deal with (operating on the SQE
> directly is going to be racy as a malicious process could change the
> argument values after the filters have run -- this is kind of like the
> classic ptrace-seccomp hole), but since SQEs are a fixed size it seems
> like the most natural analogue to seccomp's model.
> 
> While it is a tad ugly, AFAICS (looking at io_socket_prep) this would
> also let you filter socket(2) directly which would obviate the need for
> the second patch in this series.

It fundamentally cannot operate on the sqe directly, exactly for the
reasons you outline. We need to move the data to stable storage first,
which is why I did it that way. It has to be done past the prep stage
for that reason.

> That being said, if you do really want to go with a custom
> representation, I would suggest including a size and making it variable

There's no other choice than going with a custom representation...

IHMO it also makes it much cleaner. You really don't want filters
dealing with the intricasies of SQE layout. For custom opcode filters,
they become much easier to reason about if they are working with a
sub-struct in the union.

> size so that filtering pointers (especially of extensible struct
> syscalls like openat2) is more trivial to accomplish in the future. [1]
> is the model we came up with for seccomp, which suffers from having to
> deal with arbitrary syscall bodies but if you have your own
> representation you can end up with something reasonably extensible
> without the baggage.
> 
> [1]: https://www.youtube.com/watch?v=CHpLLR0CwSw

I'll take a look at that - fwiw, another reason why we need a custom
struct is precisely so we can filter on things that need to be brought
into the kernel first. Things like open_how for openat2 variants, for
example. Otherwise this would not be possible. We can do that in a clean
way, and never have to deal with any kind of pointers.


>> +enum {
>> +	/*
>> +	 * If set, any currently unset opcode will have a deny filter attached
>> +	 */
>> +	IO_URING_BPF_FILTER_DENY_REST	= 1,
>> +};
>> +
>> +struct io_uring_bpf_filter {
>> +	__u32	opcode;		/* io_uring opcode to filter */
>> +	__u32	flags;
>> +	__u32	filter_len;	/* number of BPF instructions */
>> +	__u32	resv;
>> +	__u64	filter_ptr;	/* pointer to BPF filter */
>> +	__u64	resv2[5];
>> +};
> 
> Since io_uring_bpf_ctx contains the opcode, it seems a little strange
> that you would require userspace to set up a separate filter for every
> opcode they wish to filter. seccomp lets you just have one filter for
> all syscall numbers -- I can see the argument that this lets you build
> optimised filters for each opcode but having to set up filters for 65
> opcodes (at time of writing) seems less than optimal...

I agree it's a bit cumbersome. But if you just want to filter a specific
opcode, that's easily doable with the current non-bpf restrictions. You
only really need the BPF filter if you want to allow an ocpode, but
restrict certain parts of it.

> The optimisation seccomp uses for filters that simply blanket allow a
> syscall is to pre-compute a cached bitmap of those syscalls to avoid
> running the filter for those syscalls (see seccomp_cache_prepare). That
> seems like a more practical solution which provides a similar (if not
> better) optimisation for the allow-filter case.

But I don't think useful in this case, as there's already an existing
mechanism to do that in io_uring. And with this patch, particularly the
last patch, those can also get set per task and inherited, so that any
new ring will abide by them.

>> +	/*
>> +	 * Iterate registered filters. The opcode is allowed IFF all filters
>> +	 * return 1. If any filter returns denied, opcode will be denied.
>> +	 */
>> +	do {
>> +		if (filter == &dummy_filter)
>> +			ret = 0;
>> +		else
>> +			ret = bpf_prog_run(filter->prog, &bpf_ctx);
>> +		if (!ret)
>> +			break;
>> +		filter = filter->next;
>> +	} while (filter);
> 
> I understand why you didn't want to replicate the messiness of seccomp's
> arbitrary errno feature (it's almost certainly for the best), but maybe
> it would be prudent to make the expected return values some special
> (large) value so that you have some wiggle room for future expansion?
> 
> For instance, if you ever wanted to add support for logging (a-la
> SECCOMP_RET_LOG) then it would need to be lower priority than blocking
> the operation and you would need to have something like the logic in
> seccomp_run_filters to return the highest priority filter return value.
> 
> (You could validate that the filter only returns IO_URING_BPF_RET_BLOCK
> or 0 in the verifier.)

Can't you just do that with any value? 0 is currently DENY, 1 is ALLOW,
those are the only documented filter return values. You could just have
2 be DENY_LOG or whatever, and 3 be ALLOW_LOG and so forth. Don't really
see why you'd need to limit yourself to 0..1 as it currently stands.

>> +int io_register_bpf_filter(struct io_restriction *res,
>> +			   struct io_uring_bpf __user *arg)
>> +{
>> +	struct io_bpf_filter *filter, *old_filter;
>> +	struct io_bpf_filters *filters;
>> +	struct io_uring_bpf reg;
>> +	struct bpf_prog *prog;
>> +	struct sock_fprog fprog;
>> +	int ret;
>> +
>> +	if (copy_from_user(&reg, arg, sizeof(reg)))
>> +		return -EFAULT;
>> +	if (reg.cmd_type != IO_URING_BPF_CMD_FILTER)
>> +		return -EINVAL;
>> +	if (reg.cmd_flags || reg.resv)
>> +		return -EINVAL;
>> +
>> +	if (reg.filter.opcode >= IORING_OP_LAST)
>> +		return -EINVAL;
>> +	if (reg.filter.flags & ~IO_URING_BPF_FILTER_FLAGS)
>> +		return -EINVAL;
>> +	if (reg.filter.resv)
>> +		return -EINVAL;
>> +	if (!mem_is_zero(reg.filter.resv2, sizeof(reg.filter.resv2)))
>> +		return -EINVAL;
>> +	if (!reg.filter.filter_len || reg.filter.filter_len > BPF_MAXINSNS)
>> +		return -EINVAL;
> 
> Similar question to my other mail about copy_struct_from_user().

Ah missed that in the other email. It'd help a lot if you trim your
replies and only quote relevant parts, it's a lot more efficient. And
makes it much harder not to miss content. Sure we can use
copy_struct_from_user().

-- 
Jens Axboe


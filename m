Return-Path: <io-uring+bounces-11942-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WJVhJKTqeGmHtwEAu9opvQ
	(envelope-from <io-uring+bounces-11942-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 17:41:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22D2A97DF6
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 17:41:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EA29630022E3
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 16:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB04534F48F;
	Tue, 27 Jan 2026 16:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wWqnFRqs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A808334D4F6
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 16:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769532065; cv=none; b=FGesZ/yPwKOxUMtUjrWVNqWkCCswUyK+ZB6vvzmhpbvJJmqTK7codxNMJj4qDBNAcZH52jQDdzwF/qQMgluzcOqmTDMBaRusMHTxDKQCzHQkloBwNsYmjwV0VT8xy8b5qLk++bSYN0ay4oyrTER91JKbNu9w/oy9oxOIWvgfyEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769532065; c=relaxed/simple;
	bh=Pw3Os9PF7gqvDxTsWGbh3HWYcMCVNWCGn4yurqe2NFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FwTEqKf4H+9mF9CDMkeeYkojTjrajkmQf1YuQIkqwvhMBptHY4TXK9kJ34uHWjr7960eXyWUMjJuvhqd3qpNj6A3JXxEH2QAb4syIOUvT94czGDqvFdsxE7DFqZq3nGrxdZOFqfv8gNFq3LwgfX/3OaJAWdBDkfG80/vohnVAhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wWqnFRqs; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-124a635476fso620130c88.0
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 08:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769532062; x=1770136862; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S0nHU0IFRxLKlodBkKGRRT1wMjTIExYPnjSNEjOhX9c=;
        b=wWqnFRqsPan51ETdW30CI5y2KuMVtCC31vHey6Svjxv4QyHqLL5oqI+PPQI+POTdBE
         HQHKowYacJdci6i26DgVa/UtiWXlMvdTEYBaLZlEd1c1pdf0RdBfYUoF62o8DUxODazp
         DTjJySxqRc4YZnZfbebeOA/3Wx0RWyK/MLjvVOwLZCxDBzyPCKeReaFRCyjjGgkl5sF/
         AZ3phP1CeKdeI87IGJAiudIr4drucgHa6Ev0I4WYzWoMmKNXj0Q5Bs+o7tcWZWt2LUco
         waUrXKx9sVMJy+kSU+vGUyKMc9SAkk2V3mtZXjwN8jzNDjED1UmeqgUBP5hkJhahZrQ7
         VXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769532062; x=1770136862;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S0nHU0IFRxLKlodBkKGRRT1wMjTIExYPnjSNEjOhX9c=;
        b=YlQ0aPPM79TV92yRNscDMxCvF/8PbCpq0NO6P5Bm83FtcN8Vzu3A0kCYcJzxHAohfo
         w/bYihIf4eaO/ym7UZ8TQn36aLiLlQSSLXIBGe/tAQCabpCsr49ygUilG+NidUK2p0kT
         v5+ecGfMenbwAZ1xwnlTP2iO8rCY8oKJwiSdER9Oyb/6u0DXLDfG3UcP52I8IUuMHXU3
         X6OcvJ9lVY65X9FQElDivkbQorcZj6TAyQfdzHSki/K78pFFTcJ+mY2f1PO7LiYc0TyN
         9pZ6kEbcEMCzoHYf7qPOGas1QnnEY5h97H/7lNrAnUyxZY2gNDDWePvYwE3RhkXd1w/2
         3gjw==
X-Gm-Message-State: AOJu0YwaSxlj7crpm34VLrsdnsyRiurCh5y76vjmwFrIlHi+XNGeqiGu
	hYDYhjKPo6J+qMh3y3IZSu20ZndhPUP2GFIZvr7BnkQJjVRX6dLtIfG9GObcP4qU+k0=
X-Gm-Gg: AZuq6aL18h7OMi1EAMMvhiUGpGWJ7+zyY4nq1M1WHF/sVTatrLnHBnlMXQHlUCxYvCX
	5oM8UdfvxO5CdcHAaw8DShHdSAEJDbfg2xT0O4+ovYn9vL0DqCaZh0NgIGLpeOWJsdxwP2WjfSv
	7o0hYZ2NxULLE0faEOq0XrgFH9i9Hlx5lb5eMHD+0e5udNPh7cWSXUZdfn3mqDZv+eTuz3r412I
	OB2y3fToFNEFktuhALEHr1kVU7k0MubitTKFEcQx5l9jFjjE9WePXfcwyKEXSsWMYe89luhUbHa
	AJUsX3uw5slGxeinli4gnJeGaRXcrZUxrl9FD6E3G+YtXWbFXJHFK8Yupc0p+wL3dbrbAqtu8Oj
	YYhzOz1cqemc1d4nsr8XgD5wTGzGnyzERhVuW/kbEGMmNw85pEw+s9jhnbwtt9V2AoYY1rQYwR/
	tSFS7pSSyuOMBWVRPUwhuabtrgJwshHhOhC6ERghD/vS5sGeEY0C1ZZJsCbRCLOqpXvAOc38MMN
	8EcXw==
X-Received: by 2002:a05:7022:24a9:b0:119:e55a:9c08 with SMTP id a92af1059eb24-124a0114330mr1338340c88.36.1769532062128;
        Tue, 27 Jan 2026 08:41:02 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:122::1:58f5? ([2620:10d:c090:600::cedf])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b742c4043asm16018489eec.34.2026.01.27.08.41.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jan 2026 08:41:01 -0800 (PST)
Message-ID: <269f6e6a-362f-4ccf-926f-2e2e0c1ea014@kernel.dk>
Date: Tue, 27 Jan 2026 09:41:00 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] io_uring: add support for BPF filtering for opcode
 restrictions
To: Christian Brauner <brauner@kernel.org>
Cc: io-uring@vger.kernel.org, jannh@google.com, kees@kernel.org,
 linux-kernel@vger.kernel.org
References: <20260119235456.1722452-1-axboe@kernel.dk>
 <20260119235456.1722452-2-axboe@kernel.dk>
 <20260127-lobgesang-lautsprecher-3805340711c8@brauner>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260127-lobgesang-lautsprecher-3805340711c8@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-11942-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 22D2A97DF6
X-Rspamd-Action: no action

On 1/27/26 3:06 AM, Christian Brauner wrote:
>> +int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
>> +{
>> +	struct io_bpf_filter *filter;
>> +	struct io_uring_bpf_ctx bpf_ctx;
>> +	int ret;
>> +
>> +	/* Fast check for existence of filters outside of RCU */
>> +	if (!rcu_access_pointer(res->bpf_filters->filters[req->opcode]))
>> +		return 0;
>> +
>> +	/*
>> +	 * req->opcode has already been validated to be within the range
>> +	 * of what we expect, io_init_req() does this.
>> +	 */
>> +	rcu_read_lock();
>> +	filter = rcu_dereference(res->bpf_filters->filters[req->opcode]);
>> +	if (!filter) {
>> +		ret = 1;
>> +		goto out;
>> +	} else if (filter == &dummy_filter) {
>> +		ret = 0;
>> +		goto out;
>> +	}
>> +
>> +	io_uring_populate_bpf_ctx(&bpf_ctx, req);
>> +
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
>> +out:
>> +	rcu_read_unlock();
>> +	return ret ? 0 : -EACCES;
>> +}
> 
> Maybe we can write this a little nicer?:
> 
> int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
> {
> 	struct io_bpf_filter *filter;
> 	struct io_uring_bpf_ctx bpf_ctx;
> 
> 	/* Fast check for existence of filters outside of RCU */
> 	if (!rcu_access_pointer(res->bpf_filters->filters[req->opcode]))
> 		return 0;
> 
> 	/*
> 	 * req->opcode has already been validated to be within the range
> 	 * of what we expect, io_init_req() does this.
> 	 */
> 	guard(rcu)();
> 	filter = rcu_dereference(res->bpf_filters->filters[req->opcode]);
> 	if (!filter)
> 		return 0;
> 
> 	if (filter == &dummy_filter)
> 		return -EACCES;
> 
> 	io_uring_populate_bpf_ctx(&bpf_ctx, req);
> 
> 	/*
> 	 * Iterate registered filters. The opcode is allowed IFF all filters
> 	 * return 1. If any filter returns denied, opcode will be denied.
> 	 */
> 	for (; filter ; filter = filter->next) {
> 		int ret;
> 
> 		if (filter == &dummy_filter)
> 			return -EACCES;
> 
> 		ret = bpf_prog_run(filter->prog, &bpf_ctx);
> 		if (!ret)
> 			return -EACCES;
> 	}
> 
> 	return 0;
> }

Did a variant based on this, I agree it looks nicer with guard for this
one.

>> +static void io_free_bpf_filters(struct rcu_head *head)
>> +{
>> +	struct io_bpf_filter __rcu **filter;
>> +	struct io_bpf_filters *filters;
>> +	int i;
>> +
>> +	filters = container_of(head, struct io_bpf_filters, rcu_head);
>> +	spin_lock(&filters->lock);
>> +	filter = filters->filters;
>> +	if (!filter) {
>> +		spin_unlock(&filters->lock);
>> +		return;
>> +	}
>> +	spin_unlock(&filters->lock);
> 
> This is minor but I prefer:
> 
> 	scoped_guard(spinlock)(&filters->lock) {
> 		filters = container_of(head, struct io_bpf_filters, rcu_head);
> 		filter = filters->filters;
> 		if (!filter)
> 			return;
> 	}

Reason I tend to never do that is that I always have to grep for the
syntax... And case in point, you need to do:

	scoped_guard(spinlock, &filters->lock) {

so I guess I'm not the only one :-). But it does read better that way,
made this change too.

>> +static struct io_bpf_filters *io_new_bpf_filters(void)
>> +{
>> +	struct io_bpf_filters *filters;
>> +
>> +	filters = kzalloc(sizeof(*filters), GFP_KERNEL_ACCOUNT);
>> +	if (!filters)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	filters->filters = kcalloc(IORING_OP_LAST,
>> +				   sizeof(struct io_bpf_filter *),
>> +				   GFP_KERNEL_ACCOUNT);
>> +	if (!filters->filters) {
>> +		kfree(filters);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	refcount_set(&filters->refs, 1);
>> +	spin_lock_init(&filters->lock);
>> +	return filters;
>> +}
> 
> static struct io_bpf_filters *io_new_bpf_filters(void)
> {
> 	struct io_bpf_filters *filters __free(kfree) = NULL;
> 
> 	filters = kzalloc(sizeof(*filters), GFP_KERNEL_ACCOUNT);
> 	if (!filters)
> 		return ERR_PTR(-ENOMEM);
> 
> 	filters->filters = kcalloc(IORING_OP_LAST,
> 				   sizeof(struct io_bpf_filter *),
> 				   GFP_KERNEL_ACCOUNT);
> 	if (!filters->filters)
> 		return ERR_PTR(-ENOMEM);
> 
> 	refcount_set(&filters->refs, 1);
> 	spin_lock_init(&filters->lock);
> 	return no_free_ptr(filters);
> }

Adopted as well, thanks.

>> +/*
>> + * Validate classic BPF filter instructions. Only allow a safe subset of
>> + * operations - no packet data access, just context field loads and basic
>> + * ALU/jump operations.
>> + */
>> +static int io_uring_check_cbpf_filter(struct sock_filter *filter,
>> +				      unsigned int flen)
>> +{
>> +	int pc;
> 
> Seems fine to me but I can't meaningfully review this.

Yeah seriously... It's just the seccomp filter modified for this use
case, so supposedly should be vetted already.

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
> 
> So you only support per-op-code filtering with cbpf. I assume that you
> would argue that people can use the existing io_uring restrictions. But
> that's not inherited, right? So then this forces users to have a bpf
> program for all opcodes that io_uring on their system supports.

The existing restrictions ARE inherited now, and can be set on a
per-task basis as well. That's in the last patch. And since the classic
"deny this opcode" filtering is way cheaper than running a BPF prog, I
do think that's the right approach.

> I think that this is a bit unfortunate and wasteful for both userspace
> and io_uring. Can't we do a combined thing where we also allow filters
> to attach to all op-codes. Then userspace could start with an allow-list
> or deny-list filter and then attach further per-op-code bpf programs to
> the op-codes they want to manage specifically. Then you also get
> inheritance of the restrictions per-task.
> 
> That would be nicer imho.

I'm considering this one moot given the above on using
IORING_REGISTER_RESTRICTIONS with fd == -1 to set per-task restrictions
using the classic non-bpf filtering, which are inherited as well. You
only need the cBPF filters if you want to deny an opcode based on aux
data for that opcode.

-- 
Jens Axboe


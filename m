Return-Path: <io-uring+bounces-12945-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oM65CfXgz2kq1gYAu9opvQ
	(envelope-from <io-uring+bounces-12945-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 17:47:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 141C0395EF2
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 17:46:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 40D3830093B2
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2026 15:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2D44230BDB;
	Fri,  3 Apr 2026 15:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="nNrVYwNs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353D73CBE6B
	for <io-uring@vger.kernel.org>; Fri,  3 Apr 2026 15:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775231199; cv=none; b=o2s0jaABawla4RuuLVixxDU3qEmzhqF7fn67tAU4wMW4qz53NAMJ9bRoHhnRqlrMpL4Co80auNsOy7bKwgAFMUGbjEKv4B/8dMqGMOtCOl5SwPjwj65kz7382pVMaUE9U8N1pC/3f8yi4fu2dMVy6TJwbI766kvdhZc7bQ6ffzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775231199; c=relaxed/simple;
	bh=1HwRQZ8lP8jZGh5b/FgAtpH3dI3DnAUhco17qeYKq+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ipjrC9SyTCHgt/RHHK7iuZGdUgN6N44cQCL5wqTBOWmkRATIWIZsPSROBQn9lTR8GgPF6rKAV/58N0SuO1VGVxNjSqu2FfzCy5Zld5jjpZu9tC0LPELZ4CrfJlDb8aB8DPqFeXYCZI01wExpL72nKDJurDOaQZx4EaJi3zUFdaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=nNrVYwNs; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d9b21d1461so1951030a34.1
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2026 08:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775231197; x=1775835997; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K0c0DhKW2IhtOv8mkjVWIMAgeS4UtF/c2tQs3JYMSlA=;
        b=nNrVYwNs2QM5Oss+goGPT9Ggf7OVI6tG1eCRpAmklGceITKJg2ddN0CMzETZV84f5p
         SCSkPMvlCqawGVAgSOYe3bH7Jmhw2ord1RYY8O3UUhoONpxRHTaubh4EvGhD++jIeIIv
         qVeHnVX09Ngz5oy4/TlyRptLRtynDyWUslOW0X+mvcklKZFURhyQVnb4Z+5xAPl5TwhB
         VLm0OCENlyaeWvw7PGrDMG9gmGIENZreNMmIUXwXAWd/WDdTOOSRP/0OLyu3GG5t5jl7
         W1zuR4kVD5xI/DDan/11M9/IumN4XId0cnWDmdfa09hIiiNp37mggGReIT7aYglMtsiA
         V6eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775231197; x=1775835997;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K0c0DhKW2IhtOv8mkjVWIMAgeS4UtF/c2tQs3JYMSlA=;
        b=BdSYY2oAE8Xnt+EHSCiUqh/zYN4pqZ02IL1+ugTEFZ1YB2gufpZpNRYmmb0owt4ea9
         TOwdtv0SCj7Ii8uPgQNATjsfUt9UqUT1DDx54ujQGwVxLM8Ra31GYQNV9jBUsaN8VqfU
         tYDbpafHRM84mJ9+6cx2fdh+BOCHbnD9PvgFgVOI5lr/yXk+urOu5Q5yP8sKuPp1BH4B
         ph92gE8Dmws2WzHju99cucPH8glxu350aifphhIUX12vt5+wmZeomxJAyzvyovhzl7Al
         rnc0gPADrPMCgGgELmlhAu1XjduDsIR+9kgZK1QnMtfK+B6abbTMU+oL0Ely+ekQixnm
         VVTw==
X-Gm-Message-State: AOJu0Yw2AqAF0ABAQeZ8OQvaUyixbMAbm+cO1RBIv4VvjvcDFQ2Du4hh
	m9A9wHh5t0sfnVJa/+s3aXYfVCEzjqeA512BD4R9nxcahOivNmdzvbIvx5NhDyxHV4k=
X-Gm-Gg: ATEYQzyihWwl3m/niQRiB65Ur0HWF9h10Gh6gm68TYbpcpgvw19H0s3Qy/kyTj+g0js
	AQjP8GQU+g7GK96pfeMlv5hjxfgxKba9WDa653vrn9D/cm0bXWDlsMo62nU/S0oHNbpsFQd90eL
	CBj6jQPyOfGXpPqlJaQ24HE5/22Oti2+RqqCaTVkFXijUYiDTNf2VD7pvzdAqPOr5iRAUsZTSm3
	hdaU3laxud8mLuwAdJBVRw0W9ROyirWVFYvlTo2sSLD2THa4bvIUauKLYWA0yARFgaNi+tJyyrp
	ygANLYHNYNzYCztEbiqRkEZwxUr75ejlUHeKzOCTPjGCNX+DmM+w+HgItNzIT4uEoe49le4oO2A
	RZIYBE64ZRkrYYzdGBTAlNmwyodY0dqf5QiGnLM7R0c1BajirMyLKCrZ6Jy3tMf8oV1BIVaqF8m
	tPs0MAB3D/e03PX/Ff22xKYk5vDi73S+AQcxhOCKXkOQRUn6AbBLA3DuxjWrlylKow8PNIh53aB
	SDd44nn
X-Received: by 2002:a05:6830:65c5:10b0:7db:9910:de8d with SMTP id 46e09a7af769-7dbabc2ee95mr2629346a34.7.1775231191605;
        Fri, 03 Apr 2026 08:46:31 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dba7126f1bsm4609233a34.4.2026.04.03.08.46.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2026 08:46:30 -0700 (PDT)
Message-ID: <cb3e52fc-3dad-4385-b9b7-ade9add5292f@kernel.dk>
Date: Fri, 3 Apr 2026 09:46:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 05/12] io_uring: bpf: extend io_uring with bpf
 struct_ops
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, Caleb Sander Mateos <csander@purestorage.com>,
 Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
 Xiao Ni <xni@redhat.com>, Alexei Starovoitov <ast@kernel.org>
References: <20260324163753.1900977-1-ming.lei@redhat.com>
 <20260324163753.1900977-6-ming.lei@redhat.com>
 <b7216cd5-68f4-4ab5-b1c8-b1c71f38fc00@kernel.dk> <ac8_XZZiTmHi3mwq@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ac8_XZZiTmHi3mwq@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12945-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 141C0395EF2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/2/26 10:17 PM, Ming Lei wrote:
> On Wed, Mar 25, 2026 at 08:09:03PM -0600, Jens Axboe wrote:
>> On 3/24/26 10:37 AM, Ming Lei wrote:
>>>  int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>  {
>>> +	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
>>> +	u32 opf = READ_ONCE(sqe->bpf_op_flags);
>>> +	unsigned char bpf_op = uring_bpf_get_op(opf);
>>> +	const struct uring_bpf_ops *ops;
>>> +
>>> +	if (unlikely(!(req->ctx->flags & IORING_SETUP_BPF_EXT)))
>>> +		goto fail;
>>> +
>>> +	if (bpf_op >= IO_RING_MAX_BPF_OPS)
>>> +		return -EINVAL;
>>> +
>>> +	ops = req->ctx->bpf_ext_ops[bpf_op].ops;
>>> +	data->opf = opf;
>>> +	data->ops = ops;
>>> +	if (ops && ops->prep_fn)
>>> +		return ops->prep_fn(data, sqe);
>>> +fail:
>>>  	return -EOPNOTSUPP;
>>>  }
>>
>> Any early exit should ensure 'data' is sane, so that the cleanup doesn't
>> potentially touch uninitialized crap. This is something that has bit us
>> in the past. Not an issue for this patch that adds the code, but it will
>> be once the next patch is applied. Better to clear ->opf/ops here
>> upfront, so that we never leave this function without 'data' being fully
>> initialized.
> 
> But ->cleanup() is only called in case of REQ_F_NEED_CLEANUP.
> 
> Or maybe you mean other cleanup instead of ->cleanup()?

I do mean ->cleanup() - what I'm trying to say here is that we've had
cases of REQ_F_NEED_CLEANUP being set late, and hence missing cleanup
for easily hit error conditions, and non-initialized data being exposed
in cleanup. It's very easy to miss for later patches that adds another
error condition. My recommendation is to fully initialize 'data' and set
REQ_F_NEED_CLEANUP early, which handily avoids that for future changes
too.

-- 
Jens Axboe


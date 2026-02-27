Return-Path: <io-uring+bounces-12453-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wDwgBkHFoWkVwQQAu9opvQ
	(envelope-from <io-uring+bounces-12453-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 17:24:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 829E91BAC56
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 17:24:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1732630B5A0F
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 16:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FB6544CAC3;
	Fri, 27 Feb 2026 16:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="XCquYVJ7"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567DF44BCBB
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 16:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772209076; cv=none; b=tVRnY74PTcMY82bvIVYTEd7sg1wgRyPM/MRTz5Mb7imqcqXGHwh4GyuNAFr0xJNTKQcVotnnImTTIQCkTo49xY5WtgbY6F2RAYRdHFMHluO8Rc7MAYoVRlI0aT8ceH2B9uOl8Iu5aKdjxd0MhwpaUbQ1bTDcoIxa0raursmUacE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772209076; c=relaxed/simple;
	bh=gxR9yZ2LMW+/BWskh+u7+rZYyk1DXQedpKyOVChRlug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=me3n5KNMeH0ZTeprIEmoguZ6SCqVsfBqvRcwRIJVy2Gi2enGsecN2SoS1JrYg9alerbmZrjMgwxk2YaoQPKE4elrQS5VMigtODYswsuJpbw6T/hd9dg/D81rqVmcFO1zWWicac7VZYi1YnvC/WRea13Vv86zcSq/VkZtz+evOPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=XCquYVJ7; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=bf30ON4lZRK1XdFChF7G8ID1/VN+WAjCpYqRuc60JCo=; b=XCquYVJ7BUz/SvZt6/pZ8HtNFc
	pUe/5V3wZOcaRBVEK4vWZ5cyzUwWLcDrtfH4Tq0BARmvAtOKEWY29ziJ+0CqvCKUB6McMgO7OsuJW
	JJcaRVV11iDJiNgznel10pvWXPZ4Fdh4bz5MQREanax1lHQWcLrOmQOcuEHi1+4P+fO87NGCOrCT0
	cIJPI/w1KJka9z0KQQEDQYp8tNVuwziPoIWVnPlBd7GVQRhY1xRMCLbkCgmbqATIcR2I+3icG5RVQ
	RZo6DWVIb3kFiSeBYmTF5fqAY8LEFD0/GoPvBBRgp+w2746Jvz/ihgWi25A0Cy1zLBx8P0urVvxyt
	sfWqJ1dRlQZMjx+JsGFQHVb8Byl5NpVJ6kAYstEgQyDilRAHzsIr5MyD3Q9Jssgpa8/E1bKZX1Q9U
	Jx+d/lL4J2Gj6n4AhbgdXlRfamOYOzj+DXlsLwbdLxSMm/oj/7CX45wp/HrMN1DgvAj4QWcACWjx2
	uHvOH2Z/VmjxYjBWbTrT6/NB;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vw0XH-000000090PS-1Teu;
	Fri, 27 Feb 2026 16:17:51 +0000
Message-ID: <df890812-04bc-428d-b9b5-40b836e611ea@samba.org>
Date: Fri, 27 Feb 2026 17:17:50 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring/timeout: immediate timeout arg
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <cover.1772015321.git.asml.silence@gmail.com>
 <6151302f1dc01d1c4e3176da50ab4224947b709f.1772015321.git.asml.silence@gmail.com>
 <3ae98749-590e-4f8b-a835-c9a15d7866c2@samba.org>
 <79408230-ee5b-48e6-a111-f76c40f52df5@kernel.dk>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <79408230-ee5b-48e6-a111-f76c40f52df5@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[samba.org,quarantine];
	R_DKIM_ALLOW(-0.20)[samba.org:s=42];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12453-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[metze@samba.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[samba.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,samba.org:mid,samba.org:dkim]
X-Rspamd-Queue-Id: 829E91BAC56
X-Rspamd-Action: no action

Am 27.02.26 um 16:05 schrieb Jens Axboe:
> On 2/27/26 7:08 AM, Stefan Metzmacher wrote:
>> Hi Pavel,
>>
>>>        if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
>>>            return -EINVAL;
>>> @@ -460,10 +461,20 @@ int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>                return -EINVAL;
>>>            if (tr->flags & IORING_LINK_TIMEOUT_UPDATE)
>>>                tr->ltimeout = true;
>>> -        if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK|IORING_TIMEOUT_ABS))
>>> +        if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK |
>>> +                  IORING_TIMEOUT_ABS |
>>> +                  IORING_TIMEOUT_IMMEDIATE_ARG))
>>>                return -EINVAL;
>>> -        if (get_timespec64(&tr->ts, u64_to_user_ptr(READ_ONCE(sqe->addr2))))
>>> +
>>> +        arg = READ_ONCE(sqe->addr2);
>>> +        if (tr->flags & IORING_TIMEOUT_IMMEDIATE_ARG) {
>>> +            if (tr->flags & IORING_TIMEOUT_ABS)
>>> +                return -EINVAL;
>>> +            tr->ts = ns_to_timespec64(arg);
>>
>> I'm wondering if there is enough free space in a small sqe to hold a full timespec?
>> So that there is no restriction for IORING_TIMEOUT_ABS...
> 
> There's ->addr3 for another 8b value, so yes it should very much be
> possible. I quite like that idea, it'll then be the same as the regular
> timeout options, except the values are passed directly in the sqe rather
> than needing the copy.

Yes, attr_ptr and attr_type_mask would even be two 8b values together,
basically the same as 'struct __kernel_timespec', correct?

So we could even add 'struct __kernel_timespec ts;' to the last
union of sqe...

metze


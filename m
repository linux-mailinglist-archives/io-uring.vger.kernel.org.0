Return-Path: <io-uring+bounces-12944-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gE5gNUzgz2kS1gYAu9opvQ
	(envelope-from <io-uring+bounces-12944-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 17:44:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 73597395E6F
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 17:44:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A4C62300F12C
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2026 15:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97260344DAD;
	Fri,  3 Apr 2026 15:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="T7gHCzj+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E20C350A08
	for <io-uring@vger.kernel.org>; Fri,  3 Apr 2026 15:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775231050; cv=none; b=CDlTlSKSv1NR9egdvWgdQFHntiU7Kvc/f3BhsUca/daAZGWuwNoPzVVQtqB6unxort+xt0TYatgHEubgblkCZLr9H3Bp0zVQINFrNIgjXcC/TMT9ncFeHkh6U99XKPqb0UPF7EitITb9PThzDB96o/ew9fp4uF4dvWkxwwWR8XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775231050; c=relaxed/simple;
	bh=uYq/3416mlXI+iwcJOHQrrp6Lqd67kQJ64MXtoCFamU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=muQbLH03W9SY0gaGUeG4v4J5PSxTw5cnEAbggTIIxAdjXtzsRo3BiFy/lG+AzThfiKwbtvFPlc1st7fEWvCWUA8jsnORKcDEKORws1S+fdVy6j8LNz9MNIxIHUPcvI6Rp0W4d8OmCZy2vTKh4GJlnAeO/Zg9dTwpWeOt6HLedq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=T7gHCzj+; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-42306f82341so788040fac.2
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2026 08:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775231047; x=1775835847; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UP39jJ3rhxJQ4+9IiHy7051NnSJJsim1X1uLLCgprng=;
        b=T7gHCzj+I96jIWLWWBJlOa6DpoweH3SRVBxFm3qkXg0qhQ/w1vQvCWhPekd6C/Ov4c
         ejSrWZ0J5INj4AOk3qIRwaCsGjMJ6vJyl/bM3wzRrr85diJbsoOiF7sABNYXCXEr33hB
         S1PGpHgY2gHgNlBMTKRczwWtLVrb3yZOpbtA6Vj6qsNUVBF6XYxBp9uyjooZAv1NjeFj
         s/O3eXnqwWuilED5kiRox7o51T9ZrmD7vx36pl9dV5wQAZ/zFtNEaixgt9AyK3xW2dUR
         gIb4sh/YjTR2eKa5vYPag6tTDNGdQvvBJwdEIkTiduOyKQQN6K0iKJkRQjbtztHAlq4g
         PgIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775231047; x=1775835847;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UP39jJ3rhxJQ4+9IiHy7051NnSJJsim1X1uLLCgprng=;
        b=j693oK/45yDdnz0Aw/n+8TSye/qudTt9yAdUpVmazMV6tGNG1bYZGfrRuFgrGzqd1T
         Pz5LAW4X2p0kxyx+OAExg/nvAXQZqrqhOR+A2T/v7MZuMkyHvUYJZfujChRChlK35fSa
         olSvgWBWHA2LHu85g3QtG6Wpo0WFi3lh0BIaopQCB5A6eQD/IVCnthTGOfUJnYz4URA1
         8hlSCE2z+Fx8e7hM+Z1vVPIId4iTzb5+mPxZC3uTtVjFVel2r8LL+kkPBbsW2hwsupAJ
         7pHY3Ki6Iogjm1joYUndoLYptnsi+9e74kOydo8kvhAZiBTl5SGP3+8RXstQ2wowls5I
         cdRA==
X-Gm-Message-State: AOJu0Yxh19fqmFlKcTp/LdSJBL99fpI18WRmItSHVDULzae47NwjowiJ
	wC6WEYpVcYUgz3OFRmun6tMz7q9pijAvdovwrLQXPVbjZoTmlRBxDSH7/0BY6NMU4Gc=
X-Gm-Gg: AeBDiet73kzMaNY5BFOPQ5HG+1WX8ti2JgYnCZqYiiPHhci+7Dy6EHeYJp21gGvbZUC
	3YXaTW6CYNUs7E36Z96r5ESErGduISNBQbeWrhz6A2dnmHlKmwKRmuuDAL1JD4SG4b7rjbnbpB7
	MRrvfthcFN77uvvkttxvhikqsBB/tSTZ+cDJ8QCFrzeoo7XH7coj5ZOK2OUMA+Ycxr/J84cVgtZ
	b9m9yNmmUPB1AVrBq1dz59FXl0INjPIVQYshpXW9ReXjYWUIDY9huHBn7Hf4usdJVKAndyKrl3k
	ZJV3VrAxG6B5OpNxYrBUqz8x8MNm3VZTtGpRue3TfXmKBJ30GvUGIEaY1YueEEYnjAbpJUy1k/+
	T0LGG7MuIxXjupgh6J6v5umnHJglpZeidln8gXGR1ffbntAH4gSeSQF15bGsvMW4u/ksgjBiJL8
	BvmbZSQKzEUBcK7yfddrqKfg8/doD+ebhKILiGsZ6M1p6LOD/Cs45ODOicfrf3TvBDaDnWemLmy
	qiQvM6g
X-Received: by 2002:a05:6870:8181:b0:41c:f16:f74c with SMTP id 586e51a60fabf-423100208a4mr1655548fac.32.1775231047165;
        Fri, 03 Apr 2026 08:44:07 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-422eaed6647sm5089543fac.2.2026.04.03.08.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2026 08:44:05 -0700 (PDT)
Message-ID: <ba3654fe-5553-4349-8a7e-7d542bc399a6@kernel.dk>
Date: Fri, 3 Apr 2026 09:44:03 -0600
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
 <5e8766d3-a801-48e0-8d27-60e75523ebd1@kernel.dk> <ac88hCYgrFXBX3-g@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ac88hCYgrFXBX3-g@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12944-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 73597395E6F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/2/26 10:05 PM, Ming Lei wrote:
> On Wed, Mar 25, 2026 at 07:49:22PM -0600, Jens Axboe wrote:
>> On 3/24/26 10:37 AM, Ming Lei wrote:
>>> @@ -493,7 +494,16 @@ struct io_ring_ctx {
>>>  	DECLARE_HASHTABLE(napi_ht, 4);
>>>  #endif
>>>  
>>> -	struct io_uring_bpf_ops		*bpf_ops;
>>> +	/*
>>> +	 * bpf_ops and bpf_ext_ops are mutually exclusive: bpf_ops is used
>>> +	 * for io_uring_bpf_ops struct_ops, while bpf_ext_ops provides
>>> +	 * per-opcode BPF extension operations (IORING_SETUP_BPF_EXT).
>>> +	 * The two cannot be active at the same time on the same ring.
>>> +	 */
>>> +	union {
>>> +		struct io_uring_bpf_ops		*bpf_ops;
>>> +		struct uring_bpf_ops_kern	*bpf_ext_ops;
>>> +	};
>>
>> What am I missing here, why is this the case? What makes the use of both
>> at the same time impossible?
> 
> Please see the following code:
> 
> static inline bool io_has_loop_ops(struct io_ring_ctx *ctx)
> {
>         return data_race(ctx->loop_step);
> }
> 
> io_uring_enter():
> 	...
> 	if (io_has_loop_ops(ctx)) {
> 		ret = io_run_loop(ctx);
> 		goto out;
> 	}
> 	...
> 
> So if ->loop_step is assigned from io_install_bpf() called from bpf_ops
> registration, traditional userspace SQE submission and CQE reap are
> bypassed completely, then IORING_OP_BPF and any other OP can't be handled
> at all.

It ends up calling io_submit_sqes() all the same, so not sure I follow the
problem here. Seems to me that the only thing that is making it mutually
exclusive is the fact that you unionized the ops.

-- 
Jens Axboe



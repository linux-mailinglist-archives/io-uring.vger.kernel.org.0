Return-Path: <io-uring+bounces-12383-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UBEVOfFknGkoFgQAu9opvQ
	(envelope-from <io-uring+bounces-12383-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:32:17 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C61C217807E
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:32:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6501D302E11C
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC2E28DB49;
	Mon, 23 Feb 2026 14:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BsBUlvFa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414DA26A1AF
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 14:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771857133; cv=none; b=Nr34ppD+8p2QqTbIcMNzAjRwqgzuMTgrzUT7ZHOcHfnBwhKZlr+EOX8m+j0yJE2O8SwCLHO/5d/XuYcnvSzGjdJvKJccFQqZDa1ikA0B5bWUYJrbfwn1HngN2JWSRcLNWrNdC8skxZ6wK+Fvt3uodBeQ49TloEUqf99XbE2b5/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771857133; c=relaxed/simple;
	bh=3Zc+uRiN58XFWN6+0rpSke7KZkfFbqBysqOWy4wmT1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XON3gkP0Rgro2heYvhs39jRkKAK8zbwc+hHCxlmYu4FOesNg7aigZnUqO1iazxVZIPtwuwEu+UoT6zVpAz5I+ubkizzb1bMQ+GUDutHsT7lVvG3+5RJTbsCmnUmw8I/xYHGlI87i+d79E11oSJ0QNctqq9y/HWv3jDv90EADfz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BsBUlvFa; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-435f177a8f7so4384212f8f.1
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 06:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771857130; x=1772461930; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LI6emMZxIDfCxoTprBZThTpHOJPMdNw9OcTGSAjJRdU=;
        b=BsBUlvFaz/6WOdxeea7QWZnjghwGTeHq0E65RnDfk6pEMjsYhbrKMo0E81MW2v8TOd
         EGfsn3vb8mtyb8eSXYroV5to0qFmfDSot1Y8BJM9afnWNNACxOvo7wfwEHRK9d+CFxxl
         zmX/attaLTy3B59QfIHxxs7Syc60C65CBdSTMKxpxHyBMprI6Idx67nR6/JU2yZyIwEH
         4kwXSWQnLZNsfmJgDKVOpi2iN2GXm53N4seoixBogIPT62wqB/dOL/epnvcf70tPKlKZ
         6qbp5Dh2KLwgB2Q9gPnhlAbm6ajHRKdZ1Tx5cGyKZ/+cS2U/Q7pEm6yKOI/q9TdRnoR7
         YEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771857130; x=1772461930;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LI6emMZxIDfCxoTprBZThTpHOJPMdNw9OcTGSAjJRdU=;
        b=mr8my5sB9k83Pp1SOsp3yeoA+S6ttpa0NimBSdAa7kVwuwQcnUSJ9109nRIYzANMFu
         Xl0KkcHNL7qrTjLQdaLmcQMerDGSM72fRnVh+oKEJRvbrK2zZjF6nnAZRHhjNqLAcWNt
         5sBBncDBlL99Y4xkegG+TYdfVBMmgXz2YJPG/btPM1YP558PpnW4gAnNaNhGyu1vmSBs
         WkSNMebAD6w1FOb4CoWwgtI3ujmIjrOikTsGBvP7CAMH15/3mBSO7HXFGE3Vwov8AI8s
         n/9Na7S6WQuTNr9iMwUtutIP6DLW6zIQGySLiykP+dLgfLCn+C/VdpZUGdnr9/lRpaLq
         5vEg==
X-Forwarded-Encrypted: i=1; AJvYcCUf1UXLhUHOFN4vF6K+eaiMaojbHJlPglL/B1GmnmbU/LIkX1wa8Y3LLLCjhmBeHlaFFRwvgK3uNw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxFG8e6c648ffcQPbvHT7JNVXHnl7T17d1/fBZHuVqJYsHelqnG
	CpjOl7xpHHMW2v6StOrwxMiWqYG+A/6EwlCd+UBE6sBWZtGTXCuUJXaD43Ei3Q==
X-Gm-Gg: ATEYQzzkzg7+URP0wMrmuE9m36Nu7xYJo6FI9zjvoa0akWlMmvw1Es+rBgMU4RPDAlM
	6e5pKBGAMiAWZv/daqVLMylGZZZOvrJhxTWlEthlD67C6JdOFOAWHXnhaPengHGW65zkIz+zeO9
	JWqfRXjVJCcM0JslBtgay2CubqrJWtYmfc6jYmt/fmS4u6ewqpAoMpXyRmGFq9okoK9ANkFGspg
	gSqlka5rHXzO/DMlks7k725tiFd1k96FAZHkdlHE0ryU/zi5SrYHmHm+OW3RG1j4HQsTEWNZ7sx
	DIQjO/I6FNEN0wx9cpVkGshs72qLpJXFbqXb2zOdjpATupPs6cXlz3G0GsYqbGwFztOgMpPRc/N
	vW8GStWI5O9AgbEydWHGFC1Glt5cCXPUzxilSHHsDSUopKLU8KZPw1owzGiO0THY3W6kkE9FCVU
	TPtQjOi4gif+AC21skWC8VQeb/9AxfAe/fU5yMYZuGfXb9ifBWlfAYfcEtAs8ix29uPMSTTGtR1
	1ztKi3xLr9I0wLxv5ZF/KxCjOeeTt2JOLWt5hM=
X-Received: by 2002:a05:6000:430d:b0:437:6758:ce80 with SMTP id ffacd0b85a97d-4396f160edamr16697608f8f.25.1771857130330;
        Mon, 23 Feb 2026 06:32:10 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325::38a? ([2620:10d:c092:600::1:36ea])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d3ff27sm21293391f8f.22.2026.02.23.06.32.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 06:32:09 -0800 (PST)
Message-ID: <d808f483-3c0f-4323-8faa-0b7d49c539e3@gmail.com>
Date: Mon, 23 Feb 2026 14:32:06 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] extra io_uring BPF examples
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1771850496.git.asml.silence@gmail.com>
 <9c8d6af7-8546-4409-91fe-85f92a08f503@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9c8d6af7-8546-4409-91fe-85f92a08f503@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12383-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C61C217807E
X-Rspamd-Action: no action

On 2/23/26 14:14, Jens Axboe wrote:
> On 2/23/26 7:11 AM, Pavel Begunkov wrote:
>> NOT FOR INCLUSION
>>
>> Alexei asked for extra more realistic examples. This this series is
>> based on top of v9 of the io_uring BPF series and implemented as
>> selftests. There could be more, but I stopped with 3 that should
>> give an idea how it'll be used:
>>
>> 1. A QD=1 file copy program that show cases state machine handling.
>>
>> 2. A BPF program rate-limiting the number of inflight io_uring request.
>>     That's a good example of what users asked for before but seemed to
>>     be too niche to be plumbed into the main io_uring path.
>>
>> 3. A toy example of how BPF can interact with registered buffers.
> 
> Let's please keep examples in the liburing side, where they can be
> with the documentation too.

I got you a liburing example

https://github.com/isilence/liburing/tree/bpf-ops-example

but need to sync with the selftest. I think I'll rather keep the rest
into a separate repository instead of adding all helpers to liburing,
which will inevitably do similar things but deviating in API and
internal details. And it's simpler on dependency management instead
of requiring libbpf / etc. for liburing. I wanted a space for
misc io_uring bits that doesn't make sense to keep as core liburing
anyway.

-- 
Pavel Begunkov



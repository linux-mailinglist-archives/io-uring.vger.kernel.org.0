Return-Path: <io-uring+bounces-12386-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6P11K/RtnGmcGAQAu9opvQ
	(envelope-from <io-uring+bounces-12386-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 16:10:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 177F9178835
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 16:10:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5FA3B3100DC5
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D55A335BDAF;
	Mon, 23 Feb 2026 15:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i522L5Tc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47621352C29
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 15:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771859186; cv=none; b=rosMZnakGbLWEmWTos/s/mszuHEGeO7uiYLcl4UBOlzm76rMDX/2MPnSCslW7trZkDQcQS4acG1Rc5AU8B0ztphIaE7r3jUXCEW/NslUXXBC5yiUIZcOLOHqORpb7b6luc8zBm7IAtUUqmZxiTBabdZu9Op8erD9X+b7fsShJXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771859186; c=relaxed/simple;
	bh=IHV7aqPp+bGHxNZCJm3n893oxNKmSFA6/AU1Qstp97c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E0n2OSW0120ikCfu2z2uzlLSqUBb6TUmR/Cc14kvRT0OBUftoMof/VBvXOO8fEClWUaOktRhz/0AlIYSECgWG7lxjcMra/pg2/H7viHwqk9bi4W1Hz2FZM9KBADw+7vJHEF2W4jnOIV7mNixarm78H2LR6/MizQgQrHLVoNReRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i522L5Tc; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48371bb515eso56413655e9.1
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 07:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771859183; x=1772463983; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DEkms4j98deJ+XfmVJdJr2vX/lC1EVAkdFYjsx1rvdU=;
        b=i522L5Tc7mhKMN9JxKVr1ZG7Ak+qXF34I9m34qefivKv7ApccK76nCoHsVmiDpFDF6
         QrjJZnPKdn8guVFbSQmf/sxztrzBYIB7kEODFW78DoBS5GX2p91CAg9gtTDZYVJu5THe
         SKoBhuW2HhjbJCNbBRDXGkpN03C4f5UP15fLddAYqCiW0cmxib5Bq40W7CKHiUMnowdP
         8UwrPi4SfLwjMhv/h8o9lTWZxoLxIRjlj+7jN9Xwa74DDkBJDJaPMqg+TZ8sM1MYtaGP
         Xvx+xLLNnrLe6WpxcqprMMnyGN6Yp7GrzwwZswPbDHtok/3ipDHuQLeDdWVR3X0qMcRl
         tOkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771859183; x=1772463983;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DEkms4j98deJ+XfmVJdJr2vX/lC1EVAkdFYjsx1rvdU=;
        b=w4OKcB6YcqSoKjY/cxdQBZ++DVWv8ZE/27Q6V/Z+WLR9aXvXsnY7NNEtQixTCtNHbC
         RHfPTYF0zVCFDGX0JYyprcOsvX99EXMqfLJPRRjgqTFbIjISSvwjPI9NVdl0Ki5R+Qbj
         zIGS+I+ST6FkM2qJIYarksFeC5qgetuCYEia/iUsMsNMzOH8E73BuxH33PYdkQ/XMEjo
         yZKTJu+VQeSw6DKnGnWvnKl6OHWSybrE6kVObaErC7WExJFI2JG/S5HGDP3p8Jvysk0m
         4fjSvSa9dBpEpHqwipaeFrRzlAIuEmfcPg0IMDW0s2GAZUf7HouWCpyigsx3N/lPZWUf
         bz0A==
X-Forwarded-Encrypted: i=1; AJvYcCXuRzkWlJloyh0zcAhFg5zMjxfPd5eFJbBEz8q5GftLqyQR6ZqqBv80mXp012i8GiP874JhPpSPUg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1k3d81LQpWmNJSZ0oigm6bGpx8YMRP7Ul7Jag3TsamMQVSNTd
	F48qxbIEqd3PhoiQDUboQPimX/pV+3Ann5qvXYX7L6NJe9Dv/uYVHQ/0
X-Gm-Gg: AZuq6aICHopuXaEiMl2s9cx9q5py1clX+F7h7MMlczaaGtoRXziMxy6g264Nqh9/Jtz
	/16VUCBe66ZTtxW0/yNHGqmir+IujpE9qkCMCpPWRizec4PQ6fNQeSm+SAb86yeH2CXA74K3daJ
	AgzqooeO9cXWnabAmJbZzNHnNydACq1J8K+NA1L0T0NkE4iCf/u6oQGo5t6nrE+mKsgM+pmqNG2
	2V34PDN4tWIzNYQnXTytN5nEknR8jp+CR8DSzDDcR6HNHLsaOqb+5pZV5LCTADjSka3uXLkJbSk
	Dop6gWnukUMSBKoSE1KoTyHDtfwcZ7SqqtJ+ok+9J6qwj3GuZBdDs0DAowNBcu+8M/1bQyxeYSp
	WA+CzZdHfgEhn4wvpxTXhjdrOJuWmwi1LHhG0UH4tplhJyyJ2+SV+DK8GcFbLTAsFFRE4wqXi9I
	m8HA8NldXnOagFlMKHkBF3ACnlzU6UEzLbjNlONdirCGfVymZlGwFoK1VoobOHPjiKaTpcGMyFv
	B6qw5keqsSXp3x+DVXoxIIEmfNRIM/Q9ZuqcsA=
X-Received: by 2002:a05:600c:450c:b0:47d:73a4:45a7 with SMTP id 5b1f17b1804b1-483a96377b1mr144550165e9.24.1771859182508;
        Mon, 23 Feb 2026 07:06:22 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325::38a? ([2620:10d:c092:600::1:36ea])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a9cb4bb3sm194526255e9.14.2026.02.23.07.06.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 07:06:21 -0800 (PST)
Message-ID: <b22117fa-84ba-4f9d-982a-bbaaae35eebd@gmail.com>
Date: Mon, 23 Feb 2026 15:06:18 +0000
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
 <d808f483-3c0f-4323-8faa-0b7d49c539e3@gmail.com>
 <a7e1f667-04ba-4fe5-b21e-8c47e68213d3@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a7e1f667-04ba-4fe5-b21e-8c47e68213d3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12386-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 177F9178835
X-Rspamd-Action: no action

On 2/23/26 14:39, Jens Axboe wrote:
> On 2/23/26 7:32 AM, Pavel Begunkov wrote:
>> On 2/23/26 14:14, Jens Axboe wrote:
>>> On 2/23/26 7:11 AM, Pavel Begunkov wrote:
>>>> NOT FOR INCLUSION
>>>>
>>>> Alexei asked for extra more realistic examples. This this series is
>>>> based on top of v9 of the io_uring BPF series and implemented as
>>>> selftests. There could be more, but I stopped with 3 that should
>>>> give an idea how it'll be used:
>>>>
>>>> 1. A QD=1 file copy program that show cases state machine handling.
>>>>
>>>> 2. A BPF program rate-limiting the number of inflight io_uring request.
>>>>      That's a good example of what users asked for before but seemed to
>>>>      be too niche to be plumbed into the main io_uring path.
>>>>
>>>> 3. A toy example of how BPF can interact with registered buffers.
>>>
>>> Let's please keep examples in the liburing side, where they can be
>>> with the documentation too.
>>
>> I got you a liburing example
>>
>> https://github.com/isilence/liburing/tree/bpf-ops-example
> 
> Right, but that's just the nop thing, which isn't really interesting
> outside of doing basic verification of yes indeed the kernel side works.
> 
>> but need to sync with the selftest. I think I'll rather keep the rest
>> into a separate repository instead of adding all helpers to liburing,
>> which will inevitably do similar things but deviating in API and
>> internal details. And it's simpler on dependency management instead
>> of requiring libbpf / etc. for liburing. I wanted a space for
>> misc io_uring bits that doesn't make sense to keep as core liburing
>> anyway.
> 
> liburing should have support and documentation. It's not that hard to
> check for libbpf in configure and either build the support or not. Once
> various feature support ends up being fragmented in the ecosystem THAT
> is a mess for users, I'd much rather have it consolidated and deal with
> it on the liburing side.

What kind of support do you mean? Installation, removal, other BPF
management is all on the libbpf side, e.g. skeleton open/load/etc.,
and with it generating new structures for each of them, I'm not sure
how to make it into some generic API whether it's liburing or not
instead of making users to fill in the gaps, nor I think we should.
As for figuring out right helpers and abstractions for BPF program
writing, it'll be a gradual process, and I'd rather have it
separately, it's not like I can reuse liburing for that.

-- 
Pavel Begunkov



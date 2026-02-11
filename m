Return-Path: <io-uring+bounces-12162-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oJXdDy2jjGlhrwAAu9opvQ
	(envelope-from <io-uring+bounces-12162-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:41:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ABCA125C4F
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:41:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 44AB1301F328
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 15:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34BBC30B519;
	Wed, 11 Feb 2026 15:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DKS5w1iG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA2630B52F
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 15:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770824456; cv=none; b=HvuplSAj7IYtU/FL6tP7zjjg1w9EzAtPoMkAXZZi5kpwNFuJzFJdNie0q92ZBLZTi8xkiHM1T+5BzOGGP9VI/tZKduEPGfDoxZk6v004Li92ii5j0701ky5jmC1wWWo3ChAByDLdYhKDiucsATMPeoHi/QJFkrGCCugEGK/gsc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770824456; c=relaxed/simple;
	bh=gar//loSr4yv/50iCK+pDKH4gpzEImR6mB669ItJ9JY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jb5VcDwy0zZj3A7CcCjZjksiDJxR3bU8zXfQ5twIl7F6eBYriAsxfRFDMiVw5PE1IF55tVrhJ7/BjGlceEaeTm1rKk/Fn8bgzrr6xroEWHz5kdvxxESM7IheaZBDI3qmUvj9evpEekwtBUKI/OQ2fze1b03Lx7ngfJaNDwvUo64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DKS5w1iG; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48069a48629so62802655e9.0
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 07:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770824453; x=1771429253; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fdKarRN1NSXhH05CU/sjeG4t0zo/Q2fYiKAEmozL0tE=;
        b=DKS5w1iG0tANc7OrknUKzYtZaEK+wslS3ZD34Jwi2JeOO3yLBmdBtV89yN/1mDSGan
         SBI3fsi+wTotQQjIw7oDtW0I5x/v48YnRfnJ9a33m9sTV7cYAG9ZXtUcn7BIHbUVhnWL
         XjRj7eO5k+eaLxmDTqpzJPiU9Z/sxCYssLi8TZAmicVZLkE2GO037Usl5RdmuipYakOm
         fsITy+6oSADtPg9X+Nze6ZV4UfwAA053CPSmNsSdyS1OWsshO9UG7lcFGtvsMbeLSs5d
         60YOVDF2VR6LPXsKVwwDIgcbx8iJJnB1ZDHl17bRyIR8XuECwcRCP7VFcBlsV1ip8SIV
         CqJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770824453; x=1771429253;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fdKarRN1NSXhH05CU/sjeG4t0zo/Q2fYiKAEmozL0tE=;
        b=E6Ba2+QFc5cE2XO3yP5OQewAKcsf+SnV+jwvxbqBAgeAj0nb/Qg5YIUUpD9moYGDhq
         xHrf1J15hLYwQMpx4YXea+9jSLbdykvCuBgQCN2AscCwB/tUSPXWmNTdYJE3gaqx3Ndp
         xXnEuM7Dy9caJfXrOO0vhZ4JWDFcNGdpX6pjZI34ABKW5YhiSMzB0gOMnz3bSBkEhNgJ
         5CNRIBGeJN2C5KIhsAmFza5ru6q5DIDmwa/HhYfhEywaW52wzntVQ3NIFX5IQW8eoq1d
         txE5QLH+Afh6LL+fba0OFHrpb/k30jzcZQRhZDlmaAAcLlfPXW/RRAAccaTmtu5fsdnJ
         p5JA==
X-Forwarded-Encrypted: i=1; AJvYcCV1Rh4Bj+rKRR2xVEjos180P0RAnFDptaOH/7q8VTKq72NDzihoqxaoJxMnhr7X4Skiwv5shKODww==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUDcBqwgmjNlaEtKFtvD97iZ0tU2luZGMnsAbavnO/6ogXHwyT
	rOsPS4QaEY/0KBmlXcUvwe7YHLD3igN8GxsOl77efFs4MLwlkwmjRqYr
X-Gm-Gg: AZuq6aIam1lxEn0lYNjrUnTfhu7NWKJjlQ/LP3qaIOyCOlwKUCsETRET5fliHUwLUf6
	9VJNZqpt65P1RXr0VUvDX+YA8AGGS0Ek1eGBlvHmva9L6Q+x+3Ufi1CRVWS8cAiTwRAOZGeWHsj
	9CBOggCVPzycL50GgBiZ0K2IdZJ4IQOdlIfYsYR4u63vBNDzOVo9yWetZXVfGQrlNtmQORqbseQ
	HTnthEcVZsJBUFVcnuDD6CXVG5LffR6sdRyai1yOzLu0m2JVRrJJYMdKYqxR41v9U548p9GuQ4P
	ddhbm95FmnTjLPxy2Z1JqEi4oxTthJ47NLJHgasCHMTYFaXRhsfgXYyM/P5LGANitNqc5+NE4pd
	SshqZ1xvtm70YG6jWRkVYjwU0atwvMAlyfqJI5xDDmlRPmtyT0IZkOec7l21ixApZgoGA8Tiuje
	PU5E+xe7PteFAJhK/pJuuc1R0rIlyHJNPjSEgPHqofuhGiyGcqIphekkTDvorsEjwnN5JL6Puc1
	61iC7fbvgXICS1oXCRUBjgwR8YVJ+SWovj5dCxKvduEJCPWzK7aGgfWDF7sRuDeUCKHAIZ7QWKh
	XQ==
X-Received: by 2002:a05:600c:8587:b0:480:6941:d38c with SMTP id 5b1f17b1804b1-4835082d177mr90270985e9.29.1770824452529;
        Wed, 11 Feb 2026 07:40:52 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835dd20519sm85013405e9.15.2026.02.11.07.40.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Feb 2026 07:40:52 -0800 (PST)
Message-ID: <8bdb51d2-0935-41ba-bca6-c9d575c7ae99@gmail.com>
Date: Wed, 11 Feb 2026 15:40:51 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] io_uring/bpf-ops: implement bpf ops registration
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1770818588.git.asml.silence@gmail.com>
 <7ca5070830c022493eaf45948e146f418aceb747.1770818588.git.asml.silence@gmail.com>
 <55db7c09-5bc8-4dda-818d-53130400ee50@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <55db7c09-5bc8-4dda-818d-53130400ee50@kernel.dk>
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
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12162-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8ABCA125C4F
X-Rspamd-Action: no action

On 2/11/26 15:21, Jens Axboe wrote:
> On 2/11/26 7:32 AM, Pavel Begunkov wrote:
>> +static void io_eject_bpf(struct io_ring_ctx *ctx)
>> +{
>> +	struct io_uring_bpf_ops *ops = ctx->bpf_ops;
>> +
>> +	if (!WARN_ON_ONCE(!ops))
>> +		return;
> 
> 	if (WARN_ON_ONCE(!ops))
> 		return;
> 
> ?

Good catch! I even lightly tested it before, but seems like
there is a delay before the program is actually destroyed
and you could still call the function without crashing.
I'll add it to selftests.

-- 
Pavel Begunkov



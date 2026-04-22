Return-Path: <io-uring+bounces-13130-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OC6RNa9E6WkbXAIAu9opvQ
	(envelope-from <io-uring+bounces-13130-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 23:59:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AE5F44B2EE
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 23:59:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BF49C300D459
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 21:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 839D63A2549;
	Wed, 22 Apr 2026 21:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gf2kU7R+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE8837B017
	for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 21:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776895103; cv=none; b=NaLthwpFkgxTQjg2PpPeL8tFQSlr2oT+NzJvPwccJNbSPVl2qYOgLdWiyQdNgyphq6EWujnhJIetsw6iL1OHXgZ6pBgq7l+x5ipnKGTdzHJEhdPrnU/47fZwbUcWmPkeSXRe38ApazKrsfOKbvBrDq4NokhZ7/uJETkcqoIWIY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776895103; c=relaxed/simple;
	bh=GzHVAmsLzPuelQXQHQrVV3DAhz1JSgmFcYw+FXXnjMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MHFzUmb+orTVBjo2FsSiV6MF25/lqn3qiCUvvu+7F7xawX9FTCqgop3h9LNdQtH2PrBn7Bn+I3yceiSvkawhJ39TnaSDuW72+MfRveR9lFZS6PYjhLpyhb3X/oEs3ku7wPQzFa1urKpbjwpY8cg45EhZw7+0K0sjgamlescxvBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gf2kU7R+; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488b150559bso47263935e9.1
        for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 14:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776895100; x=1777499900; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kuCrp9vHvm93F/m655sREzL7Gh/S5uVZ2N8F50ItWVg=;
        b=gf2kU7R+8lACzlYkqVPilvWZl2tDRZVw0hnN5jBkNpPdEFKWwacioM4kKJmTOyJK0X
         jZwtCI+HdAQOBx9GWEMc497zBYLerTdCmx38x5zG4mXLPGxwdNBbBthE7uobBu4LLaJJ
         cEFexorEi7XI4VyGGBBWA7n+53ubTSD+dhZR95aAxDULN5NZY9SwvC+CymhUJR5qkS5q
         7esGZp0krCHGqa+A2goYFZWxEgEm0jWjv9FZOT7sra3rJGOsbA+H597BRzwnaYRLiDBL
         uMGtJm6oToEfomuBQhvOGa/RNa24v+jQtH//aeeSuaEi+4WUPc4TSCPQVSTA/zJp8yaV
         nyPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776895100; x=1777499900;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kuCrp9vHvm93F/m655sREzL7Gh/S5uVZ2N8F50ItWVg=;
        b=eps5lgT6Q7VjZGALuysPtqppPTKSKJ8ywK5QibtCHiRGiA9ptGjEYaAvww+TON3MxN
         KeBn6cIDCmlE41AfxBz/Q8Pp9gWd3qr9nThjcNnL2l6pjQNQTx6hsEHmzRzpMONoWwtE
         k6RkWsPRJlKs4GTuYdtaBHl0kX719RKbPuxa30wL1dmBHsPZkvy/WXt28DebYlJShaAO
         a9VPXZqzIZ8fyJe/56+Kwsz+4od6zhou01gaOpik0xTjUwOnK/NkIEVuuBaTQfoIuwm1
         pEDlwwTmiDxdpffcWnMSVE3GSIdedqRa0+5IZ97e+ruzxyxBeB0zx8CPeTI91R3DILp6
         t36A==
X-Forwarded-Encrypted: i=1; AFNElJ+cbKIggg9WoLhyJwV9nJ4ZRaSMyS8QlLaxMIl7NMcb2GVwPx+m5DQfHZlAnXjv2XezEa2Hq+pRvQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxKtG0jX8y9WvWM5F8rElTwAoGG468NpRUENgPrxFesqDDqSBPG
	xe9r8viZWKsy7oLNaHcyfvplTfcYGvbSAZdQ6vC3qGpK3lNsZN1w52zv
X-Gm-Gg: AeBDievsoEgu9qNwVjSncAxqnA60iRE0m/6Dbo6cbj+8Za/04PhD5a+g4V0jPMyOEoc
	h1I1vV3fyqY7y6f53WanjZZXrXfiPbt//4mt6tpHYR/7AgLNg+JDatWJXYDymF0RGu8ldDAtaIg
	8BTT3aj99SLs9gqiAD4isN2KNcNzoWrWSku1qzXKTZSNCduFzTIHNH34M7QxtMtiTSAn0lV2oii
	GoULxN1+gY41KrDGM3UMH33m/AvKVzRVauCFfk5hBmPwaFxOkM1Gx0wk/ZbkuwXmuuPSaf8UtER
	IfM58Dxkhn0iVXsNtYqfCFV2bxRqylZYXrZV9hDT8N8ATysnc6ruwYZfpLNFFn/hYIXVe2CM2K0
	829ffixqc25+2oUNjFUWWOY5EMex+X0uxiamWdyY7ZraV4j7rIOHC5X0Y5s1xEqed95rLoY0XFI
	TOKFML1C6RW9MYe4bw2lWSTXmuFQWnwtNHegH9SkoCtGXZLe6wm+xJ8tV7w86H2rZ3HCPWZDnK2
	BkBl8uYgMDEjmBVntLSy66MDhj00T8RKrO8xvTXuXfP4tdS43mWFACrPO4sP3WSS14BhtY+MSL3
	W7U2ohe3a42T
X-Received: by 2002:a05:600c:468c:b0:48a:56d5:16f2 with SMTP id 5b1f17b1804b1-48a56d5179amr120772365e9.7.1776895100454;
        Wed, 22 Apr 2026 14:58:20 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4891cc7b2efsm151827445e9.0.2026.04.22.14.58.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 14:58:19 -0700 (PDT)
Message-ID: <e49d1391-b06f-4d60-98ff-0f034f2ed9e9@gmail.com>
Date: Wed, 22 Apr 2026 22:58:37 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix missing submitter_task ownership check in
 bpf_io_reg()
To: Gabriel Krisman Bertazi <krisman@suse.de>,
 Ali Raza <elirazamumtaz@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260422-master-v1-1-e82f47558345@gmail.com>
 <87eck6ofo8.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <87eck6ofo8.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13130-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[suse.de,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 3AE5F44B2EE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/22/26 22:20, Gabriel Krisman Bertazi wrote:
> Ali Raza <elirazamumtaz@gmail.com> writes:
> 
>> bpf_io_reg() installs a BPF struct_ops loop_step on any io_uring ring
>> the caller holds a file descriptor for.  io_uring_ctx_get_file() only
>> validates that the fd resolves to an io_uring file; it does not verify
>> the caller has authority over the ring's submitter_task.
>>
>> A parallel path in io_uring_register() already enforces this:
>>
>>      if (ctx->submitter_task && ctx->submitter_task != current)
>>          return -EEXIST;  /* register.c:733 */
> 
> How is this a protection?  I thought ctx->submitter_task is about
> IORING_SETUP_SINGLE_ISSUER. there is no permission or capability over
> it against other processes.
> 
>> Without the equivalent check in bpf_io_reg(), a local user with
>> CAP_PERFMON can exploit IORING_SETUP_R_DISABLED -- which defers
> 
> I'd argue this is a non-issue.

Right, it involves receiving a ring from an untrusted source and
then using it. Any application doing that is extremely broken,
even without any bpf you can use that to do some pretty nasty things

   If you have CAP_PERFMON, you are able to
> mess with the process in many ways beyond this.  Otherwise, how a
> process would be able to get the fd in the first place?



-- 
Pavel Begunkov



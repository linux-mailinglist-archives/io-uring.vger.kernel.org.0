Return-Path: <io-uring+bounces-13251-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aAiwBzFr+2miawMAu9opvQ
	(envelope-from <io-uring+bounces-13251-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 18:24:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 79B494DE0F0
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 18:24:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 087DE3002785
	for <lists+io-uring@lfdr.de>; Wed,  6 May 2026 16:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF4393F0ABC;
	Wed,  6 May 2026 16:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="v7ZT72yQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5503EBF2F
	for <io-uring@vger.kernel.org>; Wed,  6 May 2026 16:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778084652; cv=none; b=n6irOVOmlO/2HHcqMpITnXVMZd8UpQy0VBTGJ4lxsxFqGOayTuzQ1OCjls33274FQx5A+Aeat8Fd7cwEPQuYNoEtCBJA6XDfOoPWXt+5gX8jjbSc5YF7XpsMcVV28+V4E+jLaMw++EapFOBQc4r2vXbLeG3RorcDxJYADXRR1l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778084652; c=relaxed/simple;
	bh=qO8DUvmNSuazRZ0RZr4meUAJLg4XGF6cPc07LSNB1bQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bwY94ACglKdgvB/S+83mpSnzbftC0eZWQSxQv7CpVi5Zghf8FYFODW9WXyhxphOTQlwJD1buPftQdZEZCNuht8GPNt6D8M7Pf5cZIh/yVfFnCdoX2b/9e7z1pnskHn1bx4GqL2vdF3W6MEArXY8ptjzv0btDl8gGiEMBaISUqVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=v7ZT72yQ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488d2079582so68872935e9.2
        for <io-uring@vger.kernel.org>; Wed, 06 May 2026 09:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778084649; x=1778689449; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DX9zglvN6CCtcxFH4rJpzlES9omzFIZuN+EZiEcQkvQ=;
        b=v7ZT72yQsJuH0T+VMexB2osL4fzGiSG6ZdIGqTM8sZMdzA1ArdugyoD01OKcW40xhO
         yd3P46JJvEfzVhGlPXIALtAcL8JaxCfl6naWm+aA08N/Lk/pnLM2mPMZ1oh+nHtZOtIW
         20WS57sNyUL98o/tO3+2hxiWlJZn+nLN/0tunUzqQqP3h2l9LCLEEVkWGZ3EXvtoOhaR
         K0WKlnlUC60jSZuZIWHSH2wNhwIcDGFZ/uTZ6msrbocf0CQxwV5kRlGToIjTi+CEqNyW
         ObdRuUxvfqvWkqryDbx1gr2EIE5DITWIjyyCiYRb1BhEG13MJjM/98V/p71AmfqqSAhj
         tSbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778084649; x=1778689449;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DX9zglvN6CCtcxFH4rJpzlES9omzFIZuN+EZiEcQkvQ=;
        b=o2l9PGp/KVMJBj1VqM1ftRTaoE4JLhd5xvwWOTF65bVKE+7/uNbIixa02c5c01pzw+
         RH91Ty5xx9s7uCfy/9DtbMU6M0uwf3CzIQuRiZEwq9C/16x3NULRlokofNyRmIFrtrJ+
         4z+Y3j+gCVJTKWQUybUfLAjVzEOWaK3HpDxV/9GcLKlG0zaOUmnPG5SbotBTQiYoZMjG
         nX8K9rpHEImYWmQKgW5jNSARtiYhZN4aI5BP13rWrnTp5ffl69ftLNM43ois0uq0Y/JC
         zn1Va/q7ksqT8R+NbOBr/hwmiAmlRAL/0q+KsdGxvUiYYEAnVjNSu3ixmMQA+7bS6Jrb
         EUzw==
X-Gm-Message-State: AOJu0Yx/SMgREtYEQd+5agQGRr6zXhO/NBf3K0FAqBfqTq8lTcSQqzdS
	Uz+F4yc1Z/+udBC5qn+XUyjkIgMairFpEJ4rIyrkzKWRG1LBjJb0YSUMTdGJp4KmW/dY5nGnMGM
	zeaLYGe4=
X-Gm-Gg: AeBDievuR9k0ZEOjF6nnEj2bctYBYpl1m6oJHgyE3VQZg5cL40uFJvFTOt93xAOnzn/
	zrzeqaDDe61/XMcORSgmeSVLbK1NAzKU6ZURw4HDs2guopkqy98tISf9FDenQY35EZ09VJITePP
	MHl5+n1ZnTPBT5OkDzMAM1cSR+G+Ia9Cm+KlvxGXZ0U7G9270mdwUuGjWXFy436AeOajO10ZmZb
	XxgLicjfkjUNXKZXrpe7nlCDTWhTiDtrdgf3B3D9+MPS45yPGU7WKSyFFmUoFqKpq+wMBLAMvgS
	RgOQCYgWA/flcsCLtZCWYFpU3TnYE2FqwNxMiyCUrSxtxtw5fe/nmmbCXneepGb9oKDJBmI8Ql/
	kTkH/dgW9fP6YYp6e/2cveT4AEGNoZv0bIVAL0qGLPBi8RCcxHc17v0yLtbLMdNg5TIlCCgKG+B
	T0DnEC1RUEehMDLhNEvxVB+KKGkiFuxzHOsXFtEY7KA/NieYFxjGaTqb+5XCq2RGYsL4vyTU22Z
	fFvyLQmJXXbQj7M3SICIgL7
X-Received: by 2002:a05:600c:4512:b0:489:284:44ab with SMTP id 5b1f17b1804b1-48e51e1deedmr68511985e9.12.1778084648609;
        Wed, 06 May 2026 09:24:08 -0700 (PDT)
Received: from [10.10.101.107] ([188.252.209.237])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-450524831cdsm15118753f8f.5.2026.05.06.09.24.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2026 09:24:07 -0700 (PDT)
Message-ID: <d4ce3d3c-0a3a-4aff-9d5f-418a3bdd74c1@kernel.dk>
Date: Wed, 6 May 2026 10:24:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/uring_cmd: skip inline completion cleanup if
 unlocked
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring <io-uring@vger.kernel.org>
References: <2469b617-3b4d-442f-84a9-7d1136d84065@kernel.dk>
 <CADUfDZpZJMdFywHApMO3h+bn3S-SCDvEAHJ2e9yGD0r=2kJ_FA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZpZJMdFywHApMO3h+bn3S-SCDvEAHJ2e9yGD0r=2kJ_FA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 79B494DE0F0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13251-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]

On 5/6/26 10:14 AM, Caleb Sander Mateos wrote:
> On Wed, May 6, 2026 at 4:04?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> If the call path to __io_uring_cmd_done() is not locked, then we
>> cannot recycle the uring_cmd to our allocation cache. Check for
>> that and skip it, and let the normal locked completion flushing
>> do the cleanup.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> This effectively defeats proper cache recyling for uring_cmd opcodes,
>> with the fix it's working fine again.
>>
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index 42be1be5b132..35e2aa8b9446 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -166,7 +166,9 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
>>                         req->cqe.flags |= IORING_CQE_F_32;
>>                 io_req_set_cqe32_extra(req, res2, 0);
>>         }
>> -       io_req_uring_cleanup(req, issue_flags);
>> +       /* defer cleanup if not locked, otherwise cache recyling is skipped */
> 
> "recycling"?
> 
>> +       if (!(issue_flags & IO_URING_F_UNLOCKED))
>> +               io_req_uring_cleanup(req, issue_flags);
> 
> Doesn't io_req_uring_cleanup() already check this?

True it does, I think all we need is:

>> @@ -211,6 +213,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>         ac = io_uring_alloc_async_data(&req->ctx->cmd_cache, req);
>>         if (!ac)
>>                 return -ENOMEM;
>> +       req->flags |= REQ_F_NEED_CLEANUP;
>>         ioucmd->sqe = sqe;
>>         return 0;
>>  }

to ensure it's called later too. I'll update it, thanks!

-- 
Jens Axboe


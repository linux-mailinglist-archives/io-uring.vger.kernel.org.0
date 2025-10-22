Return-Path: <io-uring+bounces-10101-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A8E0BFC3A8
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 15:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8E026269D1
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 13:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64AC63491E1;
	Wed, 22 Oct 2025 13:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="X/DF/cUu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53AB346E76
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 13:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761140075; cv=none; b=CuAob3SMucsYnc6bYlr+k//fAaLO5h0jal354ULM5FQaw5fGqpzdL3/4/ARBODlaA+oR6yh24GdS2gpojgHQzHyqOs6EYcx2IKiMdsdKX5hZgLVvj9ld6EPj01LW4+G8gZkE9IydWGWlL52w66SHP5RFTlfwMj+a+Wog9wmM+CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761140075; c=relaxed/simple;
	bh=4PnkTP9Pu4f71u/WXu4R9YBsEe9bBIoQkb/JNrrqhD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N/NlrsPDewkF7Qq2K8G711x8PsMigSu5hB1wzkHZZLTEESe6PCFbOtACGH6cgsX6w6llvVd1n2/5yz0/YN4cAQgNhoeTKk8ixG25m+3GtwtJQ654T1/smuSuh4u+lOf0pGbH+9RCdXPhoDpraigAHN1wmd1N+vuZNm2w1Wec7yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=X/DF/cUu; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-940d92d6962so158393239f.3
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 06:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761140071; x=1761744871; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XV5vEDb+PLsuEAr5Dc791OLpoWf+84eLdNZr6HQ4S34=;
        b=X/DF/cUuipO+Q9xPebD34HjUPuC6vqbn3R3jfdwXPPJ0+IBRfYUnM6iLBCSFidmTTN
         I87vXCBurIcxr2vX70pRFoiEl341Xjp29FDfQTV6YOF/1hd3U8j604YCbQfKDjQYXxtD
         e/hi9A/AmgjHD9XqYuQKtdc+3m3OTbOiKwF+elrhfDml2i5kaYNqL0O8iVbjFuTYlf/s
         24vU7kfD/0uMZr3d+0Z+pTJWC16hGd503DgJtcI8bLlhMnD05AzC2MpN5SRT/GF1j1wy
         qq+wS6EOiJZ0hiFhhqBYBf0tE9mbnPNBxrnoXQIB7Dl9TvX6x5gGbnppqStl8GmIdjHX
         QDmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761140071; x=1761744871;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XV5vEDb+PLsuEAr5Dc791OLpoWf+84eLdNZr6HQ4S34=;
        b=cs3NdDMW/VTeVQEdQqHJnkgKy0jUPRXQfMZ3wFCLSGz0OIa9WjMcHeIGlSJFwz6zrZ
         U7tOq/ze2WlUuty1HALD95RugZOW6WozDhtXk0/WPozrWME6Oscvf5JbK65zqDCZ5DGv
         Uc/X9PPRZcFncsJvWegFAamTYYrKn97Cag3/AcwNCi/xrWfIISp4J2JCpydCYwgpB0KR
         AuqW3WB87q5+0EhD2khA3pbh69ki74IbXqWi2119N3rPLbkte7mdYi6go6AdeCFhXkMT
         IDd/vWBbwGJgBWhQYvEQpF2+gxxcUTm+g/g98F0bWz1U+xqTNbXyFmGrJor24yBg2JqO
         GCwQ==
X-Gm-Message-State: AOJu0Yz2N3pw1lQAM7WqKi8fiYDcmBs+bKI1ZWxtCl8f+huwHv8H0UE4
	dA+eEs0XeMTquUXh1hjGTlugIkzQ+7JMbNQyWT7UkZvlD/F/qLF89Hj5hVd2NHp2rLsnYNusu4s
	t7jsUOHs=
X-Gm-Gg: ASbGncudwcnrUqaLwUACrHi1/ctfKlVKhdRNczcnYLR2Tm4sgPPietkMw14YDmOnFq1
	ZR4GoU55nRGyZUN1NyHQb9/yWRVNHHs4axs2EAtyIzIQ9yqBRh4gjRAF7sMWT5X372dCfVBvcOu
	OY+PSFOwtAvQEMcmppkKqd8CcH1m6DEhCy6b/7ZnesQejtfEmpMD3g7Kpcw5bl7ptRY9eWMUzP/
	m6YXdsyZAB50bkmYMgAuiy/Z9dB5Ceoksz7tbQEFo0hzQiPgQHST3D07FPAjKGTBjtVlY6vf3zH
	OIZ9T8BWCsyTAuD6KZ2uNBc/mpKI6QFp2MGy6MKNMhny2QleRxftBvKwgv9P7BCJUjMYDA5JkQr
	1eO2OGv7v7WEIwbEbHAiqxalNIeDQKaVEbYrOk6pgS3cFRtA5VyXG/37m+l913sF0hxLCdqMMWI
	RAAZhzrt3CJRWBGKg4fw==
X-Google-Smtp-Source: AGHT+IFc8uoj4Do5t5zb539hS6BCkySzVR8p6zymdCVAWTi1lnzPFJD9IswWcUa1DASlGW2uIwU4ug==
X-Received: by 2002:a05:6e02:1d9d:b0:42f:95a1:2e8 with SMTP id e9e14a558f8ab-430c52d5786mr269032565ab.24.1761140063517;
        Wed, 22 Oct 2025 06:34:23 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a9630bf1sm5181320173.17.2025.10.22.06.34.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 06:34:22 -0700 (PDT)
Message-ID: <4ea25979-4fc2-4db7-8656-6c262af2cbee@kernel.dk>
Date: Wed, 22 Oct 2025 07:34:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6] io_uring: add support for IORING_SETUP_SQE_MIXED
To: Nathan Chancellor <nathan@kernel.org>
Cc: io-uring@vger.kernel.org, csander@purestorage.com,
 Keith Busch <kbusch@meta.com>, Keith Busch <kbusch@kernel.org>,
 llvm@lists.linux.dev
References: <20251016180938.164566-1-kbusch@meta.com>
 <176108414866.224720.11841089098235254459.b4-ty@kernel.dk>
 <20251022120030.GA148714@ax162>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251022120030.GA148714@ax162>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/25 6:00 AM, Nathan Chancellor wrote:
> On Tue, Oct 21, 2025 at 04:02:28PM -0600, Jens Axboe wrote:
>>
>> On Thu, 16 Oct 2025 11:09:38 -0700, Keith Busch wrote:
>>> Normal rings support 64b SQEs for posting submissions, while certain
>>> features require the ring to be configured with IORING_SETUP_SQE128, as
>>> they need to convey more information per submission. This, in turn,
>>> makes ALL the SQEs be 128b in size. This is somewhat wasteful and
>>> inefficient, particularly when only certain SQEs need to be of the
>>> bigger variant.
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
>>       commit: 31dc41afdef21f264364288a30013b538c46152e
> 
> This needs a pretty obvious fix up as clang points out:
> 
>   io_uring/fdinfo.c:103:22: error: variable 'sqe' is uninitialized when used here [-Werror,-Wuninitialized]
>     103 |                 opcode = READ_ONCE(sqe->opcode);
>         |                                    ^~~
> 
> I would have sent a formal patch but since it is at the top, I figured
> it would get squashed anyways.

Indeed - I'll fold this in. Keith, can you add an fdinfo test case for
mixed as well?

-- 
Jens Axboe



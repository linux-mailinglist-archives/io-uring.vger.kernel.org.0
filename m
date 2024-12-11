Return-Path: <io-uring+bounces-5441-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A01039ECEF3
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 15:47:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02062162486
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 14:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D03F24635E;
	Wed, 11 Dec 2024 14:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T/WOxY4K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0702246342
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733928460; cv=none; b=PP9zrrQI0PSV9Sszkk7TOZ0T5axZ511TUbqGIEPZjAcTIA7p490qcWFYHKIKQTGuyFehTeSUo8cCP1SvNmkv7TV/HxjkbYrqGJ22HNDEcsnqDsH9+MbKyxpOXPBNzUXo3um/BAf84RZd3SCBExNqz3CG0mOFc4Mvwo6ag2kNV4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733928460; c=relaxed/simple;
	bh=f/yv/dJrz9R5IVrX4pdSRjZy3QjPmCg4eEOwNUaM0dg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rCmfe06AUHlJLHE9cdHwf292DDn4lby73IBdgfv5liBFmztEY53CLZY224V5cs9v8vyOd70xGgvKxg5Wyrfy2Vwvu0Ktq2ZerFanyfoCurNIooqD23eT0Xv/dGsvreZFmeFw3gDRCHK+P+VnuqR2efNLOfExxXEFJ/9Xs+2CCLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T/WOxY4K; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aa662795ca3so153175266b.1
        for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 06:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733928457; x=1734533257; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ja8nlubTbXsPowp1tPLGhan4myxVNf0Pa7sWOLIwfIE=;
        b=T/WOxY4KB25vgxgYurSoNvyQoVOrsKusVm/8s1YesZLBBGpmgUlT+FRAcymIf5WO4m
         x8Iw7juTCtaUaa08Zw6c91fbIbPTJBrEBenRKqDsawndxj5NkKMD3BOdrAMVg7Yner8l
         3yi4UUB83q+FHwP4R3mozqryqR4UDqsNKqwoTGy0/eukjm52BZ/OCVvCKuOUKGacqxTF
         urFPZ0ec9QWIMP3PLDMSdrTlt000vj98Ux2ZXrTxsqXMv0EE7EL6ckGJY2Ki6O1QESW+
         GYzJy38WN4i7huaFrZPbd16BouZYQhH36bcZs/msPoXeeH5RFu5cwuUipXZl+VpZbFF7
         fjfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733928457; x=1734533257;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ja8nlubTbXsPowp1tPLGhan4myxVNf0Pa7sWOLIwfIE=;
        b=ZW97TlgMsB8KjmfWOEHRNlWYg2dfNZTbj5z33FuEQhaJ5DReghJB61Mt6DhfE32DLQ
         b4tVKMvGBSKLgyhUUikDvXuu/BOtQdw41ytmbXAT34k4Kp0RrpmxgfvAYnYOOy+E3JYd
         q40ugT795rcb5GDNRRhvxVbEVCPo//oplHV0/65U7pmTbbJRWptWHb477QpwPWZ+Abky
         pveR7u71RVV0IZmJeZWSvgh0ZYIvZ81e7uN5HWO7+niTO9+KOyBIyI4acQrMyRXbqMWM
         I6o3RotDNY32b42PoSY5tsbV4mrEm0o0O5IKrtZF5BuPydnoYGrcl34C0fLUqp1hd+qZ
         lE/Q==
X-Gm-Message-State: AOJu0YxrxpkQFmOpFIFpMmDOdJKjNSav7eUC5traUN4AtexBd9R+6yCC
	iPTFTn1uS52vfJzLGJ6qrqZ3cF4tQ6pBK5jkSJ38703kKdTUSPB2P5CyUw==
X-Gm-Gg: ASbGncvLw45pdWa2FeGG359m8We7btlihSj6Atj3PGdzXKGWf0yhG3oItfq2uN/+Oeb
	EVA2wdAOznd16pAldMYsCz1XMmy5TCd/M8sxfY0vJnlRy7kFLQrnt09eugJ/XnLUuGf//ii9CiC
	M5uQ8n9CyZEGbRlTiLOllDRadEFt9rwI9TJIkeRCCPXLR8VSnQVyevpAHRXGIR7BPC++ijob5NK
	ANtxh+E112+wZZMulEUNNR4EkQN0A/fDAn5CWutS/g64DPytYQzrwNB22t/Cpew0Q==
X-Google-Smtp-Source: AGHT+IEWfTlhEdkIt0xbUT1i6vq9KtS4Gtnrd0kSzw09e/0cqZHRpzBmpe9eQldrcmJRYxjuoyg2XQ==
X-Received: by 2002:a17:906:2921:b0:aa6:79c0:d8ce with SMTP id a640c23a62f3a-aa6b1555536mr251308766b.1.1733928456719;
        Wed, 11 Dec 2024 06:47:36 -0800 (PST)
Received: from [192.168.42.162] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa66ef6409esm613428166b.149.2024.12.11.06.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 06:47:36 -0800 (PST)
Message-ID: <39ba714b-c745-4fac-963b-822f55bbaf69@gmail.com>
Date: Wed, 11 Dec 2024 14:48:26 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 6/9] io_uring: Let commands run with current
 credentials
To: Gabriel Krisman Bertazi <krisman@suse.de>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, josh@joshtriplett.org
References: <20241209234316.4132786-1-krisman@suse.de>
 <20241209234316.4132786-7-krisman@suse.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241209234316.4132786-7-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/24 23:43, Gabriel Krisman Bertazi wrote:
> IORING_OP_EXEC runs only from a custom handler and cannot rely on
> overloaded credentials. This commit adds infrastructure to allow running
> operations without overloading the credentials, i.e. not enabling the
> REQ_F_CREDS flag.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
> ---
>   io_uring/io_uring.c | 2 +-
>   io_uring/opdef.h    | 2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index a19f72755eaa..0fd8709401fc 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -457,7 +457,7 @@ static void io_prep_async_work(struct io_kiocb *req)
>   	const struct io_issue_def *def = &io_issue_defs[req->opcode];
>   	struct io_ring_ctx *ctx = req->ctx;
>   
> -	if (!(req->flags & REQ_F_CREDS)) {
> +	if (!(req->flags & REQ_F_CREDS) && !def->ignore_creds)

It's not the only place setting creds, see io_init_req().

-- 
Pavel Begunkov



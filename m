Return-Path: <io-uring+bounces-12866-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YNBKJV2TxGnH0gQAu9opvQ
	(envelope-from <io-uring+bounces-12866-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 03:01:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ED3A132E255
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 03:01:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 47F2530C028F
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 01:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD6E34F275;
	Thu, 26 Mar 2026 01:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JJvbe2y+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1BE33AD82
	for <io-uring@vger.kernel.org>; Thu, 26 Mar 2026 01:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774489767; cv=none; b=sS2XBQAQuffal4xbHUHBSQesRJ76ahYsjuezZm4O1iArNPHGYT7fN7RRldgxJ2MxtR8vVcCT+utzbNwkoAkxHyNEDSBFhg8t/NPBbF6zhi73NIl95PHjwphCgUqPz3kzGcm2noPnYg4Z7GL6GVexV/mNRXWgLOsa/5J7S7tmMsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774489767; c=relaxed/simple;
	bh=GTaFnwGNfdgg0wmbzGs2jW7nDaj1/uyRzrmfCE5Ly6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y038ViiZCO4X9R3acnxWwhTt30vB1Peepc5J98wG0Vl7aR12pM6yzjwJqY3oxg/vYJi/UsH884yC8/7eFVhaTeR5nFe4Tj+mAL/VrL0fyb39xkXHuW7IzcAlYGEPvmkUA0X61X7N/34Zv/vAKuMBuV7NA1CayxVp91SUWZeO1yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JJvbe2y+; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-67baf20e8c2so261416eaf.3
        for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 18:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774489764; x=1775094564; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AzggYU7nJxlqFueGBHHNK6M7p48nU6BANSh6J3W16ms=;
        b=JJvbe2y+HHo0+KZPoyrLHwndHsiVBpCFXdO5fQgBURZe4uxZQ1QNc+MtOF/sI5qqYm
         N6llf6qO1tB0SwKCEjBhClADLVcTLi5JtcDYp9yhkkNpiVWRBZk/CQR0jeUpqRm6cEux
         UgV6arG4LnRa1Ruz5FgaEBxqjD0R/4KOCu9pPQqRo64mwBzckFK+bHwsOIJFwT1+sR6M
         LCvpCRCMTMOypTtnzHp75VjS9sgQeCrMwmN1f13kyQuMJWD4CketwMlvN8VVwrvae2Ew
         VbUBIU2CAK8SDNZKD5tuhLYEceqMhYz8+kR1XeXe0WX8x9BQgkaUxWzTyPg6l0z7/KuC
         XdDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774489764; x=1775094564;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AzggYU7nJxlqFueGBHHNK6M7p48nU6BANSh6J3W16ms=;
        b=lOvPdlWHBlHzH7WunSG3VTQMN3WIe66wvWwCdyzAgalzaZDh2kcRlR3s3zvk8km5N3
         iG2Icys+AF9wrUV3Ty5XqGDC5uIO8B6YXkd+xXs2IVElf+iTCNCxKmaXr34X0+Oox/94
         kVTjhgeFM1XV1wk4wkCD537We+Y78c+aPfSeBZbTOksYim6Pmbk1bRLZ831Gv3bbXx8P
         KZ35RxzeKmgK/7m5OeEY8PkVOBuTEprCukkSmpSfhYxq16elzT+23KMFvCsiLWMLzmPf
         e1ZvuipJXu1rX7ShvHf48XRFKbn9HIaTXipGGsf1E4peXhQQ/ZQ4PsnPOaRe1hsIgpMJ
         +aPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjGqffFXjeVArZNsvMshxW/3kbGnu0JrUQVnhR7dCRe4vre/6y1HlSPaBxftfL/k9o6y/cKFFiiA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw40lEaETwxP89SdNk3FT5ZFUnnfxJSAksvuMYy+UC3W6qb2UlX
	pYbiOerKchKvYpKfhN8VfomrixlXUZBaWOa/kY3qNBziq+HkBZeoCfo/q3O7/BjS6Os=
X-Gm-Gg: ATEYQzy4S0WxbJrMSvuGs309DzmkYy8SvoZn8Uef23+noK/RwXWvcRxvPWi5J3To9cA
	1C9vVuiOGvw0Mki0WkqIbnSsWUZXX3fosAV37VlVLuBsVXKrxngV3rp3F+JxmYvvbYy7y949RWG
	NLZLfIk0FmyhOwSXOgOGCOdlN6Po8Y+1uSm87RJm2N6meJAcR93tttYF97ZMdvgPw1QQWww/NuC
	cQz6bJJzvJXrOQCdF+Ttqarxsm6jBRrhhVe6fQmivWSZjiCNs97uel5fHDp407YtaBHiQvakeCB
	29lqjXgN61lD5wnIE5caZTOxPzCLs4kWDpF0s5GuubRceACeIV5eI350bJGVutqc39kbZtTZjYm
	KgWBmePejYtr8YSdeaW2b6ONg5KbQiNpqO+6qJcYxw/qGjamtsgFRPmJa2F0FJqkVN+XD1a381S
	POuu3LahcuZ2z+uFCcyX5Ms2s26OnS5Hfky0ycAx5llvq0xw5Dh4MX1VF/YBy+KQcbeUdMu6pSG
	oX3bgYprQ==
X-Received: by 2002:a05:6820:2294:b0:67d:fa15:ea48 with SMTP id 006d021491bc7-67dff59dc56mr2769205eaf.62.1774489764267;
        Wed, 25 Mar 2026 18:49:24 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67e0ab1b9e3sm969199eaf.12.2026.03.25.18.49.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2026 18:49:23 -0700 (PDT)
Message-ID: <5e8766d3-a801-48e0-8d27-60e75523ebd1@kernel.dk>
Date: Wed, 25 Mar 2026 19:49:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 05/12] io_uring: bpf: extend io_uring with bpf
 struct_ops
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
 Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
 Xiao Ni <xni@redhat.com>, Alexei Starovoitov <ast@kernel.org>
References: <20260324163753.1900977-1-ming.lei@redhat.com>
 <20260324163753.1900977-6-ming.lei@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260324163753.1900977-6-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12866-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: ED3A132E255
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/24/26 10:37 AM, Ming Lei wrote:
> @@ -493,7 +494,16 @@ struct io_ring_ctx {
>  	DECLARE_HASHTABLE(napi_ht, 4);
>  #endif
>  
> -	struct io_uring_bpf_ops		*bpf_ops;
> +	/*
> +	 * bpf_ops and bpf_ext_ops are mutually exclusive: bpf_ops is used
> +	 * for io_uring_bpf_ops struct_ops, while bpf_ext_ops provides
> +	 * per-opcode BPF extension operations (IORING_SETUP_BPF_EXT).
> +	 * The two cannot be active at the same time on the same ring.
> +	 */
> +	union {
> +		struct io_uring_bpf_ops		*bpf_ops;
> +		struct uring_bpf_ops_kern	*bpf_ext_ops;
> +	};

What am I missing here, why is this the case? What makes the use of both
at the same time impossible?

> diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
> index e4b244337aa9..e91c6964405c 100644
> --- a/io_uring/bpf-ops.c
> +++ b/io_uring/bpf-ops.c
> @@ -162,7 +162,6 @@ static int io_install_bpf(struct io_ring_ctx *ctx, struct io_uring_bpf_ops *ops)
>  		return -EOPNOTSUPP;
>  	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>  		return -EOPNOTSUPP;
> -
>  	if (ctx->bpf_ops)
>  		return -EBUSY;
>  	if (WARN_ON_ONCE(!ops->loop_step))

Spurious whitespace change.

> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 91cf67b5d85b..1af33a89ed2f 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -49,7 +49,8 @@ struct io_ctx_config {
>  			IORING_FEAT_RECVSEND_BUNDLE |\
>  			IORING_FEAT_MIN_TIMEOUT |\
>  			IORING_FEAT_RW_ATTR |\
> -			IORING_FEAT_NO_IOWAIT)
> +			IORING_FEAT_NO_IOWAIT |\
> +			IORING_FEAT_BPF)

Do we need this FEAT flag? If you think so, then it should at least be
dependent on whether the kernel supports this feature, eg if
CONFIG_IO_URING_BPF_EXT is set

-- 
Jens Axboe


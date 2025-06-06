Return-Path: <io-uring+bounces-8256-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF4EAD044E
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 16:57:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B863517AA88
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 14:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C02171C9;
	Fri,  6 Jun 2025 14:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hMtKoXXh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF54E1BCA07
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 14:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749221831; cv=none; b=KUUvR42KOdZGzz3g7htwibpaqPDy1Wq/eB2CnDGPlNdu62Ko2Ek+/qS/bC3sQOext7RanJuUzObAg/eq6L5Z9bdnRvQepaL+iFn8lXwwaqVUOb31CwEHvvBDqCCUzXI+oEJ3+KUSgAuJOCc0pZ2A4Idl4ckQuAVcAZVG9xH6RYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749221831; c=relaxed/simple;
	bh=5rLk0Y1o9Yqu936oDGAf+guTBOuXSZ/KP5hY7VpGzCQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X8x7Z87GkYHCV+5JEhopNr1r4wsUX/IbY0TXBx8Y8B6QlsX+FaIaxI6ItcIFqG9GuMg7XWi2UXnoIm2zLhMSwJ6pPhtcEpHeMUq3I66A0CemrD81GSpTOgnIX+gox87XRRNFCynVDxzzvJnNXlHyeCtsiA8RUay4+M+2zLOG4FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hMtKoXXh; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-86d02c3aab0so59968339f.2
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 07:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749221828; x=1749826628; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y4SilW7Kz/GqOrsdyu9o99hQfeO+kZMJ6kTTI3SZL88=;
        b=hMtKoXXh8+5SC4d//xyI/YsWQof1pTyJgp8PvZMRjJEr+ZXGQDP6PiKucpYcvXxhgt
         R/v1olg0Jg27bs2vAvbXLvE45rYoG68EZ58vWZtBT+YKvSE/Y61EG6Jgsuv5c7j7Q4CT
         N/ZaM/yXxUEhAabGOWU23a3e2mAqusOZvhacUnQPB8HTsuTR9UlfgAN8gIV3ssAnmWfq
         YqQLiPlal2Hv22VEolt+uyoxborkDCIxNRXuov18yx2KNRy3TAqCcSFxGpvuQVV8gXia
         HlbkOMQthwezDppKAreITxg5uCk6PNvrqFLM4Aw9kHo6ObeJR3xcgVGqd6O2DVHzEjiY
         Txdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749221828; x=1749826628;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y4SilW7Kz/GqOrsdyu9o99hQfeO+kZMJ6kTTI3SZL88=;
        b=M61OW+oeBsYVUQ5rJBH/YxQtF5/QlanEafWRjc4bDiCfWIbV5CumYCdTwf68EkN3WK
         +cbqfoQ6nN0j/8aMWa9V5L3JubsOE75u3KgRP3jAbfDIq8L9QKAL/GtsNenstBV9MvwD
         5jVlNxfgBJ4qxiH85Z2tiNSsH9sftT5zBs0SYlp95tJTLHi4ZTzniif1Ojs5PwGbqgkg
         z6nYcEcjv6xuawNAZeVjmC5Ki066X66iiQWn+KO1bmyV+T40FWkLAlB+zUQuOZhREd+8
         l80/G7miHSiBycTzgb0+5D1v82eQrpgPENV6tosc+eOQ66qO7RwYkJ5EnICgegM0jeG1
         mmPA==
X-Forwarded-Encrypted: i=1; AJvYcCXsfJ4sj3Og2YR9ftnOQJEbjbASqZ5E7kNhzaw4zl7WZROvkHm/Xu7yShjJJyBCSNy1pqnKUeeolg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWW83oX19jisXoRBRR6xtnGiCR2qu0Vk5VIREgPnlUwiFIw0JU
	DlZ5Wrlm87yNt6AKf4GyAl1GZJ+NC+/OHfrn0y/uYGInK345b+8Fha0HUPdpI1aC0f8=
X-Gm-Gg: ASbGncuVhAWO7JP86gLIs7cSqqAmu+3f7R84UA/eyVjC4fcM7XcqRMzfAe9EXTolyrj
	2ObcjqqZgPY3X0pGrycKcJIeYN970JBrp3+JwsGOgLyOGVB4KqNK1YRf56ka23ON0wTzCVZ4aIh
	Tj9piD3b8vTjROU5QXc79hwes7DHpiOx1Wu275LjC5l9VX++DI3gTFg0ljfugW9jRwTxjaKwmnS
	Iv9Y1OZuy67cQw2E3lSEe5zbfSce+st79qFrU4wwhtlFHfnf1yHByBsuYJZZb4ufLpxHR42TxMy
	+w32EHfeajXi9GMv15iJ++pEJaMCkCUtJ3LMYJ7Zmc34T3cKW0DQQxEo1Q==
X-Google-Smtp-Source: AGHT+IHCqdvcPc2EHD8OF2SGiY28FRz5VxV/iMut9sL/Iq4G5xTeNxhhacKuQVTKYCyvf5H+SS82Sg==
X-Received: by 2002:a05:6602:4c03:b0:86c:fa3a:fe97 with SMTP id ca18e2360f4ac-873366c4eb2mr364557439f.10.1749221827729;
        Fri, 06 Jun 2025 07:57:07 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-87338782c7dsm37099439f.2.2025.06.06.07.57.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 07:57:07 -0700 (PDT)
Message-ID: <9b9199f0-347b-42fb-984a-761f0e738837@kernel.dk>
Date: Fri, 6 Jun 2025 08:57:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 3/5] io_uring/bpf: implement struct_ops registration
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1749214572.git.asml.silence@gmail.com>
 <f43e5d4e5e1797312ef3ee7986f4447bddac1d3c.1749214572.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f43e5d4e5e1797312ef3ee7986f4447bddac1d3c.1749214572.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/25 7:58 AM, Pavel Begunkov wrote:
> Add ring_fd to the struct_ops and implement [un]registration.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/bpf.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  io_uring/bpf.h |  3 +++
>  2 files changed, 69 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> index 3096c54e4fb3..0f82acf09959 100644
> --- a/io_uring/bpf.c
> +++ b/io_uring/bpf.c
> @@ -3,6 +3,8 @@
>  #include "bpf.h"
>  #include "register.h"
>  
> +DEFINE_MUTEX(io_bpf_ctrl_mutex);
> +
>  static struct io_uring_ops io_bpf_ops_stubs = {
>  };
>  
> @@ -50,20 +52,83 @@ static int bpf_io_init_member(const struct btf_type *t,
>  			       const struct btf_member *member,
>  			       void *kdata, const void *udata)
>  {
> +	u32 moff = __btf_member_bit_offset(t, member) / 8;
> +	const struct io_uring_ops *uops = udata;
> +	struct io_uring_ops *ops = kdata;
> +
> +	switch (moff) {
> +	case offsetof(struct io_uring_ops, ring_fd):
> +		ops->ring_fd = uops->ring_fd;
> +		return 1;
> +	}
> +	return 0;

Possible to pass in here whether the ring fd is registered or not? Such
that it can be used in bpf_io_reg() as well.

> +static int io_register_bpf_ops(struct io_ring_ctx *ctx, struct io_uring_ops *ops)
> +{
> +	if (ctx->bpf_ops)
> +		return -EBUSY;
> +	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
> +		return -EOPNOTSUPP;
> +
> +	percpu_ref_get(&ctx->refs);
> +	ops->ctx = ctx;
> +	ctx->bpf_ops = ops;
>  	return 0;
>  }

Haven't looked too deeply yet, but what's the dependency with
DEFER_TASKRUN?

-- 
Jens Axboe


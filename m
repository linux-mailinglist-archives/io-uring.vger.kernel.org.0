Return-Path: <io-uring+bounces-9655-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0131B499CB
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 21:21:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC64C4E141A
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 19:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C38261B95;
	Mon,  8 Sep 2025 19:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="K0Q8b8bm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18328263C9F
	for <io-uring@vger.kernel.org>; Mon,  8 Sep 2025 19:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757359232; cv=none; b=pzDPPr6aMoO7DGPxxIaS8EMUCVzHHpoc721kLPPNtX8PRQz1bdtFMV7k0XDJEeHrKdtzslRb6uPgrKlnnN6pi0UZm1q782pHPx58TWFIL15aShLhb89ZDl/B/x8lY/SIX52tTvEPYJEKyxRkCe+0U7KBLwPxZB1xfFjLNqSsBRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757359232; c=relaxed/simple;
	bh=vcRykPovzDO3rQ/3VtONWIdwIzbOk95su0xjh1pc+Ts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=StCXb8W+UWn8eApIkFPbS6ZMuPl2zJVuTYboECoAZjmdejZRrGYdj/ihqUiLgyzbjtJ4NgbIoU3ncNUjdpr2Ptbvbzk5jvcCWQZHfmUHdoT84ovVvWCTfEjXDNVP1hROOeBYwb+Ov3zglYqxk/M6Nm7QISZhvkKXKU3RBNhQEvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=K0Q8b8bm; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-889b846c314so36903739f.2
        for <io-uring@vger.kernel.org>; Mon, 08 Sep 2025 12:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757359230; x=1757964030; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RWzSj1FMOLdM2Nk4IZ+iJU6xUGBlgzdtZ6KrMbT+oRU=;
        b=K0Q8b8bmgYD4OQ4Mk8B9nyrCseXKo71n0dkRpkGa7tvqf/aoSj8ECJmOn2bKfamuEp
         sw8+T2mTByylldiaP4X1X1Q2yUVY8+7FwyvNkWepjxPGCX3IjJ4VMzQd1ZUjumXZx9LT
         o6636KSOBLVhxPkxyRbJamiBb7+vHVu4M08muaGmZI6H0JiS3DJtXJmXK+jwKcu4ki2+
         S4kUBj2+GG/062j3mPbzoEG3HLF7hGF+l//qsnCewvdlKT9om8w4qO6Fi8Ciiy6bzgUv
         +P0ZsX2qpr4qi1K78RR+oZy/GmbSEjsEfdDYof328Xo0weUFtoDeqwEa4otG0++lhsV4
         jeog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757359230; x=1757964030;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RWzSj1FMOLdM2Nk4IZ+iJU6xUGBlgzdtZ6KrMbT+oRU=;
        b=j8/MRNSuxcadtoN/ZLs+p7h8ThFi3ojMJAGaCqWIisw4qXpWG7ykNyKhkfl+kvaCCO
         iF6d3sV0mM9AJLlGFstsjL4KVSedjjYT3UJvlzVlGKOTgpZu48Fdhylq7BWUpNS7Hubj
         BsstUOHhMToOBNS+m4f4SnJ+bVb+nU8lx5aPFo/aIwuE+LnXrATF/RrqxL5WuCPezhDF
         fo4sRSm8iv9xMbLAculEp8aJ4+/vcqOBQmaV2P+ulG+xGpmBE0opKa2O0HgMurpu3FOu
         1kw2P+5nAjG0c1+IvZeda0/IrthGUumxDMp1NoXX6EZGt/YH4VqJh657bNa4owlxkGOu
         04SA==
X-Gm-Message-State: AOJu0YzkYuRxg5T5Sz2NK7+Xsf38A3nD5dStdrbUrr1RmD3w06IDkCpl
	W/bcEm6xfz3yfecOQ6xDCGDgnyf3d74NyF6vio+aOwZH6SBCZzWfAPszCaWIp1OMdC1lJs4vET6
	FWEaR
X-Gm-Gg: ASbGncvXHbWYMsyV7D6UOE/oAJC3USyQIugbHzU9jFYUStstCgAHVKM1igvNHdDZ7aK
	bOs0MDycmy6w3iZEHuW9m3vSpmmKkKTjUNl/41qJQBDODSkTr7nk6cI8bhz4LLz+gvWRFZpNZew
	TaH8dFtZ62hdhorbQK81eQtAk8Px3lPKYg5TqePYkYuZrewoGhy6xduUfIVLNaBsJJ7B3uTRfcN
	cdGR17AhE8Otjdv+6y+bUC2xR1d6YJcajNEhO+gEZ+sG3UMW8h1+xDh5ZhNOV/O9IBB9Q/BNqVy
	ubv1cc0r4uk/Zi/n9CCG5A4hjAhmQTCm8KHhYryT/9lH6/SycnfFfYZv7rWGuA3g40GNfJ2XpeO
	x9F5tw1JdGzTCx+pGB38=
X-Google-Smtp-Source: AGHT+IHPERXnh35U5KLN0oB9XHU8r47sGlqZ6/yemRyGMlR8wQlND1vUeWOzfK2ZkSssVIRR5XPfbg==
X-Received: by 2002:a05:6602:1505:b0:887:118c:34fb with SMTP id ca18e2360f4ac-887773fb5ffmr1486323639f.0.1757359230130;
        Mon, 08 Sep 2025 12:20:30 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50ece96399csm8341428173.20.2025.09.08.12.20.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 12:20:29 -0700 (PDT)
Message-ID: <4812e4b2-b7e0-45e6-b465-e160ac267939@kernel.dk>
Date: Mon, 8 Sep 2025 13:20:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] io_uring: avoid uring_lock for
 IORING_SETUP_SINGLE_ISSUER
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot@syzkaller.appspotmail.com
References: <20250904170902.2624135-1-csander@purestorage.com>
 <20250904170902.2624135-6-csander@purestorage.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250904170902.2624135-6-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/25 11:09 AM, Caleb Sander Mateos wrote:
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index a0580a1bf6b5..7296b12b0897 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -121,20 +121,34 @@ bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
>  
>  void io_activate_pollwq(struct io_ring_ctx *ctx);
>  
>  static inline void io_ring_ctx_lock(struct io_ring_ctx *ctx)
>  {
> +	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER) {
> +		WARN_ON_ONCE(current != ctx->submitter_task);
> +		return;
> +	}
> +
>  	mutex_lock(&ctx->uring_lock);
>  }
>  
>  static inline void io_ring_ctx_unlock(struct io_ring_ctx *ctx)
>  {
> +	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER) {
> +		WARN_ON_ONCE(current != ctx->submitter_task);
> +		return;
> +	}
> +
>  	mutex_unlock(&ctx->uring_lock);
>  }

I do want to get rid of these WARN_ON_ONCE() down the line, but it's
prudent to keep them there for now.

-- 
Jens Axboe


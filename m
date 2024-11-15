Return-Path: <io-uring+bounces-4717-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 476E69CE180
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 15:44:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E79311F2115F
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 14:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7995B1CEE97;
	Fri, 15 Nov 2024 14:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MyNg62Sy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B33754769
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 14:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731681886; cv=none; b=G6eFaUx8q1XEv9vzQ/5IWYWzhxpq/zvY2ojLjVmRKWPjE6UQ9iLcKfLumT6KRCnSg3dmDfRwXBeyLjMjHx8x2gnLVxEryAsN7SOsRjBty02MpIvImba1x2W/tkBB/ZVHdK4x4iF7kohJoNMEh5zEn6bftfvhtPuvJSweA4EvZ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731681886; c=relaxed/simple;
	bh=sliCBDy3xzT9tSxC4hfpbA465KRX3eXIW2Sf3yYjtz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BTk6r3VOEAz1v5YQvW0fbrwj78TDmu3RIz4EwjWldBW40t8qBAlWraqSHLZybZAvId9zdSMdZkwQBOrXtPTHSmeFRp9UkChYoLBpQsk+71ytjFIKNYDHuzzntns1FVN556v7bFfw/TfDXA6K7ktxcZoi2AAYBDMVoVi/6C/nsvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MyNg62Sy; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3e6075cba82so1101225b6e.0
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 06:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731681882; x=1732286682; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NY4ekCIco7kjju0U19tJGE0DaTlYgc+R3dCSvLjiMCE=;
        b=MyNg62SyXJsQFTEUCUqlhKq4OS76hAwDptlIL0utjeyhJZv679R5vw+4hkA0Q+y7fJ
         FLKiWlY/hc1wMP9UsiSOlbg4WVx/9cwiW32y311uTtQHDGxMul3MpnQeRhzcKYkCK/8L
         TtPguwFk/r7jVwPp7k+PZDpfZbr24JIkVw90E1B+wteLHcR4s+iNFk2bhZY/Ju56Vda9
         dQvwKYr6SJnjBy8dhekjZeOVp/QXmLJxC9okTIqceUhzBmLIlXVhVsm21bVghwdKDHpf
         HM1EqOxeTIbCE3mQl8qNcYhMKRe32P90TzSQBpeltWmFodFsp0ntdWHDhu5uElfxLuwf
         M86w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731681882; x=1732286682;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NY4ekCIco7kjju0U19tJGE0DaTlYgc+R3dCSvLjiMCE=;
        b=u0Eg1LslqxjDvGE/DUeTEMPs4KsoNXdHOmr77WZZcSKcC9II+qu8VRe9t+Zst2p7P1
         EUyv6PGH1swGGZShCKKfak6LSQH2UByQznCrXVq8JrjpLAgtpyuH0xSQ2ejdhYwZ28rw
         7xRKuzlpENe6rlIMqeCsuOnQtAKFb2JFlhnsc8hxgNp/TpjM4l11O1YYEwJaSrvnuwcj
         KSNcLzQVdAM06GGg16uagNNNJRguLuTgsXGZ50XApeseTZFBOiHT05jY+84pogkvx8uW
         BpTAI01UwVXV8zVKPQSRmQB46Do+FXH6fMu3c2fPlb2XoAndmg/rJNMMrSknNRcEWHRH
         hcqA==
X-Forwarded-Encrypted: i=1; AJvYcCXwQW0pITqcjrxf3qYrYknwDXkWIJGDrISN3+j1WL41p5z78h5ZVELkWBNZfYllgOvOBTWTC1cKuA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfFOHbqz/1HjSTA91soVJ9fGSpbH+BVjTh00iYczhjIyJUq0Y0
	c1OHz5Fg8agPKVXYBbPO+PDEnbROVtflAjDz2sQVIDWYCbzMpWB/R665UczlcHUVVjx3OzUDPB8
	snxo=
X-Google-Smtp-Source: AGHT+IEsdBwZZ/uSjM5+U7Z+/b7LOEfYGf4+dRINQgCSzH/roupntGBVq9Nqrxtv5auyI41P9oPblQ==
X-Received: by 2002:a05:6870:56a2:b0:277:c113:5b26 with SMTP id 586e51a60fabf-2962dcc7206mr2308088fac.7.1731681881966;
        Fri, 15 Nov 2024 06:44:41 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2961092cba5sm1465674fac.22.2024.11.15.06.44.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 06:44:41 -0800 (PST)
Message-ID: <073858ab-ad4c-4f57-ae3c-b9b30c59fc6e@kernel.dk>
Date: Fri, 15 Nov 2024 07:44:40 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] io_uring: introduce memory regions
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1731556844.git.asml.silence@gmail.com>
 <cd8e0927651ecdb99776503e50aa3554573b9a61.1731556844.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cd8e0927651ecdb99776503e50aa3554573b9a61.1731556844.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/24 9:14 PM, Pavel Begunkov wrote:
> +void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
> +{
> +	if (mr->pages)
> +		unpin_user_pages(mr->pages, mr->nr_pages);
> +	if (mr->vmap_ptr)
> +		vunmap(mr->vmap_ptr);
> +	if (mr->nr_pages && ctx->user)
> +		__io_unaccount_mem(ctx->user, mr->nr_pages);
> +
> +	memset(mr, 0, sizeof(*mr));
> +}

This is missing a kvfree(mr->pages);

-- 
Jens Axboe


Return-Path: <io-uring+bounces-8653-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D28BDB02AA5
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 13:33:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B8B44E4069
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 11:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA2E1E991B;
	Sat, 12 Jul 2025 11:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YZNr5dne"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69186179A7
	for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 11:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752320026; cv=none; b=YVeND/sESu3NwBGQxSrTNHc6F3Vz+jKaAsCkw3PzhsQVrR/6e8jmtNK7Eaj2VsnTss7dSX+IOrJaMmHGyMJEP4idQf/fkqiK1YUD+lT8kNdXZ8gpf/wDEr9+3dF44efD6ESlCV/asI1Up+xxsxC1ntsBy2Ga2DJAv8gg2iANu3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752320026; c=relaxed/simple;
	bh=hi4dm3lnMGcTuuJp2Sh0asOH8jK9Vj9+eYX/vh7GCYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=r8Q/xtHAO6oQA8DIFCkhSwAH/F0xltKub3GazSLdOs2/KX0lW/FCkW2FfgjmWnuLX3Wy6Jc9yKL6xtexmI7ZSijYj9nIrX/Mhj5YqaexCB7t58d4FJXRYq1HO1uxxLgQ19DfHDy0FK2i/3QMEXZnNensm9X7pQ7mnDMUedXsgys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YZNr5dne; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-60c79bedc19so4961601a12.3
        for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 04:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752320023; x=1752924823; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F4OwpWZVRTEJeYHTDVuSt5MwOtFkXUZJC9AsjieUA8U=;
        b=YZNr5dneItF4T8dfoeyJvcjSlRMtH+cFfxk0Y8gpJ2K+PtCny46N90DYv1lEIA4VMY
         a0W61c9ZoJZRiWV6L7TllxvUDbMfv40UEXjvMszEr8X1hdUcO/SJCVl9zJ9YB2kC4qUm
         h7o8rh7n/a6Fx5bLZvQpCw9rMu5mreU1kjwzNNuIWkiBku1xxFmG6nIp1WmUjJbfj3J3
         rk72wVP/2J0sScJ1COeJE/YLCsoVf9AOz1Kd8iu63MzMARxDQ3nc0yO2HZp70vfC/ZLL
         8rfBpThaOhXWie8GcXT7US9Qclno0SmpBbWmkGMhgloHwF3jLEwFjRUSkZDgYNLwxVkp
         2iQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752320023; x=1752924823;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F4OwpWZVRTEJeYHTDVuSt5MwOtFkXUZJC9AsjieUA8U=;
        b=t0Bew/78g0WkUODjn4zm8pvUFBVgQxaq4QkynY8WiOsaKMeIGc+euFCTDlKLV7kyA3
         dfk0m6awZhiDR2wiYHl97f3buMu8jiKd40J36b90sHUPL/nNxvbKbeajfkHOdraltoJe
         8BH3TmxuN2yX/wZWnOtf533j9WHAf9rHwX3yk/yV+azK314lt0+cippvPA0VO1ON8A9G
         h8v7t131R8KAbpxtINXt5o2LUeg7POTcI2AHcC0VmDBMrI2WiNfg/oP8QFM9GkDvo04/
         aF0PyUmOjEikboZw2nQmEGfSCAKPgFwYkv7f4ssnk9FhvnPXGsQ918spKbnw6oSy+GUI
         /l6w==
X-Forwarded-Encrypted: i=1; AJvYcCXH3ikyWIro1OK0un6ZlbDz/lpJbsp3QInItivGnYRFOOp+74o5YElvn9atiuBNOA5OdDIAymheqw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw97bjD2RheDbdbE/8AiL6uI5pJOX3XQ5bFZZjyVAEyGMWaQxh6
	IXjYjDiEAoRae4zmTwSM74HtsCjSMIs182V6hidoU1ZTvLznTKuy5jKfA+gXqw==
X-Gm-Gg: ASbGncuvaI4AlNttk1dRmywhWbxIfcZY0tKA/A2JWVxWhrcRz74OeU3okSVLGAnpTBF
	JKv/grqglGKKMNQ9ejXCeGPmQKUC4yTK9EFq2EyLA3JfSxJj6aPDyAuSbNC3PKEGyAjFDBnjfCj
	gQhqMCaG2ZGh4I+GBPiUbousrcBRq5L6i6/+yW3AzbRbNppF07ph4TWYMNQurgJ2v6YRHy7Alc4
	L8O5zP6Scp0Hlsq8KN8wvgpSm3ZJaVVyrw3H5lrV9/jjY1yYjDUi4dfe1Zk5QvgvOm7cJPHuNJG
	hHi/AeCtsEpNAIr416rb8anDIqRBmH1kktaeAV6o76NDPx9QrsRcD9TvSz+kcsF+/uUqJvwY3Zx
	WH3acQe/U17+RtHmOshDKs5RlIojqhFrZURw=
X-Google-Smtp-Source: AGHT+IHMA06qfXRM12T6YrR4mrR2ey7gISKSy021RLwGLypKUK5GjgFNNrvMYZr2fnhw29vIZe8OAA==
X-Received: by 2002:a05:6402:5206:b0:609:7b40:4e8e with SMTP id 4fb4d7f45d1cf-611e7658075mr5634253a12.10.1752320022358;
        Sat, 12 Jul 2025 04:33:42 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1ac? ([2620:10d:c092:600::1:b2ad])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-611d04d8347sm3209118a12.42.2025.07.12.04.33.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jul 2025 04:33:41 -0700 (PDT)
Message-ID: <7541b1b5-9d0d-474a-a7d9-bbfe107fdcf1@gmail.com>
Date: Sat, 12 Jul 2025 12:34:59 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: add IORING_CQE_F_POLLED flag
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
 <20250712000344.1579663-1-axboe@kernel.dk>
 <20250712000344.1579663-4-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250712000344.1579663-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/12/25 00:59, Jens Axboe wrote:
...>   	/*
>   	 * If multishot has already posted deferred completions, ensure that
>   	 * those are flushed first before posting this one. If not, CQEs
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index dc17162e7af1..d837e02d26b2 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -235,6 +235,8 @@ static inline void req_set_fail(struct io_kiocb *req)
>   
>   static inline void io_req_set_res(struct io_kiocb *req, s32 res, u32 cflags)
>   {
> +	if (req->flags & REQ_F_POLL_WAKE)
> +		cflags |= IORING_CQE_F_POLLED;

Can you avoid introducing this new uapi (and overhead) for requests that
don't care about it please? It's useless for multishots, and the only
real potential use case is send requests.

-- 
Pavel Begunkov



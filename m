Return-Path: <io-uring+bounces-4369-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C585E9BA85F
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 22:47:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 807F7281AB0
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 21:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D20189F33;
	Sun,  3 Nov 2024 21:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B2Fd7E0f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28C6E552
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 21:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730670430; cv=none; b=CUtOEy4qKrFBB4pzdzix2juClufcjHSuoBtlJIxNbHtAc7GO6YyvXk3/5lKeQ8vPFIpy8hIVgUJVdxSqk2M56wMQVBE9LIU0YcFErY5h2N54tBacdnCjpVuHkFx8UhTnAJRPPyXkP+oA3TtO+hbfxgNt0AotQXtWly71riangBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730670430; c=relaxed/simple;
	bh=mDqSIZN2TNjQqiMiFpU1trVq5il+6jiYAZJHDE7o4g4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iEas2t2WRaGeXb6uqRiNfeFgARgaCQBze6e+Pi/4bta6c2uOBnxOWF6fDDgUqBrEYU7EObBnH+I3ls7Na/sDT26TDOYNWB9/9XhY+yhYU7c+v0K/gHko0aFC3SLYeAuWZqCNdXB8eo8aQtZVNnfSeJ0h1L7uXlNyy7tluPJhUH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B2Fd7E0f; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-37d47b38336so2693352f8f.3
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 13:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730670427; x=1731275227; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ty+RdcM6KnoADbI2CnTYvHIptTP9vNnLhojipzxT4j0=;
        b=B2Fd7E0fKR4cgV/T6chzeWg+mgsYmHHOSFtJkb7p7tEetlO2jG5eQ4JpyEj2gSg6BM
         I3BbNODKR+5r+5fL3bSmrfkM0nNENCj+zVZsMTI4wnIOYfLvrs+SL5Lo2Pxs8I+p+dH6
         qyzjWC1nNBfcOrfo0Qk/F8tAg2USMGu8SWkrc0/niEmyyzVE75/h7G4EIOlLDbuHENI6
         wmHpXFcZBVT8MbL24sSM5OprXQUqcV/blXFzkRTaWSroG2Q8JlJhWIchI1QejWJ4xzfk
         R+FgJ9mS1o3dtYQ1xqFwQ00XA8ETO+AL6qAoBWj/kbMSxmU+1jZi2UAhH2C/+kIBSINM
         2uwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730670427; x=1731275227;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ty+RdcM6KnoADbI2CnTYvHIptTP9vNnLhojipzxT4j0=;
        b=saCpf/NxIo1tnAwbcMFcahMeNFNeRUQRKynjhH4SGowG+cHWeAUEn3RtpujB0bxKtv
         tWPFwy8+KWU3R816UTkYRyipQ9MD8ycaQPgbw00IXaSFIm68xMCUGYQ2wpa1MfZFfoNv
         D/kWoMXtNuDiHLQmZJthJgtmNyWR97Sq3pNMDksRU1V20vJyVQqr7FvKMx4Hnc4a5XBy
         mmQg2g0yyF935rfdMZELtsHjBxoTn5CTS6MiVmZ9ZZGfWTMDhaoBjeeqlGBqQoTlvR8H
         kkLlwTjPPxtOShU5qBVytQ/C6SirMHANYvFolt8UAG3aI3PPGXu5eHr4S0zaXrKk75C0
         oH4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWYVaGupUpoL9IiHVPi1+eQm6vepBAEF00SMnc4AWdIuDtYUHgFxqj6kwxhb6gAY1RX4zwQaisS1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXeuYOcX5HJSA7y29qv61AN7TpzKk0bXYtXloaJa5j6s3VWB6/
	KHlNYVRHDrxDplFifrAUgI/LT5PnPCjEOkGFBBdwrm6NuMCoUhbb
X-Google-Smtp-Source: AGHT+IEHVv9tHgUrR18k/8gPTPZip32GRPwbullzVwWC4E1VvqnTRviLM/B1+8lsE52na7dNPngQrQ==
X-Received: by 2002:a5d:5f54:0:b0:381:c811:d2a3 with SMTP id ffacd0b85a97d-381c811d382mr7078659f8f.39.1730670426879;
        Sun, 03 Nov 2024 13:47:06 -0800 (PST)
Received: from [192.168.42.207] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c113e6aasm11487018f8f.67.2024.11.03.13.47.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 13:47:06 -0800 (PST)
Message-ID: <8025a63c-6e3c-41b5-a46e-ff0d3b8dd43b@gmail.com>
Date: Sun, 3 Nov 2024 21:47:12 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: move struct io_kiocb from task_struct to
 io_uring_task
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241103175108.76460-1-axboe@kernel.dk>
 <20241103175108.76460-4-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241103175108.76460-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/24 17:49, Jens Axboe wrote:
...
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
...
>   	nd->head = prev_nd->head;
> @@ -115,7 +115,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>   	notif->opcode = IORING_OP_NOP;
>   	notif->flags = 0;
>   	notif->file = NULL;
> -	notif->task = current;
> +	notif->tctx = current->io_uring;
>   	io_get_task_refs(1);
>   	notif->file_node = NULL;
>   	notif->buf_node = NULL;
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 7db3010b5733..56332893a4b0 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -224,8 +224,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
>   {
>   	int v;
>   
> -	/* req->task == current here, checking PF_EXITING is safe */
> -	if (unlikely(req->task->flags & PF_EXITING))
> +	if (unlikely(current->flags & PF_EXITING))
>   		return -ECANCELED

Unlike what the comment says, req->task doesn't have to match current,
in which case the new check does nothing and it'll break in many very
interesting ways.

-- 
Pavel Begunkov


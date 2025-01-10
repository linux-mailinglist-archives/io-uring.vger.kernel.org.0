Return-Path: <io-uring+bounces-5812-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1168FA09C8B
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 21:40:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CB6B16B50D
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 20:40:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46B5212B06;
	Fri, 10 Jan 2025 20:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ckSeS4J9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B61C2063FB
	for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 20:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736541605; cv=none; b=theNfK+FojFMxyb3hU9LFmacUJlyhmO1bex1uwwLthdtyYmx1qlCK50uEfzqYGy+4XB2a34d03vXfwgxNxrxSSXBbEPC6Mw0qhECj7t4Os0eFwM086oHaECeYzIA8wcVgY2PAMm3BzAJXt4eZMJC55HP5RAjCZmMns6KGdNz+7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736541605; c=relaxed/simple;
	bh=wyNONi3yxSwfHhUM1MkIzwhgouiPRpBwI63r5WhOE4w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RYJNn+RBuOx/nfQLEvXtnrSTS/C3jPEamvQxK01HwZn0zKBX9gEjU0gwL6/S7X7m/Irndc4VR1JaV4ADKZlWoYjTugF0xiRzuxkJJAIulpEfC6GujEUbIQlO/5oJDvvh8qxev9kFPrU6XWrHfRk4JhSBQCfUL18u/QdQkiGCbBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ckSeS4J9; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aaf6b1a5f2bso660722166b.1
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 12:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736541601; x=1737146401; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hk98SrsZ2ZZoOs5IIDxGuJRIx3zry6RzJb6JMAmT3DU=;
        b=ckSeS4J9wTF9Eev6bJxynV1tVcDw1uNYLfms5VbYWgYWELjPeMbm752zqzGLt7rjUG
         JDmSmJ3ozYLoOG6k5UnjgWa9S8d8y90GPIWSbNQWEsqR3jC6+STLy4I0XpZMGb97xWQE
         J1zX3BHTOh6JKo6/D40grAud+tp8R9Y20EwakLFJG0rPBlnPwaAdIFr1TeneZoAGRZWr
         xzsh7l7HAcShiQanBj+apSdTVHIHZX+hUKx3x6zIJyYu1BtyqpQZQH4nSNWLxN8x2xAV
         1DI/1EPAD+3QRnSRTUEFHrgn7zeLCZz4CYoRR1lcPPk020D8wzAIzIBbUIQRFNA67MpC
         WtAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736541601; x=1737146401;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hk98SrsZ2ZZoOs5IIDxGuJRIx3zry6RzJb6JMAmT3DU=;
        b=GwJrRgUjdljSCwhkJ5m0/ROjnKk8zc8bMmgC55oCSVFL7ogxDqRQvbQblM9FM5r+rW
         KTSqACKU2WCQ7iT078MMRdkuyX2+CRWiTFVxt6ASqKkh+oGsntfNmDebrqoItSnlLqYv
         SGyE+YEL9VGuTbq5AJAa/2JdrfC7KvEcTDLszhro9OaoDJW4AGc2tYxbu3myUr0bAJAB
         R0gmw7/qbsHCjkwgRxr6a/pDkSB+pP+h93Lry9tq32szUujlSslfSc1QSxsw0xuSerLW
         tLVJLexJQfAn4PfsK1QVVM7BPU02UjnjhxWrRMtScWhtj8uQEaT4+/9NkKC6X8amKcAR
         bv2w==
X-Gm-Message-State: AOJu0YwNL7aj207MIG4q9TqRlH90DuYcW4pNuXKUlFShdxb2WS5DvcQv
	JLTDDaaIFm2ebVYzUDmK9rB3Ib5dcoOwNfc2fBEc9kS13pxdFN2M36frlfh6
X-Gm-Gg: ASbGnct55qgxKqHCj9/9B7i0IAr9y5jJ5kaHvhU710ErWVESR4kTh6a0oHQyW4L6M2h
	Y5ngK8bT6Tsbve5cLyRBYuguiR9yOQZk6D3r0gqzxe5P1ge3aTB2ONofD2ismWY5ohYtBpt7iDW
	NGTmVYFERKbOkeeddOYFAwwieU/uy/QAfVoNVr/LHzmwmKVLGrEO4EaBdXbLVxjKVCuaYpuH3Go
	w2SeLwD1L4QLnttYmfZrD9nNP/K6+AmIEBAPFM5JwQrw+KX9hga/kNrK73QH46gmdM=
X-Google-Smtp-Source: AGHT+IGSKEH9Xa5aZ7nqI7cnDVtEwnD6/4a3A8nIiqMlABOYovH8D/co8tfbuBrgpHxeYDsyKWVBug==
X-Received: by 2002:a17:907:3d91:b0:aa6:7ff9:d248 with SMTP id a640c23a62f3a-ab2c3c452c8mr773871266b.8.1736541601355;
        Fri, 10 Jan 2025 12:40:01 -0800 (PST)
Received: from [192.168.8.100] ([148.252.141.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c9564865sm203029866b.108.2025.01.10.12.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 12:40:01 -0800 (PST)
Message-ID: <19e47e09-9a3b-4773-9aa9-896108614fc4@gmail.com>
Date: Fri, 10 Jan 2025 20:40:56 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: don't touch sqd->thread off tw add
To: io-uring@vger.kernel.org
Cc: lizetao <lizetao1@huawei.com>, Bui Quang Minh <minhquangbui99@gmail.com>
References: <1cbbe72cf32c45a8fee96026463024cd8564a7d7.1736541357.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1cbbe72cf32c45a8fee96026463024cd8564a7d7.1736541357.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/25 20:36, Pavel Begunkov wrote:
> With IORING_SETUP_SQPOLL all requests are created by the SQPOLL task,
> which means that req->task should always match sqd->thread. Since
> accesses to sqd->thread should be separately protected, use req->task
> in io_req_normal_work_add() instead.
> 
> Note, in the eyes of io_req_normal_work_add(), the SQPOLL task struct
> is always pinned and alive, and sqd->thread can either be the task or
> NULL. It's only problematic if the compiler decides to reload the value
> after the null check, which is not so likely.

We don't have much time to drag it on, let's fix it up
so it hopefully gets into 6.13


> Cc: stable@vger.kernel.org
> Cc: Bui Quang Minh <minhquangbui99@gmail.com>
> Reported-by: lizetao <lizetao1@huawei.com>
> Fixes: 78f9b61bd8e54 ("io_uring: wake SQPOLL task when task_work is added to an empty queue")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/io_uring.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index db198bd435b5..9b83b875d2e4 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1225,10 +1225,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
>   
>   	/* SQPOLL doesn't need the task_work added, it'll run it itself */
>   	if (ctx->flags & IORING_SETUP_SQPOLL) {
> -		struct io_sq_data *sqd = ctx->sq_data;
> -
> -		if (sqd->thread)
> -			__set_notify_signal(sqd->thread);
> +		__set_notify_signal(tctx->task);
>   		return;
>   	}
>   

-- 
Pavel Begunkov



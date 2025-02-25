Return-Path: <io-uring+bounces-6741-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 24AA4A4406B
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 14:17:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5495D1889C4D
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 13:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21118268FCE;
	Tue, 25 Feb 2025 13:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eA33XMyB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7062E268C4A;
	Tue, 25 Feb 2025 13:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740489165; cv=none; b=lZZLMtc7nIqvZh1T2Ogj27mgvRDfMozixLlhuAr2QHtfuI6vleYWGU5DnEdM5nvoBzv4718ZkjsuQ/65GUdHXYu6qDeEtp0mApUlRkyajnbllIrq9Du365NzzfmCcezUe8yCnzwEEO9ue6b6Qzh6TOYmCscWi6qKaYjwe7sD4YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740489165; c=relaxed/simple;
	bh=GEJZrRty+O5TovELjeY7AFVyUO75W0YyrTZiUXy57p0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XpaeoxU80N/Q6dyBRDQ+77tdNu/hZBZP/GtO3sbntNehr6r22iX9W0+xUSsKv4eaHoCZ2apNZIS/HzULF3qZIhkQ3SmF6q35AZfYEtw4Z/IDynkl9kERFXaXnVvYlYCjqLWGbZgrFV5PmgpiaJGqwEtShAiE5AZ7nI+maOXRmI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eA33XMyB; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e0939c6456so8893083a12.3;
        Tue, 25 Feb 2025 05:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740489162; x=1741093962; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CiAvjfSWnOpCrIMGAM7RGeGgTVKYcuQ8p+4+u2W0RZA=;
        b=eA33XMyBB6cwmtgHrTn0Q2srzsNZYcKVzDe0tLC2Ex3k6bWwmsx/DVvjEsxqq1m+8D
         vZrqz/RYcNjbuQaty9sbFfM5q3q2WiUIaPi55EzCDzp3QvbEdQz/QtSqJh3qREi4x9g/
         gy1rlvEeblYPmtAkRCU0NdmoToXUWf4pVH7ATv4Uvz0TNxqnIMaUU7KpWgP0eHjmd/On
         KtQ8Cq8iQ/MO1+PSI/1/aLrDNdHBxiJQNS8BnweIWFwxyGcxSUhCjND4XV1MFiQIB2FU
         bD02hDGrr6okZzTULlmmrUkYMwxuW2sNQivFvNf8aKjoNSlAwRIk2qUyz1FgAaaCFaAM
         +OYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740489162; x=1741093962;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CiAvjfSWnOpCrIMGAM7RGeGgTVKYcuQ8p+4+u2W0RZA=;
        b=Rjj6+Zd5ajdUPdwDOC7iWmXlAYwOLQsl8DypiETGCRe5z0h5VbAQDcxcBBqSil5lk0
         NiDOobgnDYCWXO8n1F5HPXoNCVNEJJxjvucB3+2VPxjTkSpD18QBvb9Wq3Hd9hXVgfjO
         e6ClM9zwfcA3vrWxQpv5V5+PIZLx8siroSYIQ2h/0Q910CIF2MPuPhzRY6RHLPk1Ir4q
         MDVhruLqMUXfoFpBvwxOx3MrwOeqcd1+tMq/dj2GXi6qtF8qfvMMVxxI77PKIBYIu6S5
         YDTQt6sz7xuBVj+YykKtiGvqphCvGRlkqo9hTzxWJ65y6WP+Ojzv/+PNZzWZ5s2W3ubF
         7o0g==
X-Forwarded-Encrypted: i=1; AJvYcCWHVRsPSyJECIONM/EIBuK58UFlIFVhXDhJ4zX3MicTssn00k/Ty69eFt1bEMOv4WVaQMoevP+phzFi1uE=@vger.kernel.org, AJvYcCWZizsgdqTgPXucEqJ83vFzSfnm3+Xl5GMG5snTnpFqzPUZOXvT8CcM7ofRiJhUwQyVK3VqVHjyig==@vger.kernel.org
X-Gm-Message-State: AOJu0YwtvzOz4MlPHSvprBGEhBupGIbFU8sAX2eQCOHRI2twr+pgWB8m
	Tu97zCXiJ8AfVYIeM9x1fhSJzSZ67IQWSIetAGLj2nQtqzlYgM60
X-Gm-Gg: ASbGnctpHzibMi4iqqpQbuGvxu9t/Q0s7HU+qtdhQDS78Y83qBhWpOBClDjvhPed5fJ
	ebT/g1lid+bMcnFChG0N10QMiZ6hlLasSJEatU+Eay5eTkTqhco4IayHxXSKoaV8IGh3Dw65D/S
	d0ebBdd36JZekzUk3t6/lfYsIXmwDe3XK1gVfVHsq2knH58ii/nIxSrRnHuWC15vkaa/GfE9EgE
	HC0HvQkj4+Ef1YQWzCrE9ImW2ikxyFy+wDMvuyXGjQflvQPbQMEcBLEIvmnI6l1QudqApGrKTfR
	vkZAtZ3w5Hp8XjugBic7iyJDnd6cB/fZYAHQVCstMDoOrCex/xiAkuObuOw=
X-Google-Smtp-Source: AGHT+IHqmZhKAI83p5bfjJkhN1bp/v/QXfHC1KVLYScQNtOsfZwhWgZP/zkjRZWkhmMK1QwM3OCceA==
X-Received: by 2002:a17:907:3da0:b0:abb:83b9:4dbe with SMTP id a640c23a62f3a-abc0de4a335mr1824903366b.47.1740489161299;
        Tue, 25 Feb 2025 05:12:41 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9e08])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cdbf06sm139669066b.23.2025.02.25.05.12.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 05:12:40 -0800 (PST)
Message-ID: <9611fde5-6b6d-4794-ba0b-4a53eff78c34@gmail.com>
Date: Tue, 25 Feb 2025 13:13:41 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 02/11] io_uring/nop: reuse req->buf_index
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-3-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250224213116.3509093-3-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 21:31, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> There is already a field in io_kiocb that can store a registered buffer
> index, use that instead of stashing the value into struct io_nop.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   io_uring/nop.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/io_uring/nop.c b/io_uring/nop.c
> index 5e5196df650a1..ea539531cb5f6 100644
> --- a/io_uring/nop.c
> +++ b/io_uring/nop.c
> @@ -16,7 +16,6 @@ struct io_nop {
>   	struct file     *file;
>   	int             result;
>   	int		fd;
> -	int		buffer;
>   	unsigned int	flags;
>   };
>   
> @@ -40,9 +39,7 @@ int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   	else
>   		nop->fd = -1;
>   	if (nop->flags & IORING_NOP_FIXED_BUFFER)
> -		nop->buffer = READ_ONCE(sqe->buf_index);
> -	else
> -		nop->buffer = -1;
> +		req->buf_index = READ_ONCE(sqe->buf_index);
>   	return 0;
>   }
>   
> @@ -69,7 +66,7 @@ int io_nop(struct io_kiocb *req, unsigned int issue_flags)
>   
>   		ret = -EFAULT;
>   		io_ring_submit_lock(ctx, issue_flags);
> -		node = io_rsrc_node_lookup(&ctx->buf_table, nop->buffer);
> +		node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
>   		if (node) {
>   			io_req_assign_buf_node(req, node);
>   			ret = 0;

-- 
Pavel Begunkov



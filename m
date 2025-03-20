Return-Path: <io-uring+bounces-7145-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3638AA6A5B2
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 13:03:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7382E17F97E
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 12:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD8DE221542;
	Thu, 20 Mar 2025 12:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cx6I5r0d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BDB21E0BE;
	Thu, 20 Mar 2025 12:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742472050; cv=none; b=EzXkxW8fRAXrwJRSFIhXpNuGd5EsCL2/TNq8S73brGc9EkVo4V/vkzLs9fxijk3Yv7emGePJUrzshxkh/TAaqsc/4kZz8noqynawgLBUfWW/YlUYHPxdUb0po8DC/L/kI/Uj34HFOwL1+isAG0d9EWgZi6ZAFPJUJrH2LfkvBFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742472050; c=relaxed/simple;
	bh=wS5cHZp7JA1DSasgtzQi4XEUw6dEkOHf7U4/ZFqB8FU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K5J1qIvGBEp4QqTDosGfGt3Zc+JRNpHAKS3yq6FM4pEYaJETMFjjvKk2nJep/tFKd3rxqILTjHnlqLdzqYw0zIf7cB2pBqJjkLoB2CH/XLiGx9SI1/0O9+e3OUpWEATJIycs6kHKJjetZkPgIGsflDMCp5uGaEEKbAiMEbE9ee0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cx6I5r0d; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5e56b229d60so3222954a12.0;
        Thu, 20 Mar 2025 05:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742472047; x=1743076847; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=psZ28iWY4ce3nMVQ77aT2Xshn46cO5+w4xjAt4YRxQI=;
        b=cx6I5r0dU1Uzcb8lz8iYUFzXZM6TDpm1MomElLGsVoMtv8hgT/Dp7L6vuUvqDjMmxn
         3JGOW0mKRr0EFi5bJJybtV9DIpS0o1WYHBYvEI8w0o0IsMrmE1BI5TRI5ULv7Sz6/ztx
         kj3jEgRKzJTAlVny/h/GgsW0gO73GawLR6sUaM1bVXGkj/dnhPTpg5omvq3Uuy/us8PJ
         Jzho9XzeieCUMsY0d1FPdkygI6Or21GkQlZfwKcoYcp2kLApDNH07virjiwv9dKXKP3p
         /OUzhShokrhsGQikOnBJZ+pst7q95y+/EiYy/Ba5htz61hSgS3PNuA/HZAQCc4Kqh3s+
         +JnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742472047; x=1743076847;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=psZ28iWY4ce3nMVQ77aT2Xshn46cO5+w4xjAt4YRxQI=;
        b=Z2ovDWRm8HJuldjHg5DsHDDY53o+QtVUcWZjSe8CuYTICt3aAEhitK9cGjATUbKPTh
         Z7XNniSk0iOl0gjOGUvQcCoU+0qgdt20IsRqByowBHG/44D/6dl2hp/0WSaQYGuHBIT6
         EACyGxWY8DHB9im6vJ6qoK+tpEjmo8puWx7jYMzg9d1al2BCHA1eozPW7A3mqb6Ytjta
         zeNVtIiH4TLSv9Xk+LG3Bk+BWSU2Sou/fyuo8egtuSvIRoII/YwnoxtmsQGKobEwcFTY
         CR3EWdUhdwgfI+clQ1G0P3mnp+aX1ZBArgiWzBBSxfXpPU7teBxYQUf4qIlIaPWzrQIz
         c5Zg==
X-Forwarded-Encrypted: i=1; AJvYcCUa8+7MvZmBeHh3waZ+rdbHNmhMZlZ/oVdlDuS5pkWWKOgok+Y1XhrxXQ14geT3E3/P1W9Ak03Udw==@vger.kernel.org, AJvYcCXn8dr68AvzPhXQkATY5O2hdq90M5dy+1+TTnZ5fobbh52EtUlyxW4z2sSzRSmT/0s8G3guhUchEtf1ICLk@vger.kernel.org
X-Gm-Message-State: AOJu0YwVNt/IhEdSM7/50NgrI3U65xcRa00jpmrH0LZQdeTeoy4li5x6
	q4kgmFFnQUnB7WZjdReeKQcebvUMUnKgjKJ/SXLwHeDcdMdGEWhJ
X-Gm-Gg: ASbGnctQhJjDpj4Ax/od/opc9Ap3mFbfTuGoHO99AyTcaB2GzRNBmeZa/bav2g+oJ9V
	LIiJGRUcYT47iWPHfQiuLBHOaAcCfKwX5+KqF4nwuJtZflDTJpiYBqSly3zxqi/XPh9gDkrxk19
	Ax5bv2OrGLOJfwYYSSm5MTClRVamPb+U7/E7b4ECbZagKScfMMadw9TmuWsK7Q4mpQsexT5lZOA
	VTXI3K/haWd944awLzTTU1nUA+aRMFYXFvas647AqXqJ0ar89MuRXw2qFdNtBB+Q6X82y6LvJep
	CzLV0TlEQc3K6d1oEwyHFFK+zRmK7IvyPv17wUquF/hFdu20L5JXq8wGQ70ies9W10j2hICYCl2
	Oxg==
X-Google-Smtp-Source: AGHT+IH9kFnjgyrXu8gDQxf7ywNmvrwutO6K+fCnFZNjcw6cZ3Ga9Tjep9mQxKHstZ3wrK4j+kKl/w==
X-Received: by 2002:a05:6402:40cb:b0:5e7:87ea:b18c with SMTP id 4fb4d7f45d1cf-5eb9a11ef67mr3052412a12.15.1742472046742;
        Thu, 20 Mar 2025 05:00:46 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5148])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e8169b04dasm10665154a12.37.2025.03.20.05.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 05:00:45 -0700 (PDT)
Message-ID: <14f5b4bc-e189-4b18-9fe6-a98c91e96d3d@gmail.com>
Date: Thu, 20 Mar 2025 12:01:42 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 5/5] btrfs: ioctl: introduce
 btrfs_uring_import_iovec()
To: Sidong Yang <sidong.yang@furiosa.ai>, Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20250319061251.21452-1-sidong.yang@furiosa.ai>
 <20250319061251.21452-6-sidong.yang@furiosa.ai>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250319061251.21452-6-sidong.yang@furiosa.ai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/19/25 06:12, Sidong Yang wrote:
> This patch introduces btrfs_uring_import_iovec(). In encoded read/write
> with uring cmd, it uses import_iovec without supporting fixed buffer.
> btrfs_using_import_iovec() could use fixed buffer if cmd flags has
> IORING_URING_CMD_FIXED.

Looks fine to me. The only comment, it appears btrfs silently ignored
IORING_URING_CMD_FIXED before, so theoretically it changes the uapi.
It should be fine, but maybe we should sneak in and backport a patch
refusing the flag for older kernels?

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
>   fs/btrfs/ioctl.c | 34 +++++++++++++++++++++++++---------
>   1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 6c18bad53cd3..e5b4af41ca6b 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4802,7 +4802,29 @@ struct btrfs_uring_encoded_data {
>   	struct iov_iter iter;
>   };
>   
> -static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue_flags)
> +static int btrfs_uring_import_iovec(struct io_uring_cmd *cmd,
> +				    unsigned int issue_flags, int rw)
> +{
> +	struct btrfs_uring_encoded_data *data =
> +		io_uring_cmd_get_async_data(cmd)->op_data;
> +	int ret;
> +
> +	if (cmd->flags & IORING_URING_CMD_FIXED) {
> +		data->iov = NULL;
> +		ret = io_uring_cmd_import_fixed_vec(cmd, data->args.iov,
> +						    data->args.iovcnt, rw,
> +						    &data->iter, issue_flags);
> +	} else {
> +		data->iov = data->iovstack;
> +		ret = import_iovec(rw, data->args.iov, data->args.iovcnt,
> +				   ARRAY_SIZE(data->iovstack), &data->iov,
> +				   &data->iter);
> +	}
> +	return ret;
> +}
> +
> +static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd,
> +				    unsigned int issue_flags)
>   {
>   	size_t copy_end_kernel = offsetofend(struct btrfs_ioctl_encoded_io_args, flags);
>   	size_t copy_end;
> @@ -4874,10 +4896,7 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
>   			goto out_acct;
>   		}
>   
> -		data->iov = data->iovstack;
> -		ret = import_iovec(ITER_DEST, data->args.iov, data->args.iovcnt,
> -				   ARRAY_SIZE(data->iovstack), &data->iov,
> -				   &data->iter);
> +		ret = btrfs_uring_import_iovec(cmd, issue_flags, ITER_DEST);
>   		if (ret < 0)
>   			goto out_acct;
>   
> @@ -5022,10 +5041,7 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
>   		if (data->args.len > data->args.unencoded_len - data->args.unencoded_offset)
>   			goto out_acct;
>   
> -		data->iov = data->iovstack;
> -		ret = import_iovec(ITER_SOURCE, data->args.iov, data->args.iovcnt,
> -				   ARRAY_SIZE(data->iovstack), &data->iov,
> -				   &data->iter);
> +		ret = btrfs_uring_import_iovec(cmd, issue_flags, ITER_SOURCE);
>   		if (ret < 0)
>   			goto out_acct;
>   

-- 
Pavel Begunkov



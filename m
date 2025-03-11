Return-Path: <io-uring+bounces-7049-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F9CAA5C1AB
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 13:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7494316B2C7
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 12:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B3D0252907;
	Tue, 11 Mar 2025 12:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gjgZ32S0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C182225A32;
	Tue, 11 Mar 2025 12:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741697698; cv=none; b=GQGbk6tlbmTiOgEH6797lv2Wy3sTkTO2daNrvhRqmWr/DerV3RWaVZJFS/a2eGgam0SVyQUmbBzEgZqyL5VurJDXVJF7+Y2gtP04xDKRWQar1C0tMjKqjoT2uBoI1fJJQ+bwRI9l0g1dtYS7K0BvLgin/FYHM8K+jK68N2VzwZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741697698; c=relaxed/simple;
	bh=3IVIpjKAZJnW0t8BkaJj+KsWnjc2UJcQZo1D5R6ib7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UYm5I9aSHASTMvRYFT9v7iIhWhCTpMDf8x7XqEuGVjsG7sgeISUFS74AwFUClNesj/D29BYlrL4BGHCv7U2Bh5xs1TIGPTjKs6u5ilnD4dtHraS7Ua+q2s6oFeUo46/zhkRWdoLRXkAfES80uFuMlJx5mo2j/4G6jpAN79bc3Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gjgZ32S0; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43cfebc343dso10518175e9.2;
        Tue, 11 Mar 2025 05:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741697695; x=1742302495; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AJvZkGTzB3cq9B1EDhIcl8JEbNWcP543fGtK/fbZTEA=;
        b=gjgZ32S0NsWsaVJsW49N6vkE9nWN6t7059EUHH8oJAGfOd/7B4Gl0QUilgti9joDQk
         rXtUpOqI0aXyz0O3znsMkEX3o8ISWF6RfqszoHTSP9jFYkkrhnQN3mdAdcMHZozpU6dO
         SNc/o+ijRrZAhl0gLB5rt1cUq5C7l+A5377q5OzL7rdnGPfjnliCWFbmU5ka2kX3otOD
         PQsZwOe4Z8gmORszhz5sFQXBcLaGxL9n9yQbbpd/kISaJWISpYDLJr+Y904qtmW/IOPj
         pywtbL9IqnwOlcuGQum+t2u6ldn80Mk3YWLgfyRixPIRWw0kOXcdYSASMtZ1vjvDVonF
         B98g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741697695; x=1742302495;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AJvZkGTzB3cq9B1EDhIcl8JEbNWcP543fGtK/fbZTEA=;
        b=w16N62r8RoUfeIKPmF08/YhAFFVZ1CZhf3+/TLHCoPzrmjao4+9Bu5lUIGnI4pwJS3
         6tXM/JgzS1X40x6Yc1V4fmK8uUxPOEAHJjiHFn7vEAwGM8AB0JOqOIJEcKvdj1JGXIaj
         8D9k8cG7QxxGDstdL+ayLOlZy5F7ZQ8O2xTYs5yf8Bamn+piE2ua9aSjRTpgwKcLumDS
         4+/83z0QKzgB+ITOaEyW/2URnyp91GzelJ1J+KItNqZ5bm5wE245HMkCZvOdCjpgBsjg
         x0c8PxWjC6ehUhvKvk7b5hJwhvhFwRS0ouoWFiz10n5R5x7qLQ1KI3hxm8CBm6LIQzVi
         Giaw==
X-Forwarded-Encrypted: i=1; AJvYcCV5ebWckdaleuzS4A8nF9NIrvSNbdjK5RbNbfB0IorXk4LTZ2jTv2+atJQ+6YmxX5f8NT2HfifM1Odj4w==@vger.kernel.org, AJvYcCVFnZKUihVpPDevU0E7+BaqeRxiIOxRBeWrwyLTbg73MI3eJUizLflHHeS4n1rFXF7dDFjMgbF5rbEqRsd3@vger.kernel.org
X-Gm-Message-State: AOJu0YwJtsmTg/wV9W680VSq2xN5yGdPP5xAlmmvN7X7bU1NYMvh1tiG
	3u72Yu1KRNCyd5iGnGbf9vMUBrAbAPb4HuxvIMqzv3LmPq4jcS//
X-Gm-Gg: ASbGnctQwxigZ0Cr00i12+RnsOo+opmKLUG+1Xc+LIptBYzoXtrqczo094QQep4F6hx
	h3kFXHLWBGtLXP4ZQ7/6KUUSITOdDY9QzE47UTC3mwxmofQ4T0hXOSepOAQvzobMSDlSNh/1yRx
	juDEhFTWY6sMTGEuhfqQhQzo7etMCoN0ZS0xRNPHrVgvW/4mXd8asLvwz9kJspwap+2qE9tlXGV
	qOeObpWITyNj3xfcH8ofuC0Tu3+Sp6XJt+oyqTi/shDOOvJhsLIynD+ep/vN2zjRKcPtRqoqUzi
	3C2fOI5T6G7m2k7LeZkAAP5tpHu89Q3GRcFOYTz+1M6BdTHVDi1xzTDL/A==
X-Google-Smtp-Source: AGHT+IF4lkp/2XD/UZHNXEWIMayTgBLaXABRdfTQjOJ4lOJ94NiZ5g0x3ZhIlHJb3Ds0G6m4t51g8A==
X-Received: by 2002:a05:600c:4f4d:b0:43c:fd1b:d6d6 with SMTP id 5b1f17b1804b1-43d01c2e299mr47398635e9.31.1741697694660;
        Tue, 11 Mar 2025 05:54:54 -0700 (PDT)
Received: from [192.168.116.141] ([148.252.129.108])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d073555e5sm9563095e9.4.2025.03.11.05.54.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 05:54:54 -0700 (PDT)
Message-ID: <58181ba7-dcb5-4faa-a03a-8ff88cbffc24@gmail.com>
Date: Tue, 11 Mar 2025 12:55:48 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] btrfs: ioctl: use registered buffer for
 IORING_URING_CMD_FIXED
To: Sidong Yang <sidong.yang@furiosa.ai>, Jens Axboe <axboe@kernel.dk>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
References: <20250311114053.216359-1-sidong.yang@furiosa.ai>
 <20250311114053.216359-3-sidong.yang@furiosa.ai>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250311114053.216359-3-sidong.yang@furiosa.ai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/11/25 11:40, Sidong Yang wrote:
> This patch supports IORING_URING_CMD_FIXED flags in io-uring cmd. It
> means that user provided buf_index in sqe that is registered before
> submitting requests. In this patch, btrfs_uring_encoded_read() makes
> iov_iter bvec type by checking the io-uring cmd flag. And there is
> additional iou_vec field in btrfs_uring_priv for remaining bvecs
> lifecycle.
> 
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
>   fs/btrfs/ioctl.c | 26 +++++++++++++++++++++-----
>   1 file changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 6c18bad53cd3..586671eea622 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4643,6 +4643,7 @@ struct btrfs_uring_priv {
>   	struct page **pages;
>   	unsigned long nr_pages;
>   	struct kiocb iocb;
> +	struct iou_vec iou_vec;

This structure should not be leaked out of core io_uring ...

>   	struct iovec *iov;
>   	struct iov_iter iter;
>   	struct extent_state *cached_state;
> @@ -4711,6 +4712,8 @@ static void btrfs_uring_read_finished(struct io_uring_cmd *cmd, unsigned int iss
>   
>   	kfree(priv->pages);
>   	kfree(priv->iov);
> +	if (priv->iou_vec.iovec)
> +		kfree(priv->iou_vec.iovec);

... exactly because if this. This line relies on details it
shouldn't.

-- 
Pavel Begunkov



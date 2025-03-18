Return-Path: <io-uring+bounces-7104-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7921BA66B6F
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 08:20:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8E043BB22B
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 07:19:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780BD1DC185;
	Tue, 18 Mar 2025 07:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OYusHWAg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53E81E98F8;
	Tue, 18 Mar 2025 07:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742282407; cv=none; b=imtipma0YDN1MEHJWaaNIOec8FLcSbKRYjAIdTQEtJOvgNmHYuuXLXOuiBL+tdz0JdC2GiFprVo3sXk7eDnP0Wjtnn80jFt7E/40ccHSo9gKLPt5thChbxsXEJ/D6SYXbV4bfj0D3U5Ybk2QyY8vSCbIBpyeoB8mGISne5YLZ7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742282407; c=relaxed/simple;
	bh=/LXv9pdnd7fkRKmq695RDAHG14ww5Sa2dHTbmSsXSf8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ov7x4ceQ3wDSjXtqdfffmog0d+hNJanWj4asypweIjBCh3+vrRcAR4VH4RHSA4z+ByjtYs3xiGdhDf7BT19rYOMEOsvYzl3nZPfoiiqazH4jOgeIvQUotvqWSVs+Q1qQeLTl7COJBRMuDUK502ip8gCf5/tlG+WqqbYb9kddCLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OYusHWAg; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-390fdaf2897so4880687f8f.0;
        Tue, 18 Mar 2025 00:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742282404; x=1742887204; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XubnwXg9oRuAD+ZcoKjTcthnYvYFSBjX2054cK7Xw+M=;
        b=OYusHWAg0NIYzVnBnXIVFJiqRtE61/Hp7Lxwvc6H78lA8nLhD7kzOkUzwBN409uwD1
         kTh1UUrMPU61QARnP8tY6E+fUaKWS/6TNnV5nkeIF+a777CGZpCK04+eWJgoQ1g9nOnc
         6q0BB/PVL2x7ePJRqJFdPbc93vg/mhJ2C773fRTOS3FrDuwkelQ/mDcESzLUuGg4K83k
         tdcCqc7po3tsFn7bkebZ2oq00oKZmzljx97+7fI7IM1WeIAQ+1Zyb7kdH/pKRZ8GbwMK
         I07jvGf9mxLCefi8rHyKr0JXIiEAgKK/JKg5+NTuuDH0BtGwrYGvH0h9kCnNqplmHLC4
         XMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742282404; x=1742887204;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XubnwXg9oRuAD+ZcoKjTcthnYvYFSBjX2054cK7Xw+M=;
        b=Nf5M4YiHCRSNCg55k12lM1yLm5yRNsaXXYWlBsGPq/9G9CjOpR0sLkudYT2uUm8qkl
         vLcMiwuvjsMVOHauxX0E1wWRfAWeA3Cz+n2wqa+xL5u/xwzAXsQ0OA8ZnuMhMEp2UdCx
         z25gD2npxTjbVly9MPb1OHcAoefcA25pYk0DzCKaVGcACJZkethfF5Oso2i13cwclda6
         4uQ0Qy7LAEyGOK5vpFkBEw62r2o2bxSbZGxv/K3VG5Xag7OsMmGQ58Jp3oLzw04+Zhp2
         K9DfqXFNYYCj1scBOXGvbPj6OGDzTJIybTeNOK4CFAVa8zbN5ioRre8cR433moo4P6+/
         uLfg==
X-Forwarded-Encrypted: i=1; AJvYcCVAqH4OIWNQUcHXdMUa/jrx423Pb+KbRZZo5tM8zUdsEJh151jddFQxXr6iEw06Su8s4BFZuiEtkg==@vger.kernel.org, AJvYcCWxsSS+jSZQGBOT4U353HUjZI0xplc8DeSXbqYHxHv67nEMIKR4evAjsxU0/1mdKYIweAXNNHZz2Oo4mQ8B@vger.kernel.org
X-Gm-Message-State: AOJu0YzUKjMS38XtkTgeaU7xZ32sEAjUboOqZu/klhJRQddEom4WW97L
	4v7akCmmmQu1AIjLeOOCuj7QeEAFlvabbo7l2GF16eF9BQCWDIpj
X-Gm-Gg: ASbGnctm+TRooOttCUAW34bfjzBvXoCG7EKC9XY8gT5ma4fQXcBLp2jAa7VIAilWiQf
	UWADvLXDbbuiJVIMj4Fmif8a3M1c+bbXHY8PevXyPgIDRjyejMTKeJMoiEQVa+b4fMW4zQPKEyq
	nPqPsiOwuyHZindPxMcDM8Yt1PyQ2wwZBaFvOaa3mlRrZ6jRd8Dk76TvZ1UzZ01qzvVYmT9GXvG
	2H89zUyFDRyWzBggnDZR9mo7rdojSSzyuEzk6HN0xqG0mRE3UGGWtGHRA/srj6mRZgWUX8+oi3g
	yu+0mfuh3BNFfI6LSNzDZCI0GdjiD6xolBEtXnb4Li0+CBMNCtYRCOM+gImBmHSsakVP5H6FVQ=
	=
X-Google-Smtp-Source: AGHT+IHGiFWEAOgf9TJoZBrkofxAEIYgBpfiWN7VsO9dIj4d7h/UmVwrPdgP+onuolUUPTI++sg76Q==
X-Received: by 2002:a05:6000:1563:b0:391:298c:d673 with SMTP id ffacd0b85a97d-3972029eb48mr19912766f8f.40.1742282403770;
        Tue, 18 Mar 2025 00:20:03 -0700 (PDT)
Received: from [172.17.3.89] (philhot.static.otenet.gr. [79.129.48.248])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c83b6a1csm16923529f8f.28.2025.03.18.00.20.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 00:20:03 -0700 (PDT)
Message-ID: <849ce82d-d87a-428a-be79-abdeb53a1a99@gmail.com>
Date: Tue, 18 Mar 2025 07:21:00 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 5/5] btrfs: ioctl: don't free iov when -EAGAIN in
 uring encoded read
To: Sidong Yang <sidong.yang@furiosa.ai>, Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, Mark Harmstone <maharmstone@meta.com>
References: <20250317135742.4331-1-sidong.yang@furiosa.ai>
 <20250317135742.4331-6-sidong.yang@furiosa.ai>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250317135742.4331-6-sidong.yang@furiosa.ai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/25 13:57, Sidong Yang wrote:
> This patch fixes a bug on encoded_read. In btrfs_uring_encoded_read(),
> btrfs_encoded_read could return -EAGAIN when receiving requests concurrently.
> And data->iov goes to out_free and it freed and return -EAGAIN. io-uring
> subsystem would call it again and it doesn't reset data. And data->iov
> freed and iov_iter reference it. iov_iter would be used in
> btrfs_uring_read_finished() and could be raise memory bug.

Fixes should go first. Please send it separately, and CC Mark.
A "Fixes" tag would also be good to have.

> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
>   fs/btrfs/ioctl.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a7b52fd99059..02fa8dd1a3ce 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4922,6 +4922,9 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
>   
>   	ret = btrfs_encoded_read(&kiocb, &data->iter, &data->args, &cached_state,
>   				 &disk_bytenr, &disk_io_size);
> +
> +	if (ret == -EAGAIN)
> +		goto out_acct;
>   	if (ret < 0 && ret != -EIOCBQUEUED)
>   		goto out_free;
>   

-- 
Pavel Begunkov



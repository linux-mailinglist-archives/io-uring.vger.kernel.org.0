Return-Path: <io-uring+bounces-5182-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 155669E1C27
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 13:29:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEBEE28304A
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 12:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58421E492D;
	Tue,  3 Dec 2024 12:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A11WHvj+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD713398B;
	Tue,  3 Dec 2024 12:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733228950; cv=none; b=CECIDPD9lKfZWwhkvdGvXLLHNtJKoCvUd5o+1a4ULIR8SrwTt12yoWIdYpKuM8+Jp84aQhZA6wSCneWgNRE3ej0DvN3QdXRuLqZCIpdeIiC8szUDqgY583cNem3TdMRlvvgScQ5wdUq+J2kMYhCnPaczIkwvR8vO/MGq1+fOyyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733228950; c=relaxed/simple;
	bh=QgPUJ4swc8aoVQ8rfJq33M+egIoY6rb7ju8UZCgFVMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uJaajXujtRgYsFek6x0XlBtWC3/NbqntNEWcf691Ta12xrvlngd/Dp+6a1z1AfFB8ZqnrDcKS/E0iurZ5QRUMThbR10b+sJ96Cm4z6YYTkFwarpiLIK6X7280zqhcdjYooFsY5FoIXB1Yw1fryj14ml2Ns9EUo7PS772/Lv3Hk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A11WHvj+; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a9f1d76dab1so241453366b.0;
        Tue, 03 Dec 2024 04:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733228947; x=1733833747; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N3yTd0P+sWr9rmebL6jBWUz4AM4JLK47nRAJu8aIMqs=;
        b=A11WHvj+B+iuL0zjslJWzl6jvM3HOEJiVT7NryrgKEwXsQwGmEv977Kota9+XFGMhb
         ewTsTIdLYucVkjLsFrVT1AZMX78FzMsDkmZLrsoIMbff8jTTrw3kE0KsFwtxqUpWF4WE
         DRkBqSWS3MTpNQ/bhx3UiN2akNlKvs6MvgpO7KvZjwzN8UlMKHfB0p5Ft4dQLjHTGXEp
         UqFBWrUw6TD8sOz8yR2rDB0mbmuCsZcHnzntOa8fP+jCLBH6czo8SpBrb7tPJkNtRz75
         LaW6d1F6PFnP+tVuriS3nzEHofT4KF7ECJ8dFp3KkuKgk/BrZQ3ytsCRzPCto5km1OjE
         lhQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733228947; x=1733833747;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N3yTd0P+sWr9rmebL6jBWUz4AM4JLK47nRAJu8aIMqs=;
        b=AvJeIWB4zgLrmm1iHdxNscQnU7y9F98bvLzp12LB3cv0ZApNt2EgNq5/EKsOaQRbsr
         NNxb+2yoGNVITjSVDAMFL0Uxid61SexDwhaQ2fw9PaqxxFfIZIRwJRNRtrxsYxculgRl
         tIqX++ox17c+jCzw6jrYZzdoiUhH8cnOdMGC6Wdr2ggosHeThvrI8gC3TLAid/J4HfLE
         Zu4mLt8wrsVIOK2pCbCqVLmXvO53LmuRBO81osrW4LbOGDmG6FxHBuC2f98JqE6gmX5Q
         UveBUuKHnJBcSLyrsCnchzHlkiue6iqw1jLIMmF/NPhyox77+BU9+Rr2Q0ncjWF16hcB
         5jeA==
X-Forwarded-Encrypted: i=1; AJvYcCU1BaKUy8d7hZqupnouhi3pJyYG+uP+PCV+5hpdi4XJJQgsXrPSr4/bdyJo1GidKEUxCi2BR35dAiOnOf91Tw==@vger.kernel.org, AJvYcCWmyj5H1H3OU15EkjDSqn1/u/dLQs9/5d4ywK5YSpeWlEgtAz8DNqdyRyRLKniz+rSO/YUvCDfBvw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQZ4gNLkw2XskQ/pXyW0/jWFSj/JGFLOSJE1XjJ7tLL+km5tUK
	tHr4i9Ns5MPV/bsCdeOTxJPQEta6ofSFapR1QgtWXDm6p6gnVLh9
X-Gm-Gg: ASbGnctt3XBVx7Cmdk94nLm4RGi/Vdcan4YmOTldsqf5LiG0dHKPFqpqqlytX8aWS6E
	vHET56jFli65LF/WKqeHk1lhpR8vRofZ49jkN2e6y+PakDWG0oFXwVhLG2M5U6Ox2Tgh1ecryPM
	cOIH2l5fYWdvaWSiCe1f184zOdXFTkR51gRR4L3xgyPj6GikL1EhyTPX8fh3ZwPjW87k12799Vi
	lQbbXtXn7y9Uuc25R2s2GdpG0U7xHE2hKgr+JERtvzPlzjPZf1mYK0pE+6QkA==
X-Google-Smtp-Source: AGHT+IEs1hHTE91WdyjJhnNKrvABRn0ceMlr1p5VbroJk8JUwAH8w012SB5vpmIxavYP17+kj7r58g==
X-Received: by 2002:a17:906:3191:b0:aa5:4bdb:5e91 with SMTP id a640c23a62f3a-aa5f7cc2eddmr238261266b.4.1733228947407;
        Tue, 03 Dec 2024 04:29:07 -0800 (PST)
Received: from [192.168.42.213] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c17bfsm610397066b.3.2024.12.03.04.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 04:29:06 -0800 (PST)
Message-ID: <de7105f5-291c-464c-9ac3-1701639a911f@gmail.com>
Date: Tue, 3 Dec 2024 12:30:03 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 04/16] fuse: Add fuse-io-uring design documentation
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <20241127-fuse-uring-for-6-10-rfc4-v7-4-934b3a69baca@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-4-934b3a69baca@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/24 13:40, Bernd Schubert wrote:
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>   Documentation/filesystems/fuse-io-uring.rst | 101 ++++++++++++++++++++++++++++
>   1 file changed, 101 insertions(+)
> 
> diff --git a/Documentation/filesystems/fuse-io-uring.rst b/Documentation/filesystems/fuse-io-uring.rst
> new file mode 100644
> index 0000000000000000000000000000000000000000..50fdba1ea566588be3663e29b04bb9bbb6c9e4fb
> --- /dev/null
> +++ b/Documentation/filesystems/fuse-io-uring.rst
> @@ -0,0 +1,101 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +===============================
> +FUSE Uring design documentation
> +==============================

I'd suggest to s/uring/io-uring/ (excluding func names/etc.), there
are several such here. It probably wouldn't confuse anyone, but I
don't a reason why we'd deviate from the original name.

-- 
Pavel Begunkov



Return-Path: <io-uring+bounces-7050-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA747A5C1E4
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 14:07:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53F7B188DB18
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 13:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073DD2629C;
	Tue, 11 Mar 2025 13:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kTPDmeUn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5A8200B0;
	Tue, 11 Mar 2025 13:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741698443; cv=none; b=P9BW3nNmBi4ywL6EZjI6XeTAhI2KvsalX8yfiTDXE1cC0e1+rIAs/LDicnf5xLGUb4UyRrcmx/mn8hC9JcgQkKjhhUSWEYHh1jp+DCg5MB61P+1nDm+lca9Uziu06H1FvlJjdMB73AkQZF1IXUjO3p/dT+KNOBhRsQlwz6wIVWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741698443; c=relaxed/simple;
	bh=bP5RU2Ft46IBKYpIV1EaRQ3t9lSto1srfYKaYPEnFeM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OrqffYmU40wRITHgM9jF53QRb8eRy3OgO+J1SiwQogtp9S3iRqXvW5VxGjWgP42m75vi67BkCPPhF+n/EmupNJayHI4qzfW8hmZ+OTxST5M+x2skO81cSr+LXrzFHde+5GcIyOsHwUVa+5JHPZmZZtmwTf+pjJ5eYRf+U5r1cHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kTPDmeUn; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-391342fc148so2595731f8f.2;
        Tue, 11 Mar 2025 06:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741698440; x=1742303240; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F8P0lXXtLEXAWGLMrxzrAIp4r1CxyNPSKHDrgYLLW2M=;
        b=kTPDmeUnq+kmVXLWNsFGHvp1kqfsCGt/uxcebSIe+Cpho76A9VSD9MVhyAVaJI7yRU
         BU/rcNnZ8V41mA+4HuocSFb2bVDF9ndP73/AsRIftvYaIjmsteD4ozYf1sQ2bpismsX2
         CYBdhiGuMTHi53H7kuTN/EGxxf6xHMkg6Iyr2mAAANQSTxBrrG6+i35JokmOmJqSM8xe
         nQkU95kA5fHlOgQxDT0JjepvhtbNPJktxiPIyefWEmi1+Ga7fvySo0BbqbwkB1xPW+6J
         3s3KVVvLNoIO7cPz/a+mZDk4LsriDPkD1rfpW/PLpcb/+d7Rkpon2td3EmliA7kRyU7f
         MUOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741698440; x=1742303240;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F8P0lXXtLEXAWGLMrxzrAIp4r1CxyNPSKHDrgYLLW2M=;
        b=oETaUgeM4OT0JvPmzTaq7Q3mcz4ljVKJiJjlQf/NutmSVqT0E9c10T8L1bVQxOPmiL
         IbJRm2QoPd8mrKY72M3pY0TXgyek1XnWeNzBkG61MvXJ6TdP2yljRov6Fe9BaJDPJFOM
         LgX7/J6PTRzuOeqVtV5p56L2vlyAyw+PQ6KUw3vBTRco1N6rbpdAOmNgZEAbiJh6k3/v
         W8GQrXn6x7fWY48+RWHjnYvIhdtL8kdBmV5Ps/vnsutMv8fF7L7pF5lUMuSYaw+6FLWe
         0XCXbmjq5R9kBOM47p2wveJnrIyprznLTvakEGxn9adktsYso4/mb7gTykX6xaJ8EQbV
         Oj4A==
X-Forwarded-Encrypted: i=1; AJvYcCWQ8qHTJRWZks8+MHSujJzkpioC3CdYrBHnY0WU4GNLN+txIaxBxJAsG3FzhVenu1XX4kUbJ1Zf3wPbng==@vger.kernel.org, AJvYcCWjYo714a7JRJlr84AHEcHbFv9OBF9d276CTzU6TPbbpPFKEH8adIBADJP229urJZY0nks4z23EM45EWz/X@vger.kernel.org
X-Gm-Message-State: AOJu0YzoQwyEapqLgN6rEugSVGuc60+I+cB+bXzIx3Hkysi+ZOhgIiQv
	QUXP3JG5xb4P4T9Q82u6pQNrD22txRRhceifZBXv3m7nuwyD/cn2
X-Gm-Gg: ASbGnct6zKWXp6DBP2HEcMzR5UWODLDLKv5oJE+f6A2+2PwdmGy3UOlRZ+3WOQz23NJ
	dUO2RzHVtcNH9Oy/NkMONY6xi2/dhSlz6ITP0L175mgE7RL9ZnaJLCVzZxr/uMLYyT/QcAJ+TAK
	s/hpEm4wLd8ANNgg2AmpRgohItYQ3qoI86KxzMD5XxydGj4jjDwRn1cHe1pfa0/qHP0YnncL1y1
	UZS63vK7xDp+QqgDQ7P7psk1mTc3ckmpCR0sqHFGWXSzTAEPvv50R910Svb5nubB15DwPjlSXRY
	gW0Ave0m4KoPFNqXUpSDwHXeTWpc+5Up943Yv3jQkPR6RBEq9QrzSdq4kQ==
X-Google-Smtp-Source: AGHT+IHgn0X7HFcFM81fc0izK8oewaicmuAv0gLuLMhBpzBIiC05fjZKm9ZS+vYbeRz24pq4boollw==
X-Received: by 2002:a5d:648a:0:b0:391:2eb9:bdc5 with SMTP id ffacd0b85a97d-392646932b0mr4622778f8f.23.1741698440010;
        Tue, 11 Mar 2025 06:07:20 -0700 (PDT)
Received: from [192.168.116.141] ([148.252.129.108])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ce9f2d081sm118834985e9.21.2025.03.11.06.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 06:07:19 -0700 (PDT)
Message-ID: <8b5cd4f9-5c45-4ffb-be9a-d8dd6d0baf53@gmail.com>
Date: Tue, 11 Mar 2025 13:08:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] io_uring: cmd: introduce
 io_uring_cmd_import_fixed_vec
To: Sidong Yang <sidong.yang@furiosa.ai>, Jens Axboe <axboe@kernel.dk>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
References: <20250311114053.216359-1-sidong.yang@furiosa.ai>
 <20250311114053.216359-2-sidong.yang@furiosa.ai>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250311114053.216359-2-sidong.yang@furiosa.ai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/11/25 11:40, Sidong Yang wrote:
> io_uring_cmd_import_fixed_vec() could be used for using multiple
> fixed buffer in uring_cmd callback.
> 
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
>   include/linux/io_uring/cmd.h | 14 ++++++++++++++
>   io_uring/uring_cmd.c         | 29 +++++++++++++++++++++++++++++
>   2 files changed, 43 insertions(+)
> 
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 598cacda4aa3..75cf25c1e730 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -44,6 +44,13 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>   			      struct io_uring_cmd *ioucmd,
>   			      unsigned int issue_flags);
>   
> +int io_uring_cmd_import_fixed_vec(const struct iovec __user *uiovec,
> +				  unsigned long nr_segs, int rw,
> +				  struct iov_iter *iter,
> +				  struct io_uring_cmd *ioucmd,

nit: it's better to be the first arg

> +				  struct iou_vec *iou_vec, bool compat,

Same comment, iou_vec should not be exposed. And why do we
need to pass compat here? Instead of io_is_compat() inside
the helper.

> +				  unsigned int issue_flags);
> +
>   /*
>    * Completes the request, i.e. posts an io_uring CQE and deallocates @ioucmd
>    * and the corresponding io_uring request.
> @@ -76,6 +83,13 @@ io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>   {
>   	return -EOPNOTSUPP;
>   }
> +int io_uring_cmd_import_fixed_vec(int rw, struct iov_iter *iter,
> +				  struct io_uring_cmd *ioucmd,
> +				  struct iou_vec *vec, unsigned nr_iovs,
> +				  unsigned iovec_off, unsigned int issue_flags)
> +{
> +	return -EOPNOTSUPP;
> +}
>   static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
>   		u64 ret2, unsigned issue_flags)
>   {
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index de39b602aa82..58e2932f29e7 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -255,6 +255,35 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>   }
>   EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
>   
> +int io_uring_cmd_import_fixed_vec(const struct iovec __user *uiovec,
> +				  unsigned long nr_segs, int rw,
> +				  struct iov_iter *iter,
> +				  struct io_uring_cmd *ioucmd,
> +				  struct iou_vec *iou_vec, bool compat,
> +				  unsigned int issue_flags)
> +{
> +	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> +	struct iovec *iov;
> +	int ret;
> +
> +	iov = iovec_from_user(uiovec, nr_segs, 0, NULL, compat);
> +	if (IS_ERR(iov))
> +		return PTR_ERR(iov);

That's one allocation

> +
> +	ret = io_vec_realloc(iou_vec, nr_segs);

That's a second one

> +	if (ret) {
> +		kfree(iov);
> +		return ret;
> +	}
> +	memcpy(iou_vec->iovec, iov, sizeof(*iov) * nr_segs);
> +	kfree(iov);
> +
> +	ret = io_import_reg_vec(rw, iter, req, iou_vec, iou_vec->nr, 0,

It's slightly out of date, the import side should use io_prep_reg_iovec(),
it abstracts from iovec placement questions.

> +				issue_flags);

And there will likely be a 3rd one. That's pretty likely why
performance is not up to expectations, unlike the rw/net
side which cache it to eventually 0 realloctions.

The first one can be easily removed, but it'll need better
abstractions for cmds not to expose iou_vec. Let me think
what would be a good approach here.

-- 
Pavel Begunkov



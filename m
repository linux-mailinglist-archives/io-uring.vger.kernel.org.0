Return-Path: <io-uring+bounces-7196-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E262EA6CA02
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 13:01:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A13E7ADF8A
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 12:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 781043C0B;
	Sat, 22 Mar 2025 12:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WH/yH/YM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B845617E0
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 12:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742644873; cv=none; b=YJJaD/jS4QkkbmmDzJajBQhzXDIG0VKDe62jCjThZ+iu4D38SMcz/4idRf8kICMZG+4BawQ23F8x6Ejfvbm6p/a4qIqEJoExGM3/nUDxZOJOS+/cTIV8Qll7dApVR2weJdrls0vEBI4eePCnAfiQCZl9LZOqKooqyVEP+BhRQXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742644873; c=relaxed/simple;
	bh=yH5Z/WcLGSxAOAUY5HaWKyy2zJuRLSz+CfVLzRrRTMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WgiSAZc3KXyxRPjWaZe5szKP/L6lxl6aHOIYYXFFApF3ld4w4At63qBUt3Iqnk6QC21RBJD9TUWVoeU3Tjxxv9H9u2G88BTaRXz7UhKzVpwlI3mVHsoh8f/+dd+mAPlrEEi5GFZk69h6XdgF/YnS7BAul1O+vw2gDX1MaMIX674=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WH/yH/YM; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac29af3382dso455482366b.2
        for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 05:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742644870; x=1743249670; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zcc29kPTFyky0VZ+mnM8E+6agE7y5EpBjon01T5j9LY=;
        b=WH/yH/YM+hZGuC7FvOsJcJ/syAe3Aw49OMuADVoVbR1XH5CXhZ4OCnInlk6yHtBnEO
         rxFWZe+hGkYFRGlhEB9LXyxy5Og4HEgsCPkks9cqfkdfQCA4hic1IJXcUuLxVdWbigJi
         mo508LYyG9l6xxXVc/eyifAJrVc66OldOV+5335lrLYstHqXioxPWibBWcbUN5vcBWxz
         qqH7DkfMqAePbUYkNDMfp5Ko1lo5RNRbn5SkJy3frXJCtAiV3ht56CRbh8MDprjJdyVU
         jgQ930EJD8i0L7KwW/NWbxn75EDRP1NzfrBC+7nc1FuCD4pCv5Fbj9aomtWqd/uI6qOh
         1HAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742644870; x=1743249670;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zcc29kPTFyky0VZ+mnM8E+6agE7y5EpBjon01T5j9LY=;
        b=ji9FYqktIegUGbPJSrVRwkPBivgFhWNgbGMJiSYxImfp7bqoSsbcsQvcx1UCx2nFtl
         GJarfDcO7i5ctesORgyN2JVY4a9GxGPM3cr+2i43vhqsnkJ7mKMgXvKUtRbyBP2bGJSK
         YfO+HUGq1Oon62KAlt6xsYHLod0Sopz8Uk4dhcfM6vKNFopPV7K91/B2zN+/Fg2tLfWz
         4qca+MU+4qETy0uSZliKOrLTwEPwAQ5huxwvmvr42NIfaTAy6YaDn3kHaC+ZFCREc3xO
         nb0JrQCbeiW32a/k5FXmnc//7pCJX6gJMRdq7iBVsC0U7fy0L0F3bSYWBij5XhYbJT0y
         k7yg==
X-Forwarded-Encrypted: i=1; AJvYcCWwmILzkrER4D26m/+gPJ6xfuT84nm314ahX/YLqnO5Zc+Psfb/KfTMoDX5+BIFL5swv4J/s9BYQg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxDDaXTIXyB30DAl0RmIqo6nQW2UaryCoGBsXWxeWzmZxwY967y
	HfiJrnIvLEcq1UMNFkpReBMJ62uLj2baS5KsfMQxpjoETZqwjVY5
X-Gm-Gg: ASbGncvatv3G1uGw2HqNDUiQbKatHW+eKdbusZZL55iUSUewhCK3No8qtYSlvCGkaHF
	bmXf6fZuOEaF8UzVi574v0TSyWOdnp7KMfuIQL4SBtumcRliC9BHWAK2dIuFaVwsvpJIN1f3sIF
	JmzB0nsXSJXEhqqpna1dN+nVFDDRvgrK6Y+aguX/yllbnc82VMnmAb3O8v+7Xecjr5zXmBfoitO
	rXiYCSR1aAvOUYKg+ivZXcFOIAcUVQbLxgNrce+6AlDJUg+QyYAJy/0XC0OBmC9sc7M7DvoaJ76
	hEPEifLxVYyfu+n7OcUm93PTx+zu5AuSRTHOSWX37tasc5KAlvtYmEOKMyVLfd0=
X-Google-Smtp-Source: AGHT+IFGMKqP9++8aNC/1U+3py20/WshyU5+hgJ2oHD6Ga0ZYgLw9Lqk2OyB2ytN4NEkJnMhYwtADg==
X-Received: by 2002:a17:906:dc89:b0:ac3:eb29:2aed with SMTP id a640c23a62f3a-ac3f210904emr614086866b.16.1742644869434;
        Sat, 22 Mar 2025 05:01:09 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.37])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef8e50edsm333616766b.52.2025.03.22.05.01.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Mar 2025 05:01:08 -0700 (PDT)
Message-ID: <ae74ba78-d102-42de-95a6-1834f5f85dc6@gmail.com>
Date: Sat, 22 Mar 2025 12:02:02 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: zero remained bytes when reading to fixed
 kernel buffer
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
 Keith Busch <kbusch@kernel.org>
References: <20250322075625.414708-1-ming.lei@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250322075625.414708-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/22/25 07:56, Ming Lei wrote:
> So far fixed kernel buffer is only used for FS read/write, in which
> the remained bytes need to be zeroed in case of short read, otherwise
> kernel data may be leaked to userspace.

Can you remind me, how that can happen? Normally, IIUC, you register
a request filled with user pages, so no kernel data there. Is it some
bounce buffers?

> Add two helpers for fixing this issue, meantime replace one check
> with io_use_fixed_kbuf().
> 
> Cc: Caleb Sander Mateos <csander@purestorage.com>
> Cc: Keith Busch <kbusch@kernel.org>
> Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
...
> +/* zero remained bytes of kernel buffer for avoiding to leak data */
> +static inline void io_req_zero_remained(struct io_kiocb *req,
> +					struct iov_iter *iter)
> +{
> +	size_t left = iov_iter_count(iter);
> +
> +	if (left > 0 && iov_iter_rw(iter) == READ)
> +		iov_iter_zero(left, iter);
> +}
> +
>   #endif
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 039e063f7091..67dc1a6710c9 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -541,6 +541,12 @@ static void __io_complete_rw_common(struct io_kiocb *req, long res)
>   	} else {
>   		req_set_fail(req);
>   		req->cqe.res = res;
> +
> +		if (io_use_fixed_kbuf(req)) {
> +			struct io_async_rw *io = req->async_data;
> +
> +			io_req_zero_remained(req, &io->iter);
> +		}

I think it can be exploited. It's called from ->ki_complete, i.e.
io_complete_rw, so make the request size enough, if you're stuck
copying in [soft]irq for too long.

-- 
Pavel Begunkov



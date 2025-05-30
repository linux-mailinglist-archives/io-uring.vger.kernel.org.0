Return-Path: <io-uring+bounces-8149-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8737EAC9027
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:27:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5708D3B62F3
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057802C18A;
	Fri, 30 May 2025 13:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fCAiTLUG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C739722A1EF
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 13:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748611528; cv=none; b=iwtgKFwPEkvq94+piVn5SvEy9o2UH4J5vvqUobWj7tMKa2BlCdgmlE5ugQ1eqGeSL4bHEZIPeFUm/GAcVTmTB7z6Tizolla/hwsF99rg1KGSwTUIoCCL4Rw6Mcc5l47r/EYotmCUuuqkKEluHEr1/Xs7UCE4puQrNWwjfJaWz0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748611528; c=relaxed/simple;
	bh=26A5uwRBzYKY9PJC5IrdsF5YaUnSlTuOsMK7Dljqnso=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NaBX6fuwbjFKtZpyfCXdfRbTIV4OTcqh9oP8cBZga0tGkDv4bW5P0+ox8ymwzaYX2AQska/nGqU0n3w/hWpNcFM8qLPr2KW5rxmTCgvzsqXt8DxT/IkeaCd3vCVxdilyMky15libGGTcrC1Jwiv1Cz4uX0AcqtkPftOBRpuhZcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fCAiTLUG; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-86cfc1b6dcaso41310439f.0
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 06:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748611525; x=1749216325; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yY+dbpVGvwyReDCeUrnDQCAvkwkygHvK2v+N7HOnx6g=;
        b=fCAiTLUGWmcOmNCnQSEYnp5HJ3v6qMAGq6keRRaH2oWMwoNaqnWF6eu1lEFGBcGm9x
         XFqJ3dSoP7kww9pwQYc4N0cU9u/CqMjjfIurb/ibzttzZ1n/O4LQw9tzomzdpUQqI6lq
         dMWw/j9eQq1gtdom7FUHAwLy0cn/OX03ge23+5MZ8dnT+u6kW/XygIhXdiOXIdjYhSzd
         Jsv5RHXbteAy1a4qowGFUwxsgN6YWuoSUjdCHNrw2f+JDmjsTEZF5Ny+nVQ610IDity9
         GKZGth3L5vyjUGgW0KGH4wt/Ua96Ip04wUlfmu5tO8Sx/0D1jSo/yk7o8rwNGF5Dd/mX
         wg4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748611525; x=1749216325;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yY+dbpVGvwyReDCeUrnDQCAvkwkygHvK2v+N7HOnx6g=;
        b=v67hD46gSlAf3+FI1rEQd7EYUg1whG/xAKiB6tFZTYjNEYS8fH7AiAReUPifZR3jor
         KcJgg/2piuQMIoHjc8Fs1OER9b4FSqexdRR0H0jURhbxQPWi8ns+CnoeCP2v1h1kuJWR
         cuVGF+YY1HWsK+7KkLDHiuQLKlUvxl+TAX1Yypl4F4Uuy69VJWxjvk0/9koTUomD0X9b
         WXVLB4uzybJioRpCdq7vMcBpDLU7wksmlfYeUP6gRoogo4QuJLl7WKHYPB0VZbdfyudz
         m9ccl/CwEi1PpTndD6HxuwZMwLB1kO/tZV6AxaBL1CqavR4MbsvlPVuVj4Ve6D5CAbDV
         mdwg==
X-Forwarded-Encrypted: i=1; AJvYcCXd0URiP34rkG5AhEMthz7gORIH98h7VRwmmOwgDo6Rnlmj0nIRmZwNTBEMIYOMVC2qDHmWdb4J8w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBT5BOtILFxrYegEkGOTh44DB6v7J7MLggSAkZGag5FCrUYIm2
	c6LGfo67GJ91W/uLZZwo3fC8xrR0Xvi/fWcbbR4/NUDcKlyzy00SrbIHRPmpIC1lTy3lMouVd2Q
	fUUw3
X-Gm-Gg: ASbGncu80ajFi+g6NqipkGx548PF0ZINan7Nt2Kf65kF0Ey4e3nNKUVUAE30gknz2vv
	kFaHDfGY53IY5sTO94TajOpiIJ88PeQEGXJ6h9pul9JjGxdIlAEW3lx9zxEXWXj8/ehaDS4FUO0
	4GCQVqjI54J/xQH219/9LbwDtVeCe0fiKLIUPBmCu+cy+H2iftkIbWJ63uPbmVG6b3bDIwlk38P
	0G2qc2lepsrd0EDC4QYWMzK/JLOhuHpF2W69oRVLOuFQwt+UbeqZQ2EOjyYy6qJF1P6twQChQPH
	xmfGd/lNfj2595CZmNUNZxH1vQ1Ma9Fhzt0fYixWkvd/dK0=
X-Google-Smtp-Source: AGHT+IElrzl4SEMEZGUl3oTE453Cj3XDjiWZnvGl2STUQ0A7k9Coc6OKSzdKUqjDOrvlNFIvggL5JQ==
X-Received: by 2002:a05:6602:3f0e:b0:86c:fa3a:fe97 with SMTP id ca18e2360f4ac-86d0010bb40mr352645639f.10.1748611524856;
        Fri, 30 May 2025 06:25:24 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7ed8682sm449239173.75.2025.05.30.06.25.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 06:25:23 -0700 (PDT)
Message-ID: <bd72b25d-b809-4743-a857-7744a3586bea@kernel.dk>
Date: Fri, 30 May 2025 07:25:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/6] io_uring/mock: add cmd using vectored regbufs
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <a515c20227be445012e7a5fc776fb32fcb72bcbb.1748609413.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a515c20227be445012e7a5fc776fb32fcb72bcbb.1748609413.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/25 6:51 AM, Pavel Begunkov wrote:
> +static int io_copy_regbuf(struct iov_iter *reg_iter, void __user *ubuf)
> +{
> +	size_t ret, copied = 0;
> +	size_t buflen = PAGE_SIZE;
> +	void *tmp_buf;
> +
> +	tmp_buf = kzalloc(buflen, GFP_KERNEL);
> +	if (!tmp_buf)
> +		return -ENOMEM;
> +
> +	while (iov_iter_count(reg_iter)) {
> +		size_t len = min(iov_iter_count(reg_iter), buflen);
> +
> +		if (iov_iter_rw(reg_iter) == ITER_SOURCE) {
> +			ret = copy_from_iter(tmp_buf, len, reg_iter);
> +			if (ret <= 0)
> +				break;
> +			if (copy_to_user(ubuf, tmp_buf, ret))
> +				break;
> +		} else {
> +			if (copy_from_user(tmp_buf, ubuf, len))
> +				break;
> +			ret = copy_to_iter(tmp_buf, len, reg_iter);
> +			if (ret <= 0)
> +				break;
> +		}

Do copy_{to,from}_iter() not follow the same "bytes not copied" return
value that the copy_{to,from}_user() do? From a quick look, looks like
they do.

Minor thing, no need for a respin just for that.

-- 
Jens Axboe


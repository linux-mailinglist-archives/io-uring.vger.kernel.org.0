Return-Path: <io-uring+bounces-6200-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34285A2405A
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 17:26:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A79E03A6AD7
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 16:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EF541E571B;
	Fri, 31 Jan 2025 16:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lh1+1QbX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D06C1E991C
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 16:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738340768; cv=none; b=sJxIIH2+4dncH5XjWmLfkKUmWasRwx5hvu/U2BMFz1iiVraDYaifQOIhP2wvb4TZGA7n/TXMu2TNAXEF1SzR7HQ0Wx/ibnCxRkAVTkQkfzXz9fZ48rRu/Ygmu0vPy3VOnxCqewlqQ8/Kc7PWW19RKULLgDvYLXs4aeKVVoR1aXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738340768; c=relaxed/simple;
	bh=TAergm4+xr/44XGDbCskXQ7NqfmaU0lcA9Y4zL3onjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=le/gtn+w5X5v1Yl6VjNwuJjhZop/hneZJNQhjZLx6Xl6xQImwbnF9kHInYYgZoGycOrJcZUS72GVuI3Tczzafoxfi/M4e/p6zeHrp/EOSeBAik6Dfpr3qEfpDreQObIDrknlJbattJGnDk2bOWamDM8mt6kfSSdLTt2y6m2tn5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lh1+1QbX; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3cfae81ab24so6534495ab.3
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 08:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738340765; x=1738945565; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BVo2tdPrYYwccqxdTPQYzZnTCxB6K3zx7DG1c1LNctU=;
        b=lh1+1QbXm20oNxJO93pChXEZ+SI652GDZc8thIANkg1j1droWmQXBmTc7HzBCvfgmR
         mstsShDg8IAWapxKcuGfLg/ZHDGBVPsXr9XexJ6qgP+qwCUTVP3wqHc5UwnGqJBHDANY
         CNG7/+I7kdzvgbErQw0hJZPGIkh83GyKYapaqWA8MwOTTZlgSDlECZpUhFZltyT5c+8b
         Sv4yzX64EcJ3ItJ27vNfP5EFOmhUdg+mCAPNncj907PHAFzkfeciJ/JBNQDCADRBtyPw
         /L3QjjMFM22O8e0pdI/N4u2z1P+OY4wGIRiqxSkVSBfZdMNuEHSN/h0h9H9Tl5OumSMB
         7dJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738340765; x=1738945565;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BVo2tdPrYYwccqxdTPQYzZnTCxB6K3zx7DG1c1LNctU=;
        b=t7qA1rXbaDdsBLIrhOCNfBLVi3i9Bw6cKy/Ld6PPftwgJQmcQCAIyCRu/4g7Sjy1+c
         79xawb1x14HknjhsO+5QrN+Me7dXXgzDpZiCM6jkG+liZBQmv24VG5GnxjYz9L4uWDFv
         tHKcT6DAIn3leZvD5LUnN4mj5vLkuFEzF39nHfLimTLJg7JKrWLKXUx9yFwMcweI8839
         U83UEQ+3+0fn88bfn3CrcX0MFsmY+HakJAz1y7a1GQGRJ1KOcOA3eKuSZWWGxnTsxKHu
         vsq+ggNVAqdEKbk7gKpVRJHSmf3jvBp17pZZ8cyc46RYDQlrL0gqR5qJOGU69fQ+n1rk
         gxUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWtxQScXF88kYe5BzDsKqWAQnKdoVgFt3RXtYjVSxSnh40R6DwKwTHxuQWxXaKU3PmMDZZQA+6IQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr07Neip+7B7PcETEEXsIjPo2evq7buLkm03AxamgpSkzirJ71
	LRUmor2BXc/prFch/XTPQ3maSr49QJ3naHt8TAoxZ5ozUU1ievMeVKu/FHziyZOq1YwhDQp2uPs
	n
X-Gm-Gg: ASbGncvplbYMmZlYCw3Si18jyfV1x0Av1lReHOHcvebxVu0r/jrdoe7MYyfnFqjy3iA
	NGmiWjnaQfCuK6c918Y2KyDvuz2yFCvIbeT+XbR2xrrXEb9q8Z2HXBPYhQwv6U4A2WYFIEeF6ip
	jqmHajnd3FMheDlKJyiosrLedX1v2HrMvZY4jx0FEihiOzm25vux/A5007GmKaz1VAmMwya9o2I
	/NAiUTqSgz+No0UMuKRbjZ0VlwIyOhu5sHaFv47YbDzvhFCQFh92/h2P8Q5siCnNeKwRK7hEizt
	hcNHVIMIeiY=
X-Google-Smtp-Source: AGHT+IFVUWYsCXYBMHP3T/u7VRUqbb/dukG6dfDQvkKGNT/8vSOVPVoQozMvikg398N8RP5eRiQppg==
X-Received: by 2002:a05:6e02:1caa:b0:3cf:ba5:1ea3 with SMTP id e9e14a558f8ab-3cffe3b79dfmr101954525ab.7.1738340765519;
        Fri, 31 Jan 2025 08:26:05 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746a0ab3sm893979173.88.2025.01.31.08.26.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2025 08:26:04 -0800 (PST)
Message-ID: <e9b3aca7-4095-4795-8570-eabbb093d118@kernel.dk>
Date: Fri, 31 Jan 2025 09:26:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: propagate req cache creation errors
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1738339723.git.asml.silence@gmail.com>
 <8adc7ffcac05a8f1ae2c309ea1d0806b5b0c48b4.1738339723.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8adc7ffcac05a8f1ae2c309ea1d0806b5b0c48b4.1738339723.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/31/25 9:24 AM, Pavel Begunkov wrote:
> It's very unlikely, but in theory cache creation can fail during
> initcall, so don't forget to return errors back if something goes wrong.

This is why SLAB_PANIC is used, it'll panic if this fails. That's
commonly used for setup/init time kind of setups, where we never
expect any failure to occur. Hence this can never return NULL.

-- 
Jens Axboe



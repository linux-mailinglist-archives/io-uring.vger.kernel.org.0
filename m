Return-Path: <io-uring+bounces-4279-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B51A39B7FA9
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 17:10:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AB87280DBC
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 16:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA26213342F;
	Thu, 31 Oct 2024 16:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ExzareqL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49961A4F0C;
	Thu, 31 Oct 2024 16:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730391001; cv=none; b=Yh6xX04q9PhlY6nZCaEZagIOQOXkBgrVzXvLz0FmHMBVa7YkWqfCeH4GrZvq5RER+PU72TOSgY25VnjrhCoaqWiMqwo21/i2OrpedT9eFq2dHZp9oVMNH7oB+8jB45BEw/gjpKh9/6Qt2ORI7DnMRlj9mHuj96XubbAYPerFih8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730391001; c=relaxed/simple;
	bh=tgWYjWbBHWmprC3rEp41fTXSi6APp8RfEYzQIaW1lfE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qdm0l/aulsZXhJ3p/jStyOsByAV3Vfcr01pPtv0B2PS9RPzcgve/MSkxv1dlR18GO3KsowJgbOhT383QvzPnzCWR6H8OwE/037TkctvC7dR/tj6ZponwQTEK1DXV/FTX/r9N9LxHUyaeKHDucgJqRAPADfDZbmTFU/LCcLpo6pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ExzareqL; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2fb51e00c05so17726621fa.0;
        Thu, 31 Oct 2024 09:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730390998; x=1730995798; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dD+fn3P7Ou/mYctSwD7qYZ9DhdFkpvbaxR+VgQD8Ov0=;
        b=ExzareqLH6ell8MxUWbW+Xm4/yISZ6veMJnpL7qYBLvpb4bpZaED3OPaY4FWnKEvTp
         19dBR+ngpX2VS8UkuliD61EZIVRk2Dk8HTQ/pKWYbxDXurwwNJd20CH7EQ33A4ZEtfog
         OW7aWbRZWRgma8MTNsUrn8abQhB9FbRPsW3bhp1HlFEKCna4YMbzlViTibXVS134wnw7
         bz3gvywdh2LKd/vPGk1PpRv3XtmyDj1QvZeISHvHKoDnT10Wj8n41z9kyYX34LShfBd6
         IMNhLsNwQb70SVhm1DdXl+SofufdZDbTinAPOMdnv4AmEWxF7/h1MBY4K7TVbdK6b6sg
         ObMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730390998; x=1730995798;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dD+fn3P7Ou/mYctSwD7qYZ9DhdFkpvbaxR+VgQD8Ov0=;
        b=FrKLJSSnaq5ozJfSrGy4SogLgEcCRP+PDawho+CdIGR+1Vq4Hr48bOEXEzLXkxMjbv
         lqB0uCUcta6r+/nMYtlORsFGiKwB/uk5WeQcHcK2OQedu1QwfK4vh7SG20u5ABXJUYXj
         syYsXlQmJZkA63ag0cLYEsMCF9YSr7xxQKC+tHj1r1NsdVlbyMM1IsvKv8ZzqsfcJek0
         O+D/raKw0Vouvf9cpP2QCuBQTdZuG85mxrg+FIaSGLqn4iVS/va0NGoqYGYWUrpUAj2s
         k75J/PKRP7Qh/81ehkhNku5KoNQEtzm10D3PxLw0Xi/Gnr6RTbWuXY6LRGylOnqXfyYS
         iWVg==
X-Forwarded-Encrypted: i=1; AJvYcCVyVIiiTFUB80S5gXn3XiQtFi9PdDZeDIlrlCE/5rsAVI+OuSKof1VVrqS+XytOiIVyAawkDddWcqmWDw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbjPbM1x39HDNztf+WTH5DkJ8sbahyxY/ij4NeK/abtM5AxOx6
	cqboENe28u8H0giDyKm0f2B/QZxrZlrWZ5su1BLamVIuQGGPhJ7CTJ+g/Q==
X-Google-Smtp-Source: AGHT+IE17flOXccWPqqV4EcizDVXArqnrcJS5HUZG9Uedt9gYQ4mffaUw9eg75c+wKpkzI/kVJ/t8w==
X-Received: by 2002:a2e:bc14:0:b0:2fa:fdd1:be23 with SMTP id 38308e7fff4ca-2fedb813ad8mr4387961fa.28.1730390997586;
        Thu, 31 Oct 2024 09:09:57 -0700 (PDT)
Received: from [192.168.42.101] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e56643609sm82796266b.155.2024.10.31.09.09.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 09:09:57 -0700 (PDT)
Message-ID: <7da4cc24-cf5a-45f7-bcf4-1d64cde4cfa9@gmail.com>
Date: Thu, 31 Oct 2024 16:10:13 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add struct io_btrfs_cmd as type for
 io_uring_cmd_to_pdu()
To: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org
Cc: io-uring@vger.kernel.org
References: <20241031160400.3412499-1-maharmstone@fb.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241031160400.3412499-1-maharmstone@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/24 16:03, Mark Harmstone wrote:
> Add struct io_btrfs_cmd as a wrapper type for io_uring_cmd_to_pdu(),
> rather than using a raw pointer.

That looks better, thanks. I don't think your patches got
merged yet, so you'd need to send it together with the next
version of your patchset, or even better squash it into the
patch 5/5.

-- 
Pavel Begunkov


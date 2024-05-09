Return-Path: <io-uring+bounces-1837-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C428C09F1
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 04:55:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 261E51F22649
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 02:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AC3D13BC31;
	Thu,  9 May 2024 02:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BUkCsBip"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2129413A414
	for <io-uring@vger.kernel.org>; Thu,  9 May 2024 02:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715223315; cv=none; b=Eg1ZaCFVrXZSnJ9UebHr7mOV+PeQVthdWYvdl39iD+VmlCgaeuxNSJ5iUwppp4nmzdttsedjkoIzMYMhO5kb4KnI3Pf79n5xok2y54DITSYnB8NDJEDdj8cgArpcVQKtbVQCNUSxkyey1bkEf4xxzz7EwX/tKEWtvQJsygeSLx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715223315; c=relaxed/simple;
	bh=jk+zYAXe+NRpb4ae9coUxlBV5Qgj6M54BIRyHYyZAEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JL3TPhExM/zrPbQQePNB8wiUDhlwtLzktccx0FR+hDgxqf1SmaqUtdlOCz4RYZyTntdjzj4Hh4EAJpatw+thZL96PbHmGRi1CoWt//MIVNBTdpGRVPMqNsD5FBa4CQzsBkhMPjNfHSnpSd/9ajupIMApOgJn3OAMphujpbXpalw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BUkCsBip; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5a9ef9ba998so99319eaf.1
        for <io-uring@vger.kernel.org>; Wed, 08 May 2024 19:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715223311; x=1715828111; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ae8zr8WW5un2jVxdbJIo8tr7ylZk/NZGIjwavASRfxQ=;
        b=BUkCsBipqRyE9VLWOK2+HBbOaaFWpPBsoGAH6vH2HVhyC0FXyshR7u14JLZIiP3ZhP
         9Q/hIzV7XLlOTupAJe5mL+pyl9MwNMLNWmhsls7ku1QQu/0klKA2dV8B0jhzJK4FdyAX
         qiIHuYENc7M/SJnm3PItMWELxva87LUK6NQT8cm6zQ982uIm51Tt59VozvymUweEMVKR
         QbRl9M9prwTwSiEgvWC3LRlsrmt0gAi6fdH7SuEhEvjyW/ZNw076mhb53uGYRJSn8dgg
         qCU/ZXgDB/VV8iEaUUrIlW0UHELphKety0qaay9fLlNcw1407oYkbOv5dCZjOIPQQRae
         3CQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715223311; x=1715828111;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ae8zr8WW5un2jVxdbJIo8tr7ylZk/NZGIjwavASRfxQ=;
        b=VxZUcYiAifYI2OInlY5BiY7s5ynwxZggoafzXXk9yetKrtJy+8X7u22ysLvAcIRni8
         3euwWykODfOqVODICV6hA6jm3moDlMrBGDLmflpyNVC9gkpdPN+35hoQtdBFZnZzPV2d
         aMoTJ3DLk6u0w2kb57fFDMBx7Wmz6b/5YwkDbNV/fInUoalpGOFBkjOrLfmG3TsB6Gch
         8IoGD4P8HVelCUcf8VRJONFGuOT7f0S/cZ77YrQfo0jBNYosbGQ+X+xqgvEj/V7Z7Nrg
         bp/NE127pvQLORXzfrnW34fSNWK4Nw/Z3+pXTdD0WF4dA/EEKycAD2O4hrleSCfvNZ4X
         bc1w==
X-Forwarded-Encrypted: i=1; AJvYcCWLUVRtfL844xzAmhTto4iN/C9dOTzR/irqSE6I0SxmQFm+w1744+PMERpgReegJwB6O97CzY/55hYc//WHd4yKUzkVAk41bkM=
X-Gm-Message-State: AOJu0YxxRJKd8tVY70w2ppVJrtPrsAjIFIOJt6Y+akZxYKSKQGxj0MY3
	/X885rj5Q+xzez7AxK+wQwgqD0punJEwav/Kr5eiiq8L+1urHQIvcc5jp9j0g9TU2aFnVK5uZdS
	c
X-Google-Smtp-Source: AGHT+IHmk0DV+UvghH41OazBGKbLXYaP/K7OLlcA1FEk/HpQ2dDOabxy7LwHaEgGP79TB4RS40ThoA==
X-Received: by 2002:a05:6359:458d:b0:18f:9c8d:cd1 with SMTP id e5c5f4694b2df-192d377c6cfmr489075055d.2.1715223311054;
        Wed, 08 May 2024 19:55:11 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6340bf1741csm205706a12.27.2024.05.08.19.55.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 May 2024 19:55:10 -0700 (PDT)
Message-ID: <1f411b88-f597-40b0-b4c9-257b029d3c9e@kernel.dk>
Date: Wed, 8 May 2024 20:55:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: add IORING_OP_NOP_FAIL
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
References: <20240509023413.4124075-1-ming.lei@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240509023413.4124075-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/8/24 8:34 PM, Ming Lei wrote:
> Add IORING_OP_NOP_FAIL so that it is easy to inject failure from
> userspace.
> 
> Like IORING_OP_NOP, the main use case is test, and it is very helpful
> for covering failure handling code in io_uring core change.

Rather than use a new opcode for this, why don't we just add it to
the existing NOP? I know we don't check for flags in currently, so
you would not know if it worked, but we could add that and just
backport that one-liner as well.

And if we had such a flag, the fail res could be passed in as well.

-- 
Jens Axboe



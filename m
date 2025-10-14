Return-Path: <io-uring+bounces-10010-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B6CBDAC2E
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 19:21:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71D263B13C3
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 17:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC173016FD;
	Tue, 14 Oct 2025 17:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xPlHp1YS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3084213C8EA
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 17:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760462484; cv=none; b=FPq9+qZZBr80fZlW4WxYeQv1yn0liFOtb7+KEnRMz5EhwkTh5JdTRdCVma6PC0aYU19KOQ3j6jSQHV/zSokvScuhdaTnQ4527nbbeJiDo+C+0OqeitnbF1WdlzWueCFXd56cK/O3TYyPzKUhcxMOVzlvY4QGfiW/KD6UVA/Y1hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760462484; c=relaxed/simple;
	bh=WwtIYKCxSAZdnIHttG4cjaZPD0F3g4UiT9+GtEPQOOU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=m2qA8fXp6/ELqwZabEL3S9roBihOrBpFssmbORq3+Plp0W2Hnyh4I/jwBzGG9xQ1vnV1mA8BnRSOKNO0eZdZnLbd7RAeq1xEySKtCb8cHNPmZHavkIuIhsj67lgpAn8yPsBQq/PkdwwiEU0WHgTogke039CLj7JOyhLh6cUwtPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xPlHp1YS; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-930cfdfabb3so5178939f.1
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 10:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760462481; x=1761067281; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3/alFHma9PJg+zn21oIOBckRFUubnleUFeNQg+Bkzio=;
        b=xPlHp1YS/p+Xzs/I0tOrQurzDfPflMCJQyVhPFi221POh+i7yEBDfvhlmyvzobZogu
         4gW8rB9gtDczvEOcqr53HDddEPTCyGi5c716HAtV2Xb9DKk+K0sQ6k47Xd3gCmj/QuS7
         OO9kIuYNi8MQ7CTdCmz1Q4O6LihI2LfoM7PnFLALuc5OuLOGyd78U6Ps4nY85K9B9TPA
         l4UFuE1+baEbBE0uGR0uzq8erq79XzWveVpzcp8wWhuIGIiuwmdG+AQmWtW9ogO0gnaB
         OqMgmmuTlmN/7qEhflQtiXPfayScXYRXNy2GmPdG6s7mCjJIokt6NMis1k6hgkFkbwW5
         G2tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760462481; x=1761067281;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3/alFHma9PJg+zn21oIOBckRFUubnleUFeNQg+Bkzio=;
        b=dBpia8NISsv9Au9j2JHL4B0JK2d0hXuza7Nlg8WROL/yi+hVowTCinIc9QgXiBKXpV
         yzhmSU0fCngFiehL2ZXLP7THsjgbb/SpvD0WtNWnWnCW2EsXbJDjvoSjf8IGeuvVHDs1
         +plEV0o3+lw3gtHCRiHLlBwoU/wxLwflAukkBw8k8JGWSBF0ZglVihT+VDr89S9X9KzL
         g47/shwk0+NMchcVTz0zLH0F2F6MLq9khsbf5jkVi5oQUYsKyMFsg9m02LuhEc+8LJ0o
         Zc5E97riX8R6ISxlPeU2hRzCAaGOW02MEaLzJLYYwVMXqfV6ycsSOEXCUJjNvMIayjiT
         Bh8w==
X-Forwarded-Encrypted: i=1; AJvYcCWKUfZrXTSSCXAUIMjWJmIg+FqqqFJJ5uvIQkVTGJVvFBWMRIwf/pOI//yr9Znsako45jxo0YHOtw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyXYpSA1uhvUfZKluALxmPODIpqoqhVF7XlnDabpuSugL53hSNX
	mUiwwUx439bx1HxkX7g6hS3I+UiK+vfXPRuXs/OgchniS8NW3CqPRZ+eoPICo1/FWZg=
X-Gm-Gg: ASbGncsGAhiSCUopjVBdqgwmeQS8XTTA3AdGT5SVF9tYKnXEN+PJhAECutx547G2a5u
	w/3ufvZk3AMs4wecp0J0AdOqMEKU0etAP2a8sq5c8ulykg2g2ztclmIX9VFqxlM+McXmrPsiNaS
	RBIpHc99nSNUqVI+PTRtC1HS1kds6iP4kLtzFu2V1toxaSujRVCyvIH5VclVnRd8P0WwPLIq0Mt
	GdqTBh6wkI6a6gTeZx7v8dTD11Fxk1KJs2N2OeG+lMEt38fcDrw+MLWEpAfoLXPI8bLtAFBulZW
	uphJ+iGX5FxR8w/x9RW3o0WjJ5rVK3igMdev1He8udn2KPI6v5HS8MCEnJP47O5fc5MV91/gJse
	g/aXyHCxV3Gwf4q1e/xuVl2A6tw0k+YQXHaeg/A==
X-Google-Smtp-Source: AGHT+IHyO59G5YBQMhQs9a1QjxXIRKrsD850byBLZ0I2BmGvZzaLLTfBIA7+E27SIe9S6sbyxxnfXg==
X-Received: by 2002:a05:6e02:1545:b0:42f:8d6c:f502 with SMTP id e9e14a558f8ab-42f8d6cf905mr268229315ab.0.1760462481150;
        Tue, 14 Oct 2025 10:21:21 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-58f7200bf82sm4982160173.44.2025.10.14.10.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 10:21:20 -0700 (PDT)
Message-ID: <0a659c8b-45e4-489e-9b84-fce7600a4beb@kernel.dk>
Date: Tue, 14 Oct 2025 11:21:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: introduce non-circular SQ
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1760438982.git.asml.silence@gmail.com>
 <d2cb4a123518196c2f33b9adfad8a8828969808c.1760438982.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d2cb4a123518196c2f33b9adfad8a8828969808c.1760438982.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/14/25 4:58 AM, Pavel Begunkov wrote:
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index a0cc1cc0dd01..d1c654a7fa9a 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -231,6 +231,12 @@ enum io_uring_sqe_flags_bit {
>   */
>  #define IORING_SETUP_CQE_MIXED		(1U << 18)
>  
> +/*
> + * SQEs always start at index 0 in the submission ring instead of using a
> + * wrap around indexing.
> + */
> +#define IORING_SETUP_SQ_REWIND		(1U << 19)

No real comments on this patch, very straightforward. I do think this
comment should be expanded on considerably, mostly just by adding a
comparison to how it's different from the normal non-rewind way of
tracking which SQEs to submit. I can do it too, or send a v2.

-- 
Jens Axboe


Return-Path: <io-uring+bounces-6506-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8CF8A3A44E
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 18:29:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A60763A18A4
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 17:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FEE026FD81;
	Tue, 18 Feb 2025 17:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="uq+w7nr4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3649626FDA4
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739899746; cv=none; b=D6DwtGhHz1wiT5degW/wxOx6TCZRDWHXDnfrmrNtrnERthq7LKgUQmzrMezv4MTQgVija5dyZwMZ7lFASQFSU1meqA06PGFDbsUK8cOkHCuOf5ffaqTdyewFCJiGl81ykcb1aHJClKrJPA26ZYPAb2MiMir9zg2RDwWVHKrXOgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739899746; c=relaxed/simple;
	bh=SoLd4RhdUtgUYmiT29r8m7nIYlQI+sZrj4a4r8bbS2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZLHy0cClbssIoP/vRmmx32NvKCQJmXkUHPd0FlZoGvdYEqepOF1DBk7Or+zewxwvxi6o2FQxWKxLIXUXVQAtJUvtWWK7adEu4aZMdCHLowUrpD6lAF5QlpoPk4pz+LtiEeygfHbaoyNqCRZxbKfY+1ng964SDl26j3lCUUoNsPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=uq+w7nr4; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2fc0026eb79so10855403a91.0
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 09:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739899744; x=1740504544; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bgd9gh0YxSXuFXhgg3vOtS7F4IfANGG08PXYFLL1c4w=;
        b=uq+w7nr4lgDcQKD7m9VkoZX/CbyJ1GpLFPysWDP8maR2NEqZ4jVjfRJzuul38TkiVh
         IzWeCpJ+r6k3uMxyFi5dC1Qy0szAkHaao1lFU5fS5j0BJO4GNM3WrX17SZBddsEZmVOV
         4LOG7YV7Jeo0C+LDMkos7zUd2IvF2m1IZUQmw1bxZYV/ICpZeSnIe+Tj8HuSYQq59tRa
         LqW/511qqQAnU4zHtXrWT3H119tDp9kgvlQFhn16A5xsvKVgYf+qTEXTOQn9q0qthLoi
         ca2IfVxrCwRvYY2juaBDP8F5slmuzDfWWGPFrvs5AxxxbBmOTPSCSQyZGvKFgaP8B42q
         obDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739899744; x=1740504544;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bgd9gh0YxSXuFXhgg3vOtS7F4IfANGG08PXYFLL1c4w=;
        b=Pndiz2M5Lr2rL66onC6hgTcXI/NW2zBDgC+4GmCjjOhfyW2sKe+VswWtsKNRfNSVUS
         G2XoioPjerld9W0ScfWPT2Xcz+yJ7eUPaW1GoajMAXqt4IwWUYgQNVXoE4a0r3Xbnuyg
         V7JOjloSmwMLQSZvYBjk/ijaWKOsZJ8X6jMI57i61C5W9po/SI62r4o0TLHdngdDmLW3
         P/glfA5itE05e+yLvfX+EYJne0WBwWdCxjlTAiTtOhT4kVCESNgr54giC14Ta+RLPdg9
         ZvgWyY8nBLNqmJwYFJx2kFZLjS1hVZp+onGzb8Cc7dTp/zrfI1V8KS/PbDC7VMbgT5Ed
         KZkA==
X-Forwarded-Encrypted: i=1; AJvYcCUhp4D3b/p9KHXuMfQaNpqTBZv7clepQ5yIkT1LrsZk5zgrHFFFFMiwH1PMmFaCRmeXkYlFeXWM4w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxdlGttwrWIbw5JZAcW7Lg7ZpzmwpevTRe3IBpSnPDjCD08gjrH
	vTPry5maZwA9Fsr1ruefu3N2i6n94jLma07wqrU5rKpyvt13+MIE4IPkfprOszk=
X-Gm-Gg: ASbGncvHu5kosJD1fZVAFEnH8NgFcZiJ2fMav1IvHe1XB7/ZxHn+TXGNOAEDDACtcZf
	+IF2Fns4HGXt8E3vS70JfKWzkafhbW75AorFnBevVEFsTzAL6Nb6cVXBKHPZTp8O3UqmD83BGWi
	MFr+BeoRQXwWSIL7VeUVH+a5Y+YFqBnKTId/UxmBIOTZuN/H9W1V6k2xA72eQOZIPNhf/2q09Br
	1fHvlknBqgmzbbXEx6KKNPFk5/FVW/NGNLYPDXFnUIMJBLn/+2hulUfiM+jNoh0IG9jdzTuPEtc
	089aBHMZcD+P75dq3IOnhQPzEpx6PV8K5edWMm2gtBUhuNhU+qGovfp+8qc=
X-Google-Smtp-Source: AGHT+IG+cDgTJohHSkGXiYeHD273wxqnnPU9QkqlYsOHnB6iu/TZFvBpo6aU1O8ZflFBdCZKHiok5w==
X-Received: by 2002:a05:6a00:b8f:b0:72f:f872:30a7 with SMTP id d2e1a72fcca58-7329de650edmr178043b3a.6.1739899743111;
        Tue, 18 Feb 2025 09:29:03 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:18cb:90d0:372a:99ae? ([2620:10d:c090:500::7:d699])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7326d58d4d0sm6028147b3a.94.2025.02.18.09.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 09:29:02 -0800 (PST)
Message-ID: <e62e724c-2ae6-452d-b2c8-95bcb114627e@davidwei.uk>
Date: Tue, 18 Feb 2025 09:29:01 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1 2/3] zcrx: add basic support
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20250215041857.2108684-1-dw@davidwei.uk>
 <20250215041857.2108684-3-dw@davidwei.uk>
 <4276270d-0fe3-48fb-b44c-79734a945319@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <4276270d-0fe3-48fb-b44c-79734a945319@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-02-18 09:05, Jens Axboe wrote:
> On 2/14/25 9:18 PM, David Wei wrote:
>> diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
>> index 83593a33826a..cedc71383547 100644
>> --- a/src/liburing-ffi.map
>> +++ b/src/liburing-ffi.map
>> @@ -222,6 +222,7 @@ LIBURING_2.9 {
>>  		io_uring_register_wait_reg;
>>  		io_uring_submit_and_wait_reg;
>>  		io_uring_clone_buffers_offset;
>> +		io_uring_register_ifq;
>>  		io_uring_register_region;
>>  		io_uring_sqe_set_buf_group;
>>  } LIBURING_2.8;
>> diff --git a/src/liburing.map b/src/liburing.map
>> index 9f7b21171218..81dd6ab9b8cc 100644
>> --- a/src/liburing.map
>> +++ b/src/liburing.map
>> @@ -109,5 +109,6 @@ LIBURING_2.9 {
>>  		io_uring_register_wait_reg;
>>  		io_uring_submit_and_wait_reg;
>>  		io_uring_clone_buffers_offset;
>> +		io_uring_register_ifq;
>>  		io_uring_register_region;
>>  } LIBURING_2.8;
> 
> This isn't right - 2.9 has already been released, you can't add new
> symbols to an existing release. I usually bump the version post release,
> but looks like I didn't this time - corrected now, with a new empty
> section for 2.10 symbols as well where these should go.
> 

Thanks, I'll rebase and add to 2.10.


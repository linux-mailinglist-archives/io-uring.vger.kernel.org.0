Return-Path: <io-uring+bounces-4561-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF6B69C11AD
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 23:26:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05412B21E44
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 22:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72B3D218D64;
	Thu,  7 Nov 2024 22:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yPzFmgSt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC53218958
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 22:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731018364; cv=none; b=jM4oA8hNzdD7AYEb4bL57dnaOEHmc9l3uBxZ5PXGXD81H0Us+fzig2fJucy9to40vgKBsi6QOI5VfBxRQFcTRPEN5+zmxXhuiunHgZVESyK6lU9cVVYhlYL/GHHUAPvkQ8yLsfRgBnfSdtQN14VTiTmpQXzI12G8lhl0q9aOy+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731018364; c=relaxed/simple;
	bh=1aHsB/zKiQbMlmmGU8Nt65GTi06r96XtuPpx3Rw94cM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=sZ/jfepdsEs7pvCEKIq9lfVtWclb8WG5ekbrjjZoLQwwrMpgi6B7N6O0D10c/uCbufVXP/BlVLF9jDFzU2G8BSYxL1vJJUzYr81tDHt9O45+oLdxl5IOaUhfYGttOYz/NrFuihTap3OZDKArfhq2gXl064OfG57GYQnwY2Stg1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yPzFmgSt; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-288b392b8daso927561fac.2
        for <io-uring@vger.kernel.org>; Thu, 07 Nov 2024 14:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731018361; x=1731623161; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ic3moIW2xzE9kekqow/yFFuj4gT8GFTls4K6Xfp4vq0=;
        b=yPzFmgStmaNZdI5uukrDIiGL50XmI7Qj5aoyaMw/jvB23GSuByS8nzdGihE8fHOlKi
         tWhzdG17Qa/5VMtSGFEi00dE9qCMM46Uiuu/O/zaIi4SFeiEvGTAM235GqD/PVMVEtQc
         S/cp4l4Wn2PVrkV+PB8WcXZ2Q0jvvGZCWhUjjIUy/2PqurV97ns9aEZHYvylp9wi9+ZJ
         M8wvhJBGCGiA9NpgwOPjR+l8FD84sxLDaHjOGIoiM5OVQH9tRINu1fEi6AptaIDG8VvY
         Pb44vsXb+lkJ5IHAsdCZWNsAI6ybGX4Om1TFTTCiNk9OIN9a/lE9PSt/OLKwVWwHcvHP
         Gfxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731018361; x=1731623161;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ic3moIW2xzE9kekqow/yFFuj4gT8GFTls4K6Xfp4vq0=;
        b=LJ/iN19AWnLjYRW1CxpYai+hrryBIo3Q5eUqt5YBAFikfwXyw6Ez/qwYtbuvDcR/Ar
         TR5Rbx047WDs9djSlRdqnQ+XF1SRrYT0s3NHPJdaCTRFJGhGxIgxm3nuOFXSOych62q7
         DknVgRF0PJa7CZU2JpHxx0INUPR+0EuW96DzX+1ZGNmtmeueGp3hQ0qFymU0Ci4KOdO9
         Ehn9jcOHXfk41OCLoF5u/XHGJ14KHqlmTaC6MkqjazlxprZkO1Qk+kg4YWaF/bxeFMG7
         uFNBZsaeIIod0b1TaXrxp5ElEDThXglTukmtes2ExBZpRsgn+bhHAPTuoF0YqRZI2Lv8
         oE2w==
X-Gm-Message-State: AOJu0YxbTOczRpuU73gcxoRlY/LjeFG0WqmQ/HNTL6E427+O/8lqnFjq
	kvqVDNEnC1VLBUhr9LDDsggy/bSPwbbkBWuvNG4gRm2e1ayRDMCySzpgBCun5XENoXX/v3dCVyO
	oD08=
X-Google-Smtp-Source: AGHT+IFuI5q1Mb4wqDT2YjLU822jxP2SRwO92t0Qytb10bAEIacogw+MK0uT+tmaS89AoFiDN2AjvQ==
X-Received: by 2002:a05:6871:1cd:b0:277:d8ee:6dda with SMTP id 586e51a60fabf-2956011f91amr585507fac.23.1731018361266;
        Thu, 07 Nov 2024 14:26:01 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29546ed7ab3sm642504fac.42.2024.11.07.14.26.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 14:26:00 -0800 (PST)
Message-ID: <b0004544-91f7-47b8-a8d6-da7c6e925883@kernel.dk>
Date: Thu, 7 Nov 2024 15:25:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH V10 0/12] io_uring: support group buffer & ublk
 zc
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241107110149.890530-1-ming.lei@redhat.com>
 <173101830487.993487.13218873496602462534.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <173101830487.993487.13218873496602462534.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/7/24 3:25 PM, Jens Axboe wrote:
> 
> On Thu, 07 Nov 2024 19:01:33 +0800, Ming Lei wrote:
>> Patch 1~3 cleans rsrc code.
>>
>> Patch 4~9 prepares for supporting kernel buffer.
>>
>> The 10th patch supports group buffer, so far only kernel buffer is
>> supported, but it is pretty easy to extend for userspace group buffer.
>>
>> [...]
> 
> Applied, thanks!
> 
> [01/12] io_uring/rsrc: pass 'struct io_ring_ctx' reference to rsrc helpers
>         commit: 0d98c509086837a8cf5a32f82f2a58f39a539192
> [02/12] io_uring/rsrc: remove '->ctx_ptr' of 'struct io_rsrc_node'
>         commit: 4f219fcce5e4366cc121fc98270beb1fbbb3df2b
> [03/12] io_uring/rsrc: add & apply io_req_assign_buf_node()
>         commit: 039c878db7add23c1c9ea18424c442cce76670f9

Applied the first three as they stand alone quite nicely. I did ponder
on patch 1 to skip the make eg io_alloc_file_tables() not take both
the ctx and &ctx->file_table, but we may as well keep it symmetric.

I'll take a look at the rest of the series tomorrow.

-- 
Jens Axboe



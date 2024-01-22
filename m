Return-Path: <io-uring+bounces-445-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A0724837389
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 21:10:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E4151F2A27B
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 20:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 496AB405DA;
	Mon, 22 Jan 2024 20:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NLayZ48+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CEC3DB86
	for <io-uring@vger.kernel.org>; Mon, 22 Jan 2024 20:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954211; cv=none; b=DcvoJcT7INY0dcp0oI71fYFixDRPi1rj7e43vsezRKMDCoG5VARyx/cQCR0kshwLamtE7J8mh3Fdc6pXYEINDyYWb5EYm6pSPchcHglUJjll0cjNlqvLzbrRYEc1kh5lZw0oHHDiOC6GC3R0g0yuU2/0eufxkkzBaGr8m6bd3Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954211; c=relaxed/simple;
	bh=Ze4XGDs3xqgMo5D7vFdmVFM+SI79P1+6bhB4VvGpudo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=N+0gbUYdDQ+M4QWH/hkxLd1lao7niJ+dMpistcgXhVfCp4t04Uv6PvNyI12sJL7WaTXMetyi+kGEB+c26/Xp7rgWj+dIoIPFi67n113DsasACGHGLFydsqXSwRguKTR9qPJ10CP57mYkP3aGPDPg6LWyAwNI8uKXyKOZiuDX7N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NLayZ48+; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7beeeb1ba87so47891539f.0
        for <io-uring@vger.kernel.org>; Mon, 22 Jan 2024 12:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705954207; x=1706559007; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xK7M4SgoF7aIhJeQmKinLhl/sGCoMFGRlDALRO/n+uo=;
        b=NLayZ48+lbWQx4J8HcAv07uBEi2Pcv2JIUOJEzdsP9Sd5dF7qzYY8TUK+t7gME3IQM
         2SM9TM8mPtPRriYXzcedyCasUgBAbAGiEaPJ4IFiYAs1FUlD+8e44j8nmm8btBVSUcI0
         vLzUuw7Zpav+tuHIf88ntlmTMDzv8HbRi8IbOHg1MaYn3rXzKWNRovrUW+S1HN/UAPJv
         /BbAZuhQtJbZ3CJCRH7275Kwqh7/cMVXoPtTvGybcsYwRceLeBUiv83ZaII7x2lLjkIQ
         ujVaEocKRsR6NrJGty/Hb2+6yOJcC14tJa1KC1aUu3DONT2wR4TCYJVK8z4V2UeN/fyi
         UR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705954207; x=1706559007;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xK7M4SgoF7aIhJeQmKinLhl/sGCoMFGRlDALRO/n+uo=;
        b=P0jdf1jOwD2KWz2dDWrRG+FGLFb5BkvDdOgHoILxqZSExhiNt7aKpEp0aYTdunXak/
         0BlLBqHn4NLpi+3hFWgBC2w5sAnWu5K5HgQB2bTQN9fpo0fwBlTZ3HfoNryqtCatdL1S
         Fz/lp9LrehtsvJaG+wEEGXCVwIBUpbex/Qc+7UFibmFPJZKdXjAfRrb0nXRg7dFszmRL
         T24Ysxr1VmqBOU4agnVJj02/FpW/sa70JjGGAUZdJIcPakVuDKBpEfuTZiwl/6s4uMDr
         p05wp1kPQCtkyHHzsxgjZYLnb/6tEtX/B0VsfvOq9zuv27+4zfAOmiSs2Nctj2gUs2Ae
         jVQA==
X-Gm-Message-State: AOJu0Yw3vo1fdSPPSPpRwRYN4OMZ4mzkg7LPZd3TWk2HHVSSir5UpcI5
	5qIHRT9N87TWaP67EtpTUliLuTDTpZ3BX6GZjcJidHwt7MSV+TNJ2zLr7FwLXzU=
X-Google-Smtp-Source: AGHT+IHiSuq+ZucgNLvzQQdySaEwGYF5fGRXVz+JRPQZx0TlA3CzXM/QtzEiRGwKXwyy4b3hiMpklA==
X-Received: by 2002:a05:6e02:12ee:b0:360:968d:bf98 with SMTP id l14-20020a056e0212ee00b00360968dbf98mr7982120iln.1.1705954206690;
        Mon, 22 Jan 2024 12:10:06 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g5-20020a02b705000000b00468ed10d45esm3135066jam.154.2024.01.22.12.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jan 2024 12:10:05 -0800 (PST)
Message-ID: <549751f2-2936-4a24-85d7-548c4607824f@kernel.dk>
Date: Mon, 22 Jan 2024 13:10:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring: add support for truncate
Content-Language: en-US
To: Tony Solomonik <tony.solomonik@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
References: <20240122193732.23217-1-tony.solomonik@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240122193732.23217-1-tony.solomonik@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/22/24 12:37 PM, Tony Solomonik wrote:
> Libraries that are built on io_uring currently need to maintain a
> separate thread pool implementation when they want to truncate a file.

In general, I think we should just make this one opcode, and then
require fd to be -1 for the truncate case (with path in addr, like you
have, or have a valid fd and NULL addr for the fruncate case. Then at
least we don't waste two opcodes on essentially the same functionality.
One minor code comment, which applies to both patches:

> +int io_truncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_trunc *tr = io_kiocb_to_cmd(req, struct io_trunc);
> +
> +	if (sqe->off || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
> +		return -EINVAL;
> +	if (unlikely(req->flags & REQ_F_FIXED_FILE))
> +		return -EBADF;
> +
> +	tr->pathname = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	tr->len = READ_ONCE(sqe->len);

This should use offset rather than len, as Breno pointed out.

> +	req->flags |= REQ_F_NEED_CLEANUP;

Why is this being set? There's nothing to clean up post completion, so
this just slows req completion down for no particularly reason. And the
you can kill the same flag force clear in io_truncate as well.

-- 
Jens Axboe



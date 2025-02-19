Return-Path: <io-uring+bounces-6543-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8201DA3AF00
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 02:34:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A30A3A9028
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 01:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ACAA14F70;
	Wed, 19 Feb 2025 01:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J5Ii5i3X"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D86224D6
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 01:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928891; cv=none; b=Nfv/fTqggHS7ZQ2CGSCjJ9Zp5O9jWP5gML4hNLTjkkU+VyvARTkMSe78qck8tzO4YcUyt/gV3re133jbdacFr87PiQva9HCAFnbmILb32KcIZ+en7luT4OJXdkjVkGRjFsljcKO81RTGqEYEEaaP9GTx/4xXXDcysVZDNbSLXLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928891; c=relaxed/simple;
	bh=NGcoqwPWq9qSFfJYS3ua5PlrNnluzwrZWblVi34ejDU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=p64xywbjHbQsOrD4komsTPsjSYMuLHsD3xu5DFHEK2ceiA8TJmf2HDl4oUml8hFhfvBBd6p07fYUHjIh/L5JnAtVTawphY2+Zmqu1KqyeAIB8NNE6XRgaYHYIDg+PGmjY7Qzavyq8uCv9I7QgS6GTxjHqZ8+qbnUjAPaDDaIBGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J5Ii5i3X; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-38f325dd90eso2615200f8f.3
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739928888; x=1740533688; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xg1SbduNBhrrxx3oo6BxHC+xGvbVSez9erSwOZjekDQ=;
        b=J5Ii5i3Xs1MDSJaFOKn04HM3vWo2bZuWUSlGOVI9VobPof87LLOv+GzAPSpM0qpu18
         f+TK2ijF8TrKLdYaN3WqTLgCH7F0iY/R4UCRrFwYyRatun3iosYW5asACs97v1tZPHxk
         s4i71Ei8ajAem01rwYKC9g5QQt2AYRt113ahDLKXoI4CRxGX5mouk6F08BJfuiKoku1t
         KStcAWosPX7ygSBD62sSBhCy4xQBpZvCtgAR3U5YHt6AETEMSfi4mw/P4k5/DyKdXHti
         avBjX2J93hzIiuTS1IhPJZ5krRmw8H/iJy6e3YkZw0ujgevRjLp1FvUGQefx4UwXBDno
         YXrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928888; x=1740533688;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xg1SbduNBhrrxx3oo6BxHC+xGvbVSez9erSwOZjekDQ=;
        b=s7NMveX/oqKlp33D0EruXCl7TScrJrKiB/hAkY+xMFq6BKM2u7n8MZDBYgi8fFU198
         5jr4Lt0CgMOiUDgWZFX5HvDYp96ur0Hcjg+rYsbgXUNSYwtYHzzrNP2w+4OGq6+W2BpZ
         8Sy+nE2YHUBQ9tmAajCgaq9ydZ94mLr0GbZh6P543nwlcNnJb/fovFVpAqElHvW9d6XY
         ogk+Bewa9q66XisDJe4sJ/tyE5Kzx4f6OW2FNp/we5G8i8v0uzHCahqrQDv15kCWt4Zi
         1yv7c9Qq00m6aBTadpC/Nj3ox6/DTQR+Nd5TgFL7dXpjGW270U8fGiACEYOAtye9pa1e
         WSNw==
X-Forwarded-Encrypted: i=1; AJvYcCVJV8rhKT3uHiSiCKfpOLOkLfDTOzAQ+0GEArCoBrBwu0R4WhZ9NrLwPcvMPEOB8koLzuHsRR1sHg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1g4qyp9a/z42pE15PK7SbB9N7MCjnj9ktP16iRI7Wwf9Fd655
	ErR9csqvfN25u01iWVCxfd2wM8MFubNQSvFPunAk3ssUrlkoeLVP
X-Gm-Gg: ASbGncuQTXLDM6OkIqkIm7sttPP1N57R2QYa0/jIVyDGZqzLPlfDKznRVSBUVZIcFv+
	B3SmHN9sw6VRjV+T883XsmLIv4A/avfbkdCzwcnjI4mSWpHjFEwIr3LiTPFRzS9RX5G4fDIcNrR
	fHxOdlY/I2prG8XqZkZ5W2sw1Jxe/T7lT6pSxyQNwRq0PGTomZIj/rG/ObEv0eflvLiVIL6j29Y
	lj46l/IfH5bsTFXXwxEBOFlLkXL3EkzyaF1ba8gFCrf34sIH4n9ESCEShK0P8jnRYEkmGCbfXiq
	7m+F2Xl0m3oLA+yRijTtqhe3
X-Google-Smtp-Source: AGHT+IHeWUVPexiPOGnkCyBHpaeWoeLbPkyakiOC34Zf3OcJjQJVqAUrChdzHmd8KORnN9T0ha2KZg==
X-Received: by 2002:a05:6000:2c1:b0:38f:43c8:f765 with SMTP id ffacd0b85a97d-38f43c8fba6mr8864286f8f.26.1739928888237;
        Tue, 18 Feb 2025 17:34:48 -0800 (PST)
Received: from [192.168.8.100] ([185.69.145.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259f7979sm16191612f8f.83.2025.02.18.17.34.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 17:34:46 -0800 (PST)
Message-ID: <61fa6d1b-1ee0-426d-8414-21eb1c3c18e0@gmail.com>
Date: Wed, 19 Feb 2025 01:35:51 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/rw: forbid multishot async reads
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <49f065f7b88b7a67190ce65919e7c93c04b3a74b.1739799395.git.asml.silence@gmail.com>
 <cd42f912-df8a-4c9d-a891-1c127f6b6fa0@kernel.dk>
 <c5daca6a-dedd-4d6a-a30c-00b7b942d1eb@gmail.com>
 <205ed24e-238f-497e-9990-6bcb08acaf61@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <205ed24e-238f-497e-9990-6bcb08acaf61@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/17/25 15:37, Jens Axboe wrote:
> On 2/17/25 7:08 AM, Pavel Begunkov wrote:
>> On 2/17/25 13:58, Jens Axboe wrote:
>>> On 2/17/25 6:37 AM, Pavel Begunkov wrote:
>>>
>>> The kiocb semantics of ki_complete == NULL -> sync kiocb is also odd,
>>
>> That's what is_sync_kiocb() does. Would be cleaner to use
>> init_sync_kiocb(), but there is a larger chance to do sth
>> wrong as it's reinitialises it entirely.
> 
> Sorry if that wasn't clear, yeah I do realize this is what
> is_sync_kiocb() checks. I do agree that manually clearing is saner.
> 
>>> but probably fine for this case as read mshot strictly deals with
>>> pollable files. Otherwise you'd just be blocking off this issue,
>>> regardless of whether or not IOCB_NOWAIT is set.
>>>
>>> In any case, it'd be much nicer to container this in io_read_mshot()
>>> where it arguably belongs, rather than sprinkle it in __io_read().
>>> Possible?
>>
>> That's what I tried first, but __io_read() -> io_rw_init_file()
>> reinitialises it, so I don't see any good way without some
>> broader refactoring.
> 
> Would it be bad? The only reason the kiocb init part is in there is
> because of the ->iopoll() check, that could still be there with the rest
> of the init going into normal prep (as it arguably should).
> 
> Something like the below, totally untested...

fwiw, turns out we can't move all of it like in the diff as
ki_flags setup and checks depend on having the file set.

> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 16f12f94943f..f8dd9a9fe9ca 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -264,6 +264,9 @@ static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddir,
>   	return ret;
>   }
>   
> +static void io_complete_rw(struct kiocb *kiocb, long res);
> +static void io_complete_rw_iopoll(struct kiocb *kiocb, long res);
> +
>   static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>   		      int ddir, bool do_import)
>   {
> @@ -288,6 +291,18 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>   	}
>   	rw->kiocb.dio_complete = NULL;
>   	rw->kiocb.ki_flags = 0;
> +	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
> +		if (!(rw->kiocb.ki_flags & IOCB_DIRECT))
> +			return -EOPNOTSUPP;
> +
> +		rw->kiocb.private = NULL;
> +		rw->kiocb.ki_flags |= IOCB_HIPRI;
> +		rw->kiocb.ki_complete = io_complete_rw_iopoll;
> +	} else {
> +		if (rw->kiocb.ki_flags & IOCB_HIPRI)
> +			return -EINVAL;
> +		rw->kiocb.ki_complete = io_complete_rw;
> +	}
>   
>   	rw->addr = READ_ONCE(sqe->addr);
>   	rw->len = READ_ONCE(sqe->len);
> @@ -810,23 +825,15 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
>   	    ((file->f_flags & O_NONBLOCK && !(req->flags & REQ_F_SUPPORT_NOWAIT))))
>   		req->flags |= REQ_F_NOWAIT;
>   
> -	if (ctx->flags & IORING_SETUP_IOPOLL) {
> -		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
> +	if (kiocb->ki_flags & IOCB_HIPRI) {
> +		if (!file->f_op->iopoll)
>   			return -EOPNOTSUPP;
> -
> -		kiocb->private = NULL;
> -		kiocb->ki_flags |= IOCB_HIPRI;
> -		kiocb->ki_complete = io_complete_rw_iopoll;
>   		req->iopoll_completed = 0;
>   		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
>   			/* make sure every req only blocks once*/
>   			req->flags &= ~REQ_F_IOPOLL_STATE;
>   			req->iopoll_start = ktime_get_ns();
>   		}
> -	} else {
> -		if (kiocb->ki_flags & IOCB_HIPRI)
> -			return -EINVAL;
> -		kiocb->ki_complete = io_complete_rw;
>   	}
>   
>   	if (req->flags & REQ_F_HAS_METADATA) {
> 

-- 
Pavel Begunkov



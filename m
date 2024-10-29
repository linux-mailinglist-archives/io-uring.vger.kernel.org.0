Return-Path: <io-uring+bounces-4129-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEEB59B4FB9
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 17:47:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CC391C22230
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D359194AD1;
	Tue, 29 Oct 2024 16:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l2nsFDoK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245447DA81;
	Tue, 29 Oct 2024 16:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730220464; cv=none; b=ipBQT5gVhI2x0/RMs/1urLaPR2fL8l25VleWz9bxo8daU4LxeDWoFrMtZ2qkScuRUwIaWUUOvH4LGCHwiw8KuWGurLqnC44cJCKNttKdRLnApczc7jrLHcA3JfYslrOdUyMIYNj0fEo0gmHdxWTjDCPWBMsAMTsozP3pZhoWdO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730220464; c=relaxed/simple;
	bh=avcy8Y5x6vA/ZlM46laLBaGxAC90NqrADTtALMmEr5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eHzdpYDaiPUdtUfj6kXKKISuPAyAfRBSKfadSxtiOCr8iRZlTHc4cFi0vm3otkTZHuajAKaHESQ1rs3JIMvKCmtGoBL/Ym+brf/GQycqUPgNon/bgITiVWJYWb6W5Fu4Zu/LGppwngzmq7EOfmgaHbR8FpHAjkHDdPMmksfBheY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l2nsFDoK; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43163667f0eso53943295e9.0;
        Tue, 29 Oct 2024 09:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730220460; x=1730825260; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rWA4KkCBSk1QKJcRvuDg5QtHyButhhkG/bhJ4kRAJsc=;
        b=l2nsFDoKI192DObcBralaK0l/CKqaWxsHi3mjucwal5UQ7VC5W8WNs/CXeyCAJYSfu
         8N63dv9splcYUvDVjToyLciCMSusXbJ2jYrfA8wDsVZjVDf4kj7mf0yrqAEMsvsc6wm8
         TDvo/XVASqms5NBtcc1imvjjkiSsahi0/ekzVSbgoKMLp0SLwOiXnR+mARlUVv13tXlT
         lXrgJj6FgLPnoIGYFdv0+jeCXTIdkN4QM/wFN+ZPVF4p7Xk/Dt+eqD5lJ/fTXO+a/uBk
         6OBqKbuEFha9I0p7fbLyiJS1K8TWYaHKnnBnNhA2C/GW1X1p1eKUYqF7jAsAsNvNa40G
         rMRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730220460; x=1730825260;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rWA4KkCBSk1QKJcRvuDg5QtHyButhhkG/bhJ4kRAJsc=;
        b=qSWuIKoaXXmSBO11hco+LdP7HIHbE1yU437SUKxGVnur6gDVX6SGi6qLx5R2blMXjE
         O/K9tO+JM9xi/s69ZnoxaKAEMMNUz6Z8uPKagrJCd1u+HqN5UBFUASEWeaDUoZ0Xqh3t
         3I4a+BV9zDf4AR+eMjjS6G3oUqZcnz5ufCMy/0eMimCBqsjhuCew/ePucCw17orlMl3y
         iDhJAz82xX4YbwFLAi0Ftbyw17C3TrcyFD15gGy0VHQwR7rozBUWX0ovCNA/A9D7aJv3
         jr5bYcPPzOeovi+V9lMyT9YngnRTxTpVL5jZwzZWRLSHTVb/c8YsOu2GdCsjSGmQWQg9
         mwUQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8y8bTHUkZCVwPy0X2VWxw1heoasBSiERTj0nCV+/uP6auDmZ2lAPzI2s/03GF7rAQ+6rF2xgMFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxN4cykGUSyDQ+Dd7Qtsb2aZCe8VvqT6OXIIjZPZIkSfpZYZA7n
	Y3jXBA1aLgmaxj+CR/NGK4LAYZzGuH5J61fMnczMbfc0KJuJQczYQ3s04w==
X-Google-Smtp-Source: AGHT+IFD+FrvwNPWG4HQp9xxXxKz5wJI7IrnIOX6wMnvWX7HE2Jw6oIqAJ3GEGWXuliMMxZqNwWcIw==
X-Received: by 2002:a05:600c:1546:b0:431:57e5:b245 with SMTP id 5b1f17b1804b1-4319ad14981mr87058525e9.23.1730220460184;
        Tue, 29 Oct 2024 09:47:40 -0700 (PDT)
Received: from [192.168.42.53] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b3bb62sm13081754f8f.29.2024.10.29.09.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 09:47:39 -0700 (PDT)
Message-ID: <4576f723-5694-40b5-a656-abd1c8d05d62@gmail.com>
Date: Tue, 29 Oct 2024 16:47:59 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 5/7] io_uring: support leased group buffer with
 REQ_F_GROUP_KBUF
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <20241025122247.3709133-6-ming.lei@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241025122247.3709133-6-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/25/24 13:22, Ming Lei wrote:
...
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 4bc0d762627d..5a2025d48804 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -245,7 +245,8 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
>   	if (io_rw_alloc_async(req))
>   		return -ENOMEM;
>   
> -	if (!do_import || io_do_buffer_select(req))
> +	if (!do_import || io_do_buffer_select(req) ||
> +	    io_use_leased_grp_kbuf(req))
>   		return 0;
>   
>   	rw = req->async_data;
> @@ -489,6 +490,11 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
>   		}
>   		req_set_fail(req);
>   		req->cqe.res = res;
> +		if (io_use_leased_grp_kbuf(req)) {

That's what I'm talking about, we're pushing more and
into the generic paths (or patching every single hot opcode
there is). You said it's fine for ublk the way it was, i.e.
without tracking, so let's then pretend it's a ublk specific
feature, kill that addition and settle at that if that's the
way to go.

> +			struct io_async_rw *io = req->async_data;
> +
> +			io_req_zero_remained(req, &io->iter);
> +		}
>   	}
>   	return false;

-- 
Pavel Begunkov


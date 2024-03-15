Return-Path: <io-uring+bounces-996-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A65F487D739
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 00:11:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6035B212D0
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 23:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 877D65A0E8;
	Fri, 15 Mar 2024 23:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nydp7kyu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD995A0F0
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 23:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710544242; cv=none; b=aZvD8NrVl9NRXRgNZgMDx6rCfDLxIdjJOQbYxW3UqEYoy1uecIxT5P0UYcsNW8liqAK5fo2zYhVd3nqKdZ8wPmvJ/Iy9j9KC3y8+txgU84MDaHvmlLl6jCCKwowTQKUVDa42CxSuxsxTorhQgVehHUsDqZK5V0eVgXVVgDL4fRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710544242; c=relaxed/simple;
	bh=UQHpR86YaZzEKupUmDGPklatNSKStkdCeuE4IRFX9x4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RI423srrtEryWcpK/PiiQl5W8GBmQT7xLn+Bs2rstXfS5WZF4/SAaeHfVsd6JIxBdAedJFrfaIzGcQvPEqkNq8CohylisX90txHdM4XShY2tvknVz529Ah3nyqXMMohAXj3jeZVaRFXRegpz6x6XEhLivYRxjVnx6w8Ab+zBITs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nydp7kyu; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-33e899ce9e3so2023069f8f.1
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 16:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710544239; x=1711149039; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KLJ1WHEgCf2NOhiZopnUMe9i6oZWeuNXkY+2PjzR5QY=;
        b=Nydp7kyuzBU3DNigt7qhztoBvAocAdpvDrofisVUzdiZFzfFbzSHc6SzOGAJkB2Tt3
         sqjhZa84ugerULM2RyLIkIR0nG2dD+TwFuF7kb3w5cKPprhYiC1w4BS54Y4RRQEnBfpE
         yj8Ab/3Hj+yGcRkTwjESWYAMZKzG4hxWyFAk+Frv3FHiXPmGttyBenk5YmH6UHVU6Dey
         52o91pytiErLXtK3wnsPw6wAKezLVIMozU4FXuZEYvF2d2aZOoodL6hfFcivgkJkyJvU
         oh+e/NkxNjkFxGYHzemsvHPgAkUpIudcsiNsBADC54sXsbwP1j/yrSmh5sIPBID01ZJE
         nvOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710544239; x=1711149039;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KLJ1WHEgCf2NOhiZopnUMe9i6oZWeuNXkY+2PjzR5QY=;
        b=k4TaNpiaAXq4mUOYntqJjVMONkF0aaQjF0JTrZHPNeShooUdIm7WPnSjxzGTRbJ1sR
         XLmpAsc1i8JyWVZOD0ror1RpHr8WaSG6GLPtmrUWlRtGYnpb0RH4vbY5YuNadvOs4DEQ
         qaRpQlNgLPi2itZaL1rvdDsc9ge39pl77pvlrHJPm5ud9T4i4OKtlTvyVwAMW7txdpNN
         G3d0Oz78+klVC22L1vUX1ydwErNS7Du462PF2Y1r2ve/LIdWbID3JEzjhNaYH8KKQnpQ
         oQ+56/ZWZWQpq2wBAnIBuS+ca5JwH15+UbYj0h6O+9bUmIg+7nFImjBicCkdwl1e/+lI
         zoiA==
X-Forwarded-Encrypted: i=1; AJvYcCUP51/lfSUEwbG4O/1w02HsMvsoFc6FlJh+ooUe1kpGKrPSWmrGh5OfAIq7luseMVDPPfj+Qu+amuEPrHaSwygaXc9mIox67ow=
X-Gm-Message-State: AOJu0YyVifEenkEENzuhdtrO+UsLVwpccryGTZ6oTRXuzRpWcTCS0KPR
	KhH0/f0pOf91UZMul+4AMppfCmGo7EJAiOvVSZeJDzYptqrCMCy4GSJJbJxY
X-Google-Smtp-Source: AGHT+IHqgsGeWqmmtfkW7kbNJAOHzR7mfki9VaHpDS9xtQZ6lwz1/kVU2EHmnC7LmXuhv5E1+7VrVg==
X-Received: by 2002:a5d:5051:0:b0:33e:7869:4f73 with SMTP id h17-20020a5d5051000000b0033e78694f73mr4356642wrt.39.1710544238788;
        Fri, 15 Mar 2024 16:10:38 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id n16-20020adffe10000000b0033de2f2a88dsm4098060wrr.103.2024.03.15.16.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 16:10:38 -0700 (PDT)
Message-ID: <0ec91000-43f8-477e-9b61-f0a2f531e7d5@gmail.com>
Date: Fri, 15 Mar 2024 23:09:33 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/net: ensure async prep handlers always
 initialize ->done_io
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <472ec1d4-f928-4a52-8a93-7ccc1af4f362@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <472ec1d4-f928-4a52-8a93-7ccc1af4f362@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/24 22:48, Jens Axboe wrote:
> If we get a request with IOSQE_ASYNC set, then we first run the prep
> async handlers. But if we then fail setting it up and want to post
> a CQE with -EINVAL, we use ->done_io. This was previously guarded with
> REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
> potential errors, but we need to cover the async setup too.

You can hit io_req_defer_failed() { opdef->fail(); }
off of an early submission failure path where def->prep has
not yet been called, I don't think the patch will fix the
problem.

->fail() handlers are fragile, maybe we should skip them
if def->prep() wasn't called. Not even compile tested:


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 846d67a9c72e..56eed1490571 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -993,7 +993,7 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)
  
  	req_set_fail(req);
  	io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
-	if (def->fail)
+	if ((req->flags & REQ_F_EARLY_FAIL) && def->fail)
  		def->fail(req);
  	io_req_complete_defer(req);
  }
@@ -2201,8 +2201,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
  		}
  		req->flags |= REQ_F_CREDS;
  	}
-
-	return def->prep(req, sqe);
+	return 0;
  }
  
  static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
@@ -2250,8 +2249,15 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
  	int ret;
  
  	ret = io_init_req(ctx, req, sqe);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+fail:
+		req->flags |= REQ_F_EARLY_FAIL;
  		return io_submit_fail_init(sqe, req, ret);
+	}
+
+	ret = def->prep(req, sqe);
+	if (unlikely(ret))
+		goto fail;
  
  	trace_io_uring_submit_req(req);
  
-- 
Pavel Begunkov


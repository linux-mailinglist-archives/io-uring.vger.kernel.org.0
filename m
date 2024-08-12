Return-Path: <io-uring+bounces-2724-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F8DE94F83E
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 22:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DF941C2122B
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 20:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 218A61917D0;
	Mon, 12 Aug 2024 20:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IS2dHqPr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DD114B978
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 20:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723494698; cv=none; b=nt/eih5svXyKV0YdkoTY9rmRO8XqTjPnud1EHN9S0geilGuIqpGgJ9shHUGcPI1KgSTBCxppFAEIlKzy+Q7NgNPHPEh2PIfbbQxQ6DsppPjisOcVPyDUglMIcOXQzW8L9pV9XqbjMzCyzt/K2LdAJnS9yiSd/1TnnuZXQMz/uAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723494698; c=relaxed/simple;
	bh=ZAe3tdol81Hm3RDq0vE71SI2b2PptYzKXA2MtM8IKqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=r19S95H3UhWaGHUJ8SlGGUUIh7CHkKqwkYzovteb/RXYlwRVEcjBGPjSOPY8N2K4yeBU7Czc80XKcHA3KRSgykcJRYp6IvJc7Rj5a0yItQyDHpIBrxa7fn7q8igYm4yoMBVRUjZpA3yMzgVSWxJrrHdLv17uzIoR92XQBhZpFW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IS2dHqPr; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-70d2ff38af8so211027b3a.2
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 13:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723494694; x=1724099494; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8g2XI2HZCdrRgczusBMi0r027eH3AbRVPt0dh15AyfU=;
        b=IS2dHqPrBll7Ig3+eHHIaFKuE8+8kzNmarQWdO1OYq1Bz85BmRfn0zL8x0e0u2Y0UV
         juXb4QaUUQla+hmH9FJLacrI0VDUaL5ojPeOk6P8dafE9SP9jhYSykvmMab/3rhC81kd
         TDUWOIKiXUdxHhgB8sv13ShKzFzLeJK7PGzx7sslqOMCxMV6zrWtUb1Pt6DwBcfP4bIW
         LJfgB1krbgT1BtCe8z335GebnFCZcbVj3wz4KhbGum5RlCwEq3xFT8s0EsBoALBcd19y
         YvYcLTy3f6Af1qKiqYGBdZu/lE23UpeBAvCuW5mb+ueHRZNfQonUBVvYRaM4udgtdKHC
         EwZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723494694; x=1724099494;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8g2XI2HZCdrRgczusBMi0r027eH3AbRVPt0dh15AyfU=;
        b=GMt448gKbVouaVnLggLxHF2MDYwjPUQuksq38Ht3OUobKnayI4/Tg1AVcFkA/tBRYz
         yw5CEGFrT5Ejul7TpDmJf4haFPbhFq0GLG7r73UcKXwRPwofq4C6dxZkawYFw/FcUBMT
         DqEmAtd7FVOXaxTsCXzQxCR33b4UqCgr3AU2JuFbpvurrQLIzNCvAg3FtBYSwpdhMzId
         IYJ7I7KlZctYFXMH8EtAPwWimQ+HBDYSaak4ydNTdPT8Ilxnc2zGyFEjLonxCGkVNfhh
         K9wiFGZ+9B1OQkScvi374u3y7jKYztKS1m/8ed2XzWO/ol+ZtBBirBtKwEjGL018GUcu
         Dhdg==
X-Forwarded-Encrypted: i=1; AJvYcCV7Cs6fvyPO++e29NsgT8FFH79zIJ7ehIbOsH9BVyAZAFFeI1up2/Low4MADfrEpjaMRaPUfpt/fA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx91bCIyyrww2StCRWveQiOEOLVjE1qK5nqRd6HHKe5JENPO8ze
	gjR5PyMUBXWoPbzNzBJV+48ZLvsz7PJ2HE64phyQaE/IGOfw/NjAnVQbgm7Wwl8=
X-Google-Smtp-Source: AGHT+IFn0nHlotRTTjFcpAmZf4An2a/rNswx0W0B0+UmGb+yRJFUJu0OEqMHQL36XLQkdVFbiU8hJQ==
X-Received: by 2002:a05:6a20:6a0d:b0:1c4:d62a:140 with SMTP id adf61e73a8af0-1c8ddbf90bcmr63210637.1.1723494694019;
        Mon, 12 Aug 2024 13:31:34 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6979ea8d6sm100471a12.21.2024.08.12.13.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 13:31:33 -0700 (PDT)
Message-ID: <402e9573-2616-4cd9-8566-e7d99fe1ab53@kernel.dk>
Date: Mon, 12 Aug 2024 14:31:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: do the sqpoll napi busy poll outside the
 submission block
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <44a520930ff8ad2445fc6b5adddb71e464df0e65.1722727456.git.olivier@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <44a520930ff8ad2445fc6b5adddb71e464df0e65.1722727456.git.olivier@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/30/24 3:10 PM, Olivier Langlois wrote:
> diff --git a/io_uring/napi.h b/io_uring/napi.h
> index 88f1c21d5548..5506c6af1ff5 100644
> --- a/io_uring/napi.h
> +++ b/io_uring/napi.h
> @@ -101,4 +101,13 @@ static inline int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
>  }
>  #endif /* CONFIG_NET_RX_BUSY_POLL */
>  
> +static inline int io_do_sqpoll_napi(struct io_ring_ctx *ctx)
> +{
> +	int ret = 0;
> +
> +	if (io_napi(ctx))
> +		ret = io_napi_sqpoll_busy_poll(ctx);
> +	return ret;
> +}
> +

static inline int io_do_sqpoll_napi(struct io_ring_ctx *ctx)
{
	if (io_napi(ctx))
		return io_napi_sqpoll_busy_poll(ctx);
	return 0;
}

is a less convoluted way of doing the same.

> @@ -322,6 +319,9 @@ static int io_sq_thread(void *data)
>  		if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
>  			sqt_spin = true;
>  
> +		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> +			io_do_sqpoll_napi(ctx);
> +		}

Unnecessary parens here.

-- 
Jens Axboe



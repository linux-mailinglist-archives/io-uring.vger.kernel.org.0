Return-Path: <io-uring+bounces-8253-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93A85AD03F3
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 16:25:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 622D117359C
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 14:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BF3A487BE;
	Fri,  6 Jun 2025 14:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XdRPICfS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60376F06A
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 14:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749219931; cv=none; b=R/rbwKwCUxhzlJx380XeTS0NCqnO8R/uaWUyZ8v3BhGZbHQ+SEIf/gqPd6BnUGB34FmqYz/t8DCEkcFeqPOfg8upgKAbsWzyMcnPKM6PQjj2GSu0Bh08UvA5HyrH1Yrw5hWbErPZvOrDEC/f77taNFq8b4v7+E4/sbwvg3kXhoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749219931; c=relaxed/simple;
	bh=0/Xbc5DoXdOonGdb1FnWFrx7HW4T9hMU9U0+W+iph0U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UAbBtzvVdSdzJ/kPs8njbI84dV9dYjevU8bX59KvWYBgG26HwP+wqbkMjy1hho5x+0I0TnBYIR4aqu9PL8+Il0d11LofCqZDpqiS5Pu/ZiGaHvWDJyVIeCPtGppDUG9nWjop1e5bsKvDqPw9Ji8blVw81CaIdrFNo2XeD/REC+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XdRPICfS; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-70dd2d35449so17322477b3.3
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 07:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749219928; x=1749824728; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RAaimuBfQTz1EHGQEWzx7YSWNC+FbUyMuJtQhEefSSo=;
        b=XdRPICfSOhvpOxOyKQJpQ+zbmOT8qydVb6MreHYvTciFJ3SuzvzTPfh3t7srKLyp6/
         EDrrxP/6Y+lzYIuBVxyJpfsrsTbC+uzgD2/yNiFofGuN7c7hIpNowl5xxTc0EfB0l5Va
         pQVHO26DkptM7jMa+VLUCaw/J+xPvBjbGS5EN932RQkpdCCaGQhCO9JXYbi2fM+PHR+h
         meyNsiz9cEPZdB+APSVLPWBYz2zvof8FTv3wOSE/UpcfJ2F6eAwFOruyAZrHbLieC/sd
         H1u5kVRQo53kfMm4FWdXYWxBMTm/+jsPIpk66T4+Px9xWusSWxffuSJiWQm9ifAGnH6t
         KPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749219928; x=1749824728;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RAaimuBfQTz1EHGQEWzx7YSWNC+FbUyMuJtQhEefSSo=;
        b=Rtosv7nGEKrOqax2d+eGXbB5J4A7FEhxc12UbFHr6FVL3QIcG+BeF+DAGFVMkjLFbR
         p0pxcO3QoBqCvmeKTsaKIwjN1PNJJqDGx79WRu673kUnBNKs4QljN1bPpUumcMnR8xZ9
         Lt4n0XvqnVimmsPZRk+EpmgLIx8lVyL40kChzo9NvyIV8KZDo5XRBcpoF2Ga2rVhfavI
         jdVbvGmbt4N8HNVWydkTT2qkA90evTNE4MrNML1nEORUIAtxuu3TT3udTGF9r7BrrUzf
         8pwIazmzVteaB0IKiuO0xEyJztincwLvMSICIMYEWC44xubQoz2rcj6FjqU0MLiZWf24
         4UPw==
X-Forwarded-Encrypted: i=1; AJvYcCUCUjFQsrggjLanMEo81WE5jllSyrIyduiI7hG1hAzVHLSwOcSj67A9MymmnWG41b7U7rCdqbdiKg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUUDSDONjF2E1dj/xYMywjDqzXG++PRveWr3aNlC4O/Z7Nm6KK
	YKPvpoTVQnbXA049+Iebqgrg0EpD0MjzAuyOQwh2QkVZTCowRekR95M6UL6sy2MadwFmBc1ZH0f
	BDZmB
X-Gm-Gg: ASbGnctWMu18rAdAk8woMw2tSJhIa7nkFjvXhD6HhbL83hWcp/9nmxFk/cCzYmIWKOn
	ZJQ5YNcaxrVwoFYU/QEsNv/xz5hYucehzW3k/FYlPMgp7S0cbMqfvbmM9W0np/WXwnkPFBjZ/Fp
	Cfjl1nqhHn/xQJxAINHX0ubqCGrfqwH7VuqqCXxUm32cniGV/mwZoQt5raOYMdq1eCmRyJLOJV6
	4pHr7qu2umPDjBR5XblRtHgFuqK5uM8Q4tO3j4vdOecm8ZeHjDFHuJva/KeMCf+EJEPcpJzlKYG
	7cGg73ooTCxCCQdYu0drRGWdmN/c55yIJVD1w1e2NP5hcppYO4Kpus1XgQ==
X-Google-Smtp-Source: AGHT+IF5km4CtDvHDOVe+SIqNmRZERGMS28Qi8RaU8LfNaXvtlGLcevIJqxza9IXKdKeERufgQAQHg==
X-Received: by 2002:a05:6e02:3093:b0:3dd:cb92:f12f with SMTP id e9e14a558f8ab-3ddce4100demr44053855ab.12.1749219916570;
        Fri, 06 Jun 2025 07:25:16 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddcf253213sm4120495ab.51.2025.06.06.07.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 07:25:15 -0700 (PDT)
Message-ID: <783d14e8-0627-492d-b06f-f0adee2064d6@kernel.dk>
Date: Fri, 6 Jun 2025 08:25:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 2/5] io_uring/bpf: add stubs for bpf struct_ops
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1749214572.git.asml.silence@gmail.com>
 <e2cd83fa47ed6e7e6c4e9207e66204e97371a37c.1749214572.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e2cd83fa47ed6e7e6c4e9207e66204e97371a37c.1749214572.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/25 7:57 AM, Pavel Begunkov wrote:
> diff --git a/io_uring/bpf.h b/io_uring/bpf.h
> new file mode 100644
> index 000000000000..a61c489d306b
> --- /dev/null
> +++ b/io_uring/bpf.h
> @@ -0,0 +1,26 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#ifndef IOU_BPF_H
> +#define IOU_BPF_H
> +
> +#include <linux/io_uring_types.h>
> +#include <linux/bpf.h>
> +
> +#include "io_uring.h"
> +
> +struct io_uring_ops {
> +};
> +
> +static inline bool io_bpf_attached(struct io_ring_ctx *ctx)
> +{
> +	return IS_ENABLED(CONFIG_BPF) && ctx->bpf_ops != NULL;
> +}
> +
> +#ifdef CONFIG_BPF
> +void io_unregister_bpf_ops(struct io_ring_ctx *ctx);
> +#else
> +static inline void io_unregister_bpf_ops(struct io_ring_ctx *ctx)
> +{
> +}
> +#endif

Should be

#ifdef IO_URING_BPF

here.

-- 
Jens Axboe


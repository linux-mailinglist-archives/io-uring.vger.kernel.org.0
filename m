Return-Path: <io-uring+bounces-10336-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EF917C2DBF7
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 19:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66126189B3C4
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 18:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC75274B39;
	Mon,  3 Nov 2025 18:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wRDq/T6r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C045312810
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 18:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762195935; cv=none; b=mcGsoDVFrKsQXK181+vL2YsuZ3snYI3wGpYlsV1+PYZpKK5DIJ4HXk1bxqa56HYYxWGBmRNpzjRJyqTyt8j4z1UAFjIfW5TOH1ZqyYulWoDJj1P+l5auGEdnEsNc1r5+BgvzVNcEG/BTATrG/HuCuM2DrbOTOM3MPwkQ0g1r3pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762195935; c=relaxed/simple;
	bh=Tfjlmwgp7jBDKS7wJLGCM7rnyhv+v1/ZjsbRtoATg8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cmtqhGgqLGz2dMDMevjOjd2HkYp0KvfRay20Iz/6iyh9z9U+3kLNgUYG0HuVGHL5Pk2Qr/Dz7m3/rYdc8cC1I03izOl7Wy5gzaAIUQ+hDOubCK0FJ/vy9XVVy8Gq9vx6hqx6Pm0nET8MfW7NJIBdgSiIWD8j8ZBNe+/fR6sroS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wRDq/T6r; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-4331e9cb748so7317345ab.1
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 10:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762195933; x=1762800733; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c3LLOt//Kk9Cau57vFDfarzw5ZwM8QYy6IyKlQctH+U=;
        b=wRDq/T6rOqbII4/kg9E79fWNpdr1opDw1k3fPuZTLRngn7/g3IezSMUv2knzvCZvfG
         8wsF4kGt12stEytiGfIzSYI73rNuhfctFkVxOSvGxWTMSsT0d3mthkrRkFcjlR+4WkF0
         vt2mnuXp6szMwzagKhcJwHlMpKoAX5IAGtJ5nVZz+X5xNUxPld0Yfchkw3YU9hW6jd3V
         0fiXOj/wChA91VjeEBodGwRtwqhqTHOgbVw8SZzyPnX7A87aiXRH1kydlN9tCqr+XaHM
         I8kpEvYBOb9pikn+JN7o6DM9WXoPovHc50vslR/rfVFySCThGJ8NSIbr5uQj98f9O4qc
         rhzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762195933; x=1762800733;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c3LLOt//Kk9Cau57vFDfarzw5ZwM8QYy6IyKlQctH+U=;
        b=gbqaEOcUAzbt+mi4F75/MhsrPFRhzfXMCHHuWtrMBRIBVhbuOvUPzyVnUY5IDpztuM
         3A6W9Dg4wm5LCEQ3cbjfavY+sywojyR2OteVpgwj88HgqfleXeLd1fKkPkjCg14Er0ES
         GbxHKM5u8cHiDdoOYMOKTtOf616h3ArFsS1TOcl0u1zKxkYKTXO2A6qrf1Ee1tG51NTT
         8OYltBgaJt05Xnl0xpHag3IU7CmfudYgcI14sEZEM0I42oem9zVIDiQbtLJ8grEcnUL+
         tJzn4OwMLGmXFzLaTQQ8LhLwDFWGY1SoC2KfPebM9pHd/ObPLW1/mAootH9Y4D0+Vxeg
         HKFw==
X-Forwarded-Encrypted: i=1; AJvYcCX/taGwS5bVGZit0eEHzoNVoD2vQnolowKnOT9R/yDg9Ht61V/2Zhj5zJiOVovwV/0kVk0y+NaJZg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd2g/+5v1ML9X44BYUW2KoMszlOHCJIA+DEOOKCOlitR8n3LD2
	Kfa2RqPm7lXqsijQpk+m253spTaxrtO7MX7jaA9zFBR8A0NTX0ZAh4TZYf0mARLDo2I=
X-Gm-Gg: ASbGncvkOzxvWrMTpb/UaeJ7FbX8OrlaTjKNzaF9QG7DcpOPdrtmiUNAT5ETXysjW4L
	JEIROGb732zJ+pPJvOnYnUrERhPHLw80835q16xaycrbYVSMMRR8AxyCG3mwcsquGNNA5udXsoU
	xIlqwPfOFBHSS6//iZoLDcCSvUNHWF/VezpxNHOycuHP8KQtXg4GVDrnsm+dhceSZcV2Y92Y9KK
	nugbAoSz5cy7hd7johbPS8jJVXO6hvBBBEJlxhxfKGaRhMWT0nEJ6/KIdUWt7hA7W9OvhC3WL0L
	BxE1qHmxxPpO/9RiLBC+cYoQBBr6XHTcz/pLYI/FxHoRbdJ22vInFkouHKmlGmR3nCiVfQDgvO7
	lRpOPTmlYTq2brnxHGtlAepsTezKEY8cO0AOYva7tvQffE3p55LI/bC1q/F0o7yc/fMixUVzlWK
	Zo6NuQ+Co=
X-Google-Smtp-Source: AGHT+IHL1W9ITdMknzBJIrbNblJwZOJyBke9ngTRiUMQ7Zu7FxsNRMXkir7tES+FupfJFHXFewIRCg==
X-Received: by 2002:a05:6e02:1064:b0:433:24ac:4d4a with SMTP id e9e14a558f8ab-433378066d2mr6802195ab.4.1762195933413;
        Mon, 03 Nov 2025 10:52:13 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43335b48733sm4410575ab.26.2025.11.03.10.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 10:52:12 -0800 (PST)
Message-ID: <a3a7f07a-50f5-4a07-9b14-4d9e41a82586@kernel.dk>
Date: Mon, 3 Nov 2025 11:52:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix typos and comment wording
To: Alok Tiwari <alok.a.tiwari@oracle.com>, io-uring@vger.kernel.org
Cc: alok.a.tiwarilinux@gmail.com
References: <20251103181924.476422-1-alok.a.tiwari@oracle.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251103181924.476422-1-alok.a.tiwari@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 296667ba712c..59062db89ad6 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -915,7 +915,7 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
>  }
>  
>  /*
> - * Must be called from inline task_work so we now a flush will happen later,
> + * Must be called from inline task_work so we know a flush will happen later,
>   * and obviously with ctx->uring_lock held (tw always has that).
>   */
>  void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
> @@ -1246,7 +1246,7 @@ static void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
>  	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
>  
>  	/*
> -	 * We don't know how many reuqests is there in the link and whether
> +	 * We don't know how many requests is there in the link and whether
>  	 * they can even be queued lazily, fall back to non-lazy.

Should probably fix the incorrect grammar there too, if we're making
changes.

-- 
Jens Axboe


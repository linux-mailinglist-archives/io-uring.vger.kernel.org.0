Return-Path: <io-uring+bounces-2385-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DE3791C76B
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 22:36:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 489991F21A74
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 20:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 027B577103;
	Fri, 28 Jun 2024 20:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yNUB2Ncs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823B07D06B
	for <io-uring@vger.kernel.org>; Fri, 28 Jun 2024 20:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719606971; cv=none; b=lfBmr/TYK6MDlJYODqRSg7Sd8WKvuane/LCMeEwWM+pgWFp3Fw3c/FL5GNTkndUDmFmFw3B5x4YN+3zn4eGMI9o6lUw+pZYdmwgdptuf7tSWxIP6ZzzIswomANsxxfi1fJoD0phpAocfYCs88eVKjtuVZZ63npKFiy79W+eQO2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719606971; c=relaxed/simple;
	bh=2K3dQB3zpbRSQ4zNsm2kr2egLTbsrKEaC+HcN9qfUYY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ljbP/xNkAHjywfE7YmRoSxIFq7tGv4f97a9vF3GSmwEkTGcNzBNrIBkRN+zaeW0X+zkXwkduLSbTIwuPMpZOWvoZB/I5Fhk3I9K3cxIoaiexiVrUM2whlbxvt3OFTW8kPyVNwU5s9GtQLWJiqGzYBTmYn1lfHYPYKYxqISLnfhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yNUB2Ncs; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5c41104e447so55118eaf.2
        for <io-uring@vger.kernel.org>; Fri, 28 Jun 2024 13:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719606969; x=1720211769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5l0qovf4jTVxYzo2d0+ddTKgfILRCCXgo0o1Ulo6Ekk=;
        b=yNUB2NcsuUo9AAjBGJ30Z/C5gP4BG/PE2245Bc4XiMD1X4HPlihN/4UgsNhUezL4rW
         QAbNjahKDm2mv+U64uMrNxRuIWrxFd68XF7rZR3KyKc8IT/thloY8VDYOqyYKynHDk95
         KHR1ZEdtaluaq3qQ/zsHx5vpLOFXuQJudp8C/C81/TgJo10wh6o9AqZZaAlUU+Wyyc9w
         VFjk5NlgHYFgdStBK5JfJpMJy8y8BnFAC6E3yNPik0aJNO0Ml6At3GgMVMJyZRUOXgCN
         Fs5HRHMCQUmtlctRZq07LBsXe53/QrfjatQWDRYIuaVYRq1N6vPL7ujXBfhCUNkbHcti
         9j4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719606969; x=1720211769;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5l0qovf4jTVxYzo2d0+ddTKgfILRCCXgo0o1Ulo6Ekk=;
        b=bwXh2OaLRLKV1Ba4Mn2vsBtfIwpRRJ4+pwL7fA1NVP8NXWdel16wqCdqrm4a+yQQ/8
         Q1GGqMCVQmIpdHlYccTzsBKaSCq3ys9tgi+gKfbSDXnF3hKxMNNoSRPEYs2r00Uqqn63
         oOYZzQvJyF9FlrXQLsMEHuULNGf4Sz8/X2PxvPLRAHDbdTlJQxJLv8GqBKoDwdfktCdT
         b3OnNHRodTS6TdSQxII94MAWTsP52UgTBfFccsGI6yVU8RdcJYx7+I7I3Smwc9TMm0p7
         hPpLLBACDUs7+VRI8qJdWcXvcOBNuhlt81BJBeIwTrUt3RcSuQ+tdT0DUb8U4YZHCIHX
         jR4g==
X-Gm-Message-State: AOJu0Yyq0yjTBUm7gdwWzouxNTIIu3WsOgA4zrCMrNC4byL+zjlmbju+
	rDsnb7qxL1rzjrN5XaW9O+gt7yKLtuMYYm1h8x8WHlx1w8Xz8W5zSw4hAEXxFr0=
X-Google-Smtp-Source: AGHT+IH4WazrWMA1Jhl7+Mv0AnHm21EMJQcJF3b3HRLS4CUfPejixBcFUyOtlBC/ESyNwt5bq0+QDw==
X-Received: by 2002:a4a:c186:0:b0:5c2:25cb:e6c6 with SMTP id 006d021491bc7-5c225cbe811mr7965464eaf.0.1719606969571;
        Fri, 28 Jun 2024 13:36:09 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5c4149c37c4sm367003eaf.42.2024.06.28.13.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 13:36:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, mpatocka@redhat.com, hch@lst.de, 
 kbusch@kernel.org, martin.petersen@oracle.com, 
 Anuj Gupta <anuj20.g@samsung.com>
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
 linux-block@vger.kernel.org
In-Reply-To: <20240626100700.3629-1-anuj20.g@samsung.com>
References: <CGME20240626101415epcas5p3b06a963aa0b0196d6599fb86c90bc38c@epcas5p3.samsung.com>
 <20240626100700.3629-1-anuj20.g@samsung.com>
Subject: Re: (subset) [PATCH v2 00/10] Read/Write with meta/integrity
Message-Id: <171960696798.897195.9522006867615686131.b4-ty@kernel.dk>
Date: Fri, 28 Jun 2024 14:36:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Wed, 26 Jun 2024 15:36:50 +0530, Anuj Gupta wrote:
> This adds a new io_uring interface to exchange meta along with read/write.
> 
> Interface:
> Meta information is represented using a newly introduced 'struct io_uring_meta'.
> Application sets up a SQE128 ring, and prepares io_uring_meta within unused
> portion of SQE. Application populates 'struct io_uring_meta' fields as below:
> 
> [...]

Applied, thanks!

[02/10] block: set bip_vcnt correctly
        commit: 3991657ae7074c3c497bf095093178bed37ea1b4

Best regards,
-- 
Jens Axboe





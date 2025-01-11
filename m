Return-Path: <io-uring+bounces-5818-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 38076A09F10
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 01:13:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14BBD188ED3D
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 00:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9845383;
	Sat, 11 Jan 2025 00:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="07S6txlR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC60372
	for <io-uring@vger.kernel.org>; Sat, 11 Jan 2025 00:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736554383; cv=none; b=SI6+7b5mOfmIMUnXctXgvaukxgP7Spsa66LhibYkHglD7qiFJpdeWV/CQ9DRR8NJr2TQMp/R9HGLZm7V9dt5l58dEuoU3z/dyRRbp/B+MJiXOIud+GrHb1/8azCotG7UvmtXjidOt/hDm31omJptrjMKZnNnElU3/f2Uq2Ld91c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736554383; c=relaxed/simple;
	bh=DSXdlZUZ230XZD0U8NwzK1Jc+/jvMC8Bm0g6t/7Gq7c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ch1q1cjGq9JfboJuimV/L9ZX+DwJdNPTvlsx9fn6opplnjURgWj3JcweScSQws7TvzvPFWHdKwiAfdsvqpplWgdSzRgR9RyrGFrZvHQCFLqa+8SIgbA9TpDCHdzcW57vgtPOhbrRFEucbQPU2ygDwnPRFd2+Ee7/KBXSLDgzgDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=07S6txlR; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-844e6d1283aso117933639f.1
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 16:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736554378; x=1737159178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZw92ldoH3OcK4XDquY8nDoBqbMWUwtvwgADA/zYHJY=;
        b=07S6txlR6cLFPeDjXb7WFs0hQ+PNxgcWCGRmcahnBIDjhnnrKRWyRS42nFaFwh38gM
         BCE/ll48U4hbK/TU9VCaIQ/Ebj+xQklb2E1AhJDHCKoMPWcGvHulfxbQYfdNB61rc8ZH
         nwH01MtdKdRJorZ5WiNIHWYsZy/wMeP2j7pj4aTvnAcFLdFpX6JUST1rTORUGfANphoU
         pfDLPjWG+XaMbYcX782ahdA+UTXAeLI7zMthVNCr4p3Y4BG7OiAIhpWi+V6XAcR2WMB7
         Dw2ztmBDcwvApMHK1nZQCM01YkNsOwnEsV6778LHVZm/Z7Xna0kywwVibkVgoIx7xhaw
         p3Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736554378; x=1737159178;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eZw92ldoH3OcK4XDquY8nDoBqbMWUwtvwgADA/zYHJY=;
        b=u6bnSin8tCskMqef2DZJTSfhnqD+CADzO+84vSD+xnRUd6p+xVoQ0uKpzXZBAXZyxO
         u3WXQAkZhjJHdYO34vOpjD/dw2op+EHHk211v+bm0sXMePjfPklpg2+9ln9ETnm0UV0I
         r8rSzAYI+sQK84PALUBTGNORb+GgHpMX6e2PUCsiANJRenYiExMXBlhi5AMhbJrrmVGZ
         H/cEKLamZRmH4VnKwj5UIu/Izu8dMhaCx6JL9TVkK0P/uDRF6eAmXO7ReFpv0TUUFnkc
         S/oYsQTBpxuWazth0GfrbWk+egk0v6wKB7i5SmETJP8/LpVuoqnE/X5CaIzHqh1bKP+4
         BHGw==
X-Gm-Message-State: AOJu0YzcoL1fMe7tlgVAbg5w+KsuUrBVPCG1mm1bu72a4cyLuBFHkTGh
	yUL4yW0prU0MpbhcJkKeSo5RnLPUiO2PThslGDWG8as+tsMv+v8AoAw5Z3YAt4Y=
X-Gm-Gg: ASbGncvMKTRTO8M+zoo+s3Sg0ijx2HEWRUnhzJkgtR3Api/axmrWlz6XFtXr50jVM8T
	3xxKp0QzRPJYUesfyWe9bz5QQZ++7LssyGne/8zBaAbRTKYLt1aYmgGwd28wTVh2h9wOAFc6Bko
	GXE3+3JJEiopuGkMKwbPymg8aUvrft6UNZSSl09fokGnG3HFNOiO3u0MXG5jAdYgOmCW8i9hlQS
	uYc6J6kQnLMmFP3sW99SI1dTW//OhYQZU52agBpjfwu8+OJ
X-Google-Smtp-Source: AGHT+IEDoeZCcTdEl8OjjwocgxZNFznNXwcW7JorUMrtCaUaDtRzFIn+UNVkVO6gnpuv5uhEZZQSug==
X-Received: by 2002:a05:6e02:20c4:b0:3a8:13d5:bd2c with SMTP id e9e14a558f8ab-3ce474ed04emr73844495ab.2.1736554378372;
        Fri, 10 Jan 2025 16:12:58 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b6143a6sm1147909173.60.2025.01.10.16.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 16:12:57 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, anuj1072538@gmail.com, 
 Anuj Gupta <anuj20.g@samsung.com>
Cc: io-uring@vger.kernel.org, vishak.g@samsung.com
In-Reply-To: <20241205062109.1788-1-anuj20.g@samsung.com>
References: <CGME20241205062910epcas5p2aed41bc2f50a58cb1966543dfd31c316@epcas5p2.samsung.com>
 <20241205062109.1788-1-anuj20.g@samsung.com>
Subject: Re: [PATCH] io_uring: expose read/write attribute capability
Message-Id: <173655437723.922246.9981758697142954394.b4-ty@kernel.dk>
Date: Fri, 10 Jan 2025 17:12:57 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Thu, 05 Dec 2024 11:51:09 +0530, Anuj Gupta wrote:
> After commit 9a213d3b80c0, we can pass additional attributes along with
> read/write. However, userspace doesn't know that. Add a new feature flag
> IORING_FEAT_RW_ATTR, to notify the userspace that the kernel has this
> ability.
> 
> 

Applied, thanks!

[1/1] io_uring: expose read/write attribute capability
      commit: 94d57442e56d2ad2ca20d096040b8ae6f216a921

Best regards,
-- 
Jens Axboe





Return-Path: <io-uring+bounces-9921-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A5D9BC1A0E
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 16:05:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id AB99234F5D0
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 14:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D98D32E1EE2;
	Tue,  7 Oct 2025 14:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CVmTL9Tp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419372DC337
	for <io-uring@vger.kernel.org>; Tue,  7 Oct 2025 14:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759845890; cv=none; b=SkImfkiASa6Ef5wR8TzCQzs2RoHwrdKoGi0xVLfzs2U0v3rQyeBDTR42s1RPc90Ac4VKYmv6+y/RSVj+NR5nHWQymqIBJSfQE0BRYcZwJQY1uP4Qqtyw1pqGa6ZbQWYP5tlUtHUgCOI0nn6Nt7zFwEhDerC4oFDjYNtHPDSnChY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759845890; c=relaxed/simple;
	bh=ijLAN0exJCji6rgx+CHni2NaV0Mf3H8FK7MowTwd4KA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=f7lchIsDtPfk6PUumlHN/gJPnudo8s+DIZ3Bn2I9/Oq7WIT6C2eB71D9JaQUJjf3E7wrNv7HQWzlpUwrhj6QcZOHbw6a4zqWw4CQaT0htp4Fhb9Vhm96dKzTtiqzqdWYwwRl4ZUGOUoA/QKhlaxgyR2bAjZh9wxTEwjtDsdbA2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CVmTL9Tp; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7bcfafec537so4498397a34.0
        for <io-uring@vger.kernel.org>; Tue, 07 Oct 2025 07:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759845887; x=1760450687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ErqCQuWU4GRUllCeMfERo8Njpa/eKfO7vvWJYYk50gk=;
        b=CVmTL9Tpc4TsIDQt3KI9LQVxJv2SkbJwmDKh4afYjFDIyzrtGcGyTtuQikIYDLPQfS
         15GdFM0vKXybJpzOhEpPSxgzOyCeCFO/ZGexrDVcSGNiY2veiXMxtlh2aFbxbHdL6ODK
         rOFshyTGhYu5Obs/iU0624jGErK5k9ZBNO9RogwlBcwDkvohg9pAlzYDn4knB34qd3iF
         HeTlZRW0/cl6Q43eaM9rJbG/s2f3gcjTfLhBs+dcp8AIk1N8I9L9r5U36tqblp0skeDm
         JXmJv3LTWyZ1Pm0mbkpfDukMGoUGpEO8/A1DJb9c8BZkC8aO21K16QPdINtE3jOpoKRO
         wrPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759845887; x=1760450687;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ErqCQuWU4GRUllCeMfERo8Njpa/eKfO7vvWJYYk50gk=;
        b=ueEXeZcmss2GzaFv6hWgk6MPeV6glFB7Hc3KM2ZW01WkmII4H0qNjH0cyfX6M5+HrS
         3bawAdEdxjeqridt7lD8kP0gCj2+A8krb8d6OCQwmX2d5sqsMJSM9zVF0sb2eL6u5kfy
         x7YLN17gb18Ml5+5zqM7Etbv6aytkHorB8zVakPnhKi3U5ZpOydKY/rkytpDlyicuzfL
         CWLnd2cqUA4F3HLsj5orlnkh0dAsIXd9QWCAc9ZHOeslhZfP7/D2RWHyepNFjCd6sEqg
         3PqmHxwO6qf1APfiMQBeSYaFiwYEo4JhL1rNOJtPvY4uq2s9NXG0EhOF615uz764s5Cx
         0qTg==
X-Gm-Message-State: AOJu0YyGCZOgwiET+tOG/v/9XsMqtqtGNRNrX9CbBRzh1YSRvJrew2rt
	IdZG13ZQLL9Nu7J3DKi8q4EuMhb7R/S3YoiIiRd+bO1nABDfYuk92OtKRphClZIh0eY=
X-Gm-Gg: ASbGnctOmp2GiUyDiUdHr/EcXWc+eu/wG8kfDDTzxZkmpPzXBok1y7HI5zTNemu/6q2
	ziutAD3/3h1KSo8fuApPa50l6qSNhD29ce9ID5AVmgYOdcmCdrHJClg6zt4tP1arSgCVLyjl0Jr
	9BKxzJHRf4AfRZznvZZ4mFEkvuHUnXSR1YTu9k93GIMrqU0q0NX0FV0F31fwRt38Sv1RMWlkrKA
	K8jYLnMyXdsfekVbWRonaxwnLCo6Uko0DL5u0H/EIeity/85R4O5r3wuG9GS/CwC/B/xnSLUzbu
	VnlO5dfHqiqftRgbwZIlKdKAM9/GO2O8tZq74kiNu52g5qspKNIqxAb+1K2MTv+fbfEvUtju8WZ
	uFmkxJTbCryhHCbcBavvPsIQLGmQF5H4ZqGy6zNQ=
X-Google-Smtp-Source: AGHT+IFSCjmQBh9z5IS27ZLrcF5NLDUQRLu/27nCbuXAxqTDL0C5q+k2u9OUG1h2/kpqOvFVSSlxPQ==
X-Received: by 2002:a05:6808:250e:b0:43b:8cf4:9284 with SMTP id 5614622812f47-43fc17ad13dmr7686074b6e.14.1759845886612;
        Tue, 07 Oct 2025 07:04:46 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ec4aa7dsm6045985173.65.2025.10.07.07.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 07:04:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Haiyue Wang <haiyuewa@163.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20251007061822.21220-1-haiyuewa@163.com>
References: <20251007061822.21220-1-haiyuewa@163.com>
Subject: Re: [PATCH v1] io_uring: use tab indentation for
 IORING_SEND_VECTORIZED comment
Message-Id: <175984588596.1934259.1809567091954753640.b4-ty@kernel.dk>
Date: Tue, 07 Oct 2025 08:04:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 07 Oct 2025 14:18:18 +0800, Haiyue Wang wrote:
> Be consistent with tab style of "liburing/src/include/liburing/io_uring.h".
> 
> 

Applied, thanks!

[1/1] io_uring: use tab indentation for IORING_SEND_VECTORIZED comment
      commit: beb97995b97532e1f215e3295e6843e59862f94b

Best regards,
-- 
Jens Axboe





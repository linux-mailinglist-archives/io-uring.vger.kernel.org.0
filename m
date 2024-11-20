Return-Path: <io-uring+bounces-4864-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D38579D3D63
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 15:19:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B32BB2E11B
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 14:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A87CE1AA1FC;
	Wed, 20 Nov 2024 14:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LpmCIM6x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA321A2C25
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 14:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732112028; cv=none; b=LcpE3YsNpEEHLMxMqRIaeOciUT0ObXZPwlh048QF41Yf+6zKDaFL03EBoSzBDsEbOFFhCu0aabx7ipE6g0XCNAxhzyz6Ab7DSCq/QJrMXVD2c8iZo8MdI3TgX75IGenZcJTQUzg2V956PhOQa3lhXlfJJRaPlZHwMybj8clvHzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732112028; c=relaxed/simple;
	bh=fG2rtQP3i/fL3pl3U4h6EqkOrbGR5g+ma9OgPWJDVWE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=CeVzA7qwpFs5uu69FDKdJasX6rdYbsaumvAggqLyC4pVY6C8FWqLzY1+AXzeDlICKFyst7N5bBiavtri/RibIBHEfdtykqIbvId2CERns3rHH09WHBd7eAka+VE9PzUKWvPMo0lG3M8hOT3z/pHjLfeza0+3jWPB+zixEFTsI+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LpmCIM6x; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-296b0d23303so1258283fac.2
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 06:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732112025; x=1732716825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eTi5b10WLqsSCiJUbo5/jmc+MHfUzlPQvFKPqOZIskk=;
        b=LpmCIM6x4TvKbGsPpW1de+zhTNl+wyyKhR66oMlBjtPPpyw3WK1HsH1DFSH33jlEJ8
         P+6hE07JpLLfp3Ihp3RpUSHwaZ0BVel+cr3juEEllrLYdyZkBo7EN+k2uioJir5+fsw+
         bEWB1X2l4oelgfkbfvXrgg7HmejO/cI5N/vM1+IwOR3lLzdslmAiUvR9rPbDsUIzTxPR
         i1IZLvKNdCJdYioxtTv+jyBa+ZSSvbl9a+JnYukGDIctDx0uzzf8OJZF72RYQMx36Ozv
         4PskqUECzyv4QjFUOcxc92+HQX2CnlvXIS2OjBuAmo3abvl7dOxvzMwzo4ASPXUESiAJ
         0Wgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732112025; x=1732716825;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eTi5b10WLqsSCiJUbo5/jmc+MHfUzlPQvFKPqOZIskk=;
        b=EJmkYBUGq5s6Ji+chRXx8tqcN8c65Lg5QiQu7TkaaWEhqFsyCvuWp2U6EQ/Ia9vj+9
         fkun/2t8GJNc5b5arQyo0O/WNJRZNhHQe3wvXdlVuP2qtRlveoOm9lhM+Xm30tn0gM6L
         /aoR+2FXM7ih5tY1bpv0FK6meyt0oMGuMoCo1D0KImAengw+vn5ipV9R6InIm7GAsgn5
         EyYYj8oo9JtdaTOrhYmaVLvYuZEs8k7rchEg3hzJodS9foPwSj4Qs/drD4TE82mLhtDB
         wpHgkJNLg90XasowEquOIgRYUqLD7oDtYRFxf1aYC6r6Vkk3LM+1YKRHdpAw3yol9XEo
         KFkg==
X-Gm-Message-State: AOJu0YwSNy5vflZqulH2kkiatv8X885NjN2bI0yy/Df9GTjaMf/SH7jd
	UR5tEVXqpme+f12VZcGduSqY2Jom3IMJ2cfyUYhJAYOMB3PjP+79LtaEPsFFd8iCSuwcEtPPk/E
	0GLw=
X-Google-Smtp-Source: AGHT+IHKEqEaFV0atda3jXxRVp2Q7ZAibmbPVVSQctOYrQe4CjaraL/pBwf2ptYdMN+qn4DtUXHsLQ==
X-Received: by 2002:a05:687c:2c11:b0:296:dd44:de85 with SMTP id 586e51a60fabf-296dd44e290mr2244900fac.28.1732112024924;
        Wed, 20 Nov 2024 06:13:44 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29651ac5ff9sm4185830fac.42.2024.11.20.06.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 06:13:44 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Dan Carpenter <dan.carpenter@linaro.org>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel-janitors@vger.kernel.org
In-Reply-To: <d8ea3bef-74d8-4f77-8223-6d36464dd4dc@stanley.mountain>
References: <d8ea3bef-74d8-4f77-8223-6d36464dd4dc@stanley.mountain>
Subject: Re: [PATCH next] io_uring/region: return negative -E2BIG in
 io_create_region()
Message-Id: <173211202382.191688.16891113055939966026.b4-ty@kernel.dk>
Date: Wed, 20 Nov 2024 07:13:43 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Wed, 20 Nov 2024 12:15:05 +0300, Dan Carpenter wrote:
> This code accidentally returns positivie E2BIG instead of negative
> -E2BIG.  The callers treat negatives and positives the same so this
> doesn't affect the kernel.  The error code is returned to userspace via
> the system call.
> 
> 

Applied, thanks!

[1/1] io_uring/region: return negative -E2BIG in io_create_region()
      commit: 2efeb13a0e2a0a188ae85ce7d838874a4c8d135d

Best regards,
-- 
Jens Axboe





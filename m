Return-Path: <io-uring+bounces-9044-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BA57B2B1AD
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 21:30:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 383A87B0B0B
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 19:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7CE23451B0;
	Mon, 18 Aug 2025 19:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="We/misZD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8235288A2
	for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 19:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755545349; cv=none; b=pCTwgY2+t1IhPQzOFiyRYyEx0Wf49mSD0XxtlwAXPk+4w/GGjAke1bv9AxqOwZEzyjmRm/s6vMdrQm0GImId4dWPaQE+hHhZtvPp+FhQZZSXQ2PIRh008KM36vpg9Igufo23pnrP60QOPJ2HeSCwMwRVS5Q5RMCtKcMyC5FAPdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755545349; c=relaxed/simple;
	bh=1lU4km32AZnq6NliZCVS37hMAgfVE0WxgZIt9/mfEUw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gLvU6ptTTeUxt7sXB0pX8rVwIRRYBMxxUrFc7wlv9zC4w6w7gKMo0KT3gmaV7JLigt1lnLmCRqQTunqE0b8zBNGMi8gyTBhQDL/4rgQXi3RkaXVtrB8h2DB79f7YKkFwH+e5x1lHvkGWA1VEQ409ypMvKzjD6br5VNmvTNnsG90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=We/misZD; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-88432e76dc1so276000039f.3
        for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 12:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755545346; x=1756150146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Ri/JcrxmHl/YNpRCclATkji1Rwxsl+weqd7WGuV3vs=;
        b=We/misZD7HFIEfw+LtRDNVcVXdHlyRPlX0Y3FvMqp9eWUO/ujgmtZck6gnmVyJELcC
         l5bOpx6LmgofBUIOq/8/Sf/tSHsxhLU2r+vUrdg4FtH46JdBlLN5VhX+FTJoiCZDMg4/
         F/0n3DwbhegQ8Q3/6S9UTkVbo0Pzhl8D0s3zY5vF2lIWLgCKsHnCLGK3nBB921cB1Dp5
         0DtyKqoPn5rPxwSalRi1PfR+1Kohm2uEmjL71D0Lm2AmlAfyKJUldMS6meQyj+NL5Huc
         Be2gii1vGQqHCWRkaqcBt3ODSrY/FANcfasq6rcF9bCQgk5MJDuN1JkmULTvJF4mJN7M
         0v5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755545346; x=1756150146;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Ri/JcrxmHl/YNpRCclATkji1Rwxsl+weqd7WGuV3vs=;
        b=jSLfKjmwNHjbn3UAm+8DhX4kgNfJDuj4VaGIDoSqNAo5Z2DRbX5ty+Vp3Q807rErzG
         I+UUvc6w+YqT3edDjp/61wvPpyo8ZZxGaQOkSsi3mz5nlY9uFU0pHUOPtpWLL5le3z86
         mGub+t7bSuzB0I0gRjtilD8X3WRyEDmbr4dGbG/1+0lgyfTQnP8o+qMksBENHMmQbU8L
         MktBlgCKdBmFvwiBGJgyJOlbT3AoGbp2woWnHBCr6WFzUXK2PaodDvAXJmfqqf5dTPET
         Xya6Lh7sXaLTmn/k0la3kq0MqB5gqsB6sMHXa2IvGXtgQ3pHwmk9Wl3yRwNn7lwGbxy1
         fEtg==
X-Gm-Message-State: AOJu0YzK9eK4u8/j0eaf4QSSOOjwk+1oIpDMDIoxzc6PtW8odipRrBEz
	0Zr8sKW3FdDMQVl5OzHI0cTppCnqyjHdUp/ENZ4ySo5bHa6whifE0ruXAOAXEwKBpaznXRcFHWL
	GlTFl
X-Gm-Gg: ASbGncuDZVneOPWV0fUCBsYmIvUx0WG2VfTocc2FlsNqGouviIcLlbK2+gHoTUygqbX
	XmGB7eMjx+tqdo78SPeN/fP/MB26yUVm9H4qWv7MUrB8OhaH/iqOeXC/ycexXQn2C++y3IVpbpw
	EtWyIVzCxACfLkKfIlDnjXvKk/uMBrrGkb2dCdYK7vyK1kVinQgTIBfkp5NCsGtcaeE2kK4I4L2
	go1rWIrjLwQYUvVM5zjWr45inq8tO/AhRzBzF5f2gnaeoIZ2/DLIrzNiv9MSG+JJBB/wyRsOwwI
	OGsEkXnhE6VpgEwut3zQUWF7fcNiDE7te3Qji4Mlz6EcfhxyaFTn31sM5W3NpKiQRTGnLlmHmIp
	/OzyFV/2fpzeO3Pr3VrKmtkP5w+T7f0XvB0E=
X-Google-Smtp-Source: AGHT+IE9+jQaF9qVxVr8/RgEj0auP3Z/6EG3OPUz80lhUcbZ9HhOd/6pW4lUUeLdXIp1wFRTJCfUtQ==
X-Received: by 2002:a05:6602:3f92:b0:881:80d6:6f0e with SMTP id ca18e2360f4ac-8843e37919amr2665376639f.4.1755545345739;
        Mon, 18 Aug 2025 12:29:05 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c949f8936sm2854232173.83.2025.08.18.12.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 12:29:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7a78e8a7f5be434313c400650b862e36c211b312.1755459452.git.asml.silence@gmail.com>
References: <7a78e8a7f5be434313c400650b862e36c211b312.1755459452.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 1/1] io_uring: add request poisoning
Message-Id: <175554534485.130800.9422267559271128602.b4-ty@kernel.dk>
Date: Mon, 18 Aug 2025 13:29:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Sun, 17 Aug 2025 23:09:18 +0100, Pavel Begunkov wrote:
> Poison various request fields on free. __io_req_caches_free() is a slow
> path, so can be done unconditionally, but gate it on kasan for
> io_req_add_to_cache(). Note that some fields are logically retained
> between cache allocations and can't be poisoned in
> io_req_add_to_cache().
> 
> Ideally, it'd be replaced with KASAN'ed caches, but that can't be
> enabled because of some synchronisation nuances.
> 
> [...]

Applied, thanks!

[1/1] io_uring: add request poisoning
      commit: eb7d5ca9f9b9a5e6b1ebb6a7f1982e498a347cbd

Best regards,
-- 
Jens Axboe





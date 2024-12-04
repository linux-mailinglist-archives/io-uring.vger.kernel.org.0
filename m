Return-Path: <io-uring+bounces-5208-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1887F9E41E6
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:39:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74A59B2E52F
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 16:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBCED20CCC7;
	Wed,  4 Dec 2024 16:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="e62okoPB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8584A28
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 16:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733330423; cv=none; b=qS7e0UmeQTXIilhHQDyOiZMQ7AKl9P2aDIh59eQyM8trjVKHa7NJZcH/nzmG8iJlaKbvkotX96bsuMsCXOhQ+Ydy6NAwy2uNqqQd+0dS3zwx9wUfVJA4Nx2yrHLFJmPMhjBAAR2VTNuvbQaFCHvMHiMWz0d4nAtQM3oF12DXS00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733330423; c=relaxed/simple;
	bh=/04I5Sh36cVEWH0Dc57OoZdAbdAokopOpW2ylNRnEV4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OZmvssqMn4JVQgJeQsXEO5yoAFC3PqQfdRMLH9hRHh0wNjtCFkW4oFCCVlMTqWAN54fbL2fE+hy/2nxgAJYxi4fAlSIpM0idVrCjcobPxCiAe04zZZ11vD03xKoyMCz30FplvlWcnw/BWTeKJe4pkmUpGoK6ZZC+yH8SUQghRMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=e62okoPB; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-215a0390925so37997995ad.0
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 08:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733330422; x=1733935222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ea41nc8IA/yWz0s00ynnrLVfux7dYksfDzuAH1K99H4=;
        b=e62okoPBN1EZ1e62EceYghK3vwedofJo6Jdpz1L0w695AosDS8l13OWPT8C4yK8aun
         7VVEzLMs53pysJwQOIM440Jj2vsqGCVku0WzJepWBrm5I+GeMcY80KZM2NL8ipDGLah8
         IwamuyP3RBN7H5aRBURiBrQLCDREimvS1cCgxWyHG7wGv8I+FWhw7Ws0i7Qxy9GnIgMk
         /I4PkPWL7Q7V7iK2PkRHTxyZmMLlgAbal1efn42tR3noFAxEEw+X4dPk0iIcShoCvC/m
         j2xSQrGvBSoe2dzIwb69Fx7kdxZXDaxSZ/FU5qUzU0JLainIuYREQ8kZzx7a+TfPPm1R
         q7zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733330422; x=1733935222;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ea41nc8IA/yWz0s00ynnrLVfux7dYksfDzuAH1K99H4=;
        b=HbXg3d6dCrbE0KblGTlRCIoZR0H2dqOwVLi7x04P2Nd2qfRSpLmgpIIskEZ+yRC4tP
         TLUxtekarDv1F+LX77207ahy9VO+tuo9YX1oB29mUDKuTA5IAwGPoW/sHEfgKaFNjhe2
         /kp2Iu7TRigr+d3OiG372Nv7o3Sc3i6bDUxiXjJyuzt4hobKsbH91yrcnKzPjinQZ9K+
         2Sc85eNLKSNUV9UWer25TZQo+8L5EjX/3NhCupV1GTiYeKuK0bv+9ioXJA2PQVq0EI/L
         i+gusNKZIEwgO58gBoK+SwKfKrW6ZPWfWf8PbPOFpz31jFUOUq3vTEbogeY7Xvs5c8EZ
         80Pw==
X-Forwarded-Encrypted: i=1; AJvYcCXmp4dbLYaUg23lqjnB7MmqECqP3yKnq/GLXrq8GFmZ63cYQ2RHn8FLh9ilaRpLlWS39Po/xQlFlA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwqGfl6zPw13g3Or4kRKlz1sSPNE3kk5fJn3CyErNB0CjzSOp9r
	ntp4TeEun0S5JWGh5jBF+KV2UCRQXKlFLCxT/tDBA7ofelwJTwiBrBt/pvoK9uE=
X-Gm-Gg: ASbGncuIh/eXYQPFwc62ONa1Y/re5pwQvi6fBO0y85jl4rIqyMleZx+kTN+NVBnXbT+
	lsTOpHXPMWYY2Y8jzR4/mQjPQPL8wbGrxQkwur+o/H2dTR1+GUG2wbUbrirAgocrY53iADMtQ7o
	nlhiFegWkFk0V9mq4dM9pGzAxA68MoAZF0cDyCK9LIlcrx5BZbFAMZ6diJXD+9q+YHuLnwBWQX3
	XclASqRLPJxu+20AoZGxVzX3SPEyg==
X-Google-Smtp-Source: AGHT+IHvExbzUsZz3phLvXEVX1hQ65i0mcWOe7p/CmHEt2r2LOx5jc+H2no4a9V5TPiVKl76Q80KNQ==
X-Received: by 2002:a17:903:41c6:b0:215:9642:4d7a with SMTP id d9443c01a7336-215bd0ed2efmr111425035ad.0.1733330421907;
        Wed, 04 Dec 2024 08:40:21 -0800 (PST)
Received: from [127.0.0.1] ([2620:10d:c090:600::1:a7a9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2154e1c34a4sm88508675ad.260.2024.12.04.08.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 08:40:21 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 Colin Ian King <colin.i.king@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20241204153923.401674-1-colin.i.king@gmail.com>
References: <20241204153923.401674-1-colin.i.king@gmail.com>
Subject: Re: [PATCH][next] io_uring/kbuf: fix unintentional sign extension
 on shift of reg.bgid
Message-Id: <173333042069.512655.8947541818653406492.b4-ty@kernel.dk>
Date: Wed, 04 Dec 2024 09:40:20 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Wed, 04 Dec 2024 15:39:23 +0000, Colin Ian King wrote:
> Shifting reg.bgid << IORING_OFF_PBUF_SHIFT results in a promotion
> from __u16 to a 32 bit signed integer, this is then sign extended
> to a 64 bit unsigned long on 64 bit architectures. If reg.bgid is
> greater than 0x7fff then this leads to a sign extended result where
> all the upper 32 bits of mmap_offset are set to 1. Fix this by
> casting reg.bgid to the same type as mmap_offset before performing
> the shift.
> 
> [...]

Applied, thanks!

[1/1] io_uring/kbuf: fix unintentional sign extension on shift of reg.bgid
      commit: e54fb80b57e4534ae91e65ea14cc66b9f21b4b7a

Best regards,
-- 
Jens Axboe





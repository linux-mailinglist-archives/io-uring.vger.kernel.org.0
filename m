Return-Path: <io-uring+bounces-4311-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF6059B9433
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 16:18:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E05961C20F3F
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 15:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ADC61C303A;
	Fri,  1 Nov 2024 15:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Gj7UqalH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7711C0DD6
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 15:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730474284; cv=none; b=cSOcJcSYwK0xq6GVM6LtNciSDWR0nzKyxh2Loap9yRQRwZBm8wJ18C3VkDKGrgKGiB9R0lXueWV+c7ClyVxDTPDUXx8qRYdoHUH/V5D65zQy31SFCdNZNgeNhc5FXLhtHKFgegYCTWI6JWjuBx2ws6yb5omuf0ua+ukwphHOL04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730474284; c=relaxed/simple;
	bh=lkf5T6VDGyK+AxefNOE21mzu9AeD2d3DO0OV8fJLP+c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Dsz1ziNRQaEE2Ds7IhfagVnzeD/L7TPw9xnVD2Q4EadAVbnRlJZ1Hi62z8jdQqSJTXhyQAkP9dTwoj7PXkyaTx5p80Gmp//emCKFhs9G8ODiQivwcFrHYw0iouGyFdxsP5yHoYT+PA8PcB5l+oqytbTrRggm9gGe1D7PwQ67Cv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Gj7UqalH; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20cf6eea3c0so18088295ad.0
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 08:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730474282; x=1731079082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z76tNBW7IiSXlnUlkX8YEl3RTDQ10RA/5zOtclJTWHM=;
        b=Gj7UqalHVi11YwDmtH+oQ+hNgPm/7lz26qP76ymyEAyGigHKce/sJ2R0W3M9dI12St
         ga8zfKGhRSwC2w1fRJY3uHhoNLsfJNsB9mwdOftcX1bUq+PH20zxWcxlJ05bZt2YOirV
         61zaDb0m77rJwkkHsSTpx29stgTPK1drgNFLX0/ZmJF3H5sbWZS+Nc3wjRgxzE7LIyOD
         fj4ksTF1XN71YX3ZuJb38Nf14e34bqx+mn5ZgoE62VgeuPrhVqBp5DwPOKyjpvpTlN1w
         xmoYN6heP4UEvSU9cUdyffS6VcE0o5agtGPIitLnyceh7w2BdgIP4/DgjzssbwTokTrd
         MJRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730474282; x=1731079082;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z76tNBW7IiSXlnUlkX8YEl3RTDQ10RA/5zOtclJTWHM=;
        b=Rts8bsSEUB06FjC6EpWDhipZ4gboWAMT7yM6CugYb/jhg9oOjaB3uVMUhc1t4On/4Z
         8bRfxuYLo8Vt3+aK2Vt/iih/wsDB0z6VkvEMnSTg7sawc7IO5gZqIuV3WLXoRXWv1/Jg
         Fdkg+6Gfu3tZJgwEw6QYP3a966MyXWOdyBeSTvI7bjJC/tGrC6ca3ssmvbyOydYN5Mld
         QOtIaYf8oDGNqi69PV+KBQ9iT+lilwvA0TE6kKGChK+FtHsD9IbD/aMA5SQLapaY6fgI
         ECmcHUSdCMc16bM5S69CglmdhAbW9oWj3fLK+YKoXd0a02dUejNcWxTwJ6QSb9fljgSi
         u9NA==
X-Gm-Message-State: AOJu0YwP1BOYAOYQSor+ZiydqYAy/PPZsttQdCcr6JvJQ3W8oVEDUB76
	9N5g8UnzMmX2MOzyilTmjGo03QOmUw9VgHMgfoWDDmKiQ0ILhamklk2YyJ21WB4=
X-Google-Smtp-Source: AGHT+IFeNQdAJMdFu2eVkBAD+wHxFyp+YiN4W9Y8wYMbUNxprY5tnH5CjMhX/v4HkmIVX6xStac7eA==
X-Received: by 2002:a17:903:40cc:b0:20c:b0c7:7f0d with SMTP id d9443c01a7336-210c68db595mr292711025ad.25.1730474281550;
        Fri, 01 Nov 2024 08:18:01 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211057069e7sm22762955ad.95.2024.11.01.08.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2024 08:18:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, hexue <xue01.he@samsung.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20241101091957.564220-1-xue01.he@samsung.com>
References: <CGME20241101092007epcas5p29e0c6a6c7a732642cba600bb1c1faff0@epcas5p2.samsung.com>
 <20241101091957.564220-1-xue01.he@samsung.com>
Subject: Re: [PATCH v9 0/1] io_uring: releasing CPU resources when polling
Message-Id: <173047428059.527059.2484497150578119081.b4-ty@kernel.dk>
Date: Fri, 01 Nov 2024 09:18:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Fri, 01 Nov 2024 17:19:56 +0800, hexue wrote:
> This patch add a new hybrid poll at io_uring level, it also set a signal
> "IORING_SETUP_HYBRID_IOPOLL" to application, aim to provide a interface for
> users to enable hybrid polling.
> 
> Hybrid poll may appropriate for some performance bottlenecks due to CPU
> resource constraints, such as some database applications. In a
> high-concurrency state, not only polling takes up a lot of CPU time, but
> also operations like calculation and processing also need to compete for
> CPU time.
> 
> [...]

Applied, thanks!

[1/1] io_uring: releasing CPU resources when polling
      commit: 71b51c2fb200c502626e433ac7e22bcb8a3ae00c

Best regards,
-- 
Jens Axboe





Return-Path: <io-uring+bounces-882-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC6287719E
	for <lists+io-uring@lfdr.de>; Sat,  9 Mar 2024 15:27:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13A021C20A44
	for <lists+io-uring@lfdr.de>; Sat,  9 Mar 2024 14:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36B043FB9F;
	Sat,  9 Mar 2024 14:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gGqoV5Q4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F214E42044
	for <io-uring@vger.kernel.org>; Sat,  9 Mar 2024 14:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709994449; cv=none; b=eCUDGjUGvKrB8UHhy5P3no3je/91GY3k5qLvvjECeGRigEDMTz3PwUXiDzWRpJG7UroH5ytyqW2YFuocloc1/HNclZKuaBIusfb2zvdTPK3L29FjJe5h5O0+UCxiWtM/bMv+tlFbAuKRRjggQKsz2enIw1e0s1cjwp4IT1KSJM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709994449; c=relaxed/simple;
	bh=7iy5dCKh1UQu04KRBH3DT+f4Y/jzFlMi1Rco06t6uO0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GmLg5wl6QzMaZsbRfnmNLQwb2a/a3+YC0S/nlZdYb6LlGUBg5jWm3KnaPYBFQfmx+23I9WmPzE67Od9N3XPqMehunK4jRXBnWBx7XideHXB3i4+gc4S5FkUJaYbtE2cLwOxI5vwlt6VjUEpoejGWpLg3FOulwkBAofappm3AgJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gGqoV5Q4; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5cdbc42f5efso976426a12.0
        for <io-uring@vger.kernel.org>; Sat, 09 Mar 2024 06:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709994444; x=1710599244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZhbIzlzPkgPjvOrq/WhxvMYLdjNfixuja2xi/kzy9o8=;
        b=gGqoV5Q4dQLtd9IrZW75zweoPB/SduVu8JgaAEFsjHlIEdmjSCNr+ax93FnulPSyF5
         gPKiOr1VwZzkzac6uqlcAzuDbTI/epnPDw031DsiYcoy0bsY+LeTP4iVk6bbIPFMZ4ec
         7VgihNULoHzH4s7vPMmC0fAU1cYkgljON8MmXapuZ0Dukh0bVQa5u5Zh80KaLI52fzO4
         U971uin6vuBT4L9HOkUwLsZKdM+b/bFcT9gclU8XieT95r6oeZ36zF57hmdFSAZYOA3M
         +EGOI4h/0yf5gg/k01HzVp5wWXstCE0XE7/3D8Zi1h/RPVN5fqoCYv7mKVi26BQ4UO9W
         av+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709994444; x=1710599244;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZhbIzlzPkgPjvOrq/WhxvMYLdjNfixuja2xi/kzy9o8=;
        b=H9T/KulZ32H7PQfFSykwiILDqkUYWjk/MmrO4V25GEexgefcOfP/HRT7i9Z034c0te
         oK5LmQRLea00tdER8t/6M9ViYBMbBSCXEiR4Xa++Dh1mq54AuVvDXKYgqGrcBBAe5zZp
         66LwQ3unmYtGeiSGVN2X+/4NDKyQNPuGU4pe4sfhecYYL/vyKUdWKjHwtQFoMrQjewvY
         diznZU3KGvlVwyPlBcFSFXfGc1bKyWEwIp8TS7wJLoDnhlWyHaMWzdlKREnkIUQgl2xE
         m2auTxYWJNKEC4PzRCD5RRcF3GiYbt3pUqIXT7ku4n/Ho+obSzasfMwkkTtM28qSYNTh
         rGDA==
X-Gm-Message-State: AOJu0Yw5y9Oc3rSI92p4cZuqq0OB5lxLV2CqhRj+CHmtem8Ts77bsMxo
	DlK+kA/nPAlUJVmm/GUGbMLFrMVVfJPGEafyy0STxB6SLXoFaIyLQLAJ0LZvs2k=
X-Google-Smtp-Source: AGHT+IGtQ8dM2P0dlMqPchiPbl8aG+gpD1PAOGSgfmEWf/4OQrVMkZXxNZ+5W68QAx3kBCtQxmcYgg==
X-Received: by 2002:a05:6a20:d495:b0:1a1:1a07:b0b3 with SMTP id im21-20020a056a20d49500b001a11a07b0b3mr2312501pzb.5.1709994443942;
        Sat, 09 Mar 2024 06:27:23 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id c13-20020a63350d000000b0059b2316be86sm1287289pga.46.2024.03.09.06.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Mar 2024 06:27:23 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, xiaobing.li@samsung.com
In-Reply-To: <20240309003256.358-1-krisman@suse.de>
References: <20240309003256.358-1-krisman@suse.de>
Subject: Re: [PATCH for-next] io_uring: Fix sqpoll utilization check racing
 with dying sqpoll
Message-Id: <170999444297.1023382.3779633523793018161.b4-ty@kernel.dk>
Date: Sat, 09 Mar 2024 07:27:22 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Fri, 08 Mar 2024 19:32:56 -0500, Gabriel Krisman Bertazi wrote:
> Commit 3fcb9d17206e ("io_uring/sqpoll: statistics of the true
> utilization of sq threads"), currently in Jens for-next branch, peeks at
> io_sq_data->thread to report utilization statistics. But, If
> io_uring_show_fdinfo races with sqpoll terminating, even though we hold
> the ctx lock, sqd->thread might be NULL and we hit the Oops below.
> 
> Note that we could technically just protect the getrusage() call and the
> sq total/work time calculations.  But showing some sq
> information (pid/cpu) and not other information (utilization) is more
> confusing than not reporting anything, IMO.  So let's hide it all if we
> happen to race with a dying sqpoll.
> 
> [...]

Applied, thanks!

[1/1] io_uring: Fix sqpoll utilization check racing with dying sqpoll
      commit: 606559dc4fa36a954a51fbf1c6c0cc320f551fe0

Best regards,
-- 
Jens Axboe





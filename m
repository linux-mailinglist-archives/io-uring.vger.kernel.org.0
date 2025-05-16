Return-Path: <io-uring+bounces-8007-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AD4DABA329
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 20:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A4C73BAD7E
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:50:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 349C427C862;
	Fri, 16 May 2025 18:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FXuzuWUL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9931627A47E
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 18:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747421420; cv=none; b=oWMu05svfg4iKWVTQJ6vcXm06x0AA7T3AzToMU4dtzNzd3V9YC6VZ0oeAmbj8exKG7ThhrseXnAmXJgVQicWG7J6AZr34qaOMadwEmDa6Y79efxW+tjysDMWuIgol8X/GstC1AV4HrGnIocsdomWYoQm9QwhzE+5QaqgHUtKO7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747421420; c=relaxed/simple;
	bh=N//9YMoubIYw0Ap76lN5e9+z1x7/5Fr4VMNeMVJa8gA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=eGAkK1oF2K6/KuH+Nx3Kgyq+Kh4AbR9TrJrvw7E9hoVCo45u+c1oHqLSIDeDgNHn+d4rDHoLyG/32o83MypYU0UP3PsnkF1ivOx80qI4cQzMDWmfujTqVnHxsFKlmOQZMHNwLajJrocfkaq+GTDJYsWyeBiuRcgvaOMhpuZ9wNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FXuzuWUL; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-85e15dc801aso195848439f.2
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 11:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747421414; x=1748026214; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=iqEQ2p27FDhJKwGXnI7veduhqr5UVc9whYftooXd4mw=;
        b=FXuzuWULmESAPmmVrd+5vQOA+4o5ThczpafzMicI5AcU3OFJItVbah8jKsQy1Mvl2J
         qb0izXkx/sy05ZNa1rou0heS/HBOlhep8PYxY+IXYfjRMVxugevtd8om/Gb1TerBviXg
         7gF/BiXahPNWXFGzWRfsGg8dYP0BubOEoaoQli8DZ/mFwU6XdOsOJK9MT3jxR3Yq369H
         zv8drIKXV0WiJqrPsd9LQHarzIBj0W0x9l6wTxuGNqiqXt9pn0tRku+xNdoMVW18f0ui
         Nrl0yS/ZUzGmy7RMdpeKSpdp/Ul+DVO96bEXyGjiIHJmVI64KWIl/DYhTPN9U4nuUIVi
         i8lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747421414; x=1748026214;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iqEQ2p27FDhJKwGXnI7veduhqr5UVc9whYftooXd4mw=;
        b=k8IuUcb1NgkWX29WvVFx57ume6We3cu+tFkEwiFiX2+kPHj4agxSLcOic7zQ+GaqVH
         luKBHN73d9SmC3fLajmUsXtIRXpbBRowuH39z7rpGykJXEkKxu9zLk7Pc4Ex568vQRuR
         klFZ5HxLGy5e+FNEN+b10q3hjkeMrOY66v19yCH4U0U7YskvpfwH03WRaTCfU+WWtU1z
         ZlOn/Ktaxo4UDkBVtqcfa4AZM8dqehfy6K3gfOxYKdHpgALOGq5nXXrdHgA3R4JmKBTr
         Pm6WpRO9ivuKWoa8bm0h86x7iC3QuI+1fjnMDcaQj4uFxmK2j4rA7LAJFFCm/8arovPL
         prlw==
X-Gm-Message-State: AOJu0YyDcWeR3IdqbkiF4xQwftQxQu9M4Tzhk6sjjfNPb9peOZ6Q1xXy
	FZRuEtEckaVhg6IkwG0ZUsrxbDcEfdaz5Uw3WOA8Fbk6pizgihc9mcJXJ5BuxhjgiUrv+obVyAV
	rOdZ6
X-Gm-Gg: ASbGncsfJgbgb3r/xWhN3ddMSTcmY8gxSFO3GYMpqYCVCQ8BnHLPZ7WW+rQZZrJkC46
	0KtyFQcUaNqfvfYLEeV9+YrWv9KDaDXKmhWVdCbFhbrN96Cv5NR23Cb4K/9MjshFEmuQv31Y2OD
	3wirsAnCd1ERwtY5RoN51bqMYlSXRckjzksmK5tZTsc99HKxx51lbvkbOf3wnaZoWI6jx+d+BYe
	byVp+5i5Rq/xKFvsdzKngILC0PKN/7sKSzpHTCSoL8C3mlh5ExmKedyLtV2z/VIycqyAeUgxBVj
	ONbN29YlRwL7SYoud3ZZMTfEJ7uq0azofUpCV466aemwCBlRbW4luqnt
X-Google-Smtp-Source: AGHT+IG/iB+EHmFYicAcmQ/IzzH7S0hFf0YtDXQP+JICiktYeSn1rp5eNdQ7n2P0xPB9XNtzO8GlPQ==
X-Received: by 2002:a92:ca0d:0:b0:3d9:3a09:415e with SMTP id e9e14a558f8ab-3db84331476mr60984085ab.19.1747421413711;
        Fri, 16 May 2025 11:50:13 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3db8443ae8dsm6162115ab.49.2025.05.16.11.50.13
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 11:50:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] io_uring fdinfo cleanups
Date: Fri, 16 May 2025 12:48:45 -0600
Message-ID: <20250516185010.443874-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Just two minor patches in here, cleaning up the fdinfo parts a little
bit:

1) Only compile fdinfo.c if CONFIG_PROC_FS is set, rather than wrap all
   of fdinfo.c in a if/endif section.

2) Get rid of dumping credentials in fdinfo. I'm not at all convinced
   this is either useful or necessary, so get rid of it.

 io_uring/Makefile |  3 ++-
 io_uring/fdinfo.c | 40 ----------------------------------------
 2 files changed, 2 insertions(+), 41 deletions(-)

-- 
Jens Axboe



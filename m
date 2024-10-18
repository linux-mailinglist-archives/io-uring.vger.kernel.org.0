Return-Path: <io-uring+bounces-3826-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA5639A4605
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 20:39:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05AEF1C2101C
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 568B02038BD;
	Fri, 18 Oct 2024 18:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TNpF3XqV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D08D20010F
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 18:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729276794; cv=none; b=d6pR4ytf5TMYS57F/9A12lyQIGkwAuTc08tD5jv9kgGbzOOWsv4h9oP3KV2BcsL934ufmvtBldhnk0LJWLLIlSaoZP8x/s05SvPQ6V7FxC1mDLP0uoyKi9NUG1Mhxlt6mHkq2jiy0Z0gXXrwBJMQuxcrf4OAZVXlMdFCJvQgww0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729276794; c=relaxed/simple;
	bh=RaeEY2o0GiVPsUoG8VOaSDebu2l0aMa6M8tJMWPCPZA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=HL6NuFe997IJnnHgb6Ypc7OwY/EgrgE85IYLlnSFu1O3+U23hX5OBib6tLtvLcGZK1YiRrrTwBa9CPoPPDl0qrUdQ5CgcozDtbcfHH97xv9mRPiK0VSl/lUC2W/JNEZ/RVtD9C/M60Xvw+vxvtENi1bm5y+NrDEBqlQeAsPgTkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TNpF3XqV; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-83aad8586d3so117569639f.1
        for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 11:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729276791; x=1729881591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=hETdI/LIma0+/OLorH47Mwk41E2UT5C0kLcmgkT6otg=;
        b=TNpF3XqVIoWcRqGRZGy5Qv5Oh+fUvM261GkT+XC7zHmRm+rRhQvpq44iMOeaBjFvM8
         oVaXYUL9PC9phtWhcP8nAlr1dPjbFEcHKOud+n2IyQCVpK1njSrl+UDcxlR609O8pfOs
         z9XkVLXi+Zkw8uOyYlLbKEIlTjxcT5UPB/CtSxXh+CsTXQN+FJb85nNPyGze6wnguj0Y
         gomNf4SfS6keMzRbL94k/A3Cvhc12tqFoo/ku2vREW70PdHXmXz3r2qzSLsU1xAKah0e
         /uM0NKYPeXbwlq1bgEJfTULEx62KlNITUaHa+n1YsWTvzj7tIDxog08loTGy0ptdqODX
         D/BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729276791; x=1729881591;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hETdI/LIma0+/OLorH47Mwk41E2UT5C0kLcmgkT6otg=;
        b=VgFo7nVWTqPl5bk6Bq26RSloByhtG9D+4EDLKjwqIX//jC8RwnM2UIboMV5Xu/Uxud
         6d1BuBzTcBCfP0gWPT53lNGyML582RS0BwFmsMfb/RZQYZExeHtqFcaVnlev5RXFfXMf
         lRMjko2r2QIJUC+QVwbXsAEPykV+UQl5ZtH4dZVzKFdgUyRJMbIe777DWTfn28uDEvJX
         lFH3oBHP6/PdkTdbX+2RuQxWYIQWeWVpABsX0N3Tf8ItAxV3CHlQ0HlIcYPyEVkiCEKv
         z8TH0Xd0s9rl1xNVf/oxfBuOKok8TvMYFJVYQtWi4SuW31YusQbm3gmWffgmwC6DCY7p
         JaGQ==
X-Gm-Message-State: AOJu0YzOqWiQ2C3RBCqfMbjetndm0a4uE00C1R2PWRqXdzIrGEIfPHlG
	5BPo0IpylvK/YbyJf3uceNGYY/RUslv0NPOyHa+NeMW1UPOLS8OAL9hBX8uIRtbyGkDx/mqQvya
	O
X-Google-Smtp-Source: AGHT+IEhQFSJmK/cm6ZFEqRfiqX81uP+U+fmgEmdkG43XYM5c/Urj5X+HY57K3ZT/3my8zU6jmcObA==
X-Received: by 2002:a05:6602:628b:b0:83a:b33a:5dff with SMTP id ca18e2360f4ac-83aba65cfa2mr352035839f.14.1729276790996;
        Fri, 18 Oct 2024 11:39:50 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc10c2b424sm534387173.98.2024.10.18.11.39.50
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 11:39:50 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET for-next 0/4] Get rid of io_kiocb->imu
Date: Fri, 18 Oct 2024 12:38:22 -0600
Message-ID: <20241018183948.464779-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

There's really no need to keep this one in the io_kiocb, so get rid
of it.

 include/linux/io_uring_types.h |  3 ---
 io_uring/net.c                 | 29 ++++++++++++++++-------------
 io_uring/rw.c                  |  5 +++--
 io_uring/uring_cmd.c           |  9 +++++----
 4 files changed, 24 insertions(+), 22 deletions(-)

-- 
Jens Axboe



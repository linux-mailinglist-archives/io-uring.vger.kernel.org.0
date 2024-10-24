Return-Path: <io-uring+bounces-3989-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA08D9AED2F
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 19:08:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD7951C20911
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C241DD0D9;
	Thu, 24 Oct 2024 17:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mwQXq0t+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58603167DAC
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 17:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729789719; cv=none; b=IdIdeJ7rjOrMsRHzSXPH/942igUCRHPGWK12qRAmZce6lPArMKqhkjLkauaRVqkFtDdKMpZUQWu/GXTKcUvUNcWGyVxFMaUD7s972CTHlpIe6hlN2oYVEOQeRjDYXEhugcWgEonhMEQyjyWOGQ6zhblqz67dksJGf0UhqZ0stiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729789719; c=relaxed/simple;
	bh=GZSP2Jqmj+cb5A9s36PXgauQuS0PqxgHTtekIrEFWZg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KfdX4rahwxhAJWtNPxlZrK3KkEPuRfOCDCQawA+0SZJVRpmzLGrPqAhtLKn22MOTjTkpJSM2pvoeHM4HXWDrjdk5QoTCuMMLqcw4Dv+6rNMm22Ig0NvTwAmdcAWeihAJoiRbpQv3y65io3f0g3iEfGI9xf+NbautTsgKeOL2pJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mwQXq0t+; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3a3b0247d67so4488695ab.3
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 10:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729789714; x=1730394514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jAFTHjQtWkTk45Itv2lVcGVjShmEQvDpnfV4iMtY4Wc=;
        b=mwQXq0t+mdWpEfv0eguX7nPxIfxKLORRyecRWyIxDClNEUjlCHEVaIQk+2qlKuhwD/
         E4KDGw0KjEdudWHwlRhxn2nfVXyWbgCZC5nkEvTtTcNa8uDXhxu5TM1BN2VsZvryFjME
         jA7wqWAKgF7wBTrIcEqcldBrLUpGucljm/xJlDPIvZDFSSW7UM1tQo0xnAwjthSFl2qJ
         fRKtvpTKEm5kUiCIpo5J9dxzQpVKvr6LNURJQsPMsQv8+XDLMQDIq3I5GisD/njcqqIx
         rlOvSsSs50BOEpT4KiIR5fjDRs7pIqRUf6j/aT5RePraDeptczRpNQuUe/p8fi4X2Rsl
         nXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729789714; x=1730394514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jAFTHjQtWkTk45Itv2lVcGVjShmEQvDpnfV4iMtY4Wc=;
        b=s4J1+SK2gYmDHEKAM1xvRzmRz+6Lv4zhIbUyB0gvGh8ccDNVJPhCiCq2mlwQxe/kE/
         N8GrlfeGFMfY2VrhcLpGIcDkhqndb+82ihfLyfYvV4hqODvSUwOoCR0EUql5oMdwKBWd
         mmQwqvBsLSu6RoQxIq8D3KbukH461uSfFc1vaLFZfSQReSYVY64iiLRKtfVU6Y93NjBh
         XYYLllBIzShVA+Y81g8vpZjtm4MZcMjBgvWDTgKv6fg6726KcGTtL/uCzF/i/hqvXg26
         FFGp9TDNV4QpByS0vWXXL0e7ZGsqBBPf5GigDlVNKZczEhtkCBcepZ461egUCy6i2sAe
         ZjeA==
X-Gm-Message-State: AOJu0YxlhKjhZ40UXhGG+YyvyFn9IJbOvqoA5NDzvp0h2t+rsH9rB+I5
	Q/8ISMzSlw47/K+t/kEtgaqCedReA/elM8ePEsHm1GUKGzN0NC/IYWIt1kayEY9SZcste44m2/a
	c
X-Google-Smtp-Source: AGHT+IGqOkqT0IBFrlYde6N6UJolN+yfJZtri74CnqgR1TEjsindBUGZguYjxytyC7mVNt3Y83dhtg==
X-Received: by 2002:a05:6e02:12cd:b0:3a3:67b1:3080 with SMTP id e9e14a558f8ab-3a4d595c67amr73045415ab.7.1729789713807;
        Thu, 24 Oct 2024 10:08:33 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400b63981sm31368045ab.67.2024.10.24.10.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 10:08:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: jannh@google.com
Subject: [PATCHSET v3 0/4] Add support for ring resizing
Date: Thu, 24 Oct 2024 11:07:35 -0600
Message-ID: <20241024170829.1266002-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Here's v3 of the ring resizing support. For the v1 posting and details,
look here:

https://lore.kernel.org/io-uring/20241022021159.820925-1-axboe@kernel.dk/T/#md3a2f049b0527592cc6d8ea25b46bde9fa8e5c68

 include/uapi/linux/io_uring.h |   3 +
 io_uring/io_uring.c           |  84 +++++++------
 io_uring/io_uring.h           |   6 +
 io_uring/memmap.c             |   4 +
 io_uring/register.c           | 214 ++++++++++++++++++++++++++++++++++
 5 files changed, 273 insertions(+), 38 deletions(-)

Since v2:
- Add patch explicitly checking for valid rings at mmap time. More
  of a documentation patch than anything, doesn't fix any current or
  future issues. But it makes it explicit that they have to be valid.
- Fix an issue with resizing when the sizes were identical, causing
  a cleared io_uring_params to be returned and liburing using that
  to re-mmap the rings. Ensure io_uring_params is filled in before
  getting copied back, even if nothing was done.
- Fix an issue with SQPOLL, it needs to get quiesced before we can
  proceed with the resize.
- Hold the mmap_sem and completion lock across the final part of
  the operation, where state is copied and the rings swapped. This
  prevents concurrent IO from accessing rings that are going away,
  and mmap from seeing any NULL or going-away mappings until the
  swap has been completed.
- Add some more comments.

-- 
Jens Axboe



Return-Path: <io-uring+bounces-7062-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65697A5DEDB
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 15:24:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F3C3189CD06
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 14:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D5A24E01A;
	Wed, 12 Mar 2025 14:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="Q5I2of1G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2EB24635E
	for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 14:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741789445; cv=none; b=Kf1u1BnC+LxR2SH4yCZ5eK1iZ0wUmtg5SmxmhXrbuZ9Oq2c0IEJFqbyI4tiYdRlnXqjJQBpmNpjP4i77ydKbqzjs/pytMa5emCW1c91W1PMDwQ2c0boYiivCxlOTIcSDLB2khE9R3c7vqW8XQSqQIcmI214+DXLxyDzdkeu01GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741789445; c=relaxed/simple;
	bh=b5GNVKf0dUozoYT4vENKJWq/5eyWVDh3jS26Zidli60=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LtoyJ9Jx8aDVWQkiEtHZk/b1yfz+dxidxos6gWxck/l2Db0gcBS/n2nOiX5Y+hX40RdMqBqrQdv9R3g6nypxAkjaczRcyOGlUrcH5mobw8YJn7J/f0Z6Fnam93+WID4+GezZ/6wBeIBU1HoAbBQeRYYH0MtvNSxz84JcQV0dLWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=Q5I2of1G; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-223959039f4so136225155ad.3
        for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 07:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1741789442; x=1742394242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=85OatdnhR8vOMPUDmzQa+fglJ8ydwkYnTnhnCnWHZkY=;
        b=Q5I2of1GLTvXARl7P6XKgGPccFo7U0WQf/BRsVRbU94b53/9EDrWi383hq0fGRcObe
         YFzfhLn6eNdm6/aLctOk71Vof5aDfoyR1DhS47By6o8Lo+n4YphdujNWyA2i1Q0YxxQc
         zgz/KjB7EjNFpIEY4p6QGezHE08hTNRt1X5Hvj2q2SmOYST4HqpVC2u8ncq+ZqqwRDSc
         smNvIkQJ6ZQ55zVTv563pmidhDfaxrPWCs+i1rUx0+Ec+A4s82BYrsyuaOzlNVXA6Gg4
         RNwNuu88nLX2MmHOyIeuerjm4XJhuHJ68XzcKnZDxodrabTtSKtJuipji3xNXqwqyT1h
         W4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741789442; x=1742394242;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=85OatdnhR8vOMPUDmzQa+fglJ8ydwkYnTnhnCnWHZkY=;
        b=cgowETQ07CehBLffnmkmYfxeUWg8e1EOHdRgMzPkIWrou81bX0OiwhEma8TjYe9hjQ
         FwJIov0+IgmI9PEC2K2Ys1D4lJRmboHIiV3f7TwKwZ+c+3wynxdOupUVOBq0esyT0S0y
         KR4KdH24tCbyiiGOZNGv5xGJpSGTFnQPi0U0jPud3dSKl1iKogcZW3eoSyjpFaS6tBOI
         Gq3EuKM8M3aqZsU95cLIZoNf44s6NFpbl/8XcsXlHDosr2WS4xLKqyb2A8ZafSM8XTl1
         zBP0gFs0rXa5eycuuWD+mJd02fbGMstHbwOPmgmJlW1uPEQXjtp538l35PpT13121W/1
         NQog==
X-Forwarded-Encrypted: i=1; AJvYcCXdDp3ho2uoaWkIMADUhGAbuAd6oBIZEGew3BlkMKi1JVx4c9sd+nOzqsGbv4uAJ3yNsUeQ/t8iLQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzBwG02FJ+XWX6ID3w/WFY+A4uV4mLPxrb3hTXBPaAZlAZoUr24
	rTJVJAe3We7D4iPPuPg77C2GJh4ptNGcAADeylsgAbPH4xDoc5lXXiBFtmXqPCQ=
X-Gm-Gg: ASbGncucqfjaJlPgSRIpk6ngAKkQ36ak9pGesK2FVtbrayJGgLFtbdPthbvpSUswoLJ
	fnbPUGJSU5ZflrykyeMlrf6WKJKf3yN37HEGYztpKhK6ZqX6Ka+6HVq9zoc4415K7tZ4Vmx0xRc
	nZS+Z/I/z/4J2JDRrZJii2kWo2U+svB0tPbiVqr0RUwY5g2P8m5V0J/uqJVK7KxKVRoGS7y0hFz
	rgDXc9ZnWKnJj3mS6VRg66+Y3gR1jvGQUm+zSYsOgKiM0heYXQcoHEp3VU19qpz20WundUQUeop
	4vaBHwlGhoYMiX94/VCL2i55Rj2twQFEty5B762Et2BqObHLHLMZtbGjDhwR2QH08xkgA1A/k+1
	HfKfl
X-Google-Smtp-Source: AGHT+IE5Kw99rmsO+aGISXKk7+NkabJNBq8xp8xHITBkdCvmzgnas/3E8b+v2s7QvMJWwmkI1EknQQ==
X-Received: by 2002:a05:6a00:928b:b0:730:75b1:7219 with SMTP id d2e1a72fcca58-736aaa22109mr32117339b3a.12.1741789442019;
        Wed, 12 Mar 2025 07:24:02 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736cc972eabsm7413860b3a.144.2025.03.12.07.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 07:24:01 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [RFC PATCH v2 0/2] introduce io_uring_cmd_import_fixed_vec
Date: Wed, 12 Mar 2025 14:23:24 +0000
Message-ID: <20250312142326.11660-1-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patche series introduce io_uring_cmd_import_vec. With this function,
Multiple fixed buffer could be used in uring cmd. It's vectored version
for io_uring_cmd_import_fixed(). Also this patch series includes a usage
for new api for encoded read in btrfs by using uring cmd.

Sorry for mis-sending noisy mails.

v2:
 - don't export iou_vc, use bvec for btrfs
 - use io_is_compat for checking compat
 - reduce allocation/free for import fixed vec
 
Sidong Yang (2):
  io_uring: cmd: introduce io_uring_cmd_import_fixed_vec
  btrfs: ioctl: use registered buffer for IORING_URING_CMD_FIXED

 fs/btrfs/ioctl.c             | 27 ++++++++++++++++++++++-----
 include/linux/io_uring/cmd.h | 14 ++++++++++++++
 io_uring/uring_cmd.c         | 31 +++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 5 deletions(-)

--
2.43.0



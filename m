Return-Path: <io-uring+bounces-4103-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 548F99B4DB2
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:23:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18B1F285A18
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1489C1946C3;
	Tue, 29 Oct 2024 15:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BZBOyQgA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D913193434
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215387; cv=none; b=lRlYzU5hx3fZy7ivd+PL8uCqUWsdyYm1rmp3g4S0o+kydX8/Okrh7cvsowsr+zd3UiLOQ00i4TQlLVHS2u+sybyvBQoSNixERObB8jpXBkJBh6Av666skxb3x2avRuxm3VvP37Y/c/JpjUsoi0yQ/CPQAtljbDkSRIqC0Mlwxas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215387; c=relaxed/simple;
	bh=LGB1jwOkWzOmySsoi9ZNAKmLRKn31ZuMQPEcE5e8TNI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=CIp8cgM78PPnn8/hLxB3i8Wva479XpGpY9tcZw8lg7VzaNmrw0YNsSHedmMDF0YrEMP2CvAbjD23viChJar4PfwybDUaakrBmTB+ejU3XnU34V7gzsna6xQ9OqnQzL4JFIL6PTprzoCP3tJSCRMHbxhwjNxJURjd5WJUDLvHkTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BZBOyQgA; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-83aff992087so215022039f.3
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730215383; x=1730820183; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=6M5GDH/jsGVhLPGlxQAyAhQdyI+Ud7fSD9w0OYww790=;
        b=BZBOyQgA+B9aZOej6LKWVVJdGrL+yqKT+MXhLXPQ5nmHH+VqW6hdNOxU6cZ4Iu+LN3
         3oI064Z/sgyWYGEOC9txL6KjxPIHIQ+Wj/9pFB79t2A+29LZtkPAF73pBWk759BywkdE
         xN5QAlmYdSCk5hEwQRmMPngIV7m/KOrJUQLsEbcxhMxA0gz9xoRyE55Pjg0vll8OWj3t
         SZZioaZFC3bkcEvxESUESpvjlRZz1TWuVAUZXr1Y8ctZmiZlvUdW8ZmUVhKp0iiQVCaM
         Rws9GTDQfXhcxvjBT4sBGez8BBPAx/12H1KgKGnZjOQ1B/Dfjfcfp0vruqCPwVwzMAzT
         pMGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730215383; x=1730820183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6M5GDH/jsGVhLPGlxQAyAhQdyI+Ud7fSD9w0OYww790=;
        b=hSJFTFOdFmZRlv68Tc1+bwylIiJVIoGWuClhdmMcDCTqTN2R/JZzqFkDXCEphxzAjv
         yRuugpahEeXae4FF6vztKA6drtz7J+ud0ZR31PAsC0fOshhNYygpWGwiWTbCzuEebt0K
         U3zZ7pNRx9Hoyv2N60lvewr9JpLjLQgXbHeVXmyFUZyXINr98OOEAr9lJWE6CAxmWFgu
         r1zG+bONdByDLeOVIon6X8pdQ6sG7tbd9s4pD/Rgy7JB/qL1sWFVY76fo1SB2jNKG1yW
         v+EQWPTW4WxGNPfmcXU5qwyuxs8rrUWYdb3lVGOBvMS0IK3w4rGzwbxijlyobbZWyKin
         9Ayg==
X-Gm-Message-State: AOJu0YyoEvKZaXl1VwWY48fGaqUzTkW8uiDytLDDotb0QB3aZnDz8wwh
	+L3PWQ72iQzMpDjCaEip6cozpCXZ5qK/cGLAN/91qJlvesQPMmQCIFMO09QHT8XPs95DO6uhKst
	q
X-Google-Smtp-Source: AGHT+IH02g4UeKJ/n1QYWEdbDE2i+FGWlmzyyU31Wc6vJGnb21lp9HBuRs/TZ8Lnk4/YAIwWzWx7HA==
X-Received: by 2002:a05:6602:2dca:b0:835:3a11:7946 with SMTP id ca18e2360f4ac-83b1c3e6eb7mr1244454939f.4.1730215382591;
        Tue, 29 Oct 2024 08:23:02 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb58esm2434160173.27.2024.10.29.08.23.01
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 08:23:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v3 0/14] Rewrite rsrc node handling
Date: Tue, 29 Oct 2024 09:16:29 -0600
Message-ID: <20241029152249.667290-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Here's v3 of this patchset, it's looking pretty clean by now. For the
v2 posting, please look here:

https://lore.kernel.org/io-uring/20241028150437.387667-1-axboe@kernel.dk/T/#ma92ca3d24796b56414c68e49213bf6455002eb06

This series can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-rsrc

with previous versions in .1, and .2 postfixes of that branch.

Changes since v2:
- Don't pass in pointer to index to io_rsrc_node_lookup()
- Add io_reset_rsrc_node() helper, which cleans up some of the "lookup
  old node, if it exists, and put it" logic in various spots.
- Get rid of 'rsrc' member in buf/file union, clear the right pointer
  when the specific resource is put
- Drop unused IORING_RSRC_INVALID type
- Drop unused 'index' argument for io_rsrc_node_alloc()
- Use rsrc_empty_node consistently
- Rebase on current for-6.13 + 6.12 fixes

 include/linux/io_uring_types.h |  25 +-
 include/uapi/linux/io_uring.h  |   3 +
 io_uring/cancel.c              |   8 +-
 io_uring/fdinfo.c              |  14 +-
 io_uring/filetable.c           |  66 ++--
 io_uring/filetable.h           |  31 +-
 io_uring/io_uring.c            |  51 +--
 io_uring/msg_ring.c            |  31 +-
 io_uring/net.c                 |  15 +-
 io_uring/nop.c                 |  47 ++-
 io_uring/notif.c               |   3 +-
 io_uring/opdef.c               |   2 +
 io_uring/register.c            |   3 +-
 io_uring/rsrc.c                | 578 +++++++++++----------------------
 io_uring/rsrc.h                |  98 +++---
 io_uring/rw.c                  |  12 +-
 io_uring/splice.c              |  42 ++-
 io_uring/splice.h              |   1 +
 io_uring/uring_cmd.c           |  19 +-
 19 files changed, 414 insertions(+), 635 deletions(-)

-- 
Jens Axboe



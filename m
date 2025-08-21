Return-Path: <io-uring+bounces-9135-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF8C4B2EB14
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F24BA24861
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 02:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B67012D8DB9;
	Thu, 21 Aug 2025 02:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mzzcPk3L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0FE194124
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 02:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755742113; cv=none; b=rirquX0E1kJ9YXbxa+pSxrkHgoSVnQwWNKd85c3VEbs45kndkUSCse/VjUO+PHQr2H7DfKkhi/A3ZkkPGgO4S215ChZnnjssCcQadYajPWuydJD6SyvJevrDk0IL9RCMixfM8RRJTb+EVArAoTmQRMXokwE3OpSQ8U2LCJskt8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755742113; c=relaxed/simple;
	bh=1jvBkpcvQ9LHRviFzo/mtU7Ig8JHppdWPHWQIJme6co=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ReGI+rw8Hdc6zJBgbHn9jfep6N0ORzPCdg07ESE43ofK+/WrIvA2hPoNH4sICCr9v1P/QI+2bKVay+Ik4rej1KacC+g7RvKlUnUvsyjloomETfCQxCMB8vzCNRloGht2WuyyDD/hDwaoHFuDxcvbyPxUs6kqj3NoF+fW2JY+Yik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mzzcPk3L; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-324e6daaa39so493371a91.0
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755742108; x=1756346908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=jeWZOcbQ7LJMC9K3nsHEVfvwuWASpnnTA47Xpnny9Co=;
        b=mzzcPk3LPTyAt6+Gnd3h1P4L6ydbp51CAIukXbLlJNrtfW+m60h4aEDiB5w99yIM/K
         BXBKhDzjEavNPa1uMjDLisADUdHZT89q3OdrMF/A2Qqr9GAGaMHeAp+moBIETQXnDJCU
         2dTaEp0kiaM39oou62V6vuCJpFumDGtReQmrv33CVrtelktZocPH/wlFo9dpdjezSesI
         9A2zLQCfQifsFdF6YmxzYfKGb9vcssWPxlvf3Ti7JFLG/Bo3m1KUArf+gpabMlVRiKoH
         i0wKna5t00xPWAriuPunjiS9FBlcj5UoGY3UAAgsQh24Ubo4jGIJarV2UKD0fPH24ANu
         rVvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755742108; x=1756346908;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jeWZOcbQ7LJMC9K3nsHEVfvwuWASpnnTA47Xpnny9Co=;
        b=HofPakd8H/epSwNqq5Jo5B3vxdh46+uzLx0ZJes3QV1PJeXC9pFQC1H7HahdIy9v3G
         TovMBtkUiYO2RI5pgZsPLGtL8BvIIeITJEFJLTFOoLFrz2UyOF27IglADQYzlBZ4kYSf
         KJ+0EpEUpKiYrr93ZxOzyXNpZuvvOCqrCIu4rxgMf542fZjoWupHbEvE42VA7Kh+LJv/
         PtQRyCsfPmB1Cyr1q+70OLQyGcz+Xq33AXg5MJdPNeq+MfAOyNqFrWOoEDR9Bhj87ZRr
         mAEO2C70nRb6vKYzmGnO1HwvKdJ/w5M8k/E8PbfdxsICAqUuB/cuLEPUR42+iB4Pp4pC
         yUyg==
X-Gm-Message-State: AOJu0YwodKXuuRJfAMNfT5vnxItUdhnTmNwwglh7Phs+Q3jdIIsQ6r8J
	k1cuIphgdTpxNCEYT1iCdhXNL2MNO8MqyODWDFkUxaGN0iyGgFVQLcolDFxCvldWwQOXxbftWdt
	UxizM
X-Gm-Gg: ASbGncue9j9ySo5ai7qMS7nbI/KtspcQVRCxaN7QQ7CAMtZ0fALpTSGEvGFtse6V+tv
	Mh5P+dpi2K8PJmXvDUjgYzNjKYfw3i0K/5UP5ztqho0eKAuFPmFK/miFmNku10rA2gGlO2rPbMD
	N03L0uSJApnDIdJioFNwo6d1Yh+GEo/EzCU18xUg4ViWToJlj3q8W0RUrX1fYekV/0JYGF/bSUA
	hEo1G/xpxlNqzCpHbxXAA2wjznfbp911Q77+7vkGnzh1tIRJkatCZQhULg0wshceF2XXOv/tfp6
	8Eoxj5H+d0fkNH0OhORMggs7b3RnuYHnqJin6r3TELsJDrYZ0FtCwBQzJRYmGw1qHgnVX4426a5
	fWR7xkS4=
X-Google-Smtp-Source: AGHT+IG/UHAlCc2dvVeqN3eoJBu4YdSxkQDmAvdFnsNeiXT/3YSNnDVGoVH7Iza70LBcqUGyH/guLg==
X-Received: by 2002:a17:90b:4c4d:b0:321:2b89:957c with SMTP id 98e67ed59e1d1-324ed13c975mr1133099a91.27.1755742107739;
        Wed, 20 Aug 2025 19:08:27 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324f381812asm104827a91.0.2025.08.20.19.08.26
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 19:08:27 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/12] Move io_buffer_list out of struct io_kiocb
Date: Wed, 20 Aug 2025 20:03:29 -0600
Message-ID: <20250821020750.598432-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

One thing that has annoyed me is that struct io_buffer_list is inside
struct io_kiocb, as they have potentially drastically different
lifetimes. This makes it easy to screw up, even if you think you know
what you are doing, as you need to understand the intricacies of
provided buffer ring lifetimes.

This patchset adds a struct io_br_sel, which is used for buffer
selection, and which also then stores the io_buffer_list whenever it
is safe to do so. io_br_sel resides on the stack of the user, and
hence cannot leak outside of that scope.

With this, we can also cleanup some of the random recycle points we
have in the code base in general.

Should not have any functional changes, unless I screwed up of course.
Passes full liburing tests as well.

Can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-buf-list

 include/linux/io_uring_types.h |   6 --
 io_uring/io_uring.c            |   4 +-
 io_uring/kbuf.c                |  67 ++++++++-------
 io_uring/kbuf.h                |  57 +++++++-----
 io_uring/net.c                 | 153 ++++++++++++++++-----------------
 io_uring/poll.c                |   4 -
 io_uring/rw.c                  |  56 ++++++------
 7 files changed, 177 insertions(+), 170 deletions(-)

Since v1:
- Drop 'issue_flags' from both io_put_kbuf() and io_put_kbufs(),
  unused in both.
- Add patch folding 'ret' in io_send_finish() with io_br_sel, just
  like was previously done on the receive side.
- Add patch checking for REQ_F_BUFFER_RING first in recycling.
- Rebase on current for-6.18/io_uring branch.

-- 
Jens Axboe



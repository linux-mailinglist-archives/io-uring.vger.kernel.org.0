Return-Path: <io-uring+bounces-6905-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB1E9A4C5A4
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 16:50:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F28EE16918C
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 15:50:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 878B22147FD;
	Mon,  3 Mar 2025 15:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IBKSbY4y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAC321481D
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 15:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741017004; cv=none; b=s5y/c5Hud4OL/Vfi1iVceCgU/Bd+eZGmKsorVTXR75J4d4CnacYc9cQpRUxcJLE2/rmx+daUeCYb+9oQNfZP1EYtDiNhMdEXSty+AYBRzIVth7BR2cZ41lT8ONO1i6Jhvf15K7iFDbcHq325Om96vOThTGhOOcqwE+5QS42AG1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741017004; c=relaxed/simple;
	bh=5enHuutKAuvKaSzRDeRyhLSLaypVrchgTLPFC1lSC1I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YzfH/Iy/voXcenkn7cg/zng2rmLievDWHIorF1hN+PBzBun6ZxA1sf14t9j+LRqUU4LnvOoq8fXhdpFCNnCDIzFVy/tM07dcVkzKFAsaScf6lun2ezuF9nn1/HkcQsJRkImxVfRxnz1BOrCjtn7tjeCWmzsqPhDPi8oNRFIozYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IBKSbY4y; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e52c1c3599so2842453a12.2
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 07:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741017001; x=1741621801; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HN2BY1F4G5bgv2RPZmUsY73K56BCDvvrbagTGh6vfqw=;
        b=IBKSbY4yUig4gxUYCEgjbvsk74tkt1GcnRsc4AoSkYsWmSf+FRzS4yUKsobgnKL+nd
         fRwt6Z4e14lDjni/Stlhsgp+Ete77P1dTL2YRJVLaeGmvyex8L+lEV026eP7aolP3Uq4
         HMGgqbJVfit+1SNHQTZMokAHXThGhmDWm+wbMAtHdpS7kjmNGTkptKyoFu1OTRJsSRD2
         BBpoYJ8qZASS6OnOd1Qh8fQKZmleHpBR2epokk5b+uBq+GRaweQdKO2Bs2yLZIM/RvO9
         MUsv8bXPebHBEspxtseqTMe6gdTsYv3a4yoPGuR5PW32UArT3aI3bnwlYYB8O2rXcLwF
         JcgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741017001; x=1741621801;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HN2BY1F4G5bgv2RPZmUsY73K56BCDvvrbagTGh6vfqw=;
        b=X1fhCYTjkrVbcv9iDYTA6b+StYQpD5FwSCoopjxIfrwQ3j9xg/TNU86q7HsiI+MOvi
         werEmtoNALJE9KyLbOCO8xJxP7D/+m/wXSh89NO9RhgFMunOEmry9mh4lfkcg6YQw89i
         vVze56xLUVy256641VBaftVBX6WaEjnTkJNKD4wMWdxxVKDn8KpnwpZR87CnCGLpm2au
         qbF9KL865ZX24hwJIOfO1+a7O5Lhp48hk5IqLCssKWviVrkDPiuPHNDi0280qr3yB6X0
         c0Ujep9i623T6MaBZ9noNUG7rw1LO6nR90rLT7uHvNcWU4h8h6gmaL3QxlcMHKO8be7V
         b71g==
X-Gm-Message-State: AOJu0YzEb9rUQ8Kc/+GTzu8Juh9L2ele1L+zuYcV+7Tx7ijO4MPEWH4f
	iRNCXHAE1x2yJaXxC39m12Faih0jvr3YDSDUZOjxcOfwTd0HX7Kx/pBecQ==
X-Gm-Gg: ASbGncu+WBg8Z+vW3bEzLnRE2Su+Nw37IEBEUQFcSkemOY3P4If8IWY6cuIPllf5dJc
	uO+94gEt+kloNmclXh7fkD5qpimayAyqrlhSJaw+urs6vPfN+YrC2KLiPWbGxcIsM5yAaaJz8ns
	vItFdsJCjRjI3RgHMxfBVgNS4SqpnTVSM/cuwrBKkOiS8IbpQHbnYX+zT8c4+4X5h5QSN1JMsBi
	m3cXrhkOsOoJw5Kc3wSSmg+HRXguJpuyJD2gaMNvYC9EoyJnIEPAnBiceJVUAA1TqxJ4xJRhYLs
	rc9jNMhta6hveUpTxziC+rQTmXrI
X-Google-Smtp-Source: AGHT+IGEH2g8R7hn7Mu5JlIjpdKY6fPx+Fkjp6zuMJgsq5As0pvtUYcG3InElou4RxplYs9jJOaw2g==
X-Received: by 2002:a17:907:3ea1:b0:ac1:de32:dd82 with SMTP id a640c23a62f3a-ac1de32e123mr288043566b.53.1741017000418;
        Mon, 03 Mar 2025 07:50:00 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:299a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf4e50c80esm492335266b.61.2025.03.03.07.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 07:49:59 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH 0/8] Add support for vectored registered buffers
Date: Mon,  3 Mar 2025 15:50:55 +0000
Message-ID: <cover.1741014186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add registered buffer support for vectored io_uring operations. That
allows to pass an iovec, all entries of which must belong to and
point into the same registered buffer specified by sqe->buf_index.

The series covers zerocopy sendmsg and reads / writes. Reads and
writes are implemented as new opcodes, while zerocopy sendmsg
reuses IORING_RECVSEND_FIXED_BUF for the api.

Results are aligned to what one would expect from registered buffers:

t/io_uring + nullblk, single segment 16K:
  34 -> 46 GiB/s
examples/send-zerocopy.c default send size (64KB):
  82558 -> 123855 MB/s

The series is placed on top of 6.15 + zcrx.

Some tests:
https://github.com/isilence/liburing.git regbuf-import

Pavel Begunkov (8):
  io_uring: introduce struct iou_vec
  io_uring: add infra for importing vectored reg buffers
  io_uring/rw: implement vectored registered rw
  io_uring/rw: defer reg buf vec import
  io_uring/net: combine msghdr copy
  io_uring/net: pull vec alloc out of msghdr import
  io_uring/net: convert to struct iou_vec
  io_uring/net: implement vectored reg bufs for zctx

 include/linux/io_uring_types.h |  11 ++
 include/uapi/linux/io_uring.h  |   2 +
 io_uring/alloc_cache.h         |   9 --
 io_uring/net.c                 | 177 ++++++++++++++++++++-------------
 io_uring/net.h                 |   6 +-
 io_uring/opdef.c               |  39 ++++++++
 io_uring/rsrc.c                | 133 +++++++++++++++++++++++++
 io_uring/rsrc.h                |  22 ++++
 io_uring/rw.c                  |  96 ++++++++++++++++--
 io_uring/rw.h                  |   8 +-
 10 files changed, 411 insertions(+), 92 deletions(-)

-- 
2.48.1



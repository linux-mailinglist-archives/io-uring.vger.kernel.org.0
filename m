Return-Path: <io-uring+bounces-6934-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79761A4E577
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 17:19:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE7A188754B
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 15:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF492BF3F1;
	Tue,  4 Mar 2025 15:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H5mT+gbs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FED2BF3E7
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 15:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741102775; cv=none; b=kobaHXdgzUMS7G/HKdxEvloiE3I22AiNQ00dzEwExnbfLldSWR/q8+Kr6ysrun3+Qgk17mXwpf72v5E0Yqqhn5UXNH+s4q6Ldp8grvH772820iskQj+lAierRjUO1F/avAvuZLq0SEa6YQ21os907B1gZY7++g407Q7SgULciSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741102775; c=relaxed/simple;
	bh=Pp1PAO2Y8SwZIjdJKW1tBodLgBIqBPbl2mOjZO7kVtE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hwAAfD6rfw5IKt7GczIxn03NeSPHT0fYfEtyjov9DQY4j7IIn2tgBBLZqXtJcQtmSSZDnwCooatllK3VbTZ7x1puYduTP8fUtRuK8mfY2FzX8MmFETdn4DMCnCd9kzY5b0oUjXqkVkiYgyPOcbLSoAUARWxoJ9aZenPanzIHu9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H5mT+gbs; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e4cbade42aso8763748a12.1
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 07:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741102771; x=1741707571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sLSEs+5Zj6Ap+cMQAkDec6FLj0eKS1tYEqeGUIaFdGw=;
        b=H5mT+gbszq85TqCkbvY4rAq249Zx/a8XMqYoV/CuftOVt6tAUbGCOdHtz1VpnlZxti
         WVrYAk8S9tZ8AhHa7bGN44+Fl373WPR8A6XPOSFWfBVBJUHEMKm5PzwZU8S3xqWlG9UD
         Ddz/uXp7iWRM4vorqS21GFdZT2fzNEAWTcz/k9fofoHI5tAYnPA8is9p7xNZZzyGK7gn
         5MvTokvuT+IAr01clIFWih04Vu+MxEQm9dFCQH2bCLxJeQ63ZTQh+Gavp1T+nrk5XYA4
         V1WSNHyCMedX77TVVS9HIZWRnMFsxSZvROd750B7yRqjGVRTjRc10jprnJ785jclj9ns
         0f9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741102771; x=1741707571;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sLSEs+5Zj6Ap+cMQAkDec6FLj0eKS1tYEqeGUIaFdGw=;
        b=Z2RXvU2wZPfZFf4+f4ax5BYqwoUTFKsJ6ULauQG6SeW/ezYeKaNBufsbJZ0RcJxRjn
         VVT236VjFIlrgFCiOtGAnMSDzotup4vr737o0e6/KHYBIYXrCZSkCCJWbggJToXvZbsh
         ViS81FUNxJD3JoQi9bdV+943fhUHVCBXSECC28bUz3YU6ro3eq57sY6F1aXwkKBfp6Am
         uemRhkI2f7Dr3r9inRv4mVEMGPzTYnKfZPbnxVNvVzJZoTmRLmStQv8sIHOslOhaRwcj
         j8pOhzpo/VN+c0WTJHNsoHteEuZoccOL9m2SIZcSpNfa/+tp/GvRpTB5IbNIgPgWKK0S
         ciVQ==
X-Gm-Message-State: AOJu0Yx9c380gC5bWGRa1ZJSDTFMA4qMPWIxaKdxNoX0bKhrDvg6m4Jz
	fQFzaTzVu1Lmh7ppGPuKxyqoIx2l0Ms85ADC/N0KehFUiHLA50iAiXKjYA==
X-Gm-Gg: ASbGncuRAFCXx+gOFNIr3ZfMYhGcIOVgKJeYuLA/jiiyMHYRcvuXyO7JZ8Qzf8dv7tf
	fL6u+DRljyHVMwD4E18yiaXWDfHCMba3CuuG9YbhdFFiy4ZxYfPJru3B8wtb2C/kC8TJQmIX/yN
	6yVHYUZs7E6y8Bw2aH2xRcm0jFrxFDLNOkI1+u2CSnLNWe57bmKUN04KfSZ1z3ZEcGn8i3bwqKl
	0oTF7OVkfoLswLZtwHuYWj/OMYOj0HGtJtQie4RvIbKtmQn+S3aCCUJogUiT4S8E5IeSqsVPgbQ
	GS5gXEWSArD8wYm+JSeKxpX7di9Z
X-Google-Smtp-Source: AGHT+IFiJP6gwiXS9JZy6YRz5biun2OIWlI9lL11yA9V1HYTeBZTOmWc08sZEc0iK1S7pf9Zjpc2SQ==
X-Received: by 2002:a17:907:1c8e:b0:abf:6a8d:76b8 with SMTP id a640c23a62f3a-ac1f0ef6981mr388470966b.11.1741102771470;
        Tue, 04 Mar 2025 07:39:31 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:3bd7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1ecafa17fsm168420966b.162.2025.03.04.07.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 07:39:30 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH v2 0/9] Add support for vectored registered buffers
Date: Tue,  4 Mar 2025 15:40:21 +0000
Message-ID: <cover.1741102644.git.asml.silence@gmail.com>
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

liburing + tests:
https://github.com/isilence/liburing.git regbuf-import

v2:
    Nowarn alloc
    Cap bvec caching
    Check length overflow
    Reject 0 len segments
    Other minor changes

Pavel Begunkov (9):
  io_uring: introduce struct iou_vec
  io_uring: add infra for importing vectored reg buffers
  io_uring/rw: implement vectored registered rw
  io_uring/rw: defer reg buf vec import
  io_uring/net: combine msghdr copy
  io_uring/net: pull vec alloc out of msghdr import
  io_uring/net: convert to struct iou_vec
  io_uring/net: implement vectored reg bufs for zctx
  io_uring: cap cached iovec/bvec size

 include/linux/io_uring_types.h |  11 ++
 include/uapi/linux/io_uring.h  |   2 +
 io_uring/alloc_cache.h         |   9 --
 io_uring/net.c                 | 180 +++++++++++++++++++++------------
 io_uring/net.h                 |   6 +-
 io_uring/opdef.c               |  39 +++++++
 io_uring/rsrc.c                | 131 ++++++++++++++++++++++++
 io_uring/rsrc.h                |  24 +++++
 io_uring/rw.c                  |  99 ++++++++++++++++--
 io_uring/rw.h                  |   6 +-
 10 files changed, 415 insertions(+), 92 deletions(-)

-- 
2.48.1



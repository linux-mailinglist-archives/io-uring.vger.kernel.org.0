Return-Path: <io-uring+bounces-7572-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D74A94753
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 11:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE698188D913
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 09:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A835F2A1C9;
	Sun, 20 Apr 2025 09:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gf3zU8JM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB49013C3F2
	for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 09:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745141419; cv=none; b=is1W+/s9/8ruvY9FuriQv+WpfSp5IP4yk1SlaPQBwwAunSjFAHZ8ND3H//GdwvvdAOVF4I0Gr6xHoZZsu9FxA86VNWFz4mTlk5DByCdGSLC8JnEhuY2dZClLSXlX0XLW2HNI6zpxgBUNdrSON9XKbbPOEoCoN/ieROxbm3fiOuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745141419; c=relaxed/simple;
	bh=s9Dlr/vatWcvsPy7fWTsa9pyPimWhaanL/LaAdmY/QM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OtBn5IkOIV8LiYIHEIqFG+yxyEBKhRTV3VgXSOCTO8dTgyrWW0/dUmO8HiYX8JM2GRJvytk/IbY5vksoiLwAKqJKAxXjfDWJPej/OTlM3FrCpbCsbZAkTa26rulpCBpc9+i+lEBdwpPEIJXUf49/WdwzG7M40jhWCWc7qp7nDQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gf3zU8JM; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-39ee5a5bb66so2103573f8f.3
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 02:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745141415; x=1745746215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zS4N2gIXv6i6irs36ZRFUD2b6Pc3yZMu674vVGglZRM=;
        b=gf3zU8JMBmaD+bQhGoyftUp+whSvRGa6E7JsE/VUf/2CbUWNLbRcQ3OXjZno5XP93N
         sNEW39ZNDU3nVv54OV2Hjb+o7kP9LdtpdnZLT6Uwep2enK5iK554fmciyCi7P5rGFS1Z
         ToU2xW/aFADO7JumnrJ50E2Wlo0DTDl/RlFAk7b3qOpQCg9sJEzzpsHHqg1AqWnyiE5o
         C1iIto4awCiDJJ9N9z2XJR3xTeZdtlzO6j/cMI1Asr8HfCFR+Q5Mvevw9eOyZwSvDGx8
         L46C7Mk3mziWHXRePjwtUYM9v26LMFlNZC+qYrifvvyz9/eqEB1ImxP3/q2hZJos6Lwz
         Bexg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745141415; x=1745746215;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zS4N2gIXv6i6irs36ZRFUD2b6Pc3yZMu674vVGglZRM=;
        b=m9xOpN+t2EdoRkitdd8Nvchtu81FyYWVLbLAcKviiiJBc6JfmHOrBQJ+eINVgHo6aR
         Pd3Q+lBefEPKsVsgSxRwbf78JdOPygU7VzeZWDN+s8rMEVw24iN+Lqsrb9eccSECKgiy
         TxfSQRknUVy3yjLvPtYmh0iwGrtuDfPsC1/y88f3LAjLWE2xE6Clkbrj1XiaFjsDipB5
         MTUrgVnsU5/Z6rCdssHARX7vxEv/Q41sYw1GcrXF0FYJxSzGjJJq6QNrOcM6vVtzP/5c
         Kgk3Bi2/Kd5QSJtoeUnKA4Svu2cGedM4exc+igPCvEX5ZePyVnPJQmuYaGz3wtYRqfZi
         ELSA==
X-Gm-Message-State: AOJu0YzA1itCniAOU9UsrXEZoBwFBwCRcz0oxWajd1osLFN79iIS7tE4
	MUnnLUvTY5dPS4owBEa92V6bicDiBDxNAw14J9WekB3Qz9PUG2l5QhTkJg==
X-Gm-Gg: ASbGncu4eTfrHGNg3CZAgiaZx7xOHF7GkIc3dtJyIQImnVmoNl6puB1ebmkhlAfsPCO
	SKzfHhjfTY7wFGSdqxJKSOVu2C6jtWOPgsTlodDq9qKaEB5KkeNnD5UvJPWXZtOQzYqcFY01GaZ
	LpbGTXy7XcZlWk4q89W+Nxd4k8HI2fjPBymEPhHdsN40gbG41pH7O4sO29bmX67+Re5MDpQk/sU
	RQGHxqG6Xp068u/G5l04EBD82h0VrQsRQdrrwVec655DQeKq3cx4u8mXIn/hWND6IhbeDhhKuXf
	RY3CMmv2o0SSmxXlqfu+EwBAo8P1MzZJKNtH3jnLcTtqZc/qGBMrwBxvArKTU9W7
X-Google-Smtp-Source: AGHT+IHJntysslEfTa+R5JCxwpSmi61P22SSjLfztldUTMlYffzuKro9aNhpshb4FO0xvJ7KrhETrA==
X-Received: by 2002:a05:6000:400e:b0:39e:cbf3:2660 with SMTP id ffacd0b85a97d-39efba26294mr6165432f8f.3.1745141414580;
        Sun, 20 Apr 2025 02:30:14 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5ccd43sm91188675e9.26.2025.04.20.02.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Apr 2025 02:30:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH v2 0/6] add support for multiple ifqs per io_uring
Date: Sun, 20 Apr 2025 10:31:14 +0100
Message-ID: <cover.1745141261.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Note: depends on patches queued for 6.15-rcN.

Patches 3-5 allow to register multiple ifqs within a single io_uring
instance. That should be useful for setups with multiple interfaces.

Patch 1 and 2 and not related but I just bundled them together.

v2: fix returning the user an incorrect offset for mmap
    add IORING_OFF_ZCRX_SHIFT
    split Patch 3 out of Patch 6

Pavel Begunkov (6):
  io_uring/zcrx: remove duplicated freelist init
  io_uring/zcrx: move io_zcrx_iov_page
  io_uring/zcrx: remove sqe->file_index check
  io_uring/zcrx: let zcrx choose region for mmaping
  io_uring/zcrx: move zcrx region to struct io_zcrx_ifq
  io_uring/zcrx: add support for multiple ifqs

 include/linux/io_uring_types.h |   7 +--
 io_uring/io_uring.c            |   3 +-
 io_uring/memmap.c              |  11 ++--
 io_uring/memmap.h              |   2 +
 io_uring/net.c                 |   8 +--
 io_uring/zcrx.c                | 107 ++++++++++++++++++++++-----------
 io_uring/zcrx.h                |   8 +++
 7 files changed, 96 insertions(+), 50 deletions(-)

-- 
2.48.1



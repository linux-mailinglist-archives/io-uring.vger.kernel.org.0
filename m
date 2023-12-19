Return-Path: <io-uring+bounces-296-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C5C9819101
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 20:44:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE79128648C
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 19:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDADC38FBB;
	Tue, 19 Dec 2023 19:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LwphQ+rm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAB03D0A2
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 19:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d3a4671e29so9085215ad.0
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 11:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703015049; x=1703619849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/6u3BJ2Ih4A36ofqnpguJDYADNTOkQgdZBnvU+Wp1JA=;
        b=LwphQ+rmuJkAuF4kow+o46kSYs6Jp9WyJrTtpRhdRwa5WKa5OtON7TkJRhOPAsy8Wq
         ZkMVzsGS71dxzpkHCBh8TvG5imr8StImsd4ZbugaGZlpI3iwRzSz3nkXAl5gKFFXM9u2
         rZZkv2TqDSiXGvQf2o/YnLZmoBtBGUrbVsNrWHgoFZueyr1Sn93mAWGwI4Gw0CmmZpd1
         JjEV48n5i0pXxHta7fJJzYPam+A6x08rVN2QqyhBKz5Y0p3AyymkoGP1CfAO5Tstqzfr
         Ef2JaKuch4WMpPb/heNa/8o7meFqX76EuaEw3rec8oSwJhG5U0WhuWc0dTz+Z14iY88i
         rDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703015049; x=1703619849;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/6u3BJ2Ih4A36ofqnpguJDYADNTOkQgdZBnvU+Wp1JA=;
        b=vHs6xaMZPzJFVvGO7p7eMLazGagWWDRMhICbaQwrbzGfLJRqvPrHmT+4c69i/AtNlW
         u3MmAdiqn14EVXvUeahrn2NxGIMPqDduhLzM0ynmlwts2BBToF2k5TdcoWV05zDYea3p
         pxLaiNIQbE2m/oSFJ/P+gqLVZnfT5oUtNaSsfhqFNC/ut8F82x3FcXcPTguZa/XP/Q1T
         Gg+OCyUkdSjQFdyJKNeAAIBMkWBhQq+UY85ecp5xIg7datTN9nyd1+mIGzFu6wO5OY6Q
         Hol08dRV31a5RSoF9US4BKqnk7QatlTp8zdIeC68XXTEiIOYZGm4jHghfh7jDj0ZX6u8
         SkBw==
X-Gm-Message-State: AOJu0Yy+Pl8Dc0pONws3k2KB5MaES3kWXohLNlx93N0sc9JuTSqpLNhx
	/NncXXJZC73pPG1otQxEM8uu56JbMWNPdgHeiMJLmQ==
X-Google-Smtp-Source: AGHT+IFxMt6ti+aWH3YZl+IvgCqmQhxiT0ydMYex4ro0FDBp73sW9PqzoHmKJzumh93mir4DQtOmiw==
X-Received: by 2002:a17:902:b092:b0:1d3:ec6c:ba4e with SMTP id p18-20020a170902b09200b001d3ec6cba4emr182194plr.6.1703015049556;
        Tue, 19 Dec 2023 11:44:09 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902bd4200b001d369beee67sm7083397plx.131.2023.12.19.11.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 11:44:08 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCHSET 0/2] Drop remnants of SCM_RIGHTS support
Date: Tue, 19 Dec 2023 12:42:56 -0700
Message-ID: <20231219194401.591059-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Since we dropped support for SCM_RIGHTS passing of io_uring fds, we know
have some code that is no longer enabled. Drop it like a bad habbit.

 include/linux/io_uring.h       |  10 +-
 include/linux/io_uring_types.h |   3 -
 io_uring/filetable.c           |  11 +--
 io_uring/io_uring.c            |  45 +--------
 io_uring/io_uring.h            |   1 -
 io_uring/rsrc.c                | 169 +--------------------------------
 io_uring/rsrc.h                |  15 ---
 net/core/scm.c                 |   2 +-
 net/unix/scm.c                 |   4 +-
 9 files changed, 17 insertions(+), 243 deletions(-)

-- 
Jens Axboe



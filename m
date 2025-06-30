Return-Path: <io-uring+bounces-8536-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA42AEE697
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 20:15:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C278517809F
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FB119ADBA;
	Mon, 30 Jun 2025 18:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EJC52oEO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2B8199947
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 18:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751307338; cv=none; b=vFeicRK/193t4pCGuOxNsM3qNauaqfCZwnJPOOxLcYnnPFbwL7v4mc3b6nm4/ZOOgU3aOwQtPs4TEuoPYK5Jnlh0COHK8OuIiOLtu5l5PEQMqThEEhiy1CkXSQECzTseaGQRSI0lRmkYTbve92wg4Nf8Cob2dRo2XsNjpBjuAug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751307338; c=relaxed/simple;
	bh=NUImL+NoeTWJCuq/tJxBeX28pgiaR5T6vg8X5ZdYwS4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L2iDh0EV80PNN1xZO8x8oEoARAIjNav8chifO7bPWhO+OPv/9p5vZkjRwEAH2Q3jLf+PHxwAZMwy0esUgYchbvY7oJKuERmfPP42tk35yrqloC99Ek11TjbJEYW1Xsnv7ZIgwrJKamxRCWysH0h0mXkyVzPyWkyIDYedJI5Pii8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EJC52oEO; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-748d982e92cso3769985b3a.1
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 11:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751307336; x=1751912136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pbmxOvbnIwytB7MJxq+eNz+U/zfyKfteGO1pqpcAgHU=;
        b=EJC52oEOARa6LLZvjdo7pFSf67Qfgm5f45EWmQQXb0hrgW+bu35C0RW66GuXUpb2uF
         kkSzJQ4pcnaSgLxHd45ogrhjc1xHzBa7FFoP0fdZlrCE9Kt0ziilzVk0/ZWQyrJQCnCT
         B1zPQSCWtJZfxAPf50ij9ICpDhlwHIUEq9Y1AUcO7gxtQiPDnWVgUFhPY8eA/zKWHbpK
         ddAq8tBVQDwcakuVQ48EoZhgGMPbRuJYqedpGC+mny1umyGzeucrP0Zey3nchN88pBYT
         MqRNKwi1iNH/W+kITE0nEyeXOP3p3eh4bz1ZfkXGcdh71SL5EI+gEJoaAEr2Btplp7YD
         pkJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751307336; x=1751912136;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pbmxOvbnIwytB7MJxq+eNz+U/zfyKfteGO1pqpcAgHU=;
        b=taAvpZXCpFLu6R65ZhKyq327tXFI8c3cGnSb6R6EpX0wTiqsfOgSogsc6CsXGPx7av
         77QqVIyVkMx2Md6FyXjvQGcnEBmVjkeR++avWqoWFqXwGgjJhLo4gSiFcQXAKI2xeCsY
         V3rkHpPicypf3kUAKAQ+VOQ4JZNFYoiHR6Mpll/6sTDrSly9i97EPpF317UZ3rQn1xhI
         D7v593y3ISwMS7PWcm2JssmjrXvmwteVc9Fco5L7PgoDubBpvPYED0Y5dEfPpFGJdgE1
         6KCZt4vxv+on7o6IEq93zhRPoAdoMj+VAfF9o7WqrmSChSV41gFZdDuLU1ZBD8zFKFJY
         ik+w==
X-Gm-Message-State: AOJu0YzDXS/lmRhlLHGkKBm31zaNbdrJAOb3FHMWAkurfyIffJj4Lry4
	Qe2iwzH5hpZfJ5O3rWfVfhdY3zKfX1PiyVQt5+pxUt3lPtTUABkOkhcnuxK14i/e
X-Gm-Gg: ASbGncuFWRHEjuSuE1QmSn3jwe78twd2L8rD8Nen7OApdwx7Xjiy2EcYnQricgYlKsx
	AFClTDuWtf5JAc7TbAi4cinVJQH3weKgvpQG4vUjMoRsNFdCcLOOZJUNbwNotSVgf8GtP6JSAe+
	IltyJ5VCSA0zEXMOel1fvzM0kBG7JqUDangD02Mij3lXOttQ9RRK5/H2S//GfEuwCWm8ARLz67o
	IjLjID4v1TvLEB/Dk6rB8Zcayvj1GakRxjgKYHysrvnKvaO+/WWVRFyDp6YnOatY9Z/putG3Ykq
	a8GYRjkrHR1mRCalQr9NlikedQRKIT+HsxfY9xnoHhAXIw==
X-Google-Smtp-Source: AGHT+IFPcziR4eMd/9qoIeR9Fs3kU3MnHUVm6x1G60J4eGziHyMUdOs2Lhk+06RN/fdloc6Da05aUw==
X-Received: by 2002:a05:6a21:3998:b0:21c:e870:d77 with SMTP id adf61e73a8af0-220a12d0b4cmr22972323637.15.1751307336109;
        Mon, 30 Jun 2025 11:15:36 -0700 (PDT)
Received: from 127.com ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5421c59sm9505960b3a.48.2025.06.30.11.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 11:15:35 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v5 0/6] io_uring/mock: add basic infra for test mock files
Date: Mon, 30 Jun 2025 19:16:50 +0100
Message-ID: <cover.1750599274.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring commands provide an ioctl style interface for files to
implement file specific operations. io_uring provides many features and
advanced api to commands, and it's getting hard to test as it requires
specific files/devices.

Add basic infrastucture for creating special mock files that will be
implementing the cmd api and using various io_uring features we want to
test. It'll also be useful to test some more obscure read/write/polling
edge cases in the future, which was initially suggested by Chase.

v5: moves headers to uapi/
    taint the kernel
v4: require CAP_ADMIN and limit to KASAN builds
v3: fix memleak, + release fop callback
v2: add rw support with basic options
    implement features not as bitmask but sequence number

Pavel Begunkov (6):
  io_uring/mock: add basic infra for test mock files
  io_uring/mock: add cmd using vectored regbufs
  io_uring/mock: add sync read/write
  io_uring/mock: allow to choose FMODE_NOWAIT
  io_uring/mock: support for async read/write
  io_uring/mock: add trivial poll handler

 MAINTAINERS                             |   1 +
 include/uapi/linux/io_uring/mock_file.h |  47 +++
 init/Kconfig                            |  11 +
 io_uring/Makefile                       |   1 +
 io_uring/mock_file.c                    | 363 ++++++++++++++++++++++++
 5 files changed, 423 insertions(+)
 create mode 100644 include/uapi/linux/io_uring/mock_file.h
 create mode 100644 io_uring/mock_file.c

-- 
2.49.0



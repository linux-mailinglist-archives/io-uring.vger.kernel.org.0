Return-Path: <io-uring+bounces-9990-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FC15BD8D5D
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 12:57:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3B0BE351DEE
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 10:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E03BF2FBE00;
	Tue, 14 Oct 2025 10:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y5/CPIYY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31682FB99A
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 10:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760439424; cv=none; b=rK7ldpLl2GyXa1rv5oAaJXhnD6CqvySzaj0TwaOcYz+Y6mZBM2hD0NiAmMScHd2gTUxXjDPVF1A6aAWDp8TeoiJe4tQ8RBrLwbbVEgFcBlBOnMIAdvwE1cWeerJnodbzUodePxLguWoS0Y4QlUiOy8v02qjNiDjSImog3BpKWJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760439424; c=relaxed/simple;
	bh=vkQzdGhCLW9P3T4A7ZRKRiH3IzQB1LpaPTQGqGhYy6s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oIw5eljfcJkgzHMeKgC7FrF3YNNVGbIQxuesEBEekj9L0TITDXjnJv8BkwO9OzVZzezIwudVILAusyNO3MoajgycHGAgJh8EvDPnopg7nzHc5pVaww3ny2VhulK11Wd606EJ4Zp6v/8RGmh5MrZk4UwfPzEefLbarssMYGigHF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y5/CPIYY; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e6a6a5e42so22718745e9.0
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 03:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760439420; x=1761044220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8QySVSjGzqpmP6r+BmP9KLXPiFSAlqMnHru3y5wtYCQ=;
        b=Y5/CPIYY2HaN+B7M8g6boCgMpYDh0nhkylHrjWB6nQ6h2tY0Dn2quWGz0G1uMAIf4Q
         Kr2fVvwglUsK0fRkgWYv5c1iC9mHpx/7/lH1sY2glB7OWBYNJkW4gNm/oWB/2xbsEXtg
         4P40CMVlXkEky14ltZaqe//INJAos0n+sMQtgePMewm8a1DmzbwXgyssr2clpv1h13/x
         0J3bZ6WiqhPpx2Vymjjy+PmdXxqx2YQRKoG+51b1/J7Xk09FE2PL6chepx/pCxiq2K1Y
         Nvapj1Ew/v/WKLeKFL9tH8ixy+YxtXdppn+YNvbgcnlp3uZoKO3rgdV9ek/5A3pJDJl2
         LWeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760439420; x=1761044220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8QySVSjGzqpmP6r+BmP9KLXPiFSAlqMnHru3y5wtYCQ=;
        b=H/ACUgdGg3KOyDaAXImN4f9tCxozn2NBT8kv7/RJOyDDqCiIM8Bqzzw+kUB8cmkc/S
         SYrHCuz3kdxsdgXFMovunKo9om4mZVh6o45ptKsfuBZNYN+UvpcLZ5YGQMdoaLLDM1W8
         q/paYpIigITXzBbGTR6khgEtnm8//f6IyQrLk30bRvWbwzXV6xxe9LHlQ1lhKPL1Pl/U
         cVRMNdY7jjBQiLHmSifDUV4qMK4iK5M23BbPEOD7v2AVx7kydQtXbgePPG7bI/zWXc96
         t0TDtgr/MCFEMstP1v/vybWTjPw8U+mxC8ehcr4mTqlQRjZrn3YYvgQSIOVqTzVEMFwd
         z7zw==
X-Gm-Message-State: AOJu0YyDI6d143DoS0JYmO46uhDpZPxdVV35mHzYwiKa5NGBdVJG5pha
	AJ0xgupSb5pAarMhWX7wJtM2cVrFYji0PVpRR7ryM4ANZ4u63sGJZwJ1M5BSPg==
X-Gm-Gg: ASbGncvMOmPMBZgJ4EVoiEWteHVKG8Nxio+iCOMI0y05e8/z4gmbaz/KO/Pj25RYSCc
	4qBPeHUZlkuIUEu+sMqJXQAfcksE3rjDIjMbIA/2xIiY4mhwqMZLD8j+pkM2Yl09jfXP1KFFmTc
	o7nhg4blmdgPkSqXk9mz+Zd2RCz2ysyjgOq+k3TY3IPnKySb+HjFeagdnF975TruF3iqfpa9XPZ
	jQWMqrz/sxzbxv5iRCdJ2OcW+Akl3WOLfre5gTPAR9HrFTWaWN34pwEoShLzCQq0/16YYyQkcZh
	1QhvDn++G9Jo5KZZB4buidfQCmkE10Q+lRPLRsAE33OV9zTfJwcTYmRb1uy0+EcYqDdKEVwYRPh
	RLGP+eXpsif4D2YnBnrETdtx+i2FPzbko3JU=
X-Google-Smtp-Source: AGHT+IFrScPKsq04N8UpoAkz0Gi1R0UjjHSi3an8nGy1yhCzMmc+qcNt6MiiIWMWrrFZYKLOHgEc4Q==
X-Received: by 2002:a05:600c:4687:b0:45d:e5ff:e38c with SMTP id 5b1f17b1804b1-46fa9b02000mr201478515e9.32.1760439419599;
        Tue, 14 Oct 2025 03:56:59 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:7ec0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb497b8fcsm235694115e9.2.2025.10.14.03.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 03:56:58 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/2] Introduce non circular SQ
Date: Tue, 14 Oct 2025 11:58:08 +0100
Message-ID: <cover.1760438982.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a feature that makes the kernel to ignore SQ head/tail and
always start fetching SQ entries from index 0, which helps to
keep caches hot. See Patch 2 for more details.

liburing support:
https://github.com/isilence/liburing.git sq-rewind

Tested by forcing liburing to enable the flag for compatible setups.

Pavel Begunkov (2):
  io_uring: check for user passing 0 nr_submit
  io_uring: introduce non-circular SQ

 include/uapi/linux/io_uring.h |  6 ++++++
 io_uring/io_uring.c           | 34 +++++++++++++++++++++++++---------
 io_uring/io_uring.h           |  3 ++-
 3 files changed, 33 insertions(+), 10 deletions(-)

-- 
2.49.0



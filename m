Return-Path: <io-uring+bounces-9800-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6CF9B59A29
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:32:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C19B8188A1A1
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92813280A56;
	Tue, 16 Sep 2025 14:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bmns7qaV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05F827707
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032809; cv=none; b=YEJhtbbetd8ZPER9Wi5rMn6+hgLx3L9Kv1Xx31Ty2iS+uCcm9CRkzOhQlpnYMxeM7zmgJQWKzW0X7Y+d2Q+POeo6Fss8xpNlI3iEIWmKf9MZlBEEu+fI2HtAnDG3uQ6gANUeenDIAKi7i79E28G0zkCBbgvkRmMcq+HJXgP/PrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032809; c=relaxed/simple;
	bh=mNJOduvrmCOXNFXbAe4z5/VIFhnxP280Z9/15Ac8e7M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OHMIZE6Cl0aDy2XpyNY2OQiDolLukfhl4A5FmZojg04i4gjc9N1uJQmYECy62df7HKIaoQUY6uUZHWTYE22Y+fK3/V4gYsrk46lw3CJw2FhdZSDx1ghMdrTnC/xd6lW+xpNjirNEWdrs+QYYHrxTtOxPcD7oqzM1Z25iVQTwQXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bmns7qaV; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ec44b601b8so805485f8f.1
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032806; x=1758637606; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5OZWHb46HW+FIkzYA6U8IvTEqMTEs3V/aF0orH1+LzE=;
        b=bmns7qaVcrhegJDqE2Ub1CbC8P5cQyOmRhJAvTu0g5QR2dtxr8FRmT1UM1788H7fQF
         Mlh2upGPNm5FGeJkBgMP5f4a6lTB5Yu1dD3qohp7Khxk4uZPKQrz0LBylxFYVUu6z+FH
         4PGFTszKEoP5mAeTCEkzyJ1S6FfLRdRU+zjSECjPSN/eXlZ+pNNT5enIWkRCdRkeKE/I
         Ml1R/5RqCa/2j581IlvmMgyDmjRQFx8iTC490phiZFuNcLTaMpkfyLW+bM9rU+36V9mh
         /KAPC15Ls9bj2s5KkcxopjWZCEl0ZOZ1sWP1+be0xEr7wv88yBy2Ok/UsVtRAhRyKXYU
         kTaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032806; x=1758637606;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5OZWHb46HW+FIkzYA6U8IvTEqMTEs3V/aF0orH1+LzE=;
        b=Yf76JrVpKdij4h4MHq8UwyjsZoV5qukcRDhORwCI32HpqybQDG6c1zUdoh7W9vWI7w
         wIgxWXmp5MpUHM1wJHl7gmBYAwmkHdsv8eAAc/hHKlx9wVtvXTEN09QsqdyiBRyCn8ZH
         AwQVi/dzsc2G5nyN8tv4J45cjgfY4FhzgcEdsqWu6C68PiiLPGmuYBDey6SLUkTefdwZ
         4CupjMeSgPSLtYX/3cwzHg0AVxP4KLTKXY/plBIayys24AhJ13sb9xWdGhdBokKwiZY/
         fzkoMBSI5gy1wGs6B2a6V6Ty7nvz1FyxUxwKw/sCtayLTXZ1K+4+w1arcZpZWUAP6ilv
         6Y1A==
X-Gm-Message-State: AOJu0YxevwVEZ63FA62j+5M+bmQ9VnvO0M147WGoGFTKR7WxxbXwauex
	YSUwrheGUYHLWVWX5K3jehiBNhf4tANgdrhmgmkTZ5q55NLXvBb64hMq3Eil0A==
X-Gm-Gg: ASbGncs7ITAOou1kfL885kCS4s7oGwkWrXavYpYoGKvSdh+BP4TqN8ZfVtUX10yTiL7
	/Q3ROYsQ71jH606PwbtLnPRbABhnjnC45ij+eGF+PpTeTjHIDNMljvPS/AIxHYmnKnGWFr/n8bf
	TCvihRH4sKVuYFbARMemck1iPem4Os5lzniMI7Knj/p4PNy9n7q4qhCe08qMoNLAm4gzyHcvxz0
	9khoI4TLgPVzPszxa4Fx+OMGhQv2jANry/L/Ws2E7xDaqpgNgirCVpORSEpRJf9L4OVC27S2lsg
	n9bkY78B0nyR6DcuFS/IP2cg0xYKzkDYS4mqHROFXVfFre2wb9Z4StRUyaPO6ino8oHmR448j9p
	tkQKzEQ==
X-Google-Smtp-Source: AGHT+IHo1WlF4dadaABKcKU0F/B+7Bxi1DtFHpT3H92twN2qPT4EUkKrqdyb2IZP1SDMKOS2UJ1M3A==
X-Received: by 2002:a05:6000:1841:b0:3ea:6680:8fa0 with SMTP id ffacd0b85a97d-3ea66809332mr7523587f8f.14.1758032805515;
        Tue, 16 Sep 2025 07:26:45 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:26:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 00/20] zcrx for-6.18 updates
Date: Tue, 16 Sep 2025 15:27:43 +0100
Message-ID: <cover.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A bunch of assorted zcrx patches for 6.18, which includes
- Improve refill entry alignment for better caching (Patch 1)
- Various cleanups, especially around deduplicating normal memory vs
  dmabuf setup.
- Generalisation of the niov size (Patch 12). It's still hard coded to
  PAGE_SIZE on init, but will let the user to specify the rx buffer
  length on setup.
- Syscall / synchronous bufer return (Patch 19). It'll be used as a
  slow fallback path for returning buffers when the refill queue is
  full. Useful for tolerating slight queue size misconfiguration or
  with inconsistent load.
- Accounting more memory to cgroups (Patch 20)
- Additional independent cleanups that will also be useful for
  mutli-area support.

Pavel Begunkov (20):
  io_uring/zcrx: improve rqe cache alignment
  io_uring/zcrx: replace memchar_inv with is_zero
  io_uring/zcrx: use page_pool_unref_and_test()
  io_uring/zcrx: remove extra io_zcrx_drop_netdev
  io_uring/zcrx: don't pass slot to io_zcrx_create_area
  io_uring/zcrx: move area reg checks into io_import_area
  io_uring/zcrx: check all niovs filled with dma addresses
  io_uring/zcrx: pass ifq to io_zcrx_alloc_fallback()
  io_uring/zcrx: deduplicate area mapping
  io_uring/zcrx: remove dmabuf_offset
  io_uring/zcrx: set sgt for umem area
  io_uring/zcrx: make niov size variable
  io_uring/zcrx: rename dma lock
  io_uring/zcrx: protect netdev with pp_lock
  io_uring/zcrx: reduce netmem scope in refill
  io_uring/zcrx: use guards for the refill lock
  io_uring/zcrx: don't adjust free cache space
  io_uring/zcrx: introduce io_parse_rqe()
  io_uring/zcrx: allow synchronous buffer return
  io_uring/zcrx: account niov arrays to cgroup

 include/uapi/linux/io_uring.h |  12 ++
 io_uring/register.c           |   3 +
 io_uring/zcrx.c               | 285 +++++++++++++++++++++-------------
 io_uring/zcrx.h               |  19 ++-
 4 files changed, 211 insertions(+), 108 deletions(-)

-- 
2.49.0



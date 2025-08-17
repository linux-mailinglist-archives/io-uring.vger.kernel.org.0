Return-Path: <io-uring+bounces-9001-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB5EB2958C
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:43:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 954A41899F37
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B8B21767C;
	Sun, 17 Aug 2025 22:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cCHgBQf4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0F41D8A10
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470593; cv=none; b=nG5CUjkvrduBM3GxfYVFKgJb7cuuREd9IP+dRWwtsW0nwgEu/mjIlDaNo5UiJHpQJR2bHzF6LYBYhflgyBnw+Yl38lRCJtTRQipuNA2h1Lv/ogORv2ySHiOXalTtCRWCXTAhCTtzXUj0lP72d+vxZ67htnghvONzZG6huv1xLQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470593; c=relaxed/simple;
	bh=hauepBJwkZ1bJLaRDCVwc7HsERSm2lSmwc12c99COjk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tExDvnvdQxuOgoxek9kUuwJv0/Mor18S9ICuOFfrU63vzvEdPKgY+HaDvb+6X3z2xx+hw0h3Zmu6zBebaHYmsBS6ArhJDvmfGAvWs1JwKpGcnooIgbUzS4ZHeZE8mdMAqroP1/v8r8cpBhebKAS0Z48GWI17eitjyTfhGPFMRGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cCHgBQf4; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45a1b0b2d21so15698195e9.2
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470590; x=1756075390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E1PVNFuYcmxqwE1FocBN6I22mn9bn79QcNzJCN8b0Ws=;
        b=cCHgBQf4v1DsunxMVNxRODLwUjCd+3Dz001hWlF37d7Z2L8qtLdLq0YcGZU2FVL19/
         F7wbmLPePL9Q32+HQ/biCrg+a9lpANK8j5q49AqgHSmgoe60vcHPsWDZ8qz5y1fyAulU
         uDcsIqOf+e0vSlx0ecXv1IP7uIZs95Jg49trZxQg/7//retNrFZcxJm28LLlrt+TLsNH
         m7aiFG90Wdt+cgbDZgPNBta6CsGoF7L7G+TxKjYMBWtRlQHebc2gAJUxCjRb0wKeTIu9
         9x/+2H+xvQ9pAnHBU8TeD9i+o7lXDIYEcD0pgxLiugL+9163LlspED77ozzw8r2MKnXz
         I5uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470590; x=1756075390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E1PVNFuYcmxqwE1FocBN6I22mn9bn79QcNzJCN8b0Ws=;
        b=bBE+Nxgz3qTxVF2NjcA0M546/BJF25HLscWf/5uK9htwiEN24L0Myxom38ckFH7l9U
         BIq08e8ZyIDqsYxiNV6rb1zkXf51udIutOzdjtJGJZmuC8r/FCkrrMr4aLmiZ3a3ItK/
         p0XgmFZZm3dfWCSZIDYIEzUfxeNuXS8dOBTlF33G1kHMku13KWphsDm3T9GqLVjtOlbS
         kn9NZU9shCQ8JcXZNWjNWbtb91+dLra3wYwovTeaatlX/pYWZk+X3wP/01SI2eMVpUry
         wfqvgFGBunSPgB0sWZDtYyP7GBu5TTCk0VDCubtIZcu/1a2wvS6erjIWlBlCpnsjBHTl
         O2wA==
X-Gm-Message-State: AOJu0YzVcf3Jvcus1sL0XOV3zcbGjhXPh2j3lTjICZa9LX3vCJLrnQUo
	x9eY1TMY53Lddb2W8dvJ5UIF1uqQAkMuoyfvI4R6CTUlm9NRzXSvgZT/P65B7Q==
X-Gm-Gg: ASbGnctFIv+IpEn7ObsM7/DxuE7jvMPxoWK5tDtNmSFrvErNE10T7hSGVHvkrIslFVc
	we0Imh1KUmr0pc+2cGncHLfLrvyUdYfpVimOhzvtUjuihZ7EelEV7SBThw5+Dd1jzSepbGZ0kbN
	i2gkdU2Hh82n2ZD3RRkO0UXnPvmgOUhZO7tkzxHuxH45r3ipOXO0BOtcj/4ZoZCnr+THiUFJ9RM
	gL0XmJGTlaI+9xkOiIf0uaNW+H9qJ/PrD9SvO7F6eww2SSv//OxrjGpTOLZvZVmuPHK4z8lijPX
	OyUURoD1Oq+Cp/DG6KtwruB5DMVijQg5xdMAK4M2gSvJBGjXex8LwuJ1+R/UD5d+4iwUWsL5Nb6
	ErPACHJ36OWUas2MwRcDnk1pAVrwsdtoCeQ==
X-Google-Smtp-Source: AGHT+IEo/rq5O7qUGDLH5RVPad8mY7tPJBT9bbHjBbw434Amh7fqX0zFt/5vCvS0psUgQsyzTbOmiw==
X-Received: by 2002:a05:6000:3105:b0:3b7:9b81:73f6 with SMTP id ffacd0b85a97d-3bb694ae017mr6861863f8f.54.1755470589888;
        Sun, 17 Aug 2025 15:43:09 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a7fsm10554786f8f.37.2025.08.17.15.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:43:09 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 0/8] niov sizing and area mapping improvement
Date: Sun, 17 Aug 2025 23:44:11 +0100
Message-ID: <cover.1755467608.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This includes a bunch of cleanups deduplicating area type handling,
and Patch 7 introduces handling for non-PAGE_SIZE niovs.

For a full branch with all relevant dependencies see
https://github.com/isilence/linux.git zcrx/for-next

Pavel Begunkov (8):
  io_uring/zcrx: don't pass slot to io_zcrx_create_area
  io_uring/zcrx: move area reg checks into io_import_area
  io_uring/zcrx: check all niovs filled with dma addresses
  io_uring/zcrx: pass ifq to io_zcrx_alloc_fallback()
  io_uring/zcrx: deduplicate area mapping
  io_uring/zcrx: remove dmabuf_offset
  io_uring/zcrx: make niov size variable
  io_uring/zcrx: set sgt for umem area

 io_uring/zcrx.c | 123 +++++++++++++++++++++++++-----------------------
 io_uring/zcrx.h |   4 +-
 2 files changed, 65 insertions(+), 62 deletions(-)

-- 
2.49.0



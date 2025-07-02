Return-Path: <io-uring+bounces-8567-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E550AF5A61
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 16:02:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E2043B966B
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 14:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2912279355;
	Wed,  2 Jul 2025 14:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VhUX50wf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAB4270ED7
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 14:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751464931; cv=none; b=cFP6lWBAQLgJcL52tD7BzfVRPD/2vAS6uDwYnX6SRNZ1/ztaK6Be6h0iJufTcKKG1noCIajYG1xtbsAst8HFDdok0G/0/H4jUbdeB8I2ZnuVKl0eWYP+3q5zsZxAXqG5CMf+hsdfb+h80uCC5blAZD6gpPOFGtBWIIVbRqcvPh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751464931; c=relaxed/simple;
	bh=LlKLCN3/PUfZB83kQS6qtDHoSgJRheo52J7Hxbop4M0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OdWNBmo5Itya+LJgYLPt0GBU5qT3WU4+6fMpDS5NkaxRsZG0cs+aCW/IT+qYbQ8wK05q/egk0rmjDdNIcldAbgNpF6EWFyiuk2NP5yIVdTGRPTF/ao/RYGpitpILbpalT9JuwDuBv/r1D5HuFhc9VURfEq+W6SNfgKP+qd71hKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VhUX50wf; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-23636167afeso42435825ad.3
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 07:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751464929; x=1752069729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JhJE32CF7G9Xiq3Ne/q+5iMRX7p7cIt72EQylTFukFs=;
        b=VhUX50wfRIV3jtjAy5/4WSSREaFum+5PNyxQS2bgeCtRfV+7LNv6osTQysYQQH5nim
         GBaT9s2UZixOTq7zf0YvxNIBbykUIG1unll8Ivlou5udDbs3m5Jvv4RPRPKE1Xk5BGbb
         al2OpM2iWzAolDDDpifdfWUBaVJm/J5KacB/BHX0gxYA3Ksdc60W+NYJuqZJUSOfyXFm
         H0x0bIwH81UigLoXzukeWay5gtIINpCogYTVwYsw/uB6TRdVcWOFvC3cYnVUU47H25hG
         dLmOK73zKgdtIzVqJkByaoquX/C7w3n48qP0tcRjK7LJAFau1g9/uHQENUqMpd2xzrLV
         N0UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751464929; x=1752069729;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JhJE32CF7G9Xiq3Ne/q+5iMRX7p7cIt72EQylTFukFs=;
        b=Zgauygd8Jocb8/E3nenGd/NB90gtZwcCYrszHpWHez+kMqN9iQstD+WurtOxStV0Yv
         /AZGzpo48GOWBfdd/hIkvB2XQQfGZYA/bgNTwpxjsiiSDaOjYkPNaVbn5V0GPZ32wMvc
         2hzdZJ39uCoGhH3iYlOXbI7vvnoyN4J7lH4T8ayf7q/FUZ9qwU1YJJepJJST/cNgyFbR
         nXmV3Ee8j0l97mX8P4pPmJ38uQGZesQMVHEWkbtP/bvJRhy8rtnfw0quIv84Fzm/a6CC
         Dv0QejN5ZJ4yzn/LgvnBrzezb3RhIkfR/3LrF5deyZ8gSo+RzvgJmPFVXx6HOgycBmp3
         37Xg==
X-Gm-Message-State: AOJu0Yz0iXwVWy+9/vJgtoGhrj5D0NiQG9MEd8NSM+x1AXpNppWQ+GlQ
	C26BOBPmg/JLnDNrDCXFXLLwhcJKG7kwhtIbgvDgMA6Tqvj+ahmY/F3/2sfkr34H
X-Gm-Gg: ASbGncsyhDPqaPCQ5aDxCs/LeI9nBvn5MgJr+QISSw3nnMo471YAYn/NTQN7aj4isSy
	TSdDrI6p8+Idptr8DrQz0EzvX8cIbie1ju7XRgd/KngZoaa6LnFS6KkezDzB9B2dTQ78I2+gI1H
	O+d9yyAww0E0VX0u1rLP5W9Zgeg8eCl5Yns+6lX+a02mzrQztd1SZO47qcdZSlme2X/YZYS1nmg
	OTmXILkZjOivegkaL2bvmr3gmk0DUX9xRwiyusDj5ZJC1uSX4b7eSF4H1ekCD2Ys/xXc3u+J9OJ
	MpQ4bApySeuE2Oopa56fHhMhuWQoi+FtQ+HAq1bVKDh11eIDCUNQfwhcaZT/90FfxDuc+w==
X-Google-Smtp-Source: AGHT+IEhFBUOuFOngwZWPblZWM0RxV0tK/BU85sF8WegfbFTONeyjePci54o5OLEzaJI6GMignhepQ==
X-Received: by 2002:a17:902:d603:b0:234:ef42:5d65 with SMTP id d9443c01a7336-23c6e5ec705mr47381335ad.52.1751464927642;
        Wed, 02 Jul 2025 07:02:07 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3c6e14sm126828135ad.228.2025.07.02.07.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:02:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 0/6] zcrx huge pages support Vol 1
Date: Wed,  2 Jul 2025 15:03:20 +0100
Message-ID: <cover.1751464343.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use sgtable as the common format b/w dmabuf and user pages, deduplicate
dma address propagation handling, and use it to omptimise dma mappings.
It also prepares it for larger size for NIC pages.

v3: truncate kmap'ed length by both pages

v2: Don't coalesce into folios, just use sg_alloc_table_from_pages()
    for now. Coalescing will return back later.

    Improve some fallback copy code. Patch 1, and Patch 6 adding a
    helper to work with larger pages, which also allows to get rid
    of skb_frag_foreach_page.

    Return copy fallback helpers back to pages instead of folios,
    the latter wouldn't be correct in all cases.

Pavel Begunkov (6):
  io_uring/zcrx: always pass page to io_zcrx_copy_chunk
  io_uring/zcrx: return error from io_zcrx_map_area_*
  io_uring/zcrx: introduce io_populate_area_dma
  io_uring/zcrx: allocate sgtable for umem areas
  io_uring/zcrx: assert area type in io_zcrx_iov_page
  io_uring/zcrx: prepare fallback for larger pages

 io_uring/zcrx.c | 240 +++++++++++++++++++++++++-----------------------
 io_uring/zcrx.h |   1 +
 2 files changed, 127 insertions(+), 114 deletions(-)

-- 
2.49.0



Return-Path: <io-uring+bounces-5131-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CC629DE7A3
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D15B2817C8
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF01219CCEC;
	Fri, 29 Nov 2024 13:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LIMsJRhS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E85199E89
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887240; cv=none; b=MoEOto2h1TEX/oLtutxYenY0ri5kQIbCG7y+GoLmgikqbWVRfMnTylo1cFmXFeeSH0GZSRs58Qut5weT+OuZ5WPmaKQYItGjSdS9lVBnLwoJ6VM+E5XfQrLubwmqY8dhFJ34f9LEjWSvTVCinK0I4S8oCQksqVtO9ZvlEl8HBLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887240; c=relaxed/simple;
	bh=kqcat5ogh36tQR8GYAuh6hDxVynDNd4iHXYc2GxkgyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AnZYHPKkD3l77z+9rtP+EzLvNtg5Q0GTlCdQ91cDZlXZeOCROhl4EmCG3bgr3zyxqh85jU8esS2TMDYjhMrEfMMnQqF1TPzaV0DyjPscCBz5BCjge/ziOgmUgjbjW8pGra3fQF5cTXDfymaOl5SDGSuFiarkMlZ8NPbyLzgZCLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LIMsJRhS; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aa5366d3b47so271979366b.0
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887237; x=1733492037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s9MeknfqTvTkOdFhkPQP5UM1RB+f3zdV9yZy9RMz4yM=;
        b=LIMsJRhS76PWpjLu8u8DV0Wdnuwdw6LA8c7mJJC5eEVA6G2mXJglLzkdEq+xq71xNC
         HrEOlUW46p+HOhxW7MzexR8SD8NA4VZj0nyNrmrqrFFcpWaFrC7LVpLfQiJd45zc0uwt
         9u1rkK+vswM4HYVmAGAPBS3H0XELj5epy/j5lRcSLDVscYL2Wfrv92Dtp96fVltTyJg0
         akNz6cVCdxtwWKuu0v84OqrRW8FcMq228iO5jolT+l+rgOFp9SXpr15CKe7I9WPpO6I7
         mwW8Z3VALu9kEFzktPlAN1H7UYvYY4UaZn1iJEUA1fBD+kPHPnZ4WhfOKF7mGM8W46Vr
         BB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887237; x=1733492037;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s9MeknfqTvTkOdFhkPQP5UM1RB+f3zdV9yZy9RMz4yM=;
        b=PaiJPmdl7HSmAUHZJfGwCUZX59VXmFB6HrE6UxoRTZ9SHYhVWZCRJU8KcueFPsHNvO
         PYmcWTMU35+7NPeP6hzmstK5VNs2DutilwSAHlWmBoZbSqM2+Zo7407rdb10OOWhCVo2
         RUCl8G/b2CBEdPalNfc16JvxYLjoWv7+IHQWm2hrPkFH60aRzjb+st/n5e2OmJYdkOAo
         qqZaGsRRYONGaM/Vg7Qs46xD0gJc7NKNwVYwv/yfgX18/YGTuSWJsOZjIZlzOqriPSHx
         +4GlbTKNzVtlv7qUFp8TvcFidw+Rcuvho2uELioxytiwQ6lzkH/e2jO7ywoxyWl3XE+a
         aHTQ==
X-Gm-Message-State: AOJu0Yz03ErhUv/DWZFbDKShhvm6/oZ+hzfv1nwQLcBOZslyh/qxIRL1
	YMlKT34LOfS4h6NimTPSbu8Brs1zv/YRw+07h9m4A7z1P7fUSr3TVCHcpQ==
X-Gm-Gg: ASbGncu/WZMrw8O1WmOUgAnWBUdIlOTKEsh/8olGPb5cEquMAOKZSsBdQx8qB8Yd+Ki
	9YaB875eqJt29DOIdcMS6hg1X/ueIBNgYbVxBi5kHnmqQWMoQ0adqv0MNfIEL4e8ypsTF1hfbyX
	BKHSAixTcWvcxqgim7VWVnMC4iOh4jZqUD3bzJX1hhldcnEmxpeDDKSOOuAKV+NCYzwuZ9LREX/
	vKNP8OTD4kCNHgaCrEsdvxVtbzSoJ3QiYYeBcXG/vRDoxgDC9u8D82XXbXPqS5b
X-Google-Smtp-Source: AGHT+IHhPN1irHk4Em/aSNUbzxHpx+D9q1qb2cIYQzBLG0xQb3lw3E5cdpIc+/jpIpgLX6cL1u2CSQ==
X-Received: by 2002:a17:906:31c1:b0:aa5:31f5:922a with SMTP id a640c23a62f3a-aa580f1e0d4mr1003599766b.19.1732887236912;
        Fri, 29 Nov 2024 05:33:56 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:33:56 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 00/18] kernel allocated regions and convert memmap to regions
Date: Fri, 29 Nov 2024 13:34:21 +0000
Message-ID: <cover.1732886067.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first part of the series (Patches 1-11) implement kernel allocated
regions, which is the classical way SQ/CQ are created. It should be
straightforward with simple preparations patches and cleanups. The main
part is Patch 10, which internally implements kernel allocations, and
Patch 11 that implementing the mmap part and exposes it to reg-wait /
parameter region users.

The rest (Patches 12-18) converts SQ, CQ and provided buffers rings
to regions, which carves a common path for all of them and removes
duplication.

v3: fix !NOMMU unused function warning
    rebased to avoid conflicts with recent fixes
    use more appropriate alloc_pages_bulk_array_node

Pavel Begunkov (18):
  io_uring: rename ->resize_lock
  io_uring/rsrc: export io_check_coalesce_buffer
  io_uring/memmap: flag vmap'ed regions
  io_uring/memmap: flag regions with user pages
  io_uring/memmap: account memory before pinning
  io_uring/memmap: reuse io_free_region for failure path
  io_uring/memmap: optimise single folio regions
  io_uring/memmap: helper for pinning region pages
  io_uring/memmap: add IO_REGION_F_SINGLE_REF
  io_uring/memmap: implement kernel allocated regions
  io_uring/memmap: implement mmap for regions
  io_uring: pass ctx to io_register_free_rings
  io_uring: use region api for SQ
  io_uring: use region api for CQ
  io_uring/kbuf: use mmap_lock to sync with mmap
  io_uring/kbuf: remove pbuf ring refcounting
  io_uring/kbuf: use region api for pbuf rings
  io_uring/memmap: unify io_uring mmap'ing code

 include/linux/io_uring_types.h |  23 +-
 io_uring/io_uring.c            |  72 +++----
 io_uring/kbuf.c                | 226 ++++++--------------
 io_uring/kbuf.h                |  20 +-
 io_uring/memmap.c              | 375 ++++++++++++++++-----------------
 io_uring/memmap.h              |  23 +-
 io_uring/register.c            |  91 ++++----
 io_uring/rsrc.c                |  22 +-
 io_uring/rsrc.h                |   4 +
 9 files changed, 362 insertions(+), 494 deletions(-)

-- 
2.47.1



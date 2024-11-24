Return-Path: <io-uring+bounces-5007-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 698E49D7834
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EA10281B56
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3937D14F136;
	Sun, 24 Nov 2024 21:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IlINRH6d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643E7163
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482724; cv=none; b=c+XcI815O+9PuOLlCYBv8D0PiFtanaybXZe2IqgwuWGJW6eslaHO26Kaq01g9PEM4JQRw7VmSKoN+NiC6dP051XHtmWmGLg46FMEdN7ddOq7Rqj8wTMcTf7jmDhXQHteP/mFMcJ0WdVUiahyv9OGVLYxunEjXZSvAZfM3+Aogxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482724; c=relaxed/simple;
	bh=mw2V0M+3kdNVtfnYRxEaXTBeZZvmXKLwz4xkVLMkYSc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aGMNmVG87MZ43Vibn6LQHpAIZzi+YwepPjwLI2JYQNSq4nIJXRZyBwGHqRzVSVWDZpg3GQKHwkJwla77K+/QVMNmaZZ+6os84Ak0FCpdB3C4mGTBFcQw6H8zCSMdEs8AT5dELvSy15uBHd31MczGTtTXqcY3/x3RFMgPZ5VT2d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IlINRH6d; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-431481433bdso34295965e9.3
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482720; x=1733087520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FW5SOKTklLI3z4cN6hJWh5pReCpEsqaJlsOxy0HEz2g=;
        b=IlINRH6dVGp4qiHHxXb0VMlo7SEG+Y6OI1YwC10TV8iA5rLEEdnY6/Paj76BJFhbH9
         avc2afKIt6SgedHCbqVwzbGfeKPMBm8waA+zBRrWLTAP6ioxxFpgieDng9YvTcwX3t8t
         5BLqLafNSsZl4RZ/Sg50uehy3ktYjxO+S1f/HYM7UoLM4ab7zr0JY7422eHHpnLILSeU
         0ywt03ZX489Iamc6/xUCDhPvTTZGyCg7Qd0x9I4eOSV8aq+vOeUX3VynMrpYZ0ze9L7F
         bHOuujONcrAPjws5/RH9HuJbojYZc8gqF67qVWPkcgN0MqEGMvul0B2bV9WCJmhaXgtv
         c1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482720; x=1733087520;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FW5SOKTklLI3z4cN6hJWh5pReCpEsqaJlsOxy0HEz2g=;
        b=G+EukTpHeKH2mMiQcY+3PDlBEPA6YaRH7804CRlEpDKC+iSwfOcD+uGDXov5c3cz3U
         A10vtGEQA5+I35GFvrpk3kqwmjQFy9F3nwNSLNrmprdSS2LPrzNoM5MDpPc17grlLM7a
         cGNHIWjrEsFxKgNbD+7T+6FcOavxRdUDaxTdgLX5hHAV31nlfyeYDC7RBsekwjUHraKR
         m7pfRS/Qv2LIRRnCbH+XQ1DnfHjti/R8XF5JGVvaSY5cv/QfpBaaWn2cqNST2tcT9oqI
         GiytlixYRGVdqGY6gj5Bx6LkWxdr8Mmy6srPD+Y98WCj1+jvuWh+EBnOYnW24JCxPcw6
         1H6A==
X-Gm-Message-State: AOJu0YzY2YsPVDR1iKYvRXLYsVUf7lh5KHKce1Od/uEAiZhC4YXFtsNq
	RGVJPYRWK8rxCDbNm3oVCd4dgSApeSFRfzA8dKlWHXYrK4kl1+D+6g04RQ==
X-Gm-Gg: ASbGncuNXbuVA1jUy1DJap/hokEzIWAqR9wmmtB28j7y+w8dTmAuTiGOD7qfqC+ED1W
	QITuP/36az95xsFJzzqatU1v35hL7eym2dp2cnoh34O+WNEq5fIeDjnCUDuhGRfw+Kc/8LOPSeQ
	GKRgkcKsMTR2OPwH8V40k3uazm4KNcj/KhOapBEaVk2Fa87Nxrb4OMhVUjTVjZG5to7qwC7TcfC
	DGZUwEtNCqEo+W6dexqCmgPap5eVHJ5JEb/Fwfh8IbDZraFNj868/w/NOEByUY=
X-Google-Smtp-Source: AGHT+IFKkL4Dn21TG17HrJ3vHx2qIhqERNSHm+8cbyP8pmQ6MwQb7TamwrwhgnrZWz19ji/RaZoYbA==
X-Received: by 2002:a05:600c:1f8f:b0:42c:b52b:4335 with SMTP id 5b1f17b1804b1-433ce4210fdmr106197095e9.10.1732482720359;
        Sun, 24 Nov 2024 13:12:00 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:11:59 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 00/18] kernel allocated regions and convert memmap to regions
Date: Sun, 24 Nov 2024 21:12:17 +0000
Message-ID: <cover.1732481694.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
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

The second part (Patches 12-18) conver SQ, CQ and provided buffers rings
to regions, which carves a common path for all of them and removes
duplication.

Pavel Begunkov (18):
  io_uring: rename ->resize_lock
  io_uring/rsrc: export io_check_coalesce_buffer
  io_uring/memmap: add internal region flags
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
 io_uring/memmap.c              | 369 ++++++++++++++++-----------------
 io_uring/memmap.h              |  23 +-
 io_uring/register.c            |  91 ++++----
 io_uring/rsrc.c                |  22 +-
 io_uring/rsrc.h                |   4 +
 9 files changed, 359 insertions(+), 491 deletions(-)

-- 
2.46.0



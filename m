Return-Path: <io-uring+bounces-6700-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 73CECA42CF0
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 20:45:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A730F1895B45
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 19:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D805204F8B;
	Mon, 24 Feb 2025 19:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kf8chYvV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C251F3D45
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 19:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740426262; cv=none; b=pmsYMwDM5J0ggO0e67qcRuGcPGCPJhFwE01NwMXgpDYvWTOQE9nQedGKn/vV4hadzwcIJ6p0wlhXvfVb+5OYKl5LkYwjNGI0dD94uy1ra8FTg2iTOWt/4PZjK5kQ1lbhIcNJE8H0ngjpQnJ/v+s/bPGHLnW+eu5q2pZMgikPtao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740426262; c=relaxed/simple;
	bh=325nwkcRUDIQWv5UDmx3UfYIhoirlZYyB+22iQ/lJsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZQckDSYUGZB95ryIwJUs01sXK0VJvqCFdbZjZJyVEg8s4EUwYb7SMniDoE2p2u9Z7vSUlESJZ9kzk4LovGepXQAuPoJBvnSav+WQNHK5AxPvampb11/SxvnU/mWE3AVzLrCqU5yXDZRwrNZPwHZxaeyxWx8+DScga/dMSGUCUio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kf8chYvV; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4399deda38cso29407525e9.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 11:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740426259; x=1741031059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XyFNBIFKo4HAAaWI4UHbllD2dPdchzujqr3/l+fDjXY=;
        b=kf8chYvVjO30FcHa5dMBkau5ctPgwIDVH4uyg6SyU8pPyMkAqsFqlv5/j3w2pGGpak
         iGTo+rQizUABIRgnAAyBEUnVhKDtJTlwF7Eb2adMceEHNd5ajxvu97OpOX9oL+5fKHz9
         QpBYZhkfT94KrV+qa/absQ5/Dj+WpIBf58/G897ZHixB++/OkRuueJqtNtj/cW2xnZZx
         D0qiGdovRPNE81a/OsNF2qQdCQY3YUKPibvmMvp2PuZgfV1FzOS2FG2375k0gSGdsOIO
         2uV48EM11FkdAsI6Znu0N1PJk86Wi/75kcrnUx6LpgTuHl8QEJNrJMGKwt9N2rXaTmOJ
         +hug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740426259; x=1741031059;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XyFNBIFKo4HAAaWI4UHbllD2dPdchzujqr3/l+fDjXY=;
        b=w9NHbbHQwU6MdO//jgoCZNkGB0rnu6p4NFE4HQ38ekZ+TwCor/Vwh/t0ri/o/YOZoO
         qA2vvSfYCgC8QQQxQ2WRuoVK1iHtf/aYklIGbACK7AWumOOCBNfL2Z8gToSHBq82etCC
         zMx3yYBlY2oFPO7YtYiPXeKIWP9MaetVZPc68P2oEFQ6sbXaQXpGahg1NvUWHwHDr7kk
         XgfV7ip6MsUqoDv7OinQl6J4Q9hpOQc+gANlMzElpirkEIiphrY/FHBwtewj5WJi3ky/
         HponNUfprDlgpR3zTDU2JgbeVQ0GaDwowWcmWwBQ9i7QDZLCvUQWHN43QLKixs74QNcb
         xNuQ==
X-Gm-Message-State: AOJu0YxXGk7xlusY1BsiybQ/jgAaBZd6MiEZ+OXU/AXw5w8eFX2YWvlQ
	ScUTyliPw0MKVo/q3hpaXz1th7xijAo13p/TYLNG5ZTU5ZX8AGaMgLRxvA==
X-Gm-Gg: ASbGncvnqEeK2735iiyzB7OTU/R8s3v2BEX6r2bZwhUMVpiQyq9NTne0jdD4WURhVHV
	oG/OA8Xpk0LcwbTOg2weH6PLe+5dHFeFkmZFVSlAigdoGiwwdEv34IIOOOb0h01RduquuFAgGCC
	l3pfJ7LhRTbxc6cURE6e+hsQScjK3crsU50ona4vnM71oPoumBcFNCz1SjZcv4K+0dO7tIIy2TU
	iGHmCk+u/tWm4c7k4CbAv35bDlu6IgTy/pyxS/5UG5CEGpsuvXDftpGwHNdY3OQcGyHFg6rq2BF
	8tVojxaRrQpS2FFJZdiMbHT349KN90Aa/OweP7s=
X-Google-Smtp-Source: AGHT+IFKqPXIDRcW9260FJkDog5+6OzszXLHUfnIlQewo5sxs5OJ79i/OgT7QHr+8xtivXVzSz1Mzw==
X-Received: by 2002:a05:600c:4e8b:b0:439:9eba:939a with SMTP id 5b1f17b1804b1-43ab0f8b68bmr4808425e9.26.1740426258484;
        Mon, 24 Feb 2025 11:44:18 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ab14caa5esm1548305e9.0.2025.02.24.11.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 11:44:17 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v2 0/4] clean up rw buffer import
Date: Mon, 24 Feb 2025 19:45:02 +0000
Message-ID: <cover.1740425922.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do some minor brushing for read/write prep. It might need more work,
but should be a cleaner base for changes around how we import buffers.

v2: void * -> struct iovec * in io_import_vec()
    flip the if branches in __io_import_rw_buffer()

Pavel Begunkov (4):
  io_uring/rw: allocate async data in io_prep_rw()
  io_uring/rw: rename io_import_iovec()
  io_uring/rw: extract helper for iovec import
  io_uring/rw: open code io_prep_rw_setup()

 io_uring/rw.c | 94 +++++++++++++++++++++++++--------------------------
 1 file changed, 46 insertions(+), 48 deletions(-)

-- 
2.48.1



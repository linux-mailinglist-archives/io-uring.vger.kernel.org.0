Return-Path: <io-uring+bounces-7216-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C18EA6DEC7
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 16:32:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74E023AB46A
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 15:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1562125E446;
	Mon, 24 Mar 2025 15:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hlF1wjJP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FE125FA3A
	for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 15:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742830313; cv=none; b=omBdEQq5NLq/ZjwkJV03tSbt1N0Tb4Fscfl5GC6TvN4g9HvbC0XI4V3/HBYXHnvob2mynS51WFEsDNFL+EZh4hQB5U74l9e6o4VI6f2Q8SkJuMziFFjD8pFhVSAjuLJqtYkj9Dja5luJnwC+3UhVglzQDWkddp3H+hxCbWMZ0Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742830313; c=relaxed/simple;
	bh=9H40qhTCQqK5iK9gsSV+Gs1iPpoIboy/4S7Gnym0sr0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=liuJQsLW/2dCzPuOdji7rL4bE60ivfaWtdhUJfab+BLKyvX7Ww0CeoytnFDluXzy2w88xg0qaTE6/k0ghtk0xbDqIeQR0f65WLjSm4u00Me6BGzDcs7fk0VvaGkLQkUkVyLwN4J9kL+e+PYvoueodLrOu52Mny4XKuMJAhA++Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hlF1wjJP; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ac2bfcd2a70so656636666b.0
        for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 08:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742830309; x=1743435109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i66BhqWd3ykFKjcfNb2Vxa49n2nOfzGUxKVnZEMPqsE=;
        b=hlF1wjJP5BJlwmAGrkrLmphMkF5ccz6OXBdoAFK2EuLndRBmn6LXWvn0LJiJJeQaaK
         6Ac3B2Ya2k+0MevjK5oMUHE/LyQGF99ZSy9JXCe8TAf8CBPaceHXlDXYh2P78Grdto66
         DCaOE75KSpZW11mzEzUtp4mmlwFsh+YUkG2QvCJVyWYcpQSkwPDZDZX9WxIfd3OzRdQX
         fs6lxp8RuZ5dMmmgcgMRrXf8YAME9uu6thzBs4/EI4Vn7Bz708mNYLxHugoagPTQzbds
         RnF+jeCdBGSOufFq0AtNBdXop5tdG+kNGbMSn4WftZ6CMgbpbe7HOyUv4vsPxq1nRapa
         yRPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742830309; x=1743435109;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i66BhqWd3ykFKjcfNb2Vxa49n2nOfzGUxKVnZEMPqsE=;
        b=RQ8F7tvXpU67I4PivCpLofBRFVt8aiaH1EwPtZMvqt/xZsJHZXv9CtsTSRzHhwz0Tz
         satO0cY1B0CDEIrxbaxnamFYpXF1CshbrpdlXR9xPKfYAD8w+FTKHVJAtmIRuRZukQdV
         QVASiwQ8gayejIpT9XeRyYqQqlXEE9XzNZGXoKVgM1dfyYsNMh6PTPEMQZcTpD2wXhm8
         UNQivd5j9E2MLeoiLHew+M1jujw+DJttiOeLMdrcgojMVizsRCtNEy7jWeQ6wd8HIqtd
         DizkXXU0SstSLClIwif0AKp4TcviNdyRmSCDqX47pICBBWG+rlF7JJELqEfqTe8sBytj
         bEWg==
X-Gm-Message-State: AOJu0YyKMkM3PQCesEEvC+0un51boD9PZb/r92hasHbI+wz+u4NRbjRc
	EKdVmTh9etPeN4Pxf5AE6wUUZeIj0C6aVdDSLHKLePL4GFPHHKGdfIDBUg==
X-Gm-Gg: ASbGnctv64+YZc5vtO130AsE/bqBKt3dEGYkceDsAmMfgs/VYlkHYLBARDwOUyGfn89
	ii1S72Et7qZIaOEyHsh6yRJQ0bwk/1jkV1224AcCQzYTQ5QlaB3g8zpz/XtvleEx+7ajv40UzQX
	CWrb4O3SuxKIIMrLSLvAF/KPBJxaYGKA02Sqhw1XcDW9MLrL++sZAuFyx2gS4ne4KZAhwnHTiWA
	ohDZaL3q1/X0ueoDOU4joPNfDLC+qr8uo9JBoq9rQyKNVLXTZGcA0hHDyuiOe0Yauowusxo9uoS
	58w5S1u2JHKr1UoDriCCKWQGEMVg
X-Google-Smtp-Source: AGHT+IHNbxWNSHC0AEoruwLphaKU3tHTFPAyukwgFM5RaDXMiGyPjMJ/1x+4hUN36W/v0N+DJ8AuHQ==
X-Received: by 2002:a17:907:a08a:b0:ac3:8aa5:53f6 with SMTP id a640c23a62f3a-ac3f24d825bmr1218830166b.24.1742830308718;
        Mon, 24 Mar 2025 08:31:48 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8aa1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef86e514sm688103866b.35.2025.03.24.08.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 08:31:48 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/5] reissue fix and various cleanups
Date: Mon, 24 Mar 2025 15:32:31 +0000
Message-ID: <cover.1742829388.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 handle REQ_F_REISSUE off the iowq path, The rest are
random cleanups.

Pavel Begunkov (5):
  io_uring: fix retry handling off iowq
  io_uring: defer iowq cqe overflow via task_work
  io_uring: open code __io_post_aux_cqe()
  io_uring: rename "min" arg in io_iopoll_check()
  io_uring: move min_events sanitisation

 io_uring/io_uring.c | 49 ++++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 29 deletions(-)

-- 
2.48.1



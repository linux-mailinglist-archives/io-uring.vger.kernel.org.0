Return-Path: <io-uring+bounces-987-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27C9C87D660
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 22:47:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56DC31C217A8
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 21:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D6E548E7;
	Fri, 15 Mar 2024 21:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GKDN80bb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE525491A
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 21:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710539253; cv=none; b=b6DpbZ9HmAT+xthVIzopS95tfVBiJSOItmwyDU7ybrCF5YnlACtysc/4Bt9jVJrJcZ1cp//PIfmdD7e3hOn69QF4cDjYZNd/4PEP8ej5A0Zpl2CWgZk6ansHSxO6g3nb9Q0DXKaVWTfEEmHrPdSo+aAJB7M0CaVsCHY6Jc09AxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710539253; c=relaxed/simple;
	bh=oKOwkD9uEqWxyz2+JByIDGBCBcGuVlfa7hISPAHEaNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=org2SQpkdNLUCmWIQLS2uHldDL99aQjiGC4ZOi/WnVz9kAAsOmOujQ9UdumQWlSWGLL171syRGGcop35tXrM8a/0zZlo0DWybHvZcLLNU0245HF1y2L0dUMLe2BJHga2JA3PKVk2oaOwepU4P7yN3UKrRWype7TFWjNo9WFBvw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GKDN80bb; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-413ffe7ee4eso9530235e9.2
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 14:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710539249; x=1711144049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MeHDzWWTsxVr3uyxIAv6b8+tPYujO+vm7VOvv74Dnh8=;
        b=GKDN80bbW5BFep9giyGOC4LDshehC8jhHRWQXF7YzFSHAeDgbrn8AU1So/ASwYNbsI
         8zFLohpvx+oAipHQzXuoK08BzmN6Xxpoc75Mj9AsJfn1TDtE18ibfr7tblMGUjhUHTPU
         N5GmAWLEm5XAc2Xr/MxZzl+DAUmxB/mcevhyU905604sHr2fr50v12n3McA9+8Dj7xbq
         vUWSLqdoWi8t+bCEwA+K9ioUC0RJ8pC9o/AdmAku3Qy55I0IOcwfSzzmA+GPR7v7GbAq
         uBXEnpcu/DCEX1VqIk9265jpZsnKkdtafAWMBLqX2vhAVbcWJujLk/aJ5BW9TEB+wblr
         YVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710539249; x=1711144049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MeHDzWWTsxVr3uyxIAv6b8+tPYujO+vm7VOvv74Dnh8=;
        b=fQB+odIo3TTVNV9wwYQBUqA002VUBiwgRD00yx0RbeqwEt7ajSwwwHEwZCetnauCsp
         7RJH5qTl7cRnS+10D1q1g0Tj06ysoAZJXsvufeLTSi+FlDTbTo7Vhel40hD0J0GqZCdR
         4XGQjmmhxus1na1Z2yEva9DZYb/zQT6ZXXzXMSYrj/mmEka43/gYCcMVmocLfiFV5sIb
         mCaSbwk5ZOdB0AjXvVXGwLSAkzWyJT8GwBTq6urVVaABrao2ZN1AS0dq+lX+zyT7YkRu
         AsolsXFxZBq0Q3XU27dtffvx20+R90Qo5xJus042mzO1pPxe+pIYBfC4/PdP26KBJcq8
         uQKg==
X-Gm-Message-State: AOJu0YwcNuH/LPctYk0WRH/dfcBDlg1oYUfMVBb7dxFIiNIniu9mRGxJ
	gZ6QUzJIketqHpuB8iwJ5bw1bcqYIwi6w8dOgVTypnxltin3FBAbw2PYEqWD
X-Google-Smtp-Source: AGHT+IE91kXhuVUkZOjvalzr71aYJbhBjrS8DFUXyyFB+i/qgciYFSupQ2I490fhIdJk1+LS6YKmMA==
X-Received: by 2002:a05:600c:310d:b0:413:2c11:f795 with SMTP id g13-20020a05600c310d00b004132c11f795mr4835924wmo.39.1710539249307;
        Fri, 15 Mar 2024 14:47:29 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id m15-20020a05600c4f4f00b004130c1dc29csm7040881wmq.22.2024.03.15.14.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 14:47:29 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 3/3] io_uring: clean up io_lockdep_assert_cq_locked
Date: Fri, 15 Mar 2024 21:46:02 +0000
Message-ID: <3c7296e943992cf64daa70d0fdfe0d3c87a37c6f.1710538932.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710538932.git.asml.silence@gmail.com>
References: <cover.1710538932.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move CONFIG_PROVE_LOCKING checks inside of io_lockdep_assert_cq_locked()
and kill the else branch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index db6cab40bbbf..85f4c8c1e846 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -119,9 +119,9 @@ enum {
 void io_eventfd_ops(struct rcu_head *rcu);
 void io_activate_pollwq(struct io_ring_ctx *ctx);
 
-#if defined(CONFIG_PROVE_LOCKING)
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 {
+#if defined(CONFIG_PROVE_LOCKING)
 	lockdep_assert(in_task());
 
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
@@ -140,12 +140,8 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 		else
 			lockdep_assert(current == ctx->submitter_task);
 	}
-}
-#else
-static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
-{
-}
 #endif
+}
 
 static inline void io_req_task_work_add(struct io_kiocb *req)
 {
-- 
2.43.0



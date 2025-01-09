Return-Path: <io-uring+bounces-5794-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 965B6A07FAB
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 19:19:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8CF03A6837
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 18:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B86199949;
	Thu,  9 Jan 2025 18:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xLheF3Je"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C70218D64B
	for <io-uring@vger.kernel.org>; Thu,  9 Jan 2025 18:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736446792; cv=none; b=Dfi0fo9092ex2PftvqXpcR19uZzMjt8WyFVbGD5GYcpHGbh21UanyRe+5hCVtMLYB3TDuKP40/Tzv00P3iQRAOG6QnwiuYHq8t4VQtGCF8CxMjqwxM1KZjngDvj/JRKhHLbZQAa5gQu9ZnadSzbQtt68pcUMt2nzaZUkArJFu6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736446792; c=relaxed/simple;
	bh=dNar5AEtE0BbKa2mnnMNZVte74NklMUkXZD3Hb0W60s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNggO2OkszvXIUwtGFtWE7WKrW7uadM97bgGk8OP/nNjaFMZJIQAyhDsp4DKRXfUh4NC1lLLItGuFW0dWUH79sMFyaz64Slc6nyk9BVWoCSmHIBBEbJ3Du5RNFZd3BzZuasHqCxxQFWa6haWqak8plpBL2+gg5iD10gDNjXClqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xLheF3Je; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3a77bd62fdeso7348265ab.2
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2025 10:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736446787; x=1737051587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e6pW68q8Tl0n3cWurgkIaiypqWgn2fQmC4/mo+BZ/aQ=;
        b=xLheF3JefyDugmIdhqMOGMuDG+d1XT1N8HPd2dwba273nobZJ8cAw4TFH+n4SAPBow
         NnRnuyvGTj/MiWAR+lHJ1xzBm1KphAgVzeVRdG+wdPqrYBieRx50jP6u81mb/uo5c+0x
         saLpazPlfSb/qLhABaf1tPxzE/0ppirGDgh+mr4DruQ71MhCAlABSZtH8DTb8hCIzDyc
         rC2XcHYDo4O+fOPqNDEILPkuJuGQd/d9x37Xq0q8Ws74LhYS7eMj6je4BUxGF15TskdJ
         V6NzEIbVGoHe5zhVhZETlBFqtReDVBN8c9FM6+VTlEJxU+TOILIBU5pYZ86Nm5z3SS5x
         oetg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736446787; x=1737051587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e6pW68q8Tl0n3cWurgkIaiypqWgn2fQmC4/mo+BZ/aQ=;
        b=hqDe6KIKNV7W/EvMVtZccndpJm4ohIJhW4VedTlYLnZpgsUBPgVlbW4hKSaMXrpP+2
         kkp70QPStSUimXh5IqrkEmFOOpndbOweTwVq2Tb3MfzMWbK7JYNyOD0QI1B0LwE7eQef
         3PeL3FFm0rFVE5Zm68xdyj8/U0dRRALF9DRC4kFXnqwSe/Cx1WMINSldzWSqKnQu60F7
         Kv+Mx/JAqVBh1F29qMhtme+aqQImhQyQ9Zu8Kwf6SLCNSjugFM2tunfzgNA7Fmw7Oghb
         0ilDgse6uDIDw33RQ67GBOfFOnfLaGLhW2+SnvM2fLcuxuoUITH1NTKULGgViRXWI6Xm
         UpeA==
X-Gm-Message-State: AOJu0YwcY4Mi/5q5Gdn2vBj0iJtRkRaPoDQdXsBcu6sCOdx+Arm9uZmi
	A02yoQHwjSibGqwcUGiE4/g2QbQBHg4/wjoccVQWIzo+7MZF1Wjrx6g2jURjCqkjGxY/4xObnxZ
	Z
X-Gm-Gg: ASbGncuLwXfyFuIWJs4o13I2r2BqPncYFGAkDIYwPt1DyRJ2u9KqLXrC44i3Q8xUApZ
	mkxsKngrz8mP4U+eX+SnjupWeMSDQGfyatWVlc2I0dERzEll2qCjj90RZc5OkCd/HJi2uLplCSu
	18UX8wPXORxQ68dzu+KYxUaqycE0g369bc9LaPO1gmpmRRcr2jzCwBgx7GeYJ2mE5KOtfgNPa03
	iuOsSXBufIcoBPjMgcxf7fDPwnpUUD4hXCAlOPhgi9tC7koKhLr2q9btuBWtQ==
X-Google-Smtp-Source: AGHT+IFyMcQZb6yKLBN0KMRGktmzr5gt2V3e2Q6PHagEtcNzVzbFyMJTFrSktK7C/t9OOSkQQwFTHw==
X-Received: by 2002:a05:6e02:483:b0:3ce:3c8a:b7d9 with SMTP id e9e14a558f8ab-3ce3c8ab91dmr48454835ab.18.1736446787065;
        Thu, 09 Jan 2025 10:19:47 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b71763asm440672173.103.2025.01.09.10.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 10:19:46 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/rw: use io_rw_recycle() from cleanup path
Date: Thu,  9 Jan 2025 11:15:39 -0700
Message-ID: <20250109181940.552635-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250109181940.552635-1-axboe@kernel.dk>
References: <20250109181940.552635-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cleanup should always have the uring lock held, it's safe to recycle
from here.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index ca1b19d3d142..afc669048c5d 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -434,7 +434,8 @@ int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 void io_readv_writev_cleanup(struct io_kiocb *req)
 {
-	io_rw_iovec_free(req->async_data);
+	lockdep_assert_held(&req->ctx->uring_lock);
+	io_rw_recycle(req, 0);
 }
 
 static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
-- 
2.47.1



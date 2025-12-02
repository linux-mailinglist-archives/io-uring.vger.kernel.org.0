Return-Path: <io-uring+bounces-10885-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D62DC9C410
	for <lists+io-uring@lfdr.de>; Tue, 02 Dec 2025 17:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2395E34448D
	for <lists+io-uring@lfdr.de>; Tue,  2 Dec 2025 16:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E0D929BD90;
	Tue,  2 Dec 2025 16:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="O9MRYuyk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f97.google.com (mail-lf1-f97.google.com [209.85.167.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34EA2561AB
	for <io-uring@vger.kernel.org>; Tue,  2 Dec 2025 16:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764693694; cv=none; b=lYaVJl+ogA4hHnwFa2XFwLYydhay0g3ofw0F+mbD36pKVQjFW/z4PvV3z6r0Fcw2KP5NGG8pnYMrG/uqxCDR0XGd4tV1qEKD8UxCUrP8HHI60DLeaU+mNSIobmH9p/ueIXDD8Yak4ff9WvLrg4+9cNFXaDHHxCvQnpMHjnQ1yHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764693694; c=relaxed/simple;
	bh=oJ3TB2bE5K/CW3N3AxH8QvgLVVXrWJFnX4vH0ILQxFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8h8G1lXkkPKFouMfQcYhlriJjKk4JJ26yUDo4V2V/DN72f8FpZgOUH/fB8CnfzvoA7RMuPlT27zsLF6EIS3yX5764pDNHSHqiGucjw8XLiuYN8cSNfYDFrn5yqYjZuLMy/IR9Dl7WxBxmFflB49j8DWDQET7hLXIDkeDm8KBto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=O9MRYuyk; arc=none smtp.client-ip=209.85.167.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-lf1-f97.google.com with SMTP id 2adb3069b0e04-59425b1f713so512279e87.0
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 08:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764693691; x=1765298491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rY5nvju4bFOTuCq7sD6Wpn9mpxfHxv1vMUw6znMOr3Y=;
        b=O9MRYuykOSNrdzqWDrU41hqQdCEmSRPqBCWC9tk3ECySIMjEcgmywjfHjgTfqdxBs0
         dtL1wm75oHWDBKv6n/hbii7CaYvVWLx7bW8Vud2R0B1xlzoANWrpYm1l3wOuRqKWPo1Z
         Gl7FrWMi/Azefm3t854cX/zQwp1WIFhwgjiDd6yDVZ4x7mQuqM0ttyJrSHa8NFbtbGdh
         8ouzrBxzb2QgogPXx13EKsQK+gvuM2dVfhrWFsNdQu5wN5Dn+pe0kucATuLnks8NbNqW
         7ZICAQIDTyK40wwA+HnL3NE8DJpmLYqkanhwEUmbep4qlm8aOKY84odfwjgucn5XBKMY
         Yb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764693691; x=1765298491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rY5nvju4bFOTuCq7sD6Wpn9mpxfHxv1vMUw6znMOr3Y=;
        b=JOFYYKqFJCdE6m8emIL+hx1RFq78G6MN2tsQUCeNXNqyAMe9hxExZOAgA7EyYFViU3
         hBERLXKHYiBmHp72K7lUiA27NJPrtl2yq1MoIqUa8SJiWC3wT4mb4In6dejVAOrjiXCV
         DcnXjrrSekvZ8tccLaFVny/5PE4TIJ6jSBsIEPtV+S6Mq3PrZw1IZUG+X6bxKURsd0xq
         El+lcMib5PfHOIpJCgNaGN3tII3DvODVUezedoXmsj4snrmap4ZIdmxVOflcpbq806oy
         1yPL9jFGajyMX6Zc2amtsGWWg+hOF3Fr/nr7Sni+Hpf3jhkXDcnSkXcAbUVDcOjZ9vHg
         nzXA==
X-Gm-Message-State: AOJu0Yy8LCz/5zoD6g7U1Q47V53GCEWwSXYwg3zQ8c+tfeNJiH1fIxw5
	ddPLp/V8Kde+Nzf/7hA+jZiomuTd/+PEaGLaRoLt1mFK0eWseQF3BaeiJs8eeT8kVdXAdlaWMm4
	ncY+z4rMgTLn8TenbscfkLvwFKYi0CAA7RqnbRGRf8rAcMqMBUy1Z
X-Gm-Gg: ASbGnctlXgWqw+Ph4L/41PbsKVVHFx9lPAkdq5ISH5/5/0HQJjyqXF/51zss17DuEmg
	we8Xpvc8CZ0/0w6qWOzkWg/NW6sHPoXnbxtlB0GF1G8nHPl39LIvCdWBgt+N8BSGHM08FN3UtYt
	qzPqwRUX0fO1s/MObjfJylh0rFH8b6vI/47mhJUgOZbIWPUqYDSk46Px2Et9R+WyOUONDR6qW/t
	VvHhNviEM+s2BWpgA6lfTpfl6j2MuT+flFTR5ug6SkRorvV4H590OFuqIlsUm7My0In6sLt1yys
	5dUNBpg1ay8kHY7cvrjV9wD5ijcTQJLHjp8qWwDwoywJwEcZ+3gGcQnAzqjMSQgu8kQ5t1f3dzU
	GtP78PXodyBrL8DUubdbYmEuQDYY=
X-Google-Smtp-Source: AGHT+IH32fycXq7x1oe6vlJMhxWCBP3eopr1dCNAYJyAgc83mxf/MhAxWqVF7/COHjOy3hK3lJhiKzOPbVqd
X-Received: by 2002:a05:6512:3b8c:b0:595:83c6:2228 with SMTP id 2adb3069b0e04-596a3e6371amr6575836e87.0.1764693690591;
        Tue, 02 Dec 2025 08:41:30 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 2adb3069b0e04-596bfa48ad9sm2523301e87.46.2025.12.02.08.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 08:41:30 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id D0F7D340505;
	Tue,  2 Dec 2025 09:41:28 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id CF016E41DB4; Tue,  2 Dec 2025 09:41:28 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v4 3/5] io_uring: use io_ring_submit_lock() in io_iopoll_req_issued()
Date: Tue,  2 Dec 2025 09:41:19 -0700
Message-ID: <20251202164121.3612929-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251202164121.3612929-1-csander@purestorage.com>
References: <20251202164121.3612929-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the io_ring_submit_lock() helper in io_iopoll_req_issued() instead
of open-coding the logic. io_ring_submit_unlock() can't be used for the
unlock, though, due to the extra logic before releasing the mutex.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d0655082ced3..42ac03b56725 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1668,15 +1668,13 @@ void io_req_task_complete(struct io_tw_req tw_req, io_tw_token_t tw)
  * accessing the kiocb cookie.
  */
 static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	const bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 
 	/* workqueue context doesn't hold uring_lock, grab it now */
-	if (unlikely(needs_lock))
-		mutex_lock(&ctx->uring_lock);
+	io_ring_submit_lock(ctx, issue_flags);
 
 	/*
 	 * Track whether we have multiple files in our lists. This will impact
 	 * how we do polling eventually, not spinning if we're on potentially
 	 * different devices.
@@ -1699,11 +1697,11 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 	if (READ_ONCE(req->iopoll_completed))
 		wq_list_add_head(&req->comp_list, &ctx->iopoll_list);
 	else
 		wq_list_add_tail(&req->comp_list, &ctx->iopoll_list);
 
-	if (unlikely(needs_lock)) {
+	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
 		/*
 		 * If IORING_SETUP_SQPOLL is enabled, sqes are either handle
 		 * in sq thread task context or in io worker task context. If
 		 * current task context is sq thread, we don't need to check
 		 * whether should wake up sq thread.
-- 
2.45.2



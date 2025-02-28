Return-Path: <io-uring+bounces-6869-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1894EA4A6C6
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 01:00:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDBFC3BC313
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 23:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 598D71DF96F;
	Fri, 28 Feb 2025 23:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="QeCRZzBB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9887B23F37E
	for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 23:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740787194; cv=none; b=Rdgkkp+DydMPaKvtuD00i0jUKA111H5ZBL4AtZCcZOGP/bqGJ/RSvHl8u/e0cNQAD8cLJMPIYsoAnzGyds6ipMKun8tzQgltauXT1IO/MJ4HXNDYgF5hZnfbRed7R2/2IaAM+J2QAt1FVlIkpTwOg/sA1lxxjRGAorYomrw7dlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740787194; c=relaxed/simple;
	bh=M19kqPwNW3vIXGn+RbcnqMl8wOB9w+/nhDOK8KFUgxw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e7n+XCWkDQeT8CgTpUsyqeOq/W5J5TZ5RjyKpb7+pXigUqRsNEKxR7BZU0biQ4j8nzdysTSEYd4X/wn4FE4QcLiHg3393MJ2ZVTEuSDZVsc7SCgElKiL+havgVKuw2MG6/cBVnV0qVQG8FPlRnuAGA1In7nnoVJgms+/VVtY9/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=QeCRZzBB; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2234f57b892so6668995ad.1
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 15:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740787192; x=1741391992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JSAJMXS5kmM5iwGMwe4iAEt0SbX+ffh78y3gp8LBwPk=;
        b=QeCRZzBBjv67C1z6Ur4k1aan8mf2RiEZL1RAvXNWeTm+4Xn/p8GKEqJCp61s4vwo77
         V3Yw4CByOVqjDbbDHt4KC1NNq09SbuxDMeJtngwf/1wKjzfuPEvMYghP9peDBiELIbCi
         deB0J1S8IXuVxoJM+E9Nod9NxEzdYFGQfwg3lRt1gMnn6wfWh/CmAVQz54zOu/nibnXu
         dvBY28CisI6EajoA7+NFNGmf0y03XyIm4wgRGDnEXt8jGrolUhr4N+vyyNaPobHbYhN+
         cU9+E+Auc4dRFV5jCst0jayLiIIcQuVzDyIeOuMisSLij0h9avm8d9NyvI8CtdVNBGNw
         x8hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740787192; x=1741391992;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JSAJMXS5kmM5iwGMwe4iAEt0SbX+ffh78y3gp8LBwPk=;
        b=IYseJtIGtzhVR1H6VeRduia2q5XB3RszqYiiTwlftvIvAAiLAQ0MML6y5Ydp4j4riS
         rUtogNpavpIC5h+SDBRIi9yXG1B9oJxGLS9DPC9dwM8IuFpP++7orTJLSLpJVxznbywa
         m7j+hPu0ppweLAvvfXMESLBBcpoY10Ge1Yj95sI7UitCWffvxiKyyNZQ4UGqheF+/7l1
         tdyXHGO9wCEDJP1Bj1Be1GY/YwxG1cyL6w7uhd6clP8YXpzWSeuowPZ6vco363D/IXZW
         P8RXUdWVwQvEV3Q14aK/WwZJ8sXiYOfATyjTbtgRivAHBBhGFDohCvgie1WLxEinebgJ
         YvGg==
X-Forwarded-Encrypted: i=1; AJvYcCWGskdDq9xkYhuDVu8tfqxP1XyJ02IIENsgAtVIybTapaajXboC/NtKYbb7Shg0/U6+bBzUZ1I9aw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzRQck+r9jOYLmjtOYFc+mUrddGDB1zzqQFH0vpnEGTe41kUnqP
	FNttB76YSmD0JsLQwmkfSr6PRmQxgao3A5qb+2r9f5kDvVRpsGdhYan3vGGMr2yHUkZwmGu/yFm
	upPmPj9HFLjYTo7oHmjfOigJUjkE/0Cg7
X-Gm-Gg: ASbGncu7ciwWL6jluEo4uecz7Pz+Oobr26vk0mqIoMjzXVsRvZNwkSOZfEPinbd+CQk
	QC5jMohpMkQvjq7nBrfZ4r2nu9ND1LF5+fF1cVtgomJUAEpBKK7IBUGsgMv5KBlEestvZEV1pXl
	a1WTUHkJvm8LrPgdEqHydvdJxG76vrLD/HtNheP5NGqJF/C87Jq7+ckgNuVEiwqW+bMKpBraDN+
	EEOKxgyxnJlMsj7/c+/jgZj2RmXE6zD4oTUMZjQe+PcnEzk9lSAxed9Scdz6Bq52qduqnlOoLVO
	sRw3NE1tGQyNLRDpD4IhVnJFbVPwlbfNe6NYbECGC7rdm9A2
X-Google-Smtp-Source: AGHT+IFXwoTbx+UT09HA0mseihQdFnNVZNlDZ+Vyxp4n3cmTdkTekPi9axOJaI12Kcp3hl9Tn51ew5XmZClo
X-Received: by 2002:a17:903:f85:b0:215:3862:603a with SMTP id d9443c01a7336-223692477f6mr31720455ad.10.1740787191655;
        Fri, 28 Feb 2025 15:59:51 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-223501fb591sm2330175ad.44.2025.02.28.15.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 15:59:51 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 36D4B34028F;
	Fri, 28 Feb 2025 16:59:51 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 1F621E419EA; Fri, 28 Feb 2025 16:59:21 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] io_uring/rsrc: split out io_free_node() helper
Date: Fri, 28 Feb 2025 16:59:10 -0700
Message-ID: <20250228235916.670437-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Split the freeing of the io_rsrc_node from io_free_rsrc_node(), for use
with nodes that haven't been fully initialized.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 45bfb37bca1e..d941256f0d8c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -485,10 +485,16 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
 
+static void io_free_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
+{
+	if (!io_alloc_cache_put(&ctx->node_cache, node))
+		kvfree(node);
+}
+
 void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
 	if (node->tag)
 		io_post_aux_cqe(ctx, node->tag, 0, 0);
 
@@ -504,12 +510,11 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 	default:
 		WARN_ON_ONCE(1);
 		break;
 	}
 
-	if (!io_alloc_cache_put(&ctx->node_cache, node))
-		kvfree(node);
+	io_free_node(ctx, node);
 }
 
 int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	if (!ctx->file_table.data.nr)
-- 
2.45.2



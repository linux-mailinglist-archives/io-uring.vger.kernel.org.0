Return-Path: <io-uring+bounces-7215-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97E4DA6DDE9
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 16:12:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B79CA3A777A
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 15:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D32F25D54D;
	Mon, 24 Mar 2025 15:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="D2oBLnXO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f99.google.com (mail-io1-f99.google.com [209.85.166.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622FA25F7BA
	for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 15:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742829125; cv=none; b=EtPICN0yrPSb79JwgIZ+sPPs4ohTfRZpeqLHqCKoQSNu47hu5bRmjrjf+Pz3N3YKeW7lgjE2yPS881aEFq1fBcHi4JyRCmIFhvxbLuLMQ4PhFlrTkLbBP+iukDbbQbCUScLuXT7NXyyNFSTmiaR9dE9HNd3gvk3BKOsiLtbWU68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742829125; c=relaxed/simple;
	bh=6PyiGn4SiEiCYGvy1jMGKDenohF/ERsQojmyCgoW04c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gMxBI5Nyy2eJ9Ln7+HA5TAVK6dBr80LcL2sI0imyYSUeoS9CDzzgwSvGu3mfB3UUDRUW0KnE6qgO4ZEo1n93MPNKIzKEPNKUGIGzX9cDPdkZsU33NCefGHE+ZNjO12ssyENXwOYnGU7jeru/gFB0DYMdNAcbQh7NPlF2oSEMQis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=D2oBLnXO; arc=none smtp.client-ip=209.85.166.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-io1-f99.google.com with SMTP id ca18e2360f4ac-85b52d6e034so14757739f.1
        for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 08:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742829122; x=1743433922; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/DaDTHAl/xpFy64mz/KVdnuIp1nPGqaX22/7mVtls3M=;
        b=D2oBLnXOREGQCWL5no2MErDlkJBvVi81X3KLd4ARXPo4UPzPll96+9EBFr6Ft/62Cg
         HxrRogJV73TuVhLDHA3IZoYal8NwvU9SMmSaNG02E7FKNhGfCo8aO9pgUGQQFsNRJNCV
         OYPdbZsmBEO3lH+aUH5BWQk3YwM2c0NSqM9x/N6fXKVQY95zG/LGgA2bHvzg26Th2jCg
         XYo04wNq8b/EQlgXKtaiMFcTiC4Qssua6Vpt8UBTuDuUZxv0uYZieiNv4Pu8FpNtYsKo
         0mb0X9UYP5Yw+OYiF67/PQ1tq5DsZEIrS8AgqbbblEj2iWpKu0LlgBSCuwuxf52hmEdj
         mZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742829122; x=1743433922;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/DaDTHAl/xpFy64mz/KVdnuIp1nPGqaX22/7mVtls3M=;
        b=mmTS6NYBzr7t01PeEkx4CFmtkfoWJg6jm6i+QSzICyraLMwE8eDUuEKrPZTGmuGKLG
         tbsTZqaMpe/OTkedQZ1REH6cOHwHU2M4zbSof6Z1HRPG24sUfhsZ1rREuUqfRBf6+kWA
         TNnWyZ6w852UdbAB0scDAyK7OFAJXDTcx79F05pLiBTI+zunOBJyaDZVlr9aNeNmVeB/
         2FNm0tmfvShNmWe+OjV1sAL8RZMtt1iD8ghPOXy0968MKsf+OjXgLhPxVeWnoyHxaF3g
         3Id8UwvcG3GYHzt994KhzJ2Sh45pjXTgkDENpuITblUegb7yAsOUUU6FZ9gdBILJCYuP
         rg8g==
X-Forwarded-Encrypted: i=1; AJvYcCWVVHOsor9XlZ/CQZ4Y+yqplUv0HjlCGE2zFF+xPJwXNihgecQ4sJJniuBnmqahXi3WRkU7fIcRHw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9geOCh2rTodnGyc6ggjPpPUHTN7ip2FUIhhda9lzrTQG75vYj
	7Knl3aKVIY639CqqaJc5NOfMXSReVau7x3qAJhKHHLddS/JtJNMtoDssfWSNZG/lB7C5NufIB+r
	IUQl/jtbUoqCa9DZfFy/knCWNTdPMPjjuIjmTkyKSn7P30yVr
X-Gm-Gg: ASbGncurF7KGcEBcaoEAtmOZzZYmzns/DYwLk1vPjPXXVE49+izcOk2jAOkplGnUiJu
	wkUvj9pbRpw/vmH4IYrgMsemwfEIYiGdWZGR/H/mhIqFL647E0Y8KtACtLZO4mgbJn6znasdgAb
	vcK43/U1eU4xSufkiOTM5xJTyCYqUMKOCSLJfdpKJlPgs80eJXQtbI5dZjLOThsSskSxdGMArVJ
	VoPqesuYGyRHo05n5iCB6PC8Eg9YaO3Nsce0U+odLW+4VG6ytGjWdKwKGCGNig+gvlWRqakwwKP
	nNps73lkU6EFxKrlUn9eASGlqjl/Y/+NTg==
X-Google-Smtp-Source: AGHT+IEvGhdaNr00BzWWE+mFFMquDvVXhD7sNzqsigex3tx68oVgpBapaJD6isuNNk8GdMEGzNSPd+kJk7na
X-Received: by 2002:a05:6e02:1c25:b0:3d5:8928:20e3 with SMTP id e9e14a558f8ab-3d5960bf9d3mr38272455ab.2.1742829122158;
        Mon, 24 Mar 2025 08:12:02 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3d59607f822sm3708795ab.17.2025.03.24.08.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 08:12:02 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 3EC3B3400DB;
	Mon, 24 Mar 2025 09:12:01 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 31926E41921; Mon, 24 Mar 2025 09:11:31 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/net: use REQ_F_IMPORT_BUFFER for send_zc
Date: Mon, 24 Mar 2025 09:11:21 -0600
Message-ID: <20250324151123.726124-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of a bool field in struct io_sr_msg, use REQ_F_IMPORT_BUFFER to
track whether io_send_zc() has already imported the buffer. This flag
already serves a similar purpose for sendmsg_zc and {read,write}v_fixed.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 5 ++++-
 io_uring/net.c                 | 8 +++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c17d2eedf478..699e2c0895ae 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -583,11 +583,14 @@ enum {
 	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
 	/* buf node is valid */
 	REQ_F_BUF_NODE		= IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
 	/* request has read/write metadata assigned */
 	REQ_F_HAS_METADATA	= IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
-	/* resolve padded iovec to registered buffers */
+	/*
+	 * For vectored fixed buffers, resolve iovec to registered buffers.
+	 * For SEND_ZC, whether to import buffers (i.e. the first issue).
+	 */
 	REQ_F_IMPORT_BUFFER	= IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw);
 
diff --git a/io_uring/net.c b/io_uring/net.c
index c87af980b98e..b221abe2600e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -75,11 +75,10 @@ struct io_sr_msg {
 	unsigned			nr_multishot_loops;
 	u16				flags;
 	/* initialised and used only by !msg send variants */
 	u16				buf_group;
 	bool				retry;
-	bool				imported; /* only for io_send_zc */
 	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
 };
 
@@ -1305,12 +1304,11 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *notif;
 
 	zc->done_io = 0;
 	zc->retry = false;
-	zc->imported = false;
-	req->flags |= REQ_F_POLL_NO_LAZY;
+	req->flags |= REQ_F_POLL_NO_LAZY | REQ_F_IMPORT_BUFFER;
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
 		return -EINVAL;
 	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
 	if (req->flags & REQ_F_CQE_SKIP)
@@ -1447,12 +1445,12 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 	if (!test_bit(SOCK_SUPPORT_ZC, &sock->flags))
 		return -EOPNOTSUPP;
 
-	if (!zc->imported) {
-		zc->imported = true;
+	if (req->flags & REQ_F_IMPORT_BUFFER) {
+		req->flags &= ~REQ_F_IMPORT_BUFFER;
 		ret = io_send_zc_import(req, issue_flags);
 		if (unlikely(ret))
 			return ret;
 	}
 
-- 
2.45.2



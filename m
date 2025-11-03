Return-Path: <io-uring+bounces-10332-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F424C2DBD9
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 19:52:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B23DE4EFAF9
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 18:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D29B32570A;
	Mon,  3 Nov 2025 18:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Xn8XGq7S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C103254A3
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762195788; cv=none; b=Y7JedJNqEgTrybKRlaw806SwnTYe7iYduhKAo+qPe74DB3nYSJVvLwYKpgWAfaZfcumLFsD4DFvAnxJMpwZc4KI6xRRAkupzxFgLXbtpIjcSQdRvMbpnw8ReokB78z2edP+uclBmOfusqlXHHkNmv6tAeXqvzgBRYCRoD7xlY8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762195788; c=relaxed/simple;
	bh=aYPmE5W3oD4HhErik5ycYSbLKENXfAHec4WB27lC/1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgU/7YKC7v2eabvpbEUEhiIMh4Pz+YETexPlBQ0N/q8OPZKkJqErd01noLKDGNZzfsXwpxllShKz5SZeQ4Qsw100+LiHbxj+p+98FRIAHI9Ya43iyCHW7px6txiB6ZZzogjHbTyEIGol/vrwa2dBU5FPLGyfiHPD75tzQf9BxBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Xn8XGq7S; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-93e2d42d9b4so205326939f.2
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 10:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762195785; x=1762800585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4kZ2NOtf0dmbiOGulq6iVQhrcL9yVkfzcE47OyblUsY=;
        b=Xn8XGq7STbPDpGyLpAhWhNUj+iSX4V6kochYuXFpgcm8C1cfJqflk2DmZsXZfDI0Z/
         ffiI+EFJR0Dm4b63VXHMjegRUv2pNNm7jAA+XTEiBJmXT4yYSWQImObniSq5laVm265M
         bXz4klnxhU+6yi7a/Bj6qPdFvTIAFiYkiijFjWrmJZBn66okgo5D1cXqhRcf3DbUiSkI
         gFXYq/fbPqqzSzgMcVV+CBh2Btl071ov6vIDB+q8bLJzjb2/vSfoQPOK2FY25LnSviBe
         MR6DhuEVzpH3HPyEuq11sSt75I43KHYfm6/hlkXAb4hN0GhZ8QhrU8SvlR1Ys+49efnG
         jdqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762195785; x=1762800585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4kZ2NOtf0dmbiOGulq6iVQhrcL9yVkfzcE47OyblUsY=;
        b=Z0ODPn70I9tbFnDjw472d1ZRtbDCwNHSr8sMzEtiwDq76LH3RlNaJQsEmftITXZDKN
         Y6m9AeWlpBXTpI4GT0OaoAf558g/Q180MO/AQrFscASshvfkF4ZJnHup2QNtDe1cKYh1
         ZpEGuq03TkrCctusBjp4ZHtqh6IZyFJmWmJcZ9qbIO0JTYDWnO/Zk3xpy7L8QAL4MLy6
         x1J6TGSksgtMfuDEXhlGPecXdCdfIQ4pICqEte2/UrTO9IGxRuavnHgY2tGBQKWBHGVN
         SRVWhS4DdoX8bQ+nNPQLcdqhm9dGzT1sa16BaqSKyogLiuDDkD6m23ahI5m4E+dtU0WW
         BmYg==
X-Gm-Message-State: AOJu0YxKNkzx63epHyTX8Lpr6ZFUqJfVkSq/9/gVdbFdn48WG75wWnnX
	CqwzaiXBdAbgxxxXyoGkzloqD95r84ms2/wc5Gaig3IQlgsnAma0ryWrpZln+DA26+g2ceT7TUT
	Ie5rH
X-Gm-Gg: ASbGncufN2ULqGJfyBoUVH0NoOPk5T2nOBYl4d9rovsdwDQIzOJbES2rf/SOKHWAjzo
	LAdU74C8KzGuIh1eTN+pT3atn2zaPTq9rWS+1RzIpGdVbfSZ0olTgXzEHs59ghIAQ10oxOl7GNs
	dF9b8BZtiW2Lg4jlt9OadVS4o5wLtubb8tGszIYr+bsQxMymYIvDACVRLZSkAbQq7oWtcoVCFxB
	rQohpcsb9OobhpQ3Cx4p9ZrAn7V6f26lUl0X0rPryy20eVbIAl7FvivtEF3HXBbVmgk2nTLf0d5
	BoMTWjKV6Ds/OVDHcvrJnQUFiZ8gzsdOtTj2NBuvqU3wGpy94mwGjW4ZulX1cBdmZjUa0wTFFvh
	twowumbkzDUORItiGepx//6sZTC6jLRPGxiG8bdtiEsFCjVmmHLsBe6p1NYI=
X-Google-Smtp-Source: AGHT+IHLQVg9TzPXZ47c10w2Q1b5NVU5aEE3PhmMNTbLwmtPm1uGRtXRaJpXFp1ucWG/3XF2FCx89g==
X-Received: by 2002:a05:6e02:2290:b0:433:34cb:43ba with SMTP id e9e14a558f8ab-43334cb46e6mr31438165ab.11.1762195784608;
        Mon, 03 Nov 2025 10:49:44 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43335a2224bsm4572985ab.0.2025.11.03.10.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 10:49:43 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring/notif: move io_notif_flush() to net.c
Date: Mon,  3 Nov 2025 11:48:00 -0700
Message-ID: <20251103184937.61634-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103184937.61634-1-axboe@kernel.dk>
References: <20251103184937.61634-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's specific to the networking side, move it in there.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 14 +++++++++++---
 io_uring/notif.h |  8 --------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index f99b90c762fc..a786d5a01a2e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1303,6 +1303,14 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_RETRY;
 }
 
+static void io_send_notif_flush(struct io_kiocb *notif)
+	__must_hold(&notif->ctx->uring_lock)
+{
+	struct io_notif_data *nd = io_notif_to_data(notif);
+
+	io_tx_ubuf_complete(NULL, &nd->uarg, true);
+}
+
 void io_send_zc_cleanup(struct io_kiocb *req)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -1311,7 +1319,7 @@ void io_send_zc_cleanup(struct io_kiocb *req)
 	if (req_has_async_data(req))
 		io_netmsg_iovec_free(io);
 	if (zc->notif) {
-		io_notif_flush(zc->notif);
+		io_send_notif_flush(zc->notif);
 		zc->notif = NULL;
 	}
 }
@@ -1512,7 +1520,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	 * flushing notif to io_send_zc_cleanup()
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-		io_notif_flush(zc->notif);
+		io_send_notif_flush(zc->notif);
 		zc->notif = NULL;
 		io_req_msg_cleanup(req, 0);
 	}
@@ -1582,7 +1590,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	 * flushing notif to io_send_zc_cleanup()
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-		io_notif_flush(sr->notif);
+		io_send_notif_flush(sr->notif);
 		sr->notif = NULL;
 		io_req_msg_cleanup(req, 0);
 	}
diff --git a/io_uring/notif.h b/io_uring/notif.h
index f3589cfef4a9..a8e079991997 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -32,14 +32,6 @@ static inline struct io_notif_data *io_notif_to_data(struct io_kiocb *notif)
 	return io_kiocb_to_cmd(notif, struct io_notif_data);
 }
 
-static inline void io_notif_flush(struct io_kiocb *notif)
-	__must_hold(&notif->ctx->uring_lock)
-{
-	struct io_notif_data *nd = io_notif_to_data(notif);
-
-	io_tx_ubuf_complete(NULL, &nd->uarg, true);
-}
-
 static inline int io_notif_account_mem(struct io_kiocb *notif, unsigned len)
 {
 	struct io_ring_ctx *ctx = notif->ctx;
-- 
2.51.0



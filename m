Return-Path: <io-uring+bounces-7265-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C26C5A7353C
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 16:03:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66F3C174FF1
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 15:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EB87155312;
	Thu, 27 Mar 2025 15:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZRYJP9Zb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411FD17BBF
	for <io-uring@vger.kernel.org>; Thu, 27 Mar 2025 15:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743087701; cv=none; b=PsPFbLnTy5Y5PcnKZ6mvfI7k3GIlBCzQhl2gFAwSsrknbxbJ+x7hoaxPkBlOsxqM77iIKTwJ8mPUBjJnaH6SdgLgx6hKMGylkTGyJPq71Gp6eStbphpFhxnPwWUQidqkVpT5iqiMBFExSAr0eVAsRDxZoL3lJ5qv4qp2Ll6uvXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743087701; c=relaxed/simple;
	bh=5i2NiIlkwi5GlFWbBXGvBXHhtDJCvG4Jjexoan/r8pg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NC33Gm9ILFBFzfkIV4AmCYYn8X206SeRcdLc6rx3WnPDKm7iMD8kN2GYO2Kzfdnxtw23DlJwPTpxUC6cChy5t3gkhPsLV0E3Wnr8DmCLRgnMFl/fDsHynvaaEA1orJN2C/cp2U6Cve6SVmT4KEN/1iM3nZk+LSfIFshJrKuerT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZRYJP9Zb; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac2c663a3daso206847866b.2
        for <io-uring@vger.kernel.org>; Thu, 27 Mar 2025 08:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743087698; x=1743692498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bhtMd8gFA02iJ3IiN8tezRg321e/XebW+CwxGqwEjtk=;
        b=ZRYJP9Zbo5Aotpqa5a9pVu87rmwblQr0F3/CTFDJNU6aDRHawiExNfuNZGTtUMQyqG
         SRW69tuWjlXGVf5dNfez3jeQMgHHEeq4okhiNr8fkXUHx1TVX0DaG0fqq5FyT1OKmG+D
         cpBps3qJIY3pzOFbevMiKFjbwnTfqrTBhM4t/UKbu1Ba3UIbkhHUE9n9rMmpmJd9+9Gq
         TZ7nKDKqwk85RomBHWD+Q2zlFfOz+JJhs6GN7zrK5bsVjzQTYbdlq5Rcu2aKVa/sDEl4
         ngWB620HiG9XOxqj1QOyfvChYgOgxtlmsnTwALJnsbWImQh4xS30NUYRJzc/8L4A+gj2
         BApg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743087698; x=1743692498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bhtMd8gFA02iJ3IiN8tezRg321e/XebW+CwxGqwEjtk=;
        b=pn8yvhnEUviaEYXwJkrwOPNe/ctp9g+oNjl7838pn3G+9WopaJ5dqwx/IKSeqKHfGG
         YJIwC6iljuGhfXJ4V7XjxA6sw1U06dsiPF5Zjm/wqYJd6W9wJN2utae3EyDE6+3NU1Kk
         XcQce1Fxfp0LWeP4QNPwk54LuE3vng20KMDvUn3AxwEn72jFr4Uk54v86137+QbGzeAp
         MGDb5X0vJBpmu28y+XzXq4rNSI7qe0ShPP6Y0v7s6eJhFo+DvLNgyuWSLI4HgcLQehs8
         6psMFehDhQeFCuxcS4qsL6+oNP4h/kG9XaUuxD1XKkMJnTc0H63DRtUd6Fc45H+STFgp
         4T4Q==
X-Gm-Message-State: AOJu0Yyj7SxywJ1oGqSoYVgh1SetfhWVOZHd1DzGatEokgVhN3j+wRDQ
	eYzt+RWWLJLhDvBDPvwTDhzPToLSLp7I5UxW+eKzS18NaBj7CI/P653Shg==
X-Gm-Gg: ASbGncvmuIZVPbm+nUrFtfS8z8WY1flKJj8DMzf1KLPp5SkfkMhQi0Gms+FDWhUqqx2
	oxrdBc0R7iMK8c25KHvrhTOIrtA7Luk09i3K8/jUVg/GBWVd8D7h+S85adhE6+7ItBge2XB5buG
	4GKuO5mpXXqPuzSzTpQgnl0cXLdDd+BmpcluNBBsUVj/G9CC5ORzFyCo7gfbdE+tKjzv2zaJBmL
	Fh60n9EKUwnVUuVFhw2tVZXFx0lqeJK0iplCFViDpRUXy5Oewk6q+pFKcrjzHZyBB9yeljJ5qBw
	nIP5/AeayiXCURfQP3UMOosjmB7c
X-Google-Smtp-Source: AGHT+IHC85KgRgeiKtuHIybfMrkG2dukmH0qextsTHRkhG8RybK3ZWnbYvwaSC/HuIVPBYsHn0+MNg==
X-Received: by 2002:a17:907:9727:b0:ac4:76d:6d2c with SMTP id a640c23a62f3a-ac6fb14ef80mr331015766b.40.1743087696846;
        Thu, 27 Mar 2025 08:01:36 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8902])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71971bf3fsm2124466b.182.2025.03.27.08.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 08:01:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH] io_uring/net: account memory for zc sendmsg
Date: Thu, 27 Mar 2025 15:02:20 +0000
Message-ID: <4f00f67ca6ac8e8ed62343ae92b5816b1e0c9c4b.1743086313.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Account pinned pages for IORING_OP_SENDMSG_ZC, just as we for
IORING_OP_SEND_ZC and net/ does for MSG_ZEROCOPY.

Fixes: 493108d95f146 ("io_uring/net: zerocopy sendmsg")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 616e953ef0ae..a1d32555fe6a 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1304,6 +1304,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *notif;
+	int ret;
 
 	zc->done_io = 0;
 	zc->retry = false;
@@ -1356,7 +1357,16 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->flags |= REQ_F_IMPORT_BUFFER;
 		return io_send_setup(req, sqe);
 	}
-	return io_sendmsg_zc_setup(req, sqe);
+	ret = io_sendmsg_zc_setup(req, sqe);
+	if (unlikely(ret))
+		return ret;
+
+	if (!(zc->flags & IORING_RECVSEND_FIXED_BUF)) {
+		struct io_async_msghdr *iomsg = req->async_data;
+
+		return io_notif_account_mem(zc->notif, iomsg->msg.msg_iter.count);
+	}
+	return 0;
 }
 
 static int io_sg_from_iter_iovec(struct sk_buff *skb,
-- 
2.48.1



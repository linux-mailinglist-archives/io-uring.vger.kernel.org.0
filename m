Return-Path: <io-uring+bounces-7258-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AFAF1A72D26
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 10:59:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E9D47A6B18
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 09:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B1120DD42;
	Thu, 27 Mar 2025 09:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ckn3f088"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CBA1482E7
	for <io-uring@vger.kernel.org>; Thu, 27 Mar 2025 09:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743069406; cv=none; b=H8eLHryGP2IltNaIxWPqsAbeMTdT2o0msnkJusnl4AzbIYCrUXTAhHbk140XriI3AUKhy/WwHH1X/8oREASAKs8oZ9qtEEvmTjGg59aNnFJFAtnwZl0ys34NToDdnj7DWL5+9mfHjIuSVXftZ1LUt3WEDk/LwEtFex19OY58pYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743069406; c=relaxed/simple;
	bh=zUrgzpSQNOfRE1BK5AviML6Lbr8ZIc65GthosVQBKAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oro4dpT1HbjhEIbmIbfrsxTiNbGXgGpZcjpI5GbGaTQrnC7fuMVfKGZdSdJtk7OFyLr86hxo8QzatN+rTt+B23gdZgfP7W56AGPzDFiTGEPd6uiYTPxvYgZX9wenE+tCMQEIiNV3Mch0GwjVPMWj5JEKvbUEJkSpt9EFseVI+dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ckn3f088; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ac28e66c0e1so115669966b.0
        for <io-uring@vger.kernel.org>; Thu, 27 Mar 2025 02:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743069402; x=1743674202; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ePdlLrLJccLiAmHsJHAYKVqR1WObFD7ueRFukEzcaKY=;
        b=Ckn3f088LM5w9DoO2TuliDUYnEIe26hYxd+/8gelKgFiYyeusd7pgMREUFiKWC03oF
         AxdRctjsgay36FnBGmUGqTz5R5K1zw7FoQheG7+Uf06tJshhNtMlF3SZLA4AMFEkrDHe
         psVad/gyp4Cevf0XoFHHRd9cgjNNpqSWzc33D8SZ60rdy2SrkU++VuofOgYfHQlwIpyn
         hWDqKXtCWCraW3qyBf/6buC3/xc4ybiDeUgIV0WirQQPFJ2hb/M9x3c1HERkO9y0zHEi
         Q/rdK+IJDjkwPfNge0LSljwJWXtWGNjGhnGtMkx5jSBS+ory5gxKJysK9uJ0hdNnH/bj
         9g1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743069402; x=1743674202;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ePdlLrLJccLiAmHsJHAYKVqR1WObFD7ueRFukEzcaKY=;
        b=TFAdp7TX/blMaESVx99c3EQpu3KEKvT+zKkhDnxMw+0X+dRtrWWs46u6bNN7GbZE0c
         xCC/c7WkkoEz9JDcjiS7nv6uitC7FQfyrI/JJxzSRViJeMg8gaoH7Io2zfKp2IQMz58l
         +y1vAUicCHGHT9vzlU+b/8+4zAMudVOlgDG0t9lOwzYkzy/V7mcxZtTML2DSYIwLId1U
         68Fn28ju+1pgzhbHn32wrPmtVvXJ2DlS9STatRpVWs6V0ufPikbG4EAd77oGYtwuVWl/
         FuGRN35k0p9WQ/2gxwdZWMSmWEEa1SoHHJlxX1KIWSS3UVkXLTCLpGHO+lhSVB7ZgZC3
         lvuQ==
X-Gm-Message-State: AOJu0YziHwWK/ZBbnSg2PFVyElonC0sel2YMhOsFZMjgRtjGvxiTDCBT
	SAaiplheM00JTDAakmfc5gDfDIKc7bZFoVKQb6XI8oMj/K1YGCVzAVAOGQ==
X-Gm-Gg: ASbGnctm9IM3F0TJcQNOWXWZsmxmQlwn+Oj8l7eSM3orL8TfXLyiv5q0Q/vShA6EinU
	fQdgD7jaU5m8ut+DCleagTYRPMkrUphP1OYYjcCud86tayVH8LqEXzNOPdpgSS4gED8oNn2Erbh
	QpnshY0tH4Be8lTNN9yiYLWWLnVotZsjT5ngqIhQ9nJvXe7sHirgEmDMbVX1qqkxcxqVw6Xu1VQ
	376zTcGyXQ78q5yj5uNvKanats6+TyNGOzrk533Fa3akVNd10VzJCS2xHiP7kKC1N1dNreSO2iM
	npGTA7t6qCiG60b1RYzgDrGjGu788AhCwKP0MBw=
X-Google-Smtp-Source: AGHT+IFNQXjXgxCHWuPB4sbzpZ5nDH0HzHlGzNQAM/GUnY9IEtV3rMYIWNhHKyuBoOIlinvedXpVqw==
X-Received: by 2002:a17:907:1c22:b0:ac2:fd70:dda3 with SMTP id a640c23a62f3a-ac6fb100878mr212361866b.35.1743069402047;
        Thu, 27 Mar 2025 02:56:42 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2c99])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef86a13bsm1195387766b.23.2025.03.27.02.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 02:56:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 1/1] io_uring/net: fix io_req_post_cqe abuse by send bundle
Date: Thu, 27 Mar 2025 09:57:27 +0000
Message-ID: <8b611dbb54d1cd47a88681f5d38c84d0c02bc563.1743067183.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[  114.987980][ T5313] WARNING: CPU: 6 PID: 5313 at io_uring/io_uring.c:872 io_req_post_cqe+0x12e/0x4f0
[  114.991597][ T5313] RIP: 0010:io_req_post_cqe+0x12e/0x4f0
[  115.001880][ T5313] Call Trace:
[  115.002222][ T5313]  <TASK>
[  115.007813][ T5313]  io_send+0x4fe/0x10f0
[  115.009317][ T5313]  io_issue_sqe+0x1a6/0x1740
[  115.012094][ T5313]  io_wq_submit_work+0x38b/0xed0
[  115.013223][ T5313]  io_worker_handle_work+0x62a/0x1600
[  115.013876][ T5313]  io_wq_worker+0x34f/0xdf0

As the comment states, io_req_post_cqe() should only be used by
multishot requests, i.e. REQ_F_APOLL_MULTISHOT, which bundled sends are
not. Add a flag signifying whether a request wants to post multiple
CQEs. Eventually REQ_F_APOLL_MULTISHOT should imply the new flag, but
that's left out for simplicity.

Cc: stable@vger.kernel.org
Fixes: a05d1f625c7aa ("io_uring/net: support bundles for send")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: Dropped the assert for now because of mshot timeouts and polls
    ignore the semantics (but don't have the problem).

 include/linux/io_uring_types.h | 3 +++
 io_uring/io_uring.c            | 4 ++--
 io_uring/net.c                 | 1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 699e2c0895ae..b44d201520d8 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -490,6 +490,7 @@ enum {
 	REQ_F_SKIP_LINK_CQES_BIT,
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
+	REQ_F_MULTISHOT_BIT,
 	REQ_F_APOLL_MULTISHOT_BIT,
 	REQ_F_CLEAR_POLLIN_BIT,
 	/* keep async read/write and isreg together and in order */
@@ -567,6 +568,8 @@ enum {
 	REQ_F_SINGLE_POLL	= IO_REQ_FLAG(REQ_F_SINGLE_POLL_BIT),
 	/* double poll may active */
 	REQ_F_DOUBLE_POLL	= IO_REQ_FLAG(REQ_F_DOUBLE_POLL_BIT),
+	/* request posts multiple completions, should be set at prep time */
+	REQ_F_MULTISHOT		= IO_REQ_FLAG(REQ_F_MULTISHOT_BIT),
 	/* fast poll multishot mode */
 	REQ_F_APOLL_MULTISHOT	= IO_REQ_FLAG(REQ_F_APOLL_MULTISHOT_BIT),
 	/* recvmsg special flag, clear EPOLLIN */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ea684a17d01..4e362c8542a7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1840,7 +1840,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 	 * Don't allow any multishot execution from io-wq. It's more restrictive
 	 * than necessary and also cleaner.
 	 */
-	if (req->flags & REQ_F_APOLL_MULTISHOT) {
+	if (req->flags & (REQ_F_MULTISHOT|REQ_F_APOLL_MULTISHOT)) {
 		err = -EBADFD;
 		if (!io_file_can_poll(req))
 			goto fail;
@@ -1851,7 +1851,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 				goto fail;
 			return;
 		} else {
-			req->flags &= ~REQ_F_APOLL_MULTISHOT;
+			req->flags &= ~(REQ_F_APOLL_MULTISHOT|REQ_F_MULTISHOT);
 		}
 	}
 
diff --git a/io_uring/net.c b/io_uring/net.c
index c0275e7f034a..616e953ef0ae 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -448,6 +448,7 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->msg_flags |= MSG_WAITALL;
 		sr->buf_group = req->buf_index;
 		req->buf_list = NULL;
+		req->flags |= REQ_F_MULTISHOT;
 	}
 
 	if (io_is_compat(req->ctx))
-- 
2.48.1



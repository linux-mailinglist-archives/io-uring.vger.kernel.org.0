Return-Path: <io-uring+bounces-2705-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08F4194F246
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 18:01:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 970DCB259EB
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 16:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B24EF1EA8D;
	Mon, 12 Aug 2024 16:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hQMelP1G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D6E17994F
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 16:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478507; cv=none; b=c1gnnJ89CDfvR+NgPUIf1G2XSJXsWLWKmUcEI6EyZMCAjYo3qC4ABZzqzloO0LhME0dQltL3Y4TTImEGoLfWE4T2fI0xorSaVhF3ETAqEo+sHBf+y0jjZKUA0ymraozpC1xANJiQG+MnGUlFQFW0PVJ9+68SyCXtRbglSB0ZKAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478507; c=relaxed/simple;
	bh=KnbK5Hck6TwPUJyZ4Strl8CXcbAGeaz65ZIgVOBcJvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sB68aocezJSFyCSdaahX2GcZ5qABE/buJv+gyzK5BGKTX3e9xqBBAeiOpl8dNqX+jqDpL/lqNVt8I4SU6SjnmBZB9c/ezQuyOzMB9/iJwPAMgLEcUHnB6eBv3/QJjb+8bDRj9PWAU0oZ2STRsLKu0RA0MCI8RvqyJiwVEDAergw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hQMelP1G; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1fdb28b1c16so1828705ad.0
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 09:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723478503; x=1724083303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lnaBbZPK5LZwzpippfg4h9b8muDc6xLgjM+TAy1YSho=;
        b=hQMelP1G6r7chfBY7IW/EdDCCkBsXQrA06dmB3p/XntOz09eKqLhCTlMgzfhkahI42
         rz8KYUMbCj3ui8vaaS4tCOC1hrGtljJfgSZUFB1Ir0IX+4CZekwd7q5cqwP2NJJswPhj
         NRKG5nuoIuCoT4CPwMQN/AUInSGfDp2hPjuSa1acXFv7xyyGZ01glU0VDLCYhDHC5Dxz
         TecrnUXXJytaRr12yBVGIGmTNr3OrwRIHEmyX5SVz9W5IP9r5JV9T9TUoUAJ/7xwoMm5
         LhSII0gXN7wxgTrQK7Ajv6hFQD85FoChV/lR2q4d310Stq0lDW54mpaMURBsOh4D25qm
         3cqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723478503; x=1724083303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lnaBbZPK5LZwzpippfg4h9b8muDc6xLgjM+TAy1YSho=;
        b=f4T2jM4QF6t0gVETokRw3wj9Ro3wMnaa0h37o8V1zGToIN2DKtibaOWU5Lof/iExMf
         FhYV4nSnfjX3jdMDJ0F6awXL/ZAV5e28q2k2j88snN7McJJfw7B/cr3S2VQOmTGjHxqJ
         0mJ6SWh3bgrqOLAzg8ZKUFPJudw7FJrPg2iasLwz7CMUZhSE+w2CE2IbiO45e0Up/uhp
         quGLTiVFanDUv1pXm1+VM+LqydPq9crZKXHgRv4YnjHHcL/mVFSoG+IdWwYOtUD4bGC7
         BonrvrOPnX5acwpVGBSkTNNc/XCoVrfBxk90yccx2rqCmT3vVyfIMchpyQHHHl3hWshC
         fw7g==
X-Gm-Message-State: AOJu0YyMI46sTg9Bm+9vYW+VToRRzyIBXupdrToAA4WJaSWNv9SVDQ5e
	77TpZJU/InuscCNC0cc4ntL592FCHwCK3hRM3AiM2W3gXuX/VoEGRotgyLEHGB8l4bNA+3MYEYg
	6
X-Google-Smtp-Source: AGHT+IE7qCQaEr4JpsEwOrGewsuh3I1c/NMDB8bF54zk12SI4Z+lNVa9h8CrWyrW2XitcIGqvlrY1A==
X-Received: by 2002:a17:902:ce87:b0:1fd:d4c4:3627 with SMTP id d9443c01a7336-201ca1bffa8mr5004155ad.6.1723478502613;
        Mon, 12 Aug 2024 09:01:42 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb8f7546sm39749705ad.77.2024.08.12.09.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 09:01:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/kbuf: add io_kbuf_commit() helper
Date: Mon, 12 Aug 2024 09:51:12 -0600
Message-ID: <20240812160129.90546-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240812160129.90546-1-axboe@kernel.dk>
References: <20240812160129.90546-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Committing the selected ring buffer is currently done in two different
spots, combine it into a helper and just call that.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c |  3 +--
 io_uring/kbuf.h | 14 ++++++++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 277b8e66a8cb..5e27d8b936c2 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -171,9 +171,8 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		 * the transfer completes (or if we get -EAGAIN and must poll of
 		 * retry).
 		 */
-		req->flags &= ~REQ_F_BUFFERS_COMMIT;
+		io_kbuf_commit(req, bl, 1);
 		req->buf_list = NULL;
-		bl->head++;
 	}
 	return u64_to_user_ptr(buf->addr);
 }
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 2ed141d7662e..c9798663cd9f 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -121,15 +121,21 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	return false;
 }
 
+static inline void io_kbuf_commit(struct io_kiocb *req,
+				  struct io_buffer_list *bl, int nr)
+{
+	if (unlikely(!(req->flags & REQ_F_BUFFERS_COMMIT)))
+		return;
+	bl->head += nr;
+	req->flags &= ~REQ_F_BUFFERS_COMMIT;
+}
+
 static inline void __io_put_kbuf_ring(struct io_kiocb *req, int nr)
 {
 	struct io_buffer_list *bl = req->buf_list;
 
 	if (bl) {
-		if (req->flags & REQ_F_BUFFERS_COMMIT) {
-			bl->head += nr;
-			req->flags &= ~REQ_F_BUFFERS_COMMIT;
-		}
+		io_kbuf_commit(req, bl, nr);
 		req->buf_index = bl->bgid;
 	}
 	req->flags &= ~REQ_F_BUFFER_RING;
-- 
2.43.0



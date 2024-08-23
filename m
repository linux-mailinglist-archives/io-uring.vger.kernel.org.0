Return-Path: <io-uring+bounces-2918-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E60295D06B
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 16:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FCD31C21318
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 14:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E0331EA84;
	Fri, 23 Aug 2024 14:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NmAbG0mK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9541DA4C
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 14:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724424702; cv=none; b=QCUM4gPe57BeguS/Iu+Ht/sXK1ZYEpm+hTSO8sYz4eKNnP87TYGfFi0Uguy38IrR1F+eOci3wjH5JoiOafb6Yq4mcnEjBTikTsoeWkF5djfmhTAGcWOWFRoTzmxasj8lxcy2jYKcAKjtMxFV5BoAaZUeBmuSpLd0SwmOJHi3PGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724424702; c=relaxed/simple;
	bh=ZVnVbV1eCvFCcWr0EGQphtReu+UcBoC7+WhrwT69bnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gc+vu5Fa6J4Mk1h4ThqQC4K1Mjw2lqwROKV6n2tQXS9XoRwiuE5f7gsR/niUtLI6qUpbXMNvEi0rvpu5UX/pDOMlr9aIbs7MFr9wVy0xJGinmMKbQU38F5Ha9qZENtq16oNVJuvtHdYsQc/ZtRd/q+rcrxJzz4SvNcLUV1CCn2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NmAbG0mK; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-81f905eb19cso108126639f.3
        for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 07:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724424698; x=1725029498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sY/+cRD+7257nn9FuWVO70N6t8I0+npFIitfiMw5ZeU=;
        b=NmAbG0mKnMj3EG1SS63teQSYnDXXrIHiiufjTQQGFCwr0VzLl1Hp/i3j8LZJxj+Fbm
         nsWP4hG00uJIv/cUhxJObPpT48l+vRGRetzfU8nhwlqo4FDgVc8IwvnA3Ph4wmwWA1YM
         FSjCz9K9ezqi0bftfEhTM1MGrNfb3HNl240UO//A8VdTP3rGnv/tQ3lQxCfL5zV96qrh
         f1b3k7UpwvXtXdbUqYu5GSgl4A7x3tMAMcwujCeDJrI5Tj/aZPVpmd16mF5TA2mOZVRo
         507hAOCcRnz9ehUf98e2f5i2qkUVnFWOjUekDuK+wx8fKOmgsHTOVq91QiHWgDp4Cm4O
         GYxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724424698; x=1725029498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sY/+cRD+7257nn9FuWVO70N6t8I0+npFIitfiMw5ZeU=;
        b=X4upIiDkPXCePoCTj1y+dDG5K0ssmbWIApDXmceJTXvs7/1XkXbH5GBSObjf5UPOZY
         6xa0qbLE5Muy8YN9jm8TnzTcPpDOEOXhyvtUKIqt+DYU5KJ+Nob6SMFfIqrBiopxQnuS
         yXbZ+kw7UaxQk0lVYCUuCcIcbWR0OgejK7CKjpN/3mo6eRVRstGVpaxd7zUPUHhY2uco
         Z8IEcgmZ0vZ+xxH8+KdMXmqlNyaoSpkVQXSDyNrEYRS5k9TfCLrM0xK0B2sU/id+rqDU
         SqIMlxWfE9qhqZUBiOK3ay7xdz8q+2jgb3LqoGTkiE5zhuQ9mDY0CqqFlUhMe51hIq3G
         AddQ==
X-Gm-Message-State: AOJu0Yw7FFRxMXjiEMyl5h7hQQFu9TYRaBSzgvuMyXI4XjGHItXDEgld
	JdIVss8NauaBOmP7C5E7abJkr5dAjaBP8iIKg1RxBvKX4nHBT3kUDTifqv4UzCsNz/8JIMzVvVT
	O
X-Google-Smtp-Source: AGHT+IFZXAOaAqFzfwYRVcz1rTHrQu8raxC+Y4O1L9HySHhaHvYdaZFRiyTnuItVdeVY1vuFFWuhtg==
X-Received: by 2002:a05:6602:6b88:b0:803:83c0:6422 with SMTP id ca18e2360f4ac-8278813bc2dmr177678539f.9.1724424697783;
        Fri, 23 Aug 2024 07:51:37 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8253d5aa137sm115039939f.11.2024.08.23.07.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 07:51:37 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring/kbuf: add io_kbuf_commit() helper
Date: Fri, 23 Aug 2024 08:42:34 -0600
Message-ID: <20240823145104.20600-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240823145104.20600-2-axboe@kernel.dk>
References: <20240823145104.20600-2-axboe@kernel.dk>
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
index a4bde998f50d..e43f761fa073 100644
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



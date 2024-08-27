Return-Path: <io-uring+bounces-2958-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D5209611F5
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 17:25:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54BD328138D
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 15:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C3061C8FDC;
	Tue, 27 Aug 2024 15:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TO8+oO/s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576BB1C5793
	for <io-uring@vger.kernel.org>; Tue, 27 Aug 2024 15:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772308; cv=none; b=DoNX9gk8bBUVywrntnt12jQSjsMAv3VRnuCboozqia2qWW6oUycTvOr9J62UW0VzWh6fhW28209Q4vprUHBIKMut5Nhn27SRn+5DwKd+fDxGL6k56RBMMT3NNHbgyH7na7/bOgd3LgpTn7/uo4XI4ebtoOvYxOHBVUIxesiVrew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772308; c=relaxed/simple;
	bh=0jZi558aWZcSDcT/7S4KInb4/vAWfH0yjGSS1wU3Nwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+vOmKTBzmNYFL2VHnCvr8Jsrp1W4Pb/WXhBReDVtGV+UGX27X0ZZasuokjH5qE8eeDp3LH/2a9R4UjKDjgJzDfRpxcQJ6t4F+fmFAPuHO6mEO9So98n0igl45zFlhkcR27/XaoTCNCjZ2dFznRw3Wos3TgeHVnkIt+QJDRB3r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TO8+oO/s; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-81f96ea9ff7so282496039f.3
        for <io-uring@vger.kernel.org>; Tue, 27 Aug 2024 08:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724772303; x=1725377103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gxJ8fAaqK7lBS0lsOZ/VIaF2xF3Oms1pyKaM115RzI8=;
        b=TO8+oO/slziUQ3W68h/wbEn+i50CYxVqYiOqfnQZ9b1+aKysIOaE/idpbjx4N+Bbhk
         ePZbhJO43KPVB6ucvBNjvGn38TIODYbNF3kzlepTU9AlgnnQAO77RfowOCk/TKNphb16
         gxPtNk1to7DanBnf/HgDpOWQZSusHkcfMjSKnR3Fms9AxubWAEsOdqOFprgJs6AuYsIb
         OlxXjxBwYmvr7E8Ue+zu/I7yl5LPAUNlvI8lAt65OGC2fttVviSJGOQKkZQ0mV03NL9r
         BQHd2twGiF9UNnAA1/aL9jA7W0j5VZqOyu6wcZgp3XjrjHotdkdQJ+qyKwGHMCo74ocp
         MZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724772303; x=1725377103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gxJ8fAaqK7lBS0lsOZ/VIaF2xF3Oms1pyKaM115RzI8=;
        b=JQR4za+3+IMoDcq7ds4+DySbLxhFqt9PmMZ3MGiCb15SgjenkWSsTaayV5VUcVcy6l
         otP8grRfmuj/bLacZN+iAP/hqMes+Ersu+BG3TMmcT2xrmICWzZ6yfoHao9Yv3lt2Qxy
         4jPYAWnUY/J5IP71DEzfPoIuE4kjVJyDf3m3oKOwAvi5ncKkayvXS1oN2jhtgwWCJMoX
         rLLmIe+aDtR0owntwU1LFk7ymg2+rF5sdl5jv8ihai5dOS5fVi4mI0sVoOOGiS2m/mvk
         npqi1xiYRKMP/2FZds271wHv+qxcLb/qxV72BQ/O6aosMFV6TfX3bCyYc4hmCWJW89bI
         862w==
X-Gm-Message-State: AOJu0YyEhk51PE6eu04WZzjz65rNB2nX7+cjw1mAMh3J5fxb9oPqMD8M
	aW4lQTr/oFNfPzBHMJWJlKa0XVccuynJGajfMPidAHgXpF8EJAq2MNO5HOFWVsm3WqHBqh+gYYn
	r
X-Google-Smtp-Source: AGHT+IFAwz7+V3ux+AZP5NMNbT+RO075NiWrJ2uRV1TPhoc6ml38O0lfPveTa/zZgfLHD6HySAIAMA==
X-Received: by 2002:a05:6602:6087:b0:7fb:87d6:64b with SMTP id ca18e2360f4ac-8278738a54cmr1939937139f.17.1724772303082;
        Tue, 27 Aug 2024 08:25:03 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ce7106a4a9sm2678580173.106.2024.08.27.08.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 08:25:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring/kbuf: add io_kbuf_commit() helper
Date: Tue, 27 Aug 2024 09:23:05 -0600
Message-ID: <20240827152500.295643-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240827152500.295643-1-axboe@kernel.dk>
References: <20240827152500.295643-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Committing the selected ring buffer is currently done in three different
spots, combine it into a helper and just call that.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c |  7 +++----
 io_uring/kbuf.h | 14 ++++++++++----
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index a4bde998f50d..c69f69807885 100644
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
@@ -297,8 +296,8 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		 * committed them, they cannot be put back in the queue.
 		 */
 		if (ret > 0) {
-			req->flags |= REQ_F_BL_NO_RECYCLE;
-			bl->head += ret;
+			req->flags |= REQ_F_BUFFERS_COMMIT | REQ_F_BL_NO_RECYCLE;
+			io_kbuf_commit(req, bl, ret);
 		}
 	} else {
 		ret = io_provided_buffers_select(req, &arg->out_len, bl, arg->iovs);
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index ab30aa13fb5e..43c7b18244b3 100644
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
2.45.2



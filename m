Return-Path: <io-uring+bounces-874-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DED4876DFC
	for <lists+io-uring@lfdr.de>; Sat,  9 Mar 2024 00:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F2351C2204E
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 23:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 583883BBCA;
	Fri,  8 Mar 2024 23:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mkcC12gk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53EF3BBDF
	for <io-uring@vger.kernel.org>; Fri,  8 Mar 2024 23:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709941856; cv=none; b=u4bwd51xyqL04GAgXlop6njayfxYCc4psS3iIIi9N2xWtMRtmqp9ybZZ4vL8+xqZvC6+/jDkto0h/H1qRMja+5EAxsOKwrqwNF475gQY3IPGyOp8ZCblZ+t6YomaFSLCdR1g2/8r6ezXnqYysrFG3yoIPh4x68WZpdUQ7CMAERc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709941856; c=relaxed/simple;
	bh=4Q6R8xVCik3yzlK0DhRL2MHaQ/Ad0raM1vf3CjKXmXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0kaPJ2xavEukRx/SSW2gbUZjYZbcfnKa3oDz38MptUIjzp0U2KipNt/YCN2u1VrFOaW6BrTjnIWf6Une4L1Hy6KdGjhQIeGK/w9VDRI64dHIjGA1/DRHBvt4vdGv4oJpEEdGpaVAuxm4SzfokeqwscW0XGezgsVafPHLO4DZgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mkcC12gk; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-365c0dfc769so2589355ab.1
        for <io-uring@vger.kernel.org>; Fri, 08 Mar 2024 15:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709941852; x=1710546652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GvCNhknm47rc9v0dpdXxe2vqVN3pKt3FSisRp7tfah8=;
        b=mkcC12gkJzlgdlpCXarVQeZXpikfLm0LlK2Wjs6ntd8KZF3VJ3cvt9czc2ltkTdhNU
         YnVju17ydMx531L4LWTvNFQSqWn63wyr3mu+CAe4DuXgadABxhqMDGqnser1NOdCYjr9
         rGvxF0taAIj5BUICj5KYWvU3NrpsnlzshUW2P3OAximK1iJgQDm10Wr7kU1fDH08934h
         vMlDStF7YmbjMgPj0+FqBVL65uKrpy13CRUqW4YKp9IJWzcI6UPwRPgTyJJKw22HaisT
         Si+2ag4umx9cthPeDIbSpAjBy188KxUAY9Fxj88q5c0V6TDlQfGGa2QItB35jqnUMIfG
         NMGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709941852; x=1710546652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GvCNhknm47rc9v0dpdXxe2vqVN3pKt3FSisRp7tfah8=;
        b=tUV4U/6eKBxrt5eVIrwxYmfKqNXmwoO1h9aZw6GUoRg1HZqRWj31PJQQZWyYbp8/Dq
         Os2QASjbLVywx1kfKeuB2zR/biTbrx0YDAOaNinqiMG/HgQr6SJLIB0sx8xt6SQVx2Ml
         0GNR1gtXi+GuvxlsPpWNYYe8TO/DYs81bjmBtAZ/gHH9jB8hcVDWHHqsmGgbXDJi1LnO
         Q5Q03LcRgO/eLZLgoOu3mafcdr9IKhOpChwU0mK1LCqHZW5ayC51Po082iOlAz3MpOyz
         +Hel99cOnIEQRFTV9hSq5/R9MrMndQB8SoCr4pZJxyiu5TKHBcPZMSTRvmUzxTfIgjWS
         U3CQ==
X-Gm-Message-State: AOJu0Yx9dinhaIp9cfdJctKyW65hUgjq/0LNDKcdF9uxxA+oGtbT97Vl
	VzGEczu62Wj6nUgaAFRittDpoDWse5bw7YRqq2sQUccAaSJ5tmK8rD8mwmAG7aUFGUsh6hJHVg8
	2
X-Google-Smtp-Source: AGHT+IH+1O84dXv01XL+WGV0yumMzFF0IRDM99aujGEvQSLdqKzzhKXMnRNh+9l1pGRWp/JLdbrD1A==
X-Received: by 2002:a5e:df01:0:b0:7c8:7d0e:f240 with SMTP id f1-20020a5edf01000000b007c87d0ef240mr486807ioq.1.1709941851911;
        Fri, 08 Mar 2024 15:50:51 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a13-20020a056602208d00b007c870de3183sm94159ioa.49.2024.03.08.15.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 15:50:50 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/7] io_uring/net: add generic multishot retry helper
Date: Fri,  8 Mar 2024 16:34:06 -0700
Message-ID: <20240308235045.1014125-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240308235045.1014125-1-axboe@kernel.dk>
References: <20240308235045.1014125-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is just moving io_recv_prep_retry() higher up so we can use it
for sends as well, and renaming it to be generically useful for both
sends and receives.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 19451f0dbf81..97559cdec98e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -191,6 +191,16 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	return -EAGAIN;
 }
 
+static inline void io_mshot_prep_retry(struct io_kiocb *req)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+
+	req->flags &= ~REQ_F_BL_EMPTY;
+	sr->done_io = 0;
+	sr->len = 0; /* get from the provided buffer */
+	req->buf_index = sr->buf_group;
+}
+
 #ifdef CONFIG_COMPAT
 static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 				  struct io_async_msghdr *iomsg,
@@ -668,16 +678,6 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static inline void io_recv_prep_retry(struct io_kiocb *req)
-{
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-
-	req->flags &= ~REQ_F_BL_EMPTY;
-	sr->done_io = 0;
-	sr->len = 0; /* get from the provided buffer */
-	req->buf_index = sr->buf_group;
-}
-
 /*
  * Finishes io_recv and io_recvmsg.
  *
@@ -704,7 +704,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
 
-		io_recv_prep_retry(req);
+		io_mshot_prep_retry(req);
 		/* Known not-empty or unknown state, retry */
 		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq < 0) {
 			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
-- 
2.43.0



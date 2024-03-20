Return-Path: <io-uring+bounces-1153-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 25509880909
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 02:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 821511F243EB
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 01:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E4F76FC3;
	Wed, 20 Mar 2024 01:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OIfpdRdp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A502582
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 01:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710897796; cv=none; b=A9KBVSJu8ZIiMtQUf1OYhe9rscq25K0IqBI56ZNyMhSWVOz3rR2+KBYtQcA5bQSye2WGmd3yjrjY7/NcNpJRkOs+gg/7bIO4meVuwyIvSIAjaWeT/Q2mduKVR7TPqnTVbduYK3avEGqOjOlf5vhN3IxdO46k/5ki7u7iUqm3ZbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710897796; c=relaxed/simple;
	bh=b1Yw6AjBrKmLiNE5M50xDp0rL+hd2Brg3TM+ahttebo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCR530dXDajVoJJ6MRl0wibBY/XYxoWf77yOxmrI0+eMOGRtdwKDH1zA2odXunALTNtCcIWbDIJEvM6w2PJ7ul0sHWeT0UIU8eG8qoFHmU5YEQXtWXf8AMdIVAuJ9F/rrHFwuf3RkQEbkfgHuCaEpolOq8r2jcYf4tgOv9Oqsmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OIfpdRdp; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6e2b466d213so95532a34.0
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 18:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710897793; x=1711502593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=koYr3HDB0x7utiFY+HyI/2RGEMP2Y2Hy5qqDdHyPb68=;
        b=OIfpdRdpU5wTe/Ixh8XuP2DOR1mxkT7ZEcpvTb7EuGPId3IEo9O9q751hKqZTk6NYg
         vvniGYvU4CcQFoLnW80bk/jhcXzSFhn7fdGvnLBfCVD2QQmSjQNRtVYjkGwG6lW+LTLh
         56fmCBYNxIOZlij6sYfyxsphUTQjg/+NxX0pFYq5Rmvf9AF0JIfdZYJqH7H1jGt20veI
         DB/sI3t1Y8LPXwdz1zAPgFsLsZq+VyNiWdHfCOzkIz6ivNLbHXZbaovym+QqnaT2YWsv
         9t67+zMv1vKqmS9LcUHbUOkR3PO7QDhOml1CwAaS7HhJNJ5jLBGc3SqqgkWTpW/w/MdO
         W6eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710897793; x=1711502593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=koYr3HDB0x7utiFY+HyI/2RGEMP2Y2Hy5qqDdHyPb68=;
        b=s+2vBpsXi7dGLwX5i0So+3meeRB2La/67nKfI+vQ9rfwiDuYEZ8fkb2soKzGWsSr3q
         rUcRCW9VDZaHBc73+QPFGIYhd90PQ6RLRNrl9p9z/QYmgBC5s5mpuR0VqIRFWqo8RRTk
         oUcLX0kGu6KRm8urV3X3+IZN+leBrbAnKPFkpLLHBRENQJ8GbI01LUNMHqKy0xNoTSrn
         kVUuqSBbDo0gRr6qf6J5Fs5aLKo8kBDR6owwpIwQcwya9Enh3sDr3SDxqkxiUGcNgty+
         R3aYWK8I1E172qBSBC4ksI+NkvEzmgzUxumtrcC4Xn1MRZxHpsQbK8CmOozechiL+HMR
         I6Pw==
X-Gm-Message-State: AOJu0Yy55jLhQhBwb/MONpPLsVZeF6MHlQ/Bon9Il25zqXuLUqAFhqGI
	s6aFHmXITqOxOFTL/dvhzXXvu+ebYtAYE8F4nVfM3QSt+ZY4SHixC11HMpQRGiQxNut7AA3N2fZ
	T
X-Google-Smtp-Source: AGHT+IGxOrEBCX4a13yMrIxFpobyXOz7SJaqskBMYMIVeuNtHrzFbuwrdgnA4g21lHeqaHkIPLeSsQ==
X-Received: by 2002:a05:6830:443:b0:6e6:a019:347f with SMTP id d3-20020a056830044300b006e6a019347fmr4077045otc.2.1710897793671;
        Tue, 19 Mar 2024 18:23:13 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm9618007pga.75.2024.03.19.18.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:23:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/15] io_uring/net: drop 'kmsg' parameter from io_req_msg_cleanup()
Date: Tue, 19 Mar 2024 19:17:37 -0600
Message-ID: <20240320012251.1120361-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320012251.1120361-1-axboe@kernel.dk>
References: <20240320012251.1120361-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that iovec recycling is being done, the iovec is no longer being
freed in there. Hence the kmsg parameter is now useless.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index bae8cab08e36..82f314da1326 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -407,7 +407,6 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 }
 
 static void io_req_msg_cleanup(struct io_kiocb *req,
-			       struct io_async_msghdr *kmsg,
 			       unsigned int issue_flags)
 {
 	req->flags &= ~REQ_F_NEED_CLEANUP;
@@ -453,7 +452,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -EINTR;
 		req_set_fail(req);
 	}
-	io_req_msg_cleanup(req, kmsg, issue_flags);
+	io_req_msg_cleanup(req, issue_flags);
 	if (ret >= 0)
 		ret += sr->done_io;
 	else if (sr->done_io)
@@ -505,7 +504,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		ret += sr->done_io;
 	else if (sr->done_io)
 		ret = sr->done_io;
-	io_req_msg_cleanup(req, kmsg, issue_flags);
+	io_req_msg_cleanup(req, issue_flags);
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
@@ -713,7 +712,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		*ret = IOU_STOP_MULTISHOT;
 	else
 		*ret = IOU_OK;
-	io_req_msg_cleanup(req, kmsg, issue_flags);
+	io_req_msg_cleanup(req, issue_flags);
 	return true;
 }
 
-- 
2.43.0



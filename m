Return-Path: <io-uring+bounces-7441-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6C53A82675
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 15:41:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59AE119E1491
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 13:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F14B7264A76;
	Wed,  9 Apr 2025 13:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RenqEk3j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10D225EF89
	for <io-uring@vger.kernel.org>; Wed,  9 Apr 2025 13:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744206068; cv=none; b=l/XhkNbk1dcbHLwv+V+cwxvT+Cz8Zn116NJnuvG6+a7lIz0g3MNxLilcr5c7CIGsc7SelLpRot3bMMMs61KphS5fgeLZc7tiyGgLEQlWLvWbrtNZ9ow38Ad5fTN0+zEOooME+11pnqjqxUfOUbsU5nHxiCSeGDMde5cIeE3WieU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744206068; c=relaxed/simple;
	bh=3scP3JHTuKX1LZ4+gl8oT4+aiKvSKIdIVZ57eA9iTDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UyzRD5mseb7y55KbqPlq1pOOuQSgYIn38JlfMGHtdamTU5/DWyMTx0QbVcgOkEYlMc57HpJWUWx05fEpLuIREVeRuopNWFffPHVFldOWtVlEI4rezvukn1bB/If6rAz3eE9kcvfnwpwsh+hsmMG/zGEchNyJbfklAqne4UNcKDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RenqEk3j; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-85e1b1f08a5so154528339f.2
        for <io-uring@vger.kernel.org>; Wed, 09 Apr 2025 06:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744206064; x=1744810864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U7pPynJaQneGDwKYEd+0PbGH80xVi4jqqdOU/lGU1TE=;
        b=RenqEk3j0y5ZB3ukjFNp7ZntxRdplKt0NDMahUueFfhMOhQm0nUgL41gzz8J41KJDp
         qH4vYRnpNh9nybaxnmCQd9TzdmoZNRHJslFVfna/Wk5vhQW6aEwAEpthDttEucT0njlC
         mdH7P0IX+PSZHo7az94zDQx4q+w9dyO99jy9D468fvOjH6XhJFesC6Krg3anEy2PfrYh
         gG0WHoQ070bof3d3jTRULwsusG9QVJ8PjgL+8627c7lWwvuZXbsJ5sXg3p6OMVUThVaV
         Q5oDDYUBpyxJI6xps5OKTADPn+wDwv+BYn8CwhidmJ2r9Xkbrdt1sSTyFRDoODlsIyWw
         VCXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744206064; x=1744810864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U7pPynJaQneGDwKYEd+0PbGH80xVi4jqqdOU/lGU1TE=;
        b=Zud/2E0I6sYcTyMIMA8I86sM4KdYAV933cQx5C6vmyNoi6LDWaGL4g1yVhrZ4ycpJd
         rqi0C670jxv2LDWEJ6he1ZNoSN/HaJv9TyegYzWLvyaQoELOTbh3WvnwKhQaI14INWBX
         9eVstrzD7pzAREzS32lbAH+NZbmxfZ4luP+5f/dZHOOLhgdpkM+bMDaMS4QJZ48EnWAD
         CD/vyAk6AGFMnFwMkNLE/yvFF4SIsF4nBnLSOgOt0LiLVhVoEvw0hTutWT29XItFy4Am
         5JHW4tp7FSzTlkM74ype+Qn+yV/HOgDp+oGQRUy0jURbxKGhpIJb5lD9/Vygvvg37bmz
         Cm6A==
X-Gm-Message-State: AOJu0YwLohVAfRbJtGzkGruWJjvKN8z8TC1+PrQI1fZQF3wd0rkrViPE
	ZV6AEG7/KqN+ZJWksxMQPEpGK7PBwLq5vJtiYV7ulurbWET6srJ2IWhYU2T8fslVjnIlfVrSa1l
	G
X-Gm-Gg: ASbGncu5JwXsZ5RQHgYjTE66buQx1HzfKy7DTJCLZfskNUPTzW1T3alHibckIV+EmSw
	DNx+qoaJ5a6YWmUn1agBQByh762eL9yGYwOsZE6HkiHEDmqmdA2f8oNMuSqgsMd9RblEw3vQdYx
	pky14rcNxHV+JD7vi8Wtk0FMtgYhwoIbV2Hv6AlEC25LH/wMne70cHEECRLOfv8ukKe8DsHX6g5
	YGvuOnqgX7QYXdhmfcbr942XRs2bRVa0GoDv/YxkwZpKd4eFDQZrdDkylq/p6/Fxoig2wsOodr2
	y7mKSUS8Rhj3x1VvMxurIhIW0yi4aLddOccn4zSskqCD
X-Google-Smtp-Source: AGHT+IGc8av/+BjU0ISRwrY4urN6ol/l4Tr3rEkGJdZOwGQ9e/may1bZRc7w9EEl9F0YL9kZtdqp7g==
X-Received: by 2002:a05:6602:b97:b0:861:1ba3:cba4 with SMTP id ca18e2360f4ac-86160f544bamr272566239f.0.1744206064440;
        Wed, 09 Apr 2025 06:41:04 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e2eaeesm242546173.126.2025.04.09.06.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 06:41:03 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	brauner@kernel.org,
	linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring: consider ring dead once the ref is marked dying
Date: Wed,  9 Apr 2025 07:35:21 -0600
Message-ID: <20250409134057.198671-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250409134057.198671-1-axboe@kernel.dk>
References: <20250409134057.198671-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For queueing work to io-wq or adding normal task_work, io_uring will
cancel the work items if the task is going away. If the ring is starting
to go through teardown, the ref is marked as dying. Use that as well for
the fallback/cancel mechanism.

For deferred task_work, this is done out-of-line as part of the exit
work handling. Hence it doesn't need any extra checks in the hot path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bff99e185217..ce00b616e138 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -555,7 +555,8 @@ static void io_queue_iowq(struct io_kiocb *req)
 	 * procedure rather than attempt to run this request (or create a new
 	 * worker for it).
 	 */
-	if (WARN_ON_ONCE(!same_thread_group(tctx->task, current)))
+	if (WARN_ON_ONCE(!same_thread_group(tctx->task, current) ||
+			 percpu_ref_is_dying(&req->ctx->refs)))
 		atomic_or(IO_WQ_WORK_CANCEL, &req->work.flags);
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
@@ -1246,7 +1247,8 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 		return;
 	}
 
-	if (likely(!task_work_add(tctx->task, &tctx->task_work, ctx->notify_method)))
+	if (!percpu_ref_is_dying(&ctx->refs) &&
+	    !task_work_add(tctx->task, &tctx->task_work, ctx->notify_method))
 		return;
 
 	io_fallback_tw(tctx, false);
-- 
2.49.0



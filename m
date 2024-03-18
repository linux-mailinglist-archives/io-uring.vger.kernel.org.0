Return-Path: <io-uring+bounces-1064-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08E2E87E14A
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:43:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8EAE282E27
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CD11DDE9;
	Mon, 18 Mar 2024 00:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kr+kJSgH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6491CFAD;
	Mon, 18 Mar 2024 00:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710722623; cv=none; b=eNLGS/FL4gTNrJpi/MVmbT/LSGeLsJAK587jcMvCSoQ+kw+pME3RHdIlNhJ/IqLrnPBK9YmhGPcqPbu1o7jZWRXc4JNv7jj1xDIHEugp20vZviKxPoJMk4L4YM5odgWhMvAwhw0pdvVDSRCx9CLGJL+05JWyIdyVZ6/jSJIrR/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710722623; c=relaxed/simple;
	bh=YMGi35BAzF26VICJT9FSWmE/3j00VQwimSvy4GbKuR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYN06dMn/ultWFqx+C3f82LFNOvCuwoGZj4whZHmXkIXOGWin+LRcbO+TVUTGNiEtjsvTHEiOSOdb88LitSbbYKfHaRWBxXT7Qzyr0tT+AG5AqNYxONqilXYq/vVcM/V/gptLGEFSgYyTsBRjARJDlMTvOtNSJ95xUWE+DwVshc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kr+kJSgH; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2d2509c66daso55018531fa.3;
        Sun, 17 Mar 2024 17:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710722619; x=1711327419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H9WedqTxnnip3tXkbNwAUX++IyECvsw3O+o4OwI+ASU=;
        b=kr+kJSgHo+XbggDqYo6DTxIUSYDGfOdIkzV6rzO9kzFnxWb1YMcvyvvInOixCOuczI
         VTucclpIgEw+uMzA09MH71udph002N50l2bQ7+o3228pOCq4iL3fTxR5KG+9I8V9D+gd
         GIu86wkPck2BWTuPjMnUoymVZLzOW1mCrnIwlykEVu7V5fwwCIxu9kj9ACUG8UrS6lQ7
         C2gCUcm09TWQa474m/v3jkv/wFrXFljKKdUOi7xxtVyD8cF6tcNtI21aPoMMJYTA32H4
         0G70LAj1EmsZCTh6NLr1hC1EIVdVlBtURV4dzRF3ZCA6x50KNuIQtaf0JFk+wLnHnJzg
         KATw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710722619; x=1711327419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H9WedqTxnnip3tXkbNwAUX++IyECvsw3O+o4OwI+ASU=;
        b=MlaOO21HFFgT6+fq13q0KpqUdJncgcnZbSzN6f3NSrnjgU2yQOvawrkBuaizQ/vpnR
         FkU5ghx5z0mZJ6UtJ7IuXMjAnlB16VtDUAIOz9O/AO/Z4JPIRMwk5ZihAId+HcCFVzYR
         H5ITG4rRKXCPViNuxHa6mTHJzawTInZO2VOwG6TfLTlW/JALwAmzFogsGm7YzkiEJ77+
         uSVNtYAulACwHVrSXNqSLlja5pb9uLlJj1NtviY4SbxFIZ64OFjmi/dAH3UB9X78QXKc
         VHT4607IChGFDCr26OLD2C/31i4EU0zPOOnoccHwKOJleTG7aq3EqyCZXhps4CD3rYMf
         9K4w==
X-Gm-Message-State: AOJu0YygU72KkPFjRyz8qyTRBKjg5eOdiln2TK4GRdo9PJMzMFEYLSu2
	pZbepmRcE7VS2FKUiKqdYiiqp6G0NgccHrM3FMmjAaThExwuIzwKj3gh9n7G
X-Google-Smtp-Source: AGHT+IHWpDHvih4EBQ8dEG8gLQiAomXc95wFNR0A/ArxIHisTUp/e/imKmv+M9ZS9ryIuhL/SHxEKA==
X-Received: by 2002:a2e:9396:0:b0:2d3:ffa0:8782 with SMTP id g22-20020a2e9396000000b002d3ffa08782mr6736034ljh.43.1710722618482;
        Sun, 17 Mar 2024 17:43:38 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640243cd00b00568d55c1bbasm888465edc.73.2024.03.17.17.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:43:38 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 02/14] io_uring/cmd: fix tw <-> issue_flags conversion
Date: Mon, 18 Mar 2024 00:41:47 +0000
Message-ID: <c48a7f3919eecbee0319020fd640e6b3d2e60e5f.1710720150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710720150.git.asml.silence@gmail.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

!IO_URING_F_UNLOCKED does not translate to availability of the deferred
completion infra, IO_URING_F_COMPLETE_DEFER does, that what we should
pass and look for to use io_req_complete_defer() and other variants.

Luckily, it's not a real problem as two wrongs actually made it right,
at least as far as io_uring_cmd_work() goes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/eb08e72e837106963bc7bc7dccfd93d646cc7f36.1710514702.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/uring_cmd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index f197e8c22965..ec38a8d4836d 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -56,7 +56,11 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-	unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
+	unsigned issue_flags = IO_URING_F_UNLOCKED;
+
+	/* locked task_work executor checks the deffered list completion */
+	if (ts->locked)
+		issue_flags = IO_URING_F_COMPLETE_DEFER;
 
 	ioucmd->task_work_cb(ioucmd, issue_flags);
 }
@@ -100,7 +104,9 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
 	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
 		smp_store_release(&req->iopoll_completed, 1);
-	} else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+	} else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
+		if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
+			return;
 		io_req_complete_defer(req);
 	} else {
 		req->io_task_work.func = io_req_task_complete;
-- 
2.44.0



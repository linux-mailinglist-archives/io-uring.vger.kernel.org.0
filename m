Return-Path: <io-uring+bounces-2560-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7241F93B01E
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 13:10:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31C97282285
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 11:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5FE6BFD2;
	Wed, 24 Jul 2024 11:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="isZNJSIv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B572595
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 11:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721819415; cv=none; b=lRtEeyEa7VubK6SQuuDZyzhazV5oxaHIAQxAOb18fZDq82C0Rk2XGxIDBrCyLF0YYoGzqbhk6abliFg7vTXHbJgGccOKZRcr4k/fzPpHzR3wG89IJgXFmTWFrI90tT6z9Bi3K76Jv3pVdtcsZNTM/n87yFJO6L9oJZUckR/bRFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721819415; c=relaxed/simple;
	bh=ijCSMg68THOCcAmhBI0l0+D8DfzcsEl+lQbg1Bx+lyo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QNEyJosrqj8GwwmA7NUOjcxXixaSBHUCyxQX0tzHVLekE5BNhw4bHP3suhkqsSpg2Wc6SABWBN/ute+wMaNWwyT15Ti4UaisCuRLm7VKT/Jb3jmOCou1tuZtAmT02vn7bHX1mUTfbXi9rISEVS6SCjycLLyVq9HDoM2kPVJPp20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=isZNJSIv; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a7a81bd549eso148194466b.3
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 04:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721819412; x=1722424212; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2ionvxDIgqg/0UAoj0RYA65gyE1Hj5e0D1vCsi8A/g0=;
        b=isZNJSIvHNm8iP8edtCfuipzNLpPnGOMBpBBF4D/D0A7048hDe6NT6w1CYXOVfUegJ
         lAKw2hbQ3hvxOBzcIiq9l3L/5xDIoAW4BmKTHp8mcz2NeOfC0he7w66mHLTkpKFXKh9y
         MxlfaktP53EZnENQw6ND8ZUHJGWTWlQ93jA/zsTnuQId8YdIQEA+O4pDFneaYQkoaI2j
         wlhv3nmOPid5bQdZIC+ELALvws48EVp0DfpCNrgwyaPGs/mOJk05WS3KvrVdH6qfrr+N
         uIUsusctSUObU3s4wfPdcW8ROz6Luh9bDmNCjx2/tSuRvDlJ6lL1o3O2BFfpdKB+MyEH
         6yHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721819412; x=1722424212;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ionvxDIgqg/0UAoj0RYA65gyE1Hj5e0D1vCsi8A/g0=;
        b=HE7aZbXfWBq0X0YjVXebpRFk+JyBSrNKmN0GPDGG9S/ZOCDq4tHRKjp7bO99IAiNwh
         Bk6rT3X4AKKfBDXt7uEpf1A4kVuYQqmoslaQJ+NGELuDbrbR2RSjjkGUnodv0lXA3WFW
         +bW9gHoh4h6VmMheUw3y/NPEnsQ4cGIDbKWxsxNUzbsSW4ZS36jfIJh4c5kY0ztmKDt9
         Gc83OUqABPuOc52mrJGQGIOZMffcXVq4XUXmeuDYr94jtIQq0A3cmKSBATArd0Ihkb6L
         lb6Nm/zFDMA59NV4rDIOtJMQ/7Fj78iNDuZen/WgxGoPBOUolGBZcpI7UFrFIQM9MVUN
         RZvA==
X-Gm-Message-State: AOJu0YxGsRWeXKAHh+mWMiCIaFkFYCBmiuXu82PH6t1wiSMZDl4c7vsC
	4uPt40vwmxtiFcQcyHELQuq4M8ZD4rP2xigXIcw9O21QYyDvzaujd79qjQ==
X-Google-Smtp-Source: AGHT+IFHQRWjgtiumDuCIYXbQ5NDgk5TZ+vJ+7N+ELq5hiIAFCOQHYiMzfI5MtS6m8MPIVj+jauQDQ==
X-Received: by 2002:a17:907:3f0a:b0:a77:c199:9d01 with SMTP id a640c23a62f3a-a7ab0d9c4e1mr125603566b.22.1721819411489;
        Wed, 24 Jul 2024 04:10:11 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7a83aedeaesm221837466b.2.2024.07.24.04.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 04:10:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 1/1] test/io-cancel: expand print messages
Date: Wed, 24 Jul 2024 12:10:35 +0100
Message-ID: <2a0a9eec0e5b7a69e63b705eb9fe3757f1bbd7d7.1721790601.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add at least some explanation on what it's printing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/io-cancel.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/test/io-cancel.c b/test/io-cancel.c
index 8dca2c3..adf31e7 100644
--- a/test/io-cancel.c
+++ b/test/io-cancel.c
@@ -347,18 +347,21 @@ static int test_cancel_req_across_fork(void)
 			case 1:
 				if (cqe->res != -EINTR &&
 				    cqe->res != -ECANCELED) {
-					fprintf(stderr, "%i %i\n", (int)cqe->user_data, cqe->res);
+					fprintf(stderr, "user_data %i res %i\n",
+						(unsigned)cqe->user_data, cqe->res);
 					exit(1);
 				}
 				break;
 			case 2:
 				if (cqe->res != -EALREADY && cqe->res) {
-					fprintf(stderr, "%i %i\n", (int)cqe->user_data, cqe->res);
+					fprintf(stderr, "user_data %i res %i\n",
+						(unsigned)cqe->user_data, cqe->res);
 					exit(1);
 				}
 				break;
 			default:
-				fprintf(stderr, "%i %i\n", (int)cqe->user_data, cqe->res);
+				fprintf(stderr, "user_data %i res %i\n",
+					(unsigned)cqe->user_data, cqe->res);
 				exit(1);
 			}
 
@@ -451,7 +454,8 @@ static int test_cancel_inflight_exit(void)
 		if ((cqe->user_data == 1 && cqe->res != -ECANCELED) ||
 		    (cqe->user_data == 2 && cqe->res != -ECANCELED) ||
 		    (cqe->user_data == 3 && cqe->res != -ETIME)) {
-			fprintf(stderr, "%i %i\n", (int)cqe->user_data, cqe->res);
+			fprintf(stderr, "user_data %i res %i\n",
+				(unsigned)cqe->user_data, cqe->res);
 			return 1;
 		}
 		io_uring_cqe_seen(&ring, cqe);
-- 
2.44.0



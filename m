Return-Path: <io-uring+bounces-1119-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3921C87F2D2
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 23:02:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 695BE1C21507
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 22:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29DCE5A783;
	Mon, 18 Mar 2024 22:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PnnVfuwq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6403E5A4D8;
	Mon, 18 Mar 2024 22:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799340; cv=none; b=pJ2XhwNVNhw0QrS+AWUq+2AtBOmSfNZIAfmhsW+O2mcb6S7vXUi3hK5URkLQ3xXdYiO6sJT/JSUCDVJMoz3A/8UzEoKj5qekkWiOhFlnaYQy8kZiycqzpjnOR8koJrkfnsQXyoWjP3+U2DDY6ljP4WJEe7T36Xnhib/rtU14mNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799340; c=relaxed/simple;
	bh=88PXd6LH82VU+BV9k/zBBXLt/9uURnfB+ehKJC4vzV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMli0+60fBQWbQAi/it9nJyKLUc+jBNLsKZV9YLM8+LHwxKGzxYzPKjgaQuAHZmBTHYL+Ob2Hf62p7qEPJMy/dSEYRaG9/gC8IA33J/2ZLOulkZxYIltNvu8rr5z5ErlA7eCkxBnMd60XogXvK3eLMta4RhcEwWKWxwwhCMs0YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PnnVfuwq; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-41412411622so9432135e9.2;
        Mon, 18 Mar 2024 15:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710799336; x=1711404136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WIJUrcLYe0QNkJgTemkNItt6bDCqZ/mmH4VKVCsbA/4=;
        b=PnnVfuwq+i5xHQoM7zK2PAtWV9hp9DiCdh9m+Qsj7hBNn3jwOrUGlrNDdw509mMs0W
         3FBlb+CV7Rqbv7/d1j7sEFKkRB9kDpTF4dQ9VQ7kGNeyV8XRSS/XZPXrZ21OWCRWkIuZ
         nlvlBlc6djUjhO00xsc/Wui8cxumlaLE+zbtrI5ahs9ToZwzRkHWbxibdfWg5xnTO5oo
         OMsDRYCDQ6WPGFdzawp/N3ztmpkQtMDIvQ2Vs9eENAfFvF+xXgutca5ff9PtJOmkx+LQ
         O5DAEk0o1POI7Dq5pba/OaXFRzsHW21KY9OUyG8HcWN7rnficv56krgWLlrCbL0xzXMj
         lOTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799336; x=1711404136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WIJUrcLYe0QNkJgTemkNItt6bDCqZ/mmH4VKVCsbA/4=;
        b=U8iN21AhQJDVKcg6oSi/k4ZumdZ74nlmrKcHP3gmCIUqcqjbgUryA2zLIpTQ2GYfOj
         gk0G6ZHK9QXCP09qdTEYskW9jxkLCdBhxf2DltiwgdGabFDrzyT9FZZsssyIg66BtSFA
         Wf13to9PKU4/WaNNTUiIPbJzNZcwTUWJ+RunWFpBEGqQUs2yiVCFpFaP9XdziCaG66my
         g9g6+woZCTRVaYGmw9GV8C0p7FgbyWq7L2oLkPLhdYqEhcJlm0QcG2XT92ovmm/l4idQ
         CK0cnkd5jLHxZLlJyqLx0tZOZ9+NJZSQzkpKtfVh/axzE366VLyGMCY6XXSxgBrzzFr7
         0EDQ==
X-Gm-Message-State: AOJu0YxNLS7n5wGIQkGpLxaKf4KcbNF1/6D7z3D7YyaZBwV+PzoS6qIK
	qhdWA4DUaLtj+uV3N7S5o5NCDylrDjUlfWdLISJBLzU91aIpzWyJFNxFKNid
X-Google-Smtp-Source: AGHT+IHxLr4Z0Qn3NF9Snv6GN+3xdScEJ4/3a0pDbUpS1XqaudYxjx/welOJr97lx6w1r2PxBgVR1A==
X-Received: by 2002:a05:600c:3b0a:b0:414:cc0:e4d6 with SMTP id m10-20020a05600c3b0a00b004140cc0e4d6mr3599637wms.26.1710799336169;
        Mon, 18 Mar 2024 15:02:16 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id bj25-20020a0560001e1900b0033e68338fbasm2771038wrb.81.2024.03.18.15.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:02:15 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v3 05/13] nvme/io_uring: don't hard code IO_URING_F_UNLOCKED
Date: Mon, 18 Mar 2024 22:00:27 +0000
Message-ID: <f5e1a1f344a7ccce485a45badf02a792e77f18cb.1710799188.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710799188.git.asml.silence@gmail.com>
References: <cover.1710799188.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

uring_cmd implementations should not try to guess issue_flags, use a
freshly added helper io_uring_cmd_complete() instead.

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/ioctl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 3dfd5ae99ae0..1a7b5af42dbc 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -426,10 +426,13 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 	 * For iopoll, complete it directly.
 	 * Otherwise, move the completion to task work.
 	 */
-	if (blk_rq_is_poll(req))
-		nvme_uring_task_cb(ioucmd, IO_URING_F_UNLOCKED);
-	else
+	if (blk_rq_is_poll(req)) {
+		if (pdu->bio)
+			blk_rq_unmap_user(pdu->bio);
+		io_uring_cmd_complete(ioucmd, pdu->status, pdu->result);
+	} else {
 		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
+	}
 
 	return RQ_END_IO_FREE;
 }
-- 
2.44.0



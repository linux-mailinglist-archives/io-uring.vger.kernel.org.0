Return-Path: <io-uring+bounces-1116-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5854787F2CA
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 23:02:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 096D61F2274E
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 22:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B105A0FB;
	Mon, 18 Mar 2024 22:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fl6MGgt6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9060659B74;
	Mon, 18 Mar 2024 22:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799336; cv=none; b=HJ+qbwctAV7NuyX52GI20qBonpwy29/EsJxzS3e945yt18mcnTcZe0GG7wWR265Pxa9EmmbA2mTV5xhNJkSgi53Kk6FkY5XT7kJY4HJHtwNj3+yw3PTCPEJhxNAyU9rLHxzCNUqUtxdfEHQUoTK5qD3KjO0YzJmVHD4Yf8bRze8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799336; c=relaxed/simple;
	bh=H99ZcmrUACp8z/6xofR/+Bu+uFUG0paOzPEVB0ENvxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGAuWt0hu0RZeqSCELGnhPdl2lDanx8rb7Jykb3cmcLIp3K5PFGNyBpo4hgvUC0QS5adGcf4H4z0HJOPT2GXTc/oXYgv3lsrEa5maWMbOE02vnqA8NWLSNIHiZLwn3fDQsjG+ob3qi59Tn0GR6AuM5d9C+grJ4LXs+HVEzY8weg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fl6MGgt6; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-41413c99748so7940035e9.0;
        Mon, 18 Mar 2024 15:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710799332; x=1711404132; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Wbs7GQpve7jyA3Hi1WAUjWpcV8NDvkjvnKIw65sYB4=;
        b=Fl6MGgt6TaDR8Bc85z6zZJq4OtoTnbKkEJHdJqBIVVkbNjLXmpmWRKPpR5sL3qphds
         3K2GoTx7CerlzkPTfOxew6T8+rtEvTpHV4E0baQko4FXwwnbiOtyKZWFXdxaoL/4BDfu
         OxatWHarNvplIU2Pn2WxU7DMP84ScyjIh3zMH6X7SMEKwx3i42zIG8fPhPT2sU1Ey3Xp
         fviPf9fO2JdeDQWgVugrTcU5lGDiSSnLlsjAg2pF20adYjrG4UVvBFGKdBoLcz8Fi25v
         yj5xorReaJ8GXgvTYFMrGS1i/tD/3oZ8ehdEo6S95cf38VWfelEBc7ZT1Pi254lCdiy2
         l6Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799332; x=1711404132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Wbs7GQpve7jyA3Hi1WAUjWpcV8NDvkjvnKIw65sYB4=;
        b=CYX3eUihlSWYTeoH03yTDE1Wn5xcvse1cGe5iQ46tKjfuDmKf60deNbsNvRQ9scxDa
         X9eS/qBit+882iTsDA06SHis4oskosFw1mdmfD0donZIdE7lZGg2upMvyTPl6nUVKzWY
         pR3BPNIIgzVY7/NZZVOS4SOR+7dMkw+TQNaMM9ibgvXPm7u3m/tIwURcrlhRi2hXMRe/
         nCzZfcN2A4XSJGMf9jKjMG/OfmRQyyIDYB9NHs1GK6rRkgePvOlklrRi0A8oRQ9Zc/Al
         TqEyJqsqTsjB9WH5YdPf5tm+SuG6/UIIPGRikwh69soJA6R1pZrM92Y/dU9nOUkuQvBv
         LdIA==
X-Gm-Message-State: AOJu0YwlwUm9CfKJADQeF4XNhTKeNJ/LnyO8XRolbpoQDhtB9oP2I8+H
	f58evJgeuio8nkUL3+9eGqwprQb2URfJY3RdeHlECMNkaj6HySZPsIAMYNH1
X-Google-Smtp-Source: AGHT+IHF9p8DiUjEfE/MjPDImUl4SXeqMwTnef6SzO3Q1jmJZzGo8RCmaj6gfTi5CRi16JV+kFq9/g==
X-Received: by 2002:a05:600c:444f:b0:414:835:6ed2 with SMTP id v15-20020a05600c444f00b0041408356ed2mr448819wmn.35.1710799332202;
        Mon, 18 Mar 2024 15:02:12 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id bj25-20020a0560001e1900b0033e68338fbasm2771038wrb.81.2024.03.18.15.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:02:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v3 02/13] io_uring/cmd: kill one issue_flags to tw conversion
Date: Mon, 18 Mar 2024 22:00:24 +0000
Message-ID: <c53fa3df749752bd058cf6f824a90704822d6bcc.1710799188.git.asml.silence@gmail.com>
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

io_uring cmd converts struct io_tw_state to issue_flags and later back
to io_tw_state, it's awfully ill-fated, not to mention that intermediate
issue_flags state is not correct.

Get rid of the last conversion, drag through tw everything that came
with IO_URING_F_UNLOCKED, and replace io_req_complete_defer() with a
direct call to io_req_complete_defer(), at least for the time being.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/uring_cmd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 1551848a9394..7c1c58c5837e 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -130,11 +130,11 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
 	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
 		smp_store_release(&req->iopoll_completed, 1);
+	} else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		io_req_complete_defer(req);
 	} else {
-		struct io_tw_state ts = {
-			.locked = !(issue_flags & IO_URING_F_UNLOCKED),
-		};
-		io_req_task_complete(req, &ts);
+		req->io_task_work.func = io_req_task_complete;
+		io_req_task_work_add(req);
 	}
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
-- 
2.44.0



Return-Path: <io-uring+bounces-955-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D88F87D04D
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:31:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E239B2258E
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 15:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEFD93F8E4;
	Fri, 15 Mar 2024 15:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ePnGu9aH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA2F3D396;
	Fri, 15 Mar 2024 15:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516676; cv=none; b=VEiHtWr/x0O6orC8XoSEljZUAfl6kremwkLqlLrJ2xYmJd+s6xBjkh7F48wqDWaxkWiw6OXY294IQ4G09BgcHyT4o7vv//062Irz0BHPsRi+97uRkHzZOR+rM1cJPJxpeifIeA1XjWOfaTuSaQauVElbt/0luIehBUIW2VsUCOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516676; c=relaxed/simple;
	bh=kb6QtRhUVQyZegxltTMy3UbJXD0nOnBpiAusxJ5t7YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpDmhWVqEghr7FXDKl+neBQ7LhhCgp1a0di9IndLzr+0m6q7EMgiX1O9lreCamIjKXkvcl8CJuQe+QFVtE8ekB3qMBNVapQPjrvjYRLqa2El+9oE5DsfFIOiEf5h78bg++G66kcn218vt91BsxH2SaFtDi18e/yfhy2eexYOW5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ePnGu9aH; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-33ed4cf02ebso383567f8f.0;
        Fri, 15 Mar 2024 08:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710516673; x=1711121473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S+TFOq4id2xuuzz0BwmgK+/9Jeh0/lQJu3EsML3ViLg=;
        b=ePnGu9aHzlait8MC3LNlQ4KI3pBpbEBFf/kBAlAYdA+3sdx8jlM1USvFJ7/YhnTeXS
         qJmo3+cUb6fD2F66Q3ZBYG5yJNFaTl8dmcgF3JjlrdswQ74KSQhmzfoE2CmNUJ6dJ/eC
         WUL6YLXDa9Gnr7rzPuutVNZVZ3V4Nsu9c63qNuBpjYK8oPwAK51wD7iU7Wyt6FbhCxsf
         gZ8skwJWCoZDZbR1rXwkFbgSsJczLiCUubqx+4yegkPkJA+uKmRw/QdXKoJjeh9fw1zr
         S24DbHZl4HBOR63LVnzZG0fdG5YwOii58h0z5LRehKlSKAUuSkwoQqJCQ/l+vU3X4B1+
         ehfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710516673; x=1711121473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S+TFOq4id2xuuzz0BwmgK+/9Jeh0/lQJu3EsML3ViLg=;
        b=ppE0oOivHq6gSgt/6Uw8yB4zg5EJ6S18QsVL9Uyy4FPkqGAs2NIWKR9SZbDutr18k0
         6UkeRAdUSNNYVOhvr6sGHp/xAzaZbjNR6VITxCPoyu1NjIuz2XMEFJsvbSUExXJSxUMD
         wJtMhSgvNuU8GwhVcDWHguldeEzOLY8YyDLfdAz7mvh1QWd787XTbx93m+q1f/R3MFvs
         kCxou6wuIdUFMS7ahTX0nk9huTLaNKqcEjSmd+3VUND4DoWcLelwKHmL8Q0dQjumeTtL
         5LUTwyK8pig7m3BugYLrWv3cjwn626KFK4Dr/vkfZ574Gw1CtYqGf94/GkC6yqND5ZrJ
         Xv7w==
X-Gm-Message-State: AOJu0Yx4rtGzUl5JaoNhVSXqNhQvpMg/OqXvl5VrJ2+RbquYCgT72xYI
	whJWNpyMamQtKTeumVJYaliU6IZ4hg3b6+RP9oziimx7NWk5cGMuzJm6leb+
X-Google-Smtp-Source: AGHT+IHfgKJWxAwalu66ZuDaaVQMQ9FuFZrNyC4CC9upS2iDPZbQx0FPq4m/CrVeKjTSmbsYXsIDSw==
X-Received: by 2002:adf:ec11:0:b0:33e:1a98:46e2 with SMTP id x17-20020adfec11000000b0033e1a9846e2mr3706177wrn.28.1710516672915;
        Fri, 15 Mar 2024 08:31:12 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id u3-20020a5d6ac3000000b0033dd2c3131fsm3415671wrw.65.2024.03.15.08.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 08:31:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 03/11] io_uring/cmd: fix tw <-> issue_flags conversion
Date: Fri, 15 Mar 2024 15:29:53 +0000
Message-ID: <eb08e72e837106963bc7bc7dccfd93d646cc7f36.1710514702.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710514702.git.asml.silence@gmail.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
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
2.43.0



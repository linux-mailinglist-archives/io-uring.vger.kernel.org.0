Return-Path: <io-uring+bounces-1063-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC6CD87E149
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:43:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 37E68B21809
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D1111CD1D;
	Mon, 18 Mar 2024 00:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eVBTRMXf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7A918029;
	Mon, 18 Mar 2024 00:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710722621; cv=none; b=VBXHkd67zyd3I7kKjFoD0oN3gEI1mXb2GgPuFuk4arwvXS/xZgAfAan+mkF+7mw6HAJpNN/yV5SoleZaWlZXnbl037HiAdvVzDz9emzO0d7a/deRG+H8S5TUjTkl42AAbd9Bq7JTQeyyiD3Mw18sUDtP5zo+UMnG03QIroESBrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710722621; c=relaxed/simple;
	bh=/izrqIB3O3T0N3fMc9YK/lxjvDLgUtp/Le9kuZyzI+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmaVwHCCFY9VXqRmXuwNSf9PwYNPm3Hb34tAr6oPtkXizAb9YO6NH4fyLT1QDr8oNPch8JIlQSsC2ckys4GlkzE8r1Ueo6gCSOpayzXPuQoeff7DSiA+TkXTPelT5nprhn11C0qp+5s1ahq1Dzac4O3tM8R+PoziiVsIZH4L+tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eVBTRMXf; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-56845954ffeso5009741a12.2;
        Sun, 17 Mar 2024 17:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710722617; x=1711327417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+iTfQQgM7iNJagOFnCh9386l4X2lTE2ddUvAFovvm+E=;
        b=eVBTRMXfE7/A4ViS+Vfs7it2vg0IdP0GPY7cfq876BivZ9983y2YbxIbtvO/Rp7Qxl
         Pnn3R/POTNHG3WMW7+zRjTVMVYeucNrZp4yxm3U6MDUBPeEoMh2WG3N4Ouy5ojFA6bw5
         KRdPjgp3pE5/tVRjvwo/OD7BlE5Q9czQd1R5HDHLH2upAgB6fSgsUYhquz0Qh3xlclfB
         Dskqr17u9JN4RQwprW6kIfOwT+bAtn6WJI2gcbpApJHUov6UZRzlEn5RTJe+zqnBmSXN
         f3eua8PTVxq2NoFsw57Vb1p+1a8SYndWuC2nQVxzKvmWcZZajkCuGuFb1jxCXzYtctig
         9VvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710722617; x=1711327417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+iTfQQgM7iNJagOFnCh9386l4X2lTE2ddUvAFovvm+E=;
        b=qRS5ZDQvBSTNfIyJLYFvP+vfshH+oMQM6XMqPwZ8uZrJbrio6Go1EANgJ1jw51UX/s
         NLbv1DOW6Sr+8BxDSG1mxS13/6YKm4C5dc+3cuQPcfcx4K8ra8w267gUgqqSaG/xQbAz
         UX45go0rEDZ7XTreuP9jUMcQfxa4ys75NgMdG/tycIiRBuJEwh/pSTwcUutKDKn2Ky28
         Jg6l4RXzTO74wikaOZGp9j9/MLheL0A4Zmxzo76KXZ6RpOu3vMSA7j4v7viiUPaMFdnJ
         D0zpIkRAb5gzfEF0WvSSj7jyAYGXakZA1jp1AUwhgbW1QdX4wfUo+1fESle05gxO2/LD
         Ajcg==
X-Gm-Message-State: AOJu0YxZpm03DEpCUVI6EAXmEJneE1Ia7+WkhOGWrWVXrHlWc1HPnP/j
	9ZGgFjxVh/85076bK4lFA/RiP8xXYrVT/6EZunbPAg93EYDtzJA2Z2OzJGhq
X-Google-Smtp-Source: AGHT+IHkthDaEhoJicRBACBhl7XjesZXCE++CiBA6ndX6onTbaeEYp16qrkP/9z1K0kg+1JYjkV9zw==
X-Received: by 2002:a05:6402:1f0f:b0:568:fb58:bc4b with SMTP id b15-20020a0564021f0f00b00568fb58bc4bmr1216006edb.2.1710722617366;
        Sun, 17 Mar 2024 17:43:37 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640243cd00b00568d55c1bbasm888465edc.73.2024.03.17.17.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:43:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 01/14] io_uring/cmd: kill one issue_flags to tw conversion
Date: Mon, 18 Mar 2024 00:41:46 +0000
Message-ID: <cc0633380acf57f4392eee669c1a4f03cef7064b.1710720150.git.asml.silence@gmail.com>
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

io_uring cmd converts struct io_tw_state to issue_flags and later back
to io_tw_state, it's awfully ill-fated, not to mention that intermediate
issue_flags state is not correct.

Get rid of the last conversion, drag through tw everything that came
with IO_URING_F_UNLOCKED, and replace io_req_complete_defer() with a
direct call to io_req_complete_defer(), at least for the time being.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/7f0d5ddfb5335d038bfd8db50656a1d69daed37f.1710514702.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/uring_cmd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 42f63adfa54a..f197e8c22965 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -100,11 +100,11 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
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



Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BF13ABA5A
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 19:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhFQRQo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 13:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbhFQRQn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 13:16:43 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08D7C061574
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:34 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id e22so4026791wrc.1
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cpHk7OYMuEkdBzLJpyTewJUiHamdG5q/mtIeaS5aFxs=;
        b=vgUPalr7hldR8rwq6IuThCw02aB2Lm+fkclVUwlKX2JqkMUtPa8fPix5ZCcTPNvOOy
         fX8k3g1ceZIDkYp5x9bN7W0lzD4fPukXSqZ/UW56XaIoA4We+dCuYzQc9jfT0fInL/Ro
         dJkZhCQj54t7pSfcOrZs+z1KOXxjCYS0haZLqIEdafbit+ay07Fv4lkBJaVjI4U+yllQ
         KSGqrXqJgqx7FCF8WbnQ4sfJnfxj/DdC2dSyDSSEtGqQxWf+2LddFCF70n6Ispd5Yijm
         llLm+JCnzJB/rWgRM8DguJuR7mhC893tqGova8dnLm762AfkYJgMJZn28wN0gXvYQbMG
         RLZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cpHk7OYMuEkdBzLJpyTewJUiHamdG5q/mtIeaS5aFxs=;
        b=WaYU8w6kI37YQqYvPECqmrmmAf7fYM1WPTc35b/oEs493eveIgBQo7FOF/cZnRa8jT
         VSzAB0cUt/USlwLvL6qhwpgu0U66GA4tBX3KNfD33GbhhUpGV4Q6J8z6f3VosOEUwO9y
         /yH/dlMYdCKUMHnPqfzOZeqVbe8NrQumoNzwVAax8KM96Sp3n8V4Kwn3FuMqnr0wHWo2
         dwjbw7OqxzZR8NneaxOZ4uGz6emZC25E6V162Yiz2aga6i8+b5FbD5V3cWwTHimnND7t
         tYxSAxyQv/BpfuQEZVtZkbQlDVo0SJWY1v3yTVsZARxivLFmW/oXJEK9hIK6IeY1XYrH
         r+dg==
X-Gm-Message-State: AOAM531C7y/KzJS4YgSCyzi0FmbAbCfUc/qQWHRzq6Jj+wVpIGIO4fNT
        yGNKh5f01pW9mixNfKas73U=
X-Google-Smtp-Source: ABdhPJwFO/dvH40tL5wlXnwrp/6pJCL5LwNBaluzDR2LzdVMV7Q8OjF0vnN1ktYulzUdZgI4RniZEA==
X-Received: by 2002:a5d:64e8:: with SMTP id g8mr7100112wri.388.1623950073562;
        Thu, 17 Jun 2021 10:14:33 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id g17sm6208033wrp.61.2021.06.17.10.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:14:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+ea2f1484cffe5109dc10@syzkaller.appspotmail.com
Subject: [PATCH 01/12] io_uring: fix false WARN_ONCE
Date:   Thu, 17 Jun 2021 18:13:59 +0100
Message-Id: <f7ede342c3342c4c26668f5168e2993e38bbd99c.1623949695.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623949695.git.asml.silence@gmail.com>
References: <cover.1623949695.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING: CPU: 1 PID: 11749 at fs/io-wq.c:244 io_wqe_wake_worker fs/io-wq.c:244 [inline]
WARNING: CPU: 1 PID: 11749 at fs/io-wq.c:244 io_wqe_enqueue+0x7f6/0x910 fs/io-wq.c:751

A WARN_ON_ONCE() in io_wqe_wake_worker() can be triggered by a valid
userspace setup. Replace it with pr_warn.

Reported-by: syzbot+ea2f1484cffe5109dc10@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 897b94530b57..d7acb3dce249 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -238,7 +238,8 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	 * Most likely an attempt to queue unbounded work on an io_wq that
 	 * wasn't setup with any unbounded workers.
 	 */
-	WARN_ON_ONCE(!acct->max_workers);
+	if (unlikely(!acct->max_workers))
+		pr_warn_once("io-wq is not configured for unbound workers");
 
 	rcu_read_lock();
 	ret = io_wqe_activate_free_worker(wqe);
@@ -899,6 +900,8 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
 		return ERR_PTR(-EINVAL);
+	if (WARN_ON_ONCE(!bounded))
+		return ERR_PTR(-EINVAL);
 
 	wq = kzalloc(struct_size(wq, wqes, nr_node_ids), GFP_KERNEL);
 	if (!wq)
-- 
2.31.1


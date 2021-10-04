Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE13B4216E9
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbhJDTFj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237266AbhJDTFi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:38 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4734FC061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:03:49 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id f9so6316416edx.4
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LwXcMVZLipfWdgz9m4D/gl7eVTnWp73djXSvjVy8PRs=;
        b=B0LIpdGMWPHIgYT51ECEJhDBxBjynK+IOdfrqlXu1RXbZArdcKA93NJSthkRZbRVJo
         MDWl964wU091gRHGm8r/a0fHqb8KT7FVjlseaUzuFY8mpJ4kh9DHr6WZ+EoVco6CRKT+
         1lP+w2oBQZvSbV+aWPAjsZc18vd4ybciohw+CGCDMY2BfxOj6xpO5wTRt0ASQi/9looS
         Ie7UliagY5kRzLCQ4zmP19DT+qxFjVeBZ1uNKKrVRo/oFZYmyXQhuWUwiFDY7SvhAU1g
         etronsn3Yu8FTzHBYmYmNQ5xvr1Rv8g6o9xTWBP4tkcB+xTDN0HMrMUQKkTnde+iiwBi
         QAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LwXcMVZLipfWdgz9m4D/gl7eVTnWp73djXSvjVy8PRs=;
        b=w+gjKsACtzZ15cyC6FlIaT+tkViEQexUDgYtUh2FxNatqh6QGuNLEGcTeiFQNI0fE3
         m5TeCkzLDck8NTa3WhiI7wR8zuzt0YQIKEaoKN6Kd9tiYm2LwgSGNMruJssxATv5h25w
         lxj7u6dL4rJPS8SDDRauDdTVjJvTZD8vjJC8N8HTJ5VA85auekFNRgNDbaNsJnD3WopO
         gKQodtGOeYrNhW5MTbm5ZXhAuw3aH1l2K8jVlu/PO56+rZzJqLhkf+0DW9ckw59bExYF
         c7gO9FJjvtzYQ6bAawzmvhQTpU0H63iYnKOJowNPCHCbIToH+h9U2fGXLZFus0gvUApg
         UJeQ==
X-Gm-Message-State: AOAM531v7ALzlazb4/hOe5xX1F2Txo50mgfcwpxmUNdForVFnYNAvaP+
        Cm66+7nK5fqgzEWKKzLEiBJoF6jmXpc=
X-Google-Smtp-Source: ABdhPJzNycHXHLScXRn2dbh318d20dkaYVax7GDUP0D1GhX/owE/lY1D61mIFGRrUWSWrCn+n1ELRQ==
X-Received: by 2002:a17:906:2b07:: with SMTP id a7mr20348552ejg.284.1633374227565;
        Mon, 04 Oct 2021 12:03:47 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:03:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 01/16] io_uring: optimise kiocb layout
Date:   Mon,  4 Oct 2021 20:02:46 +0100
Message-Id: <9d9dde31f8f62279a5f48c575bbc27b8290edc0c.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We want ->comp_list in the second cacheline, which is hotter comparing
to the 3rd. Swap the field with ->link, which is not as hot and
controlled by flags and so not accessed unless there is a link.

By the way add a couple of comments for io_kiocb fields.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a9eefd74b7e1..970535071564 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -863,19 +863,22 @@ struct io_kiocb {
 	struct task_struct		*task;
 	u64				user_data;
 
-	struct io_kiocb			*link;
 	struct percpu_ref		*fixed_rsrc_refs;
 
-	/* used with ctx->iopoll_list with reads/writes */
+	/* used by request caches, completion batching and iopoll */
 	struct io_wq_work_node		comp_list;
+	struct io_kiocb			*link;
 	struct io_task_work		io_task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	struct hlist_node		hash_node;
+	/* internal polling, see IORING_FEAT_FAST_POLL */
 	struct async_poll		*apoll;
 	/* store used ubuf, so we can prevent reloading */
 	struct io_mapped_ubuf		*imu;
 	struct io_wq_work		work;
+	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	const struct cred		*creds;
+	/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 	struct io_buffer		*kbuf;
 };
 
-- 
2.33.0


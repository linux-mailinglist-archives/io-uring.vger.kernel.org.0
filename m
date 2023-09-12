Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A7C79D77B
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 19:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbjILRZI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Sep 2023 13:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjILRZH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Sep 2023 13:25:07 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F65610D9
        for <io-uring@vger.kernel.org>; Tue, 12 Sep 2023 10:25:04 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-34f5357cca7so5830305ab.1
        for <io-uring@vger.kernel.org>; Tue, 12 Sep 2023 10:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694539502; x=1695144302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9V9a5OK9Iy8QE1Mjd/+uWyQONY2gF9HS1th7ayJRu5A=;
        b=uvr+UznBwD2SWhk4BOwGxR7ZYfBxywSJ4xGD7nWJRWITYdofbuazXEQmXOW2y28xyS
         KihUecDqyWcrM+O+3QNJlUSAYLlRh2vyQMcnGM4t6TrzZQJhDYLtvxi1ggFQC6202zo9
         H0L4ige+kWZUGFF0EszuZ6xWwon5YLqG9P6Fvi7jjVcJcaWxVg5CCZqhWK9XNjGpKh2y
         hVntZeNWse6g564BuJc3PSIGY8+WzA8dxbwGdJUqgTi0MjXpdhiRm6cvgGU2VDyEh/In
         GIaBq108KOTIg9SMrEhg+OGk8OEQfg8qXUIoPDqND0T0J/xyMX2Ozkd3SFqOso/aSVow
         JhWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694539502; x=1695144302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9V9a5OK9Iy8QE1Mjd/+uWyQONY2gF9HS1th7ayJRu5A=;
        b=RHwwGN+JVyDv7DZXXm568LE4fSZxtU0PQ9wM5p177w8w2G0i/gWHH6uFl8+KEXTtHf
         BJkswvp6I+Pp+TOJYR+xgxib1yLKWU7rJT5+/E7VGxuUMymwwgMZX2rTL9+GXjtdeIwK
         CubPug5yXNcwoVURjPPXu8lomFO+aPcy19fARpa91GC1EKUVcxGUiSOqUamen4I39QU4
         PcVycnZ9no8GEvALOWGOOT28GWXgywN5Y3JnniNcRsL5v0oJKVuR1XbKDNVYEBarzghG
         ODA3Pv6LSyshocs8qgz8frY+daKSqSMi4EDAU/UknXCeNXP105jrICP6b3H3dXNXZTbx
         t66g==
X-Gm-Message-State: AOJu0YwVeGqqbr5i1NayOmXk0hWjw5tJnSNyV5+2uCrdgz3GGg5mhwTR
        rDM6KajcQdXDJeHiLnsBdw0BHoJSpHKKrdc/LLZpGQ==
X-Google-Smtp-Source: AGHT+IEMP1d/F7ZwNS42meo6Fs71Z6K0MFsEb8WfEqTyuo/oXhAnsjTZEaVICzf8J1RqiHlh2pmpSA==
X-Received: by 2002:a92:c948:0:b0:34f:3b12:799e with SMTP id i8-20020a92c948000000b0034f3b12799emr271990ilq.0.1694539502664;
        Tue, 12 Sep 2023 10:25:02 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d4-20020a056e02214400b0034ac1a32fd9sm1777055ilv.44.2023.09.12.10.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 10:25:01 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, krisman@suse.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/rw: split io_read() into a helper
Date:   Tue, 12 Sep 2023 11:24:56 -0600
Message-Id: <20230912172458.1646720-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230912172458.1646720-1-axboe@kernel.dk>
References: <20230912172458.1646720-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add __io_read() which does the grunt of the work, leaving the completion
side to the new io_read(). No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index c8c822fa7980..402e8bf002d6 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -708,7 +708,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 	return 0;
 }
 
-int io_read(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct io_rw_state __s, *s = &__s;
@@ -853,6 +853,17 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	/* it's faster to check here then delegate to kfree */
 	if (iovec)
 		kfree(iovec);
+	return ret;
+}
+
+int io_read(struct io_kiocb *req, unsigned int issue_flags)
+{
+	int ret;
+
+	ret = __io_read(req, issue_flags);
+	if (unlikely(ret < 0))
+		return ret;
+
 	return kiocb_done(req, ret, issue_flags);
 }
 
-- 
2.40.1


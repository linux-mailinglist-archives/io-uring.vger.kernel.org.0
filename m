Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE627585CF
	for <lists+io-uring@lfdr.de>; Tue, 18 Jul 2023 21:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjGRTtd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jul 2023 15:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjGRTta (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jul 2023 15:49:30 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCCA1993
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 12:49:30 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-785d3a53ed6so68142839f.1
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 12:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689709769; x=1690314569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rd5q4QGxS59bSAw+JDmQ90OVbkUJjAQIgvePrWiPffo=;
        b=pa9ml1Yq+mAUfVkTfAFqTdCTO//R/u8eINJuCUIgrPVylkBY2W2xIpTcVPIW4wAQZf
         wqQFKiXHH8mP6ilgsivhhV1sWq122AQhtfGjO8MW+NSM5Dwd9p1fBg9a7rdPecEAkfHa
         QICn2OplSCK/D8EaM75WZI9NYgCaaToa4yyUa0Qh9GUAIKeFd+tT4cIDiab8bk9WwbQH
         AtrnWPUMu6V+8nu6IzcUgBZjG5hnFdcK/OLUc50hem5+u1mAli/VHa1JDv6OWho/WzqS
         kuzawnY63NYtXJ7GAJLijCJNUjLdnc8gvaAr3bcKW0SuVfXCBPS0Hj2i2qUPgGJloePR
         l4/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689709769; x=1690314569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rd5q4QGxS59bSAw+JDmQ90OVbkUJjAQIgvePrWiPffo=;
        b=DV1nw7xLpKDtwudEbsjVJ3rC5Dnwywngz0Ppts9NkL0Yatmte9PiCjPM7iPUiZ0RKX
         /U032K8kQ+Ohp7Zwh6Qdb09YWiJgqWxpXTUGVsvBslswZ4POfMm8j+8bAsIJEw+i+Owf
         kbNtrNUFvu9Log06s+qw1j5fLK3cUJSJWC27jc5GXs3SUv3dwxJXrf7jjK9DNDlPOHoS
         PFgYwSslT+cph0IEdFL88q5FGmafSr5ahtxhABADaoHXKItbizHBizNDxs2XuNCjjj08
         gKcS24vfeGu+iNFWj1YEl6Fr3jRh/CZjJHPNHn6NFa9IXW5O1+8sykW/Jf3KlhRiW+Cw
         hyNg==
X-Gm-Message-State: ABy/qLYqWcFkDZhLzMpRgDk7UY1/u/jkGWERdGhtDT2x4ZvwC47LnAMN
        561GAmV39pb33rrQ9Jf+QZDW/Di1LtAffXMTOp0=
X-Google-Smtp-Source: APBJJlHlgVHXiTYXQZrmik3S+TX69txqAaXEnmAvcKDroC538cvy7f4ZwipVFMwfo9UCpMhMF1ZU3w==
X-Received: by 2002:a05:6e02:3486:b0:33b:d741:5888 with SMTP id bp6-20020a056e02348600b0033bd7415888mr2794446ilb.0.1689709769146;
        Tue, 18 Jul 2023 12:49:29 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v18-20020a92d252000000b00345e3a04f2dsm897463ilg.62.2023.07.18.12.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 12:49:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring/rw: add write support for IOCB_DIO_DEFER
Date:   Tue, 18 Jul 2023 13:49:18 -0600
Message-Id: <20230718194920.1472184-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230718194920.1472184-1-axboe@kernel.dk>
References: <20230718194920.1472184-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the filesystem dio handler understands IOCB_DIO_DEFER, we'll get
a kiocb->ki_complete() callback with kiocb->dio_complete set. In that
case, rather than complete the IO directly through task_work, queue
up an intermediate task_work handler that first processes this
callback and then immediately completes the request.

For XFS, this avoids a punt through a workqueue, which is a lot less
efficient and adds latency to lower queue depth (or sync) O_DIRECT
writes.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1bce2208b65c..4ed378c70249 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -285,6 +285,14 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 
 void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+	if (rw->kiocb.dio_complete) {
+		long res = rw->kiocb.dio_complete(rw->kiocb.private);
+
+		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
+	}
+
 	io_req_io_end(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
@@ -300,9 +308,11 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 
-	if (__io_complete_rw_common(req, res))
-		return;
-	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
+	if (!rw->kiocb.dio_complete) {
+		if (__io_complete_rw_common(req, res))
+			return;
+		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
+	}
 	req->io_task_work.func = io_req_rw_complete;
 	__io_req_task_work_add(req, IOU_F_TWQ_LAZY_WAKE);
 }
@@ -914,7 +924,13 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		__sb_writers_release(file_inode(req->file)->i_sb,
 					SB_FREEZE_WRITE);
 	}
-	kiocb->ki_flags |= IOCB_WRITE;
+
+	/*
+	 * Set IOCB_DIO_DEFER, stating that our handler groks deferring the
+	 * completion to task context.
+	 */
+	kiocb->ki_flags |= IOCB_WRITE | IOCB_DIO_DEFER;
+	kiocb->dio_complete = NULL;
 
 	if (likely(req->file->f_op->write_iter))
 		ret2 = call_write_iter(req->file, kiocb, &s->iter);
-- 
2.40.1


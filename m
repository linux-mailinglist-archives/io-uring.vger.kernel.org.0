Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30955AF09B
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 18:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbiIFQhO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 12:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238987AbiIFQgs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 12:36:48 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7BE2FD
        for <io-uring@vger.kernel.org>; Tue,  6 Sep 2022 09:13:11 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id lx1so24380684ejb.12
        for <io-uring@vger.kernel.org>; Tue, 06 Sep 2022 09:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=9aXUsW604JS9V3Fc+GjNX2IX1E1/9dHoWdwhnM48rJ0=;
        b=Ed2boOrvQ3UGGKJMhcfosQKcKXCTeLogGLhIXbTtUfGc47V5By/VItHpQjUGLdVh7Y
         WaiyAtnPZKxP83X3wRoxXwu9lDSiYff8qE56Hy2PbbUq6SqLvVmwi371QY/X0V9LxOOn
         HC00+HgzSSLCDrduqoQhx3wIrRNKNrsPm5rztAAW1Jpr6kcDnX4V5UCwG0F4ke07NEcb
         7wA08ACNSdR7jVpmkEYPGMOvZT3vA6OOuezWR3LdGYw3yyaXUCCaOn3hVzTnEapU6CLY
         PTtI+dEioZ4nfSeLsV6V8FfLZX4XKLMXtx2g1KJ3/Wj3cnnGyKoCuxxnT25t+Nolm9cW
         XXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=9aXUsW604JS9V3Fc+GjNX2IX1E1/9dHoWdwhnM48rJ0=;
        b=sPSmmIzBtY6om0qH0FFVWQGQEYdMn21hloQ8cMaUO+Dxw8ZT32KknR3FFl8xIH6lx5
         zQ70Y8lcck3uWGtKr/l49q8EGSF/6S1tIPAl1eYXVlao0SSHo9+nrsBiu25rEMw0jW+k
         F6V/EoQ+EOG2m3N70ufbbeJIUbTLWZwwFe4CFUO/+nvg7XFZ6p2DU4BU6IfHRn+qBEAt
         0kkXxUapXObumpkXYIuFO9joK7/ku4yi+aD8ZBhASRZsdLDbP2+d5WThZekAeKEx9zlL
         SyYC5RyTXCWzcYTaxvIVzbGL1OkmlDnWPG9zwzkAtB1Rv53dQ5ftpig1bl4ERX6gOIkD
         YbvQ==
X-Gm-Message-State: ACgBeo3yPTEeLW5bhM9WEBap34YWsx8KOtEx0OfFOISa0dOSjtNTmdnZ
        uelwahE5ms04QiyxRqlxwLv51dEHMq4=
X-Google-Smtp-Source: AA6agR6kRxu6FmfcFXDO1eHyyCq0jZd380XWPCPyxZVi0mQdn684uU3BwT+vuNkmoGIntsiiL5XtXQ==
X-Received: by 2002:a17:907:720b:b0:731:6e49:dc93 with SMTP id dr11-20020a170907720b00b007316e49dc93mr40827369ejc.421.1662480790228;
        Tue, 06 Sep 2022 09:13:10 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:1bab])
        by smtp.gmail.com with ESMTPSA id kw16-20020a170907771000b007512bf1b7ecsm6556385ejc.118.2022.09.06.09.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 09:13:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring/kbuf: fix not advancing READV kbuf ring
Date:   Tue,  6 Sep 2022 17:11:16 +0100
Message-Id: <a6d85e2611471bcb5d5dcd63a8342077ddc2d73d.1662480490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662480490.git.asml.silence@gmail.com>
References: <cover.1662480490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When we don't recycle a selected ring buffer we should advance the head
of the ring, so don't just skip io_kbuf_recycle() for IORING_OP_READV
but adjust the ring.

Fixes: 934447a603b22 ("io_uring: do not recycle buffer in READV")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index d6af208d109f..746fbf31a703 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -91,9 +91,13 @@ static inline void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	 * buffer data. However if that buffer is recycled the original request
 	 * data stored in addr is lost. Therefore forbid recycling for now.
 	 */
-	if (req->opcode == IORING_OP_READV)
+	if (req->opcode == IORING_OP_READV) {
+		if ((req->flags & REQ_F_BUFFER_RING) && req->buf_list) {
+			req->buf_list->head++;
+			req->buf_list = NULL;
+		}
 		return;
-
+	}
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		io_kbuf_recycle_legacy(req, issue_flags);
 	if (req->flags & REQ_F_BUFFER_RING)
-- 
2.37.2


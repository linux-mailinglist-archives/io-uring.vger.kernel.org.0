Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5CD6452B3
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 04:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiLGDyh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 22:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiLGDyg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 22:54:36 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3014E686
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 19:54:35 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id a16so23148427edb.9
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 19:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p7PBbvpWlX4R/Yms5Q9wU+PvrZz6g5J0eJQaIzAm6Vg=;
        b=fkqC7dMb2Bc/xVUPpjMRiT56ZR3FhrkI8auMk74QNqOMPeUdTAr4ZaSrk0RqSTE7CD
         wwleF6qo7aWx6nKvkvXaQ2QKLEb66kCJqpotktwfTT1p8+5TYNuuLnltrA2MtFsgPwC6
         y/fHxkbAJ1HBum8pDmC7UWUafik/PpJV/u0PlFSADYGp0olLXSVDC/rJEdoPJEQCUGKw
         qzZ21BmaDl+eQN7vcGoJ7tsab14BkCs1AMwuqyu+DN1mvqk+qFhGoyuRH1cKaBoyB/AK
         cI5CNo90ziEHDNP0Z6nv0WYPsFlmmp9Orkoq6CBTsWSsDONp6RDMcQprJ5rx6W4UaOE9
         h2zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p7PBbvpWlX4R/Yms5Q9wU+PvrZz6g5J0eJQaIzAm6Vg=;
        b=HhhMwfgeqNNPey1YRct0ETUHkmkeiHi/byBbuCsjFLSNqluDM1E5R2kWM0jI9L8Jfy
         WUMNwmdvdPnsRNJ5YpJ47SI17uqrM8Zu8IVUWiueKOkaK2NsknoomzNtJ7Gow8xaalX+
         T2W8wHaEcfaDQqUlkrmUWsln5Y7kkLW5LvDYoNQo6sbft5QXufxenvk9pjq9AMJfRrqK
         aQWj/ib7rvsF0BPS6zBdTj817f4xTP+9k11xpFBoZqbEPr9pgd8oBs5pJAMhNpv29DM0
         ZkcDrdRoCB5cPfbtK1kqRbcjzxhRxiPZd2WIraN4nwpQfSeUzuqkW5oXoMwipLQNHrqV
         dxVQ==
X-Gm-Message-State: ANoB5pkJpOF7rERAfgze5EU81xrlQozIXlkbV0M8QpmPa6B5GkYaTF8D
        vW8RMakcyGrws9NpYmL/ontM1h8vzxU=
X-Google-Smtp-Source: AA0mqf6fphUbdZBVhQ4yTEN7nGpIagGzOBQworifCQ1/TCo0zD16BwAFF9PqCeh7kM9zicvWXvYDpA==
X-Received: by 2002:a05:6402:4504:b0:463:71ef:b9ce with SMTP id ez4-20020a056402450400b0046371efb9cemr7618896edb.75.1670385273969;
        Tue, 06 Dec 2022 19:54:33 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0073de0506745sm7938939ejt.197.2022.12.06.19.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 19:54:33 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 01/12] io_uring: dont remove file from msg_ring reqs
Date:   Wed,  7 Dec 2022 03:53:26 +0000
Message-Id: <e5ac9edadb574fe33f6d727cb8f14ce68262a684.1670384893.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670384893.git.asml.silence@gmail.com>
References: <cover.1670384893.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We should not be messing with req->file outside of core paths. Clearing
it makes msg_ring non reentrant, i.e. luckily io_msg_send_fd() fails the
request on failed io_double_lock_ctx() but clearly was originally
intended to do retries instead.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 io_uring/msg_ring.c | 4 ----
 io_uring/opdef.c    | 7 +++++++
 io_uring/opdef.h    | 2 ++
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 436b1ac8f6d0..62372a641add 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1810,7 +1810,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		return ret;
 
 	/* If the op doesn't have a file, we're not polling for it */
-	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && req->file)
+	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
 		io_iopoll_req_issued(req, issue_flags);
 
 	return 0;
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index afb543aab9f6..615c85e164ab 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -167,9 +167,5 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	/* put file to avoid an attempt to IOPOLL the req */
-	if (!(req->flags & REQ_F_FIXED_FILE))
-		io_put_file(req->file);
-	req->file = NULL;
 	return IOU_OK;
 }
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 83dc0f9ad3b2..04dd2c983fce 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -63,6 +63,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READV",
 		.prep			= io_prep_rw,
@@ -80,6 +81,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "WRITEV",
 		.prep			= io_prep_rw,
@@ -103,6 +105,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READ_FIXED",
 		.prep			= io_prep_rw,
@@ -118,6 +121,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "WRITE_FIXED",
 		.prep			= io_prep_rw,
@@ -277,6 +281,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READ",
 		.prep			= io_prep_rw,
@@ -292,6 +297,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "WRITE",
 		.prep			= io_prep_rw,
@@ -481,6 +487,7 @@ const struct io_op_def io_op_defs[] = {
 		.plug			= 1,
 		.name			= "URING_CMD",
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= uring_cmd_pdu_size(1),
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 3efe06d25473..df7e13d9bfba 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -25,6 +25,8 @@ struct io_op_def {
 	unsigned		ioprio : 1;
 	/* supports iopoll */
 	unsigned		iopoll : 1;
+	/* have to be put into the iopoll list */
+	unsigned		iopoll_queue : 1;
 	/* opcode specific path will handle ->async_data allocation if needed */
 	unsigned		manual_alloc : 1;
 	/* size of async data needed, if any */
-- 
2.38.1


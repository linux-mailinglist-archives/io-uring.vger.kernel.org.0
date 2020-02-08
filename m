Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1666F1563CF
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 11:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgBHK3E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 05:29:04 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44700 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgBHK3E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 05:29:04 -0500
Received: by mail-ed1-f66.google.com with SMTP id g19so2393515eds.11;
        Sat, 08 Feb 2020 02:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=v71j7hU9kK984W5y9Lmu8ijAMWRufoaDXYMaq0MlKwE=;
        b=R+6fX2+1XylqfRsRx/JUV8OCEu9qEDdn44h+67ql0J1FmJ1HYzp77arYnLVdIlbvXX
         iL1ZFk2IZunNYEOYgtKtGeNCy9cVBI8+K4q68g1mKnc7aKw0OREBeKAfJdgDtlc/Dii6
         AlmuFNZ5oQLqUu10Uu0lPMpY51OoWf11ryTcaw/fDHhsDO5tulhLu8DpsuTdKEvtI2yR
         sqXvnIPP22Q6hr/W4ZR3exXxonPWVBXgSKraRYmXRYXv1Ou/tZa/dmrWJJt/jyterh8b
         foJBI6+7H8nQrhtgyQU/zgr/HEJOGSP1PT/K3NUhgumJUrpxyVRN3/amhxqLKnNMLevV
         Y9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v71j7hU9kK984W5y9Lmu8ijAMWRufoaDXYMaq0MlKwE=;
        b=CSfeHaiPF/e0A3+Omj5rVk0LEcvqvhppPuRZKLvb/Sz6/F6wN16pt5aMqdx5sQVQDT
         rW6Q7gnc6+36bQ273xKLIW07hkGi8HoZ4ocFOQOO6rGthAJuZqS+lSSNpzL7OjjvyWeQ
         MX7ahqz2jTkRpBuyMTHlydy3cLJBACs4tAMpn0NRr/v4VS4AGNZd+PmlKVMZW2rF6tn+
         xHGLONK2L89HqSmugIbk4s87ZWfShaF1VrFMAaFOK32/TSjrOD/eHZPCjU8YW3dDOySY
         aWrTPGunCjcTwfR4mnol5sTzuL0rvTQG13sovgXrAEqeYPIYsBhSmJwjAP7alP2tKYJQ
         jqUg==
X-Gm-Message-State: APjAAAVyE0ptiTG3x2hKTDbtUHswcwF2JTYDD6j5fVbcY/5D+X/GEivV
        ELSeU0QaeM/5dz7yIvNQ491nsN8f
X-Google-Smtp-Source: APXvYqzIzSq9QreSIyo9o9yhvk9aokrvuIQqIQYsIOl0naTKm5BNQnXk1bGtmUoY0DdzDxQ7wE9Hnw==
X-Received: by 2002:aa7:d9c6:: with SMTP id v6mr2928776eds.107.1581157742379;
        Sat, 08 Feb 2020 02:29:02 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id f13sm257742edq.26.2020.02.08.02.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 02:29:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] io_uring: fix double prep iovec leak
Date:   Sat,  8 Feb 2020 13:28:02 +0300
Message-Id: <3df75cdc89ce91167f0f5fef068dcc27e387c73f.1581157341.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581157341.git.asml.silence@gmail.com>
References: <cover.1581157341.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Requests may be prepared multiple times with ->io allocated (i.e. async
prepared). Preparation functions doesn't handle it and forget about
previously allocated resources. This may happen in case of:
- spurious defer_check
- non-head (i.e. async prepared) request executed in sync (via nxt).

Make the handlers to check, whether they already allocated resources,
what is true IFF REQ_F_NEED_CLEANUP is set.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1698b4950366..f5aa2fdccf7a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2187,7 +2187,8 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(!(req->file->f_mode & FMODE_READ)))
 		return -EBADF;
 
-	if (!req->io)
+	/* either don't need iovec imported or already have it */
+	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
 	io = req->io;
@@ -2275,7 +2276,8 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
-	if (!req->io)
+	/* either don't need iovec imported or already have it */
+	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
 	io = req->io;
@@ -2981,6 +2983,9 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (!io || req->opcode == IORING_OP_SEND)
 		return 0;
+	/* iovec is already imported */
+	if (req->flags & REQ_F_NEED_CLEANUP)
+		return 0;
 
 	io->msg.iov = io->msg.fast_iov;
 	ret = sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
@@ -3131,6 +3136,9 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 
 	if (!io || req->opcode == IORING_OP_RECV)
 		return 0;
+	/* iovec is already imported */
+	if (req->flags & REQ_F_NEED_CLEANUP)
+		return 0;
 
 	io->msg.iov = io->msg.fast_iov;
 	ret = recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
-- 
2.24.0


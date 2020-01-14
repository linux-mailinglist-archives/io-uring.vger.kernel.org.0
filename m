Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E578013B43F
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2020 22:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgANVY2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jan 2020 16:24:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgANVY2 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 14 Jan 2020 16:24:28 -0500
Received: from dhcp-10-100-145-180.wdl.wdc.com (unknown [199.255.45.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A28124656;
        Tue, 14 Jan 2020 21:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579037067;
        bh=T4mKbdk3//UcfIzdvp4mpLugamu5k+cxX1gfTJDXVx8=;
        h=From:To:Cc:Subject:Date:From;
        b=LjckkEKLARsfNl5vK+Ij2IUUKu9pbDqFMxuSgkjr+h4Aq6krrlnEoOwUnPma70ZB7
         yZ8QRZpQmPYa2onaIt9vDoKW+7b+JX2KIEzTr/efh2Tx9G2jwQszaOEH8PDaC/vi9O
         L3bHLS68X5isxFhy9/LpzCq7hzWA1HT5epCat1RM=
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>
Subject: [PATCH] fio: Use fixed opcodes for pre-mapped buffers
Date:   Tue, 14 Jan 2020 13:24:24 -0800
Message-Id: <20200114212424.8067-1-kbusch@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use the correct opcode when for reads and writes using the fixedbuf
option, otherwise EINVAL errors will be returned to these requests.

Fixes: b10b1e70a ("io_uring: add option for non-vectored read/write commands")
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 engines/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 4f6a9678..329f2f07 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -84,6 +84,11 @@ static const int ddir_to_op[2][2] = {
 	{ IORING_OP_WRITEV, IORING_OP_WRITE }
 };
 
+static const int fixed_ddir_to_op[2] = {
+	IORING_OP_READ_FIXED,
+	IORING_OP_WRITE_FIXED
+};
+
 static int fio_ioring_sqpoll_cb(void *data, unsigned long long *val)
 {
 	struct ioring_options *o = data;
@@ -189,12 +194,13 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
-		sqe->opcode = ddir_to_op[io_u->ddir][!!o->nonvectored];
 		if (o->fixedbufs) {
+			sqe->opcode = fixed_ddir_to_op[io_u->ddir];
 			sqe->addr = (unsigned long) io_u->xfer_buf;
 			sqe->len = io_u->xfer_buflen;
 			sqe->buf_index = io_u->index;
 		} else {
+			sqe->opcode = ddir_to_op[io_u->ddir][!!o->nonvectored];
 			if (o->nonvectored) {
 				sqe->addr = (unsigned long)
 						ld->iovecs[io_u->index].iov_base;
-- 
2.24.1


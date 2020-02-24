Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F25F2169EF4
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 08:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgBXHMP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 02:12:15 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44679 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725895AbgBXHMP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 02:12:15 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 59CFB20A0D;
        Mon, 24 Feb 2020 02:12:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 24 Feb 2020 02:12:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=svCIjTru6MK1nvbEfCRUeH6N6e1
        mwAl/7sGsfQ6ZvaI=; b=QPybhWJcZFEvOF2oc35EYAXxeWuMe+MhqZjvWt31+FG
        5Jj6+qgBM+3npHMD65eqyS0ETMimWUK0bLZt4uDbZbX54My6uIRAlXgFmE86nRUj
        tHzZLrXLKKrg02TQ0hGRUeJchYUjZToUuK3Ev2kdP1NfxpesjWI9RH2B4MgFV4Ei
        C9/niNC9WQOY7qPIaGo4aDwiWnCfLxpDwCzRqqZSsvdIoTRPa6V1Bi53bxRpDYvp
        rLbS0zA1851smh2tGv3DIKNWVoNfIKs89gEqth2ya+xlVZu2rxPa3KNYIjq3vd96
        82+SHAhefRImpB7hjyh35hkynXw/aI1/GqkPWynHX+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=svCIjT
        ru6MK1nvbEfCRUeH6N6e1mwAl/7sGsfQ6ZvaI=; b=R115ogp7E16xPKt2kPhJft
        4YnSKMmqYAgjAMqStrjetfO4CRAY6TmeJMGTIik0pDX8bmVnuDlyYfUQgmkXOgPp
        cVQnDZcFNTTBse2voqSI0B1TKKB0LWj7IznpgCOlr3ZxTfxvTAVflQXgemmmTLLP
        oALTrXeHKyAXQCwMvBipX2UIdFG9ZX+pGFzAhGyTumSblaOD46RvlNWDoXAZlSO9
        YC2dtPcwbq0On78BPKLWO05nBH4goNKrvS4akE3TOsMGn03bZPu9zRuo1sWG4qNv
        td/QzsVyQwJpm9wUpOXBDELBZXeDXgD/MtTAEA7DZeVd5w1HJIE/7VQbhItyOzSQ
        ==
X-ME-Sender: <xms:TXdTXt6mr2AwHnUGftmXepwPQ4VSuXBnrxbMeUY45TA9O4Fx9Bn0Kg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeelgddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehmtderredttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucfkphepie
    ejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:TXdTXqlC2Nxni3zfpkEmjeQGG2tsDaZcD6NavPLQp56p-RCz68Oe-A>
    <xmx:TXdTXgG-PLj4fW9dP6q0yRenebU7UFBdtG3DoQpTYii1V0L-XaPd3g>
    <xmx:TXdTXh8QzAKGkh31BVkKSd1SzsemU5WxdK41EJDefFgeC5-PYB5o0Q>
    <xmx:TXdTXsSX2jig2ghvrcJlzlNN9yOhKMKB1TZgD9NldYbyRHNCR96IUg>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id C73533280062;
        Mon, 24 Feb 2020 02:12:12 -0500 (EST)
Date:   Sun, 23 Feb 2020 23:12:11 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: Deduplicate io_*_prep calls?
Message-ID: <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5xcvbplkbi3nv3hh"
Content-Disposition: inline
In-Reply-To: <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--5xcvbplkbi3nv3hh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On 2020-02-23 20:52:26 -0700, Jens Axboe wrote:
> The fast case is not being deferred, that's by far the common (and hot)
> case, which means io_issue() is called with sqe != NULL. My worry is
> that by moving it into a prep helper, the compiler isn't smart enough to
> not make that basically two switches.

I'm not sure that benefit of a single switch isn't offset by the lower
code density due to the additional per-opcode branches.  Not inlining
the prepare function results in:

$ size fs/io_uring.o fs/io_uring.before.o
   text	   data	    bss	    dec	    hex	filename
  75383	   8237	      8	  83628	  146ac	fs/io_uring.o
  76959	   8237	      8	  85204	  14cd4	fs/io_uring.before.o

symbol size
-io_close_prep 0000000000000066
-io_connect_prep 0000000000000051
-io_epoll_ctl_prep 0000000000000051
-io_issue_sqe 0000000000001101
+io_issue_sqe 0000000000000de9
-io_openat2_prep 00000000000000ed
-io_openat_prep 0000000000000089
-io_poll_add_prep 0000000000000056
-io_prep_fsync 0000000000000053
-io_prep_sfr 000000000000004e
-io_read_prep 00000000000000ca
-io_recvmsg_prep 0000000000000079
-io_req_defer_prep 000000000000058e
+io_req_defer_prep 0000000000000160
+io_req_prep 0000000000000d26
-io_sendmsg_prep 000000000000006b
-io_statx_prep 00000000000000ed
-io_write_prep 00000000000000cd



> Feel free to prove me wrong, I'd love to reduce it ;-)

With a bit of handholding the compiler can deduplicate the switches. It
can't recognize on its own that req->opcode can't change between the
switch for prep and issue. Can be solved by moving the opcode into a
temporary variable. Also needs an inline for io_req_prep (not surpring,
it's a bit large).

That results in a bit bigger code. That's partially because of more
inlining:
   text	   data	    bss	    dec	    hex	filename
  78291	   8237	      8	  86536	  15208	fs/io_uring.o
  76959	   8237	      8	  85204	  14cd4	fs/io_uring.before.o

symbol size
+get_order 0000000000000015
-io_close_prep 0000000000000066
-io_connect_prep 0000000000000051
-io_epoll_ctl_prep 0000000000000051
-io_issue_sqe 0000000000001101
+io_issue_sqe 00000000000018fa
-io_openat2_prep 00000000000000ed
-io_openat_prep 0000000000000089
-io_poll_add_prep 0000000000000056
-io_prep_fsync 0000000000000053
-io_prep_sfr 000000000000004e
-io_read_prep 00000000000000ca
-io_recvmsg_prep 0000000000000079
-io_req_defer_prep 000000000000058e
+io_req_defer_prep 0000000000000f12
-io_sendmsg_prep 000000000000006b
-io_statx_prep 00000000000000ed
-io_write_prep 00000000000000cd


There's still some unnecessary branching on force_nonblocking. The
second patch just separates the cases needing force_nonblocking
out. Probably not quite the right structure.


Oddly enough gcc decides that io_queue_async_work() wouldn't be inlined
anymore after that. I'm quite doubtful it's a good candidate anyway?
Seems mighty complex, and not likely to win much. That's a noticable
win:
   text	   data	    bss	    dec	    hex	filename
  72857	   8141	      8	  81006	  13c6e	fs/io_uring.o
  76959	   8237	      8	  85204	  14cd4	fs/io_uring.before.o
--- /tmp/before.txt	2020-02-23 21:00:16.316753022 -0800
+++ /tmp/after.txt	2020-02-23 23:10:44.979496728 -0800
-io_commit_cqring 00000000000003ef
+io_commit_cqring 000000000000012c
+io_free_req 000000000000005e
-io_free_req 00000000000002ed
-io_issue_sqe 0000000000001101
+io_issue_sqe 0000000000000e86
-io_poll_remove_one 0000000000000308
+io_poll_remove_one 0000000000000074
-io_poll_wake 0000000000000498
+io_poll_wake 000000000000021c
+io_queue_async_work 00000000000002a0
-io_queue_sqe 00000000000008cc
+io_queue_sqe 0000000000000391


Not quite sure what the policy is with attaching POC patches? Also send
as separate emails?

Greetings,

Andres Freund

--5xcvbplkbi3nv3hh
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="v1-0001-WIP-io_uring-Deduplicate-request-prep.patch"

From edb629fc246ef146ad4e25bc51fd3f5db797b2be Mon Sep 17 00:00:00 2001
From: Andres Freund <andres@anarazel.de>
Date: Sun, 23 Feb 2020 22:22:33 -0800
Subject: [PATCH v1 1/2] WIP: io_uring: Deduplicate request prep.

Signed-off-by: Andres Freund <andres@anarazel.de>
---
 fs/io_uring.c | 192 +++++++++++++-------------------------------------
 1 file changed, 49 insertions(+), 143 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index de650df9ac53..9a8fda8b28c9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4116,31 +4116,24 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock)
 	return 0;
 }
 
-static int io_req_defer_prep(struct io_kiocb *req,
-			     const struct io_uring_sqe *sqe)
+static inline int io_req_prep(u8 opcode, struct io_kiocb *req,
+			      const struct io_uring_sqe *sqe,
+			      bool force_nonblock)
 {
 	ssize_t ret = 0;
 
-	if (io_op_defs[req->opcode].file_table) {
-		ret = io_grab_files(req);
-		if (unlikely(ret))
-			return ret;
-	}
-
-	io_req_work_grab_env(req, &io_op_defs[req->opcode]);
-
-	switch (req->opcode) {
+	switch (opcode) {
 	case IORING_OP_NOP:
 		break;
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 	case IORING_OP_READ:
-		ret = io_read_prep(req, sqe, true);
+		ret = io_read_prep(req, sqe, force_nonblock);
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
-		ret = io_write_prep(req, sqe, true);
+		ret = io_write_prep(req, sqe, force_nonblock);
 		break;
 	case IORING_OP_POLL_ADD:
 		ret = io_poll_add_prep(req, sqe);
@@ -4162,23 +4155,23 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_RECV:
 		ret = io_recvmsg_prep(req, sqe);
 		break;
-	case IORING_OP_CONNECT:
-		ret = io_connect_prep(req, sqe);
-		break;
 	case IORING_OP_TIMEOUT:
 		ret = io_timeout_prep(req, sqe, false);
 		break;
 	case IORING_OP_TIMEOUT_REMOVE:
 		ret = io_timeout_remove_prep(req, sqe);
 		break;
+	case IORING_OP_ACCEPT:
+		ret = io_accept_prep(req, sqe);
+		break;
 	case IORING_OP_ASYNC_CANCEL:
 		ret = io_async_cancel_prep(req, sqe);
 		break;
 	case IORING_OP_LINK_TIMEOUT:
 		ret = io_timeout_prep(req, sqe, true);
 		break;
-	case IORING_OP_ACCEPT:
-		ret = io_accept_prep(req, sqe);
+	case IORING_OP_CONNECT:
+		ret = io_connect_prep(req, sqe);
 		break;
 	case IORING_OP_FALLOCATE:
 		ret = io_fallocate_prep(req, sqe);
@@ -4217,6 +4210,23 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	return ret;
 }
 
+static int io_req_defer_prep(struct io_kiocb *req,
+			     const struct io_uring_sqe *sqe)
+{
+	ssize_t ret = 0;
+	u8 opcode = req->opcode;
+
+	if (io_op_defs[opcode].file_table) {
+		ret = io_grab_files(req);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	io_req_work_grab_env(req, &io_op_defs[opcode]);
+
+	return io_req_prep(opcode, req, sqe, true);
+}
+
 static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -4278,198 +4288,94 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			struct io_kiocb **nxt, bool force_nonblock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	/* allow compiler to infer opcode doesn't change */
+	u8 opcode = req->opcode;
 	int ret;
 
-	switch (req->opcode) {
+	if (sqe) {
+		ret = io_req_prep(opcode, req, sqe, force_nonblock);
+		if (ret)
+			return ret;
+	}
+
+	switch (opcode) {
 	case IORING_OP_NOP:
 		ret = io_nop(req);
 		break;
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 	case IORING_OP_READ:
-		if (sqe) {
-			ret = io_read_prep(req, sqe, force_nonblock);
-			if (ret < 0)
-				break;
-		}
 		ret = io_read(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
-		if (sqe) {
-			ret = io_write_prep(req, sqe, force_nonblock);
-			if (ret < 0)
-				break;
-		}
 		ret = io_write(req, nxt, force_nonblock);
 		break;
-	case IORING_OP_FSYNC:
-		if (sqe) {
-			ret = io_prep_fsync(req, sqe);
-			if (ret < 0)
-				break;
-		}
-		ret = io_fsync(req, nxt, force_nonblock);
-		break;
 	case IORING_OP_POLL_ADD:
-		if (sqe) {
-			ret = io_poll_add_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_poll_add(req, nxt);
 		break;
 	case IORING_OP_POLL_REMOVE:
-		if (sqe) {
-			ret = io_poll_remove_prep(req, sqe);
-			if (ret < 0)
-				break;
-		}
 		ret = io_poll_remove(req);
 		break;
+	case IORING_OP_FSYNC:
+		ret = io_fsync(req, nxt, force_nonblock);
+		break;
 	case IORING_OP_SYNC_FILE_RANGE:
-		if (sqe) {
-			ret = io_prep_sfr(req, sqe);
-			if (ret < 0)
-				break;
-		}
 		ret = io_sync_file_range(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_SENDMSG:
+		ret = io_sendmsg(req, nxt, force_nonblock);
+		break;
 	case IORING_OP_SEND:
-		if (sqe) {
-			ret = io_sendmsg_prep(req, sqe);
-			if (ret < 0)
-				break;
-		}
-		if (req->opcode == IORING_OP_SENDMSG)
-			ret = io_sendmsg(req, nxt, force_nonblock);
-		else
-			ret = io_send(req, nxt, force_nonblock);
+		ret = io_send(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_RECVMSG:
+		ret = io_recvmsg(req, nxt, force_nonblock);
+		break;
 	case IORING_OP_RECV:
-		if (sqe) {
-			ret = io_recvmsg_prep(req, sqe);
-			if (ret)
-				break;
-		}
-		if (req->opcode == IORING_OP_RECVMSG)
-			ret = io_recvmsg(req, nxt, force_nonblock);
-		else
-			ret = io_recv(req, nxt, force_nonblock);
+		ret = io_recv(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_TIMEOUT:
-		if (sqe) {
-			ret = io_timeout_prep(req, sqe, false);
-			if (ret)
-				break;
-		}
 		ret = io_timeout(req);
 		break;
 	case IORING_OP_TIMEOUT_REMOVE:
-		if (sqe) {
-			ret = io_timeout_remove_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_timeout_remove(req);
 		break;
 	case IORING_OP_ACCEPT:
-		if (sqe) {
-			ret = io_accept_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_accept(req, nxt, force_nonblock);
 		break;
-	case IORING_OP_CONNECT:
-		if (sqe) {
-			ret = io_connect_prep(req, sqe);
-			if (ret)
-				break;
-		}
-		ret = io_connect(req, nxt, force_nonblock);
-		break;
 	case IORING_OP_ASYNC_CANCEL:
-		if (sqe) {
-			ret = io_async_cancel_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_async_cancel(req, nxt);
 		break;
+	case IORING_OP_CONNECT:
+		ret = io_connect(req, nxt, force_nonblock);
+		break;
 	case IORING_OP_FALLOCATE:
-		if (sqe) {
-			ret = io_fallocate_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_fallocate(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_OPENAT:
-		if (sqe) {
-			ret = io_openat_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_openat(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_CLOSE:
-		if (sqe) {
-			ret = io_close_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_close(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_FILES_UPDATE:
-		if (sqe) {
-			ret = io_files_update_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_files_update(req, force_nonblock);
 		break;
 	case IORING_OP_STATX:
-		if (sqe) {
-			ret = io_statx_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_statx(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_FADVISE:
-		if (sqe) {
-			ret = io_fadvise_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_fadvise(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_MADVISE:
-		if (sqe) {
-			ret = io_madvise_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_madvise(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_OPENAT2:
-		if (sqe) {
-			ret = io_openat2_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_openat2(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_EPOLL_CTL:
-		if (sqe) {
-			ret = io_epoll_ctl_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_epoll_ctl(req, nxt, force_nonblock);
 		break;
 	default:
-- 
2.25.0.114.g5b0ca878e0


--5xcvbplkbi3nv3hh
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="v1-0002-WIP-io_uring-Separate-blocking-nonblocking-io_iss.patch"

From 4efd092e07207d18b2f0fdbc6e68e93d5e7c93b0 Mon Sep 17 00:00:00 2001
From: Andres Freund <andres@anarazel.de>
Date: Sun, 23 Feb 2020 23:06:58 -0800
Subject: [PATCH v1 2/2] WIP: io_uring: Separate blocking/nonblocking
 io_issue_sqe cases.

Signed-off-by: Andres Freund <andres@anarazel.de>
---
 fs/io_uring.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9a8fda8b28c9..b149ab57c5b4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4284,20 +4284,12 @@ static void io_cleanup_req(struct io_kiocb *req)
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 }
 
-static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+static inline int __io_issue_sqe(u8 opcode, struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			struct io_kiocb **nxt, bool force_nonblock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	/* allow compiler to infer opcode doesn't change */
-	u8 opcode = req->opcode;
 	int ret;
 
-	if (sqe) {
-		ret = io_req_prep(opcode, req, sqe, force_nonblock);
-		if (ret)
-			return ret;
-	}
-
 	switch (opcode) {
 	case IORING_OP_NOP:
 		ret = io_nop(req);
@@ -4405,6 +4397,25 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
+static int io_prep_issue_sqe_nonblock(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+				   struct io_kiocb **nxt)
+{
+	/* allow compiler to infer opcode doesn't change */
+	u8 opcode = req->opcode;
+	int ret;
+
+	ret = io_req_prep(opcode, req, sqe, true);
+	if (ret)
+		return ret;
+
+	return __io_issue_sqe(opcode, req, NULL, nxt, true);
+}
+
+static int io_issue_sqe_block(struct io_kiocb *req, struct io_kiocb **nxt)
+{
+	return __io_issue_sqe(req->opcode, req, NULL, nxt, false);
+}
+
 static void io_wq_submit_work(struct io_wq_work **workptr)
 {
 	struct io_wq_work *work = *workptr;
@@ -4421,7 +4432,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	if (!ret) {
 		req->in_async = true;
 		do {
-			ret = io_issue_sqe(req, NULL, &nxt, false);
+			ret = io_issue_sqe_block(req, &nxt);
 			/*
 			 * We can get EAGAIN for polled IO even though we're
 			 * forcing a sync submission from here, since we can't
@@ -4616,7 +4627,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 again:
 	linked_timeout = io_prep_linked_timeout(req);
 
-	ret = io_issue_sqe(req, sqe, &nxt, true);
+	ret = io_prep_issue_sqe_nonblock(req, sqe, &nxt);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
-- 
2.25.0.114.g5b0ca878e0


--5xcvbplkbi3nv3hh--

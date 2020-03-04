Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D71417975B
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 19:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgCDSA0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 13:00:26 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:33612 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbgCDSAZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 13:00:25 -0500
Received: by mail-il1-f194.google.com with SMTP id r4so2616475iln.0
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 10:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H4wqg+1oG0d+aJ0bEA61gWzXQeDHaGTWMH/LO7ETIrE=;
        b=ai5E57HBYQ25Skq9FDZmwXMnf18EhvqvPAe+QONV2ybmeK1cRW7HoVZ1UkyigRgAj5
         qa9DIiU5cjSndYm6lVHshKJr6z5Zxw5cfZdt6kKIdB7YbfyxsCYa0y4v7et9JsEgo+Ig
         LFyuJj2qJbas7o8EGcNL1dFajF9AWzqFkQXEvy9EYaD0MpVpkihhakckGyxY7KTv0IwH
         XJl8Y8sx+NA1+DgrfpYklEJJF+/KcudKBUY2NruwO71TRIBKbdandBZg6SrNSpvuNQPJ
         1z7Vl+w8wIBMe1fIHJ36/FK2bLJeXrex6/zAi6jzngkszlPNaLUKzZUg/j/levvCbqTn
         qk6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4wqg+1oG0d+aJ0bEA61gWzXQeDHaGTWMH/LO7ETIrE=;
        b=I0CT6rRpQhCg+HAeJxgmOWFW0cl55gMwy1luAdqps1oYvL1zsnRVJ3yd4uU6j9kbX2
         GJC/2qVGNO55H3OsGJKtTGYCl86AVxNL48DN1ltFqn/t6fFgzNkDjUoWdPsvftcHMBFS
         hEI7VRtn09uf6Q1ri20fDjsPaCvWbSPUasr+o83QaKh7zIb1dTTQHQmG4DzwDOXNIAW/
         glK1DlhWqsM7BX/KyJQDNoKaI/1cYCtYlOfUolOEQB/j+T6uVRlvbGecgQIQ2aVUur3Z
         C14Ra/i7ZRVeOUc7k9+DTYO00ywqhmuoeHRsi8pRLvE/w1A/9rV8GiwuMnOcgMOyb0Kl
         7GGA==
X-Gm-Message-State: ANhLgQ2+gJwJmvmN1VkePBeqA2Y0theRPSep3jjlW1drQ6x+S1p11tE8
        tQwDysd6oJ7SuVChx15z/0dYNSgHE/c=
X-Google-Smtp-Source: ADFU+vsrUGbybcywJOrT7FQhG8BXmBUGZ63lCxTEr0qbuhuE9yy8pHtQpridSYV4psjnywTQFNrQ8w==
X-Received: by 2002:a92:1a12:: with SMTP id a18mr3837981ila.10.1583344823337;
        Wed, 04 Mar 2020 10:00:23 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p23sm6715187ioo.54.2020.03.04.10.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 10:00:22 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     jlayton@kernel.org, josh@joshtriplett.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring: support deferred retrival of file from fd
Date:   Wed,  4 Mar 2020 11:00:14 -0700
Message-Id: <20200304180016.28212-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200304180016.28212-1-axboe@kernel.dk>
References: <20200304180016.28212-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We might not be able to grab the file we need at prep time, if the fd
needed is dependent on completion of another request. Support deferred
fd lookup.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ed70ac09ca18..a1fc0d2acf91 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -511,6 +511,7 @@ enum {
 	REQ_F_OVERFLOW_BIT,
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
+	REQ_F_DEFERRED_FD_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -562,6 +563,8 @@ enum {
 	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
 	/* buffer already selected */
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
+	/* file assignment has been deferred */
+	REQ_F_DEFERRED_FD	= BIT(REQ_F_DEFERRED_FD_BIT),
 };
 
 struct async_poll {
@@ -599,6 +602,7 @@ struct io_kiocb {
 	struct io_async_ctx		*io;
 	bool				needs_fixed_file;
 	u8				opcode;
+	int				deferred_fd;
 
 	struct io_ring_ctx	*ctx;
 	struct list_head	list;
@@ -5002,6 +5006,12 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
+	if (req->flags & REQ_F_DEFERRED_FD) {
+		ret = io_file_get(NULL, req, req->deferred_fd, &req->file, false);
+		if (ret)
+			return ret;
+	}
+
 	switch (req->opcode) {
 	case IORING_OP_NOP:
 		ret = io_nop(req);
@@ -5328,7 +5338,7 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 			   const struct io_uring_sqe *sqe)
 {
 	unsigned flags;
-	int fd;
+	int fd, ret;
 	bool fixed;
 
 	flags = READ_ONCE(sqe->flags);
@@ -5341,7 +5351,14 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 	if (unlikely(!fixed && req->needs_fixed_file))
 		return -EBADF;
 
-	return io_file_get(state, req, fd, &req->file, fixed);
+	ret = io_file_get(state, req, fd, &req->file, fixed);
+	if (ret) {
+		if (fixed)
+			return ret;
+		req->deferred_fd = fd;
+		req->flags |= REQ_F_DEFERRED_FD;
+	}
+	return 0;
 }
 
 static int io_grab_files(struct io_kiocb *req)
-- 
2.25.1


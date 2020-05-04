Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BB31C472A
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 21:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgEDTkz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 15:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbgEDTky (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 15:40:54 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E538C061A0E;
        Mon,  4 May 2020 12:40:53 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id x25so811959wmc.0;
        Mon, 04 May 2020 12:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x6Diq7oRDqkTM6TkRVDLHHEx/9bVRKYWWWp7nV67j3Y=;
        b=LJ3MgiAf01pnCAbWw5QEkH3TmTqN+dvb+8pn/5kpoqL4SmiTkWPns9pps/IzP3o0m1
         m1Cws2aYFu1A9BzK5wFGGEi930x/9va2D0GVN5VzWLN4TziNkaUMQbCsPNFnc4mA8D1J
         MTR6htRme5PAiF1k7srA1cgeBYYIhCEuNU2d0U1pWw0kg2FpkVaPYOe5QktGU481wt0q
         FdNQ80n7kvFiCn5yreAXWVtb/E36ENPVj+j8/vrOfNZv1z63MhVdHxlJxUFWVrWi+0I4
         5LBaof8eHYCEMBjZmmQ0/VPsJtpgeQd2I7Rf58Ofk9sb5G7dbVoniyxCVjPqaSV/48iL
         IfuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x6Diq7oRDqkTM6TkRVDLHHEx/9bVRKYWWWp7nV67j3Y=;
        b=gr8/sNlNyzCuw6eMhz9I4u8G1ePWWzFs80lF63iVPnbR25UdaHjWGBGov/hrzLx5sF
         tjNQaW/JFwMwVJThAL0wVtE27Y9UGeXFKSrPS8SLqc0WbU5XIVj9+GVFyWHiGh8ZvP5f
         Yln7HAufgz1hDNvfT4jbeDHnzjQLQIwU9Au8lYwh1xVPeLVd3gEDC4skmLCcigfj9COB
         sV0fjpOMVFrlat+QplHAj4fgtocPieaKTHA6Fsp0EzPMn7lvtJ7+O0RoQj/Eq47IU/ST
         3Ttibt3LBGFB4AiUULBMK7ZEa+2BV1YbCO3VFMvKHplHuwR9CmqksCkI1C629uiNnwUX
         5nTw==
X-Gm-Message-State: AGi0PuYzPDkDiUT/2OCQx4DKLdTUFy59nIRsm3VATJZaMitrH9yws9fd
        qkMIKFQ28jS+VHWi2b9I3K/IpgNF
X-Google-Smtp-Source: APiQypLkHMh9K10m3x2j4o9IHRGVNPo0tI7hiQOIARjkOtfiYiT0jvUOuZIq7vzZETWGoipI+DPcXA==
X-Received: by 2002:a7b:c390:: with SMTP id s16mr15630119wmj.14.1588621252336;
        Mon, 04 May 2020 12:40:52 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id s6sm696602wmh.17.2020.05.04.12.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 12:40:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH for-5.7] splice: move f_mode checks to do_{splice,tee}()
Date:   Mon,  4 May 2020 22:39:35 +0300
Message-Id: <51b4370ef70eebf941f6cef503943d7f7de3ea4d.1588621153.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

do_splice() is used by io_uring, as will be do_tee(). Move f_mode
checks from sys_{splice,tee}() to do_{splice,tee}(), so they're
enforced for io_uring as well.

Fixes: 7d67af2c0134 ("io_uring: add splice(2) support")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/splice.c | 45 ++++++++++++++++++---------------------------
 1 file changed, 18 insertions(+), 27 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 4735defc46ee..fd0a1e7e5959 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1118,6 +1118,10 @@ long do_splice(struct file *in, loff_t __user *off_in,
 	loff_t offset;
 	long ret;
 
+	if (unlikely(!(in->f_mode & FMODE_READ) ||
+		     !(out->f_mode & FMODE_WRITE)))
+		return -EBADF;
+
 	ipipe = get_pipe_info(in);
 	opipe = get_pipe_info(out);
 
@@ -1125,12 +1129,6 @@ long do_splice(struct file *in, loff_t __user *off_in,
 		if (off_in || off_out)
 			return -ESPIPE;
 
-		if (!(in->f_mode & FMODE_READ))
-			return -EBADF;
-
-		if (!(out->f_mode & FMODE_WRITE))
-			return -EBADF;
-
 		/* Splicing to self would be fun, but... */
 		if (ipipe == opipe)
 			return -EINVAL;
@@ -1153,9 +1151,6 @@ long do_splice(struct file *in, loff_t __user *off_in,
 			offset = out->f_pos;
 		}
 
-		if (unlikely(!(out->f_mode & FMODE_WRITE)))
-			return -EBADF;
-
 		if (unlikely(out->f_flags & O_APPEND))
 			return -EINVAL;
 
@@ -1440,15 +1435,11 @@ SYSCALL_DEFINE6(splice, int, fd_in, loff_t __user *, off_in,
 	error = -EBADF;
 	in = fdget(fd_in);
 	if (in.file) {
-		if (in.file->f_mode & FMODE_READ) {
-			out = fdget(fd_out);
-			if (out.file) {
-				if (out.file->f_mode & FMODE_WRITE)
-					error = do_splice(in.file, off_in,
-							  out.file, off_out,
-							  len, flags);
-				fdput(out);
-			}
+		out = fdget(fd_out);
+		if (out.file) {
+			error = do_splice(in.file, off_in, out.file, off_out,
+					  len, flags);
+			fdput(out);
 		}
 		fdput(in);
 	}
@@ -1770,6 +1761,10 @@ static long do_tee(struct file *in, struct file *out, size_t len,
 	struct pipe_inode_info *opipe = get_pipe_info(out);
 	int ret = -EINVAL;
 
+	if (unlikely(!(in->f_mode & FMODE_READ) ||
+		     !(out->f_mode & FMODE_WRITE)))
+		return -EBADF;
+
 	/*
 	 * Duplicate the contents of ipipe to opipe without actually
 	 * copying the data.
@@ -1795,7 +1790,7 @@ static long do_tee(struct file *in, struct file *out, size_t len,
 
 SYSCALL_DEFINE4(tee, int, fdin, int, fdout, size_t, len, unsigned int, flags)
 {
-	struct fd in;
+	struct fd in, out;
 	int error;
 
 	if (unlikely(flags & ~SPLICE_F_ALL))
@@ -1807,14 +1802,10 @@ SYSCALL_DEFINE4(tee, int, fdin, int, fdout, size_t, len, unsigned int, flags)
 	error = -EBADF;
 	in = fdget(fdin);
 	if (in.file) {
-		if (in.file->f_mode & FMODE_READ) {
-			struct fd out = fdget(fdout);
-			if (out.file) {
-				if (out.file->f_mode & FMODE_WRITE)
-					error = do_tee(in.file, out.file,
-							len, flags);
-				fdput(out);
-			}
+		out = fdget(fdout);
+		if (out.file) {
+			error = do_tee(in.file, out.file, len, flags);
+			fdput(out);
 		}
  		fdput(in);
  	}
-- 
2.24.0


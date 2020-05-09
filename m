Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19CB1CBF58
	for <lists+io-uring@lfdr.de>; Sat,  9 May 2020 10:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgEIIrf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 May 2020 04:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbgEIIrf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 May 2020 04:47:35 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195F5C061A0C;
        Sat,  9 May 2020 01:47:35 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g14so2782945wme.1;
        Sat, 09 May 2020 01:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vpA2mMnqtCdcczzkn/BswPLFEz3AqGdCg7CXXHUsINQ=;
        b=fsf5L63RngfsFHogIddKCefBwaJMD0i/7d0SGXzwlzuQj5veMbf37TVxzV3XhU9pPz
         W3ajImjcN6U19WkMWXjlRHamJXtXoycA2qWpk2mE6P3NhptdU5Yrfri5GHcyqow04Aeu
         RXDko3XlzZDmtJqLLe67ojhStsta03uAlGDfjh0p1FcSe4yWUMYxG4tT0HHRFh+lLRhI
         NdVWae3mQ3/hEHGcMkmdPgwsWrnAq33BteCX+tAKcHnVTl6zeFJKgexr10cKOvW3KRJy
         8XNpqln4a2EZBODt9MIcl+XAwEnOYXh4XzfZQJrf+VQQw0tuPFW9SubM+p0FJeyHqGOs
         pDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vpA2mMnqtCdcczzkn/BswPLFEz3AqGdCg7CXXHUsINQ=;
        b=fqN58LfDSs52XzzazE5KnzNYwKCqMkxVhluubeFKrkBD2glSI8FwajeEqa9Ql4V2mE
         yVCOZGvB2hIi2Vb6m0jSuntmuhsfGfb6/IrNWECgtQ3xH3eWDO+lhfBSb8JvUHJBx5aQ
         FdLcC8w5A3j9nPNOFrAC/+PV7KctspnY0N3FQP52jtsnmVrUy0orgRghhCF0B+H+a9AH
         b081hbZMjqjgW+KHS1UsxpTQH8XhXlf7yx5fKE5o6vAIsvD/b9dCiRa5I3TGB1cgWIZP
         lnOALqlNLJ67Jxyg6rAfj7RXv7GxFrVxfOzeZ37h++sxEZlFFN0BDJSlXTSyO0b3WPxa
         n9WQ==
X-Gm-Message-State: AGi0PuZvGJLS8rL9ZSV4hASmZoRjyjuzRCqeA0y6GTddoBrP3tWDFGQX
        3as1fevObWnXl5bJhwLQ48aI5TI7
X-Google-Smtp-Source: APiQypKZkVDG+otFrlSCvBOkm7q7k+tzlXizLMWX5sXQxqKVfB8TYKqQb5B6dyx1LlKk2FYszyfWBQ==
X-Received: by 2002:a7b:cf23:: with SMTP id m3mr19772826wmg.36.1589014053596;
        Sat, 09 May 2020 01:47:33 -0700 (PDT)
Received: from localhost.localdomain ([46.191.65.149])
        by smtp.gmail.com with ESMTPSA id b20sm16145044wme.9.2020.05.09.01.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 01:47:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] splice/tee: len=0 fast path after validity check
Date:   Sat,  9 May 2020 11:46:18 +0300
Message-Id: <14d4955e8c232ea7d2cbb2c2409be789499e0452.1589013737.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When len=0, splice() and tee() return 0 even if specified fds are
invalid, hiding errors from users. Move len=0 optimisation later after
basic validity checks.

before:
splice(len=0, fd_in=-1, ...) == 0;

after:
splice(len=0, fd_in=-1, ...) == -EBADF;

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Totally leaving it at yours judgment, but it'd be nice to have
for io_uring as well.

 fs/splice.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index a1dd54de24d8..8d6fc690f8e9 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1122,6 +1122,9 @@ long do_splice(struct file *in, loff_t __user *off_in,
 		     !(out->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
+	if (unlikely(!len))
+		return 0;
+
 	ipipe = get_pipe_info(in);
 	opipe = get_pipe_info(out);
 
@@ -1426,9 +1429,6 @@ SYSCALL_DEFINE6(splice, int, fd_in, loff_t __user *, off_in,
 	struct fd in, out;
 	long error;
 
-	if (unlikely(!len))
-		return 0;
-
 	if (unlikely(flags & ~SPLICE_F_ALL))
 		return -EINVAL;
 
@@ -1535,7 +1535,6 @@ static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 	int ret = 0;
 	bool input_wakeup = false;
 
-
 retry:
 	ret = ipipe_prep(ipipe, flags);
 	if (ret)
@@ -1769,6 +1768,9 @@ long do_tee(struct file *in, struct file *out, size_t len, unsigned int flags)
 	 * copying the data.
 	 */
 	if (ipipe && opipe && ipipe != opipe) {
+		if (unlikely(!len))
+			return 0;
+
 		if ((in->f_flags | out->f_flags) & O_NONBLOCK)
 			flags |= SPLICE_F_NONBLOCK;
 
@@ -1795,9 +1797,6 @@ SYSCALL_DEFINE4(tee, int, fdin, int, fdout, size_t, len, unsigned int, flags)
 	if (unlikely(flags & ~SPLICE_F_ALL))
 		return -EINVAL;
 
-	if (unlikely(!len))
-		return 0;
-
 	error = -EBADF;
 	in = fdget(fdin);
 	if (in.file) {
-- 
2.24.0


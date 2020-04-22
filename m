Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170061B36CE
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2020 07:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbgDVFUa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Apr 2020 01:20:30 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:48245 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgDVFUa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Apr 2020 01:20:30 -0400
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id D539D100004;
        Wed, 22 Apr 2020 05:20:23 +0000 (UTC)
Date:   Tue, 21 Apr 2020 22:20:20 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Aleksa Sarai <cyphar@cyphar.com>, linux-man@vger.kernel.org
Subject: [PATCH v5 3/3] fs: pipe2: Support O_SPECIFIC_FD
Message-ID: <2bb2e92c688b97247f644fe8220054d6c6b66b65.1587531463.git.josh@joshtriplett.org>
References: <cover.1587531463.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1587531463.git.josh@joshtriplett.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This allows the caller of pipe2 to specify one or both file descriptors
rather than having them automatically use the lowest available file
descriptor. The caller can specify either file descriptor as -1 to
allow that file descriptor to use the lowest available.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/pipe.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 16fb72e9abf7..4681a0d1d587 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -936,19 +936,19 @@ static int __do_pipe_flags(int *fd, struct file **files, int flags)
 	int error;
 	int fdw, fdr;
 
-	if (flags & ~(O_CLOEXEC | O_NONBLOCK | O_DIRECT))
+	if (flags & ~(O_CLOEXEC | O_NONBLOCK | O_DIRECT | O_SPECIFIC_FD))
 		return -EINVAL;
 
 	error = create_pipe_files(files, flags);
 	if (error)
 		return error;
 
-	error = get_unused_fd_flags(flags);
+	error = get_specific_unused_fd_flags(fd[0], flags);
 	if (error < 0)
 		goto err_read_pipe;
 	fdr = error;
 
-	error = get_unused_fd_flags(flags);
+	error = get_specific_unused_fd_flags(fd[1], flags);
 	if (error < 0)
 		goto err_fdr;
 	fdw = error;
@@ -969,7 +969,11 @@ static int __do_pipe_flags(int *fd, struct file **files, int flags)
 int do_pipe_flags(int *fd, int flags)
 {
 	struct file *files[2];
-	int error = __do_pipe_flags(fd, files, flags);
+	int error;
+
+	if (flags & O_SPECIFIC_FD)
+		return -EINVAL;
+	error = __do_pipe_flags(fd, files, flags);
 	if (!error) {
 		fd_install(fd[0], files[0]);
 		fd_install(fd[1], files[1]);
@@ -987,6 +991,10 @@ static int do_pipe2(int __user *fildes, int flags)
 	int fd[2];
 	int error;
 
+	if (flags & O_SPECIFIC_FD)
+		if (copy_from_user(fd, fildes, sizeof(fd)))
+			return -EFAULT;
+
 	error = __do_pipe_flags(fd, files, flags);
 	if (!error) {
 		if (unlikely(copy_to_user(fildes, fd, sizeof(fd)))) {
-- 
2.26.2


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D006C1792C7
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 15:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgCDOxz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 09:53:55 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:59953 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgCDOxz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 09:53:55 -0500
X-Originating-IP: 50.39.173.182
Received: from localhost (50-39-173-182.bvtn.or.frontiernet.net [50.39.173.182])
        (Authenticated sender: josh@joshtriplett.org)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 0D47240011;
        Wed,  4 Mar 2020 14:53:52 +0000 (UTC)
Date:   Wed, 4 Mar 2020 06:53:51 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH WIP 3/3] fs: pipe2: Support O_SPECIFIC_FD
Message-ID: <402a713780960758480361b707056a57d8d7a1c6.1583333579.git.josh@joshtriplett.org>
References: <20200304143548.GA407676@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304143548.GA407676@localhost>
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
 fs/pipe.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 2144507447c5..7bc576836ec0 100644
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
@@ -969,7 +969,10 @@ static int __do_pipe_flags(int *fd, struct file **files, int flags)
 int do_pipe_flags(int *fd, int flags)
 {
 	struct file *files[2];
-	int error = __do_pipe_flags(fd, files, flags);
+	int error;
+	if (flags & O_SPECIFIC_FD)
+		return -EINVAL;
+	error = __do_pipe_flags(fd, files, flags);
 	if (!error) {
 		fd_install(fd[0], files[0]);
 		fd_install(fd[1], files[1]);
@@ -987,6 +990,10 @@ static int do_pipe2(int __user *fildes, int flags)
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
2.25.1


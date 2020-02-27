Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C878E17183B
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2020 14:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgB0NI7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Feb 2020 08:08:59 -0500
Received: from sym2.noone.org ([178.63.92.236]:45588 "EHLO sym2.noone.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729075AbgB0NI6 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 27 Feb 2020 08:08:58 -0500
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 48StKN3Wnkzvjc1; Thu, 27 Feb 2020 14:08:56 +0100 (CET)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH] io_uring: use correct CONFIG_PROC_FS define
Date:   Thu, 27 Feb 2020 14:08:56 +0100
Message-Id: <20200227130856.15148-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Commit 6f283fe2b1ed ("io_uring: define and set show_fdinfo only if
procfs is enabled") used CONFIG_PROCFS by mistake. Correct it.

Fixes: 6f283fe2b1ed ("io_uring: define and set show_fdinfo only if procfs is enabled")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bab973106566..05eea06f5421 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6641,7 +6641,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	return submitted ? submitted : ret;
 }
 
-#ifdef CONFIG_PROCFS
+#ifdef CONFIG_PROC_FS
 static int io_uring_show_cred(int id, void *p, void *data)
 {
 	const struct cred *cred = p;
@@ -6727,7 +6727,7 @@ static const struct file_operations io_uring_fops = {
 #endif
 	.poll		= io_uring_poll,
 	.fasync		= io_uring_fasync,
-#ifdef CONFIG_PROCFS
+#ifdef CONFIG_PROC_FS
 	.show_fdinfo	= io_uring_show_fdinfo,
 #endif
 };
-- 
2.25.0


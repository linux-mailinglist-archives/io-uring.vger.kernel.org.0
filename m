Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7415170668
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 18:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgBZRpQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 12:45:16 -0500
Received: from sym2.noone.org ([178.63.92.236]:55126 "EHLO sym2.noone.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgBZRpP (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 26 Feb 2020 12:45:15 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Feb 2020 12:45:15 EST
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 48SNLw6Yxzzvjc1; Wed, 26 Feb 2020 18:38:32 +0100 (CET)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH] io_uring:  define and set show_fdinfo only if procfs is enabled
Date:   Wed, 26 Feb 2020 18:38:32 +0100
Message-Id: <20200226173832.17773-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Follow the pattern used with other *_show_fdinfo functions and only
define and use io_uring_show_fdinfo and its helper functions if
CONFIG_PROCFS is set.

Fixes: 87ce955b24c9 ("io_uring: add ->show_fdinfo() for the io_uring file descriptor")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index de650df9ac53..1a0138d98b60 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6647,6 +6647,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	return submitted ? submitted : ret;
 }
 
+#ifdef CONFIG_PROCFS
 static int io_uring_show_cred(int id, void *p, void *data)
 {
 	const struct cred *cred = p;
@@ -6720,6 +6721,7 @@ static void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 		percpu_ref_put(&ctx->refs);
 	}
 }
+#endif
 
 static const struct file_operations io_uring_fops = {
 	.release	= io_uring_release,
@@ -6731,7 +6733,9 @@ static const struct file_operations io_uring_fops = {
 #endif
 	.poll		= io_uring_poll,
 	.fasync		= io_uring_fasync,
+#ifdef CONFIG_PROCFS
 	.show_fdinfo	= io_uring_show_fdinfo,
+#endif
 };
 
 static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
-- 
2.25.0


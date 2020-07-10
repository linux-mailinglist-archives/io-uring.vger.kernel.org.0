Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAABB21B897
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 16:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgGJO1E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 10:27:04 -0400
Received: from sym2.noone.org ([178.63.92.236]:46840 "EHLO sym2.noone.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgGJO1E (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 10 Jul 2020 10:27:04 -0400
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4B3Fjg4QyWzvjc1; Fri, 10 Jul 2020 16:27:03 +0200 (CEST)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     io-uring@vger.kernel.org
Subject: [PATCH] test/statx: test for ENOSYS in statx_syscall_supported
Date:   Fri, 10 Jul 2020 16:27:03 +0200
Message-Id: <20200710142703.32444-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

errno will be ENOSYS, not EOPNOTSUPP if the syscall is not there. This
also matches what errno is set to in do_statx if __NR_statx is not
defined.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 test/statx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/statx.c b/test/statx.c
index 66f333f93cf9..c846a4ad5b9f 100644
--- a/test/statx.c
+++ b/test/statx.c
@@ -51,7 +51,7 @@ static int create_file(const char *file, size_t size)
 
 static int statx_syscall_supported(void)
 {
-	return errno == EOPNOTSUPP ? 0 : -1;
+	return errno == ENOSYS ? 0 : -1;
 }
 
 static int test_statx(struct io_uring *ring, const char *path)
-- 
2.27.0


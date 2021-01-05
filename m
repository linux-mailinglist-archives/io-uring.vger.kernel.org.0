Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2964D2EB5E4
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 00:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbhAEXJD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jan 2021 18:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbhAEXJC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jan 2021 18:09:02 -0500
X-Greylist: delayed 444 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Jan 2021 15:08:22 PST
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78211C061574
        for <io-uring@vger.kernel.org>; Tue,  5 Jan 2021 15:08:22 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dagur.eu; s=default;
        t=1609887614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xYbYMNsRcn8zrTr0yYP8gV+cJMQy3yxYpjY0U5ZxpNs=;
        b=AHNo1qDr5JjMQEl8HWCJnd/UysAazDgPeEyEY17qE3bPbfTs/PmI5mI2hssAedENbicA6z
        vSdJ3/1UAaBIl1z8mVjlRaKdTbLE2+XNOeOglnUAyGeRgvBcMNUoBIQk5SrayJD02tKO72
        5H1q8AE8ICqLz9DLrWlS/cfa+7iZZhQ=
From:   arni@dagur.eu
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, =?UTF-8?q?=C3=81rni=20Dagur?= <arni@dagur.eu>
Subject: [PATCH 1/2] splice: Make vmsplice public
Message-Id: <20210105225932.1249603-2-arni@dagur.eu>
In-Reply-To: <20210105225932.1249603-1-arni@dagur.eu>
References: <20210105225932.1249603-1-arni@dagur.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: arni@dagur.eu
Date:   Tue, 05 Jan 2021 23:00:14 GMT
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Árni Dagur <arni@dagur.eu>

Create a public function do_vmsplice(), so that other parts of the
kernel can use it.

Signed-off-by: Árni Dagur <arni@dagur.eu>
---
 fs/splice.c            | 21 +++++++++++++++------
 include/linux/splice.h |  2 +-
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 866d5c2367b2..2d653a20cced 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1270,6 +1270,20 @@ static int vmsplice_type(struct fd f, int *type)
 	return 0;
 }
 
+long do_vmsplice(struct file *file, struct iov_iter *iter, unsigned int flags)
+{
+	long error;
+
+	if (!iov_iter_count(iter))
+		error = 0;
+	else if (iov_iter_rw(iter) == WRITE)
+		error = vmsplice_to_pipe(file, iter, flags);
+	else
+		error = vmsplice_to_user(file, iter, flags);
+
+	return error;
+}
+
 /*
  * Note that vmsplice only really supports true splicing _from_ user memory
  * to a pipe, not the other way around. Splicing from user memory is a simple
@@ -1309,12 +1323,7 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, uiov,
 	if (error < 0)
 		goto out_fdput;
 
-	if (!iov_iter_count(&iter))
-		error = 0;
-	else if (iov_iter_rw(&iter) == WRITE)
-		error = vmsplice_to_pipe(f.file, &iter, flags);
-	else
-		error = vmsplice_to_user(f.file, &iter, flags);
+	error = do_vmsplice(f.file, &iter, flags);
 
 	kfree(iov);
 out_fdput:
diff --git a/include/linux/splice.h b/include/linux/splice.h
index a55179fd60fc..44c0e612f652 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -81,9 +81,9 @@ extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 extern long do_splice(struct file *in, loff_t *off_in,
 		      struct file *out, loff_t *off_out,
 		      size_t len, unsigned int flags);
-
 extern long do_tee(struct file *in, struct file *out, size_t len,
 		   unsigned int flags);
+extern long do_vmsplice(struct file *file, struct iov_iter *iter, unsigned int flags);
 
 /*
  * for dynamic pipe sizing
-- 
2.30.0


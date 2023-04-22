Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE676EB807
	for <lists+io-uring@lfdr.de>; Sat, 22 Apr 2023 10:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjDVIky (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Apr 2023 04:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjDVIkx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Apr 2023 04:40:53 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9934419A8;
        Sat, 22 Apr 2023 01:40:49 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id CB667C01A; Sat, 22 Apr 2023 10:40:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682152847; bh=RA6UWL31G5rZTzHkX1AYBBgu9w7TFJ4fnvpZQaj5+Mg=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=JmbiAsZSL/seMxU/J7XKeeofqV9+ITvc76e6ns1Zep0ZpfmPlEUbq456d+FRRK9ma
         yZ1w0QeMcGCpTM3z5yK+x/3vJ8V9zU6j3vOBaFae/NNsk7ZtfZcspWLBbTI+Cm2+v8
         jVFWL45gQhnDBB9aK0fOI0iJD5ZYXf6iDJiTFdeo+ViNTz3K13JgkeaZ96x1otjKyH
         YK+jL2yvRDP/wMhcVfwHi/I48nXg1zCmMUa1WG4SK357UaxyOcEPuzbwG35i5OZwh6
         JFRBbmlVKZPZg0xNqMArYFOH6B4LHoaYovl5zwpXpcN9i1ApRzaC6v7rN5qm2yaz+P
         QquFIFMEyS/8g==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id CEDF1C009;
        Sat, 22 Apr 2023 10:40:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682152847; bh=RA6UWL31G5rZTzHkX1AYBBgu9w7TFJ4fnvpZQaj5+Mg=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=JmbiAsZSL/seMxU/J7XKeeofqV9+ITvc76e6ns1Zep0ZpfmPlEUbq456d+FRRK9ma
         yZ1w0QeMcGCpTM3z5yK+x/3vJ8V9zU6j3vOBaFae/NNsk7ZtfZcspWLBbTI+Cm2+v8
         jVFWL45gQhnDBB9aK0fOI0iJD5ZYXf6iDJiTFdeo+ViNTz3K13JgkeaZ96x1otjKyH
         YK+jL2yvRDP/wMhcVfwHi/I48nXg1zCmMUa1WG4SK357UaxyOcEPuzbwG35i5OZwh6
         JFRBbmlVKZPZg0xNqMArYFOH6B4LHoaYovl5zwpXpcN9i1ApRzaC6v7rN5qm2yaz+P
         QquFIFMEyS/8g==
Received: from [127.0.0.2] (localhost [::1])
        by odin.codewreck.org (OpenSMTPD) with ESMTP id e1be628b;
        Sat, 22 Apr 2023 08:40:36 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
Date:   Sat, 22 Apr 2023 17:40:18 +0900
Subject: [PATCH RFC 1/2] fs: split off vfs_getdents function of getdents64
 syscall
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230422-uring-getdents-v1-1-14c1db36e98c@codewreck.org>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
In-Reply-To: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=2445;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=Gh7fdCatlZczIf9VabQSU+kiFAoMRFxRCv7HGXEYR3E=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkQ52ENkniSXAAbmVN2Twl1R208JYpAVJA4z6+I
 RdAmroz4/OJAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZEOdhAAKCRCrTpvsapjm
 cLzeD/9lgmYuQM4qeN4s0UrUXOrMe7OnPWZtJN6Af/HJ+FnYYVKvV0rEWeMo8VUQi2cm44U4x4z
 WqduiImPchIbbQ1FjGl5Yaxhbltxs8dmCs1AyOr4VHOOL/g7x1YzlSQthMMZLyZSeRQ8dr4WwSf
 ww84tmrn81jkvYlo18GUznvmuwBqjLjnY+Gu5P0c9lUyNe5/6kHnG0lr3CPuACHxfkFvNxR69qK
 zFjM4F+SBkgfKrEPjkca9JsCIYCQB2DxXnrmtKwZScLa8H4eRWia29CbxZrg1DmOJV/dq+bU/R3
 0ykcgIwLn8E7+inTSwibLCig6Qwx8N2MuufEewPsmorEV/31+3xY/9VyYSmDEpmzt2XcoOktfCD
 JI4910CsUD5A3/lLIDOO7LhOoVbsls1kG6OZbUNs4hKanaizpt+nvnwFu61b6hRCP5PcIG9Gwxz
 xNsKKFMLN2L33NSk007QOm/vIXU/Wa7OH9AoQyu2sM+q3E+Yj1XDA3kggQxkvnqGbYNZK+u/UGy
 XNQbYm1lNAUpMH0V51BwNWAFoBSAVBKjHGV1sNdWArcABECR1sVZFE4TLHvssJB51TX7hTuUAkE
 e0OoRkM08czBtve0WlFjoK1R7gr5CrFHVkGJHN9OQzmMYJd7UYIIBm5+S7931algbAQRGQgWG33
 OCyjKCPoRvNX0xA==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits off the vfs_getdents function from the getdents64 system
call.
This will allow io_uring to call the vfs_getdents function.

Co-authored-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 fs/internal.h |  8 ++++++++
 fs/readdir.c  | 33 +++++++++++++++++++++++++--------
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index dc4eb91a577a..92eeaf3837d1 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -264,3 +264,11 @@ int setattr_should_drop_sgid(struct mnt_idmap *idmap,
 struct mnt_idmap *alloc_mnt_idmap(struct user_namespace *mnt_userns);
 struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
 void mnt_idmap_put(struct mnt_idmap *idmap);
+
+/*
+ * fs/readdir.c
+ */
+struct linux_dirent64;
+
+int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
+		 unsigned int count);
diff --git a/fs/readdir.c b/fs/readdir.c
index 9c53edb60c03..1d541a6f2d55 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -351,10 +351,16 @@ static bool filldir64(struct dir_context *ctx, const char *name, int namlen,
 	return false;
 }
 
-SYSCALL_DEFINE3(getdents64, unsigned int, fd,
-		struct linux_dirent64 __user *, dirent, unsigned int, count)
+
+/**
+ * vfs_getdents - getdents without fdget
+ * @file    : pointer to file struct of directory
+ * @dirent  : pointer to user directory structure
+ * @count   : size of buffer
+ */
+int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
+		 unsigned int count)
 {
-	struct fd f;
 	struct getdents_callback64 buf = {
 		.ctx.actor = filldir64,
 		.count = count,
@@ -362,11 +368,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 	};
 	int error;
 
-	f = fdget_pos(fd);
-	if (!f.file)
-		return -EBADF;
-
-	error = iterate_dir(f.file, &buf.ctx);
+	error = iterate_dir(file, &buf.ctx);
 	if (error >= 0)
 		error = buf.error;
 	if (buf.prev_reclen) {
@@ -379,6 +381,21 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 		else
 			error = count - buf.count;
 	}
+	return error;
+}
+
+SYSCALL_DEFINE3(getdents64, unsigned int, fd,
+		struct linux_dirent64 __user *, dirent, unsigned int, count)
+{
+	struct fd f;
+	int error;
+
+	f = fdget_pos(fd);
+	if (!f.file)
+		return -EBADF;
+
+	error = vfs_getdents(f.file, dirent, count);
+
 	fdput_pos(f);
 	return error;
 }

-- 
2.39.2


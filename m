Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50B359CABC
	for <lists+io-uring@lfdr.de>; Mon, 22 Aug 2022 23:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238020AbiHVVVT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Aug 2022 17:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238063AbiHVVVQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Aug 2022 17:21:16 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203F55208E
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 14:21:15 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id n21so8929410qkk.3
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 14:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc;
        bh=TfAr+WtZsNrKIQGkjBb/tfdPalG4u+PDPJ+/5QKn8xM=;
        b=6NLLC2at5hobLZFMb/PRSHQIazCOxWgouYVmGv9etSZepkU7+Mol1KWuO2tIQMgtn2
         899uZRz49DXPgdDGBwQKpV2H3FID/pXUncy8UgFZ0T2fC473arwt0vvUMYMBwskH7Mev
         yzHDyAjy45x1NM9nGjXXLTyDaFXH+VvpJGNg6Y2XcCDkKGSRbvI2UqLpC7setLR3CNNh
         +r7xB+roPetL+0c58wMVrDYTznXtTa6BVqgLueF0NKQzbLFKfw/CNGkhqeyO/XkEkGl+
         AN2ljaY60XfTDTvBIhJ1QnZBEPWyK5VGy6cAzlekIRJXxZZ4nHnDfW7b14QoFqkKNchu
         urOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-message-state
         :from:to:cc;
        bh=TfAr+WtZsNrKIQGkjBb/tfdPalG4u+PDPJ+/5QKn8xM=;
        b=sKRrtek0yn7wfD2r72ozaRClApnKjRmmCqi4/UGw2+yNwmLcuxTkxK6j9Zq+ZQoKNv
         dj180Qlall2QgXNOFLXlzI0uTVhjT62ugU8nuxPIc9egTFqVUmPw+jLB+Ol/iVdzTj7t
         O0xOO8gKdRC7XD2SIEi+cc40928J8OBuKC+rA5VwCcaKr4BMtiIxkC3vZqhlQqkaYLja
         BJKO8sIVrkeM113SgmxkcYvEQcm713OEi66oObS7bEfoftBlNZ6kZRyRTQZ4kv0sJe4n
         ocZ92gRwr64o/ZyCcLLV6NiQ9+2r0zcQ1oFqKDzRuLUrdZt5LWDyRT/9drpUXo5E6bG4
         OSpw==
X-Gm-Message-State: ACgBeo2lLlcXColwFpvfzZFy0oEAOIidvAa5/YDO3qy7QR4Di9TzpGit
        nzWAR0V/kkuELaxdOzmpT6au
X-Google-Smtp-Source: AA6agR6Trm+m8bjvG4fQ14EYIOo8A5RaBj693BOZCa3YPkrDe2BHnFjHxb/65s6KEWTuVm8/Nnqj0A==
X-Received: by 2002:a37:a9d8:0:b0:6ba:be20:48e2 with SMTP id s207-20020a37a9d8000000b006babe2048e2mr13655458qke.301.1661203274726;
        Mon, 22 Aug 2022 14:21:14 -0700 (PDT)
Received: from localhost (pool-96-237-52-46.bstnma.fios.verizon.net. [96.237.52.46])
        by smtp.gmail.com with ESMTPSA id dt2-20020a05620a478200b006bb024c5021sm11980198qkb.25.2022.08.22.14.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 14:21:14 -0700 (PDT)
Subject: [PATCH 2/3] selinux: implement the security_uring_cmd() LSM hook
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Date:   Mon, 22 Aug 2022 17:21:13 -0400
Message-ID: <166120327379.369593.4939320600435400704.stgit@olly>
In-Reply-To: <166120321387.369593.7400426327771894334.stgit@olly>
References: <166120321387.369593.7400426327771894334.stgit@olly>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a SELinux access control for the iouring IORING_OP_URING_CMD
command.  This includes the addition of a new permission in the
existing "io_uring" object class: "cmd".  The subject of the new
permission check is the domain of the process requesting access, the
object is the open file which points to the device/file that is the
target of the IORING_OP_URING_CMD operation.  A sample policy rule
is shown below:

  allow <domain> <file>:io_uring { cmd };

Cc: stable@vger.kernel.org
Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 security/selinux/hooks.c            |   24 ++++++++++++++++++++++++
 security/selinux/include/classmap.h |    2 +-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 79573504783b..03bca97c8b29 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -91,6 +91,7 @@
 #include <uapi/linux/mount.h>
 #include <linux/fsnotify.h>
 #include <linux/fanotify.h>
+#include <linux/io_uring.h>
 
 #include "avc.h"
 #include "objsec.h"
@@ -6987,6 +6988,28 @@ static int selinux_uring_sqpoll(void)
 	return avc_has_perm(&selinux_state, sid, sid,
 			    SECCLASS_IO_URING, IO_URING__SQPOLL, NULL);
 }
+
+/**
+ * selinux_uring_cmd - check if IORING_OP_URING_CMD is allowed
+ * @ioucmd: the io_uring command structure
+ *
+ * Check to see if the current domain is allowed to execute an
+ * IORING_OP_URING_CMD against the device/file specified in @ioucmd.
+ *
+ */
+static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
+{
+	struct file *file = ioucmd->file;
+	struct inode *inode = file_inode(file);
+	struct inode_security_struct *isec = selinux_inode(inode);
+	struct common_audit_data ad;
+
+	ad.type = LSM_AUDIT_DATA_FILE;
+	ad.u.file = file;
+
+	return avc_has_perm(&selinux_state, current_sid(), isec->sid,
+			    SECCLASS_IO_URING, IO_URING__CMD, &ad);
+}
 #endif /* CONFIG_IO_URING */
 
 /*
@@ -7231,6 +7254,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 #ifdef CONFIG_IO_URING
 	LSM_HOOK_INIT(uring_override_creds, selinux_uring_override_creds),
 	LSM_HOOK_INIT(uring_sqpoll, selinux_uring_sqpoll),
+	LSM_HOOK_INIT(uring_cmd, selinux_uring_cmd),
 #endif
 
 	/*
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index ff757ae5f253..1c2f41ff4e55 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -253,7 +253,7 @@ const struct security_class_mapping secclass_map[] = {
 	{ "anon_inode",
 	  { COMMON_FILE_PERMS, NULL } },
 	{ "io_uring",
-	  { "override_creds", "sqpoll", NULL } },
+	  { "override_creds", "sqpoll", "cmd", NULL } },
 	{ NULL }
   };
 


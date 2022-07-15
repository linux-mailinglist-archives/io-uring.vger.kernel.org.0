Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C911C576738
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 21:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiGOTQ0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 15:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiGOTQ0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 15:16:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED3E60506;
        Fri, 15 Jul 2022 12:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Rbp/Y/4RSQ9upVQB8iDU2lcc+SWPHydaNMyD3YYmTG0=; b=TJDE9B75RAFcZZzxUGe1l91zLj
        80hPjTamS7F1cjXGdH3J7NxPn0X9Fv6d5aYLPAH7ljvrCfyd+ntq0DVvolwFKXMwR+JP0OhKQ9P9A
        pL4sw3Qm7ApcBVpG7m51vbale7VtI9M8/f4QopaGb1ZdkvoayZnpIq8drHl98nBsdNMDHcmXD7r3L
        TG7G5onRP0MSAERoyeQXEBYu9SotBq4kfz6nov5+l14NXWIPU9Y+gCzMyJAHP6juggrgMKouRjJaC
        YncxVMkaAq1KgiZhHJUsc7wzeJp6iTFxvNEp6bmvxbIJfEQwD8vJWrAa89fXbBE8ZbDmpNTbPCrCC
        TSERf60A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oCQnX-009h3z-9d; Fri, 15 Jul 2022 19:16:23 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, casey@schaufler-ca.com, paul@paul-moore.com,
        joshi.k@samsung.com, linux-security-module@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com, mcgrof@kernel.org
Subject: [PATCH v2] lsm,io_uring: add LSM hooks for the new uring_cmd file op
Date:   Fri, 15 Jul 2022 12:16:22 -0700
Message-Id: <20220715191622.2310436-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
add infrastructure for uring-cmd"), this extended the struct
file_operations to allow a new command which each subsystem can use
to enable command passthrough. Add an LSM specific for the command
passthrough which enables LSMs to inspect the command details.

This was discussed long ago without no clear pointer for something
conclusive, so this enables LSMs to at least reject this new file
operation.

[0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com

Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
Changes on v2:

 - Added Fixes tag as requested by Paul Moore

 - Moved the security_uring_cmd() check after checking
   for req->file->f_op->uring_cmd as suggested by Paul Moore

 include/linux/lsm_hook_defs.h | 1 +
 include/linux/lsm_hooks.h     | 3 +++
 include/linux/security.h      | 5 +++++
 io_uring/uring_cmd.c          | 5 +++++
 security/security.c           | 4 ++++
 5 files changed, 18 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index eafa1d2489fd..4e94755098f1 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -406,4 +406,5 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
 #ifdef CONFIG_IO_URING
 LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
 LSM_HOOK(int, 0, uring_sqpoll, void)
+LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
 #endif /* CONFIG_IO_URING */
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 91c8146649f5..b681cfce6190 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1575,6 +1575,9 @@
  *      Check whether the current task is allowed to spawn a io_uring polling
  *      thread (IORING_SETUP_SQPOLL).
  *
+ * @uring_cmd:
+ *      Check whether the file_operations uring_cmd is allowed to run.
+ *
  */
 union security_list_options {
 	#define LSM_HOOK(RET, DEFAULT, NAME, ...) RET (*NAME)(__VA_ARGS__);
diff --git a/include/linux/security.h b/include/linux/security.h
index 4d0baf30266e..421856919b1e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2053,6 +2053,7 @@ static inline int security_perf_event_write(struct perf_event *event)
 #ifdef CONFIG_SECURITY
 extern int security_uring_override_creds(const struct cred *new);
 extern int security_uring_sqpoll(void);
+extern int security_uring_cmd(struct io_uring_cmd *ioucmd);
 #else
 static inline int security_uring_override_creds(const struct cred *new)
 {
@@ -2062,6 +2063,10 @@ static inline int security_uring_sqpoll(void)
 {
 	return 0;
 }
+static inline int security_uring_cmd(struct io_uring_cmd *ioucmd)
+{
+	return 0;
+}
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_IO_URING */
 
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 0a421ed51e7e..bf76f487d525 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -3,6 +3,7 @@
 #include <linux/errno.h>
 #include <linux/file.h>
 #include <linux/io_uring.h>
+#include <linux/security.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -85,6 +86,10 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	if (!req->file->f_op->uring_cmd)
 		return -EOPNOTSUPP;
 
+	ret = security_uring_cmd(ioucmd);
+	if (ret)
+		return ret;
+
 	if (ctx->flags & IORING_SETUP_SQE128)
 		issue_flags |= IO_URING_F_SQE128;
 	if (ctx->flags & IORING_SETUP_CQE32)
diff --git a/security/security.c b/security/security.c
index f85afb02ea1c..ad7d7229bd72 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2655,4 +2655,8 @@ int security_uring_sqpoll(void)
 {
 	return call_int_hook(uring_sqpoll, 0);
 }
+int security_uring_cmd(struct io_uring_cmd *ioucmd)
+{
+	return call_int_hook(uring_cmd, 0, ioucmd);
+}
 #endif /* CONFIG_IO_URING */
-- 
2.35.1


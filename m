Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6C740CB33
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 18:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhIOQvc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 12:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhIOQv3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 12:51:29 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E3AC061764
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:50:10 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id z12so2274147qvx.5
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=znV6h22uLT4tju8GfDCyoAJth/iE5nhq2gX552Nh+J8=;
        b=yR4M9FMq5YkZZZnLVBGoHE8n/L7LBcuRYu45AIK6rpu6q86Bt8q97V42UpmZakk9Hk
         qy1Abyuha691Im0rYc9EK/tOxPEZ+1p++dVyuU49SBOnF3DsCPgp/ECkkaOcSk9hOYg9
         uZwNWDENAneb/b3kwwfPpFtKTclqgTySmd7avIWwSBqFJauyZ+YBc6bH4I/Gmz4clP5w
         UOG2/ZoGWt1ti8+ruNUFKiGZJPPEEa2XjAF0DA2xVI/cJ3BaH4r06uP8JDKIZQ63Cap9
         ayT/rIEu7My8B35KdwQFfy0AsExXY/vMA5Y0BemiwrEF4O/6W75CvXEWvQeBY3Bhk5kO
         rFyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=znV6h22uLT4tju8GfDCyoAJth/iE5nhq2gX552Nh+J8=;
        b=6XpK7E0bx7HNp+/C92C+azKO/kDn6MyPKdCZ+bkKCJh2P/mLKSmlIkD3Uaf3uiDeLG
         XuGtWFF3Zp5hs/0ea6vXHvSSksxRpfIm+i/Mbo17dePAKuRaUom3NFoCenHK1t8TArlT
         iIE2Kua2nigB4oUwhTDsiJLGYsVTRo1Crigd2qbg7AJdWGHEZdVa4pQpEuZlCK8t9fXZ
         RARPIRkEaXFWkFp3SEofKJVCUGeS9DDKF1QY4ADkpuCWjSbFgsDlPi43Q8MLQ/bRyTaY
         UWz/wQyU2aSc4Vgoh9d3NsS3O5S7xHz/iuyrqO8CuUkWcMUOM8PIIZ3OXr+MD2I1lwJN
         JrGw==
X-Gm-Message-State: AOAM533yT+4RNIqixd1gD1XO380RFDrIfjKAk6gOlc1iF442LCO+AeHt
        M796NpiovzvCF5AANqpoH6v3
X-Google-Smtp-Source: ABdhPJx75T0dQPzt4WSic6uHD74Uop3/gZqSo+/ev3KVEiS5rzNOA3M5qoWYDRrYR2z4q+uilRE4LA==
X-Received: by 2002:a05:6214:1394:: with SMTP id g20mr812980qvz.21.1631724609746;
        Wed, 15 Sep 2021 09:50:09 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id w20sm377308qkj.116.2021.09.15.09.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 09:50:09 -0700 (PDT)
Subject: [PATCH v4 8/8] Smack: Brutalist io_uring support
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 15 Sep 2021 12:50:08 -0400
Message-ID: <163172460848.88001.15344229885190060624.stgit@olly>
In-Reply-To: <163172413301.88001.16054830862146685573.stgit@olly>
References: <163172413301.88001.16054830862146685573.stgit@olly>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

Add Smack privilege checks for io_uring. Use CAP_MAC_OVERRIDE
for the override_creds case and CAP_MAC_ADMIN for creating a
polling thread. These choices are based on conjecture regarding
the intent of the surrounding code.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
[PM: make the smack_uring_* funcs static, remove debug code]
Signed-off-by: Paul Moore <paul@paul-moore.com>

---
v4:
- updated subject line
v3:
- removed debug code
v2:
- made the smack_uring_* funcs static
v1:
- initial draft
---
 security/smack/smack_lsm.c |   46 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index cacbe7518519..f90ab1efeb6d 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4691,6 +4691,48 @@ static int smack_dentry_create_files_as(struct dentry *dentry, int mode,
 	return 0;
 }
 
+#ifdef CONFIG_IO_URING
+/**
+ * smack_uring_override_creds - Is io_uring cred override allowed?
+ * @new: the target creds
+ *
+ * Check to see if the current task is allowed to override it's credentials
+ * to service an io_uring operation.
+ */
+static int smack_uring_override_creds(const struct cred *new)
+{
+	struct task_smack *tsp = smack_cred(current_cred());
+	struct task_smack *nsp = smack_cred(new);
+
+	/*
+	 * Allow the degenerate case where the new Smack value is
+	 * the same as the current Smack value.
+	 */
+	if (tsp->smk_task == nsp->smk_task)
+		return 0;
+
+	if (smack_privileged_cred(CAP_MAC_OVERRIDE, current_cred()))
+		return 0;
+
+	return -EPERM;
+}
+
+/**
+ * smack_uring_sqpoll - check if a io_uring polling thread can be created
+ *
+ * Check to see if the current task is allowed to create a new io_uring
+ * kernel polling thread.
+ */
+static int smack_uring_sqpoll(void)
+{
+	if (smack_privileged_cred(CAP_MAC_ADMIN, current_cred()))
+		return 0;
+
+	return -EPERM;
+}
+
+#endif /* CONFIG_IO_URING */
+
 struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init = {
 	.lbs_cred = sizeof(struct task_smack),
 	.lbs_file = sizeof(struct smack_known *),
@@ -4843,6 +4885,10 @@ static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(inode_copy_up, smack_inode_copy_up),
 	LSM_HOOK_INIT(inode_copy_up_xattr, smack_inode_copy_up_xattr),
 	LSM_HOOK_INIT(dentry_create_files_as, smack_dentry_create_files_as),
+#ifdef CONFIG_IO_URING
+	LSM_HOOK_INIT(uring_override_creds, smack_uring_override_creds),
+	LSM_HOOK_INIT(uring_sqpoll, smack_uring_sqpoll),
+#endif
 };
 
 


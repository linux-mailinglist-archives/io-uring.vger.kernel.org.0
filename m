Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B91D40A4A1
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 05:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238952AbhINDfP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 23:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239066AbhINDe7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 23:34:59 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7FFC0613E2
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 20:33:43 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id bk29so13212672qkb.8
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 20:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=54Sbzge3G+aat3VcychMMrLelhIpqQAZp6yuJG+ykt8=;
        b=aZ6thOvMHLr+wxTevjEA1i5Ht/W/KrKBQJDrsm43lV+2/eSbhr0/w/m5LaTbRZv97v
         13VV/f6a5EZn+YwNo+evAqqV68Rk0Q3ZSZ7p66Z50xOHLmTvSRidUUAQqWKoRmufA//s
         TRdH5DrwLc8h6Fex7ElS7A8hxXq9SCFZnCMT2WXwEZFLdqa6eaRHhZuYOqmQZA+UPyb8
         U6kNemODgsXPNN7mcEVByROU8emfLbr8Vnk/Yuyf9KR1xQgvIKEYcEbjkCJLJqdNEz8k
         K9dZzuNqP701EebgEt1oQ05r+hhjxT6DR0Y1fY8t9nmU0Lbxbb7cA5vBOG5ann40QGgU
         C7rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=54Sbzge3G+aat3VcychMMrLelhIpqQAZp6yuJG+ykt8=;
        b=STlhxOiOGXfHBkfv7e0g1quGIquvVjDwieyMBGrDgzZuCetoRtgt9man6dGFK84PJw
         aw6TnMDJEsO8rRU7ovW48xyKS681Kv8/MkMgmFZRnsyUmMhpZwX2ulIH/G+85HYnz6n+
         xeZuZPn6OfzDjPtD3Ue87jQbzszxZiQP0WlJ4M//CW5GbvvvG7z1IO4MIto8vtU56Gfs
         fyN+xlo9BAsEpUAIbbm/1r8NU/xr0dhFswjnrZOVH8VnQUo8k11pYSJrOdG/5P660JCn
         6nAMl8cvRSAeQN/VD2jNGGuaOCb+pEe3+fAvItin2iKnLHxu5DmuUv34LOEXfTL9+L2a
         Zhwg==
X-Gm-Message-State: AOAM532I0sh+vhIZmyRI5zSUxj4fIdwUlWpE7VhFDaoHUWBfKTZAdW/C
        F4y8z8IXW9UUd0OI33rEW+9Y
X-Google-Smtp-Source: ABdhPJxCTwAyD5dWI5ou1pL9SVHqbRt3WXQyP3KXoalYRryIJkcZ1TtZ+jPi+4HNVU0jJ4AhyxpGgA==
X-Received: by 2002:a37:6691:: with SMTP id a139mr2900014qkc.310.1631590422163;
        Mon, 13 Sep 2021 20:33:42 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id b1sm5212672qtj.76.2021.09.13.20.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 20:33:41 -0700 (PDT)
Subject: [PATCH v3 8/8] Smack: Brutalist io_uring support with debug
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Mon, 13 Sep 2021 23:33:41 -0400
Message-ID: <163159042110.470089.9405201508228711833.stgit@olly>
In-Reply-To: <163159032713.470089.11728103630366176255.stgit@olly>
References: <163159032713.470089.11728103630366176255.stgit@olly>
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
 
 


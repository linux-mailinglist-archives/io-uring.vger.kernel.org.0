Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63044388CF4
	for <lists+io-uring@lfdr.de>; Wed, 19 May 2021 13:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351282AbhESLiy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 May 2021 07:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351097AbhESLiv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 May 2021 07:38:51 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C5EC061761;
        Wed, 19 May 2021 04:37:30 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id i6so2025679plt.4;
        Wed, 19 May 2021 04:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m+3FZkYhV+WJmv860bclG5Usw9ZdqRUiUz86oyBiOjA=;
        b=PKbpRg6eszJcyH1upYLpGENRAQ51TgQ7D3Lnd2U9bAs5ehy8ldAcAzmFuemEzjBhvG
         FQgXuMV3fhkKDAc0NIZUbFDD2i9f1FdrxcrJ6Luo2DfAOtQkmpX9sFaMsc9ZyWBf1xrq
         A4A/FsNJiOiCPta3+atAA5J6NPtop0Wk5j2HGawm9xRqAdQkPrA8vV1I9hP+XTx5TmrX
         WeBr3RHKSN9Q1sLW3WwzShhvHfSEKaclUnnwFQ4UgDmE786JDvJV6q7Xswsbjfh1bw4G
         p/gGHCprzQIs4CLBgfAN3ckKfh+GylsKvTwA2dFNoUNdgCwXWT6jE5QwZuAk6sVm30AV
         HXMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m+3FZkYhV+WJmv860bclG5Usw9ZdqRUiUz86oyBiOjA=;
        b=nMJPOfimA10PeKdHPAt/jfHevuyKZeG/6LWzF7vOyJJbnoJN4+D0mdULV67ypkxBe0
         fHk9rslOZLk6Ye8M+gaeimu2UxUCCY/EQCOL9Hae+MxM5/+5wAJbToDCfiKgSSyQ0HbY
         1Xiw0uLJgkR++vJBfwMbs0MQOXGYVLC/bqQuzFyDQsCrJkJ23egobVCSlviN/SrkNdIP
         PQkBnHDRuYscagulcnHFFg0ZhI4DOxaJi2kZgX//oFFz9yNAusUdQ4nXT0uUKQRHwLyM
         vk3RjYQQUM/owPRJ7TqwELbMLlQECyOKDC6vF/M3ekoRHaeD4alDpAJkLB6I7bE0atJy
         JSEw==
X-Gm-Message-State: AOAM531t/nuHySMmCnuN4ngkxKXWoz0OnyhPzhf/FogVqGDGOJowwTgF
        BLIzcYq9O1lQz50F+ReYITk3EAJgJn0=
X-Google-Smtp-Source: ABdhPJwMqvO/7lxeGZHyG8CO5bVHKBZ24N9fEzTQZpI7godLtmkD3vdLicz9BmdL1OhX0EHEINjTQw==
X-Received: by 2002:a17:902:f291:b029:f0:ba5b:5c47 with SMTP id k17-20020a170902f291b02900f0ba5b5c47mr10586583plc.41.1621424250139;
        Wed, 19 May 2021 04:37:30 -0700 (PDT)
Received: from localhost ([2402:3a80:11c3:3084:b057:1ac1:910f:3c09])
        by smtp.gmail.com with ESMTPSA id ck21sm15131406pjb.24.2021.05.19.04.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 04:37:29 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Pavel Emelyanov <xemul@openvz.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Daniel Colascione <dancol@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH  1/2] fs: anon_inodes: export anon_inode_getfile_secure helper
Date:   Wed, 19 May 2021 17:00:56 +0530
Message-Id: <20210519113058.1979817-2-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519113058.1979817-1-memxor@gmail.com>
References: <20210519113058.1979817-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is the non-fd installing analogue of anon_inode_getfd_secure. In
addition to allowing LSMs to attach policy to the distinct inode, this
is also needed for checkpoint restore of an io_uring instance where a
mapped region needs to mapped back to the io_uring fd by CRIU. This is
currently not possible as all anon_inodes share a single inode.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 fs/anon_inodes.c            | 9 +++++++++
 include/linux/anon_inodes.h | 4 ++++
 2 files changed, 13 insertions(+)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index a280156138ed..37032786b211 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -148,6 +148,15 @@ struct file *anon_inode_getfile(const char *name,
 }
 EXPORT_SYMBOL_GPL(anon_inode_getfile);
 
+struct file *anon_inode_getfile_secure(const char *name,
+				       const struct file_operations *fops,
+				       void *priv, int flags,
+				       const struct inode *context_inode)
+{
+	return __anon_inode_getfile(name, fops, priv, flags, context_inode, true);
+}
+EXPORT_SYMBOL_GPL(anon_inode_getfile_secure);
+
 static int __anon_inode_getfd(const char *name,
 			      const struct file_operations *fops,
 			      void *priv, int flags,
diff --git a/include/linux/anon_inodes.h b/include/linux/anon_inodes.h
index 71881a2b6f78..5deaddbd7927 100644
--- a/include/linux/anon_inodes.h
+++ b/include/linux/anon_inodes.h
@@ -15,6 +15,10 @@ struct inode;
 struct file *anon_inode_getfile(const char *name,
 				const struct file_operations *fops,
 				void *priv, int flags);
+struct file *anon_inode_getfile_secure(const char *name,
+				       const struct file_operations *fops,
+				       void *priv, int flags,
+				       const struct inode *context_inode);
 int anon_inode_getfd(const char *name, const struct file_operations *fops,
 		     void *priv, int flags);
 int anon_inode_getfd_secure(const char *name,
-- 
2.31.1


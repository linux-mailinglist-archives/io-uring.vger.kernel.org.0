Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A30D38D030
	for <lists+io-uring@lfdr.de>; Fri, 21 May 2021 23:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhEUVvn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 May 2021 17:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhEUVvj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 May 2021 17:51:39 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D184BC0613ED
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 14:50:14 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id v8so21348957qkv.1
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 14:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=28mYvehEs3z/GlPu07ZO2sTO/B+ImH7rTZVJRJkmPL8=;
        b=Nwfv7Q2at28cE+jagIqyX6lb2QffXOuIGBUgUidmj7Gz40wtourKAYeXYgPYR6Xw1n
         uMlU4WffCbgxYYjPuSlFLu67tw5bzcTwjROX6p/zZH/CZvQEY/1+d43IOYExYZYYAKHJ
         CSD6w3qd7xZt/1/yDM7knZriGR5PVGurboSxksToizm9/AqQW8FYKBAs99EB06SgpM97
         i9DWti8EqWUYNLq9BxP4uXaHh4P8Q7WdpLP+8OYQfjBcHBcU6Z7e+mjZioiyiNQKfFBu
         aDffx8f7+xDByl4NCU10Q+7idvAHnJpb+4flJG2UacyK6YTKaE8I++ppG16HGdJLdyuP
         bdoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=28mYvehEs3z/GlPu07ZO2sTO/B+ImH7rTZVJRJkmPL8=;
        b=f8Ri1Ob80OrNhl5AUed5dyJvgyC/Mye5sDt1exVw+o4Yz06jLjuE6f3JVDt8IRhPxn
         Lb+LFM5ME4lI/P/Zw3ADd4xeEGLWXmYuk7oTkgInB6X+npll/Jfh1VS/iKb8dO6X9ugQ
         lMpjh3UKEoX7Fsy5O/jfaw/ZZYULgC8VZkytX5AvFZHJi+9lan1arIdHjGXmIKnUc9iI
         NLbeDqWmR8kf8gZHeR7/EolJphUN6ZAO/hR9DidNKGGN0fJZpvHw3LjNiVVElgrc6o2h
         pdXIsImcMj4RrRcxvdpc5qZ9GhW5gXsr7dxyVvj40+qFD2KuSVBH5W5TboU3Dl1PROZI
         FY+A==
X-Gm-Message-State: AOAM533+P10tA8fsK2kWsImYJAprfx2RL4vCKGLOEe3pukW6m0gapvxf
        DorFhDV5Xah8WYvQ/7v4Y4QNafBjLOfb
X-Google-Smtp-Source: ABdhPJw1qyLOwhzI8W3DdhQMHzc0FJSlmc5dyhRENQ524cEnIhZRftnlrl97sOqARFzzskecC3kRRQ==
X-Received: by 2002:ae9:ef55:: with SMTP id d82mr15041516qkg.3.1621633813979;
        Fri, 21 May 2021 14:50:13 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id l10sm5680954qtn.28.2021.05.21.14.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 14:50:13 -0700 (PDT)
Subject: [RFC PATCH 5/9] fs: add anon_inode_getfile_secure() similar to
 anon_inode_getfd_secure()
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Date:   Fri, 21 May 2021 17:50:13 -0400
Message-ID: <162163381300.8379.4882128125504754351.stgit@sifl>
In-Reply-To: <162163367115.8379.8459012634106035341.stgit@sifl>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Extending the secure anonymous inode support to other subsystems
requires that we have a secure anon_inode_getfile() variant in
addition to the existing secure anon_inode_getfd() variant.

Thankfully we can reuse the existing __anon_inode_getfile() function
and just wrap it with the proper arguments.

Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 fs/anon_inodes.c            |   29 +++++++++++++++++++++++++++++
 include/linux/anon_inodes.h |    4 ++++
 2 files changed, 33 insertions(+)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index a280156138ed..e0c3e33c4177 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -148,6 +148,35 @@ struct file *anon_inode_getfile(const char *name,
 }
 EXPORT_SYMBOL_GPL(anon_inode_getfile);
 
+/**
+ * anon_inode_getfile_secure - Like anon_inode_getfile(), but creates a new
+ *                             !S_PRIVATE anon inode rather than reuse the
+ *                             singleton anon inode and calls the
+ *                             inode_init_security_anon() LSM hook.  This
+ *                             allows for both the inode to have its own
+ *                             security context and for the LSM to enforce
+ *                             policy on the inode's creation.
+ *
+ * @name:    [in]    name of the "class" of the new file
+ * @fops:    [in]    file operations for the new file
+ * @priv:    [in]    private data for the new file (will be file's private_data)
+ * @flags:   [in]    flags
+ * @context_inode:
+ *           [in]    the logical relationship with the new inode (optional)
+ *
+ * The LSM may use @context_inode in inode_init_security_anon(), but a
+ * reference to it is not held.  Returns the newly created file* or an error
+ * pointer.  See the anon_inode_getfile() documentation for more information.
+ */
+struct file *anon_inode_getfile_secure(const char *name,
+				       const struct file_operations *fops,
+				       void *priv, int flags,
+				       const struct inode *context_inode)
+{
+	return __anon_inode_getfile(name, fops, priv, flags,
+				    context_inode, true);
+}
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


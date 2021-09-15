Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC93B40CB19
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 18:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhIOQvH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 12:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhIOQvE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 12:51:04 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA953C061575
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:49:45 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id a12so2276278qvz.4
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=Y1TkJrYx+ov8z66ALV7f2Sg5s1JjZX16Pw/yL09jGtA=;
        b=MOUBXl8jVr3QXSJbfF+JqSmSkyrC2sjFL9Mgn1PEPX2Ucq9xMq7Ym6t9beKr3oLpUC
         t8gjfU+RE6wjzifXOKbYF/LaSZCRbnIiYcQC0FAOmqnMJRQhBO9+OapXZnpgDmOy/80n
         jQ+0wm+8FccsibXplvv+t5+ew0QksmeyH2Co7yzsUtnM6PPwOdb0+HLGW2Xu9uMWmdCM
         jZsG9Rdul9sLY1XUby2wOGkDCIRpcP2KW1dE7Tyh1XXcoRT1V8ukuinqYkSDbVoS786m
         lgFvCGlVL/HN/tQcxv5Pm6Nwf6B0mpgkuUble2HHmKTK2bjB1UuyZQ+KpbCFaCrnl2r+
         QdIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Y1TkJrYx+ov8z66ALV7f2Sg5s1JjZX16Pw/yL09jGtA=;
        b=iNXI2w3EtifYXdH2qA5WK0YJpOBm3rftiXTpEJzWSDZE8f/Y9G7QFmxPkry3+x6aWN
         EdylaVvZvC6/NWV8qkbMhZL7B2PLFUtFBCXHQnbUxzISd2GrmoC7B2O/Ib8EVSvQR+BL
         j1XJ+3Q29f/lrjKsXvHFJhkavFHllGY7/CMfUxgi0KzhiLJmNmKiLqzTd/Hem7P5h3EQ
         yH7CAyOIB/GAK7m1041hC60st10aAM70boM/Uh0hoIJm7XczLXajMC5s+Q77uau+1AX6
         sIUveIJPHBNlqZRuBGwnXwMGGdipy6tz8Ky/JlH7q3hQNu6fp0VjixDqiKVlPiku1AhX
         R57w==
X-Gm-Message-State: AOAM531zzi3HlFdYCxLFmgw57rJAZ6OvSBva57zttdK+UKMqj0qTdzIZ
        mgQYfHMxAvUjgsjo4zogzc7O
X-Google-Smtp-Source: ABdhPJzkEEdLdy0cmCrWtOnT2Cl0+J/Y8K0llmm4G08TjUGg5mP2ZlZheVR6JwnNE/XlH+vcZDoLOg==
X-Received: by 2002:ad4:54ce:: with SMTP id j14mr653905qvx.32.1631724584929;
        Wed, 15 Sep 2021 09:49:44 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id g12sm268749qtq.92.2021.09.15.09.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 09:49:44 -0700 (PDT)
Subject: [PATCH v4 4/8] fs: add anon_inode_getfile_secure() similar to
 anon_inode_getfd_secure()
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 15 Sep 2021 12:49:43 -0400
Message-ID: <163172458385.88001.9452390680679491195.stgit@olly>
In-Reply-To: <163172413301.88001.16054830862146685573.stgit@olly>
References: <163172413301.88001.16054830862146685573.stgit@olly>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Extending the secure anonymous inode support to other subsystems
requires that we have a secure anon_inode_getfile() variant in
addition to the existing secure anon_inode_getfd() variant.

Thankfully we can reuse the existing __anon_inode_getfile() function
and just wrap it with the proper arguments.

Acked-by: Mickaël Salaün <mic@linux.microsoft.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>

---
v4:
- no change
v3:
- no change
v2:
- no change
v1:
- initial draft
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


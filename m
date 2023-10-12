Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6C37C78D8
	for <lists+io-uring@lfdr.de>; Thu, 12 Oct 2023 23:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347413AbjJLVzV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Oct 2023 17:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344165AbjJLVzV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Oct 2023 17:55:21 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DAF75B8;
        Thu, 12 Oct 2023 14:55:18 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1180)
        id 3E83F20B74C0; Thu, 12 Oct 2023 14:55:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3E83F20B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1697147718;
        bh=X9TXOYTeReXKeqvHtc+Vad8+a4hTXFQ9YgHArM9yVNE=;
        h=Date:From:To:Cc:Subject:From;
        b=pTSbVjMJnZvDc7zYeEGTsgQiuu3ZE3xRwZ7ix9shTVTzVA6YcRSVk+XLq+ng3ZPtf
         KaFKy/BmUb43ww/sqcgkY5F4Zi7aRP/1mYNauIL02UtdgD3lX6c//qGEvPDvzEisv3
         BE3KlS3nq/U6JDEx8aRQQjXWNiyN8prhXskalI50=
Date:   Thu, 12 Oct 2023 14:55:18 -0700
From:   Dan Clash <daclash@linux.microsoft.com>
To:     audit@vger.kernel.org, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, paul@paul-moore.com, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, brauner@kernel.org,
        dan.clash@microsoft.com
Subject: [PATCH] audit,io_uring: io_uring openat triggers audit reference
 count underflow
Message-ID: <20231012215518.GA4048@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,SPF_HELO_PASS,SPF_PASS,
        T_FILL_THIS_FORM_SHORT,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

An io_uring openat operation can update an audit reference count
from multiple threads resulting in the call trace below.

A call to io_uring_submit() with a single openat op with a flag of
IOSQE_ASYNC results in the following reference count updates.

These first part of the system call performs two increments that do not race.

do_syscall_64()
  __do_sys_io_uring_enter()
    io_submit_sqes()
      io_openat_prep()
        __io_openat_prep()
          getname()
            getname_flags()       /* update 1 (increment) */
              __audit_getname()   /* update 2 (increment) */

The openat op is queued to an io_uring worker thread which starts the
opportunity for a race.  The system call exit performs one decrement.

do_syscall_64()
  syscall_exit_to_user_mode()
    syscall_exit_to_user_mode_prepare()
      __audit_syscall_exit()
        audit_reset_context()
           putname()              /* update 3 (decrement) */

The io_uring worker thread performs one increment and two decrements.
These updates can race with the system call decrement.

io_wqe_worker()
  io_worker_handle_work()
    io_wq_submit_work()
      io_issue_sqe()
        io_openat()
          io_openat2()
            do_filp_open()
              path_openat()
                __audit_inode()   /* update 4 (increment) */
            putname()             /* update 5 (decrement) */
        __audit_uring_exit()
          audit_reset_context()
            putname()             /* update 6 (decrement) */

The fix is to change the refcnt member of struct audit_names
from int to atomic_t.

kernel BUG at fs/namei.c:262!
Call Trace:
...
 ? putname+0x68/0x70
 audit_reset_context.part.0.constprop.0+0xe1/0x300
 __audit_uring_exit+0xda/0x1c0
 io_issue_sqe+0x1f3/0x450
 ? lock_timer_base+0x3b/0xd0
 io_wq_submit_work+0x8d/0x2b0
 ? __try_to_del_timer_sync+0x67/0xa0
 io_worker_handle_work+0x17c/0x2b0
 io_wqe_worker+0x10a/0x350

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/lkml/MW2PR2101MB1033FFF044A258F84AEAA584F1C9A@MW2PR2101MB1033.namprd21.prod.outlook.com/
Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
Signed-off-by: Dan Clash <daclash@linux.microsoft.com>
---
 fs/namei.c         | 9 +++++----
 include/linux/fs.h | 2 +-
 kernel/auditsc.c   | 8 ++++----
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 567ee547492b..94565bd7e73f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -188,7 +188,7 @@ getname_flags(const char __user *filename, int flags, int *empty)
 		}
 	}
 
-	result->refcnt = 1;
+	atomic_set(&result->refcnt, 1);
 	/* The empty path is special. */
 	if (unlikely(!len)) {
 		if (empty)
@@ -249,7 +249,7 @@ getname_kernel(const char * filename)
 	memcpy((char *)result->name, filename, len);
 	result->uptr = NULL;
 	result->aname = NULL;
-	result->refcnt = 1;
+	atomic_set(&result->refcnt, 1);
 	audit_getname(result);
 
 	return result;
@@ -261,9 +261,10 @@ void putname(struct filename *name)
 	if (IS_ERR(name))
 		return;
 
-	BUG_ON(name->refcnt <= 0);
+	if (WARN_ON_ONCE(!atomic_read(&name->refcnt)))
+		return;
 
-	if (--name->refcnt > 0)
+	if (!atomic_dec_and_test(&name->refcnt))
 		return;
 
 	if (name->name != name->iname) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4aeb3fa11927..85653ce30d2c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2444,7 +2444,7 @@ struct audit_names;
 struct filename {
 	const char		*name;	/* pointer to actual string */
 	const __user char	*uptr;	/* original userland pointer */
-	int			refcnt;
+	atomic_t		refcnt;
 	struct audit_names	*aname;
 	const char		iname[];
 };
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 21d2fa815e78..6f0d6fb6523f 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2212,7 +2212,7 @@ __audit_reusename(const __user char *uptr)
 		if (!n->name)
 			continue;
 		if (n->name->uptr == uptr) {
-			n->name->refcnt++;
+			atomic_inc(&n->name->refcnt);
 			return n->name;
 		}
 	}
@@ -2241,7 +2241,7 @@ void __audit_getname(struct filename *name)
 	n->name = name;
 	n->name_len = AUDIT_NAME_FULL;
 	name->aname = n;
-	name->refcnt++;
+	atomic_inc(&name->refcnt);
 }
 
 static inline int audit_copy_fcaps(struct audit_names *name,
@@ -2373,7 +2373,7 @@ void __audit_inode(struct filename *name, const struct dentry *dentry,
 		return;
 	if (name) {
 		n->name = name;
-		name->refcnt++;
+		atomic_inc(&name->refcnt);
 	}
 
 out:
@@ -2500,7 +2500,7 @@ void __audit_inode_child(struct inode *parent,
 		if (found_parent) {
 			found_child->name = found_parent->name;
 			found_child->name_len = AUDIT_NAME_FULL;
-			found_child->name->refcnt++;
+			atomic_inc(&found_child->name->refcnt);
 		}
 	}
 

base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
-- 
2.34.1


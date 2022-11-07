Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB71961EFA8
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 10:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiKGJyE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 04:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbiKGJxz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 04:53:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7B51839C
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 01:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667814775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PRG3TK5PkvceDpSktl/XoLwICyvkxZzD1g+3ZIVVWaA=;
        b=Awu8DJwYOyhR5GyAdVV5W3UwplZDG53jPQbmhLngWLNuz79GN3IvLcFjBB+MP0dyOcII5Z
        4ISp3qCmju8mBrj52h7oiOHsLF7lLW6na3YC+FPbVrli4gUUXqko6z6BN/fCG/BTyGuRGg
        RSGavV8lg+0HL5TkO/y/2QvhnTYx5W4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-n8Lus9X6OkKLq4OgQeNMkw-1; Mon, 07 Nov 2022 04:52:53 -0500
X-MC-Unique: n8Lus9X6OkKLq4OgQeNMkw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1ADFD86F155;
        Mon,  7 Nov 2022 09:52:53 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1DF6140EBF5;
        Mon,  7 Nov 2022 09:52:47 +0000 (UTC)
From:   xiubli@redhat.com
To:     viro@zeniv.linux.org.uk, jlayton@kernel.org, chuck.lever@oracle.com
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, ceph-devel@vger.kernel.org,
        mchangir@redhat.com, idryomov@gmail.com, lhenriques@suse.de,
        gfarnum@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [RFC PATCH] fs/lock: increase the filp's reference for Posix-style locks
Date:   Mon,  7 Nov 2022 17:52:32 +0800
Message-Id: <20221107095232.36828-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When closing the file descripters in parallel in multiple threads,
who are sharing the same file descripters, the filp_close() will
remove all the Posix-style locks. But if two threads both calling
the filp_close() it may race and cause use-after-free crash:

 PID: 327771   TASK: ffff952aa1db3180  CPU: 8    COMMAND: "db2fmp"
  #0 [ffff95202f33b960] machine_kexec at ffffffff890662f4
  #1 [ffff95202f33b9c0] __crash_kexec at ffffffff89122b82
  #2 [ffff95202f33ba90] crash_kexec at ffffffff89122c70
  #3 [ffff95202f33baa8] oops_end at ffffffff89791798
  #4 [ffff95202f33bad0] no_context at ffffffff89075d14
  #5 [ffff95202f33bb20] __bad_area_nosemaphore at ffffffff89075fe2
  #6 [ffff95202f33bb70] bad_area_nosemaphore at ffffffff89076104
  #7 [ffff95202f33bb80] __do_page_fault at ffffffff89794750
  #8 [ffff95202f33bbf0] do_page_fault at ffffffff89794975
  #9 [ffff95202f33bc20] page_fault at ffffffff89790778
     [exception RIP: ceph_fl_release_lock+20]
     RIP: ffffffffc08247a4  RSP: ffff95202f33bcd0  RFLAGS: 00010286
     RAX: ffff952d4ebd8a00  RBX: 0000000000000000  RCX: dead000000000200
     RDX: ffff95202f33bd60  RSI: ffff95202f33bd60  RDI: ffff9526b6ac5b00
     RBP: ffff95202f33bce0   R8: ffff9526b6ac5b18   R9: ffffffffc083c368
     R10: 0000000000001109  R11: 0000000000000000  R12: ffff95202f33bd60
     R13: ffff9526b6ac5b00  R14: 0000000000000000  R15: 0000000000000000
     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #10 [ffff95202f33bce8] locks_release_private at ffffffff892ab3d7
 #11 [ffff95202f33bd00] locks_free_lock at ffffffff892ac34d
 #12 [ffff95202f33bd18] locks_dispose_list at ffffffff892ac44b
 #13 [ffff95202f33bd40] __posix_lock_file at ffffffff892acdfa
 #14 [ffff95202f33bda8] posix_lock_file at ffffffff892ad146
 #15 [ffff95202f33bdb8] ceph_lock at ffffffffc0824e8a [ceph]
 #16 [ffff95202f33bdf8] vfs_lock_file at ffffffff892ad185
 #17 [ffff95202f33be08] locks_remove_posix at ffffffff892ad239
 #18 [ffff95202f33bee0] locks_remove_posix at ffffffff892ad2a0
 #19 [ffff95202f33bef0] filp_close at ffffffff8924baa6
 #20 [ffff95202f33bf18] __close_fd at ffffffff8926f89c
 #21 [ffff95202f33bf40] sys_close at ffffffff8924d503
 #22 [ffff95202f33bf50] system_call_fastpath at ffffffff89799f92
     RIP: 00007f806ec446ab  RSP: 00007f80517f0d90  RFLAGS: 00010206
     RAX: 0000000000000003  RBX: 00007f8030001a20  RCX: 00007f80300386b0
     RDX: 00007f806ef0d880  RSI: 0000000000000001  RDI: 0000000000000006
     RBP: 00007f806ef0e3c0   R8: 00007f80517fa700   R9: 0000000000000000
     R10: 0000000000000000  R11: 0000000000000206  R12: 0000000000000000
     R13: 00007f80300035b0  R14: 00007f80517f1104  R15: 000000000000006c
     ORIG_RAX: 0000000000000003  CS: 0033  SS: 002b

We need to make sure that the filp in the file_lock shouldn't be
release when any file_lock is still referring to it.

For the Posix-style locks, whose owner will be the thread ids, we
will increase the filp's reference.

URL: https://tracker.ceph.com/issues/57986
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 drivers/android/binder.c |  2 +-
 fs/file.c                | 15 ++++++++++-----
 fs/locks.c               | 18 +++++++++++++++---
 include/linux/fs.h       | 14 ++++++++++++++
 io_uring/openclose.c     |  3 ++-
 5 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 880224ec6abb..03692564d940 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1924,7 +1924,7 @@ static void binder_deferred_fd_close(int fd)
 	if (twcb->file) {
 		// pin it until binder_do_fd_close(); see comments there
 		get_file(twcb->file);
-		filp_close(twcb->file, current->files);
+		filp_close(twcb->file, file_lock_make_thread_owner(current->files));
 		task_work_add(current, &twcb->twork, TWA_RESUME);
 	} else {
 		kfree(twcb);
diff --git a/fs/file.c b/fs/file.c
index 5f9c802a5d8d..39ad8e74a8d9 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -417,6 +417,7 @@ static struct fdtable *close_files(struct files_struct * files)
 	 * files structure.
 	 */
 	struct fdtable *fdt = rcu_dereference_raw(files->fdt);
+	fl_owner_t owner = file_lock_make_thread_owner(files);
 	unsigned int i, j = 0;
 
 	for (;;) {
@@ -429,7 +430,7 @@ static struct fdtable *close_files(struct files_struct * files)
 			if (set & 1) {
 				struct file * file = xchg(&fdt->fd[i], NULL);
 				if (file) {
-					filp_close(file, files);
+					filp_close(file, owner);
 					cond_resched();
 				}
 			}
@@ -653,6 +654,7 @@ static struct file *pick_file(struct files_struct *files, unsigned fd)
 int close_fd(unsigned fd)
 {
 	struct files_struct *files = current->files;
+	fl_owner_t owner = file_lock_make_thread_owner(files);
 	struct file *file;
 
 	spin_lock(&files->file_lock);
@@ -661,7 +663,7 @@ int close_fd(unsigned fd)
 	if (!file)
 		return -EBADF;
 
-	return filp_close(file, files);
+	return filp_close(file, owner);
 }
 EXPORT_SYMBOL(close_fd); /* for ksys_close() */
 
@@ -695,6 +697,7 @@ static inline void __range_cloexec(struct files_struct *cur_fds,
 static inline void __range_close(struct files_struct *cur_fds, unsigned int fd,
 				 unsigned int max_fd)
 {
+	fl_owner_t owner = file_lock_make_thread_owner(cur_fds);
 	unsigned n;
 
 	rcu_read_lock();
@@ -711,7 +714,7 @@ static inline void __range_close(struct files_struct *cur_fds, unsigned int fd,
 
 		if (file) {
 			/* found a valid file to close */
-			filp_close(file, cur_fds);
+			filp_close(file, owner);
 			cond_resched();
 		}
 	}
@@ -816,6 +819,7 @@ struct file *close_fd_get_file(unsigned int fd)
 
 void do_close_on_exec(struct files_struct *files)
 {
+	fl_owner_t owner = file_lock_make_thread_owner(files);
 	unsigned i;
 	struct fdtable *fdt;
 
@@ -841,7 +845,7 @@ void do_close_on_exec(struct files_struct *files)
 			rcu_assign_pointer(fdt->fd[fd], NULL);
 			__put_unused_fd(files, fd);
 			spin_unlock(&files->file_lock);
-			filp_close(file, files);
+			filp_close(file, owner);
 			cond_resched();
 			spin_lock(&files->file_lock);
 		}
@@ -1080,6 +1084,7 @@ static int do_dup2(struct files_struct *files,
 	struct file *file, unsigned fd, unsigned flags)
 __releases(&files->file_lock)
 {
+	fl_owner_t owner = file_lock_make_thread_owner(files);
 	struct file *tofree;
 	struct fdtable *fdt;
 
@@ -1111,7 +1116,7 @@ __releases(&files->file_lock)
 	spin_unlock(&files->file_lock);
 
 	if (tofree)
-		filp_close(tofree, files);
+		filp_close(tofree, owner);
 
 	return fd;
 
diff --git a/fs/locks.c b/fs/locks.c
index 607f94a0e789..e8b67f87e0ee 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -331,6 +331,8 @@ EXPORT_SYMBOL_GPL(locks_owner_has_blockers);
 /* Free a lock which is not in use. */
 void locks_free_lock(struct file_lock *fl)
 {
+	if (fl->fl_file && file_lock_is_thread_owner(fl->fl_owner))
+		fput(fl->fl_file);
 	locks_release_private(fl);
 	kmem_cache_free(filelock_cache, fl);
 }
@@ -384,7 +386,10 @@ void locks_copy_lock(struct file_lock *new, struct file_lock *fl)
 
 	locks_copy_conflock(new, fl);
 
-	new->fl_file = fl->fl_file;
+	if (file_lock_is_thread_owner(new->fl_owner))
+		new->fl_file = get_file(fl->fl_file);
+	else
+		new->fl_file = fl->fl_file;
 	new->fl_ops = fl->fl_ops;
 
 	if (fl->fl_ops) {
@@ -488,13 +493,14 @@ static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
 	} else
 		fl->fl_end = OFFSET_MAX;
 
-	fl->fl_owner = current->files;
+	fl->fl_owner = file_lock_make_thread_owner(current->files);
 	fl->fl_pid = current->tgid;
-	fl->fl_file = filp;
+	fl->fl_file = get_file(filp);
 	fl->fl_flags = FL_POSIX;
 	fl->fl_ops = NULL;
 	fl->fl_lmops = NULL;
 
+
 	return assign_type(fl, l->l_type);
 }
 
@@ -2243,6 +2249,7 @@ int fcntl_getlk(struct file *filp, unsigned int cmd, struct flock *flock)
 
 		fl->fl_flags |= FL_OFDLCK;
 		fl->fl_owner = filp;
+		fput(filp);
 	}
 
 	error = vfs_test_lock(filp, fl);
@@ -2376,6 +2383,7 @@ int fcntl_setlk(unsigned int fd, struct file *filp, unsigned int cmd,
 		cmd = F_SETLK;
 		file_lock->fl_flags |= FL_OFDLCK;
 		file_lock->fl_owner = filp;
+		fput(filp);
 		break;
 	case F_OFD_SETLKW:
 		error = -EINVAL;
@@ -2385,6 +2393,7 @@ int fcntl_setlk(unsigned int fd, struct file *filp, unsigned int cmd,
 		cmd = F_SETLKW;
 		file_lock->fl_flags |= FL_OFDLCK;
 		file_lock->fl_owner = filp;
+		fput(filp);
 		fallthrough;
 	case F_SETLKW:
 		file_lock->fl_flags |= FL_SLEEP;
@@ -2450,6 +2459,7 @@ int fcntl_getlk64(struct file *filp, unsigned int cmd, struct flock64 *flock)
 		cmd = F_GETLK64;
 		fl->fl_flags |= FL_OFDLCK;
 		fl->fl_owner = filp;
+		fput(filp);
 	}
 
 	error = vfs_test_lock(filp, fl);
@@ -2499,6 +2509,7 @@ int fcntl_setlk64(unsigned int fd, struct file *filp, unsigned int cmd,
 		cmd = F_SETLK64;
 		file_lock->fl_flags |= FL_OFDLCK;
 		file_lock->fl_owner = filp;
+		fput(filp);
 		break;
 	case F_OFD_SETLKW:
 		error = -EINVAL;
@@ -2508,6 +2519,7 @@ int fcntl_setlk64(unsigned int fd, struct file *filp, unsigned int cmd,
 		cmd = F_SETLKW64;
 		file_lock->fl_flags |= FL_OFDLCK;
 		file_lock->fl_owner = filp;
+		fput(filp);
 		fallthrough;
 	case F_SETLKW64:
 		file_lock->fl_flags |= FL_SLEEP;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e654435f1651..d7d81962a863 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1028,6 +1028,20 @@ static inline struct file *get_file(struct file *f)
 /* legacy typedef, should eventually be removed */
 typedef void *fl_owner_t;
 
+/*
+ * Set the last significant bit to 1 to mark that
+ * we have get a reference of the fl->fl_file.
+ */
+static inline fl_owner_t file_lock_make_thread_owner(fl_owner_t owner)
+{
+	return (fl_owner_t)((unsigned long)owner | 1UL);
+}
+
+static inline bool file_lock_is_thread_owner(fl_owner_t owner)
+{
+	return ((unsigned long)owner & 1UL);
+}
+
 struct file_lock;
 
 struct file_lock_operations {
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 67178e4bb282..5a12cdf7f8d0 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -212,6 +212,7 @@ int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_close(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct files_struct *files = current->files;
+	fl_owner_t owner = file_lock_make_thread_owner(files);
 	struct io_close *close = io_kiocb_to_cmd(req, struct io_close);
 	struct fdtable *fdt;
 	struct file *file;
@@ -247,7 +248,7 @@ int io_close(struct io_kiocb *req, unsigned int issue_flags)
 		goto err;
 
 	/* No ->flush() or already async, safely close from here */
-	ret = filp_close(file, current->files);
+	ret = filp_close(file, owner);
 err:
 	if (ret < 0)
 		req_set_fail(req);
-- 
2.31.1


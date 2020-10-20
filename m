Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304E7294514
	for <lists+io-uring@lfdr.de>; Wed, 21 Oct 2020 00:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392355AbgJTWVN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Oct 2020 18:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390977AbgJTWVN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Oct 2020 18:21:13 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967E6C0613CE
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 15:21:12 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gv6so77998pjb.4
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 15:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language;
        bh=p9OcnRnBePtrsDek1lD+rhU674WpMJ5/cXx6y2Mj620=;
        b=NnliunH7+teyVSHMpcpRu0N+HV1WqXjGFBFKP9IetsqTNTIevdevRoco3iqvbArRS4
         U8KW1erMp7/90fXG5AfNd4a4pXP5ioU82/FvnSHS1fD0vz/OBj1iiUnrPP7ojPMQyskZ
         2EB1iIH2yeLblue3lb5HbpTS3waEo9tMPaIqUYS2w6vFGHECDZxQIb0WsuE77UzcmjFc
         gSfbdWW8pX3TUD+pvzq4gKQ7LSCeEbIj4/NrFxA8o9rQpt1X1GL9Q0zI4lbV2LeWt+uH
         w2bRB4Nxk0XKG7/842lrvDqhx42M9qVs3xft2NCrbrrzAMZz+oWA+/ggOPLu3Zv48j3l
         YLmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=p9OcnRnBePtrsDek1lD+rhU674WpMJ5/cXx6y2Mj620=;
        b=Vy+MHSUVUK2AlP7nt4ydQ0ZAwOR0y8axLDBRoXuJA7t7Q0JFRGbaZYmmypXzN2e7F4
         iQ4qzNiNOE1dehEfdW0CINxRdcW+KGI5iGDMTkZLF6jk2z/Ay7HUsjfufYwl8vLveAjV
         He0whiZYPQcFMlxqwZiMi/xc0zaMT6msbOJIZ36vStfZHuN/Zfi/pjbjsOW/9g/FdjnV
         eufBq7quZdDbcKeU4ChvKZnsfCZ5yK/5LK3y2YVE/5Li7TF8qqRpjo2oXFXdQMzi4hr0
         WXK61KAv6ZaHqqk28A834SwIjScXdzZnZQS+4KXOoS13mBSVHgzeXDWuB5J/A5M9xG5D
         uiIA==
X-Gm-Message-State: AOAM531a+KmO0bYVfpVDmQrh1gIMEj32d4XB2QdqMpyVAAEs5fB25Fkb
        w1mC8qqk7tMnXqgSP+pRSbQbQ6KLjslTAA==
X-Google-Smtp-Source: ABdhPJzz4M8JWF8vcrfvgyFdhFsPuNXWNeC4ANo8NPgLLpkpQI9++8LLyduD4Cf8SsTuQLT4tqWVLg==
X-Received: by 2002:a17:902:76c5:b029:d3:db7d:7d85 with SMTP id j5-20020a17090276c5b02900d3db7d7d85mr361479plt.24.1603232471769;
        Tue, 20 Oct 2020 15:21:11 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x5sm56760pfp.113.2020.10.20.15.21.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 15:21:10 -0700 (PDT)
Subject: Re: unlink and rename support?
To:     Christopher Harvey <chris@basementcode.com>,
        io-uring@vger.kernel.org
References: <7d2c00d7-1680-4abc-8adf-c4517381db54@www.fastmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1586ec68-ea84-2973-e572-5b957a6b9eb5@kernel.dk>
Date:   Tue, 20 Oct 2020 16:21:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7d2c00d7-1680-4abc-8adf-c4517381db54@www.fastmail.com>
Content-Type: multipart/mixed;
 boundary="------------35F5B7AFA2F7A47427C41AEE"
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------35F5B7AFA2F7A47427C41AEE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 9/26/20 4:28 PM, Christopher Harvey wrote:
> Hi,
> 
> I've just started poking around io_uring and can't figure out why
> unlink and rename aren't supported. Are these planned for the future
> or is there a technical reason why they wont/shouldn't be.

Sorry for being slow, hopefully for 5.11. I did write support for it
(and test cases), just haven't sent out for review yet. In case you are
adventurous, these should apply to current -git (roughly).

-- 
Jens Axboe


--------------35F5B7AFA2F7A47427C41AEE
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-io_uring-add-support-for-IORING_OP_UNLINKAT.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-io_uring-add-support-for-IORING_OP_UNLINKAT.patch"

From b304cbc2a6d34374f300e2278f0f2b008d108ace Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 28 Sep 2020 14:27:37 -0600
Subject: [PATCH 3/3] io_uring: add support for IORING_OP_UNLINKAT

IORING_OP_UNLINKAT behaves like unlinkat(2) and takes the same flags
and arguments.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 61 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  2 ++
 2 files changed, 63 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dc14f70d227b..241e0e69355b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -553,6 +553,13 @@ struct io_rename {
 	int				flags;
 };
 
+struct io_unlink {
+	struct file			*file;
+	int				dfd;
+	int				flags;
+	struct filename			*filename;
+};
+
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
@@ -678,6 +685,7 @@ struct io_kiocb {
 		struct io_statx		statx;
 		struct io_shutdown	shutdown;
 		struct io_rename	rename;
+		struct io_unlink	unlink;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -955,6 +963,10 @@ static const struct io_op_def io_op_defs[] = {
 		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
 						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
 	},
+	[IORING_OP_UNLINKAT] = {
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
+						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
+	},
 };
 
 enum io_mem_account {
@@ -3681,6 +3693,47 @@ static int io_renameat(struct io_kiocb *req, bool force_nonblock)
 	return 0;
 }
 
+static int io_unlinkat_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_unlink *un = &req->unlink;
+	const char __user *fname;
+
+	un->dfd = READ_ONCE(sqe->fd);
+
+	un->flags = READ_ONCE(sqe->unlink_flags);
+	if (un->flags & ~AT_REMOVEDIR)
+		return -EINVAL;
+
+	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	un->filename = getname(fname);
+	if (IS_ERR(un->filename))
+		return PTR_ERR(un->filename);
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+static int io_unlinkat(struct io_kiocb *req, bool force_nonblock)
+{
+	struct io_unlink *un = &req->unlink;
+	int ret;
+
+	if (force_nonblock)
+		return -EAGAIN;
+
+	if (un->flags & AT_REMOVEDIR)
+		ret = do_rmdir(un->dfd, un->filename);
+	else
+		ret = do_unlinkat(un->dfd, un->filename);
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
 static int io_shutdown_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -5899,6 +5952,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_shutdown_prep(req, sqe);
 	case IORING_OP_RENAMEAT:
 		return io_renameat_prep(req, sqe);
+	case IORING_OP_UNLINKAT:
+		return io_unlinkat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6040,6 +6095,9 @@ static void __io_clean_op(struct io_kiocb *req)
 			putname(req->rename.oldpath);
 			putname(req->rename.newpath);
 			break;
+		case IORING_OP_UNLINKAT:
+			putname(req->unlink.filename);
+			break;
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
@@ -6152,6 +6210,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	case IORING_OP_RENAMEAT:
 		ret = io_renameat(req, force_nonblock);
 		break;
+	case IORING_OP_UNLINKAT:
+		ret = io_unlinkat(req, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index c9a58bc7e4be..557e7eae497f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -43,6 +43,7 @@ struct io_uring_sqe {
 		__u32		fadvise_advice;
 		__u32		splice_flags;
 		__u32		rename_flags;
+		__u32		unlink_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
@@ -135,6 +136,7 @@ enum {
 	IORING_OP_TEE,
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
+	IORING_OP_UNLINKAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.28.0


--------------35F5B7AFA2F7A47427C41AEE
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-add-support-for-IORING_OP_RENAMEAT.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-io_uring-add-support-for-IORING_OP_RENAMEAT.patch"

From 9350748ca212a2800026cc7f368ff27ef6fc5739 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 28 Sep 2020 14:23:58 -0600
Subject: [PATCH 2/3] io_uring: add support for IORING_OP_RENAMEAT

IORING_OP_RENAMEAT behaves like renameat2(), and takes the same flags
etc.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 66 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  2 ++
 2 files changed, 68 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3b2104d2cbaf..dc14f70d227b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -544,6 +544,15 @@ struct io_shutdown {
 	int				how;
 };
 
+struct io_rename {
+	struct file			*file;
+	int				old_dfd;
+	int				new_dfd;
+	struct filename			*oldpath;
+	struct filename			*newpath;
+	int				flags;
+};
+
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
@@ -668,6 +677,7 @@ struct io_kiocb {
 		struct io_provide_buf	pbuf;
 		struct io_statx		statx;
 		struct io_shutdown	shutdown;
+		struct io_rename	rename;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -941,6 +951,10 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_SHUTDOWN] = {
 		.needs_file		= 1,
 	},
+	[IORING_OP_RENAMEAT] = {
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
+						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
+	},
 };
 
 enum io_mem_account {
@@ -3624,6 +3638,49 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	return ret;
 }
 
+static int io_renameat_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_rename *ren = &req->rename;
+	const char __user *oldf, *newf;
+
+	ren->old_dfd = READ_ONCE(sqe->fd);
+	oldf = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	newf = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	ren->new_dfd = READ_ONCE(sqe->len);
+	ren->flags = READ_ONCE(sqe->rename_flags);
+
+	ren->oldpath = getname(oldf);
+	if (IS_ERR(ren->oldpath))
+		return PTR_ERR(ren->oldpath);
+
+	ren->newpath = getname(newf);
+	if (IS_ERR(ren->newpath)) {
+		putname(ren->oldpath);
+		return PTR_ERR(ren->newpath);
+	}
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+static int io_renameat(struct io_kiocb *req, bool force_nonblock)
+{
+	struct io_rename *ren = &req->rename;
+	int ret;
+
+	if (force_nonblock)
+		return -EAGAIN;
+
+	ret = do_renameat2(ren->old_dfd, ren->oldpath, ren->new_dfd,
+				ren->newpath, ren->flags);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
 static int io_shutdown_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -5840,6 +5897,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_tee_prep(req, sqe);
 	case IORING_OP_SHUTDOWN:
 		return io_shutdown_prep(req, sqe);
+	case IORING_OP_RENAMEAT:
+		return io_renameat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -5977,6 +6036,10 @@ static void __io_clean_op(struct io_kiocb *req)
 			if (req->open.filename)
 				putname(req->open.filename);
 			break;
+		case IORING_OP_RENAMEAT:
+			putname(req->rename.oldpath);
+			putname(req->rename.newpath);
+			break;
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
@@ -6086,6 +6149,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	case IORING_OP_SHUTDOWN:
 		ret = io_shutdown(req, force_nonblock);
 		break;
+	case IORING_OP_RENAMEAT:
+		ret = io_renameat(req, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2301c37e86cb..c9a58bc7e4be 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -42,6 +42,7 @@ struct io_uring_sqe {
 		__u32		statx_flags;
 		__u32		fadvise_advice;
 		__u32		splice_flags;
+		__u32		rename_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
@@ -133,6 +134,7 @@ enum {
 	IORING_OP_REMOVE_BUFFERS,
 	IORING_OP_TEE,
 	IORING_OP_SHUTDOWN,
+	IORING_OP_RENAMEAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.28.0


--------------35F5B7AFA2F7A47427C41AEE
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-fs-make-do_renameat2-take-struct-filename.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-fs-make-do_renameat2-take-struct-filename.patch"

From 0f175f9200a56eafb8a887ceac87b2551ec995fa Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sat, 26 Sep 2020 17:20:17 -0600
Subject: [PATCH 1/3] fs: make do_renameat2() take struct filename

Pass in the struct filename pointers instead of the user string, and
update the three callers to do the same.

This behaves like do_unlinkat(), which also takes a filename struct and
puts it when it is done. Converting callers is then trivial.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/internal.h |  2 ++
 fs/namei.c    | 23 ++++++++++++++---------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index a7cd0f64faa4..6fd14ea213c3 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -78,6 +78,8 @@ extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 long do_rmdir(int dfd, struct filename *name);
 long do_unlinkat(int dfd, struct filename *name);
 int may_linkat(struct path *link);
+int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
+		 struct filename *newname, unsigned int flags);
 
 /*
  * namespace.c
diff --git a/fs/namei.c b/fs/namei.c
index f1eb8ccd2be9..afa2686701dd 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4345,8 +4345,8 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 }
 EXPORT_SYMBOL(vfs_rename);
 
-static int do_renameat2(int olddfd, const char __user *oldname, int newdfd,
-			const char __user *newname, unsigned int flags)
+int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
+		 struct filename *newname, unsigned int flags)
 {
 	struct dentry *old_dentry, *new_dentry;
 	struct dentry *trap;
@@ -4371,15 +4371,17 @@ static int do_renameat2(int olddfd, const char __user *oldname, int newdfd,
 		target_flags = 0;
 
 retry:
-	from = filename_parentat(olddfd, getname(oldname), lookup_flags,
-				&old_path, &old_last, &old_type);
+	from = filename_parentat(olddfd, oldname, lookup_flags, &old_path,
+					&old_last, &old_type);
 	if (IS_ERR(from)) {
 		error = PTR_ERR(from);
+		if (!IS_ERR(newname))
+			putname(newname);
 		goto exit;
 	}
 
-	to = filename_parentat(newdfd, getname(newname), lookup_flags,
-				&new_path, &new_last, &new_type);
+	to = filename_parentat(newdfd, newname, lookup_flags, &new_path,
+				&new_last, &new_type);
 	if (IS_ERR(to)) {
 		error = PTR_ERR(to);
 		goto exit1;
@@ -4488,18 +4490,21 @@ static int do_renameat2(int olddfd, const char __user *oldname, int newdfd,
 SYSCALL_DEFINE5(renameat2, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname, unsigned int, flags)
 {
-	return do_renameat2(olddfd, oldname, newdfd, newname, flags);
+	return do_renameat2(olddfd, getname(oldname), newdfd, getname(newname),
+				flags);
 }
 
 SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname)
 {
-	return do_renameat2(olddfd, oldname, newdfd, newname, 0);
+	return do_renameat2(olddfd, getname(oldname), newdfd, getname(newname),
+				0);
 }
 
 SYSCALL_DEFINE2(rename, const char __user *, oldname, const char __user *, newname)
 {
-	return do_renameat2(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
+	return do_renameat2(AT_FDCWD, getname(oldname), AT_FDCWD,
+				getname(newname), 0);
 }
 
 int readlink_copy(char __user *buffer, int buflen, const char *link)
-- 
2.28.0


--------------35F5B7AFA2F7A47427C41AEE--

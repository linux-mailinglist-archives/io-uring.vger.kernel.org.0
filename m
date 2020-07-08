Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDEF21935B
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 00:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgGHW0u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 18:26:50 -0400
Received: from casper.infradead.org ([90.155.50.34]:45752 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGHW0s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 18:26:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=0cw2EpMcOWKnziLbFIKf3CiqiIzag4QKTjSZuHn5tn0=; b=bo5DI3+voPsNVB47TwoIoKy5Wy
        pibOBRoZptLBnGdAxX9XdVqoa34qqEG6DdeghuVLCV9DX7Ez+TPlzU1d7k7VPJp4FywQ5Yvr3FykV
        u7AjnZTbWuqaJo8J4b8PMNVjnHTmOgx8PC92oKu3g5FxLI5Nd0Uivc8YSLhxQcL/HCZs4ymJ5EsoF
        8Pbqwkv8lS+RClSOiB9L843ld+pBVKd0cSsN4nmA1Hbb/bIUZ4HmkeHrg2lgLsTP72Bv2hAIVHojL
        yWFgzbRO8jZXsj94ZAS3yxy6dtxGPiAPQUN/fRm8UBU9CL5g4s5HNLqxgJ9lhBfb3KhKqEfqckMoS
        mGgrKZlQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtIWW-00060e-7n; Wed, 08 Jul 2020 22:26:40 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: [PATCH 2/2] fs: Remove kiocb->ki_complete
Date:   Wed,  8 Jul 2020 23:26:36 +0100
Message-Id: <20200708222637.23046-3-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200708222637.23046-1-willy@infradead.org>
References: <20200708222637.23046-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use a few bits of ki_flags to indicate which completion function to call.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/block/loop.c              | 12 ++++++--
 drivers/nvme/target/core.c        | 10 ++++++-
 drivers/nvme/target/io-cmd-file.c | 10 +++----
 drivers/nvme/target/nvmet.h       |  2 ++
 drivers/target/target_core_file.c | 20 +++++++++++--
 fs/aio.c                          | 48 +++++++++++++++++--------------
 fs/cifs/file.c                    |  4 +--
 fs/io_uring.c                     | 12 ++++++--
 fs/ocfs2/file.c                   |  7 +++--
 fs/overlayfs/file.c               | 15 ++++++++--
 fs/read_write.c                   | 32 ++++++++++++++++++++-
 include/linux/fs.h                | 21 ++++++++++++--
 12 files changed, 145 insertions(+), 48 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index f7a76e82c88c..6bd6e55f3e17 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -513,6 +513,7 @@ static void lo_rw_aio_do_completion(struct loop_cmd *cmd)
 		blk_mq_complete_request(rq);
 }
 
+static int lo_rw_aio_complete_id;
 static void lo_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
 {
 	struct loop_cmd *cmd = container_of(iocb, struct loop_cmd, iocb);
@@ -576,8 +577,8 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 
 	cmd->iocb.ki_pos = pos;
 	cmd->iocb.ki_filp = file;
-	cmd->iocb.ki_complete = lo_rw_aio_complete;
 	cmd->iocb.ki_flags = IOCB_DIRECT;
+	kiocb_set_completion(&cmd->iocb, lo_rw_aio_complete_id);
 	cmd->iocb.ki_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0);
 	if (cmd->css)
 		kthread_associate_blkcg(cmd->css);
@@ -2362,10 +2363,14 @@ static int __init loop_init(void)
 		range = 1UL << MINORBITS;
 	}
 
-	err = misc_register(&loop_misc);
+	err = register_kiocb_completion(lo_rw_aio_complete);
 	if (err < 0)
 		goto err_out;
+	lo_rw_aio_complete_id = err;
 
+	err = misc_register(&loop_misc);
+	if (err < 0)
+		goto kiocb_out;
 
 	if (register_blkdev(LOOP_MAJOR, "loop")) {
 		err = -EIO;
@@ -2386,6 +2391,8 @@ static int __init loop_init(void)
 
 misc_out:
 	misc_deregister(&loop_misc);
+kiocb_out:
+	unregister_kiocb_completion(lo_rw_aio_complete_id);
 err_out:
 	return err;
 }
@@ -2413,6 +2420,7 @@ static void __exit loop_exit(void)
 	unregister_blkdev(LOOP_MAJOR, "loop");
 
 	misc_deregister(&loop_misc);
+	unregister_kiocb_completion(lo_rw_aio_complete_id);
 
 	mutex_unlock(&loop_ctl_mutex);
 }
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 6816507fba58..8b622641c667 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1563,11 +1563,16 @@ static int __init nvmet_init(void)
 
 	nvmet_ana_group_enabled[NVMET_DEFAULT_ANA_GRPID] = 1;
 
+	error = register_kiocb_completion(nvmet_file_io_done);
+	if (error)
+		goto out;
+	nvmet_file_io_done_id = error;
+
 	buffered_io_wq = alloc_workqueue("nvmet-buffered-io-wq",
 			WQ_MEM_RECLAIM, 0);
 	if (!buffered_io_wq) {
 		error = -ENOMEM;
-		goto out;
+		goto out_kiocb;
 	}
 
 	error = nvmet_init_discovery();
@@ -1583,6 +1588,8 @@ static int __init nvmet_init(void)
 	nvmet_exit_discovery();
 out_free_work_queue:
 	destroy_workqueue(buffered_io_wq);
+out_kiocb:
+	unregister_kiocb_completion(nvmet_file_io_done_id);
 out:
 	return error;
 }
@@ -1593,6 +1600,7 @@ static void __exit nvmet_exit(void)
 	nvmet_exit_discovery();
 	ida_destroy(&cntlid_ida);
 	destroy_workqueue(buffered_io_wq);
+	unregister_kiocb_completion(nvmet_file_io_done_id);
 
 	BUILD_BUG_ON(sizeof(struct nvmf_disc_rsp_page_entry) != 1024);
 	BUILD_BUG_ON(sizeof(struct nvmf_disc_rsp_page_hdr) != 1024);
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 0abbefd9925e..5884039e28e1 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -123,7 +123,8 @@ static ssize_t nvmet_file_submit_bvec(struct nvmet_req *req, loff_t pos,
 	return call_iter(iocb, &iter);
 }
 
-static void nvmet_file_io_done(struct kiocb *iocb, long ret, long ret2)
+int nvmet_file_io_done_id;
+void nvmet_file_io_done(struct kiocb *iocb, long ret, long ret2)
 {
 	struct nvmet_req *req = container_of(iocb, struct nvmet_req, f.iocb);
 	u16 status = NVME_SC_SUCCESS;
@@ -192,12 +193,9 @@ static bool nvmet_file_execute_io(struct nvmet_req *req, int ki_flags)
 		goto complete;
 	}
 
-	/*
-	 * A NULL ki_complete ask for synchronous execution, which we want
-	 * for the IOCB_NOWAIT case.
-	 */
+	/* No completion means synchronous execution */
 	if (!(ki_flags & IOCB_NOWAIT))
-		req->f.iocb.ki_complete = nvmet_file_io_done;
+		kiocb_set_completion(&req->f.iocb, nvmet_file_io_done_id);
 
 	ret = nvmet_file_submit_bvec(req, pos, bv_cnt, total_len, ki_flags);
 
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 809691291e73..d42c8b3bcdb5 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -340,6 +340,8 @@ struct nvmet_req {
 };
 
 extern struct workqueue_struct *buffered_io_wq;
+extern int nvmet_file_io_done_id;
+extern void nvmet_file_io_done(struct kiocb *, long, long);
 
 static inline void nvmet_set_result(struct nvmet_req *req, u32 result)
 {
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 7143d03f0e02..acae6a159e91 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -243,6 +243,7 @@ struct target_core_file_cmd {
 	struct kiocb	iocb;
 };
 
+static int cmd_rw_aio_complete_id;
 static void cmd_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
 {
 	struct target_core_file_cmd *cmd;
@@ -296,8 +297,8 @@ fd_execute_rw_aio(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	aio_cmd->len = len;
 	aio_cmd->iocb.ki_pos = cmd->t_task_lba * dev->dev_attrib.block_size;
 	aio_cmd->iocb.ki_filp = file;
-	aio_cmd->iocb.ki_complete = cmd_rw_aio_complete;
 	aio_cmd->iocb.ki_flags = IOCB_DIRECT;
+	kiocb_set_completion(&aio_cmd->iocb, cmd_rw_aio_complete_id);
 
 	if (is_write && (cmd->se_cmd_flags & SCF_FUA))
 		aio_cmd->iocb.ki_flags |= IOCB_DSYNC;
@@ -945,12 +946,27 @@ static const struct target_backend_ops fileio_ops = {
 
 static int __init fileio_module_init(void)
 {
-	return transport_backend_register(&fileio_ops);
+	int err;
+
+	err = register_kiocb_completion(cmd_rw_aio_complete);
+	if (err < 0)
+		return err;
+	cmd_rw_aio_complete_id = err;
+
+	err = transport_backend_register(&fileio_ops);
+	if (err)
+		goto out_kiocb;
+	return 0;
+
+out_kiocb:
+	unregister_kiocb_completion(cmd_rw_aio_complete_id);
+	return err;
 }
 
 static void __exit fileio_module_exit(void)
 {
 	target_backend_unregister(&fileio_ops);
+	unregister_kiocb_completion(cmd_rw_aio_complete_id);
 }
 
 MODULE_DESCRIPTION("TCM FILEIO subsystem plugin");
diff --git a/fs/aio.c b/fs/aio.c
index ca3b123d83f7..135f278fffd9 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -258,27 +258,6 @@ static int aio_init_fs_context(struct fs_context *fc)
 	return 0;
 }
 
-/* aio_setup
- *	Creates the slab caches used by the aio routines, panic on
- *	failure as this is done early during the boot sequence.
- */
-static int __init aio_setup(void)
-{
-	static struct file_system_type aio_fs = {
-		.name		= "aio",
-		.init_fs_context = aio_init_fs_context,
-		.kill_sb	= kill_anon_super,
-	};
-	aio_mnt = kern_mount(&aio_fs);
-	if (IS_ERR(aio_mnt))
-		panic("Failed to create aio fs mount.");
-
-	kiocb_cachep = KMEM_CACHE(aio_kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
-	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
-	return 0;
-}
-__initcall(aio_setup);
-
 static void put_aio_ring_file(struct kioctx *ctx)
 {
 	struct file *aio_ring_file = ctx->aio_ring_file;
@@ -1418,6 +1397,7 @@ static void aio_remove_iocb(struct aio_kiocb *iocb)
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 }
 
+static int aio_complete_rw_id;
 static void aio_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct aio_kiocb *iocb = container_of(kiocb, struct aio_kiocb, rw);
@@ -1446,10 +1426,10 @@ static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
 {
 	int ret;
 
-	req->ki_complete = aio_complete_rw;
 	req->private = NULL;
 	req->ki_pos = iocb->aio_offset;
 	req->ki_flags = iocb_flags(req->ki_filp);
+	kiocb_set_completion(req, aio_complete_rw_id);
 	if (iocb->aio_flags & IOCB_FLAG_RESFD)
 		req->ki_flags |= IOCB_EVENTFD;
 	req->ki_hint = ki_hint_validate(file_write_hint(req->ki_filp));
@@ -2276,3 +2256,27 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
 	return ret;
 }
 #endif
+
+/*
+ * Creates the slab caches used by the aio routines, panic on
+ * failure as this is done early during the boot sequence.
+ */
+static int __init aio_setup(void)
+{
+	static struct file_system_type aio_fs = {
+		.name		= "aio",
+		.init_fs_context = aio_init_fs_context,
+		.kill_sb	= kill_anon_super,
+	};
+	aio_mnt = kern_mount(&aio_fs);
+	if (IS_ERR(aio_mnt))
+		panic("Failed to create aio fs mount.");
+
+	kiocb_cachep = KMEM_CACHE(aio_kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
+	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
+	aio_complete_rw_id = register_kiocb_completion(aio_complete_rw);
+	BUG_ON(aio_complete_rw_id < 0);
+	return 0;
+}
+__initcall(aio_setup);
+
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index cbf36a8a23aa..b4cfd262a1a4 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3115,7 +3115,7 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 
 	mutex_unlock(&ctx->aio_mutex);
 
-	if (ctx->iocb && ctx->iocb->ki_complete)
+	if (ctx->iocb && !is_sync_kiocb(ctx->iocb))
 		complete_kiocb(ctx->iocb, ctx->rc, 0);
 	else
 		complete(&ctx->done);
@@ -3848,7 +3848,7 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 
 	mutex_unlock(&ctx->aio_mutex);
 
-	if (ctx->iocb && ctx->iocb->ki_complete)
+	if (ctx->iocb && !is_sync_kiocb(ctx->iocb))
 		complete_kiocb(ctx->iocb, ctx->rc, 0);
 	else
 		complete(&ctx->done);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index f06915fcb6b6..e0f68aa78596 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2237,6 +2237,7 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 		io_complete_rw_common(&req->rw.kiocb, res, cs);
 }
 
+static int io_complete_rw_id;
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
@@ -2244,6 +2245,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 	__io_complete_rw(req, res, res2, NULL);
 }
 
+static int io_complete_rw_iopoll_id;
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
@@ -2437,13 +2439,13 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			return -EOPNOTSUPP;
 
 		kiocb->ki_flags |= IOCB_HIPRI;
-		kiocb->ki_complete = io_complete_rw_iopoll;
+		kiocb_set_completion(kiocb, io_complete_rw_iopoll_id);
 		req->iopoll_completed = 0;
 		io_get_req_task(req);
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
-		kiocb->ki_complete = io_complete_rw;
+		kiocb_set_completion(kiocb, io_complete_rw_id);
 	}
 
 	req->rw.addr = READ_ONCE(sqe->addr);
@@ -2480,7 +2482,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = kiocb->ki_pos;
-	if (ret >= 0 && kiocb->ki_complete == io_complete_rw)
+	if (ret >= 0 && kiocb_completion_id(kiocb) == io_complete_rw_id)
 		__io_complete_rw(req, ret, 0, cs);
 	else
 		io_rw_done(kiocb, ret);
@@ -8596,6 +8598,10 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
+	io_complete_rw_id = register_kiocb_completion(io_complete_rw);
+	io_complete_rw_iopoll_id =
+			register_kiocb_completion(io_complete_rw_iopoll);
+	BUG_ON(io_complete_rw_id < 0 || io_complete_rw_iopoll_id < 0);
 	return 0;
 };
 __initcall(io_uring_init);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 85979e2214b3..abcd5257ca34 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2284,7 +2284,7 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int full_coherency = !(osb->s_mount_opt &
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
-	void *saved_ki_complete = NULL;
+	int saved_ki_complete = 0;
 	int append_write = ((iocb->ki_pos + count) >=
 			i_size_read(inode) ? 1 : 0);
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
@@ -2368,7 +2368,8 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 		/*
 		 * Make it a sync io if it's an unaligned aio.
 		 */
-		saved_ki_complete = xchg(&iocb->ki_complete, NULL);
+		saved_ki_complete = kiocb_completion_id(iocb);
+		kiocb_set_completion(iocb, 0);
 	}
 
 	/* communicate with ocfs2_dio_end_io */
@@ -2416,7 +2417,7 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 
 out:
 	if (saved_ki_complete)
-		xchg(&iocb->ki_complete, saved_ki_complete);
+		kiocb_set_completion(iocb, saved_ki_complete);
 
 	if (rw_level != -1)
 		ocfs2_rw_unlock(inode, rw_level);
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 78e7439fc4e2..5951c4180bc9 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -278,6 +278,8 @@ static void ovl_aio_rw_complete(struct kiocb *iocb, long res, long res2)
 	complete_kiocb(orig_iocb, res, res2);
 }
 
+static int ovl_aio_rw_complete_id;
+
 static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
@@ -308,7 +310,7 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		real.flags = 0;
 		aio_req->orig_iocb = iocb;
 		kiocb_clone(&aio_req->iocb, iocb, real.file);
-		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
+		kiocb_set_completion(&aio_req->iocb, ovl_aio_rw_complete_id);
 		ret = vfs_iocb_iter_read(real.file, &aio_req->iocb, iter);
 		if (ret != -EIOCBQUEUED)
 			ovl_aio_cleanup_handler(aio_req);
@@ -368,7 +370,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		real.flags = 0;
 		aio_req->orig_iocb = iocb;
 		kiocb_clone(&aio_req->iocb, iocb, real.file);
-		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
+		kiocb_set_completion(&aio_req->iocb, ovl_aio_rw_complete_id);
 		ret = vfs_iocb_iter_write(real.file, &aio_req->iocb, iter);
 		if (ret != -EIOCBQUEUED)
 			ovl_aio_cleanup_handler(aio_req);
@@ -792,16 +794,23 @@ const struct file_operations ovl_file_operations = {
 
 int __init ovl_aio_request_cache_init(void)
 {
+	ovl_aio_rw_complete_id = register_kiocb_completion(ovl_aio_rw_complete);
+	if (ovl_aio_rw_complete_id < 0)
+		return ovl_aio_rw_complete_id;
+
 	ovl_aio_request_cachep = kmem_cache_create("ovl_aio_req",
 						   sizeof(struct ovl_aio_req),
 						   0, SLAB_HWCACHE_ALIGN, NULL);
-	if (!ovl_aio_request_cachep)
+	if (!ovl_aio_request_cachep) {
+		unregister_kiocb_completion(ovl_aio_rw_complete_id);
 		return -ENOMEM;
+	}
 
 	return 0;
 }
 
 void ovl_aio_request_cache_destroy(void)
 {
+	unregister_kiocb_completion(ovl_aio_rw_complete_id);
 	kmem_cache_destroy(ovl_aio_request_cachep);
 }
diff --git a/fs/read_write.c b/fs/read_write.c
index 89151de19f77..0163cefb9bf1 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -363,9 +363,39 @@ SYSCALL_DEFINE5(llseek, unsigned int, fd, unsigned long, offset_high,
 }
 #endif
 
+#define IOCB_CB_MAX	((1 << _IOCB_COMPLETION_BITS) - 1)
+
+typedef void ki_cmpl(struct kiocb *, long ret, long ret2);
+static ki_cmpl *ki_cmpls[IOCB_CB_MAX];
+
+int register_kiocb_completion(ki_cmpl cb)
+{
+	int i;
+
+	for (i = 0; i < IOCB_CB_MAX; i++) {
+		if (ki_cmpls[i])
+			continue;
+		ki_cmpls[i] = cb;
+		return i + 1;
+	}
+
+	pr_err("Increase _IOCB_COMPLETION_BITS\n");
+	return -EBUSY;
+}
+EXPORT_SYMBOL(register_kiocb_completion);
+
+void unregister_kiocb_completion(int id)
+{
+	ki_cmpls[id - 1] = NULL;
+}
+EXPORT_SYMBOL(unregister_kiocb_completion);
+
 void complete_kiocb(struct kiocb *iocb, long ret, long ret2)
 {
-	iocb->ki_complete(iocb, ret, ret2);
+	unsigned int id = kiocb_completion_id(iocb);
+
+	if (id > 0)
+		ki_cmpls[id - 1](iocb, ret, ret2);
 }
 EXPORT_SYMBOL(complete_kiocb);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 846135aa328d..fa6f98714994 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -320,6 +320,9 @@ enum rw_hint {
 #define IOCB_NOWAIT		(1 << 7)
 /* iocb->ki_waitq is valid */
 #define IOCB_WAITQ		(1 << 8)
+#define _IOCB_COMPLETION_BITS	4
+#define _IOCB_COMPLETION_SHIFT	(32 - _IOCB_COMPLETION_BITS)
+#define IOCB_COMPLETION_FNS	(~0 << _IOCB_COMPLETION_SHIFT)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -328,9 +331,8 @@ struct kiocb {
 	randomized_struct_fields_start
 
 	loff_t			ki_pos;
-	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
 	void			*private;
-	int			ki_flags;
+	unsigned int		ki_flags;
 	u16			ki_hint;
 	u16			ki_ioprio; /* See linux/ioprio.h */
 	union {
@@ -341,12 +343,25 @@ struct kiocb {
 	randomized_struct_fields_end
 };
 
+static inline int kiocb_completion_id(struct kiocb *kiocb)
+{
+	return kiocb->ki_flags >> _IOCB_COMPLETION_SHIFT;
+}
+
+static inline void kiocb_set_completion(struct kiocb *kiocb, int id)
+{
+	kiocb->ki_flags = (kiocb->ki_flags & (~IOCB_COMPLETION_FNS)) |
+				(id << _IOCB_COMPLETION_SHIFT);
+}
+
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
 {
-	return kiocb->ki_complete == NULL;
+	return kiocb_completion_id(kiocb) == 0;
 }
 
 void complete_kiocb(struct kiocb *kiocb, long ret, long ret2);
+int register_kiocb_completion(void (*)(struct kiocb *, long, long));
+void unregister_kiocb_completion(int id);
 
 /*
  * "descriptor" for what we're up to with a read.
-- 
2.27.0


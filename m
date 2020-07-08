Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922D1219363
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 00:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgGHW04 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 18:26:56 -0400
Received: from casper.infradead.org ([90.155.50.34]:45766 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgGHW0w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 18:26:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=F0tAChMmj4QXzdRFsnSO800dOqSabaCWqBgONS8U2jg=; b=J6R1jXtgY3K0k0AR/u0bAhO46I
        7ZqbuJtTxnkJWg13JiFg/ClCk9FUMIBIEuk9Z261nBkbkjPQn6CoFHSC78oK2fXEjqwKwiPqYDdPL
        58KmGk/TugulXejmGYpU5PuzfyxRHy+hYm0RfmeRMSlTAqv304qcVrKtibghjewpDeyrt0vSBklFq
        e9KF38CHYRPDFhHrsQzfGVgB1mqdh2pEk69NY2cgmurC8POw+QpRlvR7B5j2om5pcvHWT2h8v4zwM
        12O7KGxbC7yRWM/0QSQi6b9/pkYn4swbgVaMmkoRW3vofKtcXLr0TDoq2KxqFrG8Q2vjdEwiZOuEC
        F70VfWAQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtIWV-00060a-Np; Wed, 08 Jul 2020 22:26:39 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: [PATCH 1/2] fs: Abstract calling the kiocb completion function
Date:   Wed,  8 Jul 2020 23:26:35 +0100
Message-Id: <20200708222637.23046-2-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200708222637.23046-1-willy@infradead.org>
References: <20200708222637.23046-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce complete_kiocb() to abstract the calls to ->ki_complete().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 crypto/af_alg.c                    | 2 +-
 drivers/block/loop.c               | 2 +-
 drivers/usb/gadget/function/f_fs.c | 2 +-
 drivers/usb/gadget/legacy/inode.c  | 4 ++--
 fs/aio.c                           | 2 +-
 fs/block_dev.c                     | 2 +-
 fs/ceph/file.c                     | 2 +-
 fs/cifs/file.c                     | 4 ++--
 fs/direct-io.c                     | 2 +-
 fs/fuse/file.c                     | 2 +-
 fs/io_uring.c                      | 2 +-
 fs/iomap/direct-io.c               | 3 +--
 fs/nfs/direct.c                    | 2 +-
 fs/overlayfs/file.c                | 2 +-
 fs/read_write.c                    | 6 ++++++
 include/linux/fs.h                 | 2 ++
 16 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index b1cd3535c525..590dbbcd0e9f 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1045,7 +1045,7 @@ void af_alg_async_cb(struct crypto_async_request *_req, int err)
 	af_alg_free_resources(areq);
 	sock_put(sk);
 
-	iocb->ki_complete(iocb, err ? err : (int)resultlen, 0);
+	complete_kiocb(iocb, err ? err : (int)resultlen, 0);
 }
 EXPORT_SYMBOL_GPL(af_alg_async_cb);
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index a943207705dd..f7a76e82c88c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -591,7 +591,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	kthread_associate_blkcg(NULL);
 
 	if (ret != -EIOCBQUEUED)
-		cmd->iocb.ki_complete(&cmd->iocb, ret, 0);
+		complete_kiocb(&cmd->iocb, ret, 0);
 	return 0;
 }
 
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 490d353d5fde..6b0c128fdb7e 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -829,7 +829,7 @@ static void ffs_user_copy_worker(struct work_struct *work)
 		kthread_unuse_mm(io_data->mm);
 	}
 
-	io_data->kiocb->ki_complete(io_data->kiocb, ret, ret);
+	complete_kiocb(io_data->kiocb, ret, ret);
 
 	if (io_data->ffs->ffs_eventfd && !kiocb_has_eventfd)
 		eventfd_signal(io_data->ffs->ffs_eventfd, 1);
diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 9ee0bfe7bcda..d16ce03c872a 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -469,7 +469,7 @@ static void ep_user_copy_worker(struct work_struct *work)
 		ret = -EFAULT;
 
 	/* completing the iocb can drop the ctx and mm, don't touch mm after */
-	iocb->ki_complete(iocb, ret, ret);
+	complete_kiocb(iocb, ret, ret);
 
 	kfree(priv->buf);
 	kfree(priv->to_free);
@@ -498,7 +498,7 @@ static void ep_aio_complete(struct usb_ep *ep, struct usb_request *req)
 		iocb->private = NULL;
 		/* aio_complete() reports bytes-transferred _and_ faults */
 
-		iocb->ki_complete(iocb, req->actual ? req->actual : req->status,
+		complete_kiocb(iocb, req->actual ? req->actual : req->status,
 				req->status);
 	} else {
 		/* ep_copy_to_user() won't report both; we hide some faults */
diff --git a/fs/aio.c b/fs/aio.c
index 91e7cc4a9f17..ca3b123d83f7 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1513,7 +1513,7 @@ static inline void aio_rw_done(struct kiocb *req, ssize_t ret)
 		ret = -EINTR;
 		/*FALLTHRU*/
 	default:
-		req->ki_complete(req, ret, 0);
+		complete_kiocb(req, ret, 0);
 	}
 }
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 182ddf82938f..76c55cd14ad1 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -304,7 +304,7 @@ static void blkdev_bio_end_io(struct bio *bio)
 				ret = blk_status_to_errno(dio->bio.bi_status);
 			}
 
-			dio->iocb->ki_complete(iocb, ret, 0);
+			complete_kiocb(iocb, ret, 0);
 			if (dio->multi_bio)
 				bio_put(&dio->bio);
 		} else {
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 160644ddaeed..4e379c385202 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1040,7 +1040,7 @@ static void ceph_aio_complete(struct inode *inode,
 	ceph_put_cap_refs(ci, (aio_req->write ? CEPH_CAP_FILE_WR :
 						CEPH_CAP_FILE_RD));
 
-	aio_req->iocb->ki_complete(aio_req->iocb, ret, 0);
+	complete_kiocb(aio_req->iocb, ret, 0);
 
 	ceph_free_cap_flush(aio_req->prealloc_cf);
 	kfree(aio_req);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9b0f8f33f832..cbf36a8a23aa 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3116,7 +3116,7 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 	mutex_unlock(&ctx->aio_mutex);
 
 	if (ctx->iocb && ctx->iocb->ki_complete)
-		ctx->iocb->ki_complete(ctx->iocb, ctx->rc, 0);
+		complete_kiocb(ctx->iocb, ctx->rc, 0);
 	else
 		complete(&ctx->done);
 }
@@ -3849,7 +3849,7 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 	mutex_unlock(&ctx->aio_mutex);
 
 	if (ctx->iocb && ctx->iocb->ki_complete)
-		ctx->iocb->ki_complete(ctx->iocb, ctx->rc, 0);
+		complete_kiocb(ctx->iocb, ctx->rc, 0);
 	else
 		complete(&ctx->done);
 }
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 183299892465..b17dceaeebe5 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -308,7 +308,7 @@ static ssize_t dio_complete(struct dio *dio, ssize_t ret, unsigned int flags)
 
 		if (ret > 0 && dio->op == REQ_OP_WRITE)
 			ret = generic_write_sync(dio->iocb, ret);
-		dio->iocb->ki_complete(dio->iocb, ret, 0);
+		complete_kiocb(dio->iocb, ret, 0);
 	}
 
 	kmem_cache_free(dio_cache, dio);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e573b0cd2737..7eac77d950fb 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -655,7 +655,7 @@ static void fuse_aio_complete(struct fuse_io_priv *io, int err, ssize_t pos)
 			spin_unlock(&fi->lock);
 		}
 
-		io->iocb->ki_complete(io->iocb, res, 0);
+		complete_kiocb(io->iocb, res, 0);
 	}
 
 	kref_put(&io->refcnt, fuse_io_release);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6e3169834bf7..f06915fcb6b6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2469,7 +2469,7 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 		ret = -EINTR;
 		/* fall through */
 	default:
-		kiocb->ki_complete(kiocb, ret, 0);
+		complete_kiocb(kiocb, ret, 0);
 	}
 }
 
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ec7b78e6feca..3b7edd9c3c11 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -133,9 +133,8 @@ static ssize_t iomap_dio_complete(struct iomap_dio *dio)
 static void iomap_dio_complete_work(struct work_struct *work)
 {
 	struct iomap_dio *dio = container_of(work, struct iomap_dio, aio.work);
-	struct kiocb *iocb = dio->iocb;
 
-	iocb->ki_complete(iocb, iomap_dio_complete(dio), 0);
+	complete_kiocb(dio->iocb, iomap_dio_complete(dio), 0);
 }
 
 /*
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 3d113cf8908a..498a58b989cf 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -273,7 +273,7 @@ static void nfs_direct_complete(struct nfs_direct_req *dreq)
 			res = (long) dreq->count;
 			WARN_ON_ONCE(dreq->count < 0);
 		}
-		dreq->iocb->ki_complete(dreq->iocb, res, 0);
+		complete_kiocb(dreq->iocb, res, 0);
 	}
 
 	complete(&dreq->completion);
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 01820e654a21..78e7439fc4e2 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -275,7 +275,7 @@ static void ovl_aio_rw_complete(struct kiocb *iocb, long res, long res2)
 	struct kiocb *orig_iocb = aio_req->orig_iocb;
 
 	ovl_aio_cleanup_handler(aio_req);
-	orig_iocb->ki_complete(orig_iocb, res, res2);
+	complete_kiocb(orig_iocb, res, res2);
 }
 
 static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
diff --git a/fs/read_write.c b/fs/read_write.c
index bbfa9b12b15e..89151de19f77 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -363,6 +363,12 @@ SYSCALL_DEFINE5(llseek, unsigned int, fd, unsigned long, offset_high,
 }
 #endif
 
+void complete_kiocb(struct kiocb *iocb, long ret, long ret2)
+{
+	iocb->ki_complete(iocb, ret, ret2);
+}
+EXPORT_SYMBOL(complete_kiocb);
+
 int rw_verify_area(int read_write, struct file *file, const loff_t *ppos, size_t count)
 {
 	struct inode *inode;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index da90323b9f92..846135aa328d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -346,6 +346,8 @@ static inline bool is_sync_kiocb(struct kiocb *kiocb)
 	return kiocb->ki_complete == NULL;
 }
 
+void complete_kiocb(struct kiocb *kiocb, long ret, long ret2);
+
 /*
  * "descriptor" for what we're up to with a read.
  * This allows us to use the same read code yet
-- 
2.27.0


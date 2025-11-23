Return-Path: <io-uring+bounces-10742-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F1CA4C7E8A8
	for <lists+io-uring@lfdr.de>; Sun, 23 Nov 2025 23:53:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2B0CE345AED
	for <lists+io-uring@lfdr.de>; Sun, 23 Nov 2025 22:53:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6470B287506;
	Sun, 23 Nov 2025 22:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WSVzQSuZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A877E286881
	for <io-uring@vger.kernel.org>; Sun, 23 Nov 2025 22:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763938316; cv=none; b=EJFaL74SiNQwf8kgsGBhf56d9uU7q2zppnn9BdipV3mTKnrXdOZL8crXcKkZVoiVZC3dIHjAA3PAIiFtAdQn/g7wFsiaZPTqkfrMVtaUbdS5M1lHXZfyxHU7NN2aQ+dQMS/X15MI0jilqkVo+viHUIiPcf9Hni6JACViJUQkSec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763938316; c=relaxed/simple;
	bh=069Y8B4LQyZ9577N4Tpt4w72wqG515Cr2xlW9Y7a6Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuCG16uh31oBG4DBDgao5axDSBFq81vOYJrLp6nry5CzC2rfnqM59WsoEOwT9nkrpKY8xjxLQL1g+NULPrrEuoEagL8jzHWsg5G+QDM8jROacLQY5tt6S3zxOhCUYXiIB/K/lhZ2jogYsQJfpa5sr+fjwHAtpNGGUnUIN2HTpXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WSVzQSuZ; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42b38de7940so1790753f8f.3
        for <io-uring@vger.kernel.org>; Sun, 23 Nov 2025 14:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763938311; x=1764543111; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vtyRM3SiK93qfGEm4pAX9GDP/9MNGPDztBsVCrDNvOw=;
        b=WSVzQSuZFASv9x+Ew3i3SIjYdBEW2G1mYB2kSAVZh0ZeZdgeTgK2oWLXdH0EaRSdBy
         U1s5++Nt0Ly00qErV8mdmfFI7UlvgHaEZt9yfxrFZwzzkQrlBMzgpkPhMEZ9rUEnJ6P/
         OYw70cxs9KcAusMiZ/MZESMKr/itGclAM6mc6PLUEyo8dVxB3HRMiLxUdHz5zssFcfk9
         ik26ZNn/tOoetCq0oRIdS0yE2k8vHJKbtHKbeyzuDDKchgh3EIpLgwTCX2a7pE+MELfv
         6vkfp9MlmkAmSmutLvMaamjpNdxuliQB2iY1yXubcDbU/lHrMs3/3DPq1B0fWR0OmnQ5
         WTDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763938311; x=1764543111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vtyRM3SiK93qfGEm4pAX9GDP/9MNGPDztBsVCrDNvOw=;
        b=Er5i/Sg5woF19ZCUt0nS+yZDcIIqSOLzdxvVfoqps5LPTKUrKddaKrP4sBXKZZC2+k
         mV3saBJG2ZKG5is5piRqmQ7YqamCpF859YawBGwvRzUCk/NCtYDXjPBmcAyw85B7++w7
         TBoXn8KOt48mZ007vZRxfHr7HI51kCXvprRQjeg0wA19qRIlerubrshju43Zkua3fPmm
         17FAxuB4LFBpFDgxXcuMNJRR6nibY4Hgx+rqHuWPSEzQMpwXBR8PDEpUsFA7tZEXtZgK
         +PIA/yJkWTkOfxqAQ463rFSm8ccnW6vPbI5oS7GoMsgoe0dCYdtQKQMwSn/b8pl1/MCF
         OGQQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7AMgZbyiWzJkfEpAJ59LfH1lJlhidczXz9LO7sB9u2aB9Yi8uAWfwuSo5crFnh/TCCU++h9+1Nw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxEtqe+alrBJgZeK3vgy/Oq11xZxIJR2dfKI5apSyg/2Ra+X40F
	GHc/kJeG+owg5ZfYiL8Eum/YJx2oVBJBQbjjBCG3H3WTv530akJiaMX5
X-Gm-Gg: ASbGnctb7O6cbotcCrL9A+xKhboxNRvbwmqxYK+Y869ULjaIjHauw5ef1riqXOC/wGj
	aiqcsrMI5Zm8whsr3iSuK0mbf9dkOVoZvMth7ZtLjoDBhuSrC1AkVhio2rjrb8vDcwgSK6IvW/Z
	sN/134FiVkiBBbpjEWddh51XxEXFKFgiG83ZRKcAo7Z/yfrqT31AM7rBT2whTWa34HW0JMCxWfs
	7ujxZ29kUhRSrofkQUeCEW2cVAsNaB71d2RqzSinXhkE3ylqgpaMi/i6N8+mZRzcCqrB5NPICde
	F/Gd81D7DSdgdcPv4FoTFOH7MaDWG/8W7pJfz2q1WzqECobWbfZ2wYrpPzLmI97aUWCZi7UJEZ+
	IUhDNAix44fVi5rLCiUDe9Ovy27Uu8P7+wOS5vfMaMLHZp4LvwcRo3N0BZ8FTazcgvbbi7cNq5Q
	UQ/nAM+cZKgwDCpQ==
X-Google-Smtp-Source: AGHT+IGfOL+4KpbQvV0qNRfo8OovcJ37mYapE/bWdNNKsAObOGKg7LEW9kMhWjZqfvqDPLpynO+F1g==
X-Received: by 2002:a05:6000:3102:b0:429:d40e:fa40 with SMTP id ffacd0b85a97d-42cc1d0cab6mr8756848f8f.45.1763938310890;
        Sun, 23 Nov 2025 14:51:50 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fb9190sm24849064f8f.33.2025.11.23.14.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 14:51:50 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Vishal Verma <vishal1.verma@intel.com>,
	tushar.gohad@intel.com,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: [RFC v2 05/11] block: add infra to handle dmabuf tokens
Date: Sun, 23 Nov 2025 22:51:25 +0000
Message-ID: <51cddd97b31d80ec8842a88b9f3c9881419e8a7b.1763725387.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1763725387.git.asml.silence@gmail.com>
References: <cover.1763725387.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add blk-mq infrastructure to handle dmabuf tokens. There are two main
objects. The first is struct blk_mq_dma_token, which is an extension of
struct dma_token and passed in an iterator. The second is struct
blk_mq_dma_map, which keeps the actual mapping and unlike the token, can
be ejected (e.g. by move_notify) and recreated.

The token keeps an rcu protected pointer to the mapping, so when it
resolves a token into a mapping to pass it to a request, it'll do an rcu
protected lookup and get a percpu reference to the mapping.

If there is no current mapping attached to a token, it'll need to be
created by calling the driver (e.g. nvme) via a new callback. It
requires waiting, thefore can't be done for nowait requests and couldn't
happen deeper in the stack, e.g. during nvme request submission.

The structure split is needed because move_notify can request to
invalidate the dma mapping at any moment, and we need a way to
concurrently remove it and wait for the inflight requests using the
previous mapping to complete.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/Makefile                   |   1 +
 block/bdev.c                     |  14 ++
 block/blk-mq-dma-token.c         | 236 +++++++++++++++++++++++++++++++
 block/blk-mq.c                   |  20 +++
 block/fops.c                     |   1 +
 include/linux/blk-mq-dma-token.h |  60 ++++++++
 include/linux/blk-mq.h           |  21 +++
 include/linux/blkdev.h           |   3 +
 8 files changed, 356 insertions(+)
 create mode 100644 block/blk-mq-dma-token.c
 create mode 100644 include/linux/blk-mq-dma-token.h

diff --git a/block/Makefile b/block/Makefile
index c65f4da93702..0190e5aa9f00 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -36,3 +36,4 @@ obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= blk-crypto.o blk-crypto-profile.o \
 					   blk-crypto-sysfs.o
 obj-$(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)	+= blk-crypto-fallback.o
 obj-$(CONFIG_BLOCK_HOLDER_DEPRECATED)	+= holder.o
+obj-$(CONFIG_DMA_SHARED_BUFFER) += blk-mq-dma-token.o
diff --git a/block/bdev.c b/block/bdev.c
index 810707cca970..da89d20f33f3 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -28,6 +28,7 @@
 #include <linux/part_stat.h>
 #include <linux/uaccess.h>
 #include <linux/stat.h>
+#include <linux/blk-mq-dma-token.h>
 #include "../fs/internal.h"
 #include "blk.h"
 
@@ -61,6 +62,19 @@ struct block_device *file_bdev(struct file *bdev_file)
 }
 EXPORT_SYMBOL(file_bdev);
 
+struct dma_token *blkdev_dma_map(struct file *file,
+				 struct dma_token_params *params)
+{
+	struct request_queue *q = bdev_get_queue(file_bdev(file));
+
+	if (!(file->f_flags & O_DIRECT))
+		return ERR_PTR(-EINVAL);
+	if (!q->mq_ops)
+		return ERR_PTR(-EINVAL);
+
+	return blk_mq_dma_map(q, params);
+}
+
 static void bdev_write_inode(struct block_device *bdev)
 {
 	struct inode *inode = BD_INODE(bdev);
diff --git a/block/blk-mq-dma-token.c b/block/blk-mq-dma-token.c
new file mode 100644
index 000000000000..cd62c4d09422
--- /dev/null
+++ b/block/blk-mq-dma-token.c
@@ -0,0 +1,236 @@
+#include <linux/blk-mq-dma-token.h>
+#include <linux/dma-resv.h>
+
+struct blk_mq_dma_fence {
+	struct dma_fence base;
+	spinlock_t lock;
+};
+
+static const char *blk_mq_fence_drv_name(struct dma_fence *fence)
+{
+	return "blk-mq";
+}
+
+const struct dma_fence_ops blk_mq_dma_fence_ops = {
+	.get_driver_name = blk_mq_fence_drv_name,
+	.get_timeline_name = blk_mq_fence_drv_name,
+};
+
+static void blk_mq_dma_token_free(struct blk_mq_dma_token *token)
+{
+	token->q->mq_ops->clean_dma_token(token->q, token);
+	dma_buf_put(token->dmabuf);
+	kfree(token);
+}
+
+static inline void blk_mq_dma_token_put(struct blk_mq_dma_token *token)
+{
+	if (refcount_dec_and_test(&token->refs))
+		blk_mq_dma_token_free(token);
+}
+
+static void blk_mq_dma_mapping_free(struct blk_mq_dma_map *map)
+{
+	struct blk_mq_dma_token *token = map->token;
+
+	if (map->sgt)
+		token->q->mq_ops->dma_unmap(token->q, map);
+
+	dma_fence_put(&map->fence->base);
+	percpu_ref_exit(&map->refs);
+	kfree(map);
+	blk_mq_dma_token_put(token);
+}
+
+static void blk_mq_dma_map_work_free(struct work_struct *work)
+{
+	struct blk_mq_dma_map *map = container_of(work, struct blk_mq_dma_map,
+						free_work);
+
+	dma_fence_signal(&map->fence->base);
+	blk_mq_dma_mapping_free(map);
+}
+
+static void blk_mq_dma_map_refs_free(struct percpu_ref *ref)
+{
+	struct blk_mq_dma_map *map = container_of(ref, struct blk_mq_dma_map, refs);
+
+	INIT_WORK(&map->free_work, blk_mq_dma_map_work_free);
+	queue_work(system_wq, &map->free_work);
+}
+
+static struct blk_mq_dma_map *blk_mq_alloc_dma_mapping(struct blk_mq_dma_token *token)
+{
+	struct blk_mq_dma_fence *fence = NULL;
+	struct blk_mq_dma_map *map;
+	int ret = -ENOMEM;
+
+	map = kzalloc(sizeof(*map), GFP_KERNEL);
+	if (!map)
+		return ERR_PTR(-ENOMEM);
+
+	fence = kzalloc(sizeof(*fence), GFP_KERNEL);
+	if (!fence)
+		goto err;
+
+	ret = percpu_ref_init(&map->refs, blk_mq_dma_map_refs_free, 0,
+			      GFP_KERNEL);
+	if (ret)
+		goto err;
+
+	dma_fence_init(&fence->base, &blk_mq_dma_fence_ops, &fence->lock,
+			token->fence_ctx, atomic_inc_return(&token->fence_seq));
+	spin_lock_init(&fence->lock);
+	map->fence = fence;
+	map->token = token;
+	refcount_inc(&token->refs);
+	return map;
+err:
+	kfree(map);
+	kfree(fence);
+	return ERR_PTR(ret);
+}
+
+static inline
+struct blk_mq_dma_map *blk_mq_get_token_map(struct blk_mq_dma_token *token)
+{
+	struct blk_mq_dma_map *map;
+
+	guard(rcu)();
+
+	map = rcu_dereference(token->map);
+	if (unlikely(!map || !percpu_ref_tryget_live_rcu(&map->refs)))
+		return NULL;
+	return map;
+}
+
+static struct blk_mq_dma_map *
+blk_mq_create_dma_map(struct blk_mq_dma_token *token)
+{
+	struct dma_buf *dmabuf = token->dmabuf;
+	struct blk_mq_dma_map *map;
+	long ret;
+
+	guard(mutex)(&token->mapping_lock);
+
+	map = blk_mq_get_token_map(token);
+	if (map)
+		return map;
+
+	map = blk_mq_alloc_dma_mapping(token);
+	if (IS_ERR(map))
+		return NULL;
+
+	dma_resv_lock(dmabuf->resv, NULL);
+	ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_BOOKKEEP,
+				    true, MAX_SCHEDULE_TIMEOUT);
+	ret = ret ? ret : -ETIME;
+	if (ret > 0)
+		ret = token->q->mq_ops->dma_map(token->q, map);
+	dma_resv_unlock(dmabuf->resv);
+
+	if (ret)
+		return ERR_PTR(ret);
+
+	percpu_ref_get(&map->refs);
+	rcu_assign_pointer(token->map, map);
+	return map;
+}
+
+static void blk_mq_dma_map_remove(struct blk_mq_dma_token *token)
+{
+	struct dma_buf *dmabuf = token->dmabuf;
+	struct blk_mq_dma_map *map;
+	int ret;
+
+	dma_resv_assert_held(dmabuf->resv);
+
+	ret = dma_resv_reserve_fences(dmabuf->resv, 1);
+	if (WARN_ON_ONCE(ret))
+		return;
+
+	map = rcu_dereference_protected(token->map,
+					dma_resv_held(dmabuf->resv));
+	if (!map)
+		return;
+	rcu_assign_pointer(token->map, NULL);
+
+	dma_resv_add_fence(dmabuf->resv, &map->fence->base,
+			   DMA_RESV_USAGE_KERNEL);
+	percpu_ref_kill(&map->refs);
+}
+
+blk_status_t blk_rq_assign_dma_map(struct request *rq,
+				   struct blk_mq_dma_token *token)
+{
+	struct blk_mq_dma_map *map;
+
+	map = blk_mq_get_token_map(token);
+	if (map)
+		goto complete;
+
+	if (rq->cmd_flags & REQ_NOWAIT)
+		return BLK_STS_AGAIN;
+
+	map = blk_mq_create_dma_map(token);
+	if (IS_ERR(map))
+		return BLK_STS_RESOURCE;
+complete:
+	rq->dma_map = map;
+	return BLK_STS_OK;
+}
+
+void blk_mq_dma_map_move_notify(struct blk_mq_dma_token *token)
+{
+	blk_mq_dma_map_remove(token);
+}
+
+static void blk_mq_release_dma_mapping(struct dma_token *base_token)
+{
+	struct blk_mq_dma_token *token = dma_token_to_blk_mq(base_token);
+	struct dma_buf *dmabuf = token->dmabuf;
+
+	dma_resv_lock(dmabuf->resv, NULL);
+	blk_mq_dma_map_remove(token);
+	dma_resv_unlock(dmabuf->resv);
+
+	blk_mq_dma_token_put(token);
+}
+
+struct dma_token *blk_mq_dma_map(struct request_queue *q,
+				  struct dma_token_params *params)
+{
+	struct dma_buf *dmabuf = params->dmabuf;
+	struct blk_mq_dma_token *token;
+	int ret;
+
+	if (!q->mq_ops->dma_map || !q->mq_ops->dma_unmap ||
+	    !q->mq_ops->init_dma_token || !q->mq_ops->clean_dma_token)
+		return ERR_PTR(-EINVAL);
+
+	token = kzalloc(sizeof(*token), GFP_KERNEL);
+	if (!token)
+		return ERR_PTR(-ENOMEM);
+
+	get_dma_buf(dmabuf);
+	token->fence_ctx = dma_fence_context_alloc(1);
+	token->dmabuf = dmabuf;
+	token->dir = params->dir;
+	token->base.release = blk_mq_release_dma_mapping;
+	token->q = q;
+	refcount_set(&token->refs, 1);
+	mutex_init(&token->mapping_lock);
+
+	if (!blk_get_queue(q)) {
+		kfree(token);
+		return ERR_PTR(-EFAULT);
+	}
+
+	ret = token->q->mq_ops->init_dma_token(token->q, token);
+	if (ret) {
+		kfree(token);
+		blk_put_queue(q);
+		return ERR_PTR(ret);
+	}
+	return &token->base;
+}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index f2650c97a75e..1ff3a7e3191b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -29,6 +29,7 @@
 #include <linux/blk-crypto.h>
 #include <linux/part_stat.h>
 #include <linux/sched/isolation.h>
+#include <linux/blk-mq-dma-token.h>
 
 #include <trace/events/block.h>
 
@@ -439,6 +440,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 	rq->nr_integrity_segments = 0;
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
+	rq->dma_map = NULL;
 
 	blk_crypto_rq_set_defaults(rq);
 	INIT_LIST_HEAD(&rq->queuelist);
@@ -794,6 +796,7 @@ static void __blk_mq_free_request(struct request *rq)
 	blk_pm_mark_last_busy(rq);
 	rq->mq_hctx = NULL;
 
+	blk_rq_drop_dma_map(rq);
 	if (rq->tag != BLK_MQ_NO_TAG) {
 		blk_mq_dec_active_requests(hctx);
 		blk_mq_put_tag(hctx->tags, ctx, rq->tag);
@@ -3214,6 +3217,23 @@ void blk_mq_submit_bio(struct bio *bio)
 
 	blk_mq_bio_to_request(rq, bio, nr_segs);
 
+	if (bio_flagged(bio, BIO_DMA_TOKEN)) {
+		struct blk_mq_dma_token *token;
+		blk_status_t ret;
+
+		token = dma_token_to_blk_mq(bio->dma_token);
+		ret = blk_rq_assign_dma_map(rq, token);
+		if (ret) {
+			if (ret == BLK_STS_AGAIN) {
+				bio_wouldblock_error(bio);
+			} else {
+				bio->bi_status = BLK_STS_RESOURCE;
+				bio_endio(bio);
+			}
+			goto queue_exit;
+		}
+	}
+
 	ret = blk_crypto_rq_get_keyslot(rq);
 	if (ret != BLK_STS_OK) {
 		bio->bi_status = ret;
diff --git a/block/fops.c b/block/fops.c
index 41f8795874a9..ac52fe1a4b8d 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -973,6 +973,7 @@ const struct file_operations def_blk_fops = {
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
 	.fop_flags	= FOP_BUFFER_RASYNC,
+	.dma_map	= blkdev_dma_map,
 };
 
 static __init int blkdev_init(void)
diff --git a/include/linux/blk-mq-dma-token.h b/include/linux/blk-mq-dma-token.h
new file mode 100644
index 000000000000..4a8d84addc06
--- /dev/null
+++ b/include/linux/blk-mq-dma-token.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef BLK_MQ_DMA_TOKEN_H
+#define BLK_MQ_DMA_TOKEN_H
+
+#include <linux/blk-mq.h>
+#include <linux/dma_token.h>
+#include <linux/percpu-refcount.h>
+
+struct blk_mq_dma_token;
+struct blk_mq_dma_fence;
+
+struct blk_mq_dma_map {
+	void				*private;
+
+	struct percpu_ref		refs;
+	struct sg_table			*sgt;
+	struct blk_mq_dma_token		*token;
+	struct blk_mq_dma_fence		*fence;
+	struct work_struct		free_work;
+};
+
+struct blk_mq_dma_token {
+	struct dma_token		base;
+	enum dma_data_direction		dir;
+
+	void				*private;
+
+	struct dma_buf			*dmabuf;
+	struct blk_mq_dma_map __rcu	*map;
+	struct request_queue		*q;
+
+	struct mutex			mapping_lock;
+	refcount_t			refs;
+
+	atomic_t			fence_seq;
+	u64				fence_ctx;
+};
+
+static inline
+struct blk_mq_dma_token *dma_token_to_blk_mq(struct dma_token *token)
+{
+	return container_of(token, struct blk_mq_dma_token, base);
+}
+
+blk_status_t blk_rq_assign_dma_map(struct request *req,
+				   struct blk_mq_dma_token *token);
+
+static inline void blk_rq_drop_dma_map(struct request *rq)
+{
+	if (rq->dma_map) {
+		percpu_ref_put(&rq->dma_map->refs);
+		rq->dma_map = NULL;
+	}
+}
+
+void blk_mq_dma_map_move_notify(struct blk_mq_dma_token *token);
+struct dma_token *blk_mq_dma_map(struct request_queue *q,
+				 struct dma_token_params *params);
+
+#endif /* BLK_MQ_DMA_TOKEN_H */
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index b54506b3b76d..4745d1e183f2 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -94,6 +94,9 @@ enum mq_rq_state {
 	MQ_RQ_COMPLETE		= 2,
 };
 
+struct blk_mq_dma_map;
+struct blk_mq_dma_token;
+
 /*
  * Try to put the fields that are referenced together in the same cacheline.
  *
@@ -170,6 +173,8 @@ struct request {
 
 	unsigned long deadline;
 
+	struct blk_mq_dma_map	*dma_map;
+
 	/*
 	 * The hash is used inside the scheduler, and killed once the
 	 * request reaches the dispatch list. The ipi_list is only used
@@ -675,6 +680,21 @@ struct blk_mq_ops {
 	 */
 	void (*map_queues)(struct blk_mq_tag_set *set);
 
+	/**
+	 * @map_dmabuf: Allows drivers to pre-map a dmabuf. The resulting driver
+	 * specific mapping will be wrapped into dma_token and passed to the
+	 * read / write path in an iterator.
+	 */
+	int (*dma_map)(struct request_queue *q, struct blk_mq_dma_map *);
+	void (*dma_unmap)(struct request_queue *q, struct blk_mq_dma_map *);
+	int (*init_dma_token)(struct request_queue *q,
+			      struct blk_mq_dma_token *token);
+	void (*clean_dma_token)(struct request_queue *q,
+				struct blk_mq_dma_token *token);
+
+	struct dma_buf_attachment *(*dma_attach)(struct request_queue *q,
+					struct dma_token_params *params);
+
 #ifdef CONFIG_BLK_DEBUG_FS
 	/**
 	 * @show_rq: Used by the debugfs implementation to show driver-specific
@@ -946,6 +966,7 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 void blk_mq_tagset_wait_completed_request(struct blk_mq_tag_set *tagset);
 void blk_mq_freeze_queue_nomemsave(struct request_queue *q);
 void blk_mq_unfreeze_queue_nomemrestore(struct request_queue *q);
+
 static inline unsigned int __must_check
 blk_mq_freeze_queue(struct request_queue *q)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index cb4ba09959ee..dec75348f8dc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1777,6 +1777,9 @@ struct block_device *file_bdev(struct file *bdev_file);
 bool disk_live(struct gendisk *disk);
 unsigned int block_size(struct block_device *bdev);
 
+struct dma_token *blkdev_dma_map(struct file *file,
+				 struct dma_token_params *params);
+
 #ifdef CONFIG_BLOCK
 void invalidate_bdev(struct block_device *bdev);
 int sync_blockdev(struct block_device *bdev);
-- 
2.52.0



Return-Path: <io-uring+bounces-11858-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aEUNHT6DcGktYAAAu9opvQ
	(envelope-from <io-uring+bounces-11858-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 08:41:50 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 395D052F07
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 08:41:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3B2503818D7
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 07:41:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF3424611E2;
	Wed, 21 Jan 2026 07:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Jk/K/kpm"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5F245BD69
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 07:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768981302; cv=none; b=pXZn1myW3uOiA7OfiE4/Rl+gA8jia3WNevkBwx7L37qSAposqBXNug8BOEFxcxO09g4cugZPgE3hvVXKXzrKZzhS4XjtzsqM04jOu+TqUdB//F7ce0AypUGMIZjPwrJ0lzIgRFWOtsn6jXZChfoKnjbGG86wtQ2cZKk3IO4kL7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768981302; c=relaxed/simple;
	bh=dl1WZV4KD/vyYKQALAbeHi6Js7oLVNZoGt7pdDHb/Uk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=JDpuxlbEW7Gi0rdcPXj4n5JMMk1/+i89SGTHgZRtuOrMIOpRbF0qbkhNRuClEAwXRjRgzpiKSlsCnnMfx4gqoHYNDZyzfXqZF5SNDmzzHrrReSPVkivG2riEZKOimKMJoNxQAA8q6fwmsM660CMDFL1AMPztdMFQ+/BGEaXcXZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Jk/K/kpm; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260121074137epoutp03921f9a7d092f8c376964deea9181dcb7~Mrx4ppPz10048200482epoutp03i
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 07:41:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260121074137epoutp03921f9a7d092f8c376964deea9181dcb7~Mrx4ppPz10048200482epoutp03i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768981297;
	bh=cCLSnw+7Sw2d8mXGXmlBWX5LFNtQ5J3qbnlxpAfMklg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Jk/K/kpm1DUt4MPqr+7ZSbYYUGx/y7d63dV9JSaX6fDiCNrRMSGqOvbYJyRHg0zPg
	 t6ZdGvEtdSBU5c2vZ1cM8qc0W/XcEJMnOJ6a/FrPm+USF+VgQsGpOspY/3hGHOYSXN
	 S/hrCGEGNVaHhxGLLbl8PiRtdsEoQHvDYvbpDJs8=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260121074137epcas5p161bfa789c85f6b5a0593e02ce69a4f1b~Mrx4MTvvC0369103691epcas5p1B;
	Wed, 21 Jan 2026 07:41:37 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.95]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dwx341r3vz6B9m5; Wed, 21 Jan
	2026 07:41:36 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260121074135epcas5p2eeb621d6acc9b4b73e6d45f5a40c078d~Mrx2oy7q42105521055epcas5p2j;
	Wed, 21 Jan 2026 07:41:35 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260121074133epsmtip2bc265584191911a9589cfd40524cbe39~Mrx0nhTOy2434124341epsmtip2t;
	Wed, 21 Jan 2026 07:41:33 +0000 (GMT)
Date: Wed, 21 Jan 2026 13:07:24 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org, Keith Busch
	<kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig
	<hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [RFC v2 05/11] block: add infra to handle dmabuf tokens
Message-ID: <20260121073724.dja6wyqyf5apkdcx@green245.gost>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <51cddd97b31d80ec8842a88b9f3c9881419e8a7b.1763725387.git.asml.silence@gmail.com>
X-CMS-MailID: 20260121074135epcas5p2eeb621d6acc9b4b73e6d45f5a40c078d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_113bff_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260121074135epcas5p2eeb621d6acc9b4b73e6d45f5a40c078d
References: <cover.1763725387.git.asml.silence@gmail.com>
	<51cddd97b31d80ec8842a88b9f3c9881419e8a7b.1763725387.git.asml.silence@gmail.com>
	<CGME20260121074135epcas5p2eeb621d6acc9b4b73e6d45f5a40c078d@epcas5p2.samsung.com>
X-Spamd-Result: default: False [0.54 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	CTYPE_MIXED_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[samsung.com:s=mail20170921];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11858-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+,1:+,2:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[samsung.com,none];
	DKIM_TRACE(0.00)[samsung.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[samsung.com:dkim,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nj.shetty@samsung.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 395D052F07
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

------dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_113bff_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/11/25 10:51PM, Pavel Begunkov wrote:
>Add blk-mq infrastructure to handle dmabuf tokens. There are two main
>objects. The first is struct blk_mq_dma_token, which is an extension of
>struct dma_token and passed in an iterator. The second is struct
>blk_mq_dma_map, which keeps the actual mapping and unlike the token, can
>be ejected (e.g. by move_notify) and recreated.
>
>The token keeps an rcu protected pointer to the mapping, so when it
>resolves a token into a mapping to pass it to a request, it'll do an rcu
>protected lookup and get a percpu reference to the mapping.
>
>If there is no current mapping attached to a token, it'll need to be
>created by calling the driver (e.g. nvme) via a new callback. It
>requires waiting, thefore can't be done for nowait requests and couldn't
>happen deeper in the stack, e.g. during nvme request submission.
>
>The structure split is needed because move_notify can request to
>invalidate the dma mapping at any moment, and we need a way to
>concurrently remove it and wait for the inflight requests using the
>previous mapping to complete.
>
>Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>---
> block/Makefile                   |   1 +
> block/bdev.c                     |  14 ++
> block/blk-mq-dma-token.c         | 236 +++++++++++++++++++++++++++++++
> block/blk-mq.c                   |  20 +++
> block/fops.c                     |   1 +
> include/linux/blk-mq-dma-token.h |  60 ++++++++
> include/linux/blk-mq.h           |  21 +++
> include/linux/blkdev.h           |   3 +
> 8 files changed, 356 insertions(+)
> create mode 100644 block/blk-mq-dma-token.c
> create mode 100644 include/linux/blk-mq-dma-token.h
>
>diff --git a/block/Makefile b/block/Makefile
>index c65f4da93702..0190e5aa9f00 100644
>--- a/block/Makefile
>+++ b/block/Makefile
>@@ -36,3 +36,4 @@ obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= blk-crypto.o blk-crypto-profile.o \
> 					   blk-crypto-sysfs.o
> obj-$(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)	+= blk-crypto-fallback.o
> obj-$(CONFIG_BLOCK_HOLDER_DEPRECATED)	+= holder.o
>+obj-$(CONFIG_DMA_SHARED_BUFFER) += blk-mq-dma-token.o
>diff --git a/block/bdev.c b/block/bdev.c
>index 810707cca970..da89d20f33f3 100644
>--- a/block/bdev.c
>+++ b/block/bdev.c
>@@ -28,6 +28,7 @@
> #include <linux/part_stat.h>
> #include <linux/uaccess.h>
> #include <linux/stat.h>
>+#include <linux/blk-mq-dma-token.h>
> #include "../fs/internal.h"
> #include "blk.h"
>
>@@ -61,6 +62,19 @@ struct block_device *file_bdev(struct file *bdev_file)
> }
> EXPORT_SYMBOL(file_bdev);
>
>+struct dma_token *blkdev_dma_map(struct file *file,
>+				 struct dma_token_params *params)
>+{
>+	struct request_queue *q = bdev_get_queue(file_bdev(file));
>+
>+	if (!(file->f_flags & O_DIRECT))
>+		return ERR_PTR(-EINVAL);
>+	if (!q->mq_ops)
>+		return ERR_PTR(-EINVAL);
>+
>+	return blk_mq_dma_map(q, params);
>+}
>+
> static void bdev_write_inode(struct block_device *bdev)
> {
> 	struct inode *inode = BD_INODE(bdev);
>diff --git a/block/blk-mq-dma-token.c b/block/blk-mq-dma-token.c
>new file mode 100644
>index 000000000000..cd62c4d09422
>--- /dev/null
>+++ b/block/blk-mq-dma-token.c
>@@ -0,0 +1,236 @@
>+#include <linux/blk-mq-dma-token.h>
>+#include <linux/dma-resv.h>
>+
>+struct blk_mq_dma_fence {
>+	struct dma_fence base;
>+	spinlock_t lock;
>+};
>+
>+static const char *blk_mq_fence_drv_name(struct dma_fence *fence)
>+{
>+	return "blk-mq";
>+}
>+
>+const struct dma_fence_ops blk_mq_dma_fence_ops = {
>+	.get_driver_name = blk_mq_fence_drv_name,
>+	.get_timeline_name = blk_mq_fence_drv_name,
>+};
>+
>+static void blk_mq_dma_token_free(struct blk_mq_dma_token *token)
>+{
>+	token->q->mq_ops->clean_dma_token(token->q, token);
>+	dma_buf_put(token->dmabuf);
>+	kfree(token);
>+}
>+
>+static inline void blk_mq_dma_token_put(struct blk_mq_dma_token *token)
>+{
>+	if (refcount_dec_and_test(&token->refs))
>+		blk_mq_dma_token_free(token);
>+}
>+
>+static void blk_mq_dma_mapping_free(struct blk_mq_dma_map *map)
>+{
>+	struct blk_mq_dma_token *token = map->token;
>+
>+	if (map->sgt)
>+		token->q->mq_ops->dma_unmap(token->q, map);
>+
>+	dma_fence_put(&map->fence->base);
>+	percpu_ref_exit(&map->refs);
>+	kfree(map);
>+	blk_mq_dma_token_put(token);
>+}
>+
>+static void blk_mq_dma_map_work_free(struct work_struct *work)
>+{
>+	struct blk_mq_dma_map *map = container_of(work, struct blk_mq_dma_map,
>+						free_work);
>+
>+	dma_fence_signal(&map->fence->base);
>+	blk_mq_dma_mapping_free(map);
>+}
>+
>+static void blk_mq_dma_map_refs_free(struct percpu_ref *ref)
>+{
>+	struct blk_mq_dma_map *map = container_of(ref, struct blk_mq_dma_map, refs);
>+
>+	INIT_WORK(&map->free_work, blk_mq_dma_map_work_free);
>+	queue_work(system_wq, &map->free_work);
>+}
>+
>+static struct blk_mq_dma_map *blk_mq_alloc_dma_mapping(struct blk_mq_dma_token *token)
>+{
>+	struct blk_mq_dma_fence *fence = NULL;
>+	struct blk_mq_dma_map *map;
>+	int ret = -ENOMEM;
>+
>+	map = kzalloc(sizeof(*map), GFP_KERNEL);
>+	if (!map)
>+		return ERR_PTR(-ENOMEM);
>+
>+	fence = kzalloc(sizeof(*fence), GFP_KERNEL);
>+	if (!fence)
>+		goto err;
>+
>+	ret = percpu_ref_init(&map->refs, blk_mq_dma_map_refs_free, 0,
>+			      GFP_KERNEL);
>+	if (ret)
>+		goto err;
>+
>+	dma_fence_init(&fence->base, &blk_mq_dma_fence_ops, &fence->lock,
>+			token->fence_ctx, atomic_inc_return(&token->fence_seq));
>+	spin_lock_init(&fence->lock);
>+	map->fence = fence;
>+	map->token = token;
>+	refcount_inc(&token->refs);
>+	return map;
>+err:
>+	kfree(map);
>+	kfree(fence);
>+	return ERR_PTR(ret);
>+}
>+
>+static inline
>+struct blk_mq_dma_map *blk_mq_get_token_map(struct blk_mq_dma_token *token)
>+{
>+	struct blk_mq_dma_map *map;
>+
>+	guard(rcu)();
>+
>+	map = rcu_dereference(token->map);
>+	if (unlikely(!map || !percpu_ref_tryget_live_rcu(&map->refs)))
>+		return NULL;
>+	return map;
>+}
>+
>+static struct blk_mq_dma_map *
>+blk_mq_create_dma_map(struct blk_mq_dma_token *token)
>+{
>+	struct dma_buf *dmabuf = token->dmabuf;
>+	struct blk_mq_dma_map *map;
>+	long ret;
>+
>+	guard(mutex)(&token->mapping_lock);
>+
>+	map = blk_mq_get_token_map(token);
>+	if (map)
>+		return map;
>+
>+	map = blk_mq_alloc_dma_mapping(token);
>+	if (IS_ERR(map))
>+		return NULL;
>+
>+	dma_resv_lock(dmabuf->resv, NULL);
>+	ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_BOOKKEEP,
>+				    true, MAX_SCHEDULE_TIMEOUT);
>+	ret = ret ? ret : -ETIME;
>+	if (ret > 0)
>+		ret = token->q->mq_ops->dma_map(token->q, map);
>+	dma_resv_unlock(dmabuf->resv);
>+
>+	if (ret)
>+		return ERR_PTR(ret);
>+
>+	percpu_ref_get(&map->refs);
>+	rcu_assign_pointer(token->map, map);
>+	return map;
>+}
>+
>+static void blk_mq_dma_map_remove(struct blk_mq_dma_token *token)
>+{
>+	struct dma_buf *dmabuf = token->dmabuf;
>+	struct blk_mq_dma_map *map;
>+	int ret;
>+
>+	dma_resv_assert_held(dmabuf->resv);
>+
>+	ret = dma_resv_reserve_fences(dmabuf->resv, 1);
>+	if (WARN_ON_ONCE(ret))
>+		return;
>+
>+	map = rcu_dereference_protected(token->map,
>+					dma_resv_held(dmabuf->resv));
>+	if (!map)
>+		return;
>+	rcu_assign_pointer(token->map, NULL);
>+
>+	dma_resv_add_fence(dmabuf->resv, &map->fence->base,
>+			   DMA_RESV_USAGE_KERNEL);
>+	percpu_ref_kill(&map->refs);
>+}
>+
>+blk_status_t blk_rq_assign_dma_map(struct request *rq,
>+				   struct blk_mq_dma_token *token)
>+{
>+	struct blk_mq_dma_map *map;
>+
>+	map = blk_mq_get_token_map(token);
>+	if (map)
>+		goto complete;
>+
>+	if (rq->cmd_flags & REQ_NOWAIT)
>+		return BLK_STS_AGAIN;
>+
>+	map = blk_mq_create_dma_map(token);
>+	if (IS_ERR(map))
>+		return BLK_STS_RESOURCE;
>+complete:
>+	rq->dma_map = map;
>+	return BLK_STS_OK;
>+}
>+
>+void blk_mq_dma_map_move_notify(struct blk_mq_dma_token *token)
>+{
>+	blk_mq_dma_map_remove(token);
>+}
>+
>+static void blk_mq_release_dma_mapping(struct dma_token *base_token)
>+{
>+	struct blk_mq_dma_token *token = dma_token_to_blk_mq(base_token);
>+	struct dma_buf *dmabuf = token->dmabuf;
>+
>+	dma_resv_lock(dmabuf->resv, NULL);
>+	blk_mq_dma_map_remove(token);
>+	dma_resv_unlock(dmabuf->resv);
>+
>+	blk_mq_dma_token_put(token);
>+}
>+
>+struct dma_token *blk_mq_dma_map(struct request_queue *q,
>+				  struct dma_token_params *params)
>+{
>+	struct dma_buf *dmabuf = params->dmabuf;
>+	struct blk_mq_dma_token *token;
>+	int ret;
>+
>+	if (!q->mq_ops->dma_map || !q->mq_ops->dma_unmap ||
>+	    !q->mq_ops->init_dma_token || !q->mq_ops->clean_dma_token)
>+		return ERR_PTR(-EINVAL);
>+
>+	token = kzalloc(sizeof(*token), GFP_KERNEL);
>+	if (!token)
>+		return ERR_PTR(-ENOMEM);
>+
>+	get_dma_buf(dmabuf);
>+	token->fence_ctx = dma_fence_context_alloc(1);
>+	token->dmabuf = dmabuf;
>+	token->dir = params->dir;
>+	token->base.release = blk_mq_release_dma_mapping;
>+	token->q = q;
>+	refcount_set(&token->refs, 1);
>+	mutex_init(&token->mapping_lock);
>+
>+	if (!blk_get_queue(q)) {
>+		kfree(token);
>+		return ERR_PTR(-EFAULT);
>+	}
>+
>+	ret = token->q->mq_ops->init_dma_token(token->q, token);
>+	if (ret) {
>+		kfree(token);
>+		blk_put_queue(q);
>+		return ERR_PTR(ret);
>+	}
>+	return &token->base;
>+}
>diff --git a/block/blk-mq.c b/block/blk-mq.c
>index f2650c97a75e..1ff3a7e3191b 100644
>--- a/block/blk-mq.c
>+++ b/block/blk-mq.c
>@@ -29,6 +29,7 @@
> #include <linux/blk-crypto.h>
> #include <linux/part_stat.h>
> #include <linux/sched/isolation.h>
>+#include <linux/blk-mq-dma-token.h>
>
> #include <trace/events/block.h>
>
>@@ -439,6 +440,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
> 	rq->nr_integrity_segments = 0;
> 	rq->end_io = NULL;
> 	rq->end_io_data = NULL;
>+	rq->dma_map = NULL;
>
> 	blk_crypto_rq_set_defaults(rq);
> 	INIT_LIST_HEAD(&rq->queuelist);
>@@ -794,6 +796,7 @@ static void __blk_mq_free_request(struct request *rq)
> 	blk_pm_mark_last_busy(rq);
> 	rq->mq_hctx = NULL;
>
>+	blk_rq_drop_dma_map(rq);
blk_rq_drop_dma_map(rq), needs to be added in blk_mq_end_request_batch
as well[1], otherwise I am seeing we leave with increased reference
count in dma-buf exporter side.

Thanks,
Nitesh

[1]
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1214,6 +1214,7 @@ void blk_mq_end_request_batch(struct io_comp_batch *iob)

                  blk_crypto_free_request(rq);
                  blk_pm_mark_last_busy(rq);
+               blk_rq_drop_dma_map(rq);

------dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_113bff_
Content-Type: text/plain; charset="utf-8"


------dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_113bff_--


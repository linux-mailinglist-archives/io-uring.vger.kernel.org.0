Return-Path: <io-uring+bounces-4824-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE9D89D2589
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 13:20:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D9451F24174
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 12:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73DBA1CF5E9;
	Tue, 19 Nov 2024 12:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yo8LSWgG"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EF81CFEA9;
	Tue, 19 Nov 2024 12:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732018629; cv=none; b=K7QUQzrBHhA7HDXGEZK4re22cfAG0zkbepp8FfvMNiWCo3fi3KqgyOv+M5l+GS15665pCKw7UFMRL5BInnJWfj/ByzvtcCCiWoPe6aP6rqomb5x9kRXMIOdorb7gGP0q0gXRqzw/LahqDS5wEzhONX2e+VXtZTWy5MmA5TKC7qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732018629; c=relaxed/simple;
	bh=0BkYocf6nlva5SOD91SKI1D9GWHp4nOP7oE/1rBzWII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEhEuzwzRohKHtXk4QfdVDkN2GFnSuXjI+42K4Nm7gZcILaZgBP+uKUYAMpWZUmb8jUWM++xxabxTDd7WWD70hCYmj1n3pIaFbXSyDQ6DtSKxKB8f+J3ywWcpR/P3aLly9TcOmZvuBcu47K0U0fF/dJQOYYreyglXsScNa5t2p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yo8LSWgG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QEFSXa9pfZuyC335Q9FZkYypCzaBxC18nhKs2Bn5gTU=; b=yo8LSWgGsJjg6bOWvHYI8Tz+iY
	/7ZYBWC0ba8f0srndQWhluBgtb093d4O/vpEp0ldGZ+W7sguDiVZJED56tWGlAP+C4DFnuTQCw0Sc
	uD9A4r+VjE5l8HvIGMlXKQsr7nfGzf9DUhby7VCQwiID8qVT0z1qrC9oy3DEm4QlgrDnB6UO348PU
	hLqmNUAZAF+fP74rDlokBx5xoRTu6LXxL99DHklGx53YbH+YUomNT36h88ri1/hs3RsGmY+5z5+dq
	wdgXKqO2blKYh94BYCMgRWza3KBi4TFSpjph3mFFxnlUVTe7Mc6UYySFIXq5sxrbyEA9grQ+gRzYH
	cEHMLsiQ==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDNAG-0000000CJAq-3xFC;
	Tue, 19 Nov 2024 12:17:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Hui Qi <hui81.qi@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jan Kara <jack@suse.cz>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH 10/15] nvme: store the endurance group id in struct nvme_ns_head
Date: Tue, 19 Nov 2024 13:16:24 +0100
Message-ID: <20241119121632.1225556-11-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241119121632.1225556-1-hch@lst.de>
References: <20241119121632.1225556-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The FDP code needs this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c | 4 ++++
 drivers/nvme/host/nvme.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 1a8d32a4a5c3..d194b36b08ac 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -38,6 +38,7 @@ struct nvme_ns_info {
 	u32 nsid;
 	__le32 anagrpid;
 	u8 pi_offset;
+	u16 endgid;
 	bool is_shared;
 	bool is_readonly;
 	bool is_ready;
@@ -1600,6 +1601,7 @@ static int nvme_ns_info_from_identify(struct nvme_ctrl *ctrl,
 	}
 
 	info->anagrpid = id->anagrpid;
+	info->endgid = le16_to_cpu(id->endgid);
 	info->is_shared = id->nmic & NVME_NS_NMIC_SHARED;
 	info->is_readonly = id->nsattr & NVME_NS_ATTR_RO;
 	info->is_ready = true;
@@ -1638,6 +1640,7 @@ static int nvme_ns_info_from_id_cs_indep(struct nvme_ctrl *ctrl,
 	ret = nvme_submit_sync_cmd(ctrl->admin_q, &c, id, sizeof(*id));
 	if (!ret) {
 		info->anagrpid = id->anagrpid;
+		info->endgid = le16_to_cpu(id->endgid);
 		info->is_shared = id->nmic & NVME_NS_NMIC_SHARED;
 		info->is_readonly = id->nsattr & NVME_NS_ATTR_RO;
 		info->is_ready = id->nstat & NVME_NSTAT_NRDY;
@@ -3644,6 +3647,7 @@ static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
 	head->ids = info->ids;
 	head->shared = info->is_shared;
 	head->rotational = info->is_rotational;
+	head->endgid = info->endgid;
 	ratelimit_state_init(&head->rs_nuse, 5 * HZ, 1);
 	ratelimit_set_flags(&head->rs_nuse, RATELIMIT_MSG_ON_RELEASE);
 	kref_init(&head->ref);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 900719c4c70c..9b916a904f00 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -491,6 +491,8 @@ struct nvme_ns_head {
 	struct device		cdev_device;
 
 	struct gendisk		*disk;
+
+	u16			endgid;
 #ifdef CONFIG_NVME_MULTIPATH
 	struct bio_list		requeue_list;
 	spinlock_t		requeue_lock;
-- 
2.45.2



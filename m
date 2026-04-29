Return-Path: <io-uring+bounces-13178-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gOJsITwl8mm/oQEAu9opvQ
	(envelope-from <io-uring+bounces-13178-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:35:24 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C10649706D
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2051430A7ED6
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 15:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FF7E37F00C;
	Wed, 29 Apr 2026 15:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EevxMA7L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA5637F001
	for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 15:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476414; cv=none; b=aJqI4s5b4LVc7iswdw0ktaCXalkrDgkFXkbepQYWQs/u8WDr3QFnU63lYZp1/RwaehQHaBO4bSvqTO7a26ymcjXie3ZQCGBg6SsJuMtsWdxP0xWEzXv0uUHjMwUis1Y64RpWrnXkPeSSIqn4gy3Ta1NM7Zq/VnCb4EWapVRnMRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476414; c=relaxed/simple;
	bh=DL12ZWqeJwgmWM4073U0nNO7Rud8B90RO8c36PxK6lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Us8Wfz30026FtqkmE3rj5jsS/5J4jttx+3TpcY89KK48FdId0se0l9fTHi6ccKicP+oN17Aa7luEDqIm2fcRCv9TzIBxzBB/fxs7UsYPBxmoJME9h0NHbif2kEj7KbrCnhaHZW+Gp+eAGWo1Y6/DWondG70Dwn4QX1iy7aTlG1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EevxMA7L; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43d0deb7ad5so10405008f8f.2
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 08:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777476409; x=1778081209; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pdajlfqb0Mkqw7FfTkWcBSlkNtUxKMEiU4sOjeajLqA=;
        b=EevxMA7LPtKpXQoHdd237w6Vc8pJbzdxm6cjW6PNSoDJlLosPzx0qIFsRDgPYNbdG7
         mexMEQ4B7y3zWxfct269nOC9bu4er8Y6GvfmyrrJRneIVajWkRzJhh1B0Y8Rak9y6l8U
         JBBZfSuG7lH+3EHCHD3CbnDANBUEW90SUEboSu1+/E8aF9lElvHqUuTUTUWwSCv0jTek
         eB4W4U2CzXvdYQJ0yK9hi/Fd/NnwU9NR9zcOpQpDQbD7Ksp9i/dB9dfdeVbtLEAivF1p
         rPNP2fBYkQWVm+FyjgRqQaI8WlJvCVhPpVCW/tZ0pIGGuC7zB+WQvEfLOHlCqhvGkBt3
         yoHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777476409; x=1778081209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Pdajlfqb0Mkqw7FfTkWcBSlkNtUxKMEiU4sOjeajLqA=;
        b=ky2YWHGdkGNZ11gGFy66W6VNGC98aHPkrB8mwdRfNImQ4CUwXzxjtGhhxSa6ABLgfG
         Lf3QMjq43TxDzHnxeRUdtfEernQk8mb4CmVsDB4KdARUttZgQ4kiDvQ+wHgep6wYEZ1e
         vV+FHyuk7gLee/dhNR86+cfQRGLBxLoQLeZnun/jW7xVS1CiBW5wiqLRNhO1H7e0ubQL
         iw9o9UKU1t9NuwLoZI10u95uxgyJJivGn3Xz+kJm7PxXxhVpkRRoPrseA6++9IC4/Co9
         VcSkKgQvD9WNlg8rE0gVAzv5P2mTgpSDDZfpe+k1/K/8POaEAZ41RldjA28oznGyHAKu
         8FeA==
X-Forwarded-Encrypted: i=1; AFNElJ/DvoIPiJ0YiYmokeBI7wG9+LNAn3rl80WQSmAKnn5TmtrMTahW+G3U4gNp/33mLVRJ/e4aWHXjXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzBVOoSAzoiY18WXmz2hRiw5fzFwJD8nL0TZRD1pFweaWtdQhh/
	vKfEAYE/1ZB8E+aGVZ+jmP140YfBTP6zpUO/eiV2rH+KasXENymEM4li
X-Gm-Gg: AeBDieuNV2RE/NqFt4JDqYIw0rMD9W0lonpzjB9cVJO0+U27JBDlXspBNgwznEvcMTJ
	EsC/9rLECC28wOQmnLcAIrwJJLJ5CRrZq8vbyu6Dbk1mYxRFkhmdCOYd7Sy7u982hCLed5ciLcl
	YR+BsW7YH7UjSTi8knLqhlVeqhjb/1cCQio06xho2MqM0P7moMQjo+2wRMDf4QnFzZFkRSw0BQn
	qDQeInS1s+URLxVnvgafokNmKCLZnzykp28SWuk1sf7JrLKLeXpbRrzpvoWxvuSIqkZL0ksGWf2
	BxsjLZs97WN+V+OorRZk3w/6WKKrQLjGSY7u/f52HZS/5BXaOgZ5vtr/6tfXn88DdDanJIm6KCU
	q9YY90z+r51cOUz0V9Of/trtEJNPYooaTHAIWfW6lpA4qzBpmKA3gsQBwtGPvvSHJE9oS4f7dw5
	Rn7pKjM+m2w0AEWwKkaxiiomFDOXNL1U5hf6Hm5Q79N7qKVVOkLfIRxRVp+xGd40+/9vsDarOwt
	c7OuJifogndVXpr5m8HTtViA48qXPfrnvPt8+gfvd5+
X-Received: by 2002:a05:6000:2002:b0:43f:e9ee:5610 with SMTP id ffacd0b85a97d-44790d12be0mr7198547f8f.43.1777476408973;
        Wed, 29 Apr 2026 08:26:48 -0700 (PDT)
Received: from 127.0.0.1localhost ([82.132.184.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b76e5c22sm6382951f8f.28.2026.04.29.08.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 08:26:48 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v3 06/10] block: forward create_dmabuf_token to drivers
Date: Wed, 29 Apr 2026 16:25:52 +0100
Message-ID: <559756c5e22dcfa183080a979de039910d1b896d.1777475843.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777475843.git.asml.silence@gmail.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2C10649706D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[25];
	FREEMAIL_CC(0.00)[gmail.com,samsung.com,intel.com,nvidia.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13178-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

Add a trivial implementation of the create_dmabuf_token call for
block devices that forwards the call to a new blk-mq callback if it's
available.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/fops.c           | 14 ++++++++++++++
 include/linux/blk-mq.h |  9 +++++++++
 2 files changed, 23 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index 713a3ba3f457..3d8a48a7d645 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -951,6 +951,19 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
 	return generic_file_mmap_prepare(desc);
 }
 
+static int blkdev_create_dmabuf_token(struct file *file,
+				      struct io_dmabuf_token *token)
+{
+	struct request_queue *q = bdev_get_queue(file_bdev(file));
+
+	if (!(file->f_flags & O_DIRECT))
+		return -EINVAL;
+	if (!q->mq_ops || !q->mq_ops->create_dmabuf_token)
+		return -EINVAL;
+
+	return q->mq_ops->create_dmabuf_token(q, token);
+}
+
 const struct file_operations def_blk_fops = {
 	.open		= blkdev_open,
 	.release	= blkdev_release,
@@ -969,6 +982,7 @@ const struct file_operations def_blk_fops = {
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
 	.fop_flags	= FOP_BUFFER_RASYNC,
+	.create_dmabuf_token = blkdev_create_dmabuf_token,
 };
 
 static __init int blkdev_init(void)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 18a2388ba581..ee31fb3ada10 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -15,6 +15,8 @@ struct blk_mq_tags;
 struct blk_flush_queue;
 struct io_comp_batch;
 
+struct io_dmabuf_token;
+
 #define BLKDEV_MIN_RQ	4
 #define BLKDEV_DEFAULT_RQ	128
 
@@ -684,6 +686,13 @@ struct blk_mq_ops {
 	 */
 	void (*show_rq)(struct seq_file *m, struct request *rq);
 #endif
+
+	/**
+	 * @create_dma_token: Create a dma token, which will be using to map
+	 * a dmabuf for IO requests.
+	 */
+	int (*create_dmabuf_token)(struct request_queue *,
+				   struct io_dmabuf_token *token);
 };
 
 /* Keep hctx_flag_name[] in sync with the definitions below */
-- 
2.53.0



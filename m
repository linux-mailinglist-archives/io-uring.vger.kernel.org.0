Return-Path: <io-uring+bounces-10738-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D06B1C7E87B
	for <lists+io-uring@lfdr.de>; Sun, 23 Nov 2025 23:52:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DC613A25A3
	for <lists+io-uring@lfdr.de>; Sun, 23 Nov 2025 22:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E547827C84E;
	Sun, 23 Nov 2025 22:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ftiNcTx1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6E127381E
	for <io-uring@vger.kernel.org>; Sun, 23 Nov 2025 22:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763938304; cv=none; b=bMULDvOujYdQdJJ0EPgajV7ZMAG/kxG/lI7yqpUdXju4dYerAGQo8wOGa4xeSmpN2MY6a9j42y955so1l03KmuHLwcHVGKkeyxxGC6TJ9Q+USd7VR6Q9v/cU4TVLrrLtBEar4LSbpI4V/BpODLJlb/SFJ9fU87mLLIhrk0/1auI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763938304; c=relaxed/simple;
	bh=TaA27OxA1hBFyRB5sQEZB6XkCgdFpDueoKtHtp+vFGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTJIDPyzNb0j4eGK+lWS4SQlhRE4RQfVop+DEkoOoBBQEqdLCxZ1LQjpSgog7eivYKLuM6e99Li89BYpSOY3yeO4qn91f2XVZoJ3VGGrU4ImRvPAHVeyf8ynusF0N/WDC4Ecn4WMWOyhxztOxTv0ele8KaC4pYvdGK16sgmx9IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ftiNcTx1; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42b32a3e78bso3096879f8f.0
        for <io-uring@vger.kernel.org>; Sun, 23 Nov 2025 14:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763938301; x=1764543101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PR8DhyhbmfM3XR45v/DX3VtwAUQ7pza2V3aAfSC4t8o=;
        b=ftiNcTx13YdP4WuIFjBYEQY9qh3Zw5EizPLOwUI0Oo29LmHJH65J9m5pF9tilsgK4R
         Rahz3xxfxLMMQwK14JXW532fLPTYPEwkK3ER1iCLC6qfx/26ECwO0Rv2iU494tZ7Nj+n
         kNNDxSdI9r705Qgcb7Msyeau1ATIy0ChwWxeIzgVQRW8cVAikB/9IKpzTRZmBmDB6vW6
         fkxIN2vlVHGp7KWT88WoGGAU7COpoAKtaSOaDVh5PRcaok/AAmVbDQqger9TwVxKz6/X
         Xn6IB6EtTFeqJLZ6w5szBwq5njjyzULzOsqBp2lw4WThiqTSW1xjDSUFxEnTbVJOKv58
         oC2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763938301; x=1764543101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PR8DhyhbmfM3XR45v/DX3VtwAUQ7pza2V3aAfSC4t8o=;
        b=p/9Em32v4zfE52KMze7F6fV5Z3UdPJH4sddtIR+5boVkt0DEuJO5wo4oFRKZjax1wP
         5HFqqHXbop8sJJps08izyaU0b+M9gXhp8Gd+UDcnG80woLkHpl3IvT2nLZePRKZVlOeo
         1tG71ONiZY7SS6flDGcJSFTAj7SeKVTMFEsLddAOjnJT52A2O6G2crIcwMMI0H8lMxXH
         0YlM+5VUaM6f9rcMUbVD7azurbR6JqBHUvRPM5R9HjfMNOinAzr1MITGHdCCkaYrnrR1
         5WKNMOOc/8WVAPdptef05bDs4vnMV5IA3YtVCMZPjzs6uDyIKnAiki84+brZaZgnvGRM
         XWww==
X-Forwarded-Encrypted: i=1; AJvYcCVw40l6ZimT0B8HOCowTMutQXgbD5TANMrnAxMNv0LuTZM+L8j/rlfuNIQnLzMaith9zWrMzf+8PQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ1lZTgiDU0uc6G2CFaxn4WUkMrUEkM/Ik17WlVYcmN9sK/b9v
	LltQRiGuc0In8VQQwezpN5kOioZda6ssRF/N3TeV07c8EsO6np6ACXR1
X-Gm-Gg: ASbGncuNxRYf4KGjzxlDYMwC3ml20naSzpV2KbLINyuYA3EHYGLAVt71EJ4zTFDgShS
	iMVHOqMZsEGUC1x5t4x8IR2/H8RZKrwb/C7V727zVR2iy0HQOB8MHROKwFpy6QDDL3V+o41l4Ro
	O29YTRlKxPCaU5MCdyfBQo930gaK85XPFHTUGnRqcvUMMSELaFMcwZKvH6TJBG0dLKkadRGIUmN
	4pC6OKAEPJybBEZRtvGymLUo51eazdqTk6gG3YC1lAg5MPElP4nETd4sfrPJC1967EwYJWTFaJh
	z55aGd15lGW02aKCTXu52MDA6n2sf3WajO+nqIZtmrMiL2tMrTIQ9HGV1ZEY/jT2O25jooXBr0q
	pa652gykjmKcci6+doPGpanapd5Z2rS/ZB/ghnSmQuM4wWQVStsLm5B+QcZLgGfSDMlBs69PjQ5
	fOVhkp1+FGF0C79g==
X-Google-Smtp-Source: AGHT+IF2fkOx1psmIiI8t6n1UVP6WxxL86e2rgF4bc5zvWBkXEsJkKhYvtgfzcrreOJ89mrZR3pH7Q==
X-Received: by 2002:a05:6000:40da:b0:42b:47da:c316 with SMTP id ffacd0b85a97d-42cc1cc30c2mr10114899f8f.26.1763938301503;
        Sun, 23 Nov 2025 14:51:41 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fb9190sm24849064f8f.33.2025.11.23.14.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 14:51:40 -0800 (PST)
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
Subject: [RFC v2 01/11] file: add callback for pre-mapping dmabuf
Date: Sun, 23 Nov 2025 22:51:21 +0000
Message-ID: <74d689540fa200fe37f1a930165357a92fe9e68c.1763725387.git.asml.silence@gmail.com>
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

Add a file callback that maps a dmabuf for the given file and returns
an opaque token of type struct dma_token representing the mapping. The
implementation details are hidden from the caller, and the implementors
are normally expected to extend the structure.

The callback callers will be able to pass the token with an IO request,
which implemented in following patches as a new iterator type. The user
should release the token once it's not needed by calling the provided
release callback via appropriate helpers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/dma_token.h | 35 +++++++++++++++++++++++++++++++++++
 include/linux/fs.h        |  4 ++++
 2 files changed, 39 insertions(+)
 create mode 100644 include/linux/dma_token.h

diff --git a/include/linux/dma_token.h b/include/linux/dma_token.h
new file mode 100644
index 000000000000..9194b34282c2
--- /dev/null
+++ b/include/linux/dma_token.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_DMA_TOKEN_H
+#define _LINUX_DMA_TOKEN_H
+
+#include <linux/dma-buf.h>
+
+struct dma_token_params {
+	struct dma_buf			*dmabuf;
+	enum dma_data_direction		dir;
+};
+
+struct dma_token {
+	void (*release)(struct dma_token *);
+};
+
+static inline void dma_token_release(struct dma_token *token)
+{
+	token->release(token);
+}
+
+static inline struct dma_token *
+dma_token_create(struct file *file, struct dma_token_params *params)
+{
+	struct dma_token *res;
+
+	if (!file->f_op->dma_map)
+		return ERR_PTR(-EOPNOTSUPP);
+	res = file->f_op->dma_map(file, params);
+
+	WARN_ON_ONCE(!IS_ERR(res) && !res->release);
+
+	return res;
+}
+
+#endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c895146c1444..0ce9a53fabec 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2262,6 +2262,8 @@ struct dir_context {
 struct iov_iter;
 struct io_uring_cmd;
 struct offset_ctx;
+struct dma_token;
+struct dma_token_params;
 
 typedef unsigned int __bitwise fop_flags_t;
 
@@ -2309,6 +2311,8 @@ struct file_operations {
 	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
 				unsigned int poll_flags);
 	int (*mmap_prepare)(struct vm_area_desc *);
+	struct dma_token *(*dma_map)(struct file *,
+				     struct dma_token_params *);
 } __randomize_layout;
 
 /* Supports async buffered reads */
-- 
2.52.0



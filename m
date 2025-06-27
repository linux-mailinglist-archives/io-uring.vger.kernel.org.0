Return-Path: <io-uring+bounces-8507-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E071CAEBB2C
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 17:11:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FF496A0239
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 15:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D7C32EA169;
	Fri, 27 Jun 2025 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nTF237kB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2A92E88A9;
	Fri, 27 Jun 2025 15:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036975; cv=none; b=fwSYES/VA3LYE/Zu9dWPfOT6qk0CDwIdMkWioFmcryuD1OHm03Kv0+1GTuOdoCINBwPWGbk/kZuZMNhqbJHgoExryee2e5d2F8mfL0tLdAJlusctkG+OvZq2/OHinTYr0Z9oILvu8m2OtOlhyeYq0P29cVE2v4/jO6vQQibs6iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036975; c=relaxed/simple;
	bh=HxX8u79LkjkImKu5AYQKiBbZoe8dObl1LqEcm5aDl6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bASzp3CAyMXXROHjMQZSMrAzKNF5CspMjCOd8uPe5YhnoG4cuzQ6PbwrslUmu5GBCd7YXYz+TWwKE8s7C5kmbxyVDZ2D8W5Lx0FTodcEkPa6JejHZezEN6qVyyFsqHjBqoJjApZO3YCAMOC2nwirHwilRwODuBXlMimOTxRKA+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nTF237kB; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-60700a745e5so4117012a12.3;
        Fri, 27 Jun 2025 08:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751036971; x=1751641771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Te1jw7j483sy759tHuE76cyEE4rw44hR2ayhqjLm74=;
        b=nTF237kB67M4sjImMBllMBRUWaOSbu9B2gRTqaj6Gx8cUh/grFMCJatUHM6RNkKEXS
         86pLLqKPRTGogQxNv4O1Wk+YNbM0q/6C2ZJWSIL1J5u/vj5FRXMHk2pr0SjeknxfkSBq
         n3cqqjnR6WBhBoFXBXpxbSQ3Rspzxm7OHl5+R1dB27s1VF59+ZPAIYx3ZJrrTqSBFkoQ
         7gvmxVz6gRE/mvyLvzn8w3z3sR03UEqfZWGe+gyrLzg5icD1i76w4mc1Y2EzamysQF+f
         wMF1TIZNdOzi9vVCOBPL2EF1+kKSq/eiazk1NECW1Xl5fle1iNhBJvoDWCoPVng3xxXj
         QU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751036971; x=1751641771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Te1jw7j483sy759tHuE76cyEE4rw44hR2ayhqjLm74=;
        b=RQdXZlWHIEKDz4oHH+j7q+BqvMaPe0E8u6QPUmaVKsFIDpfG4EpM8LT9hZnlbROn7m
         dIfK2ZyfykIQ7GkatEgpBz+jddaWuZdFOmMWGzVejWwVOhy1VwKz6m4yNV7FT5CUkZQz
         4DSJzfeZ6x/RXOSqr7oShcEny5/N1P5/92Brh4mt0C2fpU5iyv1kstclmWZVS1lSbXPj
         lHpjtoi5tLVMcjkZK1qCvZFd/097/m7Q5CzTok7oX+gmiEiUp566sGCEzwthLEW54sgl
         68TuBGH20mC6uM4pqxTIzRodkH+g+i/oi146gN6xw5Ju6SiN7iDZAEQ0c/me4rQIkxnW
         xXhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHh3HVFYeskxYn2rk39Fig860N+hu8QsP2Dvr3ndik1x3HtRsuBdAbBOL69J1RZ0X5vXmxaN8ne84czQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzE+UTeHLztVBswtsgbqYJZI6IKmFaKO27uI6bV0tPCEUbxcTnu
	3wYqKeFtLzvATqC3/F0uU6BfgdV5ZeMeD4sgX+58gdx9qcyRknsVdSYlagSvJg==
X-Gm-Gg: ASbGncu59WgCYBFAKjdmTa2YhL7Bo/mGi75bUbOU6jrs3WyGoZDeJlyz8mPYp5Jr13n
	qoX/nHVlpuEvurVDcboLhUXCK0etCiQy6FDogiRFTPGldSj+ffBJ7oM+BaOrFwh4wKPLen/kLfP
	HDAP63+HtzWyaPkBSafoOXIxmtufmMSIUfyF0wiSE0cVWT2i5iVw4jHFLV1uhipKaw4TuNwqz7r
	mGWvb5YCh2HG4G5PerP80NoY3Pt+uBIo+EhItHm+M0MLhBOcyHm1MZm3SthRK5eLd6EdA7Z+sB3
	hGa1H8HVv5p9XeP+ja2REP6Hi8Ux8mJIlUVUkzrB2VuCn+pZP0ymj3NtI4NdMyep8XdURIjAzO3
	r
X-Google-Smtp-Source: AGHT+IFaT5DW/2JEJLqmIAIFZpMMjsyw7WUr4bt/1UbUHg6LAPcXCFf1e2Lm3tP6AQM7KwFTHt2+kQ==
X-Received: by 2002:a17:907:6d19:b0:ae0:b847:435 with SMTP id a640c23a62f3a-ae350129c6dmr333687666b.49.1751036970977;
        Fri, 27 Jun 2025 08:09:30 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c014fbsm135802866b.86.2025.06.27.08.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 08:09:30 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	David Wei <dw@davidwei.uk>,
	Vishal Verma <vishal1.verma@intel.com>,
	asml.silence@gmail.com
Subject: [RFC 08/12] io_uring: add basic dmabuf helpers
Date: Fri, 27 Jun 2025 16:10:35 +0100
Message-ID: <a4307ea944f7c8453165c02cb05839674f150b5f.1751035820.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751035820.git.asml.silence@gmail.com>
References: <cover.1751035820.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add basic dmabuf helpers and structures for io_uring, which will be used
for dmabuf buffer registration. That can also be reused in other places
in io_uring, which is ommited from the series.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/Makefile |  1 +
 io_uring/dmabuf.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++
 io_uring/dmabuf.h | 34 +++++++++++++++++++++++++++
 3 files changed, 95 insertions(+)
 create mode 100644 io_uring/dmabuf.c
 create mode 100644 io_uring/dmabuf.h

diff --git a/io_uring/Makefile b/io_uring/Makefile
index d97c6b51d584..0f5a7ec38452 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -21,3 +21,4 @@ obj-$(CONFIG_EPOLL)		+= epoll.o
 obj-$(CONFIG_NET_RX_BUSY_POLL)	+= napi.o
 obj-$(CONFIG_NET) += net.o cmd_net.o
 obj-$(CONFIG_PROC_FS) += fdinfo.o
+obj-$(CONFIG_DMA_SHARED_BUFFER) += dmabuf.o
diff --git a/io_uring/dmabuf.c b/io_uring/dmabuf.c
new file mode 100644
index 000000000000..cb9d8bb5d5b3
--- /dev/null
+++ b/io_uring/dmabuf.c
@@ -0,0 +1,60 @@
+#include "dmabuf.h"
+
+void io_dmabuf_release(struct io_dmabuf *buf)
+{
+	if (buf->sgt)
+		dma_buf_unmap_attachment_unlocked(buf->attach, buf->sgt,
+						  buf->dir);
+	if (buf->attach)
+		dma_buf_detach(buf->dmabuf, buf->attach);
+	if (buf->dmabuf)
+		dma_buf_put(buf->dmabuf);
+	if (buf->dev)
+		put_device(buf->dev);
+
+	memset(buf, 0, sizeof(*buf));
+}
+
+int io_dmabuf_import(struct io_dmabuf *buf, int dmabuf_fd,
+		     struct device *dev, enum dma_data_direction dir)
+{
+	unsigned long total_size = 0;
+	struct scatterlist *sg;
+	int i, ret;
+
+	if (WARN_ON_ONCE(!dev))
+		return -EFAULT;
+
+	buf->dir = dir;
+	buf->dmabuf = dma_buf_get(dmabuf_fd);
+	if (IS_ERR(buf->dmabuf)) {
+		ret = PTR_ERR(buf->dmabuf);
+		buf->dmabuf = NULL;
+		goto err;
+	}
+
+	buf->attach = dma_buf_attach(buf->dmabuf, dev);
+	if (IS_ERR(buf->attach)) {
+		ret = PTR_ERR(buf->attach);
+		buf->attach = NULL;
+		goto err;
+	}
+
+	buf->sgt = dma_buf_map_attachment_unlocked(buf->attach, dir);
+	if (IS_ERR(buf->sgt)) {
+		ret = PTR_ERR(buf->sgt);
+		buf->sgt = NULL;
+		goto err;
+	}
+
+	for_each_sgtable_dma_sg(buf->sgt, sg, i)
+		total_size += sg_dma_len(sg);
+
+	buf->dir = dir;
+	buf->dev = get_device(dev);
+	buf->len = total_size;
+	return 0;
+err:
+	io_dmabuf_release(buf);
+	return ret;
+}
diff --git a/io_uring/dmabuf.h b/io_uring/dmabuf.h
new file mode 100644
index 000000000000..c785ccfe0b9e
--- /dev/null
+++ b/io_uring/dmabuf.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_DMABUF_H
+#define IOU_DMABUF_H
+
+#include <linux/io_uring_types.h>
+#include <linux/dma-buf.h>
+
+struct io_dmabuf {
+	size_t				len;
+	struct dma_buf_attachment	*attach;
+	struct dma_buf			*dmabuf;
+	struct sg_table			*sgt;
+	struct device			*dev;
+	enum dma_data_direction		dir;
+};
+
+#ifdef CONFIG_DMA_SHARED_BUFFER
+void io_dmabuf_release(struct io_dmabuf *buf);
+int io_dmabuf_import(struct io_dmabuf *buf, int dmabuf_fd,
+		     struct device *dev, enum dma_data_direction dir);
+
+#else
+static inline void io_dmabuf_release(struct io_dmabuf *buf)
+{
+}
+
+static inline int io_dmabuf_import(struct io_dmabuf *buf, int dmabuf_fd,
+		     struct device *dev, enum dma_data_direction dir)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+#endif
-- 
2.49.0



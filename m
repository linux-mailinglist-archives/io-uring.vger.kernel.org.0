Return-Path: <io-uring+bounces-8504-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9048DAEBB3C
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 17:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD1DA1C629E6
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 15:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BC912E9ECE;
	Fri, 27 Jun 2025 15:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SHpNvQJQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBB62E8DE9;
	Fri, 27 Jun 2025 15:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036970; cv=none; b=W8JAkDKToSPLmkrgCY5RuCLADVJYjRPfrA0bKclx7/QsT+RqiQ4yVRl2SdmzNDjnK6E8iNfT9ymirTDJ+kjKy7MpgtFXnO4+/R8yLFGphO9GBaC/BmHI1s54xfB5E6CfMOTNKAleHjQ3/6HhjB6+baxmwmgzGSWI61c7nvIkpA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036970; c=relaxed/simple;
	bh=G69ytbgArbpnvK1WQRFkMtCI4QDbl+WZoVGFdyrXIgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js4sLplP7Z6qOu0HHo/+1JLvQQsDclSfH46HMYRNn9tTT/XeooG6oPWVaZ67skhn1G0CfvRVbO2rx8dg6+qkmY/VnbBrypRjdVAuEPvabN0vjIfVqz38Y5Ua1PN2xuhfbQiX52M6U6ZDeD3OFP6dCbvmxpPbRhfpdm6e5kqfAgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SHpNvQJQ; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ae0bc7aa21bso473188766b.2;
        Fri, 27 Jun 2025 08:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751036967; x=1751641767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nP/keTBNc/O0C5wVNNia0UrfzNdX2jAeR1fDwRug/i4=;
        b=SHpNvQJQnnhUOGOj5o7nhq4H9UUEU0oE8RboN7bArWlfrA+SLG2hMK9vti3ECPYHdt
         RwxF+sLAttRAtCbiE+0QetxK1VHvNY3HgkEjwxEfirqcMC7/XXRirbXAJhahpq1exC1t
         yKH1NBCN9PAk1t/tWAToWVfEkmbQX+R7bmLLSlK0VlsWGLk40YKWE119r/2TORdj5ZBa
         +HcsMMj2ajOJL50TQ8V7w1ru5KUX/mUdg9lbjj+Hs4moRMR0xsS6Bowqt4+Xj8ADewXy
         ePl/lpyrogLUap2noY7oA8XI+WqMKN9OOqWoXepr417fCUeD5d+t6qeyehRa8S/y2/sY
         /xZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751036967; x=1751641767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nP/keTBNc/O0C5wVNNia0UrfzNdX2jAeR1fDwRug/i4=;
        b=J6LV2uWDl19ZBIPbm3Cu8K/yS/+dt7sJMW5vEwkF8zI0PmoqEoK6MxyEb5knZ4K3jA
         86WSqYgSbjYb2Amxsq3GZvtPCQupSQXp4J0uHPVINdl6ZiBv8y7HEpgrto07/1BsAPdA
         RRRFuyAoDC8tbW85pC5BnzN4SUh2hbrVV/FnkPvR/AVfO2aqVmCbVMbWUkw/frQC46aG
         qmLRmuGHYAvcndQqRZFEp6vt5jtQzTKTiy+xNpstPqtQ2WRu1DaoUXC5fjAGFcONdyCu
         kkRN7oivW4m3qevmwIPTZqU2kA3giaPb0J+IMRFWJU9st9gs3Rpj9CZJ2iKYu3Uvw4cj
         Uj+A==
X-Forwarded-Encrypted: i=1; AJvYcCXVm896Izst0OYQMsNawDoq/D4LZuWZgC/u6zjgAzqMJ1j52Uoj0u9Bwo6IbrCs0NJZ+zI/RHII/X6Rqg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyTwrTIakBOJDpu/xjinu4Yn0+092uRr0iErkHPQcgKaLM1ufRh
	JMRQTqOdsmkbucnZcuLe3EnOJX/+T6W7li5rVlV8aLQJc/QT1wsAxxPWbBA7QQ==
X-Gm-Gg: ASbGncuZc11FFcigduIE4roV2HKTFE8pJML1+a9YMiIu9sh6j8ofULkoWWvp61R3Y7D
	6o0wKaHWWuXvqnTGrs56tamqlesOVKmU/h5c1FnKdFhvRTp21inc9rnLQ2BTWd2NB+5rnD53Gmi
	cwJFHY8nW8ZMBedqBUD0oKG4/rWLQxLdmFGjBulzxbdIq8bPdWIPK6DJnS4c+arpQv3gYWvXrX6
	YW66M64BoXL27+ZshHCdXUomkWqbnB6qNrlumN/wXUN455VHnzJ77RzF5/o0wRDlGVTxYcQkq/a
	oDxEWEh7Rc7n6Dwe2uBp2NLnyOlACHve/wnAiq+7MueSmWIbfkmHe/rrtvmaDGtbLJjqzc44Vi3
	d
X-Google-Smtp-Source: AGHT+IGeQPxp7NHdA/JBf+pRqn8DJa3rDWFqYT7jpmKVfeIg6XCHEueu+grIlnzt9pADDCFo4kqA6Q==
X-Received: by 2002:a17:906:794e:b0:ae3:4f57:2110 with SMTP id a640c23a62f3a-ae35017b2cfmr334573366b.54.1751036966119;
        Fri, 27 Jun 2025 08:09:26 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c014fbsm135802866b.86.2025.06.27.08.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 08:09:25 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	David Wei <dw@davidwei.uk>,
	Vishal Verma <vishal1.verma@intel.com>,
	asml.silence@gmail.com
Subject: [RFC 05/12] block: implement ->get_dma_device callback
Date: Fri, 27 Jun 2025 16:10:32 +0100
Message-ID: <25992680f704b6e92bd8c96e86cd143895fa03c2.1751035820.git.asml.silence@gmail.com>
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

Implement the ->get_dma_device callback for block files by forwarding it
to drivers via a new blk-mq ops callback.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bdev.c           | 11 +++++++++++
 block/fops.c           |  1 +
 include/linux/blk-mq.h |  2 ++
 include/linux/blkdev.h |  2 ++
 4 files changed, 16 insertions(+)

diff --git a/block/bdev.c b/block/bdev.c
index b77ddd12dc06..28850cc0125c 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -61,6 +61,17 @@ struct block_device *file_bdev(struct file *bdev_file)
 }
 EXPORT_SYMBOL(file_bdev);
 
+struct device *block_get_dma_device(struct file *file)
+{
+	struct request_queue *q = bdev_get_queue(file_bdev(file));
+
+	if (!(file->f_flags & O_DIRECT))
+		return ERR_PTR(-EINVAL);
+	if (q->mq_ops && q->mq_ops->get_dma_device)
+		return q->mq_ops->get_dma_device(q);
+	return ERR_PTR(-EINVAL);
+}
+
 static void bdev_write_inode(struct block_device *bdev)
 {
 	struct inode *inode = BD_INODE(bdev);
diff --git a/block/fops.c b/block/fops.c
index 388acfe82b6c..cb22ffdec7ef 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -941,6 +941,7 @@ const struct file_operations def_blk_fops = {
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
 	.fop_flags	= FOP_BUFFER_RASYNC,
+	.get_dma_device = block_get_dma_device,
 };
 
 static __init int blkdev_init(void)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index de8c85a03bb7..1c878b9f5b4c 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -656,6 +656,8 @@ struct blk_mq_ops {
 	 */
 	void (*map_queues)(struct blk_mq_tag_set *set);
 
+	struct device *(*get_dma_device)(struct request_queue *q);
+
 #ifdef CONFIG_BLK_DEBUG_FS
 	/**
 	 * @show_rq: Used by the debugfs implementation to show driver-specific
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a59880c809c7..54630e23a419 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1720,6 +1720,8 @@ struct block_device *file_bdev(struct file *bdev_file);
 bool disk_live(struct gendisk *disk);
 unsigned int block_size(struct block_device *bdev);
 
+struct device *block_get_dma_device(struct file *file);
+
 #ifdef CONFIG_BLOCK
 void invalidate_bdev(struct block_device *bdev);
 int sync_blockdev(struct block_device *bdev);
-- 
2.49.0



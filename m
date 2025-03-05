Return-Path: <io-uring+bounces-6965-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 767A4A4F383
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 02:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3E6316EA05
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 01:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980B91EB3E;
	Wed,  5 Mar 2025 01:23:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3CD5228;
	Wed,  5 Mar 2025 01:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741137816; cv=none; b=lXUyL/wci2t8aLymTqq9qhx9ArrKBsz99qZvmWBCsaWuDvb7BrlQb9X5wtXiBuGbKX0z6W3cAcvR08Yf/W3Ek/zgRd6GgsFcAthAU7mnuZ0+EZjrmPtVBRFAPRxcbOuAJlZSs2iIG4ZK07Evou1fkvFboSXNgd84R7BE8LG2ySM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741137816; c=relaxed/simple;
	bh=/pGsyz/6ThzK+KceFflPkTk2ot9eWG/BfuA8GInaWtw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jXL/EDygv1lFJnfhVvfdYuRx26W+/KNHS1IvLKwyHIRrTpU7XDTTlesNIXbkhM6GcWEdmrTv5rTx5VN6l4xeJY6y0UHTNpm4DxE7g5BrDjD6raWPjygfmr7uvTQLbCPdktG8s576sPyEiqSRmwIAP0BdksBFWvY/mwCOhUu+0ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Z6vpZ1N3Kz1f07W;
	Wed,  5 Mar 2025 09:19:18 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id E94C01401F3;
	Wed,  5 Mar 2025 09:23:30 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 5 Mar
 2025 09:23:30 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <axboe@kernel.dk>, <asml.silence@gmail.com>
CC: <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yuehaibing@huawei.com>
Subject: [PATCH -next] io_uring: Remove unused declaration io_alloc_async_data()
Date: Wed, 5 Mar 2025 09:34:54 +0800
Message-ID: <20250305013454.3635021-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf500002.china.huawei.com (7.185.36.57)

Commit ef623a647f42 ("io_uring: Move old async data allocation helper
to header") leave behind this unused declaration.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 io_uring/io_uring.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index daf0e3b740ee..b95dab77e32d 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -88,7 +88,6 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
 void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
 				 unsigned flags);
-bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
 void io_req_task_complete(struct io_kiocb *req, io_tw_token_t tw);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
-- 
2.34.1



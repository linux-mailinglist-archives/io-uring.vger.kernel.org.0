Return-Path: <io-uring+bounces-7554-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AD2AA94206
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 08:58:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01D64446FCD
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 06:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B2CF1547F5;
	Sat, 19 Apr 2025 06:58:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C42B13B59B;
	Sat, 19 Apr 2025 06:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745045917; cv=none; b=Jgc5NuoxPuw+iMytwsN7/7tIQ+kWqi1kW7jrfYFe32Fof82lhiwYzVB1JfzGYngT6I7kTTzeNQ8rJUdBA3/4wUJ2nFvzXkmaWGWKtnAx2rmY1R3oniY6F1Iu0iab7ovLIdqebqQ/kloPGzbDC7eijIxMWO5LAoHHgTMukaqcz5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745045917; c=relaxed/simple;
	bh=qW86OOJgwQLZxCemaRyecuWwlflZx2hUXnF1dqy6eJ4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MYoXcSjcqjXh/gKJRuPil5z2s0Bs1klnIZ32Aj0zfUh0RRXtNDb8XJGFYs9vsKDN17t6QhYR5UMpiw1PWFbSCkfZ5D+VZdWqQ6Aah3ypLfnPl86Q2VtH6COD/pdnNRKFQHQQXdoT51Yg2PoVZ3rHsiJV6SUd1eyjLbXXBzJg8Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Zfj7F00SJzHrDg;
	Sat, 19 Apr 2025 14:55:04 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id C5D981402EC;
	Sat, 19 Apr 2025 14:58:32 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 19 Apr
 2025 14:58:32 +0800
From: Long Li <leo.lilong@huawei.com>
To: <axboe@kernel.dk>, <asml.silence@gmail.com>
CC: <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yi.zhang@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH] io_uring: update parameter name in io_pin_pages function declaration
Date: Sat, 19 Apr 2025 14:47:36 +0800
Message-ID: <20250419064736.1834012-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf500017.china.huawei.com (7.185.36.126)

Fix inconsistent first parameter name in io_pin_pages between declaration
and implementation. Renamed `ubuf` to `uaddr` for better clarity.

Fixes: 1943f96b3816 ("io_uring: unify io_pin_pages()")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 io_uring/memmap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index dad0aa5b1b45..b9415a766c26 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -4,7 +4,7 @@
 #define IORING_MAP_OFF_PARAM_REGION		0x20000000ULL
 #define IORING_MAP_OFF_ZCRX_REGION		0x30000000ULL
 
-struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
+struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages);
 
 #ifndef CONFIG_MMU
 unsigned int io_uring_nommu_mmap_capabilities(struct file *file);
-- 
2.39.2



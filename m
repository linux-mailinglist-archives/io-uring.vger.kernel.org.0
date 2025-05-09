Return-Path: <io-uring+bounces-7920-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A81CAB0AB9
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 08:39:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6C3F1C026AA
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 06:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CB8F28F4;
	Fri,  9 May 2025 06:39:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE97CD53C
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 06:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746772786; cv=none; b=QouS3EGgoSqP+pNsNLFcGNaM9LI4qHsVXZpC0CRm5wqvb5TjSHHfNu5cVedZCjInDrXwwBy239owPIZW660YDDyeLCRgyBQ7I/4B9OQfJYoiMWzUcs3Tdy74gc5wQ5lbzwV6gVzOHsyQWSXV4gxSShX1bzthOK7dP3j6qGOmyRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746772786; c=relaxed/simple;
	bh=n38yq1TGCHl7F0ubQYFLAHDvxvybUyQj10GU79Hb7U8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bcpiPG5xltwMZUsRXQ49kDsYjFH6GoB/nrfO2ebpRsVyrlZXW7BlF88eOJm7HBx+pMIA8ycCHb+SHPvMDdNbm3CaqfFqrNBYF5JnvIRUPfgEADhsh+U+vA66yPyRY+JpjnmzVXLWM6181sGYea+QCPaBD1IAasLyo3sudq0vzeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Ztzqj5kzdz4f3jXg
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 14:39:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 579AC1A12EC
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 14:39:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHa18oox1oDqGBLw--.13680S4;
	Fri, 09 May 2025 14:39:38 +0800 (CST)
From: leo.lilong@huaweicloud.com
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: leo.lilong@huawei.com,
	io-uring@vger.kernel.org,
	yangerkun@huawei.com
Subject: [PATCH v2] io_uring: update parameter name in io_pin_pages function declaration
Date: Fri,  9 May 2025 14:30:15 +0800
Message-Id: <20250509063015.3799255-1-leo.lilong@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHa18oox1oDqGBLw--.13680S4
X-Coremail-Antispam: 1UD129KBjvdXoWrKrW8Xr1rCr47CF4xZFW8JFb_yoW3ZFc_Zr
	Wktr1qgryIvF1vya43uFyxXw1DXrnxKF10kFnF9rn0yr43ZaykJr90kFy8Xry5Wr4j9Fy5
	Wa95X343J34I9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbcAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUzOJ5UUUUU
X-CM-SenderInfo: hohrhzxlor0w46kxt4xhlfz01xgou0bp/

From: Long Li <leo.lilong@huawei.com>

Rename first parameter in io_pin_pages from ubuf to uaddr for consistency
between declaration and implementation.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
v2: Remove unnecessary fix tags
 io_uring/memmap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index 24afb298e974..08419684e4bc 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -6,7 +6,7 @@
 
 #define IORING_OFF_ZCRX_SHIFT		16
 
-struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
+struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages);
 
 #ifndef CONFIG_MMU
 unsigned int io_uring_nommu_mmap_capabilities(struct file *file);
-- 
2.39.2



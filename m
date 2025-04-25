Return-Path: <io-uring+bounces-7722-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D24C0A9C7D7
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 13:40:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 074601BC50EC
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 11:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2EAB14F9D9;
	Fri, 25 Apr 2025 11:40:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34313241CB0
	for <io-uring@vger.kernel.org>; Fri, 25 Apr 2025 11:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745581227; cv=none; b=nTiyq9ktodzbiysZ3a63IJQkiZgMJPpY6ST9gn8cjKkGdKRzA+zYyiMRSdG+tBl2Kmvw/PzNmQh5AXZpq1WUIUM1kIzGpFzJGT0aXlOIGwyC+4CGbjf6Z9eKp+tG3zhX3zdXHyoDsXEzj5itqF10S4XakO7fsUqEczCxVSgZuHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745581227; c=relaxed/simple;
	bh=LuRENuViGYhX1lXI+70xuF4q626ocswUz0B07Msm3Lc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KdjAZp3Op5DU5uDRaBGpK98wkrcAhAgNniTJ26HbfQQf4d2/QiKXwOOP9IUk3yIdarpOnxOCbvYSb8pXBlUgUZ7pclsLsVSHtFy6dJWmhYUd+bMN+sqQ89+7ga8BB3MtwsI1EzyVqxfkXyYbyeuhzIXYoEYophDpeW/qm/i5HRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZkW96660wz4f3lVL
	for <io-uring@vger.kernel.org>; Fri, 25 Apr 2025 19:39:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6A51B1A06DC
	for <io-uring@vger.kernel.org>; Fri, 25 Apr 2025 19:40:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl+jdAtoVhkbKg--.322S4;
	Fri, 25 Apr 2025 19:40:20 +0800 (CST)
From: leo.lilong@huaweicloud.com
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: leo.lilong@huawei.com,
	yangerkun@huawei.com,
	io-uring@vger.kernel.org
Subject: [PATCH] io_uring: update parameter name in io_pin_pages function declaration
Date: Fri, 25 Apr 2025 19:32:41 +0800
Message-Id: <20250425113241.2017508-1-leo.lilong@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHKl+jdAtoVhkbKg--.322S4
X-Coremail-Antispam: 1UD129KBjvdXoWrZw4furWrXry7GF4fXF4xZwb_yoWfuFb_Zr
	Wktry09r4IqF10vFy3uF1xXr15XrnFkr48GF1UKrn0yr4fZFWkJrnYqF18Xry3Wr409Fy7
	Wa95X3sxJw1I9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbckYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_JF0_
	Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UKZXOUUUUU=
X-CM-SenderInfo: hohrhzxlor0w46kxt4xhlfz01xgou0bp/

From: Long Li <leo.lilong@huawei.com>

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



Return-Path: <io-uring+bounces-11175-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 46250CCA1F8
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 04:00:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 47D1130487F5
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 03:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ADCC2BE7AD;
	Thu, 18 Dec 2025 03:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ODkciTn7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56962B9B9
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 03:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766026834; cv=none; b=EBmFAWuLOZ3l4mmNAEW9FyFJFe3qA+CbcNiK8t9r9oDxdu4Dq7dwkFWvofDkisz4Z0X36J6drAy/cpdInDOCqbYia88WBCVQ36ve3XLXTLU9CdR/FqcM2ZBzjTSLAkFxfkVZCD1kDWSvOqIOomAnYpMKh8LrjgCAQ/Kdd9lHEZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766026834; c=relaxed/simple;
	bh=Vm++0UfiI7mTMG7UcqfeOA+uxyR8LCbfyx1yxXxyHSo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EQB1EUHRzs/Y3ImL+9FgA4Eb69XEkVaMV9AGy9+jVgJC0QY4ijW94rr+lES4HnLPKXR5lbAcIOlIPg9f4l44D9XXwvFSjhZjccA7flNz3og66DcEZEJCTlloVq3tYJLvk2MzgNkcCKIcjnZDFkof8uqMr58kplE6SPE9yWmCvJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ODkciTn7; arc=none smtp.client-ip=209.85.128.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-78e6dc6d6d7so1073167b3.3
        for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 19:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766026831; x=1766631631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f1aW+idYYoTpGggNMnP1gIvl+I8Ac1YfYU7BJVbP8Vk=;
        b=ODkciTn7QovESv863Wsiyh/h0tHGmaFu+zj5raTRO9WBC4QeHN9QKTaihFo/yh1552
         HVMr+NRdAzvTMU8zQBqVTAQXo6c3KBOTNcqtwIQfjaX0VwwyFWCHBA/wzLcM9NMMRue7
         0Z5ZhQOiYhfj44OxIJmgX/g5tiPY0aeijN978VndvrztXGnbOvulGRLmVzn70o63mEew
         dIWke/Ge5np0me26QkH3uM8AQ8eEge60QOAFgeNRj88FcSaTyuYSG2zdb5xD2ax70Ze0
         9wTaJ00SHw4A/ITdg1dh2BgO3MYXBywc4JjY6RNLEa3OHfP3Z0euGUdBR6Ln4Sd4mOU1
         Megg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766026831; x=1766631631;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f1aW+idYYoTpGggNMnP1gIvl+I8Ac1YfYU7BJVbP8Vk=;
        b=HwTh+G8y2E9EQQFOnnMcwOqJDxtGFmh0IGlQtIlPT7Em2s0xwLJ6WdtdHkmjxWEYGV
         dizkF6LnwExBWFGd5bM1ZRjX9qqqMvY272GLqekzVfGcqUhypIfGqrIXuTc33ffalBNI
         A7Jq0QU8s+m0Su5vuRqlXPB15TP/DwHI7iLJdUZN09sbjJUEvkEQVqlnrMLqCXL9nABn
         cCCojVZIq4MzJ1UFzEgyzmKVbeodSYno2d6QIAu4Gga0+eObZ/0cFebQk8OfxTI3zyRC
         H4gC5poDf8gA/1QGOYe17H4EjNXajHX3HU9JfsgPiiD3neH15/bznLxYxYAxSm0Z4yCN
         CwqA==
X-Gm-Message-State: AOJu0YzTLODCIpXZMlefrXnjq3WALDuJxCB/racO8Vf1Bqi5xJ936LcR
	RySASHCygeq9rQ6ZAowCBcYfpC/rdpCJp9MW6aXaxDxdbwMg9js69NpJWZ2DvkOqH9DzOg==
X-Gm-Gg: AY/fxX5HWzO0OaDCzW6hsJTVyp6nI2NcT2IN14bSWh8QBjkxNO33oz8sSeUCxlgkaYn
	/EQ8mqB4PMK6kMu+BTEVaQIxEOP9LWnUlv+D+T3fBkHW1sWHpVlW9B9yUKGATcKTiEyAJrN+Eva
	zqM28/MeF7dgh0/80a99BNEB/n7v8w2l4k9agRqk1TSUwwpOINirxEtWT85CbSsb7Lo7CFHHmDr
	beRc8XoKklhS/LhogjpWlH9eLL/QY1QXk37EpgXemuOmOPhr9Ho/qYaWfYBMycec8gI/2mkFKqm
	HtJtQdPLFgAaiY5TqMbo49Mix5CaQYYPu8EehwWCxu3oL6dRkwn3JOYPgP4XcTSsR/SfLKL+OGQ
	a7iMYuJ8wBshoEnqHpuKbqSLxpPECeAfnBAF2ChNenoSzdQXmFOoYA+AeokVs0kpE3bJNl/LW1E
	dV620vu/46+vEnflLFv7LuJ+8qRVqkKTIjWJxs22hxhV7v5IHQoaEzgDFKnzgO
X-Google-Smtp-Source: AGHT+IFLtp/YJVgdDwF2T2NRVscU9ohhAIZGe3jf1diZBtUCBHkPwsifUpFmbcBIew2yjf6ZKbexmg==
X-Received: by 2002:a05:690e:13c4:b0:644:60d9:866e with SMTP id 956f58d0204a3-6455567be0dmr15248816d50.95.1766026830540;
        Wed, 17 Dec 2025 19:00:30 -0800 (PST)
Received: from abc-virtual-machine.localdomain ([170.246.157.94])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fa728f8b7sm3638087b3.45.2025.12.17.19.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 19:00:30 -0800 (PST)
From: Yuhao Jiang <danisjiang@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuhao Jiang <danisjiang@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass via compound page accounting
Date: Wed, 17 Dec 2025 20:59:47 -0600
Message-Id: <20251218025947.36115-1-danisjiang@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When multiple registered buffers share the same compound page, only the
first buffer accounts for the memory via io_buffer_account_pin(). The
subsequent buffers skip accounting since headpage_already_acct() returns
true.

When the first buffer is unregistered, the accounting is decremented,
but the compound page remains pinned by the remaining buffers. This
creates a state where pinned memory is not properly accounted against
RLIMIT_MEMLOCK.

On systems with HugeTLB pages pre-allocated, an unprivileged user can
exploit this to pin memory beyond RLIMIT_MEMLOCK by cycling buffer
registrations. The bypass amount is proportional to the number of
available huge pages, potentially allowing gigabytes of memory to be
pinned while the kernel accounting shows near-zero.

Fix this by recalculating the actual pages to unaccount when unmapping
a buffer. For regular pages, always unaccount. For compound pages, only
unaccount if no other registered buffer references the same compound
page. This ensures the accounting persists until the last buffer
referencing the compound page is released.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Fixes: 57bebf807e2a ("io_uring/rsrc: optimise registered huge pages")
Cc: stable@vger.kernel.org
Signed-off-by: Yuhao Jiang <danisjiang@gmail.com>
---
 io_uring/rsrc.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a63474b331bf..dcf2340af5a2 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -139,15 +139,80 @@ static void io_free_imu(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 		kvfree(imu);
 }
 
+/*
+ * Calculate pages to unaccount when unmapping a buffer. Regular pages are
+ * always counted. Compound pages are only counted if no other registered
+ * buffer references them, ensuring accounting persists until the last user.
+ */
+static unsigned long io_buffer_calc_unaccount(struct io_ring_ctx *ctx,
+					      struct io_mapped_ubuf *imu)
+{
+	struct page *last_hpage = NULL;
+	unsigned long acct = 0;
+	unsigned int i;
+
+	for (i = 0; i < imu->nr_bvecs; i++) {
+		struct page *page = imu->bvec[i].bv_page;
+		struct page *hpage;
+		unsigned int j;
+
+		if (!PageCompound(page)) {
+			acct++;
+			continue;
+		}
+
+		hpage = compound_head(page);
+		if (hpage == last_hpage)
+			continue;
+		last_hpage = hpage;
+
+		/* Check if we already processed this hpage earlier in this buffer */
+		for (j = 0; j < i; j++) {
+			if (PageCompound(imu->bvec[j].bv_page) &&
+			    compound_head(imu->bvec[j].bv_page) == hpage)
+				goto next_hpage;
+		}
+
+		/* Only unaccount if no other buffer references this page */
+		for (j = 0; j < ctx->buf_table.nr; j++) {
+			struct io_rsrc_node *node = ctx->buf_table.nodes[j];
+			struct io_mapped_ubuf *other;
+			unsigned int k;
+
+			if (!node)
+				continue;
+			other = node->buf;
+			if (other == imu)
+				continue;
+
+			for (k = 0; k < other->nr_bvecs; k++) {
+				struct page *op = other->bvec[k].bv_page;
+
+				if (!PageCompound(op))
+					continue;
+				if (compound_head(op) == hpage)
+					goto next_hpage;
+			}
+		}
+		acct += page_size(hpage) >> PAGE_SHIFT;
+next_hpage:
+		;
+	}
+	return acct;
+}
+
 static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 {
+	unsigned long acct;
+
 	if (unlikely(refcount_read(&imu->refs) > 1)) {
 		if (!refcount_dec_and_test(&imu->refs))
 			return;
 	}
 
-	if (imu->acct_pages)
-		io_unaccount_mem(ctx->user, ctx->mm_account, imu->acct_pages);
+	acct = io_buffer_calc_unaccount(ctx, imu);
+	if (acct)
+		io_unaccount_mem(ctx->user, ctx->mm_account, acct);
 	imu->release(imu->priv);
 	io_free_imu(ctx, imu);
 }
-- 
2.34.1



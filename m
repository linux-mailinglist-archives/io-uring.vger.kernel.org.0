Return-Path: <io-uring+bounces-4826-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC129D2590
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 13:21:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13F1A2859A1
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 12:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C0331D079F;
	Tue, 19 Nov 2024 12:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="se4b/Ja2"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1001D07B2;
	Tue, 19 Nov 2024 12:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732018634; cv=none; b=P0RPfDZFn0yljJx19UG63moT8zzROzJuSF9mT1N7mTe2pcvynsk1Sg4Dy3Pvm4AR3edrpTLREGnQyxKy7zrmc/L9CAbHkldF0M9uumlSZCzg2vFp8hIS3Xo+0ISIs0oPwT3s+VyYZ0F0Bwka22HBkCt+pizvj0X/6vZgWOfuCWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732018634; c=relaxed/simple;
	bh=mM+jJIYJoUQdYmVJ3nz+C2g+egOAaPl06ivxgzm808w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igkyM0zn0doY7jOlkljJiqSw5PqxCdTXbxpw4Qds+wWGMwsT89DayVWvGOy0gUl/s/w2BM5k2D74MJDmhpI1hmVytyPAyBMcqGz2ndAhPhksv/NCWv28Po2NOceqlsQdCA1as8PtCHnmLUlTHM2EkUWZGEqXvQEzXLSqpOmgrSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=se4b/Ja2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dP9K1xCe3x7QngHbD7VKt4NIpaWi7nUk7H9PVbWTde0=; b=se4b/Ja2hdUcjFBstF7JQRd3VT
	9/VmqBpHjD3r5C4T1zh4kpZKEOhDo3FjHyAdbp9Qs7Vtw6yNRD6p0W9+nyQqVw8cuA35lDgZFfPtz
	n57SPZMbN9tk300kCv7Xe9pK0dRpMGjx0DAwklgIgwbxNFldITEL3CJRK9ozOu5m9vMfaeH8aMaVd
	86MjI8r92h+HUD+6SOTPM22cDaFWGAQS8/nJspAh2knXG7N1ZKf5bEDCTJ2z5dLCV0YVm6U+ntxz8
	z1W2qtW+hmlsN39ZRvP9p3QnU4IdiskMe+jqiXh9NFCvgWibX0ctzI8seBWGlmG5Qub+2323rIB8U
	4c+EtKlw==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDNAM-0000000CJGE-0iRu;
	Tue, 19 Nov 2024 12:17:10 +0000
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
Subject: [PATCH 12/15] nvme: add a nvme_get_log_lsi helper
Date: Tue, 19 Nov 2024 13:16:26 +0100
Message-ID: <20241119121632.1225556-13-hch@lst.de>
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

For log pages that need to pass in a LSI value, while at the same time
not touching all the existing nvme_get_log callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0d058276845b..b61225201b47 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -151,6 +151,8 @@ static void nvme_remove_invalid_namespaces(struct nvme_ctrl *ctrl,
 					   unsigned nsid);
 static void nvme_update_keep_alive(struct nvme_ctrl *ctrl,
 				   struct nvme_command *cmd);
+static int nvme_get_log_lsi(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page,
+		u8 lsp, u8 csi, void *log, size_t size, u64 offset, u16 lsi);
 
 void nvme_queue_scan(struct nvme_ctrl *ctrl)
 {
@@ -3069,8 +3071,8 @@ static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 	return ret;
 }
 
-int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,
-		void *log, size_t size, u64 offset)
+static int nvme_get_log_lsi(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page,
+		u8 lsp, u8 csi, void *log, size_t size, u64 offset, u16 lsi)
 {
 	struct nvme_command c = { };
 	u32 dwlen = nvme_bytes_to_numd(size);
@@ -3084,10 +3086,18 @@ int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,
 	c.get_log_page.lpol = cpu_to_le32(lower_32_bits(offset));
 	c.get_log_page.lpou = cpu_to_le32(upper_32_bits(offset));
 	c.get_log_page.csi = csi;
+	c.get_log_page.lsi = cpu_to_le16(lsi);
 
 	return nvme_submit_sync_cmd(ctrl->admin_q, &c, log, size);
 }
 
+int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,
+		void *log, size_t size, u64 offset)
+{
+	return nvme_get_log_lsi(ctrl, nsid, log_page, lsp, csi, log, size,
+			offset, 0);
+}
+
 static int nvme_get_effects_log(struct nvme_ctrl *ctrl, u8 csi,
 				struct nvme_effects_log **log)
 {
-- 
2.45.2



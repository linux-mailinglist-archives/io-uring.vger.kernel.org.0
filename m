Return-Path: <io-uring+bounces-4817-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D4599D256C
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 13:17:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DC8228363C
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 12:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6571CC8A9;
	Tue, 19 Nov 2024 12:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BsPDud3O"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868E31CCB38;
	Tue, 19 Nov 2024 12:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732018611; cv=none; b=j0Y+q6Hq65OkJMmlY60x+tpHjpWYb4GH7cNc7TehUPUi4RkBcpv50iHdb+6aE14tutt4MLVGkoCmT/c5oOLd5jRCbHeclRqmjSmMxd+rhWvGL02PvQHDlgOU9u2AIem+z2KLEvkrUd5r0J+tv7fW6lRyRtZcXSmbKlkuVHAWLMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732018611; c=relaxed/simple;
	bh=6pxM1bOMRFet6+JOFGsE6KmOLaBM0tWwnKAnjSKCxH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/hr21eQuXeHlyB5NtLOhDjUgpfPbYwR/1XUmFYs76hau89p8qg5gbCLmmfky8MSNpNy0GuSJxPwhOqCunNXgfu3mk6GssZwZ4lrRniKRC/WXqEcKyY+/ODkbk1Mjm0iqqXQ+MAzWh8/+5YK454QJOzGyhM3T/TpEvJMO1Brt8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BsPDud3O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=akv2+qO8RNiZ/MdlD08p6GimzeODp1R3NwsVs3l8fTM=; b=BsPDud3O0GUVpn/5hbXXtIzOcV
	VFQ0MdlEnxqRcxaA1TvSmWYDn2B90ptdB0B48mB9R0rJlg9AY8RKqWE49xUJu2g6k1+xSPc4Tz812
	4VYhHufa9c8uW6bjfRLj7SOY2IEP16+r2IorJ+CWh5V/WnF481bMgeRQ+By+DyZmsqbfXVdc3XQ42
	aWFEuPQrfBokLajvky9HFN/wSMrpE+ZrYXrRD3r1LXcWFVBubFtDrNSSjpw2J0RmWVQcoT1nLveQ9
	0l+zI5gbg6WilgIzD61DQxs+Y7f+ZGB2H0VBE2iC9xJrla3Wh9DIqdToHT9f3Ucuf1Azn00fVRbcr
	Pg5iKbmQ==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDN9y-0000000CItq-1hWL;
	Tue, 19 Nov 2024 12:16:46 +0000
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
Subject: [PATCH 03/15] io_uring: enable passing a per-io write stream
Date: Tue, 19 Nov 2024 13:16:17 +0100
Message-ID: <20241119121632.1225556-4-hch@lst.de>
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

From: Kanchan Joshi <joshi.k@samsung.com>

Allow userspace to pass a per-I/O write stream in the SQE:

	__u16 write_stream;

Application can query the supported values from the statx
max_write_streams field.  Unsupported values are ignored by
file operations that do not support write streams or rejected
with an error by those that support them.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[hch: s/write_hints/write_streams/g]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/uapi/linux/io_uring.h | 4 ++++
 io_uring/io_uring.c           | 2 ++
 io_uring/rw.c                 | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index aac9a4f8fa9a..7a6a1b3726d3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -98,6 +98,10 @@ struct io_uring_sqe {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		struct {
+			__u64	__pad4[1];
+			__u16	write_stream;
+		};
 		__u64	optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index da8fd460977b..a54da2dd83a1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3868,6 +3868,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
+	BUILD_BUG_SQE_ELEM(48, __u64,  __pad4);
+	BUILD_BUG_SQE_ELEM(56, __u16,  write_stream);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
 
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
diff --git a/io_uring/rw.c b/io_uring/rw.c
index cce8bc2ecd3f..88a5b5f65a9b 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -279,7 +279,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		rw->kiocb.ki_ioprio = get_current_ioprio();
 	}
 	rw->kiocb.dio_complete = NULL;
-
+	rw->kiocb.ki_write_stream = READ_ONCE(sqe->write_stream);
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
 	rw->flags = READ_ONCE(sqe->rw_flags);
-- 
2.45.2



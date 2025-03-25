Return-Path: <io-uring+bounces-7235-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96754A70307
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 15:00:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A8CD163D23
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 13:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AEE3256C75;
	Tue, 25 Mar 2025 13:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BowxaWAy"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B3D1F55EF
	for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 13:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742910741; cv=none; b=tkrflSC7fPwyeI+QjKaHdtqzW39ShfiI+VoB8LUp5HSCt0EuISKIctdab73BkP6xvPa9FubK/RDiIpMzwQ/oRYbGsghSiayq1LPkK/7CEMQkBkMtw/ne26vBwlm5p0p+PZSoNi4OsEKoV84D7tDTy57SkMRbKxmqUbXjXB2p9ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742910741; c=relaxed/simple;
	bh=K6whdES8559i6CBaBypmmMS9T2dsvIXYArKtiCVbMSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONGjwJMnhvoVnHS0wJ3YbcUASqUq2Dd2+dNCWb4kNGwzk1vaPaTabx3gV1tcwqOvCY40SlOFFW5F+Une8oichoU3GykNnnMVj8XIuagEhvZySk8TLPicWhQ5fbXhe3UuHX+bCBZHgdrADlJS2wFPOKJDR6yNG/XwyKGUqzumaQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BowxaWAy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742910738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZxeZTqhGbSoVgvv/Ji688YyzwiGqGk7NwUsJ7XYUkcQ=;
	b=BowxaWAyGEtL+yc18Y+CvQr/t9WqJOlNrdlAZB5POqen+S7RjCbx2Uj56L3XU7vu6fSrjn
	zV62Ci5iP3qKvUOCpsk7t/ogIjGgxfTyRvwJNFCtJpchOGDvmGf3ardiO9RwbvG6KvGs2h
	lpROWclW6p0BBbAax7TnzGnhSj8V2/0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-468-KhYdfVMANv6Xx8AUDbu6Aw-1; Tue,
 25 Mar 2025 09:52:17 -0400
X-MC-Unique: KhYdfVMANv6Xx8AUDbu6Aw-1
X-Mimecast-MFC-AGG-ID: KhYdfVMANv6Xx8AUDbu6Aw_1742910736
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E705180049D;
	Tue, 25 Mar 2025 13:52:15 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8DD341800944;
	Tue, 25 Mar 2025 13:52:13 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 1/4] io_uring: add validate_fixed_range() for validate fixed buffer
Date: Tue, 25 Mar 2025 21:51:50 +0800
Message-ID: <20250325135155.935398-2-ming.lei@redhat.com>
In-Reply-To: <20250325135155.935398-1-ming.lei@redhat.com>
References: <20250325135155.935398-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Add helper of validate_fixed_range() for validating fixed buffer
range.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/rsrc.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 3f195e24777e..52e7492e863e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1002,20 +1002,32 @@ int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
 }
 EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
 
-static int io_import_fixed(int ddir, struct iov_iter *iter,
-			   struct io_mapped_ubuf *imu,
-			   u64 buf_addr, size_t len)
+static int validate_fixed_range(u64 buf_addr, size_t len,
+		const struct io_mapped_ubuf *imu)
 {
 	u64 buf_end;
-	size_t offset;
 
-	if (WARN_ON_ONCE(!imu))
-		return -EFAULT;
 	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
 		return -EFAULT;
 	/* not inside the mapped region */
 	if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->len)))
 		return -EFAULT;
+
+	return 0;
+}
+
+static int io_import_fixed(int ddir, struct iov_iter *iter,
+			   struct io_mapped_ubuf *imu,
+			   u64 buf_addr, size_t len)
+{
+	size_t offset;
+	int ret;
+
+	if (WARN_ON_ONCE(!imu))
+		return -EFAULT;
+	ret = validate_fixed_range(buf_addr, len, imu);
+	if (ret)
+		return ret;
 	if (!(imu->dir & (1 << ddir)))
 		return -EFAULT;
 
@@ -1305,12 +1317,12 @@ static int io_vec_fill_bvec(int ddir, struct iov_iter *iter,
 		u64 buf_addr = (u64)(uintptr_t)iovec[iov_idx].iov_base;
 		struct bio_vec *src_bvec;
 		size_t offset;
-		u64 buf_end;
+		int ret;
+
+		ret = validate_fixed_range(buf_addr, iov_len, imu);
+		if (unlikely(ret))
+			return ret;
 
-		if (unlikely(check_add_overflow(buf_addr, (u64)iov_len, &buf_end)))
-			return -EFAULT;
-		if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->len)))
-			return -EFAULT;
 		if (unlikely(!iov_len))
 			return -EFAULT;
 		if (unlikely(check_add_overflow(total_len, iov_len, &total_len)))
-- 
2.47.0



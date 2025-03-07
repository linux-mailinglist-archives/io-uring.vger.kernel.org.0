Return-Path: <io-uring+bounces-7006-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F3112A56D7A
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:22:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0156C7A31F3
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB82523A9BC;
	Fri,  7 Mar 2025 16:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZGpWmiG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49B6238D22
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 16:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741364522; cv=none; b=pj17kSu55sZROnpkFrbBOgxSIzKXRg/4UbaZA7hs7mABayWztG/VwzzXd3Jy1Mr9GDCMsNnyOdbVLDZNcfGtJ/we/BXOCFs2yObryzOO26jYpRloEgAmD1PU8g/U4fWfLCB7zPnev7AfehH+RbrJ0lSHskQ5BHe5Bd3Rs4KwNAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741364522; c=relaxed/simple;
	bh=zmb2k6k6jgV2K1wnuxoBBaYJ6Ngox0NmxaYiJP8PoMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVLPl/caeBRx8kbg8PDhnUZ2izsoT3Qx6hEszS4qbVaf4M9yJrG6SuBUu5qvVBosNXA1WyFFW/eV/4r6DfieeYHMN+7m80ED6EUN67aBdYY/HIORH4aZF9ywIOGBgDBIwsxnCbBhZ4wrNm3oeK965kdFiEwQMTtxzHL71K7Ifyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IZGpWmiG; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e033c2f106so2005944a12.3
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 08:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741364519; x=1741969319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w+ZdpBqb28yOU5hmh13mX3JRPokuYrGgCWaPXJUGppQ=;
        b=IZGpWmiGdcEUcg0rQZXyGyNprkDLpiO156pfy3CdY8JfWsSBkXGaHhBTdz1AVb0WKC
         c2ExX/RVjK4D785O9ISCslrqDRa3ohpB8OGn7ZGRvHrGa0KuYEWGMNfa7nmDBtyWY1U0
         4XonFyynCBuJNRuwYI/+NZ2su6GBh/tZCQ0nZpG0gUDDgDi3PCq97up8Tv0PpTsdjwSH
         ZZQmjY/3vgFH64WiyX8jBWD0mRj3eAKTUL285ykcQR8BqDs+iI2EoJJBnLeGApFoxYb3
         FEoKpdfJX6oHERV2/jzD14vlivJWPU9YRkMXBk3DH85Nl8/nd4PAP6UZ2x+rN9Z9UT+b
         nG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741364519; x=1741969319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w+ZdpBqb28yOU5hmh13mX3JRPokuYrGgCWaPXJUGppQ=;
        b=ZMd9kQRzCRLYwh/6KyA5jsAsR/ZfqFr/KzLd3su+a5YOgdWqE8bJOAyd888MCIPqR5
         WE5kpQHk2hWTHG4nUTyMqWV8hkU/V+iI8xKvUX+PphZI8aMs99sbvfzqE6iAvEU2uABo
         FHUrlo8mDM2YQxu6LPs/ZnJa1jI8SOK3mb+Nax6lJkyq/3lZHNunDhsFGpGcKuqCvUO2
         QgFqGr8PxKF3dxYJNSS4DcOKoX7FgYCmE/GQblV+Dz5EhTTKxVgqnIlYTzblKYIQHI/o
         bEJcDKLv1p9WdH+SAI3JDb0Cc4oZ/LiHWho5tC5hHQlijoEuy9Ov2uIJ0AU52TLIgqFl
         DEag==
X-Gm-Message-State: AOJu0YxeXnEiTwsKQ1BQ4t15Z7Kr8zjuxHprDGZ1u1wC+eNIsEW2/QPx
	3a+O6B3nEz2HzgU71S2EthiqBzU+JrkfbEHhfqROsB2Ha0sZhIP9BzMHiQ==
X-Gm-Gg: ASbGncv4S4Ty2/4MALRqJulX42rbKdDF1ArcyfV5VnZAdD7ngWf0ajc6IkNv98zImCK
	4giINwedydoV4L1IUcJAtFPmMOsJ2T7+XGIhGj4z4S3eC3Ld+R7OV2U+UHZnykoVVVcjbQBhCdN
	uZx9aA5YsnZpHdh9umyEXtpTLQdKK66x+DUnRPFY57C8Wx0f/G7AXILTkuFoLZdk/gcG/qifHk8
	cUj8T7JOZBRc/CTOF7B4x6gilbUrWzVftilXgwlWS/unKgukZO/ZeMy55ErVSz8ZTOLpf/R8UGo
	NLVj3Ixech++Z0m6bDO8BFSv7J6r
X-Google-Smtp-Source: AGHT+IGDR6M2wTVheQJRxRnyagxDN3e4IurwiKktTb3igXAvunzpX6nLw7wgraoUknqHkGtj8wqh+g==
X-Received: by 2002:a05:6402:42c2:b0:5dc:7374:261d with SMTP id 4fb4d7f45d1cf-5e5e22a3716mr8278479a12.7.1741364517280;
        Fri, 07 Mar 2025 08:21:57 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:a068])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac239438955sm300566166b.19.2025.03.07.08.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 08:21:56 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 1/4] Add vectored registered buffer req init helpers
Date: Fri,  7 Mar 2025 16:22:43 +0000
Message-ID: <60182eae68ff13f31d158e08abc351205d59c929.1741364284.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741364284.git.asml.silence@gmail.com>
References: <cover.1741364284.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index d162d0e6..e71551ed 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -556,6 +556,16 @@ IOURINGINLINE void io_uring_prep_read_fixed(struct io_uring_sqe *sqe, int fd,
 	sqe->buf_index = (__u16) buf_index;
 }
 
+IOURINGINLINE void io_uring_prep_readv_fixed(struct io_uring_sqe *sqe, int fd,
+					     const struct iovec *iovecs,
+					     unsigned nr_vecs, __u64 offset,
+					     int flags, int buf_index)
+{
+	io_uring_prep_readv2(sqe, fd, iovecs, nr_vecs, offset, flags);
+	sqe->opcode = IORING_OP_WRITE_FIXED;
+	sqe->buf_index = (__u16)buf_index;
+}
+
 IOURINGINLINE void io_uring_prep_writev(struct io_uring_sqe *sqe, int fd,
 					const struct iovec *iovecs,
 					unsigned nr_vecs, __u64 offset)
@@ -580,6 +590,16 @@ IOURINGINLINE void io_uring_prep_write_fixed(struct io_uring_sqe *sqe, int fd,
 	sqe->buf_index = (__u16) buf_index;
 }
 
+IOURINGINLINE void io_uring_prep_writev2_fixed(struct io_uring_sqe *sqe, int fd,
+				       const struct iovec *iovecs,
+				       unsigned nr_vecs, __u64 offset,
+				       int flags, int buf_index)
+{
+	io_uring_prep_writev2(sqe, fd, iovecs, nr_vecs, offset, flags);
+	sqe->opcode = IORING_OP_WRITE_FIXED;
+	sqe->buf_index = (__u16)buf_index;
+}
+
 IOURINGINLINE void io_uring_prep_recvmsg(struct io_uring_sqe *sqe, int fd,
 					 struct msghdr *msg, unsigned flags)
 {
@@ -964,6 +984,17 @@ IOURINGINLINE void io_uring_prep_sendmsg_zc(struct io_uring_sqe *sqe, int fd,
 	sqe->opcode = IORING_OP_SENDMSG_ZC;
 }
 
+IOURINGINLINE void io_uring_prep_sendmsg_zc_fixed(struct io_uring_sqe *sqe,
+						int fd,
+						const struct msghdr *msg,
+						unsigned flags,
+						unsigned buf_index)
+{
+	io_uring_prep_sendmsg_zc(sqe, fd, msg, flags);
+	sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
+	sqe->buf_index = buf_index;
+}
+
 IOURINGINLINE void io_uring_prep_recv(struct io_uring_sqe *sqe, int sockfd,
 				      void *buf, size_t len, int flags)
 {
-- 
2.48.1



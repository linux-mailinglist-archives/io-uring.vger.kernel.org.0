Return-Path: <io-uring+bounces-9736-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C4A5B5305A
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 13:27:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C58C81CC0811
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 11:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2820231B10A;
	Thu, 11 Sep 2025 11:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V12gVCIV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A4C314A65
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 11:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757589911; cv=none; b=Oh01WYUe1Q+uPjO6PP5Vu1UzoTZ0igelXH6nskMHDWnJ1ftqXWDFA/HoHpvaF7+rFwe2HBurywafEtpmW9t1Sd/MnJRTWR2N8RxQCzP5YunsrY/de8URVGXufccZOqH413WhoAaIm7MLk9zvYAmXZ2u0hfPPIFQyhDn0nBXkYXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757589911; c=relaxed/simple;
	bh=5XuQ8VaE67TpGZ5WjkPTbOlpZnxpccqHxRdfbIgFzLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tylt4XlhO/BcOxeIDs4q8oqJIUefbsxTWIcme26gN6ZUSpRNFs0GOAXHDoCyCHtKgS+IesK/NPEGeBtGE2Lt9SZmS5p98nnqn4PgHiSKwm+rFYIGbLZbHsToBbuydtjp8W74sIa98HQRIvSJOnIQZQfnYe6GQzZvPoexAfTrtQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V12gVCIV; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3e4b5aee522so440986f8f.1
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 04:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757589907; x=1758194707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lyURyFLlIcE0EIVxVbuW9MYl0vDydlg8Li3EXn8Fa/A=;
        b=V12gVCIVtuHfJlw0xv9b2mHkpZwQDecZHTOdnWrmkFUJlbnvALimdpj8Ca74yRiLDq
         CXlovGIoWo9wpjT22gWMg2nmm+PxQGTe1UHPG7JhwhhJPT+8fE8ht8BACgjofM9SeDzf
         knXQOSr7vSmijnXSvjmGx3go0EO/Z0o/ehZ7bGOGifcSUS8+TQwGo2WOdJfXZfKhBAmA
         21+41+QRNPQKA2G8/4UbTe4PRs+zU+NK9PQTg0PM5jJTG6M9XCBcOKBbM0ym/efCUsAf
         bzygY7dhns079IJT97/tnRDW8ae0SsO2UE6fOvMUxvfq+gphaHtSZX7usM0dw3NlWBZd
         CwUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757589907; x=1758194707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lyURyFLlIcE0EIVxVbuW9MYl0vDydlg8Li3EXn8Fa/A=;
        b=kdYYQ8L47VIYNGYi6JlXVMZRrnVLLvrdAMsHzjeiSSugNS1kQgoRCaSch5SmT5qUz7
         2BNilbS7V4Pqy8xZTxn8oc76wuVtVYHCFJxgJpSjfeLEexoKD887Mv8FDkJ9MFxmtalM
         ytPiigYmRjax6N4k8iWw6EGXIU1NvJ3MudXvIagh1Fm8n8zYshhc/Yn9gRwpBGcLivc2
         2vmzgUAEIEbA3ymGpSslQAl0c7d2iwgW3d9q6c83q+dFhQL9TEbF0LAVsHDMu7adUzhy
         zIFxRqJKI15i1XQ5xUp/kb/gUDhJvjKfcrj9Zyz29gVbpK6orEJQ44Ll2rgFFV3/49io
         fikA==
X-Gm-Message-State: AOJu0YyRxOUTisp+71C7BT9rvCf5OJ62cBXFRMuWLrG5vEze+SGQxSAh
	tKYMxezeQSDFQQq6p0sbfB9cwrDZpaVZTYXfZOevK+YyL7u93MG7lV1tBbHubw==
X-Gm-Gg: ASbGncufWbQx0OU4LBKJ4+APnt56U8iCtAkyTm0GENALjNg2dJFEYRuBy75UWBUTcq6
	B4SydrzbENpRgO7eju/qdc09x5Z7phMEsDzsJHbck4s7Hw0fl0DnnZ0lrYYQZ1J2S5K8wg3Kz7E
	G0nX4ga7drxetwzeswA9+FNBkMHf0XZ3Zc/+30jjiNNrtfJsZ6b9vSDcIOlCdEQUSW550vhoyqM
	RRERNWjQmPOCw4i6Mp0ABgaxYYd0QzS91kZkbqeKe/QSzxWxg68xkB5MQZ+UfcPBTvkVUZSj6n+
	DetT8BFBN2a75Jj7RMO918urz3Rc0lZ4YbOW6w54UnlDPTyxrLPXnywQvrw3eQ5V2ZP25P/CKpe
	UESPDVnnZg1IhEGMw
X-Google-Smtp-Source: AGHT+IFmeU/bMrD38S7lL7GQ/11+Lvgo/+yH5hXVWy3zp8GdCE/KXqpM2XkTaWuTpu6vOS1L3OsHWw==
X-Received: by 2002:a05:6000:4701:b0:3e7:41bf:e5f2 with SMTP id ffacd0b85a97d-3e741bfeb34mr16189110f8f.15.1757589906834;
        Thu, 11 Sep 2025 04:25:06 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a309])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607d822fsm2095608f8f.53.2025.09.11.04.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 04:25:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 5/6] tests: add helper for iov data verification
Date: Thu, 11 Sep 2025 12:26:30 +0100
Message-ID: <85ec39ae2040270bec7ac991e7689fbafb36a259.1757589613.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1757589613.git.asml.silence@gmail.com>
References: <cover.1757589613.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/helpers.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 test/helpers.h |  3 +++
 2 files changed, 47 insertions(+)

diff --git a/test/helpers.c b/test/helpers.c
index 15ceb17a..83a128e3 100644
--- a/test/helpers.c
+++ b/test/helpers.c
@@ -536,3 +536,47 @@ size_t t_iovec_data_length(struct iovec *iov, unsigned iov_len)
 		sz += iov[i].iov_len;
 	return sz;
 }
+
+#define t_min(a, b) ((a) < (b) ? (a) : (b))
+
+unsigned long t_compare_data_iovec(struct iovec *iov_src, unsigned nr_src,
+				   struct iovec *iov_dst, unsigned nr_dst)
+{
+	size_t src_len = t_iovec_data_length(iov_src, nr_src);
+	size_t dst_len = t_iovec_data_length(iov_dst, nr_dst);
+	size_t len_left = t_min(src_len, dst_len);
+	unsigned long src_off = 0, dst_off = 0;
+	unsigned long offset = 0;
+
+	while (offset != len_left) {
+		size_t len = len_left - offset;
+		unsigned long i;
+
+		len = t_min(len, iov_src->iov_len - src_off);
+		len = t_min(len, iov_dst->iov_len - dst_off);
+
+		for (i = 0; i < len; i++) {
+			char csrc = ((char *)iov_src->iov_base)[src_off + i];
+			char cdst = ((char *)iov_dst->iov_base)[dst_off + i];
+
+			if (csrc != cdst) {
+				fprintf(stderr, "data mismatch, %i vs %i\n",
+					csrc, cdst);
+				return -EINVAL;
+			}
+		}
+
+		src_off += len;
+		dst_off += len;
+		if (src_off == iov_src->iov_len) {
+			src_off = 0;
+			iov_src++;
+		}
+		if (dst_off == iov_dst->iov_len) {
+			dst_off = 0;
+			iov_dst++;
+		}
+		offset += len;
+	}
+	return 0;
+}
diff --git a/test/helpers.h b/test/helpers.h
index 7dafeb17..cfada945 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -126,6 +126,9 @@ int t_submit_and_wait_single(struct io_uring *ring, struct io_uring_cqe **cqe);
 
 size_t t_iovec_data_length(struct iovec *iov, unsigned iov_len);
 
+unsigned long t_compare_data_iovec(struct iovec *iov_src, unsigned nr_src,
+				   struct iovec *iov_dst, unsigned nr_dst);
+
 static inline void t_sqe_prep_cmd(struct io_uring_sqe *sqe,
 				  int fd, unsigned cmd_op)
 {
-- 
2.49.0



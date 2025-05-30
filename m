Return-Path: <io-uring+bounces-8143-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20A53AC8FA2
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:17:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D0683B5C3B
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 085431E515;
	Fri, 30 May 2025 12:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ei6/SbwV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A82D22CBE4
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 12:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748609461; cv=none; b=UOctVYDXUkj1n4X6mxyLBohVOZ3StdHT1nvL5/DbrgX3GQMP5s4Iit+nTSSfrm/a2ylQcoe6Y5dmC0LuqRXxhBaJIpeDkbg0f6qG4kXor8xnGqG9wCM70wgMfgOLgsOsvwvvk+1LDzJXUgpV0K8hRunImfT3XXV1oFNStSL4+Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748609461; c=relaxed/simple;
	bh=kHubcvSvecSgL5DooV85TQ500shNsdvSbuUZqaNTKN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiYrPkP9XCgrMFo1M+Ik5Cly5TU6GP0tC3I4otXJKBtEMiOfBya/aQHcCscf+o0klNJ+Kj1idT06Kcz+l/m+mOgiCYaKfeNtBBnPA+4BrhaptNvBiyU0C3Wu4WNOakdg9ZfFVU1B+6RDHVz9sTSyJlefTRwbYJ0MDajB5zJzKuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ei6/SbwV; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ad88105874aso305667066b.1
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 05:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748609458; x=1749214258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tQTTsPmT14Xfl2ItEFuazQilNOTxMgLTDnf7VIP8gxQ=;
        b=Ei6/SbwVsJC1k4jF1cpzsItogb7GFNlQY97pI57IHM5yptAsFk5zpQhSoQTjT1wI6F
         CB2xYjUVY6EvcufiDuF8nAfFn37g/zzHEAW/KwWInjfDDNz/YgKJObDgmeKJFTkr3DYH
         8+PbZ6yGD82znLbiZ3QCGHNM3hYj06RBMwUJwItQECCUklduDAnMPahzrHZjacFquzge
         DJqBMeX4EbPj1eqi1TiFNNY4yNIX5KPiS2fNoHL5VVEBpViu9eEYdCgbZbIq33fFiPct
         C0pMzs49SM5m3Mbg3cs1j0lpk1QMau7OeS+94adnE0GodZE56WCKVnhOOM3Tgu1bCeaE
         DQrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748609458; x=1749214258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tQTTsPmT14Xfl2ItEFuazQilNOTxMgLTDnf7VIP8gxQ=;
        b=FFaOYCshf3vYT3J5sSLzAP/4b5S9xaXl1GY3MNhiPOSjwzEBhPqfnLL5/EI8mfBxVi
         64ofmwYjzONXxxaeZjHJJ6O0cY+CrMBaSQ2VwzvetZMdbLiAjKS/jZGIQqY0bp36QPXr
         sHMF+2nWr5t3wl65VFMZERi83NbXkD4QoFdbvKPHuoU3U5q3lYVC4DIKPwZYuVpUJUPF
         1/Nllo6mzxkym9Ex8LKHH2hps6K8wSAmWp/S6NtEca9fYo/bhGWKhtrhbOWldTLjoHLE
         7uiS46zrv63y4rsmWZ53Te+Cw2il3JXvALsZ52eC6I99u1xEID7esdwheBlc7ek/JdnP
         dvRw==
X-Gm-Message-State: AOJu0YwbOVqsRLtZiE/n4e7dJSaAkuBo6MlxYpWrpb3bnyx4obJmdvyj
	qS88cxZKDve66hWc4J40vJ7yprdOGOG5CE+sv0ItKilHH+h/VkJP0Wrag01eDA==
X-Gm-Gg: ASbGncvzNI23jPYvEgwKrpYkVg/yZgKNJqXDPx1yTeMcQBkPi6PCNsb6Dw8JeK9SGwb
	0VP5zjR3XOMgbAp3G/huESJ56o4BUz8RAsN8nNCZXqkV4DJp0WfQRXVMYushas0LHPYW3jzpEAI
	CH+nchG5LQCy34QxCGv7jqnvxTYw3hFN9m6eQ+fctWvJQnFMDoqxJRUEogF+UvMzZ3kO9Br7nzT
	Ezk4u2ATclzufI214yahqOUDOr85JdijyJdIWrIEzzC35hiHbL8sHMAvu72LxNOCX+zF9DskyBh
	kSVnN4HdRYepmWPSSVHC7ARCwLd4viVOR8piC+r+FNMJxg==
X-Google-Smtp-Source: AGHT+IGsurrsVpXxRtGazu5FPdozPCUWDN/7nRy4EWIvpHayfjI1SsrXoZKJsBIMFa6LVSejgyRP2Q==
X-Received: by 2002:a17:907:1c92:b0:ad8:9b2c:ee21 with SMTP id a640c23a62f3a-adb322b344cmr263475766b.2.1748609457802;
        Fri, 30 May 2025 05:50:57 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad39420sm323234266b.136.2025.05.30.05.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 05:50:56 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 2/6] io_uring/mock: add cmd using vectored regbufs
Date: Fri, 30 May 2025 13:51:59 +0100
Message-ID: <a515c20227be445012e7a5fc776fb32fcb72bcbb.1748609413.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748609413.git.asml.silence@gmail.com>
References: <cover.1748609413.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a command api allowing to import vectored registered buffers,
add a new mock command that uses the feature and simply copies the
specified registered buffer into user space or vice versa.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/mock_file.c | 70 +++++++++++++++++++++++++++++++++++++++++++-
 io_uring/mock_file.h | 14 +++++++++
 2 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 3bb5614c85f1..4982f71a3a9b 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -9,8 +9,76 @@
 #include <linux/io_uring_types.h>
 #include "mock_file.h"
 
+#define IO_VALID_COPY_CMD_FLAGS		IORING_MOCK_COPY_FROM
+
+static int io_copy_regbuf(struct iov_iter *reg_iter, void __user *ubuf)
+{
+	size_t ret, copied = 0;
+	size_t buflen = PAGE_SIZE;
+	void *tmp_buf;
+
+	tmp_buf = kzalloc(buflen, GFP_KERNEL);
+	if (!tmp_buf)
+		return -ENOMEM;
+
+	while (iov_iter_count(reg_iter)) {
+		size_t len = min(iov_iter_count(reg_iter), buflen);
+
+		if (iov_iter_rw(reg_iter) == ITER_SOURCE) {
+			ret = copy_from_iter(tmp_buf, len, reg_iter);
+			if (ret <= 0)
+				break;
+			if (copy_to_user(ubuf, tmp_buf, ret))
+				break;
+		} else {
+			if (copy_from_user(tmp_buf, ubuf, len))
+				break;
+			ret = copy_to_iter(tmp_buf, len, reg_iter);
+			if (ret <= 0)
+				break;
+		}
+		ubuf += ret;
+		copied += ret;
+	}
+
+	kfree(tmp_buf);
+	return copied;
+}
+
+static int io_cmd_copy_regbuf(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	const struct io_uring_sqe *sqe = cmd->sqe;
+	const struct iovec __user *iovec;
+	unsigned flags, iovec_len;
+	struct iov_iter iter;
+	void __user *ubuf;
+	int dir, ret;
+
+	ubuf = u64_to_user_ptr(READ_ONCE(sqe->addr3));
+	iovec = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	iovec_len = READ_ONCE(sqe->len);
+	flags = READ_ONCE(sqe->file_index);
+
+	if (unlikely(sqe->ioprio || sqe->__pad1))
+		return -EINVAL;
+	if (flags & ~IO_VALID_COPY_CMD_FLAGS)
+		return -EINVAL;
+
+	dir = (flags & IORING_MOCK_COPY_FROM) ? ITER_SOURCE : ITER_DEST;
+	ret = io_uring_cmd_import_fixed_vec(cmd, iovec, iovec_len, dir, &iter,
+					    issue_flags);
+	if (ret)
+		return ret;
+	ret = io_copy_regbuf(&iter, ubuf);
+	return ret ? ret : -EFAULT;
+}
+
 static int io_mock_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
+	switch (cmd->cmd_op) {
+	case IORING_MOCK_CMD_COPY_REGBUF:
+		return io_cmd_copy_regbuf(cmd, issue_flags);
+	}
 	return -ENOTSUPP;
 }
 
@@ -85,7 +153,7 @@ static int io_probe_mock(struct io_uring_cmd *cmd)
 	if (!mem_is_zero(&mp, sizeof(mp)))
 		return -EINVAL;
 
-	mp.features = 0;
+	mp.features = IORING_MOCK_FEAT_END;
 
 	if (copy_to_user(uarg, &mp, uarg_size))
 		return -EFAULT;
diff --git a/io_uring/mock_file.h b/io_uring/mock_file.h
index 8b00045480cd..8475dfd827e9 100644
--- a/io_uring/mock_file.h
+++ b/io_uring/mock_file.h
@@ -3,6 +3,12 @@
 
 #include <linux/types.h>
 
+enum {
+	IORING_MOCK_FEAT_CMD_COPY,
+
+	IORING_MOCK_FEAT_END,
+};
+
 struct io_uring_mock_probe {
 	__u64		features;
 	__u64		__resv[9];
@@ -19,4 +25,12 @@ enum {
 	IORING_MOCK_MGR_CMD_CREATE,
 };
 
+enum {
+	IORING_MOCK_CMD_COPY_REGBUF,
+};
+
+enum {
+	IORING_MOCK_COPY_FROM			= 1,
+};
+
 #endif
-- 
2.49.0



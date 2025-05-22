Return-Path: <io-uring+bounces-8082-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17C63AC0F7B
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 17:09:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB1273A4D0C
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 15:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DCC828FAB3;
	Thu, 22 May 2025 15:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QmGE/v42"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E3528FAB4
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 15:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747926553; cv=none; b=UAxDazOKv1Xv5p97fd+bfUn1yesVf6U563POzb2W74OVG88gLi6/D+GWfK15FYHo7DAoEFXHsSoOG+dg5eaMNdDnxq5DabKzrL8+Q6ie4n7lSfeeLjSO2Usvi0CdProyIHtECYkCJ3Qfd4UaBiHDxklctRavY65XHoU3bM+JveY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747926553; c=relaxed/simple;
	bh=eyxqpK6FRJTahvxxphrmuc0W864m7epPZETZ35fIfIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmDVR7UG0UOO1QcEXE8KcTtusNiCtpsxsE4j0dGBqhzyae2rk779l3nGt0RRX21AqtKXYi2/gfMXA1be26xp9H3rmCtP+5Ni0PzcTyPb5A3CB7w6h5I3tPZAfffg+HZGNBeP1VVH68t/CRjQi2bNQDF8hMT2sXt4ZXWcuDSofLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QmGE/v42; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-601968db16bso5608615a12.3
        for <io-uring@vger.kernel.org>; Thu, 22 May 2025 08:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747926549; x=1748531349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ENAiHuBeMMzfkS/36xEAW1XS4gLtTCQb+XC1mn1Wgw=;
        b=QmGE/v42sDkkFemMj38H24IfYsfs+LYwfQGKd401HJ2ynqEC3vKPwuRc2OIuKYFF/r
         iuwle6xtkAWYpoGvDs46wrAACTgl14kod/uUP8W6bURxa1a5kBfmEOd8kMnz2b/ySZBG
         h0mjSH1vaIATdB3OAim2XH/k0N8vp4h7h5pklKH+sa0KnB0fKwawh6MPKOsYo64zReR5
         cGYOGk0MhY0zK62kqHY+ca9U4639GSY8MDenkvivHeQH8pgkEYJ8+BiSAIiKfp8sitjZ
         MDt6hmCCtk53wtOCwI9/p5VF24KzQPeO2+SLEIJ+h58TeGBxrXItg1Hfl7XvYGMGwpzS
         17mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747926549; x=1748531349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ENAiHuBeMMzfkS/36xEAW1XS4gLtTCQb+XC1mn1Wgw=;
        b=OJpBXdcpNbj0Waf72ORsiINolnce0OpXoqJzaUQOq1Dt+6SDwI812VKoNhnsVhlU9E
         +QoOOJ2py+rg3taTJYYa2gJqgnqnmNNwyqlwgzdNUDEDVY7fbTyMehc7IViEPD+FF0Ve
         OICx+w/D1awY2p+8Kbfu5wOWTZ3qzMjTRTSX0uR1fwM0H7B48rZLiqcS5HqMm/nRtfDB
         171O+Tl7IOTiiMu/cFpiju+giOy+u0STki1HgLTM2CvFBYhMOPEZqV5PcFiaymJFCvaA
         5VvydgttqQ41FZt/j+a9npRFvekaQZRqTaHsjzoc6B8Su33Y1KvFe/jqRaqZji4kba2E
         dWHA==
X-Gm-Message-State: AOJu0YxfDKtSwnAyCs5UQHFguwFFWqSenjH5IpBBJf6WTMe0tg88R5wB
	QXP0WmU/ZnKTXpQSzRjthhBOwB2foymREk5H9zQjzpCy8pmELK/qla2bydoPJw==
X-Gm-Gg: ASbGncsJm8F36ZezcbsTAvS26hSE0NU+JkXX53409BKzJz7AuoSw2FIbMrhIvJzyQLY
	rtty5CJCQrpCkEsW380Gz6Dboacp0vcBPMqU44tD/n8xej3mkhhVXsZTkGq4oskBrcFFe/4Y3lc
	tO2Sq07LsfaHIwga9ql4bo2mxSB+tfaTonypgm+aUcteYzCM/UnUvnfChJTdeTLDxyz+zrgXmvb
	EDwJdAvWmUeyAfqsfQZvXn6kDUuQk0R8jEn4sumfEbooGV1tb6dNTxWasT/mIV/1dQBMsrYqPsE
	BPzuv1LkI+mWE+N6rJnWXf5GcqpdwT3tWVeC4Scsx2QSYA==
X-Google-Smtp-Source: AGHT+IFnNKISr44XFNZzu6tYt2+m7urMuUJCGoQKXJOF8syVNv6zeMScYXMpFdYJUwDFKbj3QiBohg==
X-Received: by 2002:a05:6402:26d6:b0:602:1061:5eaf with SMTP id 4fb4d7f45d1cf-60210615fe0mr9127757a12.21.1747926548945;
        Thu, 22 May 2025 08:09:08 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:30e5])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6005ae3953esm10684305a12.73.2025.05.22.08.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 08:09:08 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	chase xd <sl1589472800@gmail.com>
Subject: [PATCH 2/2] io_uring/mock: add cmd using vectored regbufs
Date: Thu, 22 May 2025 16:10:07 +0100
Message-ID: <516566d6628035bae59ee562dafcb05e7a55d402.1747922436.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747922436.git.asml.silence@gmail.com>
References: <cover.1747922436.git.asml.silence@gmail.com>
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
 io_uring/mock_file.h | 12 ++++++++
 2 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index e8ec0aeddbae..45fc5c9f939e 100644
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
+	mp.features = IORING_MOCK_FEAT_COPY_CMD;
 
 	if (copy_to_user(uarg, &mp, uarg_size))
 		return -EFAULT;
diff --git a/io_uring/mock_file.h b/io_uring/mock_file.h
index de7318a5b1f1..9a6f47bab01e 100644
--- a/io_uring/mock_file.h
+++ b/io_uring/mock_file.h
@@ -3,6 +3,10 @@
 
 #include <linux/types.h>
 
+enum {
+	IORING_MOCK_FEAT_COPY_CMD		= 1,
+};
+
 struct io_uring_mock_probe {
 	__u64		features;
 	__u64		__resv[9];
@@ -19,4 +23,12 @@ enum {
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
\ No newline at end of file
-- 
2.49.0



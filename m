Return-Path: <io-uring+bounces-10141-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C617BFE262
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 22:23:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DEB94354BF9
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 20:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8073F2F9D83;
	Wed, 22 Oct 2025 20:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hgiTv4H1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC782FB085
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 20:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761164599; cv=none; b=jObyVAUgNDZZAjw+zI9HiyH1JdOkueBUQ0W75UxoSRovQk0f7OmJreJ4yUvEltCKVfybYb7uE6wuVzxtcJMXyXq7DbsShZf3YazWdcDdJ2f8lsOcvWG0DIfjw7Rtc+RMz1Lqaz7so57ZnfFdP4QAZ275W6o2ShocpKv5IbBmJdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761164599; c=relaxed/simple;
	bh=5mGTHKsXQv408pm5SoqLD5GoewsNp5Bjs5WKt6tWBYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rc9/er8K7ssNocTudQkFHc8h/ec5bPDwv/luhVLg5HHLPB6CVRFI2AlYWuqaL3RVp7+jX2M1WCL4wTjYOwG/bt/oIE5FPTn9d01FQF7+8SAuqGFrsRhehojDDWWm8NhzJ7/WENuHselJ/LDGU90Va20vs+VAQBRxne+B3KlquPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hgiTv4H1; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7a23208a0c2so60517b3a.0
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 13:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761164589; x=1761769389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FMrDgkreuMkwxyjlwV8UKQbwsl/RgFlAftkbtcC6Jgk=;
        b=hgiTv4H1D6AjTUnuGSqK6jb4jzg2ToW4SNNG81472A2HgVKWOTsEfN976GSjE7ZNxV
         tbUZMD7QQNNzaIIeOjhrqMJFsAvrWVbJsuI4ySd8B9NEtosETYV6oITKAfZsA6IFOr7g
         /DfoSd85phMw7PlxpURFPpcj++hRQqzLO9iPleCbr2i0k/JdIYSDur4TW5Tk8SxdA5Z3
         DKo8apxwSp+2W74YgQa8tH9xixwVpMBx+NGb8LM0eJIHZE5To2CAXqzKDIDvNEB9SI8C
         sf6RNjfgyJKd2zAyXvCojIcYmvy0K0EzsLXMUKKOXF2WhSf4p/hvT6oFWd0bcjGwD+J5
         tkzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761164589; x=1761769389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FMrDgkreuMkwxyjlwV8UKQbwsl/RgFlAftkbtcC6Jgk=;
        b=GoRh0MD9qrKxdHbTp4R97cuEvzAD4/w+uooHpD8/P+XpMutjHtlJBvJ+JeEInfmzZ7
         kJQ9BrzAM7OK268ZBxyELUL8BPj/dSRe/DstO7Xa1MpOuojqmWCQYY5Hrb95e2joHStG
         ce4Knndr4K9B+5X7nnzS0vmYn0ZCdUqgnl2bsdoWGG17kCdDmYGSCB/mpk/cUqzE2tu/
         p1yUA1Rxb0GkoxzyqiywH8Yl7FCSFWpkQDdam5su/VE8NF5i1r29BT1nR37Y/6W5BpOU
         rJ9CB89yoHurtY5H7gWEnK1V+m+TWpbp2zIhDMg+qkCXwz+JDgN5TdYmXvmO5kdLecM7
         zaaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWMGUGR85gKuprbA9r0nCTEvK34bI5pg80AxK9BtM/ydq7MkOML37gVGjvdeiLcVxIqRVZayYl4Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5wgNga5unPxr1bH5befe2f2AkcIUFTYnoA71KrpaYUH4TgAlu
	uTfftZBayOu2sOemZcJ5t8SKBgsIfP8gC4JJ1FVG0jmCp39qDNtjUQfu
X-Gm-Gg: ASbGncuRJ/Hp0juYKhDfvQ1k6QrC6R6Z1QMroceLahiGiRmobr7rGfUAcGgwG8UNVts
	7t9LrFSYgMr4IxggevGAIlkTb5U+fAvvemRK4DAWCZWIFhw3tiyNSZ7MfYkYzLx3oPt64rWs+LI
	8UD7SrTc3XG25AnyyQCqWYYg0qccPV9Tk86XizteBhJXR3cEZKzEprM9dlK+KfQTjUG+B0NujVw
	MLkr6sPMWwCU3sg2FUsJFpPnHKqax704Xud9Suenlg1T4RLBuydY+bPeN0QRpbF/wOD5fN0gWrZ
	nMVJeo5eYcYKBzmjdphSlh1MI4xYQU0ZnnBxOgq3aMEB3Y9xhPgwWQO65kXi9BReFM2KxckFzY5
	xs81FsQso2SY0A8CD8SdBkkCeeLeDvZ+ELBWz1ABLvh3jxRE09jw4CaunQBmcHPxqhGJdGLC7nh
	PYTDMOAqe5OILvwjahEW6mkKILjKQ=
X-Google-Smtp-Source: AGHT+IFqN567FI5QsK8lZuMHHcMGHghKlmdWXCLA05arSr2M91d3jOjl5DkbcgOAUFVUVgzE3GNY8A==
X-Received: by 2002:a17:902:f64a:b0:269:9e4d:4c8b with SMTP id d9443c01a7336-290ca403110mr272080675ad.21.1761164589389;
        Wed, 22 Oct 2025 13:23:09 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:43::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33e2247a34esm3444453a91.15.2025.10.22.13.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 13:23:09 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org,
	bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	xiaobing.li@samsung.com
Subject: [PATCH v1 1/2] io-uring: add io_uring_cmd_get_buffer_info()
Date: Wed, 22 Oct 2025 13:20:20 -0700
Message-ID: <20251022202021.3649586-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251022202021.3649586-1-joannelkoong@gmail.com>
References: <20251022202021.3649586-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add io_uring_cmd_get_buffer_info() to fetch buffer information that will
be necessary for constructing an iov iter for it.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h |  2 ++
 io_uring/rsrc.c              | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 7509025b4071..a92e810f37f9 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -177,4 +177,6 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
 			      unsigned int issue_flags);
 
+int io_uring_cmd_get_buffer_info(struct io_uring_cmd *cmd, u64 *ubuf,
+				 unsigned int *len);
 #endif /* _LINUX_IO_URING_CMD_H */
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d787c16dc1c3..8554cdad8abc 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1569,3 +1569,24 @@ int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
 	req->flags |= REQ_F_IMPORT_BUFFER;
 	return 0;
 }
+
+int io_uring_cmd_get_buffer_info(struct io_uring_cmd *cmd, u64 *ubuf,
+				 unsigned int *len)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	struct io_rsrc_data *data = &ctx->buf_table;
+	struct io_mapped_ubuf *imu;
+	unsigned int buf_index;
+
+	if (!data->nr)
+		return -EINVAL;
+
+	buf_index = cmd->sqe->buf_index;
+	imu = data->nodes[buf_index]->buf;
+
+	*ubuf = imu->ubuf;
+	*len = imu->len;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_get_buffer_info);
-- 
2.47.3



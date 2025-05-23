Return-Path: <io-uring+bounces-8093-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5091AC1F42
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 11:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58DF61C0279F
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 09:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520E5158874;
	Fri, 23 May 2025 09:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KbY6nIW8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD0B223707
	for <io-uring@vger.kernel.org>; Fri, 23 May 2025 09:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747991021; cv=none; b=MnYxcT8FRWJ2y97k/ilx3BS6LmTIybV/ZkEkqVgDDw+vroPbNSz/ELrEMmUTla5P+w5cjkgsDC0HQocYpvY6mqj93Meqoag4in4QT9d5+iMdQjIL6MX3XVWA2oxOGowG9XKmhcS9zq4DcUn1gnpBhAOC6r8oT7rhA7AC2mW6QzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747991021; c=relaxed/simple;
	bh=D4pHwxJfQeFhzzcM8MQyxYBcYd3rHqeoOz+v02+Shac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JmcIPr4INlupXMqvtr4R2moxLpg0ysIbVWfugQxj539TE/+U+StuJSnXI22xTuuAD0mP1m7dp1pjoBPQNDBEshs7BA0r422Aw5UjMV/ZeckbRAwFAneR5cRwGk5vSNe+XywEWxONkwtns1Hl7NC2dY7p67hEELdFw8weK2zUFUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KbY6nIW8; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-601c5cd15ecso8682046a12.2
        for <io-uring@vger.kernel.org>; Fri, 23 May 2025 02:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747991017; x=1748595817; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m0gaOlQjWMXt8xqzrdD2fqpoERs+r6Vpa1a1XmLTm9w=;
        b=KbY6nIW86YLCh+awI/tfX83KIUM9E/b4snxiDkRUxH4MM9nlP8LrNlVHzdZIRnj2yX
         kqGhSNw5Apyh65sKobopZP14hv6Ra+dMi4ZJ2KNXTkOsVczqFTOe8NEQ03FOIetcr/0s
         Yt+M3lLFv8z8e/CPtAGaeUuS9FQU5VnV8WVXhjq4/A1RsS2zKFSk0mci0H4oABkyYAFA
         LlwIxGQkZnGixT1Q5EWOVUoQe/jn61Rk6edeSS6RjSw8erhfB35VXmg4him8Nz4SHem5
         pJlDTF2O86Z39ndUdv2Ydj1LtGWncUrbJDmvWyt/hFfbPOVDfLvTCiu0ZysYw0Nnt4me
         PjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747991017; x=1748595817;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m0gaOlQjWMXt8xqzrdD2fqpoERs+r6Vpa1a1XmLTm9w=;
        b=ubWtITmoTWzb5mJq/97D2Tr7hv2i5vHqiJOmU+3gYcL9g+o3dO9PkmPqbWFqPkUUqa
         Re3AENa+zmcSKwxdfPM7k2skOULVUKEZihjv5tRZfUc5Padhs+zBpb4E7bETFrYrjv2Y
         mK7ugmn/IWGxiFkpYttwYHG2Ja5Pg+2a9AABJPKZZMcMES2XEFim+jbNFSTKIVgAswzB
         /NO1fSu7ANS7Z7ilxA5e/VLuvCEu3LVe+0RZCheRmmamA2JPMbh/chfG1Bko9XI7bLti
         IdoQKc/oxSbKTpuQOIaE5DNJQjizQ01T18trvKnB8qTx5ElMuzYZ0EImFG++cpKbqGWc
         jQog==
X-Gm-Message-State: AOJu0Yw+7mz3wmW1v1azwaMS30eQwSwrfM4vR0Rv9wloJ/wsANByEYHr
	vnpCog7IG53/H8tmiYDtJByRxSQg5sQ4CgkELvpIuR+Hx7Gv4/f16sJxl0FTqA==
X-Gm-Gg: ASbGncu2F0nTA6zeizMVDFTqbpgZSam0IrE3xwzI9qrnlaSjw0XCrjkTgNuOxHVnWWF
	8w8uh6bvOxvq8pXWJtFWw/aPMRhln40mGz719eIWW6Ji5NoJnVxIxcNvu1Z2ufCAvSBigRbWNaw
	COVReu1oWcozQmKHU309y9JDF0j1E01CSN+0SZqu6BoN6p/XLVKk1DjiSyPC6dhMvvEekYXVzeL
	EBsNXQ648Ggm2qYEkvRVTMYyRzWz5fwlzPdLAukiY6m48XpABNBxjJk9ueyS3FoX9mGZLBkDPav
	UZUvqDEl0x+dcH1gM/NHZNtpHXLfDknmX/8=
X-Google-Smtp-Source: AGHT+IHFRmpkNHlhZ16w/dv7VdxmaRc9RUlZdbrYtmUZ+y9ogSdCv4iCk62v+HWj/yC1UoKFm1lplg==
X-Received: by 2002:a17:906:230a:b0:ad4:f6d2:431b with SMTP id a640c23a62f3a-ad536dce6cfmr1897408866b.44.1747991017021;
        Fri, 23 May 2025 02:03:37 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:f0c1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad5d2340d44sm158800866b.142.2025.05.23.02.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 02:03:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/cmd: warn on reg buf imports by ineligible cmds
Date: Fri, 23 May 2025 10:04:46 +0100
Message-ID: <a1c2c88e53c3fe96978f23d50c6bc66c2c79c337.1747991070.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For IORING_URING_CMD_FIXED-less commands io_uring doesn't pull buf_index
from the sqe, so imports might succeed if the index coincide, e.g. when
it's 0, but otherwise it's error prone. Warn if someone tries to import
without the flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/uring_cmd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 34b450c78e2b..05d946115b0a 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -270,6 +270,9 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
+	if (WARN_ON_ONCE(!(ioucmd->flags & IORING_URING_CMD_FIXED)))
+		return -EINVAL;
+
 	return io_import_reg_buf(req, iter, ubuf, len, rw, issue_flags);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
@@ -284,6 +287,9 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 	struct io_async_cmd *ac = req->async_data;
 	int ret;
 
+	if (WARN_ON_ONCE(!(ioucmd->flags & IORING_URING_CMD_FIXED)))
+		return -EINVAL;
+
 	ret = io_prep_reg_iovec(req, &ac->vec, uvec, uvec_segs);
 	if (ret)
 		return ret;
-- 
2.49.0



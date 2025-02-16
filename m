Return-Path: <io-uring+bounces-6477-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09C41A3781B
	for <lists+io-uring@lfdr.de>; Sun, 16 Feb 2025 23:59:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CF043A9311
	for <lists+io-uring@lfdr.de>; Sun, 16 Feb 2025 22:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5909D1A3161;
	Sun, 16 Feb 2025 22:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Ges7LyK2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f228.google.com (mail-il1-f228.google.com [209.85.166.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858F519DF9A
	for <io-uring@vger.kernel.org>; Sun, 16 Feb 2025 22:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739746777; cv=none; b=XW+XalXQZGGKKAdqKCIKx7fwcjEf4E44AA76t8rZHDHh3FyoYmjDXBjQrize7tirBQ80w0Ni2YGRE+a1Qq5KbJurOBmiA6q+8xFteW5hVz2kKWUVpBY+as2iBd7+DC/FxGNxiF5SS4GL+BthavxLxG3O7p0uIQdcA3r2HFXCfbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739746777; c=relaxed/simple;
	bh=9irgLr0l3CK861ewxkX+DyGlZog3CP8czx5f2HVoHBc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y7825rN3wOBZ70ZowY21RRoNsipxo43OA0HqiVLNUhPnCgRyZMgW3jDL5IK3C8YnBPlieeHw+pBmryTMqxmqPYIg+sSZo8DtoddbVLcMRAOAdzGK8Qkt/0plV6k0Wu/zzl+QS1X+ImU0+qG2SgHSbf9qNagJwJ1MJ4uLgX51lGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Ges7LyK2; arc=none smtp.client-ip=209.85.166.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-il1-f228.google.com with SMTP id e9e14a558f8ab-3d1a3129236so403145ab.0
        for <io-uring@vger.kernel.org>; Sun, 16 Feb 2025 14:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739746774; x=1740351574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VOzqu2X3lgSbiyrDMUmee+hDSe3BZ5BDlMMCth/AVYM=;
        b=Ges7LyK2fOgOBSxJxtANMjHiT5rEaymm/r3cCRHWmgntv+3/F5SjSCo3nBj03Cw3Hk
         jbsGaimSKwKd8cdElgJ6tjGIFiPGUa4PCXQl8FFfHsb1s9D1ZY/YXMtrDKLJMuNBdTKL
         D9Ktk3WBO+VDxyVMq4PI6S1p2I88UnMra5KpJfkZ4HKHwMDOvXxEFHhz1oKD3a3O6vdv
         C+doITv0KnffUXn7/GonsyGwedUkqB48BELJU3heZfYBOdBTYVY1q8L7gYnKeJSngSKx
         K5HF6uinvCP4Dkn88A4tzVKhc0E5Ekwv/5wft8n7PPvXYEQ6ldzlMqGkyqRhgTe/gQpw
         L5Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739746774; x=1740351574;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VOzqu2X3lgSbiyrDMUmee+hDSe3BZ5BDlMMCth/AVYM=;
        b=Wyw12dcONdU3nAYjimQ7S0uqFhI66EYO1uKkyCyjffhcZy8843wZo3MLSgVD+uqTWZ
         uhyyi1P9z3lwU8wShON6Ze9uIEDMNWaux9WHsmtlyZm6goM98IoFaP76i7uSjoOm1ccH
         rbdVw7gD6nwZM8f5Nd2UhTjLtiI/li+v7D+wA/k5LY2uqbUBut5OcEZ0UcNd6Oc9FaN4
         BYocxYrGZ4U7a7vu3+T5IUM6QbWtdK1YCuVDFqGcypC8uc3JRpsRwLAnJpPRoZlm0xDu
         VS9PDot+MHRoUa+JbOHsm1SSiZWh6Juae4e/LvLJPeJc+ZTMVt7tWDPn7+eFuedsaVIy
         0DwA==
X-Forwarded-Encrypted: i=1; AJvYcCWkFSY3pbxbmDDjmR7ju70hp9ErX/IBCzzXAlRyzGeDKfVvL1Ly/mcxC1sEthyvojgt91SLAzA/vA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyPZ1u6nCYu9X3gr1wIMSFM5kFSnpkqFRiphGWl9g7oTWeO4rN3
	CHaWbCthAUfk8HafHnmvgbVbbWXKRIYCPX0vGvlBRAI036erEe2dHR8TByKGDaTNYeEdQ35QC0T
	tdtmso+tY9t9ltUx5agFfCXdg2BKIa82E
X-Gm-Gg: ASbGncvqkBWNfucgCLEWHgUAlU4KQ6WuT6U3QKPH9hIg6fEzpOQDNWlDbhALpfJlBrU
	PC0JEh8khdXIFocrf1Q1Z28J0pr1c26Sm7u5VGqN9DW0slox3ZZcMhEr1ZpNbLsCx730aqKqBsn
	vPgdj4gl9wh95ZlLMRCfTJKcurrQqZ+SrKPgHlW6RSBYjdYoHW3ZiiHR7gDpCCToSsfUtKGAsle
	yV4HbCnNZ6996C+c/bAslMN8NjbNi7Ii30MHhmmtIrOK2q5ApeSMa5hv6OQGg2bYRfrzBVCUVqF
	7M1p5PGqz24jmw1ZhQytPa3lOGAebfCd4leSNg==
X-Google-Smtp-Source: AGHT+IGNZMUsQmjwhNAChABqyKb9P9CjO83bZ1o2Eo+zQFFzpwLHMh0KGUHlsnvWzivnKptXFveCictNYXwy
X-Received: by 2002:a05:6e02:20cd:b0:3d0:255e:fe7 with SMTP id e9e14a558f8ab-3d2808cfca6mr15592615ab.4.1739746774637;
        Sun, 16 Feb 2025 14:59:34 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 8926c6da1cb9f-4ee9e72f6fesm33931173.44.2025.02.16.14.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2025 14:59:34 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 5536C34022D;
	Sun, 16 Feb 2025 15:59:32 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 4862AE416FC; Sun, 16 Feb 2025 15:59:02 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/rsrc: avoid NULL check in io_put_rsrc_node()
Date: Sun, 16 Feb 2025 15:58:59 -0700
Message-ID: <20250216225900.1075446-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Most callers of io_put_rsrc_node() already check that node is non-NULL:
- io_rsrc_data_free()
- io_sqe_buffer_register()
- io_reset_rsrc_node()
- io_req_put_rsrc_nodes() (REQ_F_BUF_NODE indicates non-NULL buf_node)

Only io_splice_cleanup() can call io_put_rsrc_node() with a NULL node.
So move the NULL check there.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.h   | 2 +-
 io_uring/splice.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 190f7ee45de9..a6d883c62b22 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -81,11 +81,11 @@ static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data
 }
 
 static inline void io_put_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
 	lockdep_assert_held(&ctx->uring_lock);
-	if (node && !--node->refs)
+	if (!--node->refs)
 		io_free_rsrc_node(ctx, node);
 }
 
 static inline bool io_reset_rsrc_node(struct io_ring_ctx *ctx,
 				      struct io_rsrc_data *data, int index)
diff --git a/io_uring/splice.c b/io_uring/splice.c
index 5b84f1630611..7b89bd84d486 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -49,11 +49,12 @@ int io_tee_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 void io_splice_cleanup(struct io_kiocb *req)
 {
 	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
 
-	io_put_rsrc_node(req->ctx, sp->rsrc_node);
+	if (sp->rsrc_node)
+		io_put_rsrc_node(req->ctx, sp->rsrc_node);
 }
 
 static struct file *io_splice_get_file(struct io_kiocb *req,
 				       unsigned int issue_flags)
 {
-- 
2.45.2



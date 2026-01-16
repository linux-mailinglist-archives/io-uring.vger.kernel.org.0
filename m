Return-Path: <io-uring+bounces-11770-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B457AD38A10
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:31:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A9AAA301B895
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 007DA1C84B8;
	Fri, 16 Jan 2026 23:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UbbSOCAZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6D3318BB4
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606267; cv=none; b=Z5Mi9BjO1FsOAGtsCZbxyMerM/nOcXF25wccmWjhtSDYBt6mlY/aFuu1oWpDYwTDCKZNyGTzjoc8058jA/A6dcOUhgykFPlGF8GqYDtzbjkNY95r/f6eN6ctOMyB+u4NY9ITuz5OGCv6gegKSDAL8O1yAIK55HaLWNVMiB3Y8X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606267; c=relaxed/simple;
	bh=X0rVa/St9VjNlqG0rrH1NPxF9R+fvsHNxiG5pd1IqwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcFUb60Z+hwaSPZgp11kn4VAkfiyUwmh4H/yUCUylzqoAIQMBTkopDtPHgMCRPELnD/l3XbKqm/GY0z0D2LNw+sB09YCYBk9/AC2kgA6TBZr1S4W3jLFEcm6sItKoBvKOVbTQXzyI8OtqPIuwR4GdVsz5lb8e0fuS9FGKHiqnU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UbbSOCAZ; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c54f700b5b1so1513722a12.0
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606266; x=1769211066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NUFMsREpOirl/85nGnx+NyCTEVbGrT/oKEvSLBv7Wc=;
        b=UbbSOCAZIzm8vVjtiDR0tcVJqKU9D+N4NMiw2xSiE0FdvPC5Kdvbwqmg4GwPaLaclM
         ujPRH2AsE7jzWhX9Sp8TDN6IFutXtZhwXJCUgHvLuxi5UlgBdzJlufHcpZ8y1NA9tuDM
         lwyPtoYXn8JCygF7Kk1FZSmGqO0ganPVPXO7VJd6uCJqpY0/dzlaveBjjJMLtB/KvV+G
         Xx1tdHmSs/IvksVfEMyElGEb97TG3dfl9shLRk+ghOY0MHVeLp/RbYgJHY5M04759v8W
         nnYs5fzUL5035fUVu9B8ikgtOy5FP2t6rcvq9yNS9fXdUg+AFBJcKk2OnsqlSIkGEx38
         jzEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606266; x=1769211066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5NUFMsREpOirl/85nGnx+NyCTEVbGrT/oKEvSLBv7Wc=;
        b=BcwCGMHvXkg7ZaQt0SPu4r3WvNR8GAZLagtKviyHI/gG52mdO2gO1YbOvhPZ8Y/13/
         KL7lMDnF/0xfyLsCA1eoa//C73Dk7vASd4rjkoZHx/0saFpsj76CD9Zv+fPKT7FxiPGZ
         z+G9ma8vtCjaGvLICwPk0+jXlZOtNHLu39rsMzrNyPLFRBYoM3p2JVHlVyj9ok7lyjIi
         MbcqqdPGUt62hTY09mwSezr7fcSomi/pJDGDKKygnuyMkNBVajmJNntSIHoAOewX0BqQ
         T3dYCGsvClQljmIX9q4xA+pW1FJVQasgGiLopBFaNxe+UdY7MF7u90FydvX6iBvHbbCG
         7z4A==
X-Forwarded-Encrypted: i=1; AJvYcCXOYKYrRLMJV4LAbFHCk3j9MnqhV6xL1SVnmWOvl4uMMZJ3hYumQnOukW0kownIHIW7Jq+MeRjr+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZiax99rofPhnA/7oeQYdq6OhPjF90IdXAHkXNDfmUQYrtKU9Y
	8TVb5zgfBW46LL+Ps+B/v0Dob8xH+s/LhvgzpR/SJjVPAkMIFb9wpomU
X-Gm-Gg: AY/fxX7jcMM6WfrusxtQ0xRph4cu8kOAhog1jvXkjKoeVJlQO8NJma0DtZbSd8XbVqZ
	AFAfryrsx0Lr4bIp1KbowUEATzZNqmTSKEurpY4uhyhaM0rOPBUJWtz4r+dZNUN0pDB1Ta0GfrX
	iYVQI8FQCDZYxogjckSIg+TAhd51sdIRnlsXuGQhS1MW02vtQwP4ozHcU2E1Mslb2iSylWss16v
	P4izL/xosfRJSROU9+OtxULOqOiS8ZUifyRGbfZRXoy7od41pUStrbBCewL+0EETGT1BN80e8IJ
	tyNjuVafLQAwh+kBZssg8/bXnk26v9dljl6BDlwbyMk5DbTjAzln7Mp09uTaSdZBT5ihbJJWTly
	H9AA/k9u1jD+45vJPd9yTfFoJNSDbwpnm/XHVtckJOrg9YsnubwqLQKBwZ2ktEbpD26F/2NmzaW
	4dBUYgHA==
X-Received: by 2002:a17:902:ce11:b0:2a0:9ca7:7405 with SMTP id d9443c01a7336-2a7188f91acmr47460095ad.36.1768606265863;
        Fri, 16 Jan 2026 15:31:05 -0800 (PST)
Received: from localhost ([2a03:2880:ff:53::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa1291facsm2940870b3a.57.2026.01.16.15.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:05 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	miklos@szeredi.hu
Cc: bschubert@ddn.com,
	csander@purestorage.com,
	krisman@suse.de,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	xiaobing.li@samsung.com,
	safinaskar@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 02/25] io_uring/kbuf: rename io_unregister_pbuf_ring() to io_unregister_buf_ring()
Date: Fri, 16 Jan 2026 15:30:21 -0800
Message-ID: <20260116233044.1532965-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116233044.1532965-1-joannelkoong@gmail.com>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the more generic name io_unregister_buf_ring() as this function will
be used for unregistering both provided buffer rings and kernel-managed
buffer rings.

This is a preparatory change for upcoming kernel-managed buffer ring
support.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/kbuf.c     | 2 +-
 io_uring/kbuf.h     | 2 +-
 io_uring/register.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 100367bb510b..cbe477db7b86 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -718,7 +718,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	return 0;
 }
 
-int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
+int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_uring_buf_reg reg;
 	struct io_buffer_list *bl;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index bf15e26520d3..40b44f4fdb15 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -74,7 +74,7 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 int io_manage_buffers_legacy(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
-int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
+int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
diff --git a/io_uring/register.c b/io_uring/register.c
index 3d3822ff3fd9..888c8172818f 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -752,7 +752,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = -EINVAL;
 		if (!arg || nr_args != 1)
 			break;
-		ret = io_unregister_pbuf_ring(ctx, arg);
+		ret = io_unregister_buf_ring(ctx, arg);
 		break;
 	case IORING_REGISTER_SYNC_CANCEL:
 		ret = -EINVAL;
-- 
2.47.3



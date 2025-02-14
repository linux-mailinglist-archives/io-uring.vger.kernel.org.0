Return-Path: <io-uring+bounces-6453-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 105BBA368B2
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 23:48:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 597F73ABD18
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 22:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFB881DC988;
	Fri, 14 Feb 2025 22:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="So+EyjtD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363B71A76BC
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 22:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739573245; cv=none; b=c0R/cAFbeQCN22/Y5Di9033kGHPUFQBhBy0HEEBEMIWvsaWHcxQkAO8kqmJwqNLFXrpWX7y0J1UxM9o+Mzkda66oyLHQCV+ryfigzzZfL2++2gPR7DR+0hki1kDi6iS7HoEFIOqFQCAMYCtYJxByFXCGbuaLJkwk0Uv2U9AJ+0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739573245; c=relaxed/simple;
	bh=JEhmsTFVyygiHMgjAoFmlSMs3Tgk3WWdOuaEZkJBB2s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BZxSEVHZX2Wswy+N8b2Y520lJLNK+eJpxw9TX5dHsqKPbjYI7MonoZB6IkqSwE8MQVAzHQtHI1BDeslyNYFMma25o22G4JZyn9JSEEo1eenPU/VhokefYWbz4cXIb44Kb82GgL/IhbHRuCqsDy1PVYP8kHdJL3qR+04iIB6d3OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=So+EyjtD; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43932b9b09aso28669745e9.3
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 14:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739573242; x=1740178042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EnG77GiaIKsnJFsqGKOs2LHPe+JhZnMcDSNmopu7ijM=;
        b=So+EyjtDMjvAJs+/RsUPdIu3ohJGqu8Zgy1UItNeTFDd4FalQKYLLxmLQl4iJ9toON
         sot+uDMxFNQT2cbGffKTYwRyXw+wOmz/UL07M5KWQh00HtZoSM7Seu4jxKmbotx7lx2o
         mFxJ7/8ugCM5kQd+4Sir/4Zh34mxlSunFz0NJ1vJEHJjfmQX8dAHsx+DYklbDMkdwG4I
         iLYUhSUn9IgxLC0cb9rvyuX04FnShNsN6+MpRBT2gH36ddD9YKpT2y1z1kV2B8Mu41VL
         AS12Ff6H4w8b4et0xaHYOqnZjMjgvJR68/IHd6G67Ne2opgbvb+HeqA4ioLTk5Et+Zdx
         ahLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739573242; x=1740178042;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EnG77GiaIKsnJFsqGKOs2LHPe+JhZnMcDSNmopu7ijM=;
        b=lCPy8Ss5VKZ+S0ooIEQsPzUGsFPpJx3t4mx+P7KRXcCWbCXtQKmnhQuAEG5+K11aP6
         iLxGTMA5KOfUhETlYUi7jpzy5jc/D4bE7m6ESBx0GJgR1tdL+A5zT4SI+7IAQi0rhv3p
         K/hEWqKh5gLUFukDdzerQDoTj+oAl/uvf6WYtZHgSJqv0juOZ1yW6yDIBFhk++fOrfJi
         e7s9DiI0pe3JTlTGIXCSSxlofli35ZtObwi8gZckPABCZPsVP5G87Aj9tnBqTGtIChck
         XxO/MChkJo+nljwa8knGXmoo8TpZFDTZZfciKu+aiJUz5ERmbw3J4A26GyXWwKLiJp+B
         Exgg==
X-Gm-Message-State: AOJu0YxqDVzpdE4tGyIcSNNtC5opp5LvAbQDbltVYQ/OqPUCr/i2YRXy
	tGglbaq1GYu000EUI772OmCDgxlb7qjx/5iSZTPVxajIV9Lq+9b9PKKO6w==
X-Gm-Gg: ASbGncungpmmaEJQVYUaiugaLP5+b30CgF4Z/ZMfLBNQuFor8Tqlk8kh1mcv4etu76h
	E6TUPc9pvZK/Mqf86oELVQ4KcVQtgFry/SPGyiyu+8widKClMambqpnsomf6eRo8SWRoZDHiirU
	AvVmPCq+iPd17h0RC1NxeP/8scMQlbaNIJYY8DCo4e69IH2UgCL178j8PnEznFKj6vCQsfK/kih
	XZzszWUDOqjyJv4jaZR6N0XA/RqNizqzwEEHoCDcFhVqrhwXpaUXZBuFm6rJ7eFjpnM8OlnMaMv
	pNotC3PJXzepZbxDVgGwjB2vDB4q
X-Google-Smtp-Source: AGHT+IGE+i0Pw2vfqV3HMc4aReMnSQac3M7wFmiykTVuVYOCZv31VC8f8XezM7FQViITQkGJHKKFIA==
X-Received: by 2002:a5d:6c66:0:b0:38f:2f0e:9813 with SMTP id ffacd0b85a97d-38f33e8067cmr1293653f8f.0.1739573241941;
        Fri, 14 Feb 2025 14:47:21 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.233.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258ccd2csm5877663f8f.30.2025.02.14.14.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 14:47:21 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: prevent opcode speculation
Date: Fri, 14 Feb 2025 22:48:15 +0000
Message-ID: <7eddbf31c8ca0a3947f8ed98271acc2b4349c016.1739568408.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sqe->opcode is used for different tables, make sure we santitise it
against speculations.

Cc: stable@vger.kernel.org
Fixes: d3656344fea03 ("io_uring: add lookup table for various opcode needs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 263e504be4a8..29a42365a481 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2045,6 +2045,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		req->opcode = 0;
 		return io_init_fail_req(req, -EINVAL);
 	}
+	opcode = array_index_nospec(opcode, IORING_OP_LAST);
+
 	def = &io_issue_defs[opcode];
 	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
 		/* enforce forwards compatibility on users */
-- 
2.48.1



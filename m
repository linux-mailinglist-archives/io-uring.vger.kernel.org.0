Return-Path: <io-uring+bounces-6541-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A03A5A3AEF9
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 02:32:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CE2F3A913B
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 01:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C3028FD;
	Wed, 19 Feb 2025 01:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SFvL509A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5526C1F5E6
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 01:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928772; cv=none; b=BbJpuCoVYSHVTgA+ROX6sXIsa8Hok45+n1lXTFJ2ksNn7v3vdcHfr/mSDArhFo5ba+TPFGTu9O8BWPEj2F8T/O1PvP6ARicuu+Rq4w/HYAsb0pbl0QCRb/6VDelQubzKEwI0icuw0Sjg//ZzVXLwdAZ6OIUCwjO8BSryHcV7tzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928772; c=relaxed/simple;
	bh=u4YnKq2nBVulrB4CGmEJts2sxbYWVkuZq9930jiQonM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgntTFoEW321B2SRDDrKph0+ROuWYxP8Z/WxET/szME/GcrO34JH1zU7UiKc/Rwx8UgdDQv8rXJJHdQu/N3w3dXnWNcI6Vg18mH7/jxtgMMZmOyQOolGJftWetISwU70wlpbCx+QTRSALoSNqj4PVHAV63MPvOfoms3FU99rUio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SFvL509A; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38f3913569fso185392f8f.1
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739928768; x=1740533568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vVCh1cQaB1aNgTbNHpi+13n63bvU+huLIvoPQJbECbE=;
        b=SFvL509AHzmM3ZvdGSwWe1en0QBWuIzt+V610O9fs7/tFlKRsWfZC3QtguDdy4uB+j
         nKFQQfkfQqTo0SaJWeg1WxhP0aX4PV3XoPlD+S/s+q6XRhmItBnU+JMGJk0R53fbuHPp
         Eo1ZmdWtvW1DDBg7pBbhQke2Ij9mcn+Ab4lQnLJvI13pCEkUL2I0bRkl49boEv0+SrWv
         StSagS9cUCvQ9JsZTre8Bl+vzjAkoltUqmCXo2Q966TVXoBukbrZui+pTxTA8zqINVMp
         76dkQUJv1J8e4/wVtvigmiqrbGYZ3GI5fZ3dlh8PPGKXHa8jQQRrWzfQDAtuJOqvb/uJ
         025Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928768; x=1740533568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vVCh1cQaB1aNgTbNHpi+13n63bvU+huLIvoPQJbECbE=;
        b=E3RWuIAylejZO60GBwK+7YRHtVaeUSMPvyArjeYS4IOtfVtoXbl1g4uhmf3cuJns8a
         oIuIMqYgHQVugB8oxhGiIp1o6D+3wd3ntQmcPmYRxw+j2kI9RqO3Sf1qi9etPyoii6y3
         hiTZutytwYNjOjCeYyzE8NHWnE00UIUfI1VMdsWJ068hytLppvNA+MsKiKXA3m3MrZoZ
         pPJ2idrzQT+XeLk9Jvt15aWAXBIeX9/Xq3868DX68Iohcdn0fFzJ4KeNCUtOzxkJnS8p
         YhOpf6KZq7YgffMltX5w1OXHi/Dkx6RWlG8f9rv7cb5F7wnNgRhcY5j1YmPi/q8Ndwz4
         sjzQ==
X-Gm-Message-State: AOJu0YzLXuPqhLQcz8xp7N8Qs368R1mKiOZ/FLIewWkhUDrSLDDYQJdR
	JBxPw4jWKkbgsE8zxhmygX0CD5y9pvO0Zm5uT7P8YH9ehhuam7hMWflUXw==
X-Gm-Gg: ASbGncuWYz92+ermXyD6iS7G7C9eFSq5//EJuqddl/UxGLawQopYxwBPmKfI1hwfanH
	A4/kfAS5pUSlvnHGhH9veFT/VQFXA6NXCu1+ivl3yPk4FnB8rMbvNxWW7Q15asxEjXzNY6n8NEu
	mpPMlj18N5PDIPW71yIL9VJt/oimN/wzKlnHfkTJrfSAoc2BTnL5MWWms0mStBtIIl6EYmyy615
	tEdFCoBID29yXM1RY5c9O9+Irdy6B6/g7YHmF6WUXN7Y+tULrDiUk8n7Xstwrr4eE2DP9UrFrJK
	4Ic6IY4l5CZuElkhbaonYthTBghV
X-Google-Smtp-Source: AGHT+IFc8v7bv9guiKY1Uw37vjJT/p4p3bfvd5JrM7jyXewssZJw1U2U8ci4JanFGWmfBvPUSWSxeQ==
X-Received: by 2002:a05:6000:401e:b0:38d:ba8e:7327 with SMTP id ffacd0b85a97d-38f57c086d3mr1772876f8f.8.1739928768228;
        Tue, 18 Feb 2025 17:32:48 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d8f1csm16617752f8f.69.2025.02.18.17.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 17:32:47 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 3/4] io_uring/rw: move ki_complete init into prep
Date: Wed, 19 Feb 2025 01:33:39 +0000
Message-ID: <817624086bd5f0448b08c80623399919fda82f34.1739919038.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1739919038.git.asml.silence@gmail.com>
References: <cover.1739919038.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Initialise ki_complete during request prep stage, we'll depend on it not
being reset during issue in the following patch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 27ccc82d7843..d16256505389 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -23,6 +23,9 @@
 #include "poll.h"
 #include "rw.h"
 
+static void io_complete_rw(struct kiocb *kiocb, long res);
+static void io_complete_rw_iopoll(struct kiocb *kiocb, long res);
+
 struct io_rw {
 	/* NOTE: kiocb has the file as the first member, so don't do it here */
 	struct kiocb			kiocb;
@@ -289,6 +292,11 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	rw->kiocb.dio_complete = NULL;
 	rw->kiocb.ki_flags = 0;
 
+	if (req->ctx->flags & IORING_SETUP_IOPOLL)
+		rw->kiocb.ki_complete = io_complete_rw_iopoll;
+	else
+		rw->kiocb.ki_complete = io_complete_rw;
+
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
 	rw->flags = READ_ONCE(sqe->rw_flags);
@@ -817,10 +825,8 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
 			return -EOPNOTSUPP;
-
 		kiocb->private = NULL;
 		kiocb->ki_flags |= IOCB_HIPRI;
-		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
 		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
 			/* make sure every req only blocks once*/
@@ -830,7 +836,6 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
-		kiocb->ki_complete = io_complete_rw;
 	}
 
 	if (req->flags & REQ_F_HAS_METADATA) {
-- 
2.48.1



Return-Path: <io-uring+bounces-7910-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B19AAAF923
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 13:51:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1F1C1C06F54
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 11:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC362236E0;
	Thu,  8 May 2025 11:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZxNpKG9Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EE2223335
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 11:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746705081; cv=none; b=PeXlgk8lxpj25gcWkVE217EzxQJETe95/IppZvgHWoqXC+7Bf83DILxZzU4mtbWv0jE4MfmptBYkw8rhpjOXVbpJDaIGgpsZIrFzeDqf94lMKtOkO+IzN7zklpmpWhQXSlnhXcHJajwA1w35iBOvegh2i5jHZIaqYRA759uFyag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746705081; c=relaxed/simple;
	bh=fAccs1r4wd4ULNZ1sw8Jsx0NTBNp7ATbj++uRpBezPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1t77GnB+Zrm/VVTP+cGusbtX5hj5U8w0GUm3CowdPytsfMgHyuKPiyxvq479c5tFCbfR4a/FCstXTHG+WuwYmc/N1htA9VdX7lZePDkfxatmNlK3KqDXCoAQfwFDIM2LgCcj2tu+5bf7NaQBuDnB6isPuhCGa8fUpt3zkjq7AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZxNpKG9Q; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ad1d1f57a01so164130466b.2
        for <io-uring@vger.kernel.org>; Thu, 08 May 2025 04:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746705077; x=1747309877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ETeWRBQLsXP0DiigyP/+8qFoUBT2JsovPh3YXcYfB+g=;
        b=ZxNpKG9QqhLrfEz+36KHbyNjNrqGxXrQmPcMZj1RnPGDHKwrnd5sn8TPyPuJlpZxB3
         h4FsmKZvhe2an3bp4wr9TNT4PB2rH669t3c1gNAKwiR2MnoTAJhcT+fWNB6mjG8ZHNek
         LK8ILTWf8dppkJFbwtkAPp4VxdR4oP/pdTGKqQsA3NjzGtTwzPgoMv33A1QLeQa8zZF4
         wU5k2haCwFcRUlByjyOc/0auPz8LKzC1PtAUrQqGkBst5XtCeBTsxQzNaCkpi/xtVqVi
         Heve4HdnkB38ky0sezjKGRcF1M3vEvMVVOl894xDFmfAboVXL9cbyYzR6kK0JW3WMaSL
         ri1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746705077; x=1747309877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ETeWRBQLsXP0DiigyP/+8qFoUBT2JsovPh3YXcYfB+g=;
        b=SAGQ3tQan4k8IfLBz8K6ur52UXJiGmdkl8NT8ziOMdvGquozkBVSXwe9JlsulAdC/6
         qwrX0+f/+a8JZGZXspRMLM5fsVUqwQNOGiYMLo4/xrefm+8I1aH5m6xOK+JlQR8GGSw3
         Ca7gpWZlXgIWLE3DzcrXlaNivRqohAlCXnM/mARYAYpi5aon1QgUEsx3qbJq346bs5zC
         TVynUob6g6l1O2avkzlZgBFf9ZYik0otEbHAB0vIeaJWqCK+pw8lbXRsdYHu7JCFFYQI
         th99q3q7rPCl5iunzBzUQcaGt5mTAqumRkssQCZw6uIyThsvSQSLiOT2ss+pwPsPa5b/
         h3AQ==
X-Gm-Message-State: AOJu0Yyoso5zQrfVwll9b+eoSo9m+RvJQHVV064tMPPpr67Cxgf4d92p
	7kp6325hfAQv5dDYFO8pBpSoYnNghEXoDdTGjDXnRgQIJ0P1tK/zQojraA==
X-Gm-Gg: ASbGnctZ1arvhB5/PH0RFtheAZ9nSMBNHZop9PagtTY5i+O8yKM53uhAMXUSRgPOOyf
	C++caA6AMOanSdH2YpHfdy8FFSaNX52zEk1eS4mosfurfEM4DoFc4el3rry4mD0iRPT+Sg4pS8L
	8IF3ncUl73dWvnen3E+DJazJFtVkUBtB2sEJfQHfaQxE1Qe0dx6JkHgrTWtutIx8K+SER2CRuRA
	B5gBoQG+y3tJfSJ6SHr+RvJZkXc5mK6qj5RXMStfgAA+Fm2568EUUIz/HONkAKH+eFBTaTAaro+
	vCjCGXW9bSxDIA2CB8kHal9q
X-Google-Smtp-Source: AGHT+IH1IifC3Vkhz8Yymkvv2dxW4nhsrIIl8t6eIPoA/gB9R7ud7oRYDrYgg0uqzSvkLlzcqo53MA==
X-Received: by 2002:a17:907:3f17:b0:ace:672d:c7c9 with SMTP id a640c23a62f3a-ad1e8bf14b9mr480040966b.26.1746705076902;
        Thu, 08 May 2025 04:51:16 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2cb4])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fc8d6f65d6sm677051a12.13.2025.05.08.04.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 04:51:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/6] io_uring: account drain memory to cgroup
Date: Thu,  8 May 2025 12:52:21 +0100
Message-ID: <f8dfdbd755c41fd9c75d12b858af07dfba5bbb68.1746702098.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746702098.git.asml.silence@gmail.com>
References: <cover.1746702098.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Account drain allocations against memcg. It's not a big problem as each
such allocation is paired with a request, which is accounted, but it's
nicer to follow the limits more closely.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0d051476008c..23e283e65eeb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1672,7 +1672,7 @@ static __cold void io_drain_req(struct io_kiocb *req)
 	spin_unlock(&ctx->completion_lock);
 
 	io_prep_async_link(req);
-	de = kmalloc(sizeof(*de), GFP_KERNEL);
+	de = kmalloc(sizeof(*de), GFP_KERNEL_ACCOUNT);
 	if (!de) {
 		ret = -ENOMEM;
 		io_req_defer_failed(req, ret);
-- 
2.49.0



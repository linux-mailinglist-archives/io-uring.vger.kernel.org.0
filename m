Return-Path: <io-uring+bounces-24-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 986BF7E1759
	for <lists+io-uring@lfdr.de>; Sun,  5 Nov 2023 23:30:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0499B1C209A3
	for <lists+io-uring@lfdr.de>; Sun,  5 Nov 2023 22:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE55E1A703;
	Sun,  5 Nov 2023 22:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bul0YyWL"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2391A715
	for <io-uring@vger.kernel.org>; Sun,  5 Nov 2023 22:30:27 +0000 (UTC)
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C782ADB
	for <io-uring@vger.kernel.org>; Sun,  5 Nov 2023 14:30:25 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2c6b48cb2b6so54793701fa.2
        for <io-uring@vger.kernel.org>; Sun, 05 Nov 2023 14:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699223424; x=1699828224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7C2CzeiGE+2knhPabDRWXJ9QnU85q1JAUGHIfJJn7fY=;
        b=Bul0YyWLm/6L5lPNbAnadLusLDiuqr5SYNWOV4c5LAiCWRyl+4y6Kc17yHCiC0KifA
         h41hpZ9MWVCVJ/HBmfyy/V6ONfCpyC9IsIOg5Iq0vUGCYIzcQ5yLs/Rf93p67NGPczzT
         0DEXx94d7rCwl+pVmo+pxGgHgz3XIe8Ubju5AgIIjSAjo7dTzAWFGQsh08xgKqPDE5m/
         NQBx2v9MjD7xb/5qgnjbR+5hjLacsd3zA8Q9d/ZPgdVbNUusScowWTAeb+Avrg1TRqxQ
         Y2bsuy38dW6DZuITDbQJ+H7RI33HPXsHqTrVTdYD2tRBHhzPEf07wPQKBxAIMF+eZM2x
         yayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699223424; x=1699828224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7C2CzeiGE+2knhPabDRWXJ9QnU85q1JAUGHIfJJn7fY=;
        b=U8Odtl7hzYfwvmPtTf5qcFYw9noQpB/e+avgJRgoBHh60jNPQwBw+gVqCc2AZ9ttD/
         lLhpr6UD1f0s1WqagXZO1D4vXk6cSldLoy5FNGZeAOfgQ4BGxD+QkF3k0abO51DWgzoQ
         zH1ugEIMJ45gUIZjOxSxkyR2BuoOqMd9OyVqQVAZOsxIt6b7YfYinHnlIU+ESffmVHoE
         qLBXIatg/NtVHSykcigXy0BuVm4iXZ/6uviCBXvdH2UZQpz6+J1K+7kCPfSPSGjI84y7
         iPPwjiWdoDtcb0WATfeiVpNT3LfG77c/N1MHAYvlLvN3Rvotx9G7huCTSb/hZKwxlGEH
         EbqA==
X-Gm-Message-State: AOJu0YxACBZJ7+42svisBYkMfXz6Ew4xaucjVf/tbxAgJYm+pLyw/DYW
	MU9eXfexJSrqdxX240WBE6kYZBakdRo=
X-Google-Smtp-Source: AGHT+IGt+6xB6iJYaxWOLPcMYgZsxbwUFDkxrrqsw28dCvm00eJwd6mWkdWGJ1KLc4pV1Yly0EiUyA==
X-Received: by 2002:a2e:880d:0:b0:2c5:380:2a10 with SMTP id x13-20020a2e880d000000b002c503802a10mr19091269ljh.25.1699223423462;
        Sun, 05 Nov 2023 14:30:23 -0800 (PST)
Received: from puck.. (finc-22-b2-v4wan-160991-cust114.vm7.cable.virginm.net. [82.17.76.115])
        by smtp.gmail.com with ESMTPSA id m26-20020a05600c3b1a00b00407752bd834sm10244267wms.1.2023.11.05.14.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Nov 2023 14:30:23 -0800 (PST)
From: Dylan Yudaken <dyudaken@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	asml.silence@gmail.com,
	Dylan Yudaken <dyudaken@gmail.com>
Subject: [PATCH 1/2] io_uring: do not allow multishot read to set addr or len
Date: Sun,  5 Nov 2023 22:30:07 +0000
Message-ID: <20231105223008.125563-2-dyudaken@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231105223008.125563-1-dyudaken@gmail.com>
References: <20231105223008.125563-1-dyudaken@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For addr: this field is not used, since buffer select is forced. But by forcing
it to be zero it leaves open future uses of the field.

len is actually usable, you could imagine that you want to receive
multishot up to a certain length.
However right now this is not how it is implemented, and it seems
safer to force this to be zero.

Fixes: fc68fcda0491 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Dylan Yudaken <dyudaken@gmail.com>
---
 io_uring/rw.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1c76de483ef6..ea86498d8769 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -111,6 +111,13 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	rw->len = READ_ONCE(sqe->len);
 	rw->flags = READ_ONCE(sqe->rw_flags);
 
+	if (req->opcode == IORING_OP_READ_MULTISHOT) {
+		if (rw->addr)
+			return -EINVAL;
+		if (rw->len)
+			return -EINVAL;
+	}
+
 	/* Have to do this validation here, as this is in io_read() rw->len might
 	 * have chanaged due to buffer selection
 	 */
-- 
2.41.0



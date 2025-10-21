Return-Path: <io-uring+bounces-10079-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3629BF7E73
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 19:29:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76D414814BD
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 17:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE3DD2F39C7;
	Tue, 21 Oct 2025 17:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G7TsF/iV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEC735581D
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 17:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761067780; cv=none; b=dhkIdCmx2x5c4K1kf3j86M2HcpxUiYIu/F4tI6WMFYYRESsZ975YZoCdmVb8TVSBbtDP9sfhPsS7g3p62rXvY3r1WBSHBdu6Z6JSr1M+q7ubVpOBE73FXsmKQXAIE8tVvOEe3+R3dyP3ssWecNgfU0ZPDjaFW+QtH8nfqjJh0hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761067780; c=relaxed/simple;
	bh=2wVoZ6J5fH+QEIqkn/CT/xdIWuyj0ZyFQwJmlOtInbM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=hbfux3hKsREXPsWSPSaZm4Ap/W+QTsRpV7EiUZE24QbOLPU+fTtdPW8gAnmECQS32aEQjEaGhEvQh1AqLMJgshJ+8mwpPGRVaFy5gCk910eEjJtf2xsJ6txZHlcCZmoeoWQJOjvqqHIZ9JlAL4e+HYCPCDRsn6NsHnzMkc4xcpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G7TsF/iV; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7811d363caaso574237b3a.3
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 10:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761067777; x=1761672577; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ledmYIP+nkgPWwnc+uPn/2RVeKo8OpO0ythHoInBHKI=;
        b=G7TsF/iVCr3mnZc09Ic/W4NhWimyh3KhJKZIxB73Knx6TAXa+BlkwDm391Vjlc7DcI
         zWm9FbGh+cI7dJQlDwpq4LjSCs+RR5d8mzdEm1tXP9rEKuZB/7wiyYWwOU4o5P6VHyDW
         pk8ZabYJy9sCM1Okb15pllrno0b/9nWnVZSUXqRZc6XFp1pUJMlL8QSX0Al3gJC6gt6j
         dq00VF28YBjSlmmc/O1SX2Kb2jG269nvfnO5jyD1DUZB5gock9qk9slGrsS9kjEI/xJX
         Jq6rAAYRzI1UEjGXQOHLkOCiOom8aBd2LbVUenr098tny1CS3fZ/dn2F4/y4fHlCPWIN
         hLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761067777; x=1761672577;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ledmYIP+nkgPWwnc+uPn/2RVeKo8OpO0ythHoInBHKI=;
        b=t2Mv90MdmDNmX5K1NK5BfDKgUhFHePXU5xNgh3YcICWHI/ToDITwYwDi2UG1IW/Bkx
         hgoCn6UGb1GQj1aYjkOr5YSaj5BE9OY3mTZz/UzQ2cCNvKlGTWwLJh9PHN4ohwAqakod
         rO5cHxLXaoWakO6OC5WGzoL1jTYW0m5CFnFat93bSO+4E25jCVJgBTs+mDQo8R67hweH
         0MW40SJEOTj0eEgm+OUfx6iu8b2kIdIIWbm3hCPlduL/vVSH2eoRZVREnwVft4APPZHE
         5XafpjcQIOcfYNwA9rHn2YOYv41SNc4YE4zgY5BrBZLpagtKtNGfFMFWwF+5vwSTr8Hc
         opdg==
X-Gm-Message-State: AOJu0YwXd48DC36qA+Sjt/xMvVwqsCDpa4he6SwHv1XER+nDNPUwjXMM
	smVU9CWanCsVWmmIUbojhLWRkExC+3pYyGED8SKqYCeMFDI01zChYDX4Rsh5xZKd
X-Gm-Gg: ASbGncttnh5U2Pu9uW7M+k9aKN+6ePzfGPIOap8cQPNBqqCluWmcj3YxYMpsUfxjK5b
	ikZMhZ51pQjxc4ggm4Z+VHHrB0p2HwGOrubdJfgIYnuLHTe9RvzEUORf7Cg4ddLB+wwHRmd9Gag
	Pje2P96GE6OhZX9+wZEhoXWQs3uBj3499fX9v9/KGVY5itf9OkhWqayzIt7rzUZH+9PD0jcUAGJ
	S4NDxBJ/dCwv6PjaJqWQfSaTXnF2TH1+sC7fQale9TqYZKspARiAms+j5w00KrcpPj1NMCOyxc/
	PQ4SUdE9KJ3lrj6RtDBOgrijQt5+LPEMmp9Ovw8E8Qvzr59VqtcUcK5f9V2dvnzDmG0qAh11Du1
	X5vGDW/sk26XLGhjAarNuaDo3tXHIP/eIolyCGCNSqFTdA0y9jtHbJ1j4ijP0gV3/+wOCJFWGoY
	pJaYIdemnsXO1g1H0XV6OFHO7HHwIAw8LJy5710hiAFTvd3GlJM9kN
X-Google-Smtp-Source: AGHT+IFieAhnyzYe7C9i/6QLJHNCpOIimwcmOCoBd9pXtYP+sFSff2MZW43lZN1M6LJpjGGJOhvAqQ==
X-Received: by 2002:a17:903:120b:b0:28d:1904:6e77 with SMTP id d9443c01a7336-290c9d26917mr108005465ad.3.1761067776768;
        Tue, 21 Oct 2025 10:29:36 -0700 (PDT)
Received: from [127.0.1.1] ([2401:4900:c8fb:fb07:e608:6e67:4b89:c950])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471d5794sm113695615ad.53.2025.10.21.10.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 10:29:36 -0700 (PDT)
From: Ranganath V N <vnranganath.20@gmail.com>
Date: Tue, 21 Oct 2025 22:59:30 +0530
Subject: [PATCH] io_uring: Fix code indentation error
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251021-fix_indentation-v1-1-efe8157bd862@gmail.com>
X-B4-Tracking: v=1; b=H4sIAPrC92gC/x2MQQqAIBAAvyJ7TlDDqL4SEZZr7cVCIwLx7y0dB
 2amQMZEmGEUBRI+lOmMDLoRsB0u7ijJM4NRxmpltAz0LhQ9xtvd7MoObWhNvw7KauDqSsjKf5z
 mWj9RO2YQYQAAAA==
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Ranganath V N <vnranganath.20@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761067774; l=2084;
 i=vnranganath.20@gmail.com; s=20250816; h=from:subject:message-id;
 bh=2wVoZ6J5fH+QEIqkn/CT/xdIWuyj0ZyFQwJmlOtInbM=;
 b=HefC25msrxAxBwPPYJyL9S8c9tZbseSOly0CeGYXVusAuIzknsQnZeBHU714jZNgfUl+NrG5Z
 Z3d508W9k8gDQSgYkRaYxXU/QVM+P/YIJsIQdfJ4bdFJDdlvR27Ad/T
X-Developer-Key: i=vnranganath.20@gmail.com; a=ed25519;
 pk=7mxHFYWOcIJ5Ls8etzgLkcB0M8/hxmOh8pH6Mce5Z1A=

Fix the indentation to ensure consistent code style and improve
readability and to fix the errors:
ERROR: code indent should use tabs where possible
+               return io_net_import_vec(req, kmsg, sr->buf, sr->len, ITER_SOURCE);$

ERROR: code indent should use tabs where possible
+^I^I^I           struct io_big_cqe *big_cqe)$

Tested by running the /scripts/checkpatch.pl

Signed-off-by: Ranganath V N <vnranganath.20@gmail.com>
---
Fix the indentation errors in the code according to the coding
style and verified by ./scripts/checkpatch,pl
ERROR: code indent should use tabs where possible

+               return io_net_import_vec(req, kmsg, sr->buf, sr->len, ITER_SOURCE);$

ERROR: code indent should use tabs where possible

+^I^I^I           struct io_big_cqe *big_cqe)$
---
 io_uring/io_uring.c | 2 +-
 io_uring/net.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 820ef0527666..296667ba712c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -879,7 +879,7 @@ static inline struct io_cqe io_init_cqe(u64 user_data, s32 res, u32 cflags)
 }
 
 static __cold void io_cqe_overflow(struct io_ring_ctx *ctx, struct io_cqe *cqe,
-			           struct io_big_cqe *big_cqe)
+				   struct io_big_cqe *big_cqe)
 {
 	struct io_overflow_cqe *ocqe;
 
diff --git a/io_uring/net.c b/io_uring/net.c
index f99b90c762fc..a95cc9ca2a4d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -383,7 +383,7 @@ static int io_send_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return 0;
 
 	if (sr->flags & IORING_SEND_VECTORIZED)
-               return io_net_import_vec(req, kmsg, sr->buf, sr->len, ITER_SOURCE);
+		return io_net_import_vec(req, kmsg, sr->buf, sr->len, ITER_SOURCE);
 
 	return import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
 }

---
base-commit: 6548d364a3e850326831799d7e3ea2d7bb97ba08
change-id: 20251021-fix_indentation-6e5f328b9051

Best regards,
-- 
Ranganath V N <vnranganath.20@gmail.com>



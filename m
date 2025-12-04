Return-Path: <io-uring+bounces-10975-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 85F1ACA5B7D
	for <lists+io-uring@lfdr.de>; Fri, 05 Dec 2025 00:55:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D9C4B30DE060
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 23:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54E1C2652AF;
	Thu,  4 Dec 2025 23:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YAuVnrA1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE61618A6A7
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 23:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764892552; cv=none; b=kQu5ZoottTHEmU2k36QKxIF3lXZjKjJNSwXxzugyU2rw5A44okNgKPXoyLqeESCKLRkoANX8kZuyzt8TyLR7SXW9mo2Ld2Bjma2LrizmtOMuicCsB+7z1KcIyQ/D9pfCzLILqHFAaC0SJiQ9MB1bfBKAmUSKCdgprbiFnSFGzEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764892552; c=relaxed/simple;
	bh=7JtIw1rzomkzW0dDcLUz2wzV6uhsJmPAFMpCyX7CC40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YzPLoF9L0eY8yEX5Aa2o76z2g9sseCPGxnnfpH+xs/G1H0j2V1QUqFsIe0u34tE9iVzs63vkdrRIOvwDYyo44dNCE8XOPcWaZ1ecrcrL05lKuOcNCTx6nIxKtkkLWQx76DGUla/jP1YCjo//nPuuS3L/2CCu1Id7R5Wnl0+O/hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YAuVnrA1; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-298145fe27eso23035005ad.1
        for <io-uring@vger.kernel.org>; Thu, 04 Dec 2025 15:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764892550; x=1765497350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W4iRLQm1PmEHgSrfDDNk5eKNd3l6Bjsw0SUbuD8xOTY=;
        b=YAuVnrA17RNVyk0lGm80yDlT+4w78MzyD3tCQ9XmIzkEOoB+W1DUgsjYbj4iLUoYma
         aUIXhMH68Bx/A2Y1HgB3MM58XttfX0abEkulB8iGTnOKUOIhUCHgnCZZPoUP1iaAX0Nw
         rhXLxqRi4fZUXqdES2BObiBr7+Y/IrLmdM2zK/7Om9Qh92xFW4rfJrmFrBCeZ9LuXdUU
         EjJOPPFof3ZDRmUqtDBEcyhBJnuTTkCBFkAQmNoBl9zRNwn/Ev9VXSVVZhhK4C5W8aJF
         BC1LjnPXp+ZVKQF8zkOIUeDMLjfZfTBx/4kkhY18+unUPlhCSE7RGagCJx/ufGaAFN9D
         WgQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764892550; x=1765497350;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4iRLQm1PmEHgSrfDDNk5eKNd3l6Bjsw0SUbuD8xOTY=;
        b=euSCkrKFngyEtvjCC6LxlglcfT/M6bUdC4HVQs4CBIpxDg8qQyTaq57VWxppl8z637
         5HXMeGdKYBoiwu1lebhUZvYevNt2wGQYekIttVNPXeeZcBq/V0l1NzzR93HX1iO9zD62
         iq5fGFOnKccFlZPmw3DOyNKJiBUnZTJiraDEcvaQnSag92jy3u+qCNlCUvrvv2yalFmF
         AZIre/vP1XW271OFW4QH5WAoU7md99oDqP4Zzzg/wgT5NKmXef2OsFjfAMDwW7cvwRMF
         jdNYykKI337NUygrbQS1y0i1IjEfVSzxDm9ANXRaNXzfgkgdy8s7ugvrmIU5bRnPqwHi
         4Zww==
X-Forwarded-Encrypted: i=1; AJvYcCWAkAodywr1hyzs69OTUYbq4lmDzvBWZQAUd8cD9pI7AqVOK5yaNSWZfRiR3C9MSqVDwDlAy0PsgQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6q3ZbqQvsbpIl/wV24wZebS9eTg8JyqSsmvIcFfo39Um9aDuE
	vmzupgQWWyQrxgyscHp/5CX8+1KAgKFPKg1rQytp7pqWIas2W1SaGcxEdN8whA==
X-Gm-Gg: ASbGncvxj0fCWTUSwD/TvJXbbuy9QmaROzpsOn+Ew0ljR9E72jKiJoXhIlCauKBEEke
	D/5g+1d2PUX/8abnzWxwohFmxps/0Hz+HEVmWWGVL+hLmCVhwsdQpIbk9ne6PqJsxnwLS0UBtyV
	NWS29dIdNgil/txsJ3mVUPooAkJROmozyD8BSVasD81pS65VbyvVz8CVFUtz24jKnjH/7m6HXK/
	LztFLdxGSY89qskLbwsuzqVnDbte4xzETc0FtUylLRZ14r+mFTB2UhHooY+P1vk+5lhCG1Ryxkb
	ctQspGyaoBNRT1/2BGoi51B9xSIRyDWG2PvMNEcrbLFJtUSbJUItx53vhvWxES+hiQMoEYPJHOY
	/kllU0/OcEXqXZ3NK3UdzNf1q9kmHur6EGhuFVhO9gCLrOqQJ5tVugpEAbv6X5RDnB4JPAvFJq/
	QyfPiUusLFy8Wbo0q8
X-Google-Smtp-Source: AGHT+IH/yUHMwkiymyXkS0lmWh7Wc+qfYqe99oZX8cJtAXJ3R3F6Ec/xF3HMo7Rpb/FL6ULvxnXPZA==
X-Received: by 2002:a17:903:1c7:b0:29b:ab3b:70c6 with SMTP id d9443c01a7336-29da1ebb12dmr56750645ad.30.1764892550062;
        Thu, 04 Dec 2025 15:55:50 -0800 (PST)
Received: from localhost ([2a03:2880:ff:b::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae99f69esm30291315ad.56.2025.12.04.15.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 15:55:49 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	io-uring@vger.kernel.org
Subject: [PATCH v1] io_uring/kbuf: use WRITE_ONCE() for userspace-shared buffer ring fields
Date: Thu,  4 Dec 2025 15:54:50 -0800
Message-ID: <20251204235450.1219662-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

buf->addr and buf->len reside in memory shared with userspace. They
should be written with WRITE_ONCE() to guarantee atomic stores and
prevent tearing or other unsafe compiler optimizations.

Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/kbuf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 52b636d00a6b..796d131107dd 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -44,11 +44,11 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
 		buf_len -= this_len;
 		/* Stop looping for invalid buffer length of 0 */
 		if (buf_len || !this_len) {
-			buf->addr = READ_ONCE(buf->addr) + this_len;
-			buf->len = buf_len;
+			WRITE_ONCE(buf->addr, READ_ONCE(buf->addr) + this_len);
+			WRITE_ONCE(buf->len, buf_len);
 			return false;
 		}
-		buf->len = 0;
+		WRITE_ONCE(buf->len, 0);
 		bl->head++;
 		len -= this_len;
 	}
@@ -291,7 +291,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 				arg->partial_map = 1;
 				if (iov != arg->iovs)
 					break;
-				buf->len = len;
+				WRITE_ONCE(buf->len, len);
 			}
 		}
 
-- 
2.47.3



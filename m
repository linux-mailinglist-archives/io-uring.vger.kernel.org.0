Return-Path: <io-uring+bounces-11269-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6253DCD781E
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:37:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5DA3D3028C3C
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 219041F3BA4;
	Tue, 23 Dec 2025 00:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VgLtkr+A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873E81F4613
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450216; cv=none; b=uBjECXYgN4sPph75hwvBqt/dtxcXLuXeeFeihbeEzGGj5hwksLhjQi714yoOpXZldHcxCYvIP6AEDUPr16kvQqxI15cIm3rLcF479T1qaIr92n1RlFpTK1qA9+RcOFzWXSbhECTfN6Z9xxsz+04DugAwf9iJ6BSf+teWkjzCxw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450216; c=relaxed/simple;
	bh=JXMvn1NMlj4tmOrWG0zkpmdnP/Xw/eEoEIkqSGKLsO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmPpyxEFutOp3zhI+fRdZG5RWn81TodRdNhBNjQhdeBl2cz+5aAO6rYRMhD/SSQmHdOppVMGFhRRiaWKVVljI0tPntErlIf+DJW0jPmfkkAcZXMHT/H7AsYeUBtKdJOFk6OLbS5Orkh3ZGNScozTuuo0LWga/5gLGjrGG9uuGvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VgLtkr+A; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a09d981507so32375235ad.1
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450214; x=1767055014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WO1WrE07m4/ps4EUGl0M4D/d+Qo8L6vNQWiuLZIYXDo=;
        b=VgLtkr+AMgkNvXTfKu/adeNzZ1/D49uos5myhvDzjx+9jtSJ89mtUWT0GqRRvxkFUP
         4he2yL+Hi4UYYI69a9GuonCjs+nIo3o6Y94/laANYVnqdVyfM9LGoqeGwIA7HP0sK6jq
         NvOSPOYeCa2oUHl/819KtrfbWazAI+gILdTf0e7pof5UgqN7Mkp1VIH+bSK2RfPdgMWR
         6Mgzfjaj3/0nKKihMwKgDrs7NegZqKfONP+bzsnm8cL0LfHM4cL7Z0/PNU7rWeG2Pk+r
         guTT83CZNbI1Z32S3ir9xh72601pFv5DpUoudTu2ThlCSwJuDmrrKDmNfQqGEOSGuJgR
         cM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450214; x=1767055014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WO1WrE07m4/ps4EUGl0M4D/d+Qo8L6vNQWiuLZIYXDo=;
        b=UPrueVC9aXGPuouefntihxDeoKOxXo/90UcQ2SkTSAGaojb0aX5oReBY+2l+izaXm6
         sgblSvCJq07k/C2YRSxbzrkg7QJk6eGU05oOhogtcw248qQ1h5YO50QSYTBFYcFp3MYL
         cGJ8OmzMc4m1vvZPff9ICsSViMBtxrE3KXp88xPGwH2wp2hN1BGzKV7nxQAeQ0W1sO/9
         VMt3+E+7r92aoEGjih97JyGVtlWLoHhTdPJ1qDANTBnxIKEUyMJV1vkmgm7BWil79/3S
         UL2SPIRNm05g4j/Eiq6UwiffgSzyIbafWf+GOC4dnauSLhNny8fl1Z+gs1rdzdYq6MeM
         7dhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKsAXwaw6ZwSBOJtuFY+CS3t8t6aoHP3CpE/e6yHSVJgv9BK4XWqHUbVDYewkBBmCHn8c5Mu3qsg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwzmbLhYIy8PNNj6ag+sUHZsnCz0W9QiOhdGnIULKxAwWv7qGMY
	w0g1e0yo6xP6yF6EvlhHLVyDGYOuDCebuMDLiPHVdTz3aQRBjB0CBNktjGoTegcG
X-Gm-Gg: AY/fxX47PCtm1fgVFYaqSuqop4mvf6Fe/vvYjhGlm4eys4pYdaSSr/TFCDC/cy0im0n
	HjXIIyU/2EVujS7M6i/QLLQ8eF2F20Q7mCN+LiwB+8RLMOiuHYx4YAftpzQHqpzc/ym3Aw5eruY
	eGCQufPZdypMz4aaHouHdTWAYyMIuqS9z254SdSvVPJoTsnWpk5/7VkUHpVLvroTcNDJxC+J0NA
	6yrj8Zeqj5ZeUKZEpuLHrANwyzAN597asKWGjIJJrW2a8oxhJRHwgzYbLnjpJDMwd8HZOT6NuY3
	UsFyoMsj32WnFAVZQOSEG9HMQisGnRXKlvKWk1noXF3HmowPxOhR0vYuVuQ8Cd/+/PNvNGa7pZB
	k4P+35Tn24Zg+TFXtnWOorLeZO74+8pcwDh7wxVTA5PWqX0hjQL2rCqO2hevKXLz4PZsJaemFVg
	AxrxkqfQF2vyF39MQWtA==
X-Google-Smtp-Source: AGHT+IE4pCyuZIFQFQU8bsV18qI+kogsjCfMOOEuyF3C7Gj5xpFutTyGsXs278O+OfUX6eDn+vMt6g==
X-Received: by 2002:a17:902:f707:b0:2a0:a05d:d4a2 with SMTP id d9443c01a7336-2a2cab4fd97mr144240995ad.23.1766450213803;
        Mon, 22 Dec 2025 16:36:53 -0800 (PST)
Received: from localhost ([2a03:2880:ff:16::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e79a13f95sm10153571a12.9.2025.12.22.16.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:53 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 18/25] fuse: support buffer copying for kernel addresses
Date: Mon, 22 Dec 2025 16:35:15 -0800
Message-ID: <20251223003522.3055912-19-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003522.3055912-1-joannelkoong@gmail.com>
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a preparatory patch needed to support kernel-managed ring
buffers in fuse-over-io-uring. For kernel-managed ring buffers, we get
the vmapped address of the buffer which we can directly use.

Currently, buffer copying in fuse only supports extracting underlying
pages from an iov iter and kmapping them. This commit allows buffer
copying to work directly on a kaddr.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev.c        | 23 +++++++++++++++++------
 fs/fuse/fuse_dev_i.h |  7 ++++++-
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 6d59cbc877c6..ceb5d6a553c0 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -848,6 +848,9 @@ void fuse_copy_init(struct fuse_copy_state *cs, bool write,
 /* Unmap and put previous page of userspace buffer */
 void fuse_copy_finish(struct fuse_copy_state *cs)
 {
+	if (cs->is_kaddr)
+		return;
+
 	if (cs->currbuf) {
 		struct pipe_buffer *buf = cs->currbuf;
 
@@ -873,6 +876,9 @@ static int fuse_copy_fill(struct fuse_copy_state *cs)
 	struct page *page;
 	int err;
 
+	if (cs->is_kaddr)
+		return 0;
+
 	err = unlock_request(cs->req);
 	if (err)
 		return err;
@@ -931,15 +937,20 @@ static int fuse_copy_do(struct fuse_copy_state *cs, void **val, unsigned *size)
 {
 	unsigned ncpy = min(*size, cs->len);
 	if (val) {
-		void *pgaddr = kmap_local_page(cs->pg);
-		void *buf = pgaddr + cs->offset;
+		void *pgaddr, *buf;
+		if (!cs->is_kaddr) {
+			pgaddr = kmap_local_page(cs->pg);
+			buf = pgaddr + cs->offset;
+		} else {
+			buf = cs->kaddr + cs->offset;
+		}
 
 		if (cs->write)
 			memcpy(buf, *val, ncpy);
 		else
 			memcpy(*val, buf, ncpy);
-
-		kunmap_local(pgaddr);
+		if (!cs->is_kaddr)
+			kunmap_local(pgaddr);
 		*val += ncpy;
 	}
 	*size -= ncpy;
@@ -1127,7 +1138,7 @@ static int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
 	}
 
 	while (count) {
-		if (cs->write && cs->pipebufs && folio) {
+		if (cs->write && cs->pipebufs && folio && !cs->is_kaddr) {
 			/*
 			 * Can't control lifetime of pipe buffers, so always
 			 * copy user pages.
@@ -1139,7 +1150,7 @@ static int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
 			} else {
 				return fuse_ref_folio(cs, folio, offset, count);
 			}
-		} else if (!cs->len) {
+		} else if (!cs->len && !cs->is_kaddr) {
 			if (cs->move_folios && folio &&
 			    offset == 0 && count == size) {
 				err = fuse_try_move_folio(cs, foliop);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 134bf44aff0d..aa1d25421054 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -28,12 +28,17 @@ struct fuse_copy_state {
 	struct pipe_buffer *currbuf;
 	struct pipe_inode_info *pipe;
 	unsigned long nr_segs;
-	struct page *pg;
+	union {
+		struct page *pg;
+		void *kaddr;
+	};
 	unsigned int len;
 	unsigned int offset;
 	bool write:1;
 	bool move_folios:1;
 	bool is_uring:1;
+	/* if set, use kaddr; otherwise use pg */
+	bool is_kaddr:1;
 	struct {
 		unsigned int copied_sz; /* copied size into the user buffer */
 	} ring;
-- 
2.47.3



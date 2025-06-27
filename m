Return-Path: <io-uring+bounces-8501-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 57DD5AEBB34
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 17:11:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27D1B1C626B2
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 15:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DB332E8E08;
	Fri, 27 Jun 2025 15:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6ameQzi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830732E92D5;
	Fri, 27 Jun 2025 15:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036965; cv=none; b=Qe9Zvh5YUXyfD3igXHrHV8fq5088zctU6WoUKrtbqxjJ+MAlTDMO8SQeswDYKrxmr2ILW+7Ytvp4N+kYrfdQ37wKNpUeiDGkqI8PtCOM79nAz/aDMl5UoLA0iTydJLc3oG4a0JgdPaCO+UNaaiWa8vyQJhT+vKB5DADy0RceaU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036965; c=relaxed/simple;
	bh=eDHsKiRpYRzuVjZ2vOb67t0mbBdoWWd3qpf4xjrNFbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFeO3/ddBwv997Wgb42ozicXpardZA8V42ixzEJ4B19d4IOzIuhImIH7WnCGpxP+ktht42X9mq+QbpbRTwiGCPnn8We1WK1jN/vrCrNgek88Y1P8FpWL1XIpFHJ4andafPEp9TfyYj+kQ3WbbPdC9ycI/02zGzftKPl7EUFZGvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L6ameQzi; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-607b59b447bso3539087a12.1;
        Fri, 27 Jun 2025 08:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751036961; x=1751641761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELm99uPzefns5ujW7UPEs6wpoLN78rLcaBSD261dIAg=;
        b=L6ameQziERDO4xTUIpVJMM+WjV326II+enhyF2WVLtToQFTAhPTHsHOI+70dm/iqq5
         H2rxDXed4fHqo6yh4MXFOA7X127R6I9M6hwpbTwoy8lNE5q3GM26W9QiRQ3nMgso/XCo
         IGMqELqueheYtDBbLMQCEoiaN6BtkrutChkrMMlXg1qwaoqCWuzGBd/0t9aruB/ck9TD
         Z9GhwwnyClN9A7K7tAj8TZIukWGY4AmYVrSIbFkcjsQoeqN50jz8v0DpyF1tk/TAuXTg
         wvgH+/Y4Sn9wv3FWoPFPI4LQeWvjm7wMX9DfszZKbPr+4N7zwnBBu6jBasc3cAZVJOIV
         A2rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751036961; x=1751641761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ELm99uPzefns5ujW7UPEs6wpoLN78rLcaBSD261dIAg=;
        b=aQwZJ+j19naxqghk8alxzvDk7XiuVpHgIOBsBVVlUOaIN5n5K9anmPNcz3+xF75SgT
         d/6N1bkDQDjICmnkpD0hV++hup9SjHxSu+30+x3gYckocMSCPdPEEsAkV4aZelpyQoqX
         N+MZqJzon8D1bZLZlpdvJGLrGldCDLWVqhVJ0KmPRY6mfrtaYXkuiHvm8iUU4Fum4p4L
         h4BkgtMzyLk6BEUMobxz9T+wQxIb7aybGiMIpp58rAaPQ6Qj760Ij8Fx9kbhVNK8UTiY
         n+auuXN2Vs6M0g4dW9BIXlS5FBSQ/3Be56B+Kafc+D5AF1/4ft0Y5qKRh3tEjizV9Kki
         sOSA==
X-Forwarded-Encrypted: i=1; AJvYcCUN6nSYbvNdztUQq3XcQ+vchKOp3Y3EOAs7UeWFMHkGab1BWecQYnOkV0CCspJAOP0rFD3nbzzDXY/pYA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbvBoLhBvx55Z9yMCmzxq7dOyCBNm4O6CtH6MH9ZUYYLH22DvH
	jBU33Ba8YoJaAmsdPqYNZE3RY6g7x3mH/O8yimTwsSnn6zfIXn5cnU1QE10hKw==
X-Gm-Gg: ASbGncunt4tZulxNnIygaP4EFlqqlv4tlxpOzJE+Kg7+5cCYC7Mkb02LCyvzQ4nOPxx
	z40EIzdbEVnuzJ7+i88zfyK0MgFS2xOUlABGy66lf7tQWda9rr1AIM2RfIjGJjaXpo+FkINQcGg
	J13UnCgzW1lsEK0imDaY59F1a5Msu91lmlVBGA/HyQIJmGnr9d05qtSTdUW4n2VP4vtaguD7w+U
	upxTsvFzx4lVPGxt7dW3YNN3vNv5GeI7QO0jifKaeGkOtA9+liQ9RrL5QzpEBtknilb+rz5YPur
	Y2VuGkYQqPRvGFhYKarjoatK6sUHbIW6L2zG35ExTGOn7/M/7ogqW8N9JZvb83sPvmyrrLn1CWu
	9D0mtH+n/O0g=
X-Google-Smtp-Source: AGHT+IGtD0aKzaeEpz5uiE2KrXY9RJd/4VVbesLyvcMptugbexjQLqKCOv+z9jBUY0enkQpZug83hQ==
X-Received: by 2002:a17:907:724f:b0:ade:8d5a:cf37 with SMTP id a640c23a62f3a-ae35011fc71mr334022966b.44.1751036960987;
        Fri, 27 Jun 2025 08:09:20 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c014fbsm135802866b.86.2025.06.27.08.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 08:09:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	David Wei <dw@davidwei.uk>,
	Vishal Verma <vishal1.verma@intel.com>,
	asml.silence@gmail.com
Subject: [RFC 02/12] iov_iter: introduce iter type for pre-registered dma
Date: Fri, 27 Jun 2025 16:10:29 +0100
Message-ID: <66ec20266c87e323f365fcc82b60f00aef6e2334.1751035820.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751035820.git.asml.silence@gmail.com>
References: <cover.1751035820.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new iterator type representing vectors with pre-registered
DMA addresses. It carries an array of struct dmavec, which is just a
{dma addr, dma len} pair. It'll be used to pass dmabuf buffers from
io_uring and other interfaces operating with iterators.

The vector is mapped for the device returned by the ->get_dma_device()
callback of the file, and the caller should only pass the iterator to
that file's methods. That should also prevent ITER_DMAVEC iterators
reaching unaware files.

Note, the drivers are responsible for cpu-device memory synchronisation
and should use dma_sync_single_for_{device,cpu} when appropriate.

Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/uio.h | 14 +++++++++
 lib/iov_iter.c      | 70 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 2e86c653186c..d68148508ef7 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -29,11 +29,17 @@ enum iter_type {
 	ITER_FOLIOQ,
 	ITER_XARRAY,
 	ITER_DISCARD,
+	ITER_DMAVEC,
 };
 
 #define ITER_SOURCE	1	// == WRITE
 #define ITER_DEST	0	// == READ
 
+struct dmavec {
+	dma_addr_t		addr;
+	int			len;
+};
+
 struct iov_iter_state {
 	size_t iov_offset;
 	size_t count;
@@ -71,6 +77,7 @@ struct iov_iter {
 				const struct folio_queue *folioq;
 				struct xarray *xarray;
 				void __user *ubuf;
+				const struct dmavec *dmavec;
 			};
 			size_t count;
 		};
@@ -155,6 +162,11 @@ static inline bool iov_iter_is_xarray(const struct iov_iter *i)
 	return iov_iter_type(i) == ITER_XARRAY;
 }
 
+static inline bool iov_iter_is_dma(const struct iov_iter *i)
+{
+	return iov_iter_type(i) == ITER_DMAVEC;
+}
+
 static inline unsigned char iov_iter_rw(const struct iov_iter *i)
 {
 	return i->data_source ? WRITE : READ;
@@ -302,6 +314,8 @@ void iov_iter_folio_queue(struct iov_iter *i, unsigned int direction,
 			  unsigned int first_slot, unsigned int offset, size_t count);
 void iov_iter_xarray(struct iov_iter *i, unsigned int direction, struct xarray *xarray,
 		     loff_t start, size_t count);
+void iov_iter_dma(struct iov_iter *i, unsigned int direction,
+		  struct dmavec *dmavec, unsigned nr_segs, size_t count);
 ssize_t iov_iter_get_pages2(struct iov_iter *i, struct page **pages,
 			size_t maxsize, unsigned maxpages, size_t *start);
 ssize_t iov_iter_get_pages_alloc2(struct iov_iter *i, struct page ***pages,
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index f9193f952f49..b7740f9aa279 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -559,6 +559,26 @@ static void iov_iter_folioq_advance(struct iov_iter *i, size_t size)
 	i->folioq = folioq;
 }
 
+static void iov_iter_dma_advance(struct iov_iter *i, size_t size)
+{
+	const struct dmavec *dmav, *end;
+
+	if (!i->count)
+		return;
+	i->count -= size;
+
+	size += i->iov_offset;
+
+	for (dmav = i->dmavec, end = dmav + i->nr_segs; dmav < end; dmav++) {
+		if (likely(size < dmav->len))
+			break;
+		size -= dmav->len;
+	}
+	i->iov_offset = size;
+	i->nr_segs -= dmav - i->dmavec;
+	i->dmavec = dmav;
+}
+
 void iov_iter_advance(struct iov_iter *i, size_t size)
 {
 	if (unlikely(i->count < size))
@@ -575,6 +595,8 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
 		iov_iter_folioq_advance(i, size);
 	} else if (iov_iter_is_discard(i)) {
 		i->count -= size;
+	} else if (iov_iter_is_dma(i)) {
+		iov_iter_dma_advance(i, size);
 	}
 }
 EXPORT_SYMBOL(iov_iter_advance);
@@ -763,6 +785,20 @@ void iov_iter_xarray(struct iov_iter *i, unsigned int direction,
 }
 EXPORT_SYMBOL(iov_iter_xarray);
 
+void iov_iter_dma(struct iov_iter *i, unsigned int direction,
+		  struct dmavec *dmavec, unsigned nr_segs, size_t count)
+{
+	WARN_ON(direction & ~(READ | WRITE));
+	*i = (struct iov_iter){
+		.iter_type = ITER_DMAVEC,
+		.data_source = direction,
+		.dmavec = dmavec,
+		.nr_segs = nr_segs,
+		.iov_offset = 0,
+		.count = count
+	};
+}
+
 /**
  * iov_iter_discard - Initialise an I/O iterator that discards data
  * @i: The iterator to initialise.
@@ -834,6 +870,32 @@ static bool iov_iter_aligned_bvec(const struct iov_iter *i, unsigned addr_mask,
 	return true;
 }
 
+static bool iov_iter_aligned_dma(const struct iov_iter *i, unsigned addr_mask,
+				  unsigned len_mask)
+{
+	const struct dmavec *dmav = i->dmavec;
+	unsigned skip = i->iov_offset;
+	size_t size = i->count;
+
+	do {
+		size_t len = dmav->len - skip;
+
+		if (len > size)
+			len = size;
+		if (len & len_mask)
+			return false;
+		if ((unsigned long)(dmav->addr + skip) & addr_mask)
+			return false;
+
+		dmav++;
+		size -= len;
+		skip = 0;
+	} while (size);
+
+	return true;
+}
+
+
 /**
  * iov_iter_is_aligned() - Check if the addresses and lengths of each segments
  * 	are aligned to the parameters.
@@ -875,6 +937,9 @@ bool iov_iter_is_aligned(const struct iov_iter *i, unsigned addr_mask,
 			return false;
 	}
 
+	if (iov_iter_is_dma(i))
+		return iov_iter_aligned_dma(i, addr_mask, len_mask);
+
 	return true;
 }
 EXPORT_SYMBOL_GPL(iov_iter_is_aligned);
@@ -1552,7 +1617,8 @@ EXPORT_SYMBOL_GPL(import_ubuf);
 void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state)
 {
 	if (WARN_ON_ONCE(!iov_iter_is_bvec(i) && !iter_is_iovec(i) &&
-			 !iter_is_ubuf(i)) && !iov_iter_is_kvec(i))
+			 !iter_is_ubuf(i)) && !iov_iter_is_kvec(i) &&
+			 !iov_iter_is_dma(i))
 		return;
 	i->iov_offset = state->iov_offset;
 	i->count = state->count;
@@ -1570,6 +1636,8 @@ void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state)
 	BUILD_BUG_ON(sizeof(struct iovec) != sizeof(struct kvec));
 	if (iov_iter_is_bvec(i))
 		i->bvec -= state->nr_segs - i->nr_segs;
+	else if (iov_iter_is_dma(i))
+		i->dmavec -= state->nr_segs - i->nr_segs;
 	else
 		i->__iov -= state->nr_segs - i->nr_segs;
 	i->nr_segs = state->nr_segs;
-- 
2.49.0



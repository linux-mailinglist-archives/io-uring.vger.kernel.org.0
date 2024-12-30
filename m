Return-Path: <io-uring+bounces-5633-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ACD99FE670
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 14:29:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A144C3A1F80
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 13:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AFBA1A83F0;
	Mon, 30 Dec 2024 13:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FjoQSBwo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF8A1A8407
	for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 13:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735565390; cv=none; b=bbihbwqk22FDcW+c1Tgjp//t/yMBa1wH7GrTbvuMmoLqxUf+gn6TE8ZERmLdwQIVFZlGqJwEzW3CrP+oQS5VdYq/muBbn6uX58psDgZJijH95TiZyVI0Mm4qk58U3otD3CxhLFT6uY8zQgy3C/bqzD4ncsYuoYuCajUXO/ObFwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735565390; c=relaxed/simple;
	bh=QbfFPINu0lMzqOcIlrJHsO09oZ0sKO+OcaPoE6+GzKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kdrh27tmhstO/InHcEZr7NxSBjL1CTbsYsEilNTT63kEU4uE5+iD8wZKXagxVldCOr/Ch0s8QB/QnhQ0lmaP0PYZ1T2m+ANJVKXTc2kMBUZ51wYHhdf3aCHInWy3IxfsjRs8Sh5Qy9wvs37OvxqrZqqu8guzNBedo4h0GfBpqhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FjoQSBwo; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d3f57582a2so18105049a12.1
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 05:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735565386; x=1736170186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IbqMDu4h5fm/YGER5C62CbEH0I5y3CLxfXkq+w+swJQ=;
        b=FjoQSBwohLH/kcqiiBY0VkxQino3iiim9NAlmMLEYDDXYz3T9JHPG7wGe9aKlZnOGk
         YUeHkw+88IV9yc3RiGsCMdo+CPSS04Yw3uMh5wGnciSRX/E0KLQNxl0cUPJIXlgrO4q+
         S7sh9Vel0WTqG6tNVvwAL6Kek3yYJ9/kAycCVezizPmU/k/AWe3wUvtvgf8jQL7aoc3H
         9cB/q4Aj6Hu9lcu2SElKko73243QSSIZYXIt5Jf9ft8KfSk02clHTXjXrjQRWigif9nR
         ZW43039jzAmyRb1qkok7AGLWt3CsF9u5pnJy0KiWL23TCHsZD0acqCI9N7/9Y5bpWNxq
         ik9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735565386; x=1736170186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IbqMDu4h5fm/YGER5C62CbEH0I5y3CLxfXkq+w+swJQ=;
        b=jo/wUlsnEvm7jBjrBxtpAIOUJBITK8u9z0d+cLVxlt2BLUrVqJUGx+H1YMnN49iLI6
         nfPM7CMWUIhOiBlESVaW4uIB0vkE6TdMFRNyE8KGihFPAWk9/0+etoolEE49SvbDi/9b
         rqXYaqzzihsxJ2CdlZHFI8we2W9clTB8+RWwxUAVury1vpM4aQ0sveOoK7war70f77ED
         OLwz5E72915MJJpbyK7cHrp+g55eHbiVDYShDgOlZzaRZPDulyaqQMRhooAaIt36il93
         /htw69Ai6YW8mktkBhfN+QCh2rsnfZiiLMV3UHi59MNBxOfbFFKB2fDSRZH1+6mD57oo
         ZmuQ==
X-Gm-Message-State: AOJu0YxcycNcQslOslOg8MhGWZ08LubIxXVuMXWB6ER3MxjhYaJ/2Qz4
	W5YthpMqNlLvdXqZ83mIUqZOc/oSbfC100FNxLFZlul6QyxS8uxA5EuSUQ==
X-Gm-Gg: ASbGncvsSVjdz399dB2ExC0OvN8i3xfwX+eV0EEWfIrwemjpIvpESKukFzsNlXG7c2D
	Wx9jRQ4/J2ihODhHayu3BtZJPZT+1A+UPl3wXrC6qvWvA2wDOXd267bEt04y23hl1QqZpg05k85
	JXdoM4ayeZ/rcmXEGdmrVSlqTfO/ADgrAdqytBck05Bh+7zrwlju1siwp9shu0ENFxjCmUjBCoS
	VclTwNvKrN7Ng09wV7otovHMlTF+zCuwa6yT9ZwXi75fpEVCJi2sib7iwzAgqElH6ORMQ==
X-Google-Smtp-Source: AGHT+IHAcRCcJx0naousjL/x8lCegSX/+cuGOf+cvLLpn5xyMOd6pLWwAiZYL6pE9MUqsVvccTs0nw==
X-Received: by 2002:a17:907:7207:b0:aa6:112f:50ba with SMTP id a640c23a62f3a-aac0815366cmr3610280266b.13.1735565386201;
        Mon, 30 Dec 2024 05:29:46 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.209])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80679f35csm14694286a12.51.2024.12.30.05.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2024 05:29:45 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 3/4] io_uring/rw: use READ_ONCE with rw attributes
Date: Mon, 30 Dec 2024 13:30:23 +0000
Message-ID: <fbe4711906a9680da6be390548f916d7e2da15c3.1735301337.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1735301337.git.asml.silence@gmail.com>
References: <cover.1735301337.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to pre-mapped attributes read struct io_uring_attr_pi
with READ_ONCE and use an intermediate pointer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 75f70935ccf4..dc1acaf95db1 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -264,23 +264,29 @@ static inline void io_meta_restore(struct io_async_rw *io, struct kiocb *kiocb)
 static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddir,
 			 u64 attr_ptr, u64 attr_type_mask)
 {
-	struct io_uring_attr_pi pi_attr;
+	struct io_uring_attr_pi __pi_attr;
+	struct io_uring_attr_pi *pi_attr;
 	struct io_async_rw *io;
+	void __user *pi_addr;
+	size_t pi_len;
 	int ret;
 
-	if (copy_from_user(&pi_attr, u64_to_user_ptr(attr_ptr),
+	if (copy_from_user(&__pi_attr, u64_to_user_ptr(attr_ptr),
 	    sizeof(pi_attr)))
 		return -EFAULT;
+	pi_attr = &__pi_attr;
 
-	if (pi_attr.rsvd)
+	if (pi_attr->rsvd)
 		return -EINVAL;
 
 	io = req->async_data;
-	io->meta.flags = pi_attr.flags;
-	io->meta.app_tag = pi_attr.app_tag;
-	io->meta.seed = pi_attr.seed;
-	ret = import_ubuf(ddir, u64_to_user_ptr(pi_attr.addr),
-			  pi_attr.len, &io->meta.iter);
+	io->meta.flags = READ_ONCE(pi_attr->flags);
+	io->meta.app_tag = READ_ONCE(pi_attr->app_tag);
+	io->meta.seed = READ_ONCE(pi_attr->seed);
+
+	pi_addr = u64_to_user_ptr(READ_ONCE(pi_attr->addr));
+	pi_len = READ_ONCE(pi_attr->len);
+	ret = import_ubuf(ddir, pi_addr, pi_len, &io->meta.iter);
 	if (unlikely(ret < 0))
 		return ret;
 	req->flags |= REQ_F_HAS_METADATA;
-- 
2.47.1



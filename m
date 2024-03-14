Return-Path: <io-uring+bounces-950-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8815B87C4B5
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 22:22:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3068B225B9
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 21:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D303574E21;
	Thu, 14 Mar 2024 21:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mppfw1Qu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AB176C63;
	Thu, 14 Mar 2024 21:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710451292; cv=none; b=inAwotot/ReCsI4mKh1soV18u/9xnAHrZa1aeu5Ld/BhJYb0d0ZsBug9FHa8Q5CLN+OGQM6nUAFbibtddVhjjRvdU+5Ke8zefcoLQeLujwQ0+xEXbU5GzNhQrZVlZwiLwoUisufufXpXZW71ut/0U638QsQUtGJ+reQBh2oQD7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710451292; c=relaxed/simple;
	bh=Ef5/Ey0FsbDtHW5wtQ6HdF+C18tpOXHnlB3rr4fR2v4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GRsCRB+hX10RdIvUH0Oz9yX3zErZRPf1YB85QciB3By40qYtbV3D/5aVkaxVN6tDKbZb7E2n6lBZgyJuSrTvjKi896jftuqd6oYxM2kz07KprdnrsFitkP9JgH3uPspawktmbi0FOMDJ/5437+IWBt6MGziTqlTP608iwZxV2rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mppfw1Qu; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6da202aa138so891936b3a.2;
        Thu, 14 Mar 2024 14:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710451290; x=1711056090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lIdjsnxO6N4MzycqZb/h5F1aroW4/yAYPUPnkFR/3H4=;
        b=mppfw1QudHb4utR+xNsyoLeN69pFPysTxDb8IhFOCJDOGjOyLrIsC0IyprX3n1sxL5
         9+L8Osv/cr0XBJiPAIZSN1uLrrk1f+EBIA946+wgPpfTxHRIzGBO7mLH0JqeYwRKQl5E
         UC01aIxFDCHUlMdbjjSvPy87w2xcN+RF3eyFIkkSzbcgo+tsUlzVGO7Wrp5G7/rqNyza
         XTsmhMiQm72e02JJmgUS4HpKkUDMMb5YVu2+uPkJZJ3w6rZgfMmEFqV6yztT9VNinDFw
         n5dnPHgbRAHyx8X/mNwQaZeF1lin9voKzjo5C/OYzlS5zNnxyOSMlILZQxmNGY88zQGs
         7zvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710451290; x=1711056090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lIdjsnxO6N4MzycqZb/h5F1aroW4/yAYPUPnkFR/3H4=;
        b=QdFkjkWQsvvNDDcyt9WIHQymplvJ9mJ6pFPmmEVrkfBnQGUvph2e2umw0c4J5efnx2
         cKXMaRYBMa6Ape6OCtUTpIIO+fBl0gG3r9Gxa32+9SDyefcuKVddoyrfs4SOo/ccOlwY
         DluNa1iRA8MMb7g/+FKJfHyUl0E+tATO197rVRqviYMzMjTRIg1mD3Z+lEj6fyEJmRPS
         9sqMGGloA5lUxw+1++RnITRxHoqw9wOK92EL01hEd3Oxy1dAWAjWPWrCbK8drqBmhSJW
         /W5s5AOfn4B0NoZUEKTZQwkHNQg2F3wX+xiPFyqgIvX7aWaCHyl8WFlz0z8KIBNZs+fm
         8rHA==
X-Forwarded-Encrypted: i=1; AJvYcCUXrZo38LtBjGhUbaJEqRkSi5KnK8MVbaJJXjjKn4l5uYTh3AlHND+zWKg2JJLBeXvNnBS00bd5+pAD9F3V9xw1DP17TMyQJ0KV8kkzCXpAevI9RaTs+WjK9G7GA8oMP6B7tPAdD/M=
X-Gm-Message-State: AOJu0YxsJQs83hD3o5CEKtSFwEblJroUYPOTrlTGU2pHnyn/zAb1Zd7v
	BZeK6YcoqmUnOAHy1ZhOE9ExNESJL+/klIQOpM/UXcu7317bLyRe
X-Google-Smtp-Source: AGHT+IEdTeu5r/rtOOnJ55wjGudUVIpE6tR2ThyI1kBqfmVuxNiBVoZ6vxAY9udM6+LkUx8oMSpg3A==
X-Received: by 2002:a05:6a20:8c9f:b0:1a0:f5b9:bd88 with SMTP id k31-20020a056a208c9f00b001a0f5b9bd88mr1243953pzh.55.1710451290522;
        Thu, 14 Mar 2024 14:21:30 -0700 (PDT)
Received: from localhost ([2408:8207:2572:7dc0:31a4:b729:4b7a:d450])
        by smtp.gmail.com with ESMTPSA id p19-20020a056a000b5300b006e04ca18c2bsm1978280pfo.196.2024.03.14.14.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 14:21:30 -0700 (PDT)
From: Xin Wang <yw987194828@gmail.com>
X-Google-Original-From: Xin Wang <yw987194828@163.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xin Wang <yw987194828@163.com>,
	Xin Wang <yw987194828@gmail.com>
Subject: [PATCH v2 1/1] io_uring: extract the function that checks the legitimacy of sq/cq entries
Date: Fri, 15 Mar 2024 05:21:17 +0800
Message-Id: <20240314212117.108464-2-yw987194828@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240314212117.108464-1-yw987194828@163.com>
References: <20240314212117.108464-1-yw987194828@163.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the io_uring_create function, the sq_entries and cq_entries passed
in by the user are examined. The checking logic is the same for both, so
the common code can be extracted for reuse.

Extract the common code as io_validate_entries function.

Changes:
V1->V2::
  - Replace function name 'io_validate_entries' with 'io_validate_ring_entries'
    to enhance readability.
  - Removed unnecessary parentheses.
  - Line Wrapping.

====================

Signed-off-by: Xin Wang <yw987194828@gmail.com>
---
 io_uring/io_uring.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cd9a137ad6ce..4c3580229283 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3819,6 +3819,19 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 					 O_RDWR | O_CLOEXEC, NULL);
 }
 
+static bool io_validate_ring_entries(unsigned int *entries,
+				     unsigned int max_entries, __u32 flags)
+{
+	if (!*entries)
+		return false;
+	if (*entries > max_entries) {
+		if (!(flags & IORING_SETUP_CLAMP))
+			return false;
+		*entries = max_entries;
+	}
+	return true;
+}
+
 static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 				  struct io_uring_params __user *params)
 {
@@ -3827,13 +3840,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	struct file *file;
 	int ret;
 
-	if (!entries)
+	if (!io_validate_ring_entries(&entries, IORING_MAX_ENTRIES, p->flags))
 		return -EINVAL;
-	if (entries > IORING_MAX_ENTRIES) {
-		if (!(p->flags & IORING_SETUP_CLAMP))
-			return -EINVAL;
-		entries = IORING_MAX_ENTRIES;
-	}
 
 	if ((p->flags & IORING_SETUP_REGISTERED_FD_ONLY)
 	    && !(p->flags & IORING_SETUP_NO_MMAP))
@@ -3854,13 +3862,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		 * to a power-of-two, if it isn't already. We do NOT impose
 		 * any cq vs sq ring sizing.
 		 */
-		if (!p->cq_entries)
+		if (!io_validate_ring_entries(&p->cq_entries, IORING_MAX_CQ_ENTRIES, p->flags))
 			return -EINVAL;
-		if (p->cq_entries > IORING_MAX_CQ_ENTRIES) {
-			if (!(p->flags & IORING_SETUP_CLAMP))
-				return -EINVAL;
-			p->cq_entries = IORING_MAX_CQ_ENTRIES;
-		}
 		p->cq_entries = roundup_pow_of_two(p->cq_entries);
 		if (p->cq_entries < p->sq_entries)
 			return -EINVAL;
-- 
2.25.1



Return-Path: <io-uring+bounces-10403-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BD99C3B20D
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 14:14:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 977CB1B21AD4
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 13:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 092321DF27D;
	Thu,  6 Nov 2025 12:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1dKOEQb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD26329C6B
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 12:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762433908; cv=none; b=B58sEuht1PlmRevQ+JEJ3kDfVaK2UuvmMnqfNj+TB/opbjhalkKlvykvDu2aJFVULa8c5kCSNERleqF+pnylF2KRjXOC+bEHUCBF1R7jnplIMR0sHdgIFLKpVrxAgQjjqek2245QujdN2/C8OaKp9Eqqb/okdgOiCesobHCaEQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762433908; c=relaxed/simple;
	bh=8Y4iTPPZHPB2g1cVrWTzZ8Irl7Gq1qY0f3Elt/KJLr0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k7BiBni/2YP0bgAssGbaw/+Qz1ey5Ob83LBzbt0CTC0dPq48F2LQPNa3y98Gt4ykSLFjH4K/3ylVsQ5h4A1oWvXomG/A9GWQPFCtk46i9CuoShnE9UiDjCZnLbb8BU2brB/8uoFXZctlbPARYO4a30uJOUJgDbMb+9QtZuiFVH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V1dKOEQb; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-429bcddad32so707271f8f.3
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 04:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762433905; x=1763038705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zqDSavrnoocFN08EKJXS6ikrQLOdk++AvsYJHHfqKM4=;
        b=V1dKOEQbb9vLCN/q2tO05Fe3y9rP2/UBzFud3pLlahd20F19Rtk3zZ+V53uL8bnV6a
         44Xj9oycKO2fEegPunzty+D0iQMLpUS3W5IOg3M5uKAxgVISBBcWFG7hAWVSDRggIXza
         zafziVU+kjNTyYTvQnk5PqMtcvWC9Up1mJcNmzu7p0u/Qiqbyw8UftuAZN1kJFYnwNgu
         jtMM95Gx7EzPYGEcnAXbNTLcW6DNdWpxZT6Uz8e28dC5o0pQ8aSwk/KWj7lQgJd2PXDN
         +qsgjn12gr26kBeZHGIZ3RzEc90i5lzLbaA8BbMwA9q+UBP2896kNC9nScYLqKER/DFp
         O67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762433905; x=1763038705;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zqDSavrnoocFN08EKJXS6ikrQLOdk++AvsYJHHfqKM4=;
        b=iiuk5YquazpO5VpwySJu1q7Oh4A7tHrW1Da2Pqgo7vvuuWEof6eKRr1/kMky690tP2
         LGSdOW/onpLJIfjvq0ekNGDvbueEMHW5gkokKakq+lAzaaBLgxOQ/UEBrXnwVlNoMSFH
         mm+Zr6mR3DeIuBxVi4Bk96iG82vWwri/8O8rSaTUkklUdg2KX/2MVygYnEKPT7hskDHx
         kJKAGHAmY/Hm8Vb7lBQoYzDDsGtVc+GpnSxZ7w4E6v1WUp0PYT/+mBzi6izbLZepC2tN
         6AiaJXO4itWe1DQSW25FC/UkQPlpJIwpph6X+s9nYiWNbe8vX8rQRoWrV0DIqcRWpU4v
         J7Zw==
X-Gm-Message-State: AOJu0Yw9Uh0Acc68L0PaLGwhU/7fnRelyWF+v4XYISRHq0Ri2aE6oE35
	tfhgZ6o7++cTme/53NXbKOmlnaZMpFpmhbLwIEGOQqbfL2DWyRQigOJKa5eAhw==
X-Gm-Gg: ASbGncudR0MPEp/qFc6D1AkaX2AXUa0Tj33X86XYZmB2ZSmlXuyxoTNmmlqd3T0c0gF
	fg24GdUL5zUwMlpWT0IgpxVlXrdcoEOpaBE6Ee5ZKJFdedEMXsv3eXTfc5PhtYV874qKiZDoGdr
	oQpH0DIjVBbMJQ5r6UB2r9qU0Cb0D9ET4CJXuW5MhpnOdq0IMM7G0phbzH0wcOy+RSo54RhK62s
	NHlHLeKW146KnjN85buLFqhcbQiSMhqFUDVsERaPGeEtmKkzHWuBqgKQP0ju7N9bPxvhOVkiDDe
	boVw/ML0l3s7s4Ob7/ePzByOLRRrIYnfzT2nx0Cn5q9LP8h9dI57xWDOZRMZqkJh6Lt2/Zc9pvq
	O388t009hq36fl+lRJLHuKAX+3vvDEBlr08lVm1IP3b5O6SNL4mMMqmWfOChKJfvQ1taTJeZUHu
	sh+hU=
X-Google-Smtp-Source: AGHT+IF6YvuK9bPMCXLiCLW+qw11HoHtaX3L14HGG28NyL8yoYPXg/kk8a5od5hxCJLcy1l5CmZiYg==
X-Received: by 2002:a05:6000:2dca:b0:425:75c6:7125 with SMTP id ffacd0b85a97d-429e32e36eamr6255830f8f.16.1762433905202;
        Thu, 06 Nov 2025 04:58:25 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb410fe5sm5010392f8f.18.2025.11.06.04.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 04:58:24 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH for-next] io_uring: use WRITE_ONCE for user shared memory
Date: Thu,  6 Nov 2025 12:58:19 +0000
Message-ID: <5b7c8fabbb00cd37be00f828c48c2a238f06e60e.1762433792.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IORING_SETUP_NO_MMAP rings remain user accessible even before the ctx
setup is finalised, so use WRITE_ONCE consistently when initialising
rings.

Fixes: 03d89a2de25bb ("io_uring: support for user allocated memory for rings/sqes")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Mild, and no sane user should be affected, hence tareting for-next

 io_uring/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3f0489261d11..f9f8ffcdad07 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3386,10 +3386,6 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
 		ctx->sq_array = (u32 *)((char *)rings + sq_array_offset);
-	rings->sq_ring_mask = p->sq_entries - 1;
-	rings->cq_ring_mask = p->cq_entries - 1;
-	rings->sq_ring_entries = p->sq_entries;
-	rings->cq_ring_entries = p->cq_entries;
 
 	memset(&rd, 0, sizeof(rd));
 	rd.size = PAGE_ALIGN(sq_size);
@@ -3403,6 +3399,12 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 		return ret;
 	}
 	ctx->sq_sqes = io_region_get_ptr(&ctx->sq_region);
+
+	memset(rings, 0, sizeof(*rings));
+	WRITE_ONCE(rings->sq_ring_mask, ctx->sq_entries - 1);
+	WRITE_ONCE(rings->cq_ring_mask, ctx->cq_entries - 1);
+	WRITE_ONCE(rings->sq_ring_entries, ctx->sq_entries);
+	WRITE_ONCE(rings->cq_ring_entries, ctx->cq_entries);
 	return 0;
 }
 
-- 
2.49.0



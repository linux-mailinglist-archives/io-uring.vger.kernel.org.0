Return-Path: <io-uring+bounces-10906-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9195DC9D6AC
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:37:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C172C4E4C0C
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF6A219A79;
	Wed,  3 Dec 2025 00:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GwixbHac"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2379F1EEA5F
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722209; cv=none; b=uZqX+djjM5grrJEOtMgmeq0BJIh6s8d16RAQZCzN2TI7RKxcLiKUVZH2+sKxcWYUVeK4thkrQ8v+qgphz0fXpqFsNsQc8RbUcyLBNco01QfjqKfYq+aEL2w6F0NV3fTFHrpQqgB89lISsfxpQ6dDVbekLJ3jetGAcoodujmNlgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722209; c=relaxed/simple;
	bh=ShsPwaa79sbU4M2ZNWao+BTPNiaoXLHlnrWxkhIxQFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZog1zWekoaDu88HFt/VRk3w4O5wAI/kO4i9lJFGiVioELQ4fDdDRRnX7LGWlALaRJ6C9jstyK70oK37a/tIPOFs+XQotyGF6sG8YGtQY7Xlr2yTaHyuZnYjF0wUDQFmq3BZ2bbtfmdmZXH8KmBNUz10/aNHdXxHL1TS6Qlb4eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GwixbHac; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7b9c17dd591so5451724b3a.3
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722207; x=1765327007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i+lXe1UbyArO+9gy/07dcLXREZ7CEHk9KPUjbt5UeiI=;
        b=GwixbHaczrqBr0yPINal+Bn689mfuoxgjvYxHKexoO7Cypi27CvOUZHIYkZy5EkOoF
         e4Jz3+pPxZi/VOLYMz0eJKjw135SRuqNul9GMEfdHl0bJx1y+mch3m5WiCC/a7z99Mtz
         QRWBMYQ0GUMT/cznoedeqbTKYW+jlj3xxQ6I4qdSt9kQaMEwSBdkjJDiGM9RnC+BhpdP
         mJHwTcVQzRlMA7Ql/8xyTDE7UIFJROxO1JXFOHw8Fq6hOVVVZW6Jg4rhxQvD9cuy9FQC
         6CtHZvXH0gXABr5nO1B70Erjpe+bLrzvMfnqPWGbYy1Mc84+7d+fTmdQ6PP8nwZSLt/4
         J9/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722207; x=1765327007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i+lXe1UbyArO+9gy/07dcLXREZ7CEHk9KPUjbt5UeiI=;
        b=ilDj8G4xrgtwHxnM9yVCITJZdN2EPDEhTcLkfzeNx9ngcGpywI3p64L2jjk/Bd9aPw
         /QuEPgSNoVTL2iwBh+g3U/B/4DRNwzRyW1CxRC6Vj55325xJAGs1lKllUc6Kqnz/aW4H
         yu0nsw8jZfjPwkf4pb88gmRlEX7mbgt7Zdz4YgXTH7s4KK8+gZQrx4TYLwf4VIbeZuhs
         G6yCs6/Ow1Mw0nWLQL4d1nVYKjmbCHVbrxYJQEylhpTemgWKcbZrYeV4sc9VB7iYk3Qd
         mzauylSOYO2en2CtMWKtXpzR07MxATUaCB8G9zsH1Z6oqSIhj1kPWrbpbwB59cJv9g7R
         YgqQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9wJV0VitFVQFWqdHtFoaWS9mDqfo4CLPZgZD1TOrPxuohpE/+0fm3J4zMg3Q4ldVEE0F1mUQikg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3gXrSWS6diefSkYBAQsdV/1R1MJ02T4IWBloD85aPSUWnNU9/
	v2CRIFsPXsr3AWSzrXQ860mKTVXA+F0GYA+3DIF8E3hGkI+4i+VWp5+H
X-Gm-Gg: ASbGncuJSN1RfqNdXtDSVy57a3Jeivg/coNB5ga+LDZReMyEJIU6mqLNp8YP0ijJQLS
	KUk+sfKi8Yw8xmMDWrrof8/mfaHv1r+rcCd0pZDbfIMV3/5YWCLp1nH0u6mjzX+GiJIN5pr77Cp
	XE2dzY6Z7VkXCnD6MxX7VYrOW9tVZz+R/jyZyzuQR5LfzcVijDduz5pyRuCdDMu3E6aOZ7UxgCQ
	Lh/MoZsDepXIGOgSMxybpufOibNqAGaoI7jgQT+wImtGUEX2f1jV5yLMoNTJGYnfY4qAn5RrUmT
	20Gob61i3g9D64MwVa2c1V7XfNtblZm2FCFPjwwsk6oWIlbp2x2+Z79Gi7BNyb5AX4Pmwoc1C4q
	cJOxFw15JHowxThfj9m0IOegg6ibTKzA6DS+1x7COA6ck1o1j0yZTZwgKCwIYAVJtSzoFLHGTUm
	hUF8yGrjkozMlrALPWdg==
X-Google-Smtp-Source: AGHT+IHGmXFRYmNYu4mG5FEegRAmBVj6PM5FVTftWbC9NdYNznU0I8s5pAIlTgPC5Uk/by9n4hlm/A==
X-Received: by 2002:a05:6a00:10d3:b0:7b7:631a:2444 with SMTP id d2e1a72fcca58-7e00eb72335mr387471b3a.22.1764722207504;
        Tue, 02 Dec 2025 16:36:47 -0800 (PST)
Received: from localhost ([2a03:2880:ff:55::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e7db416sm17921048b3a.41.2025.12.02.16.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:47 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 11/30] io_uring/kbuf: return buffer id in buffer selection
Date: Tue,  2 Dec 2025 16:35:06 -0800
Message-ID: <20251203003526.2889477-12-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Return the id of the selected buffer in io_buffer_select(). This is
needed for kernel-managed buffer rings to later recycle the selected
buffer.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h   | 2 +-
 include/linux/io_uring_types.h | 2 ++
 io_uring/kbuf.c                | 7 +++++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index a4b5eae2e5d1..795b846d1e11 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -74,7 +74,7 @@ void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
 
 /*
  * Select a buffer from the provided buffer group for multishot uring_cmd.
- * Returns the selected buffer address and size.
+ * Returns the selected buffer address, size, and id.
  */
 struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
 					    unsigned buf_group, size_t *len,
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e1a75cfe57d9..dcc95e73f12f 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -109,6 +109,8 @@ struct io_br_sel {
 		void *kaddr;
 	};
 	ssize_t val;
+	/* id of the selected buffer */
+	unsigned buf_id;
 };
 
 
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 8a94de6e530f..3ecb6494adea 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -239,6 +239,7 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_index = buf->bid;
 	sel.buf_list = bl;
+	sel.buf_id = buf->bid;
 	if (bl->flags & IOBL_KERNEL_MANAGED)
 		sel.kaddr = (void *)buf->addr;
 	else
@@ -262,10 +263,12 @@ struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 
 	bl = io_buffer_get_list(ctx, buf_group);
 	if (likely(bl)) {
-		if (bl->flags & IOBL_BUF_RING)
+		if (bl->flags & IOBL_BUF_RING) {
 			sel = io_ring_buffer_select(req, len, bl, issue_flags);
-		else
+		} else {
 			sel.addr = io_provided_buffer_select(req, len, bl);
+			sel.buf_id = req->buf_index;
+		}
 	}
 	io_ring_submit_unlock(req->ctx, issue_flags);
 	return sel;
-- 
2.47.3



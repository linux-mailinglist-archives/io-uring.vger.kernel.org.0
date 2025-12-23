Return-Path: <io-uring+bounces-11262-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D0D91CD7836
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:37:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 551C93042193
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A8B51F8AC5;
	Tue, 23 Dec 2025 00:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mXTQYrpC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13B41F4613
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450206; cv=none; b=TyGgjUghGeWbJGzG3vSh5IZO4D2YXUI/hVf1qWtTqOntZRbZGz2zTelucCF/prWQt0l+n6l/co3sui0M3gu4PFLu6GFe7F0jnL5+cpPklIB+pArCfpZ3oAFOrSxoM6HNmQpevJgSYiyvDQQ81cP7xa67WvpKTkziNRFHKF9djM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450206; c=relaxed/simple;
	bh=gAS+5nvhHfNLnUGd74jbD89fTGsBX3kMDyd3KPwDyh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvSlsgj8Z6s2123kPsZIrc3LSrOvnxArtXlZuZFQ8/NJBL5K5GQZ/tcMsp2LdmufxW2JzfnWI1ZvZiVCqRTZdp8DLGI/X7v4ywzL7emS8kx3N+hFTq3eOSnpHAyqYY2TZfwd/C1AWq84XvDfxyscH6LWWRgZ67hHFeDG1GzhTus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mXTQYrpC; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7bb710d1d1dso6295363b3a.1
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450204; x=1767055004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r0YCRtWYjVTW/fPYCph6jhVkg3gRscX9ucync488Qng=;
        b=mXTQYrpCJoK69H3fiDi5AVZ9lwznPpu/4vi3fLrNjjO70ez99OkYBvpI1XelrYfJx/
         881Dz2aOAoKvLelm3/v9W8BjEbl/QrGuH8Agvi0SAhEgKO575jO0bRJtcPCW2Y+su/9x
         UtiKS0n0kncDkvQnwLsidy0PPzFjrI/F30Ccrjb8DOek9lg+rzxs0VuGhtJ9vHeQ9ajx
         uUPm7tvl9CU7AelzGMSyIcVG1mYed2OBdZvNyJKvkmJrJfTWK9kZ0A6KBNHSw/fing/M
         E0vIvhScxXo7/dSZLUHyI+QJO0sAgPONQmZ9LpwKIb0J8/CgJFBCi8PWjPblUTUIBU7k
         vOSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450204; x=1767055004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r0YCRtWYjVTW/fPYCph6jhVkg3gRscX9ucync488Qng=;
        b=ughlFG2qw84ckLdEPR/wi/9cjIeq+qWVi0E4AIbljLzfSeUKej/8/iMcH8fCrLlPdf
         8YBMR0diuBGdNoyhAgqgQeXvmGqaVAA2E+Eq+bzLnq57QDTacaTiOT/PZb+Ptj7Xouki
         4MlVfvm3K5z/5gFE7B2LARB9YR4c1yCEml62RyMTfuOiPVj9OLZ4+8bts8hLxZQ6NUW1
         /eYfDTXZL1+nD0SmIYh8SIaozi/AvvgtljOPSGEASivQJINtwmvnC+2Zktqou14xtJF0
         0KYldNiDQnRlk8INC1z65O2jhykgZmfVSz+rVvKd/HmwxvM2JHFJmswYGm3f03K5uu2e
         bWAA==
X-Forwarded-Encrypted: i=1; AJvYcCVEp6kfift30SWgRAkm3B2bTnItJxhuBbWmrlXecceOAJwQqaPmwC32sQJrlKSGgonqFe4H3LLZrg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt7JcorjCbuxS6wKfzlkTYwQyneDrNa2sQ2m+Qi+shIrmy+YAL
	UTiwQAIVfVJin5DVRrTZd88xxuIwBKTrWXC4U54jvuI8P7sfw1h0/iNT
X-Gm-Gg: AY/fxX7/LPJtci3WWJCFoiVS0NlTjfB314lFnZLiqyluCPKYh7CrzXnA1lY6M79woe1
	VLUOV43X9HNPf7I1xjElJ2ck4uwCNf6XJaTIr9Z/MGCVwQXon6813quItzGrpdI4WwCP9CZfmwI
	OUGueZCzvbFhyEUFMrXfkM19lj+LsubcJ+o0uoWxmBOU3M+WkqtiQN5fQZPdbj99hmanubxs/IO
	tybY0WT0HcstKr0WAM8mp3RQ8gUkGp4evKXvJlVuF20kcFB9M+/FwtL0fK7tlcg+z3ji2RR0R9c
	0Ym0Pk+qA9WWyIzzi6SXJtTLT5DjziakFGiqWPigQtju4RlBy5AN4YLH8RUssewlEMNYOYjQbo2
	Hz/DAx3ZMmNzmbaU+/o12+eFu/HT5VATF4RwV3qznfkqPONtFzS0hhqnifl8Ym1ZP6rPNxs46Np
	OLUTc5agynOWfnp66/
X-Google-Smtp-Source: AGHT+IF1pPK17TdPeRJBi+slRixALFF3NrUY0hW69c/oByl1h+VgSeIHwRkwUm015flmJyaYu/dcLw==
X-Received: by 2002:a05:6a20:7292:b0:35f:84c7:4031 with SMTP id adf61e73a8af0-376aabfb873mr12899003637.55.1766450203919;
        Mon, 22 Dec 2025 16:36:43 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7bc68ab5sm10598725a12.17.2025.12.22.16.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:43 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 11/25] io_uring/kbuf: return buffer id in buffer selection
Date: Mon, 22 Dec 2025 16:35:08 -0800
Message-ID: <20251223003522.3055912-12-joannelkoong@gmail.com>
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

Return the id of the selected buffer in io_buffer_select(). This is
needed for kernel-managed buffer rings to later recycle the selected
buffer.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h   | 2 +-
 include/linux/io_uring_types.h | 2 ++
 io_uring/kbuf.c                | 8 +++++---
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index a94f1dbc89c7..61c4ca863ef6 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -77,7 +77,7 @@ void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
 
 /*
  * Select a buffer from the provided buffer group for multishot uring_cmd.
- * Returns the selected buffer address and size.
+ * Returns the selected buffer address, size, and id.
  */
 struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
 					    unsigned buf_group, size_t *len,
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 36fac08db636..52fce7eba400 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -100,6 +100,8 @@ struct io_br_sel {
 		void *kaddr;
 	};
 	ssize_t val;
+	/* id of the selected buffer */
+	unsigned buf_id;
 };
 
 
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3b9907f0a78e..ff1c13b22702 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -248,7 +248,7 @@ struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_index = READ_ONCE(buf->bid);
 	sel.buf_list = bl;
-	sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
+	sel.buf_id = req->buf_index;
 	if (bl->flags & IOBL_KERNEL_MANAGED)
 		sel.kaddr = (void *)(uintptr_t)buf->addr;
 	else
@@ -273,10 +273,12 @@ struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 
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



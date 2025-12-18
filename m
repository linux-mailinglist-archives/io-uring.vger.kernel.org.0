Return-Path: <io-uring+bounces-11191-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D02CCCAF71
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:42:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 359DB30ECB71
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B1E532ED59;
	Thu, 18 Dec 2025 08:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JKQeSQ6t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CF23328F0
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046893; cv=none; b=pyW+bsM5Ta0RBvrCbnP6vVfXcMdv5CfJoFmgNNi3ye+6LotQL/DnB37/joUffxZS2L4+BQLWp8lH+RLhvigsXgP7k/VkYipaGjamartQjfQAOEfVfzthjBiKHTY4SJd/p6TV7dNa1TSovIWCMdotrQuekykHt78I6sXpbWTX9lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046893; c=relaxed/simple;
	bh=e1bzDdMw3lGxDg8Sru6rT5gQh782mYNGvlyuvSRqizA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hK7zvT49isXt8UU+juVrggvYVpU9a7rfNU5QWendeev8luC0TnjXz8WsmHYt++Q4jYF8twsEI6yZwvV61BV9QjT+4SfHEaCDwp+kapga/iHOJNCR+phVWnHY3ewyizwWnQ+qBOSSd/BqIZGZoANJXqMX7PhFL+HcZENfmwtrzjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JKQeSQ6t; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29f30233d8aso5101715ad.0
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046892; x=1766651692; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1rGFTOCAYqkXBjrHwunh+T+I9Q/f/4yUcJVgD0CCNU=;
        b=JKQeSQ6tuplmY0f61ePqhTUgZcjEyFrwD5U9vZY9XR51zoSF9thfCMvgZm6MyDRp2K
         8m451Q+kvVZMKMU/z20WxOLlk5B5YkrLdJVUNjBcYPV4nXN42uGVOdKbBDLbTFfE6nDa
         N9VfD5PH2ZL6PBX4QISSl1tWTuKQ4xtcR6NkLK4LjFDQ35XuHZ6320977DCWiW7NM3iG
         t+s+G6Ew3I7CsgYhKN/DLFgrEfoXewSXFBbZcb0JaZYMxVksw8Oq7+FYttF6bCfWGg9D
         SesWdxed7mG8xM2+WQ/YYUgpDYgWyZ9LmaCC/tGVVrUzPfMxxnf7ruSOKhfAgU43ANxH
         o8bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046892; x=1766651692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b1rGFTOCAYqkXBjrHwunh+T+I9Q/f/4yUcJVgD0CCNU=;
        b=sv5q0T5pjsSsSwAonMruXhmnHPFnk1srxkmldapwa0i/MzaBEc4iNUJdm94hfi2nxa
         EDoWJE8lNiBJC1gyaUMmiE6qGjOumQqwd9IocSSv6niRV3haILqIkYlJGSpnSyhfhe1F
         yJZ4koq+94bXDKsz8Loi3HF+kCtpAdomwMQ/Mk2w2vOYRSDv+fT5Rm0WtobsAvBpoQDd
         PzjfOxSE94AV9A3QRZHD3k4skaBZkgzC41x8BvocsTlUhBZoPDE+igBZ9nJfat1u3KvZ
         Cf7ZRsmehxzSE6QgE/pZLZniTlPzMaaGSn6Wzt0NvhNSWhKSJQiZKOE+zGEbCCytYTde
         n5Gg==
X-Forwarded-Encrypted: i=1; AJvYcCXNdK2I0IOsWsYGulk6pbAXjWpZ4kPLjDppK2J5kScx0H9AJWvAmjdl1bbJ8soFTGVpul9jOHRxVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOTaVKtz5rKLdso7FLA36PdyFfaH5MusB5ZmEqhooVVf6eVCnw
	kykghUkEAgxSFbTASZs+ATICkY0KiLs+n7oUsQNxJI4RwNezVh0C2TnriGd8rxQ7iSM=
X-Gm-Gg: AY/fxX6WkvVCJ1m2uLD/zRBIQoFXyJwQ0082/sUSsw09b69/qc4KjX62LvBeki/S2M1
	/j9ZVjwWWi8xD1n3AJPTv7vG96jzhiKuSVVZkKTGVoMPE63IBPfXeJA8cGlIoajE6UoAJ070bah
	IQ7Kt+89BAWPf6o0fC7oJQ6w5MPoJOko1TiQtLN7JDl9nZfQVeER+OcOtwU8C8R4XnzGhCSk3BF
	nvl2ujtVdYMDakf05iyh4gV+//hIYMuHCPXFVwWLrhFyJICOfkRc9RM/5z6gl8iZUi8X1IavJGB
	KeOFKDJNDiRHd4Tj37YiWqsgDWz9JOie9DycOi6/a63zPEzi24SjIQtHyNE/0XeQZpRwJnYbLH3
	eJ1aLrucqUceBM/CM71S1BXINCvSJKS8LZZ+8xee6QrGqfp8eMqAdSFk9TAQmqkzb/I1KUPIT9U
	cAmHCrHKtDU2eSnI7iig==
X-Google-Smtp-Source: AGHT+IGATMoQVpdqaL0J9UUxt4g1r2cVMkTOzgwlrgkVuuFllBZ1R/NqBZ9+j43nYuxt0z9t16wDxw==
X-Received: by 2002:a17:902:f647:b0:2a1:47e:1a34 with SMTP id d9443c01a7336-2a1047e1b30mr128776765ad.0.1766046891911;
        Thu, 18 Dec 2025 00:34:51 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4e::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d1926ab0sm17178015ad.75.2025.12.18.00.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:34:51 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 11/25] io_uring/kbuf: return buffer id in buffer selection
Date: Thu, 18 Dec 2025 00:33:05 -0800
Message-ID: <20251218083319.3485503-12-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
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
index 3b1f6296f581..d9beebb3aed2 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -248,7 +248,7 @@ struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_index = READ_ONCE(buf->bid);
 	sel.buf_list = bl;
-	sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
+	sel.buf_id = req->buf_index;
 	if (bl->flags & IOBL_KERNEL_MANAGED)
 		sel.kaddr = (void *)buf->addr;
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



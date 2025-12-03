Return-Path: <io-uring+bounces-10921-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CF56C9D6F8
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:38:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A7D93A3891
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 703A6231A30;
	Wed,  3 Dec 2025 00:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y1kfGTwL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1BD257423
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722235; cv=none; b=BEF89RNzxs6M/ZDH3mxI0L0UKZtEMDFS8ys9RltgY/IcwQdpbzwjIKu21TD5v6RQA+DPyB7MHFGACu0nr9Z0i6MKUIiZfvL+RAkjSdh37P5oq7wQuF9AurOg2TeGrDSE9S5sOyBxBr45ICNBgeM9qG3BSXkS5sMt2eyni64BVrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722235; c=relaxed/simple;
	bh=NteECKVIVVgYKooISthTyycJwAldk9Y3xjnTi0eeAPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJsve8ZB1TC90T4blACqvDMqeu33Jq7WlUH+KKQxgoClDJV9P4bK/IGgq2UgAcRak5wV5ZUqx0t0GxGC+QGxyiOAAbnPcRrSFqt5HoJz/webgVIMSuyhLs2YOp1r4kGkm7fYTifK1MCYla3mRugh7Rjawd/+AhAutZTvltUQi8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y1kfGTwL; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-343ff854297so8058981a91.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722233; x=1765327033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+hOnndXDYjC07Cd5bj8P769YKU3lF3tazToIcpHTmgw=;
        b=Y1kfGTwLnk0D6Ie4U3TyJlJqvZeUmxvyD1tpEJ3C0GQRl6NX/KahZdJ122XWt7CJas
         CpJ3IuhaQ5kSMtjT/9ipaFQHuHg2g77mTnjYrMo+NWz+B+MyhGCSEudlfIMSvWrYIiFf
         vavccI/h/sbcEBVoJwKBSUPACjuIkIqo5Y6Po9pki8SfIOTwBgXMFXlsTjus3nvFLHYm
         ebgHhXuI6zURK3eNH5geJ9CM2esvARgoor2MOGJagf/oUA4SbU4q/YAwSzPoA5oJoVVH
         Qnq33x+Eb2M+Kt6UJwG8Vah1GmK8Jy55jTjKE0Tz+Dxl6sGLi3zM0XGrhpfbHg0plAZb
         e4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722233; x=1765327033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+hOnndXDYjC07Cd5bj8P769YKU3lF3tazToIcpHTmgw=;
        b=X7xvZeu/mClwzmgIV0+0VnMjRnF3Ih09gTeAqeOKPf/L0WTA6Be5bfXJ6HQpTEBEJn
         ubk5Cc+/4iHoIqiJsia8W+e5+d9s/ugS/xsrQyvlFtGAwJTWRjKFCicO1RCOizHZfEns
         Z30iAPyQhDO2prXVpPqFHjzk6ZKzNzasWKSipnU4K6YexiAT6XbTxvBn7opTWTYdReXK
         yFbN7cJHRZO/UfU+gGxwfNVlVkXmHSTx355g5EmlIpjwn+xhTmCo0xszEDKA7yQ3VUrE
         wCqAxyzayaUWhWEYGVFV05el8JXFrEmYdZLFoZbsa9+rybt+N0twHot1AvNjgBr2KI/w
         /Png==
X-Forwarded-Encrypted: i=1; AJvYcCVWRNf9R8ASmg7NrRzNapZJ28/tGdlUT52i+uF8H+r8dFLVoMI3vnwu75ckUIHyR/4tF+0bVBSN7g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzZVZisqmOLAWD5Yx9Acz1+ZLmmOXn1e7mI6YdHliNa3p3+5jFN
	xXgQ1TWAjCf5paMTPRkygknImyzMTXxRIzEhfPiX1UmUflnIY374zJQQ
X-Gm-Gg: ASbGncvRkRJX3pamcoDp6nSrraRzVIZkuzo552CWH1iHaLAk9RpNHlJB6OXKu7q+/GZ
	sITNgIFke0a1Byb86OTcSjbol3n7KilYGymyID6RIq55fyESnNVLvtm18fWDq2r+VAb0804R97V
	hL6LWS+ulNJMCrdadr8zRCEbEr12DkjoXq0XwhyASfvkJ8w5Q7a5YCWbQgEXYoGIYb+yq6ZLBjT
	9Jij436azQUCUPN+5KlBJTHRWu+zXjXmBTlvwAHEvQGyY+ke22Gk1VygkfYs+QNTSYVZR5Oll7i
	n4A2Lg+Hve1ocpEMIOVaaJGOQ3TaJR0xkUGVvynRsYlDdQqhxXLHhA1LMArEchMVjetxXHChjyB
	jAdBWU4hJx7F1PacpjTkg4oq4hb5tki2iJwQGs3awZnMNFuZkwTDv5uUuNgnxYdfIB6KGKu9viy
	DyEaRKRsv2mUJ1YWUAUA==
X-Google-Smtp-Source: AGHT+IEBZ9bJnnKX7zklgfezY86cmHLETX/f0CSmcbvnnK2PAAoNq/3+pM5i3ocWedTdgBWDmIGkXA==
X-Received: by 2002:a17:90b:5445:b0:33b:8ac4:1ac4 with SMTP id 98e67ed59e1d1-3491284b104mr571398a91.35.1764722233222;
        Tue, 02 Dec 2025 16:37:13 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5f::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34910eca7easm596212a91.17.2025.12.02.16.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:37:12 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 26/30] io_uring/rsrc: export io_buffer_unregister
Date: Tue,  2 Dec 2025 16:35:21 -0800
Message-ID: <20251203003526.2889477-27-joannelkoong@gmail.com>
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

This is a preparatory patch for fuse-over-io-uring zero-copy.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/buf.h | 9 +++++++++
 io_uring/rsrc.c              | 1 +
 io_uring/rsrc.h              | 3 ---
 io_uring/uring_cmd.c         | 1 +
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/buf.h
index ff6b81bb95e5..078e48b63bff 100644
--- a/include/linux/io_uring/buf.h
+++ b/include/linux/io_uring/buf.h
@@ -28,6 +28,8 @@ int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct bio_vec *bvs,
 			    unsigned int nr_bvecs, unsigned int total_bytes,
 			    u8 dir, unsigned int index,
 			    unsigned int issue_flags);
+int io_buffer_unregister(struct io_ring_ctx *ctx, unsigned int index,
+			 unsigned int issue_flags);
 #else
 static inline int io_uring_buf_ring_pin(struct io_ring_ctx *ctx,
 					unsigned buf_group,
@@ -84,6 +86,13 @@ static inline int io_buffer_register_bvec(struct io_ring_ctx *ctx,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int io_buffer_unregister(struct io_ring_ctx *ctx,
+				       unsigned int index,
+				       unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_IO_URING */
 
 #endif /* _LINUX_IO_URING_BUF_H */
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 7358f153d136..08634254ab7c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1075,6 +1075,7 @@ int io_buffer_unregister(struct io_ring_ctx *ctx, unsigned int index,
 	io_ring_submit_unlock(ctx, issue_flags);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(io_buffer_unregister);
 
 static int validate_fixed_range(u64 buf_addr, size_t len,
 				const struct io_mapped_ubuf *imu)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index d1ca33f3319a..c3b21aaaf984 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -95,9 +95,6 @@ int io_buffer_register_request(struct io_ring_ctx *ctx, struct request *rq,
 			       void (*release)(void *), unsigned int index,
 			       unsigned int issue_flags);
 
-int io_buffer_unregister(struct io_ring_ctx *ctx, unsigned int index,
-			 unsigned int issue_flags);
-
 static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data,
 						       int index)
 {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 3922ac86b481..dfceec36f101 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -2,6 +2,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/file.h>
+#include <linux/io_uring/buf.h>
 #include <linux/io_uring/cmd.h>
 #include <linux/security.h>
 #include <linux/nospec.h>
-- 
2.47.3



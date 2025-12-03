Return-Path: <io-uring+bounces-10913-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 85030C9D6DC
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D90984E4B24
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531703A1B5;
	Wed,  3 Dec 2025 00:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mR6/ssUA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97803221FBF
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722223; cv=none; b=j5tpUNbcS6Fif1SaozYpcLvb5oiwLoyjymm5qUpD1/j+bXWPmOmi+O9V8zGxd2Ml6KsXUwjSbfNjQvHcclFxlu19QQiyS5dBWDymWnMzPJ06dZo0+2aN1k2IehfsnNF2W/xaZUXi7IPoeHr/68JwZkKcvZdF5mZZ3ALQ2j09YIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722223; c=relaxed/simple;
	bh=9zbdRQa5U1WLeoH5boQGAcxtyf4ds0If1PxNAfsMtqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoANlPExbd7wtO3ScG/0dQA6TZqjXEnCJgfjkmhGDkl4/zjf4qgfwlqDFNhmD39QjPjY1nEPMItmk7pT20FJFwJZszdCHjswtB6QNtKuveDgptm5zD6H5wL2Knxr8TEeOIoyDJakDebPIGvTME8rURHj+XfX5v3xvU0NjD0j9u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mR6/ssUA; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so6715810b3a.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722220; x=1765327020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZfmCPWKHjdJmwvEJc9zhie0v6QHYRdYOxmgZuC/D3tU=;
        b=mR6/ssUA0CzGA/k/rIex5D5XxlyvlMwUodWcj/Ua4M0fXUP/z0IYWhd/lQ1ffn8Rcj
         UmehPYQAxb/164p/Gla4SDEu3U7j8iiP+VFS0urqrDAGmt0jC6LTVWKUFypOK7EwqSgr
         HxOOqNnDqR3/hwDOgO5v8tIqTZ7mq8VAeuKucXDFITPNhaVryQXVexLmJ3mbUxlPhefE
         KielOEV8DFM1NMvkc7o73t7U5z0XL5szavQeY82d34MzbpMvm0WwLmOJv2ISVD629SUb
         erHEsS0Qs2FEISqFrlaCjP7Q3SxD6f+cCmWqUfp8NQ1j1FCjS/ZbR2BY8KhTD5dUKld6
         cv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722220; x=1765327020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZfmCPWKHjdJmwvEJc9zhie0v6QHYRdYOxmgZuC/D3tU=;
        b=gsMXM5wDh7Qvk2NhbGI4RuS41TCD2jr6D53jHOFniyV+RXdWhaXAKbJE+nsniTShWF
         6zgb3svhGLfxFp2V6p59NWMbXzUoOtSL0LIK6bKBFeaYp2HdvxCPDnDPRdgIFSCo8kmc
         ulmsU253yW2y90X/OrL3YPxwE7Ag+Gxc1nOxWEx9qs5LXyjcLw0KW3/H3IHPzDzCOxbh
         a7xOloh4zmhETnO78eXCv62tvrIqeC7Vi2HqLnUqPaXPb9ea4cBULd63FdiZMH+WDDrB
         mwbWIUvFpxCvgYFxtC0mXAHh/S7g33746Ded061jOcXW3HMBEsaN4VfjHmO6+M4y41sP
         Dgsg==
X-Forwarded-Encrypted: i=1; AJvYcCWdm87L5mObZwWyU73b4pKopGDhyt1bJfitd9uTZERYRlDn56rmgyTDSJDS86qodnjd/WrimyycNA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDY1pSnKFT9zre7scYOSS/v1yOoRENXQww5sRYa7m/09a3lKel
	AhptK+CQXuwFDY1LbXV30hTONC1CqnkZI+cQ7+NFLof+bcrzkHSej1hm
X-Gm-Gg: ASbGnctn0xYnNRlYisJlSJp3+WsKMMtHoN74/baA5YX25kODsDx4NMhhdoHYSqqGUyl
	pF+rtyb0dUUZHhq4/bqfLstGmTvT9KQet6z+IV4JVUKIY1PcCbeJHmLiHp6Ofa5Qd5RdBR1zjkJ
	8rxZwQZfDlqfZ127+yMa5YGG0WviWYDid1Agl2ietdU4zR42bR5ILWGIHJaWwSBFWxTJJZi/12P
	5ziTSWYrtDQc0WtXxU2gwY/y3o7fH+vZCITSjsg48L5CHzNCIXG0JmFged7Ulo+yTqYYsZFqpBI
	bZAWP1jRGF7Qfpo/vCpdz8zhTjTOhCy08zFFbBeepcVxD3F8IctJVUWOU5nBgLWytfTpyIaOkL3
	i1mMTuLDzegvIv/bxd+ojPRqcYfm74FlGxmeCFV4yfIvkRSPGiS8cnlM/Nxce15YGaTqVyNvg8g
	pn+7z2W5SG+W3LILEbrA==
X-Google-Smtp-Source: AGHT+IEqZu3aQkfNLXXgbqXRDKhCyzeWgCHn5gWirZsFGdWGcy02UvsRGyw2W+fl/OvavhCSloNsPA==
X-Received: by 2002:a05:6a20:6a1d:b0:334:912f:acea with SMTP id adf61e73a8af0-363f5efe97bmr812965637.59.1764722219823;
        Tue, 02 Dec 2025 16:36:59 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4a::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-be508b06867sm16005992a12.23.2025.12.02.16.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:59 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 18/30] fuse: use enum types for header copying
Date: Tue,  2 Dec 2025 16:35:13 -0800
Message-ID: <20251203003526.2889477-19-joannelkoong@gmail.com>
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

Use enum types to identify which part of the header needs to be copied.
This improves the interface and will simplify both kernel-space and
user-space header addresses when kernel-managed buffer rings are added.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c | 57 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index e8ee51bfa5fc..d16f6b3489c1 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -31,6 +31,15 @@ struct fuse_uring_pdu {
 
 static const struct fuse_iqueue_ops fuse_io_uring_ops;
 
+enum fuse_uring_header_type {
+	/* struct fuse_in_header / struct fuse_out_header */
+	FUSE_URING_HEADER_IN_OUT,
+	/* per op code header */
+	FUSE_URING_HEADER_OP,
+	/* struct fuse_uring_ent_in_out header */
+	FUSE_URING_HEADER_RING_ENT,
+};
+
 static void uring_cmd_set_ring_ent(struct io_uring_cmd *cmd,
 				   struct fuse_ring_ent *ring_ent)
 {
@@ -575,10 +584,32 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
 	return err;
 }
 
-static __always_inline int copy_header_to_ring(void __user *ring,
+static void __user *get_user_ring_header(struct fuse_ring_ent *ent,
+					 enum fuse_uring_header_type type)
+{
+	switch (type) {
+	case FUSE_URING_HEADER_IN_OUT:
+		return &ent->headers->in_out;
+	case FUSE_URING_HEADER_OP:
+		return &ent->headers->op_in;
+	case FUSE_URING_HEADER_RING_ENT:
+		return &ent->headers->ring_ent_in_out;
+	}
+
+	WARN_ON_ONCE(1);
+	return NULL;
+}
+
+static __always_inline int copy_header_to_ring(struct fuse_ring_ent *ent,
+					       enum fuse_uring_header_type type,
 					       const void *header,
 					       size_t header_size)
 {
+	void __user *ring = get_user_ring_header(ent, type);
+
+	if (!ring)
+		return -EINVAL;
+
 	if (copy_to_user(ring, header, header_size)) {
 		pr_info_ratelimited("Copying header to ring failed.\n");
 		return -EFAULT;
@@ -587,10 +618,16 @@ static __always_inline int copy_header_to_ring(void __user *ring,
 	return 0;
 }
 
-static __always_inline int copy_header_from_ring(void *header,
-						 const void __user *ring,
+static __always_inline int copy_header_from_ring(struct fuse_ring_ent *ent,
+						 enum fuse_uring_header_type type,
+						 void *header,
 						 size_t header_size)
 {
+	const void __user *ring = get_user_ring_header(ent, type);
+
+	if (!ring)
+		return -EINVAL;
+
 	if (copy_from_user(header, ring, header_size)) {
 		pr_info_ratelimited("Copying header from ring failed.\n");
 		return -EFAULT;
@@ -609,8 +646,8 @@ static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
 	int err;
 	struct fuse_uring_ent_in_out ring_in_out;
 
-	err = copy_header_from_ring(&ring_in_out, &ent->headers->ring_ent_in_out,
-				    sizeof(ring_in_out));
+	err = copy_header_from_ring(ent, FUSE_URING_HEADER_RING_ENT,
+				    &ring_in_out, sizeof(ring_in_out));
 	if (err)
 		return err;
 
@@ -661,7 +698,7 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 		 * Some op code have that as zero size.
 		 */
 		if (args->in_args[0].size > 0) {
-			err = copy_header_to_ring(&ent->headers->op_in,
+			err = copy_header_to_ring(ent, FUSE_URING_HEADER_OP,
 						  in_args->value,
 						  in_args->size);
 			if (err)
@@ -681,8 +718,8 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 	}
 
 	ent_in_out.payload_sz = cs.ring.copied_sz;
-	return copy_header_to_ring(&ent->headers->ring_ent_in_out, &ent_in_out,
-				   sizeof(ent_in_out));
+	return copy_header_to_ring(ent, FUSE_URING_HEADER_RING_ENT,
+				   &ent_in_out, sizeof(ent_in_out));
 }
 
 static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
@@ -711,7 +748,7 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
 	}
 
 	/* copy fuse_in_header */
-	return copy_header_to_ring(&ent->headers->in_out, &req->in.h,
+	return copy_header_to_ring(ent, FUSE_URING_HEADER_IN_OUT, &req->in.h,
 				   sizeof(req->in.h));
 }
 
@@ -806,7 +843,7 @@ static void fuse_uring_commit(struct fuse_ring_ent *ent, struct fuse_req *req,
 	struct fuse_conn *fc = ring->fc;
 	ssize_t err = 0;
 
-	err = copy_header_from_ring(&req->out.h, &ent->headers->in_out,
+	err = copy_header_from_ring(ent, FUSE_URING_HEADER_IN_OUT, &req->out.h,
 				    sizeof(req->out.h));
 	if (err) {
 		req->out.h.error = err;
-- 
2.47.3



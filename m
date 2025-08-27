Return-Path: <io-uring+bounces-9304-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 897D6B38399
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 15:20:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A91281B6655C
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 13:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7465F1BCA07;
	Wed, 27 Aug 2025 13:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BOPOWsSa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7088298CC7
	for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 13:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756300799; cv=none; b=XvWpN4hIa4ZardEOabMNqx2nX5IqMPW/L0jCmu6t0tIiTtEAPOK4iUdVliv+2cMzm9oAolnregD6dIn89WpnONZYfHI+F93+uYq1CURs+lP3/t/DBBUA8wJyWRhzDiN1/tV1r6kEkqQDh5FjOF47GzUaEiqwZ9dsPMfbgszmbfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756300799; c=relaxed/simple;
	bh=9CihXvK8I2dPvot5dktr69KT/dur071wrPk7u5h41dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUPg8DH9VpTGWg1duiiC2I1nC3WqiwmwH/Eyi+qoH3ZRGXdUUQSg8Q561k/65zAxDhJ3dKPNBydpMnINDKfrXYbapCN025KbgDXXMs7pg9uYEy5qcoo+/xjhpGpVsuDGnBnRJ8Q1shG/QV8aeR+qBh+zKO0qMvuhIhWuWohCdaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BOPOWsSa; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45b4d892175so34660465e9.2
        for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 06:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756300795; x=1756905595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zz5iR5Itghwnj9zwKDl9tq9v6O15lxNL/l95WBYSHzU=;
        b=BOPOWsSaFxsfDmOYgvdt2AYlTiBEWgeJ00hIDQutKp0Q5/53+VYcRd218xzhdJkySB
         b4k5ihGt0LkoenSta2s9L4E5Mm8f6fsxhhvvgxb5+LI9TyoTqyDbGfHuZsaQf1HYPdVo
         5Pb8gWbE+cGwsfnc7RcG4ylCBfnpjqwekeq4h5HPL5nr+sNUdEYV/i4CTQO3WZLa0pbX
         TZqU5QsK7LubTNJboomjwUNC1hjSpFa8/Xe/eVyS1NSLg5XzCdf/zcY0aI+zpVn4Zi0y
         d3V3+IeI/2VfMkCMblCIqj5zLRPXcDJRw5WzJhBF4K0Hlc6Arzzs2cI8ruu3LcxLuq3D
         bMzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756300795; x=1756905595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zz5iR5Itghwnj9zwKDl9tq9v6O15lxNL/l95WBYSHzU=;
        b=BcxPVyldvJ4ws0Smt9RoQY30phW80PkrWbPzOVlSQlYKmrAE8nWKmCUEilaWqhYrbB
         Mj1sACvrbXvcChSTrBvrsUuqlzJufjGp4d1mI0vKpe8w/8Rqy4f9kVY42JDjelMAHeRr
         T+fMB2FaOxDy83wrSxxnORn8dH0nK9lUB68u/TF78gyjlH9NsN5K//+AIj2VbntiQrwo
         SaAnlblfStWlvw6Gy43IbAjiw84+t0zOGfhdOSPJXGqAK56dlc/6j3QhLiAt++PiQVJC
         fqb2bfly9Pg8enqbHNAW5Y7KyNynz8D5oxLlCz0uftS0XFAAynhIRaCGDmrmp47C8LXK
         +ybg==
X-Gm-Message-State: AOJu0YzT7GUhXtLSMilVZjIcn/7Vg5U8G1vBexwVOJuy/ES7sxmP/tWu
	WbopdW0oZm5O8ugQGeYzD5+EYGXavxo3gPapxgKZPW+HPpqVi9eb48iYePqeFw==
X-Gm-Gg: ASbGncvhNm9eU+Cuikg39fj6RSkSoMwuDFpFMLsYljC2B2HWQQ+yhwwVoFrSKIUr20a
	elyIEnXsIpVLm5oaaYWaNj9YeuSuHvpOh+O21JUNV4kBAi2jD5j7iA7i4rIYjn9xmWzqCKMtX05
	BkZchD+e8yGJn237GiEBJtbQz0o12c1qo4Sta1l4dHFsSicyjpZ9ytUTWUt3CWsXExE8PDf5McZ
	4+ngm/EjC2Aocc0wiICTc4b6OqPLSQ7O/Nh9LrU4RD46eS2AeeI7VgC7eiF1PdT6mKXAV/dEU0o
	y305MdGh0pUcLqnyIDcqhbI183wILpCu3q/2zsIbl2tbAZkU8Lh0S6hsWiCADC5lLnKT9dMS+ob
	tIsOG7VeTRGZsvMx7
X-Google-Smtp-Source: AGHT+IGCN9/WwXAYtfwPN3RX7qP1eVopAT6fTIEVN+xTcGZfc30rtNb1CTy0rzzB+5XsraBvSsRLCQ==
X-Received: by 2002:a05:600c:548d:b0:45b:6f48:9deb with SMTP id 5b1f17b1804b1-45b75858134mr1858585e9.28.1756300795400;
        Wed, 27 Aug 2025 06:19:55 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4a19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f306c93sm30170305e9.14.2025.08.27.06.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 06:19:54 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC v1 1/3] io_uring: add helper for *REGISTER_SEND_MSG_RING
Date: Wed, 27 Aug 2025 14:21:12 +0100
Message-ID: <8c4cbc22dfcf1b480fab2663cfda7dcc013df3ab.1756300192.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756300192.git.asml.silence@gmail.com>
References: <cover.1756300192.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move handling of IORING_REGISTER_SEND_MSG_RING into a separate function
in preparation to growing io_uring_register_blind().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/register.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index a59589249fce..046dcb7ba4d1 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -877,6 +877,23 @@ struct file *io_uring_register_get_file(unsigned int fd, bool registered)
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static int io_uring_register_send_msg_ring(void __user *arg, unsigned int nr_args)
+{
+	struct io_uring_sqe sqe;
+
+	if (!arg || nr_args != 1)
+		return -EINVAL;
+	if (copy_from_user(&sqe, arg, sizeof(sqe)))
+		return -EFAULT;
+	/* no flags supported */
+	if (sqe.flags)
+		return -EINVAL;
+	if (sqe.opcode != IORING_OP_MSG_RING)
+		return -EINVAL;
+
+	return io_uring_sync_msg_ring(&sqe);
+}
+
 /*
  * "blind" registration opcodes are ones where there's no ring given, and
  * hence the source fd must be -1.
@@ -885,21 +902,9 @@ static int io_uring_register_blind(unsigned int opcode, void __user *arg,
 				   unsigned int nr_args)
 {
 	switch (opcode) {
-	case IORING_REGISTER_SEND_MSG_RING: {
-		struct io_uring_sqe sqe;
-
-		if (!arg || nr_args != 1)
-			return -EINVAL;
-		if (copy_from_user(&sqe, arg, sizeof(sqe)))
-			return -EFAULT;
-		/* no flags supported */
-		if (sqe.flags)
-			return -EINVAL;
-		if (sqe.opcode == IORING_OP_MSG_RING)
-			return io_uring_sync_msg_ring(&sqe);
-		}
+	case IORING_REGISTER_SEND_MSG_RING:
+		return io_uring_register_send_msg_ring(arg, nr_args);
 	}
-
 	return -EINVAL;
 }
 
-- 
2.49.0



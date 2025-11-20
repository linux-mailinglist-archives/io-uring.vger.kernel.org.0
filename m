Return-Path: <io-uring+bounces-10702-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 738B0C760B4
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 20:17:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 511864E1965
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 19:16:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2862727ED;
	Thu, 20 Nov 2025 19:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I/ljjyma"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F5D222599
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 19:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763666179; cv=none; b=m9LlWI/+pSEU9xLJi5m6OothUwyMwnQ7EWHJWRFkf1XcGjij4lI38l6sut71+32En3xn/KWC0qfQBjbDpHgPjlokU7I+UG4ZlSwT6CtXtkhHgBoNulAl9oclAbY8J0NlKOOgkS35+KoKB8NNG/lYw8QFQjNCJFyecm1pl7AZ06I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763666179; c=relaxed/simple;
	bh=FMjRp54IYYY1/g1SDKt9zZnvoeo+h3hi/YlQBadJGF8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ElSBLD+gqSfT58CCkCWDzHPqSIOcnepzA6fovVp00p+zyU7fZ1UQqT2pu+VHU6oosHpgF3qH/VEBJB4fPE31SiqSNKGY8wviEYiB19SAdf072oAuB6vdF0ZEN5vd6i247rQ/1l6o1EPdO3bORsZdn1127ztB7Q0J3pPrsqzLcSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I/ljjyma; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-29516a36affso17865195ad.3
        for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 11:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763666177; x=1764270977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u6P5LuBU7anT6r5OpSDVx6TGf5NxPJwj7Ai7DvYmWY8=;
        b=I/ljjymar447atjXnZszdfgOjGob3IWgLH9nsOK90AbCMoceIj0xnxHFUGocaPb/SZ
         cw/AXkyNxaQzvcE3x7kjIF/7QeCH/cfBXiKbYoWw5lS/s1+owm4aDXke4B3Nhwf9AJCW
         hgmk5T4g2AdzGtwlS/YHtTY8luV9RcCS23ivL9oMI5prSuKREWnmprhHUMOWxktnkbuX
         b9s94939Ck3xXx9bQz0ezKWusF3ncWFZKOmC0A+gkAl7gEsmokdtuVKuhzM5wPO81vpJ
         EE9/Jksc41dfzVnkbZ/IKaFV13vP/xwqK/j3yr/mpmwCMscF2U8I+I5AlV8iXKFjbfxo
         /8dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763666177; x=1764270977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u6P5LuBU7anT6r5OpSDVx6TGf5NxPJwj7Ai7DvYmWY8=;
        b=CGGreG+zHV6x7CTrFMbS4A67qIoSKzPgBt6KNr10/AUhDbPpx4CA6IRH2Si1FiC+Rk
         2T4BaJSjhTzuL9K+Zxb7fVAeiJbN59MXofiyYNCIDNQaFlykefEru8EATrnuXYFznxgn
         SrZvW8y1ZX4ip/tZ6Y4fhUPILdFZ4pFK/MiJCNHHj9owiktwmK1As85hcBczCTYhcTsW
         J+8D5QyuE4MgHQ9DHTP4aXUIqs88qbcmFlshqX5KKiD+y7JWE0P4B7GnmRkYZU9UMfIL
         vAVwDrLDYMeNkoUeYQOoYGmEMImQH9oJTsVK6tL+SUMZ8hY3RHEoW66laXMgaeHjULDb
         f6dw==
X-Forwarded-Encrypted: i=1; AJvYcCUCuy2H/o/ysjT3mSHVH7vJktFtgIhY4QLt2h6Iqa+ZiZydVHymhs4g5d0DPYhY4QaJGVsMuj22HA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7g4mxtQNvWDs6GgFELo0MDFREQoh1gDZADbHBP/ak0wGSvc9n
	nGTaZi90qAlF+raVK3yGpyMHyHDjA331EhGFFcbtTd3thFl4YVzBj3Wj2QdZgw==
X-Gm-Gg: ASbGncuh22lYE6fuLT+H10fdTUlID9PelF0HOhVFWXj2ifjCwR7Mkg587fnrgYiErA9
	6/OL2/6TFT9F0cX5qhDaOzOeTd/iBJOAem9drmiVlj4vzX+P1TTvlE+QxaZzLXAqrEXLCQDz71i
	5AoAN/MVhIavNgKCXeF8BFeQgA/6c94/tLaPXTPRqhq3C+LEPQiuoKNWo4q7i/+bvcOWsKBk5BU
	ObjznI7dC0gTJ3BJW2d6qJUF3xUF5jpo9hR3wSywsKZL6IKLqeYIl3o/ucx3o/SRKGUKmIJh3u9
	l44nxQQJH4L2cV6H9/RtWXaaPvZoMDnSxfAYFvH+KC03mS0XUzZSWt1bkiZzQ4WQPO17gimriaF
	fxXShlg9wN1zxvMkCjaGbECKB7kjXCsd3t7uYwVFuP8Mi/EVO2is8DwyVFlOPepPx1hHtFAz9pX
	oSw2qLE7ix6nUa4tti0Q==
X-Google-Smtp-Source: AGHT+IH6Gzor3jYhKc6vRLuCfcl/JqrhS9PVf4L5alcfOz9mHLN+XwnLoyfIYRXv06N3N189STKYEQ==
X-Received: by 2002:a17:903:1aaf:b0:297:df4e:fdd5 with SMTP id d9443c01a7336-29b5b08890dmr49413735ad.23.1763666177362;
        Thu, 20 Nov 2025 11:16:17 -0800 (PST)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b29b799sm33369615ad.83.2025.11.20.11.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 11:16:17 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v1] io_uring/kbuf: remove obsolete buf_nr_pages and update comments
Date: Thu, 20 Nov 2025 11:15:56 -0800
Message-ID: <20251120191556.3100976-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The buf_nr_pages field in io_buffer_list was previously used to
determine whether the buffer list uses ring-provided buffers or classic
provided buffers. This is now determined by checking the IOBL_BUF_RING
flag.

Remove the buf_nr_pages field and update related comments.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring_types.h | 4 ++--
 io_uring/kbuf.h                | 5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c2ea6280901d..e3aa54239a21 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -328,8 +328,8 @@ struct io_ring_ctx {
 
 		/*
 		 * Modifications are protected by ->uring_lock and ->mmap_lock.
-		 * The flags, buf_pages and buf_nr_pages fields should be stable
-		 * once published.
+		 * The buffer list's io mapped region should be stable once
+		 * published.
 		 */
 		struct xarray		io_bl_xa;
 
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index ada382ff38d7..bf15e26520d3 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -14,8 +14,8 @@ enum {
 
 struct io_buffer_list {
 	/*
-	 * If ->buf_nr_pages is set, then buf_pages/buf_ring are used. If not,
-	 * then these are classic provided buffers and ->buf_list is used.
+	 * If the IOBL_BUF_RING flag is set, then buf_ring is used. If not, then
+	 * these are classic provided buffers and ->buf_list is used.
 	 */
 	union {
 		struct list_head buf_list;
@@ -27,7 +27,6 @@ struct io_buffer_list {
 	__u16 bgid;
 
 	/* below is for ring provided buffers */
-	__u16 buf_nr_pages;
 	__u16 nr_entries;
 	__u16 head;
 	__u16 mask;
-- 
2.47.3



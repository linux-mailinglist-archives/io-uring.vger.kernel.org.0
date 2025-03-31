Return-Path: <io-uring+bounces-7306-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18D30A760A1
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 09:54:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FD2E1884924
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 07:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 548AC1E492;
	Mon, 31 Mar 2025 07:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jI1enAUD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDFB1C5D4E
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 07:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743407671; cv=none; b=MH3dfiyvRaNZbwovOBSyizHUETUtaiBsLLTS4IjXOMKHsHuVNLZJNDxH3tvCwKCLhVnP8xVFOWsorBoJSHXJp6TnM06B5kCWJnNnuVMZOmaTV7PSFVb9thSL/2G9zbBaBVBaqLnm9+tZNNdN1wL88SS1rxmSFG68iUBw4SXmnKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743407671; c=relaxed/simple;
	bh=c0MThJ8I4Y/XaQ9k0cK5GwVQNcH7vhHQkPg2ZDyFh7s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tWdT3Q8Ikdz/tm+eEDEBILuJ1QfLj7Fdt899/dL8z3K6xQ++/om77TOeZW6pzX9KeLD0QWiN3azKW6gx+lYvg7XLWT0W8xyGLjiOCkueZhDOfAhHguufqeKJq7GInFcDKMFyqhxcA64J01biNuucO3AA1MPpV0/rUF/ivKW/5fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jI1enAUD; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e5e34f4e89so7767435a12.1
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 00:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743407667; x=1744012467; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Aq5tIWO0SMpa2qpN+s2oYdTRkFhEkHXek5UxXuZRStk=;
        b=jI1enAUDPUWx+8oHUJzP2Ns1tQ4s0Jlm9acax0XND7tVfY3k2yeQbk3pHvxmuCm5MP
         zwuI1p5a/4tKkRmx2XFI8a6tj+Th40evLt+iXFtQDBuwNFwNzfRe/PK2EaI/NhwpkL9y
         5IHMFGWYqh+4uMSt6hvF33vNzE682+kOynebNIIuNonKCn0zuZAQ0oDWxXnA+juJ78gs
         7DnT/jUXnRt8O9Jflykcbrys1BK5fiE+jaJpi8SIerM8/lvUV8E7mOxhBJa3N8TB4eJh
         qciH1CPr4r2jmBXrOVjQag+Rwpne0ti3F+MdO+FLS0sul1xcA+D7mVzPQMBvFarIjXgH
         Xhbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743407667; x=1744012467;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Aq5tIWO0SMpa2qpN+s2oYdTRkFhEkHXek5UxXuZRStk=;
        b=FL4fLz12ZVZCn0lYzamHcrUuZmTnTQeZEr2Xrpg/43Sgjts1A9oP0PI0OH9TnP5uc4
         PijAfslay+uV3lkhq4zFBfLyLBV6WPW0QQLzcnHcr5menCVob2nHjzPFz0TJezwm3CdN
         c6rz8dozVv4EJymAuuwKJ5DOngSYrCvcC1Ls2v/9mMN2MsX48xIWlhK9n8RweQ6dD3Ti
         CM0VjebgZ0DfR3FPPO/BC6+8m7tIc2uqRnRILU2tV1DJqKxy4D8QkgozlByQsdONz1Bw
         EPj+b9YwK5/wSSxr5h6t7ofm1BerpYXw6CqNB7T+GoOKSPklUCN1RTCH+AfiGjdZ/Z13
         j/oQ==
X-Gm-Message-State: AOJu0YxdBpUU3334R4wdGp4IFOyqv2jDM9CfRNgBefFslz5Q+VieIXUc
	UpSV+ufClMkhT/J+IMSX5IP6zgZb+Q5GoLorsffOhmpi21/IecVqJWTGFQ==
X-Gm-Gg: ASbGnctprWuHa0+dye0GgUFq0D7WJ97Rz2hSknRNSxDtfuDfXe0JjGKwaYDD4flg8cs
	MU0rSparo5r3LpkBGVUwQ4UW88KinkL0PmowqpRjvAYlqkmUsgtXuYo/CZel2JmAEJpYm+Evghj
	IznFn3gQzgHBGy5Xi8XNzWN6V9QxrNKxiKqM0h611v5D7rnqeUPkijppEAEFUDDv31fmlhQ6GaS
	s8nwdDYbYHL2Mx0wKmZggySMQeaIVZK8s077PS/wBp/AHpRn4NyUMQXM3G/ygsbGetii56lkPe0
	7PkrZO9i1q94zLbPmYUfxEINTF4=
X-Google-Smtp-Source: AGHT+IEjLHr2Q2R32eeuJgC5BXGTFuAqlHpzdHcp1pwDomyB027S0wrM62LAG/xogE5s6U9nMFMY+Q==
X-Received: by 2002:a05:6402:2794:b0:5eb:4e69:2578 with SMTP id 4fb4d7f45d1cf-5edfcd526d2mr7477995a12.13.1743407667347;
        Mon, 31 Mar 2025 00:54:27 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:345])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edc17b2eacsm5266739a12.59.2025.03.31.00.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 00:54:26 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: cleanup {g,s]etsockopt sqe reading
Date: Mon, 31 Mar 2025 08:55:11 +0100
Message-ID: <8dbac0f9acda2d3842534eeb7ce10d9276b021ae.1743357108.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a local variable for the sqe pointer to avoid repetition.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/uring_cmd.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 89cee2af0ec1..a9ea7d29cdd9 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -307,17 +307,18 @@ static inline int io_uring_cmd_getsockopt(struct socket *sock,
 					  struct io_uring_cmd *cmd,
 					  unsigned int issue_flags)
 {
+	const struct io_uring_sqe *sqe = cmd->sqe;
 	bool compat = !!(issue_flags & IO_URING_F_COMPAT);
 	int optlen, optname, level, err;
 	void __user *optval;
 
-	level = READ_ONCE(cmd->sqe->level);
+	level = READ_ONCE(sqe->level);
 	if (level != SOL_SOCKET)
 		return -EOPNOTSUPP;
 
-	optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
-	optname = READ_ONCE(cmd->sqe->optname);
-	optlen = READ_ONCE(cmd->sqe->optlen);
+	optval = u64_to_user_ptr(READ_ONCE(sqe->optval));
+	optname = READ_ONCE(sqe->optname);
+	optlen = READ_ONCE(sqe->optlen);
 
 	err = do_sock_getsockopt(sock, compat, level, optname,
 				 USER_SOCKPTR(optval),
@@ -333,15 +334,16 @@ static inline int io_uring_cmd_setsockopt(struct socket *sock,
 					  struct io_uring_cmd *cmd,
 					  unsigned int issue_flags)
 {
+	const struct io_uring_sqe *sqe = cmd->sqe;
 	bool compat = !!(issue_flags & IO_URING_F_COMPAT);
 	int optname, optlen, level;
 	void __user *optval;
 	sockptr_t optval_s;
 
-	optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
-	optname = READ_ONCE(cmd->sqe->optname);
-	optlen = READ_ONCE(cmd->sqe->optlen);
-	level = READ_ONCE(cmd->sqe->level);
+	optval = u64_to_user_ptr(READ_ONCE(sqe->optval));
+	optname = READ_ONCE(sqe->optname);
+	optlen = READ_ONCE(sqe->optlen);
+	level = READ_ONCE(sqe->level);
 	optval_s = USER_SOCKPTR(optval);
 
 	return do_sock_setsockopt(sock, compat, level, optname, optval_s,
-- 
2.48.1



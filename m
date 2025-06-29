Return-Path: <io-uring+bounces-8518-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73474AED1D9
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 01:41:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 908851892F1D
	for <lists+io-uring@lfdr.de>; Sun, 29 Jun 2025 23:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B757F23ABB4;
	Sun, 29 Jun 2025 23:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UdhEa5CB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21006239E7F
	for <io-uring@vger.kernel.org>; Sun, 29 Jun 2025 23:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751240487; cv=none; b=kKE9zNvGs7qTe/GvMfyunryWCX0KwDjHdqVHt+CRPU/EQFU4c1idFgUcSh4kRAoQQ7iDBzpBRaa9gl6NmwmlTjfwLTlkDsHfFyIZAx2nREPz4zYRtzPE6W5+I2SAfLDderW4N+9rhsvRp6hZ4gtfy49Dn+L0u8lThrj7AP3R4ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751240487; c=relaxed/simple;
	bh=Bkl1NZb/1QqEb39NvdL2LjUFkxNbBLZAssvwrcRDiHo=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=XPlUVVbidiUKqbkvKv1c8zRmg81tmy2g4hMDnc88Kv7HwjmL+iv+rLrgr697PjPX4RXjYTA2JvKrkvVexSmKNSAIkVu3aqzu2Ye3/H39Pu8wJWqCfxuEC+El2UBGyv8iVTNc0T9/wTyUoosrMFOXqmU1U288ZyxyLBItbVhu/aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UdhEa5CB; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-86cf3a3d4ccso414621839f.3
        for <io-uring@vger.kernel.org>; Sun, 29 Jun 2025 16:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751240482; x=1751845282; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I3N91QXSLVt3PdaXjEE9UvLxRRpMl8K92fu1kAg5BF0=;
        b=UdhEa5CBLo3RSJ+bbbpsxy/SdjRsxjoM1N8RsO17nSz19GiPHf9B1dUynuc9RJyY7F
         up4SzE/mxI9WCc/YFnABreyGqgjW+nzyGw2zlO+zUd5ZdCC2R+tqURabxeLabsSZ8xAt
         bOlKoFL8xX3rjo0VOsTN6UdNaPRS5atmN8ODBcswMP/fY5fE/+Z6DCK+5Cug3wxEm0bu
         Ofi0A3GFnpR31ggsDkkwxtuvaRY6qUssrGLtptLJdeRhvFhcoZB34LOC9R+JzlL2zRYH
         Wrb8YLB9VFvzAv3v9LZRe2cyOADZEvqyf0Tp1lrIY5OASlrCRa+Jluzyy69pxrCn3IsW
         IBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751240482; x=1751845282;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=I3N91QXSLVt3PdaXjEE9UvLxRRpMl8K92fu1kAg5BF0=;
        b=seOGqu/+2VI8WC6X6HhxFcUA88DrXuRIIAEXp9bRjWkljws1cdQloo+XAZjpkq4tvH
         fhOoXCb+6PMk0kPtvFovVrbqSSbSDlrpKrLQvOxk/2y/x0sxI3PUmCVgBN1qd58WJkyh
         NK4wfBrT97XoA8NrGiOT3pRqDdcYpypTGL8yZ12n313dyMGkl7kXyGdq7sHCApQRQYQQ
         xNA+d8S6FduT7lQluluDejLkwxacjDzqzO2HJ5blK+3TRLpKCWUKHepAYCp//FN8mb8U
         7rraqohkl0pne9LqVZ87vpVIk1QeiG1dr7nd1w25GwyaDeYyxjgWZrrg+mgDK79jjDva
         bJqw==
X-Gm-Message-State: AOJu0YxgZAH4H0QwnYQMrjxL9vGRNarmmxDlTu2Z10rgBlREp8QlbkXK
	b9Gjqoy/y0OjtJTt27HSIKf/d1K8+PhaZ9bRjT+OtRYGxbXkY1hxu5zr0pQ1yaPYn5MEjb8h8+r
	ocZ5A
X-Gm-Gg: ASbGncsWPtOg0h0ijtdw6CyzPbpRSzBnLlIyXU7gVLXhuu59ujAEqBklvIJ+i1c1nSr
	n7ODFN3XJOuAj5jpiDnvvspf5tz+4ueKdwDIRCA684OCYopNw32bMMvf0M5l0ZOMrN2ET8Dl5d1
	so/Hc0cAJQHt6k9hr4hZ34kVGZb6ttqV4jMtG11ehsR1FhJ/plVna13D+9MWEVbRLKiG7hxGVAZ
	S6djZXBkSpgiieNJejLOxVjTVY9CvBRW/3P7YKzUs1RW6tnAfdvcvIs/bRWeNqTXFncegWJlrzd
	bZJqHqebZqAu7jjA9l3w8UYF+ajzpb5rFdY6DzQNtvRtn3G6v/VwLnW5pzVW1mUhvYY7Mg==
X-Google-Smtp-Source: AGHT+IH+ScTugxPjLqgNrnAdkc/Qt6cwKnevfSyTmwftC5itm2gAxKVu5ykj7N/AXgLFTHotxvEktQ==
X-Received: by 2002:a05:6602:370d:b0:86c:fae7:135d with SMTP id ca18e2360f4ac-876882a0c6bmr1452739239f.4.1751240482397;
        Sun, 29 Jun 2025 16:41:22 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50204a5b2e0sm1682424173.86.2025.06.29.16.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jun 2025 16:41:21 -0700 (PDT)
Message-ID: <07d11f3d-0e2e-451b-a477-2489399b73e7@kernel.dk>
Date: Sun, 29 Jun 2025 17:41:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: gate REQ_F_ISREG on !S_ANON_INODE as well
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

io_uring marks a request as dealing with a regular file on S_ISREG. This
drives things like retries on short reads or writes, which is generally
not expected on a regular file (or bdev). Applications tend to not
expect that, so io_uring tries hard to ensure it doesn't deliver short
IO on regular files.

However, a recent commit added S_IFREG to anonymous inodes. When
io_uring is used to read from various things that are backed by anon
inodes, like eventfd, timerfd, etc, then it'll now all of a sudden wait
for more data when rather than deliver what was read or written in a
single operation. This breaks applications that issue reads on anon
inodes, if they ask for more data than a single read delivers.

Add a check for !S_ANON_INODE as well before setting REQ_F_ISREG to
prevent that.

Cc: Christian Brauner <brauner@kernel.org>
Cc: stable@vger.kernel.org
Link: https://github.com/ghostty-org/ghostty/discussions/7720
Fixes: cfd86ef7e8e7 ("anon_inode: use a proper mode internally")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5111ec040c53..73648d26a622 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1666,11 +1666,12 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 
 io_req_flags_t io_file_get_flags(struct file *file)
 {
+	struct inode *inode = file_inode(file);
 	io_req_flags_t res = 0;
 
 	BUILD_BUG_ON(REQ_F_ISREG_BIT != REQ_F_SUPPORT_NOWAIT_BIT + 1);
 
-	if (S_ISREG(file_inode(file)->i_mode))
+	if (S_ISREG(inode->i_mode) && !(inode->i_flags & S_ANON_INODE))
 		res |= REQ_F_ISREG;
 	if ((file->f_flags & O_NONBLOCK) || (file->f_mode & FMODE_NOWAIT))
 		res |= REQ_F_SUPPORT_NOWAIT;

-- 
Jens Axboe



Return-Path: <io-uring+bounces-9115-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BA1CFB2E4E4
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 20:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 473EB1CC2317
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 18:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8C23EA8D;
	Wed, 20 Aug 2025 18:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qUEoX5Uf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751942765E1
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 18:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755714370; cv=none; b=oXaFTg3Or3hd+LZuO8bz0nkfytQfPCUuOz66W2v1pYQR1LH49XIPmjaVGF/3EA6n0MCC0uaMXgny1ZwuWpknEbPxdiozCWqJOvwUfxIIOjO22U2Z888vUqORnEXQTNzTXjM1tdEAVfaRhke54A/GRe4wWYwW8ohKiZgyPjXxSn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755714370; c=relaxed/simple;
	bh=xjIPjFw/woSNeovdMr8PjXz2FIAQSU8xVcZiqV/yAok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqpcYjf2cA49cqhPe1jGA7WihUcqfdNnDyDKv3QEiFM5yFk2gawS0KNSk/ph2bYqjnnxqesZuFZ5F/n/QdhOB3Id+0TzI/NIMvVIU4nK7U1P0VAXTmjssuAPxr5q6gCLGkAQqZMPGAcXZmIoAQamhyyT4Umleh50kBHdw2Fi6ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qUEoX5Uf; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3e566327065so5337595ab.0
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755714367; x=1756319167; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x0qYWkuWNZuPPqQ7W6O29gbTssE9t24Aq69ccLmNZ3Y=;
        b=qUEoX5Ufv21WglVg6vbjjlDDRAvoktrjetyx1y+ujdyhWUFy6dHba2RQsUfA1G2NZq
         etTQxa2a+1/Pm3SYiIc88RrCYs4OvixcunswCR0RvrfzVfYXretZ/5k2nuXx5Ki1i3vj
         tU7F7+yZnpoM0iVK93W7uTZwu8qCDJZ6lAxyZduT66fo1X2JRol8wIKV0DAG6dbu8MR8
         vATQig8NzXT5hv3ZZWBYlnOX1bA3nqPhyfgNUYfRmkfroyZ2OHNxmetYmJXMt5qs2ekr
         nr89Miu1RPiN3lvYJusU1vBPlvWlYdmgwyrxZOzvCwuM2zGJNWV1vmI7jPa95kZ5PyKh
         vL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755714367; x=1756319167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x0qYWkuWNZuPPqQ7W6O29gbTssE9t24Aq69ccLmNZ3Y=;
        b=tycS5CZuYrfZeNMaqzAiAfyHkJtUsDu3dHTkJ+7dMZnXPOeQ3qGK9Y5KHH0lY5D5KW
         N/te91is8tLdT6uDA04EQWByDJJBg0BuI7Hn3SY8TUjasuhvPjTcdXrUsIJ+/M8f4cT7
         4RFthO7VbYsEe2kHK9G0VDfLGBBKks3hb16SCaANgL4DHVbwSImDnpdBKOllZ9QWOVjm
         T2l6Vz7nERoQeJoQnp7hgMpihAsFFaMJyqDYDl65oZJmXpo48arwpv6pxGceQM0kONPL
         G1mBFFt/CWUuPWfUss2S58vl+b4F+9DmRVTI3jmE2/5VUujbHSbPlP7qGXqxvV+uOvpC
         BXNw==
X-Gm-Message-State: AOJu0YzV4WoLDdSceWqODOu4+5GEqIVF/znmCMVbjndGx7De+3tmCt40
	ahoVmZrQoqX4pD5a48HaHlEslth6mPKX/q1fl4uHWppM1gG1SjIBal+efjZKFELAQuGr4nFCCjl
	RAF2D
X-Gm-Gg: ASbGncv4yC9J/PyyLSEe9bvXWOpkujCdV1T8VKjb/AEr4olfUcTDzVSwphYe98AB7ry
	rnFQGzeqQSWTG3zChTq+mA9CewoYYbPHG4KWr6aYWuS8qhZgDrE33JczOwrnmnF4NZTm0a37s26
	0lCdF6TBxQ1mMCcEUfhTrcwkKETVmbqH8dgXsjdgGkutgn8gUXFqi7xPApIU3R+aI3M5UN2Rnyh
	4FZ20wkiycwW9/uEBrhdZXyKQgHDeD3QQpsoYdFbT7G5qZq0UG59PF2B2Iy5TLIQUqnuug4RShD
	5QfPpDa4PY9oDe0cLuBOh8wvdR1aEHOEKdCqR4Vjq7kiufyZlvaD76YsqJokwAL8xqr7WoLetZP
	bVakpuw==
X-Google-Smtp-Source: AGHT+IFH+iww6E5gYWAGP6Sk35xo5jlRCKxQz/NlrblYg9wkZNPSjUWBhM5IYHF1aSMgUwRrLu1aWw==
X-Received: by 2002:a92:c709:0:b0:3e5:8113:35e1 with SMTP id e9e14a558f8ab-3e683408f6cmr8774025ab.4.1755714367255;
        Wed, 20 Aug 2025 11:26:07 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c947b3666sm4217951173.24.2025.08.20.11.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:26:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/9] io_uring/net: clarify io_recv_buf_select() return value
Date: Wed, 20 Aug 2025 12:22:48 -0600
Message-ID: <20250820182601.442933-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250820182601.442933-1-axboe@kernel.dk>
References: <20250820182601.442933-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It returns 0 on success, less than zero on error.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 4e075f83b86b..73281f31c856 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1199,7 +1199,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 retry_multishot:
 	if (io_do_buffer_select(req)) {
 		ret = io_recv_buf_select(req, kmsg, &len, issue_flags);
-		if (unlikely(ret)) {
+		if (unlikely(ret < 0)) {
 			kmsg->msg.msg_inq = -1;
 			goto out_free;
 		}
-- 
2.50.1



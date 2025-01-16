Return-Path: <io-uring+bounces-5914-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CC72A13193
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 03:53:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C33FE3A06C1
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 02:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC3F45C18;
	Thu, 16 Jan 2025 02:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HzGhlX48"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D173BB48
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 02:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736995976; cv=none; b=d4lIyCO9mi0fRSClno3QGUv++ECbYKEkBKatbKXaCJ7QjL3b8sEyUPheZG4nASx/3B/TNm7j6ZrsJtgpmkfG8SrJ98Vppc91Gaf6OsezRZd7bNGFn4tisMC4iP8aOdmZj89LnKtIQrMLH42A3VY9Ms7aQ+3Oh0gYtA7YVA8dEOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736995976; c=relaxed/simple;
	bh=sXjFu2u+mOTnILuMQLYgAmOJVQ9CgHpsxccKyXADVnk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U8Y24nYBQva6CyNrHGUU9CaWvCT6QFlNduVFso9TAZPrJwZdA8njQzJ1x1IxseYqeXiKW7Ja8PwLfARPjlTrEgyuhLaeaJX98v44FJuMkglPV9+1uxize77wROriTthsK7e/hZtz1UOq1bSKOgPAaf7dkSXlRuGR4T7K57AFA9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HzGhlX48; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d9837f201aso2857767a12.0
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 18:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736995973; x=1737600773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eLzRA36j2FOA6zebunqfbWe073hNQZK8jDednnE31xc=;
        b=HzGhlX480LdlhhnVTuin7GG8Jhp6jvne4lF84b6475ZCfljOzzyMrTvfz3nm7bFN5p
         IYE9tho4vGnw5oyAp1RnISIu/Cd1jJ7c80V5ruMDyNYjJ2h3UDB7FR9QYfC5FLrccv6w
         oD5Cd4f9PkmmfdH+e4cohTqMJNy6XbYCsJIVKbgLg53o8sBvVeRFoaaf7F8qqqtIH18Q
         LfxitOy6dKvdl8/Z0VbLsInUWSMKEOAkf4mZr1tSPsy1OCGx0afFIOysXM5wMDj/LZQq
         s2lQesPuvGhs5kgET0P6UU7GjY8zj5bAQ9VhdKide8IFF46nvI+QqIdYMS+BnLYD8YT3
         FGkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736995973; x=1737600773;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eLzRA36j2FOA6zebunqfbWe073hNQZK8jDednnE31xc=;
        b=T2WE/nBR1JiHxG39E7sIIXwTcRlWgIjG3CSoNBYnaXg51fgHRH91bFLSUTAAwsIGRP
         8ScxIRdsCY/zlvRCjHZ0osdg81n8Gv/ZgR7xSCeNgroJC3nOW1hO4jCfi3T3UCsqpjrB
         auDny7lY2b8C38bQj4qn66A8OvI9qDbuecrgo//hvlG6mpbPi5J8u5q9u3GjR3sYtzMz
         dyJyrNhD5qsrRLyTM3uUlXaB8hOwmCOBczXm+gofZKJs4LzmXknu+jto8CnCDJlnt/9a
         BNJ9ULONbvtIUFkKTFElaJ2RhUevAwCPwB11lyKm2x6z+TJOD5nDDxKCfhWZ9478cFCn
         7lrw==
X-Gm-Message-State: AOJu0YxRQp/lTzBDx+YcbVpOyQuSpql5F7YwINmgggFv/m1KkNOOEl2j
	1QsAuF41VKCyg9QWqagbz5GQutyWMvud/F5OJ9I3admEvVEFt49VBn3I9yOw
X-Gm-Gg: ASbGncs+yLDNkz56Jhqh9HUKHmeKLQSFLMkBGT0G1v9yikAQ08PXL3VA4PL3rWNFpQk
	76tTDJVQLHDFt6GHoJA4/0w0HJPdlpdOrY9yO52UAUMtkCDi4SzQRzmSjPKNvMWfKTXJ56I63Yu
	zIJSW3HtdJT4zixvDf3VGhmc4l4WcIxe5mcfaqk9ocLNSubtriKFT0QCxm2Ou+k1/hT84/m8tY4
	9Ykm04F9JdWil7ATNe5LGwG1xG3TBhy+7+xGB4C6sF+kufHNcaBVSNcTW1fOVwaMGVLOBw=
X-Google-Smtp-Source: AGHT+IE04aH16PNz4B9Js7Jxpf7JsPMvTmAHsB5zzeNyJDNTxgGICBWMC6RBFofvfot41o6L0Vka7Q==
X-Received: by 2002:a17:907:9905:b0:ab3:3283:faf9 with SMTP id a640c23a62f3a-ab36e433e77mr80000566b.24.1736995972945;
        Wed, 15 Jan 2025 18:52:52 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.147.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c913628csm838279766b.86.2025.01.15.18.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 18:52:52 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: clean up io_uring_register_get_file()
Date: Thu, 16 Jan 2025 02:53:26 +0000
Message-ID: <0d0b13a63e8edd6b5d360fc821dcdb035cb6b7e0.1736995897.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make it always reference the returned file. It's safer, especially with
unregistrations happening under it. And it makes the api cleaner with no
conditional clean ups by the caller.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/register.c | 6 ++++--
 io_uring/rsrc.c     | 4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 5e48413706ac..a93c979c2f38 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -841,6 +841,8 @@ struct file *io_uring_register_get_file(unsigned int fd, bool registered)
 			return ERR_PTR(-EINVAL);
 		fd = array_index_nospec(fd, IO_RINGFD_REG_MAX);
 		file = tctx->registered_rings[fd];
+		if (file)
+			get_file(file);
 	} else {
 		file = fget(fd);
 	}
@@ -907,7 +909,7 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	trace_io_uring_register(ctx, opcode, ctx->file_table.data.nr,
 				ctx->buf_table.nr, ret);
 	mutex_unlock(&ctx->uring_lock);
-	if (!use_registered_ring)
-		fput(file);
+
+	fput(file);
 	return ret;
 }
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 964a47c8d85e..792c22b6f2d4 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1073,7 +1073,7 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 	ret = io_clone_buffers(ctx, file->private_data, &buf);
-	if (!registered_src)
-		fput(file);
+
+	fput(file);
 	return ret;
 }
-- 
2.47.1



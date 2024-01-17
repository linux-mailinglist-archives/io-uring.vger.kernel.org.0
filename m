Return-Path: <io-uring+bounces-415-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 624048308C9
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 15:54:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9548B2138F
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 14:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 019B020DD9;
	Wed, 17 Jan 2024 14:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="p/p4D+03"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941B0208B4
	for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 14:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705503073; cv=none; b=C9JJTkbuUgII7AAfTIaIndWzumHwkVjD/JpYOWJixI0Uf+FB+HHjWn32yfNzTvCHu68YfRlUggSXUUodcMqWdItbCsKEwt/URJz9N96bOTuuWdVbrkBTbMIiFjS8QLveIwBBdu23YQd6lB3K2h6yU6r4yvw/1b6tdL44B9fuZag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705503073; c=relaxed/simple;
	bh=nCvjsYc3vSQUfFnt8UOs+7CpFh6E/9KFL9MUyy90gkY=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Content-Language:To:From:
	 Subject:Content-Type:Content-Transfer-Encoding; b=BZd9gpFgxNdEu6wgp+7mHs0r//Ha0NfG3nXNkTl3IhStv9QDMTGKK0yUx49d/JJc9Uig90+OAwH7mR+pLNpX4BgF8cJ8cTv3FqBKqXQ7Eh9QnKDufoiZ/B2Hzm1zaypp1KqBwkNSbqw1oLNcisQn+5UakvNRitD7eLajUW7Y9lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=p/p4D+03; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-36095e0601bso4329405ab.0
        for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 06:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705503069; x=1706107869; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4dk1nLE1Te3FPomMk4Psh+u6rcT3zp8ToWn4MYVSQ1A=;
        b=p/p4D+03zLLBn1NGo4NcPWFlOkLZHAVmQpKoQcdvg4itxCQ3cvniyZGVMFeL9zT6KD
         IXPeZoOL/LWImDF7zQ9Ahd1uhRr/mOPi9R5ngL/o8fmxlVljtYtjjL1T1LdH+j9sr3ZT
         4We2oMDKOnAEPQnd95KsGQfg9E2PYqNSgwKHHvfC5FQykE/4F7fS1OIl65isX5mKjZHB
         sN6GfhuV3ITvKDb+borS+5l5230ta+gsRxnyy2WJeL/30RJOoLjJ/fl5BkKO/5vYq/iU
         m9GFyq68rtcAgmD/ckquMPT0+0joaoB/1+0hXAXIPrFHpjkuTlEFM73lQVwYaVsbvSaU
         yMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705503069; x=1706107869;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4dk1nLE1Te3FPomMk4Psh+u6rcT3zp8ToWn4MYVSQ1A=;
        b=nsDnv4XL+9G+nZ2h4r+ecUOHVwIxnGEvOt7zDAsMN9MJnHv9R9o9FTnI1fI45KYIIq
         xEB1qYo85IlAqXsCh8EUKmstaxuk/PlVA5rZXPJp/2YOde6UdM1mW3Iv4uzxOl55yRXq
         LsPAM9fxOQije+SNfjWMlnj3YpqvjcxSjn1/D5VCpd0ZQ3ttOxJ7Fd2bAH3iPj52c/uV
         kpT2D67eqk8t1nIff+5ULxrBaqaUhRiWptJ3Ls03Jzv6d1l7X2t81L4cblyDyGKCAlY9
         f+zdoTvBjmHBD5AjN3lJxXQq1l8x97mQqLWe/7zDflh3LxO1q5UemevVN/pmyMsWCPG5
         rQ3g==
X-Gm-Message-State: AOJu0Yx5+SPeUTQLCmNswuVQbDBlT7KqBdLBTyEvGwDCVtZfPGqoId4c
	wjL1fEU0qYkOvVTmTPfU4lhY6kFxwrqUhEb46nKskpqqpfGz5w==
X-Google-Smtp-Source: AGHT+IEhHAIAmQ+sDUF62F8tEN2BiuF9v97OJNHPWzRcsurkY2sQ5JXeRHdlZrBNIjAoPnfA8RG1zg==
X-Received: by 2002:a05:6602:14c7:b0:7be:edbc:629f with SMTP id b7-20020a05660214c700b007beedbc629fmr16688351iow.0.1705503068783;
        Wed, 17 Jan 2024 06:51:08 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x7-20020a056602160700b007bf0e4b4c63sm3533916iow.31.2024.01.17.06.51.08
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 06:51:08 -0800 (PST)
Message-ID: <80eceef8-b2d7-47e8-9ef9-7264249dedbb@kernel.dk>
Date: Wed, 17 Jan 2024 07:51:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/register: guard compat syscall with CONFIG_COMPAT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Add compat.h include to avoid a potential build issue:

io_uring/register.c:281:6: error: call to undeclared function 'in_compat_syscall'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]

if (in_compat_syscall()) {
    ^
1 warning generated.
io_uring/register.c:282:9: error: call to undeclared function 'compat_get_bitmap'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
ret = compat_get_bitmap(cpumask_bits(new_mask),
      ^

Fixes: c43203154d8a ("io_uring/register: move io_uring_register(2) related code to register.c")
Reported-by: Manu Bretelle <chantra@meta.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/register.c b/io_uring/register.c
index 708dd1d89add..5e62c1208996 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/nospec.h>
+#include <linux/compat.h>
 #include <linux/io_uring.h>
 #include <linux/io_uring_types.h>
 
@@ -278,13 +279,14 @@ static __cold int io_register_iowq_aff(struct io_ring_ctx *ctx,
 	if (len > cpumask_size())
 		len = cpumask_size();
 
-	if (in_compat_syscall()) {
+#ifdef CONFIG_COMPAT
+	if (in_compat_syscall())
 		ret = compat_get_bitmap(cpumask_bits(new_mask),
 					(const compat_ulong_t __user *)arg,
 					len * 8 /* CHAR_BIT */);
-	} else {
+	else
+#endif
 		ret = copy_from_user(new_mask, arg, len);
-	}
 
 	if (ret) {
 		free_cpumask_var(new_mask);

-- 
Jens Axboe



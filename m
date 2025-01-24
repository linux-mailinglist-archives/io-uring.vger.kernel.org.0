Return-Path: <io-uring+bounces-6123-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FD22A1BDEE
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 22:35:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8168E160DA3
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 21:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E1471DA103;
	Fri, 24 Jan 2025 21:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BK+YgUHr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F019E1D89F1
	for <io-uring@vger.kernel.org>; Fri, 24 Jan 2025 21:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737754503; cv=none; b=i869//Es/xmB7NdZgpjkUaYMWMbzksdE6K1vEqDUBedptlYqDLgGYTxe0tEi6rK927zLZXkP0X4a/qsQXQ2XU1SPaz9u3oG96Sof9qFH41LLLBDy4NEO0+bk5gG/vXuZzkwoqtaXALWPpKj840dEtFh8C2iEZJafigj37c5cVGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737754503; c=relaxed/simple;
	bh=MUGMZ9ok4XizNoPAKVdzRx0p1LUhenBgy/ALrfPe/4I=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=lbPG95PssAO2NAvgDT/z7wFNu3Zf3PkiHEW9Rcpu7i4AsjgXb47/+ZgMbx3IyC2CkGhKH3+wkPr95H8a02aNN+1iQHnj+EKndm1+utEJn/RVvXb76MOIN/EXV0PkPS4D5qqGkse/O4seLYL6X6lB25ejdblgp+3ZEJhecus3HDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BK+YgUHr; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-844d555491eso70500539f.0
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2025 13:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737754499; x=1738359299; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cq7aDWBR4SD1cQltuCVd9YoNCK/nv+IkYO1fHb3qJ1g=;
        b=BK+YgUHrgD7oaovSqm6Tk6ZSoSEBD1g0ojDdi1At6WMnNLXut6U/XILI13S7NEm9hc
         0i8RTqpZM1jF/+DUC0xGS8/YnO5zYR5XW2D3kbjefg8jDH4hfDo1qrSjxugnNSJORDrB
         BAg7+1kxU4BmVjrl9t3ZrktZUUcQ+MBbPzUcMYvvmp8BDGoldKOK2V+3seAUAXun1ZTQ
         UexLe1ctWV6XaioIaMA3UWLND+qbNAxDdPDVPsYwOuuRK/Q85D31zdw/YVn4V24wVpE5
         jhpgY9OW/YodW/jg6APw9PCknQwa6gNCniQS1roeeUDzi3tvKXTBLiXFLLHgoQHexyZY
         aMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737754499; x=1738359299;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Cq7aDWBR4SD1cQltuCVd9YoNCK/nv+IkYO1fHb3qJ1g=;
        b=TJifa4ki/Hmbbng1KrVtubbBUILg/fAtO/5DU6KfqxTZ6qAlYjpi6yHXs56qidXZPu
         EQCmZA2Z7bXmaO37g9aJCVWnjK5/HRgCDYD4KrzLaM0oYlxP8GlP+wcqqn9B3moiJzXd
         DAGRoErKpIC6D6njDvhq/L1Gcd4QF9HDUX1URoneeyYGI5wZKODG3+KUKh6lAYWGRgkr
         7HoEll+zobii5xVIe0DU1yh0SHu3Ub6lqE+oJx0BBqM2/kqwGC9A5iuxv75qwYfKdLQN
         esj9yWoi3AUlf02WKIwg673MvJhXmD2UmG4+2fv/fAFAjRuMUBiRBEfXz+jVVcmkNzMu
         aRNw==
X-Gm-Message-State: AOJu0YwOyikDkj6/rae40BPzQeLIkmwSGSzuDgbA9m1zAqv6NUZzWwBS
	uPmLxn4AEnShCnNmnUcvdVqwYooBVhhDpGwOhYhnWqx2lARhBny5vHO/FFo0Xs5qMXRvIP7GdJN
	m
X-Gm-Gg: ASbGncvqnYOBdo0p2VSFUNmIAjIlsnLrND0MMZa9NFpJIfbER7UsyIH219vasRQgw4j
	/IGi1xUvamQCn4fobCa3WpyRfDE0npyS129lXoQe1GENr2wSp7qiIIjY7IGlsFUIguIjPblHxDC
	8OeCAcbOF/4z711ivGKGarfXoHgk3HIFRVw+t32hFS04+CYtCbik81SjrF2XaczEwgBlJZDLFyF
	a6WgmcdMxNFCDYu6GsA1X9Eg76SrVTDyRYjtyn+xH/H2M601nBUgiR8BZs7RDtzI/+o7jU/7dDD
	DA==
X-Google-Smtp-Source: AGHT+IHcm6NR4xGJ9KhduBQS33E1JTivw6IqYTAStXryWMIrEKyT+hjxBb7ONhW2qRyn2yoSC9N9Zg==
X-Received: by 2002:a05:6602:6cce:b0:84a:5201:41ff with SMTP id ca18e2360f4ac-851b61658e7mr2701076039f.3.1737754499592;
        Fri, 24 Jan 2025 13:34:59 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8521ddeb782sm92271139f.7.2025.01.24.13.34.58
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 13:34:58 -0800 (PST)
Message-ID: <58689f80-097c-4644-a748-2e848629b379@kernel.dk>
Date: Fri, 24 Jan 2025 14:34:58 -0700
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
Subject: [PATCH] io_uring/register: use atomic_read/write for sq_flags
 migration
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit changed all of the migration from the old to the new
ring for resizing to use READ/WRITE_ONCE. However, ->sq_flags is an
atomic_t, and while most archs won't complain on this, some will indeed
flag this:

io_uring/register.c:554:9: sparse: sparse: cast to non-scalar
io_uring/register.c:554:9: sparse: sparse: cast from non-scalar

Just use atomic_set/atomic_read for handling this case.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501242000.A2sKqaCL-lkp@intel.com/
Fixes: 2c5aae129f42 ("io_uring/register: document io_register_resize_rings() shared mem usage")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/register.c b/io_uring/register.c
index 0db181437ae3..9a4d2fbce4ae 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -552,7 +552,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	ctx->cqe_cached = ctx->cqe_sentinel = NULL;
 
 	WRITE_ONCE(n.rings->sq_dropped, READ_ONCE(o.rings->sq_dropped));
-	WRITE_ONCE(n.rings->sq_flags, READ_ONCE(o.rings->sq_flags));
+	atomic_set(&n.rings->sq_flags, atomic_read(&o.rings->sq_flags));
 	WRITE_ONCE(n.rings->cq_flags, READ_ONCE(o.rings->cq_flags));
 	WRITE_ONCE(n.rings->cq_overflow, READ_ONCE(o.rings->cq_overflow));
 
-- 
Jens Axboe



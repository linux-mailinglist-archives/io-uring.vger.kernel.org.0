Return-Path: <io-uring+bounces-8905-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3693AB1E88B
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 14:43:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAE153BE3F8
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 12:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CECD1E520E;
	Fri,  8 Aug 2025 12:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XNRlQfK+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F0E1CAB3
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 12:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754656975; cv=none; b=IAr9CHL9y7eoirLjCvXv93AKU6Q5PnGQAhH2Fp0b4cyISji+tANOOWXWzYFLCId/xi9Q4j8A9MehSLtlnzjfreU1h1FQSb6YUgH+MeNdIUJujxhqaBRRbwzPkmAG+lUDr/LPh6o7dY4YChXRcj3p6ypwhh5oun1f7tpVA8JFgmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754656975; c=relaxed/simple;
	bh=MdJUqrdQTbm/2nyhR0mNN9oMOd7QEWDFd1tIzKM0JpA=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=nEZQ8zMaFFx/HblbKFezeWMNL3UnXvutvHkKpNavrInZgFmK4QK2UyPENTdRhCtJY8adxLGMHNWnuGVCuOC36zvA23uRJhKS6uZTvC0X4c0uMY62Me/uWujNHfXnRYGU1CvO1pUBajJG7kBTfICJByUTP90pKNMXzt10QKCl3sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XNRlQfK+; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76bc5e68e26so2084162b3a.0
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 05:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754656972; x=1755261772; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lULxvejuzPY32QBBIn/8msrfme4DYL8EXqvh+X6lOZo=;
        b=XNRlQfK+u2JlmfBo0XShLjAl3xux0C4d07V+GQsWEHni2SA9u5xcjdgfCZ1jr68twY
         NbJeBj41D9FJ36BQ0rIf3b8F1f7BNWU7O3JP4qDO/KSqpvgXG08K3lFu5hQNU2avEXjD
         sJrAK9chSpNB7GWuv6wMY0QqxLciziAh0XLUu/0vggdQGmaqiBWBl3RCGyydM4BQOukb
         v4VqCtUXLgwzj5j7uVicOIHwtr/hHSbXVKrI2x70+xP9rQOuenNVS7Zle5/moMP4Odxz
         qzUQ3ue5tDbfxm16UJn6ni/cJMqCW5XFJboKyBW/qzc58ZfaFdUe86cASp0Z6BTSSLCY
         Vj/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754656972; x=1755261772;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lULxvejuzPY32QBBIn/8msrfme4DYL8EXqvh+X6lOZo=;
        b=Vo+Oqi9bXaOYg1lu4n/8MFkod2TGHUjrXs6MOh3WEr9LhV2L95FNCYX5SzTbXMdt5X
         UZqKLn1Uar4WSakvaH6uyQGI78KjfOzwxb3+dBChB0CjTDqTglGKjfp5J62S2KElmO0N
         WU5TI9bNdFIhwJXiN6GVZhU4EwlauLvg6JASMbjZiS2SbOR0RzlT2frRQgUFPQNPdax0
         j0OIC0ff3ek/roKVJha5Gv0qwmoRhLWOoLE2+C/wO2nFcKChA+ghrR8iadOW69HwWh8k
         rh1Pjhicsbs0iSWqwtK1/xamsXR1pFVGdPJ0ukOLkRYKnI8I3S39fd8SXVLVkHSgEvt6
         zj+Q==
X-Gm-Message-State: AOJu0Yxqsrgr9/cVyLusHyKGd/i7+xoJ7PlMuDwp1mHVwjyJAyxD22PI
	mR5gVwFj8NHgn9vEgGRIhyC56+C3Pw8OFUUdjyF7SWYqeifMvFw3pJF7LL/VBCetl1o0WUwq517
	cvOR+
X-Gm-Gg: ASbGncty+iqpe54pk2G3UfCtHtdeF0cgqbHi0O/NnQIzSuzZdiMj1klOBcZG3Jon8/V
	XdGQLbJhWoWlofgbIZrx0FEIuA/93zuTEIsrODDvZL3yXaDnkrHbKuRuGe2nWBfcKoDrz74wsGc
	tA6KwrNyNXJBu561sG6sf1fRVWE/xkctRPya5462/0hL1ltbbTXlM7a3qjmCTZL67/u4CANHtw+
	5EubCGRzZF1Zh+ZvfH/D3Mvs3u0hGLHzE1qPUb1bkYayCMvw4RzbkBLTCM1xbfCRFGJIqyamgGa
	0JWOVdZxLpPKOd/vD1/zGOpb3bwWD4YqzuDmXGRpG3+Uz0FMKtCLRT4JQMfkLFnLhLXKzfH3z03
	AS3H+5zQ76iJ+V28roTtB
X-Google-Smtp-Source: AGHT+IHGs319JGiGyjvmnQu715JUlUMK1p6WvgXLoL95HTj2kqlzONxjbKx4aD4sXT4vgtSumn7i5g==
X-Received: by 2002:a17:902:d486:b0:240:a21c:89a6 with SMTP id d9443c01a7336-242c2003830mr46146715ad.12.1754656972129;
        Fri, 08 Aug 2025 05:42:52 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef59b2sm210801355ad.7.2025.08.08.05.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 05:42:51 -0700 (PDT)
Message-ID: <5c418b7e-11bd-4b22-8ea7-77022709829d@kernel.dk>
Date: Fri, 8 Aug 2025 06:42:50 -0600
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
Subject: [PATCH] io_uring/memmap: cast nr_pages to size_t before shifting
Cc: Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If the allocated size exceeds UINT_MAX, then it's necessary to cast
the mr->nr_pages value to size_t to prevent it from overflowing. In
practice this isn't much of a concern as the required memory size will
have been validated upfront, and accounted to the user. And > 4GB sizes
will be necessary to make the lack of a cast a problem, which greatly
exceeds normal user locked_vm settings that are generally in the kb to
mb range. However, if root is used, then accounting isn't done, and
then it's possible to hit this issue.

Link: https://lore.kernel.org/all/6895b298.050a0220.7f033.0059.GAE@google.com/
Cc: stable@vger.kernel.org
Reported-by: syzbot+23727438116feb13df15@syzkaller.appspotmail.com
Fixes: 087f997870a9 ("io_uring/memmap: implement mmap for regions")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 725dc0bec24c..2e99dffddfc5 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -156,7 +156,7 @@ static int io_region_allocate_pages(struct io_ring_ctx *ctx,
 				    unsigned long mmap_offset)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
-	unsigned long size = mr->nr_pages << PAGE_SHIFT;
+	size_t size = (size_t) mr->nr_pages << PAGE_SHIFT;
 	unsigned long nr_allocated;
 	struct page **pages;
 	void *p;

-- 
Jens Axboe



Return-Path: <io-uring+bounces-3831-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BF549A460A
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 20:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A9A61F215ED
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5221F2038BD;
	Fri, 18 Oct 2024 18:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qXwliqaA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723B120010F
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729276833; cv=none; b=K8TrXNHUU50B6wLrYUaYYv/x3F1aDre9RqGz0EgoHVn+Bi/f5Lj2rdbL7y8bOVft4T9lHIKERMPk5dYvYc/WpDBqEyVUTtdvFyLAM0cYwnKdNlIYqeAHQqe5MOcHCJCmyhpOP5kNfibO7IjVT8OugLUCi1Hl40rlDqYWD9QYBsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729276833; c=relaxed/simple;
	bh=iH6nMZQFQy1XQnNdOZfvl4phGBYFOyOQxCwmkfIz1Bk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=pzOp3SCcieEvZREV8KR6lHPaI30CDDx17dc27sntlRNAOyu2Y8y5G3PPC5Hcj4AvkQKKHVGt0BuMUBPiZBwSaykBhxCRs0WdCZE6NgDgfMegH6y+LxzYbNOLe974Y/DsL6K9IBASHdRuJYBtTT22BqbrTFRYUsG6eACvJFv7PGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qXwliqaA; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-83ab6cbd8b1so72568139f.1
        for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 11:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729276830; x=1729881630; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=czb8Dca6ZEiton8RqRwZo+NTd08LnmdX30AmfmJ4IGw=;
        b=qXwliqaA80//nP9Z4TyG4GDTIQ/9yxc13x7a0HMWmep0OxHGRuzr86AYrZDbGI1cRG
         melkxSb+yDjY16MtiNBZ9V3vhlbtoI8V2ryn5wHR6D4K1ysI2QTA/M8qvmsQIGNeXFN9
         rBWByI6H7ZhxAX8Y47sVLXvuz27r23RH4bDnurCjdB4SSEu0tMTq4a/LEQboo1kzjKkj
         w6GfNnFHTuijLU7CsHVdviQGyCQtvQT9reHctRQg2KOU2ieH1pBC1MlhBDoR5oNLSDNo
         xPcaJY9WyQVqdbqv5kT8YAao0f/Kx3qi9L1QqSGQrUYptsLbnJedhuWkFIbnsN6zQ7MV
         ayIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729276830; x=1729881630;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=czb8Dca6ZEiton8RqRwZo+NTd08LnmdX30AmfmJ4IGw=;
        b=uOwqFgBe0bYFZ0HcpPghx6OZBUzyEpqYizEKPfdh13NJTWdYFtyingkX0YQpCpJ6ko
         +hAHyg0Iv9P1I17SONc0xzbPRt14qz/+YesBm8Ljoup9SCkUAZgRxzICcaYiVXWxtAoF
         FAAJ5MtiVYpLL8A3jR6q0m3YWDoLz8ESogD9WReefa9jmaBxKyfb12pfm1wV9OIRWTuU
         PbKtJdBoCU50L1aYWPckS3EZoTCN6jt3ENEuxmFlCxdWBj+2EYzwX7Y57wtrFHUDBZLQ
         +ee3HSw89D6Z4v9ecxDb+gASvxzFRVqzZ9lhQ5l8t9KEb3/F638kM44aWjI7/jUbjgi2
         zCIQ==
X-Gm-Message-State: AOJu0YyjxfRoEuVapHEA0Ki2Z+ROvPOFTEWE3It7Hj5kFwbEQAVfHrFQ
	husGH8+tC3DvBVraxKC7cfBRBPeE5BshRFg+sSnS40bxMKgIoe78Fx54wP0i2lPNQEUPRKrD169
	+
X-Google-Smtp-Source: AGHT+IGyqORI3P3Pw5Tp3DrgTiQ9bVF0vjm+rg6ZgFsT/uL7c64BNqBE6UqEL+V2w3En9EqNZXNuWQ==
X-Received: by 2002:a05:6602:3410:b0:83a:a305:d9ee with SMTP id ca18e2360f4ac-83aba63ad2dmr453968839f.12.1729276829756;
        Fri, 18 Oct 2024 11:40:29 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc10b5b179sm544654173.12.2024.10.18.11.40.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Oct 2024 11:40:29 -0700 (PDT)
Message-ID: <9517167e-8338-43ba-a40a-7b487c12ac45@kernel.dk>
Date: Fri, 18 Oct 2024 12:40:28 -0600
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
Subject: [PATCH for-next] io_uring/rsrc: don't assign bvec twice in
 io_import_fixed()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

iter->bvec is already set to imu->bvec - remove the one dead assignment
and turn the other one into an addition instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 6f3b6de230bd..ca2ec8a018be 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1127,7 +1127,6 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 		const struct bio_vec *bvec = imu->bvec;
 
 		if (offset < bvec->bv_len) {
-			iter->bvec = bvec;
 			iter->count -= offset;
 			iter->iov_offset = offset;
 		} else {
@@ -1137,7 +1136,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 			offset -= bvec->bv_len;
 			seg_skip = 1 + (offset >> imu->folio_shift);
 
-			iter->bvec = bvec + seg_skip;
+			iter->bvec += seg_skip;
 			iter->nr_segs -= seg_skip;
 			iter->count -= bvec->bv_len + offset;
 			iter->iov_offset = offset & ((1UL << imu->folio_shift) - 1);

-- 
Jens Axboe



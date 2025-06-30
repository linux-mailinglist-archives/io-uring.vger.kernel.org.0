Return-Path: <io-uring+bounces-8534-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E203AEE5FC
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 19:40:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55EC316E67B
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 17:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA60529344F;
	Mon, 30 Jun 2025 17:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yr69HSha"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC2C25E46A
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 17:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751305184; cv=none; b=oFrvFi6pPt5HxFaafLNsxYZ2Le/xkJ4A0wyNSePf4o94UU8qPdzkwJyDrZ1zW8EaKoQz+MBSzpqzFAjiBWoar3TmhPa/OD+rG059ILL6xrjRLbLTt7zdp425XBFhK71kdKwiox8iEa2zvGBpmHOFE9VSinuqkxg+zOXUcFUXB8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751305184; c=relaxed/simple;
	bh=8EMTXQ0VFtLRhmAmzvXbAXvOusONWvuoqZQZQDn+YTA=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=kF3cshm8d0oF5Xqpjzg1o0ar/yFVO7F52tK/G2krNaA6ycERrvU/ol1koV6Y8K0fzFfVRVKj2gNY2Kxux5j6H7CJ/hj74KIInVG2mo2PY8Y68vWcA+GKTRVb0cmKiaN46oYttAU9f5m+zPYaXziRZ+ykZZmhIAFjujUoVM3ztwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yr69HSha; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3df2f97258eso21918115ab.0
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 10:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751305179; x=1751909979; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o9Zb+t8Meu8i37JZQDn32dDrehcq8uO59jGrvQvbnoI=;
        b=yr69HShah7GBveSUlTrGad5m/PFy0W3aiEPOYbT0TW8w+XMpvEel3SuF+3pvl6gE8T
         clV54pDONFOXF8zV8Etf38WkNwGnRpU0J0jc0cZnYaBuDFYvinYyXegdIidmslxMerC8
         /22eveslEPlGlb12A+/OpN72TZdIZ6wAJslqxtF06fWo3Zk7zbhSns7MvXQYXdLubfiB
         avvXfzYitRNX9KL9u2iHQ3QtMbzQ/S2xCCJY2Gs4Rg03gMDBZhuUebBlh2t+0DmdxwNy
         1da5nBYQ9x7w4esm/ECSqsMPSscZXJW1NlU8ypFF6ExpFlSPEnwAUTmc3rbB0DknMMr+
         V/CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751305179; x=1751909979;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o9Zb+t8Meu8i37JZQDn32dDrehcq8uO59jGrvQvbnoI=;
        b=ahZ0Rfc6YA+SBQyyLyATB2JRacRfG4NlnMsXn+oSV3VziS+4crUY2vUJe+sbHQ31F1
         k11l5fhCr7zWsfIYdi8mepr7qxzAHFBs8wF0T0vZ8hdIb1jqyumoFcz5puU/j5ZDxt/2
         c7YgVVcktziMQoqGKHaIO/i8Yco40O+iDyE2d2+yEoG85deGevEEle8DourMrHLqEI8Z
         I9L5xF07TSqeY7mxO+CkrO+cZxq/bzyt3Cv7cL8GoTf1xuP8E10Dz4xLhq8PhXQiui+B
         iOQ0GCpql5RCO1iYi+AToGLajO1BlK7ZzpsviU3MLA8ks8bl6Un2LOU7hpZqI6j+Wkha
         p+Ng==
X-Gm-Message-State: AOJu0YxaizhvztYGciRH5oJSwzrHjdK3fbmufNA10X2/6SCl9adY6kG0
	8p45BFHcpfD7gxM3bkiwdJsgukFWgOPL7nrGllTejXsW0Wz16KYuInlQRBkA4UTjPLcYZk9PFOf
	iBuYt
X-Gm-Gg: ASbGnctwynCAJ7xqwJOfR4cXmzpNWRSZeXCPyPl7vZyeG28pth2XpZzwHmR+djzNqf5
	sfRDY7bUIWNN1bQqH1Ev3YrB6TmamjbakLXVtO2gOcoBlCTrSbaIaSikjkx23Q+cobdw0EyFQUd
	X7OUI+QcDoBghZg6RGkQe6dRvPdjV0M6+mLZrROaNup4AlsGCcb2dfZCyVF9LxFgsmv0jv3S/vl
	90YpTQgtC2d84vhK2ASWDsSyce+M9v/f3q4nwZmIjc/dcXqUd+x8BNBHBVJcXBIXe0krB72D4UV
	CU+mnt7u4SVKYp+sba9hwOknWEpeI6AGDbl8eYUJPyfxbKJWRFF4CjekUtY=
X-Google-Smtp-Source: AGHT+IEdgTmzethJ2rKPgCvajZd+OPuVkSex9IQYLQ8cyU3kKWzP8qDYYrHTuiAVkuwu4/0zOypSNA==
X-Received: by 2002:a05:6e02:3309:b0:3d6:cbad:235c with SMTP id e9e14a558f8ab-3df4ab6244amr169333985ab.6.1751305178913;
        Mon, 30 Jun 2025 10:39:38 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3df4a0a772esm23760675ab.57.2025.06.30.10.39.38
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 10:39:38 -0700 (PDT)
Message-ID: <2701f5e2-1c95-435d-9422-ff095ac28d78@kernel.dk>
Date: Mon, 30 Jun 2025 11:39:37 -0600
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
Subject: [PATCH for-next] io_uring: remove errant ';' from
 IORING_CQE_F_TSTAMP_HW definition
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

An errant ';' slipped into that definition, which will cause some
compilers to complain when it's used in an application:

timestamp.c:257:45: error: empty expression statement has no effect; remove unnecessary ';' to silence this warning [-Werror,-Wextra-semi-stmt]
  257 |                 hwts = cqe->flags & IORING_CQE_F_TSTAMP_HW;
      |                                                           ^

Fixes: 9e4ed359b8ef ("io_uring/netcmd: add tx timestamping cmd support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Noticed when liburing CI tripped over it, after the merge of the
timestamp test case.

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 85600ad0ac08..b6be063693c8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -980,7 +980,7 @@ enum io_uring_socket_op {
 /* The cqe->flags bit from which the timestamp type is stored */
 #define IORING_TIMESTAMP_TYPE_SHIFT	(IORING_TIMESTAMP_HW_SHIFT + 1)
 /* The cqe->flags flag signifying whether it's a hardware timestamp */
-#define IORING_CQE_F_TSTAMP_HW		((__u32)1 << IORING_TIMESTAMP_HW_SHIFT);
+#define IORING_CQE_F_TSTAMP_HW		((__u32)1 << IORING_TIMESTAMP_HW_SHIFT)
 
 struct io_timespec {
 	__u64		tv_sec;

-- 
Jens Axboe



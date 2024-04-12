Return-Path: <io-uring+bounces-1534-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C071C8A3642
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 21:18:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC0211C211FA
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 19:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9987814F13E;
	Fri, 12 Apr 2024 19:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Vc0BNm+a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B40502A9
	for <io-uring@vger.kernel.org>; Fri, 12 Apr 2024 19:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712949524; cv=none; b=JiGRRCJRruj1SoQpU5cqg4XhoX57EMibqbcsacw5ZbOdtlMkzmz6XQUJfgTH5Eyc+lU9pkdfra9hdJRynoekj8niRUNxtYF/PqwDBjiZoMg0Uv7A1fH68rd091I/w2gWwrttH55X0an01CJFbLx9e/UT7sZlAEZ5y4sqeHg5cJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712949524; c=relaxed/simple;
	bh=hg+0u7bi6V2DcBpK3P9atnd5FI6jCWTh+gY06QLMx54=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=aeX6lWfpsEnDeE2G7MrlMMYO86kCrDTs4e/58H7VZqJfmw+JsmNlEce8Eo8U5ReMCNOLf9n4t6+tRfknUsUbfq6A1LhfQIpMU7ZIKBCL53+V+H5QnuHTA60EymDmOxV/AlbRNVgrmx7LiviIJYpGn/ccq0O8c/nA5ncZyrhG/E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Vc0BNm+a; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1e2be2361efso3260905ad.0
        for <io-uring@vger.kernel.org>; Fri, 12 Apr 2024 12:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712949519; x=1713554319; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1XWQsglzBW1kf/hVVdsv7SNq8iUHIkYQs5ceD+COa4M=;
        b=Vc0BNm+agVDidgMFDotbv70+QI+9OrpQA70TiLa9RNOU5SXA+2lLGu//S8PvPpXoS+
         JU9QJJN2vMa52wI4VwnU/7g+USelGooiRkvqnmopVUxmRVIlKmT33dMhbxRl9Y7waq/l
         g/7Eiv6RxB3yDmnAuZtitS509M0/dCnFuUHlNjIblGuJ1tjd1btmtU4onA5ArRYLqvCc
         siyB79vqt00KTOSgw7QhFd/EHt7dTRm0E0lt4ZQ40UHlu3YzOn8FAg4EFOFE8BqSDyxO
         WymgQEGIVX3vlrnq+WdeCK3jHUXYxfWv3jjtzsxFEzBWUgFf2SUpp36wWTEyspw+z7G/
         XgeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712949519; x=1713554319;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1XWQsglzBW1kf/hVVdsv7SNq8iUHIkYQs5ceD+COa4M=;
        b=oP8Of+PkZz7YBqrw5A1TneimJ7M4KXCrEvtKg/oWLVH5KiLm17NWiVvAQuXrKsKK0+
         odjll/jglukD1J0HmQ0g2xMoTrFMPFP7NOQ0fg3KGxCc5Lo0x9L+wr2WfkUQ04i3gudT
         9cqCsdIX+QkgXoOiKCrd++zB6gyI5JO4m3kl1Zj6RCN7N8s6AoPbsSXYQNTVq5BOWx1h
         s4jbAaObIbEVbYaiGEeQLO2UABS/yfSyfzQ4phUtT0QK9X7hfdbQgQgJIRo6H0qQObMz
         JYMssJp1GqipOOPuEN6+qeq0kFZqcJvA84W8dc3T8LpbCvhcvyUdMxOscRag4rFB7W9V
         497Q==
X-Gm-Message-State: AOJu0YwPbMBuyHYI/kRdpDC1JcyQ4XUO1C13khid+cHtcKKznveTchxg
	oSDplgKSxxc8F8NN9mjTJ9NMzPVRmQbHLCs0U53ypb+382ugooutkGToz2s6/BX0cst26Zy1vGg
	p
X-Google-Smtp-Source: AGHT+IFQlvEQ9+Q5mSBkldfVYraTkkVHYgvdUKm1i2kFwLjnMJUPJDOOSvMvT8OZwgpLCJ5BF+lHbQ==
X-Received: by 2002:a17:902:da8c:b0:1e2:c544:9bb0 with SMTP id j12-20020a170902da8c00b001e2c5449bb0mr3670489plx.0.1712949519358;
        Fri, 12 Apr 2024 12:18:39 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id y2-20020a17090264c200b001e0d9daa927sm3411206pli.49.2024.04.12.12.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Apr 2024 12:18:38 -0700 (PDT)
Message-ID: <025b6c13-98fd-4b35-be83-257fd34291bc@kernel.dk>
Date: Fri, 12 Apr 2024 13:18:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring: ensure overflow entries are dropped when
 ring is exiting
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous consolidation cleanup missed handling the case where the ring
is dying, and __io_cqring_overflow_flush() doesn't flush entries if the
CQ ring is already full. This is fine for the normal CQE overflow
flushing, but if the ring is going away, we need to flush everything,
even if it means simply freeing the overflown entries.

Fixes: 6c948ec44b29 ("io_uring: consolidate overflow flushing")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c4419eef7e63..3c9087f37c43 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -674,7 +674,8 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 
 	lockdep_assert_held(&ctx->uring_lock);
 
-	if (__io_cqring_events(ctx) == ctx->cq_entries)
+	/* don't abort if we're dying, entries must get freed */
+	if (!dying && __io_cqring_events(ctx) == ctx->cq_entries)
 		return;
 
 	if (ctx->flags & IORING_SETUP_CQE32)

-- 
Jens Axboe



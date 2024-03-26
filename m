Return-Path: <io-uring+bounces-1236-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81AEB88CC48
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 19:47:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B33B11C61DB0
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 18:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 834E913CF85;
	Tue, 26 Mar 2024 18:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zH5cC2ZK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C281013CC50
	for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 18:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711478831; cv=none; b=M3/joP1sL5i4VC+DiGk6eSwE4i74r38zm2hpp0JujclUNhl+Lv2yBM7IdqA1+Ntw6RaUsVY1IQWyvsdJw0qzokLlGw1udJVBtd5RjGOyASce6SKhNnm12l1+R/EWMaPYvw5pgO+veizbg8xcO7tE2AM6zEcumoaQkgl9x/tymXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711478831; c=relaxed/simple;
	bh=YzMmQkuUIRgzFFQAkctpRHoD6snLv9IpyoM7txuGVCE=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=nC4wSahpj7ERHqLFcqIPl9D08iOKJKpmIMFSFKfj7bxbnuKjrNF3v3azzIOtQtQepVMjffhmCxw/4SwGq+iPCWd91tFOqGTq+xeL4p1/JGwTO6JYzqyIKmklkcRmvbe2DHjcM/lnYe/gxwoaRfYSuzVAMhXGVwM82fnB+V8RLSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zH5cC2ZK; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so1075441a12.0
        for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 11:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711478828; x=1712083628; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yUVfQcfvwRh08AV05NkzC7lSSdaV8TwHEOpjUa0+Vxs=;
        b=zH5cC2ZK8Ju3c+H+H08pnEK0H3ssvvkf9iowHr+4uUqYR5UNHv3VkziZIhkKfdQAw/
         eYAEVG133/ZDiQZ+BRpC4fibS7vnkWrHFgvnIT8iXFNj/ERBQKorcK5H5UvZDjQHEu89
         ZTPfNSPU6L5DdBgkkB6zmngBlVklZ6HWjbQHLHMqWD7H1RPKu0f+l8CSkQpm/YQt1JOg
         nxga6fGNZWNQyAjnh3JLJoUc4/e6sjrZ7+3DegSRo/hG4k9DdTFqlOecRc28sz1hne1Z
         BN5jl8+enmbv9X2RFbWi4ExGSudy5tFBk2veXXT8EveveMx05q7A9JzVgFQgfx3L2LUN
         nLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711478828; x=1712083628;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yUVfQcfvwRh08AV05NkzC7lSSdaV8TwHEOpjUa0+Vxs=;
        b=t20Li3YNhzWzfrA2yGSl9tyzkwlpW+PNIo/rxa8KzWWBUn5IOl1qbb0cTL+5sYcqDe
         bfpOqu5q7aqRl6pxfx4BDufZ7iLZunaJ5jzxJV/aye1GnI6rUOK/bSX+BWyDJrPbHzcW
         MCo247/GsDe6Ct0nK/g/WbC5zc/vqY2MsX9W9GUGjj59hb/kXOWM6wDQfvIVnvBh+YD8
         0HfKArTZE8HMJAyer+F1REiW78y1fN2edcO7cm7V5Sm84Pf15JMWDlWwnfgcL0Pu8xbg
         EweqoDi9mpxFcUcU9iyaPofUDmHet2+Ja1GDhXc6hL5kFQ1on1TyHf7wkKc0oKYtLxvg
         OUmQ==
X-Gm-Message-State: AOJu0YwlWKnqut3uf0JDGLUTMSFT+XXYemYcsVGtXYxD5+SouI/K7nDU
	m27M7gAWGMeFQmyejPIm/vvAaJK9xaaQ0UL5+KJO3zOIHqTaVDKSRgNYbkqsuJ0QCP4YMkVaFKx
	1
X-Google-Smtp-Source: AGHT+IGU+nEe8gU1qEB9GrRPoO4YtIvq2BqUs/IIkUphrUB3avBJiQaXSJT0cw0K0+MdYV/MHdUHLg==
X-Received: by 2002:a17:902:a601:b0:1de:ddc6:27a6 with SMTP id u1-20020a170902a60100b001deddc627a6mr11498093plq.2.1711478828536;
        Tue, 26 Mar 2024 11:47:08 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:122::1:2343? ([2620:10d:c090:600::1:163c])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c20d00b001dd82855d47sm7151084pll.265.2024.03.26.11.47.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Mar 2024 11:47:08 -0700 (PDT)
Message-ID: <f0362cb9-f69c-4152-9299-98ee2213e49c@kernel.dk>
Date: Tue, 26 Mar 2024 12:47:07 -0600
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
Subject: [PATCH] io_uring/poll: shrink alloc cache size to 32
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This should be plenty, rather than the default of 128, and matches what
we have on the rsrc and futex side as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d300362078a5..40a98f6424ab 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -307,7 +307,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_HLIST_HEAD(&ctx->io_buf_list);
 	ret = io_alloc_cache_init(&ctx->rsrc_node_cache, IO_NODE_ALLOC_CACHE_MAX,
 			    sizeof(struct io_rsrc_node));
-	ret |= io_alloc_cache_init(&ctx->apoll_cache, IO_ALLOC_CACHE_MAX,
+	ret |= io_alloc_cache_init(&ctx->apoll_cache, IO_POLL_ALLOC_CACHE_MAX,
 			    sizeof(struct async_poll));
 	ret |= io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_async_msghdr));
diff --git a/io_uring/poll.h b/io_uring/poll.h
index 5c240f11069a..b0e3745f5a29 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#define IO_POLL_ALLOC_CACHE_MAX 32
+
 enum {
 	IO_APOLL_OK,
 	IO_APOLL_ABORTED,
-- 
Jens Axboe



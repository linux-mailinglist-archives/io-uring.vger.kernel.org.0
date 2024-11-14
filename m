Return-Path: <io-uring+bounces-4698-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA7449C915A
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 19:05:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C920B3785C
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 17:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D412AE8E;
	Thu, 14 Nov 2024 17:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G8cez6RP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F36318BC21
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 17:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731605888; cv=none; b=WNRyaXe90UkNDE7e3SerAOminls8Wnsfk4hbYRGnuzQ7aSlBv2kLiiBSv7JtnWZ66v5ZaebDNgjV3jk9wQ232b0/5xymWSuOi2pzxqGDzTq4X0Kd9f3wfXhanQ8AFvYTgDaGcmQ0WQZJ69eWd8HfvgmZ3XV51wcooQSvRacn590=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731605888; c=relaxed/simple;
	bh=eGfmk5pHWRmz/5IEyopxX540NFO23oPagEaL0p8rDAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0e0OrT7FlYSzDZqV5oD9UmKLetN776itlP+1XRV8l84h03LIUVTf8fo8RuMo8hdnHeGjiNqB4Pd6KAkk/qWtMBQ8EwU2JGwwnRfgl6+M3lU2tZ9yR7spA1Ae5lf5zRjpOUXAAgr9zhDqZppGVLGod2JM/5H6odJ+LsmctfKIv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G8cez6RP; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9ed7d8c86cso177264366b.2
        for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 09:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731605885; x=1732210685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LbuG+/DWjJeYlovcxNfbsJzRVRRM+t1Xz3YpJq8xpS0=;
        b=G8cez6RPIwAR8x7+nmHlAoSVGHR4QFYoEtCGc5tMUZyGW87TvWUGOdyqnb1+g7Y5+c
         QdaIVkAwP+yyXjfVLWDP6DjhIjXkih6NEHwZU4iKF5gX9jqmAsIuZxztNBq+xQI+qvXj
         FibzQ9WdSlreV7AMEVPSVQX4DN0xFDt6AZF/KAP9yjWcFS0DpYw3/2pBwAwtn0kNtf+1
         rKR8fqQmdy8OGdxvgbpO/h2Cb6ZNhtYL6/iasOk0DN9gy/rWPnVNDqOsIQpHMa6aAn1o
         inE/1lwUP617mYnjPMHeLcdjAZYT4YAtpeISxyQdv27tHFf+AX2yiQSkEj8PSXmnPBW9
         1a6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731605885; x=1732210685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LbuG+/DWjJeYlovcxNfbsJzRVRRM+t1Xz3YpJq8xpS0=;
        b=hhSB/oJ/mlL1oDNaerEhf0B07U6qkLvLxdEkSJAKdNWs30FjLrWrqD6Wh18G1yxEht
         /K8lGShhCIXQOBjev/1sAqfXYfRy9zj4+ruFJtbHaO62IuzrndmIG0Gnw+/RW2Fkcx0k
         wGNZoxWQZc/AN+/NiGAEMePWBfs+1OfH6u3Jv2KJLIqbACs1GUshOp0agTLA4gj6Rsew
         xlTocVpLb7Vi4TeJ5n/J268RDx2YNn3WAAIiRs+YiAWkNa0SGwgSsJA9/3KxHdC/gQxP
         MbHFFG0bNWYw/5VpYeK9XIDF+rR0cped0lx9hMBNC425gEWV/+lTaZD0ALFIAUFk+08R
         J7/A==
X-Gm-Message-State: AOJu0YxZA3yT6A2jj4JBq1CPc/2r9O9XA4hqGMZHzxfGZRVV0xE4TQxi
	gmj2nnwReZBnciJKop244z7UXI8KYniTtChj94TvrqUhJ/X+6kAZUJzqzA==
X-Google-Smtp-Source: AGHT+IHPArKzr3fMaAJTnvZ+EUpv6cqA1R77i/bGHxZDxpxauFiGcxt6u943IhQp3U/HcDcffBOXIQ==
X-Received: by 2002:a17:907:7b88:b0:a9e:b150:abea with SMTP id a640c23a62f3a-aa1f813b789mr584274866b.52.1731605885116;
        Thu, 14 Nov 2024 09:38:05 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20df56b31sm85799966b.72.2024.11.14.09.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 09:38:04 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 1/6] io_uring: fortify io_pin_pages with a warning
Date: Thu, 14 Nov 2024 17:38:31 +0000
Message-ID: <d48e0c097cbd90fb47acaddb6c247596510d8cfc.1731604990.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731604990.git.asml.silence@gmail.com>
References: <cover.1731604990.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We're a bit too frivolous with types of nr_pages arguments, converting
it to long and back to int, passing an unsigned int pointer as an int
pointer and so on. Shouldn't cause any problem but should be carefully
reviewed, but until then let's add a WARN_ON_ONCE check to be more
confident callers don't pass poorely checked arguents.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 85c66fa54956..6ab59c60dfd0 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -140,6 +140,8 @@ struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
 	nr_pages = end - start;
 	if (WARN_ON_ONCE(!nr_pages))
 		return ERR_PTR(-EINVAL);
+	if (WARN_ON_ONCE(nr_pages > INT_MAX))
+		return ERR_PTR(-EOVERFLOW);
 
 	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
-- 
2.46.0



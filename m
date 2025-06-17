Return-Path: <io-uring+bounces-8382-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85D14ADCBBA
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 082573BD3F4
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 12:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949402E06FC;
	Tue, 17 Jun 2025 12:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NAI0AoIN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EAA2E06D5;
	Tue, 17 Jun 2025 12:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750163993; cv=none; b=df7+rmY/UklEXzbj/QhzfmZSbw1A0dRAZQ6l0+m5LnyIYFq1NTtmj3qVjxjIcDW+2pmEBPvXtAOJiOKiTxbkvz07ya0NA+3jrEEZ3Us1sNdHkQZOBhJ88JSf1AEe4XI96apuFNimsssyS8d+VL6Pr7teHrkqzmOQEfM7IiX1GW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750163993; c=relaxed/simple;
	bh=u7FHmsIUirGkdh9hdjz/wA8Gj0a7ZkHKGmeHuNS4I7o=;
	h=From:To:Cc:Subject:Date:Message-Id; b=qmGmSC0WXOvgTGQQqJgzWtXcioAn5XfC7CaxnnKeetNRRVt9WsZctK0QtFFkFxtwrb2g3XaAcDrMPYq1tGOWyrqXf1QrWN+2kArJUjDU3wL9c6lI60uDxwl3z7fJgwANm4DernQSIXO28QIdeC/hUWwpgmxNJABA6r+hrdYXwpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NAI0AoIN; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b3192eab3c9so3537134a12.3;
        Tue, 17 Jun 2025 05:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750163991; x=1750768791; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=plpd7fG8z7aEm2eUC3mp6a7hhKXScffJgSHefA7VW4c=;
        b=NAI0AoINwiINFQnaKmwPOrRn/yr+wXE8ZUUMCtcYlSw+S1WL9/5ZQgpSHgVa62aSMU
         KoJnVdXNniYvKflwTh9qgF+iSmRW6OHHyC+/cVoiBt48Q2UaosEW7O2ZrCH3HzX4rVnT
         PIpP3EHdNjNRq/+S4zThGc++XqZvcyPRcwJ2dyOdn4u3xVCEVTTZMULaEb8VcTCFznmq
         Sj1pxz4257zaRSJYhRpJ4RSUTHbVVdC5/nvZ/uQYOMjRE0eRRMxklpqT8SQqO4K7HW8W
         CJd4Z3PbxEMF3VFT1R0Jlwd4+vYo9WXg1hRk/QmoDjqBmYcs1cITyPU8dGN70eCM3Nic
         zsAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750163991; x=1750768791;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=plpd7fG8z7aEm2eUC3mp6a7hhKXScffJgSHefA7VW4c=;
        b=KcoeTHjbZLt9QHZ1joALb93SUIaT5vjyDWQZCRUXWQt+0szCAtQfbf1NTfZ/vZDd64
         Z+thvRoR1qM3pjxNS1xbH37DMZ2y8bVovyE/h14X9rOY9y/O+TD65z7nlg3UUaz+FHbK
         et2tlFzr1LqtwLo47Glxw+AloGqICZVLIgJmK2ORmrPkxo9zqBJcoNFpRDfqE79Gpwky
         tr116OZLHbu5B2WUeF9hARD/a2ontGehwZcl4mC0aLraBbCWs0H8raYH/CycZ3RZzGJc
         hGNZZiUU5omFK6NqX5aReK3R6AWG5PSREfbT3HkAeg5bcYNNOt9qn/q9xWD+EOe+wnAd
         1bDA==
X-Forwarded-Encrypted: i=1; AJvYcCUXvYM7q+ZDpHOuTku1Lch91LD5WsLqYMvrtCAeGrio5+TTDd0AARlr0rzMv+irozSdVd7SNu+xNHBhDbc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHXK6wZfsEYMNV8ZufP4id+aHOHh7+JdVbS1y+6giqmkrtt9QT
	yUqUqYprWma1OhEe5q5wn6DolFkKh7MJScUVeAetvLd0yDToL7UsE8+5
X-Gm-Gg: ASbGncu1El1jpbrrH9K6cFiur4L7yLDRO/Gnr07x0zQNrhbmBt98YqwjIUlkxYqbiSA
	J4vI0BQ7cVe5xKSSYNDXGhdv4v3nPK7lr773Yhm4qNE6df0cGcEAjnN0hyG7j5d+HPW3sdRi2+c
	sYTdDe9gxsnbLRW7SO29LNbGjf8nd50lE/iMyYpaorMgmIA9tKcc/nAkxHBgkSDjmEytRtLL6lC
	+Jiyl3GPguHOsgPMWQzQ0rDnx8OsvEJ9vxnjJW2Q5JhAA6eayItTjEmztRNwCFuEgfH1dDLqJd7
	d9eB+kPmRa81gFD3TK/LR/V5Jc6kB3rPG/Ug9s8LGxESH7/0mP+8/o+Cl1F9OqiteS3YVT1oTHY
	SqTjQcZ8=
X-Google-Smtp-Source: AGHT+IEzwpFm1YNKJQ2uwyWSgTu8baa3dx6wLwvc5mHBvqs9ya0jp4wS4e3UMSEVcrx44o/7KJHGAw==
X-Received: by 2002:a05:6a00:2e9a:b0:742:9bd3:238a with SMTP id d2e1a72fcca58-7489cf5a845mr18627236b3a.4.1750163991148;
        Tue, 17 Jun 2025 05:39:51 -0700 (PDT)
Received: from ubuntu.localdomain ([39.86.156.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74890082b1csm8937389b3a.103.2025.06.17.05.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 05:39:50 -0700 (PDT)
From: Penglei Jiang <superman.xpt@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Penglei Jiang <superman.xpt@gmail.com>
Subject: [PATCH] io_uring: fix page leak in io_sqe_buffer_register()
Date: Tue, 17 Jun 2025 05:39:40 -0700
Message-Id: <20250617123940.40113-1-superman.xpt@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

Add missing unpin_user_pages() in the error path

Fixes: d8c2237d0aa9 ("io_uring: add io_pin_pages() helper")
Signed-off-by: Penglei Jiang <superman.xpt@gmail.com>
---
 io_uring/rsrc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index c592ceace97d..f5ac1b530e21 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -804,8 +804,10 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	}
 
 	imu = io_alloc_imu(ctx, nr_pages);
-	if (!imu)
+	if (!imu) {
+		unpin_user_pages(pages, nr_pages);
 		goto done;
+	}
 
 	imu->nr_bvecs = nr_pages;
 	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
-- 
2.17.1



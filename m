Return-Path: <io-uring+bounces-8637-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C38EDAFF314
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 22:34:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FACF5A809D
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 20:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9B29242D77;
	Wed,  9 Jul 2025 20:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wbkVOj9E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A6F2367AB
	for <io-uring@vger.kernel.org>; Wed,  9 Jul 2025 20:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752093270; cv=none; b=hmS/8SGJfqaGT51caWO2x3Oat1ftaHdxeOFr1OKPBToV8Ngup87vVM25uPZ00iLlAGfQi8pabPmIyaxQZ5qlov3phuNpOOenyMdPPXiLlZxTqQlRv+4WIKe5uNwQoPpWGteFaxsmFrobPU47whO8RYFXBzSCl0KW8DxMuS18vQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752093270; c=relaxed/simple;
	bh=fbBFqaVjOqTqrjqk70OlH9PTjNVfH3b9w02Uw0h05GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7VwmX5rle0xXXOi2fMJph5vviF9VZgz8TsSY78jPFfzSeNwxQwiOQhdlZLHt0QSKsr3aAiB1sz0VVHYxa9EcRaLLIC+D67itXwF1nSzi8gUfoIfGOKKYLQzGLfWVhTrq5T1YdnwEvjZs+3YcioBNbgotU1Ucn5hN632kaIHA0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wbkVOj9E; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-86d01686196so11967439f.1
        for <io-uring@vger.kernel.org>; Wed, 09 Jul 2025 13:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752093266; x=1752698066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DgPCMKZeL7C3iK6sKqzvsfPQgRGrIgyJ25H9MVcgXwY=;
        b=wbkVOj9EPbS710+S07RDzIm0iCt4FQqEKJTgcJ83nCoeCzSxGoE73c/2c/9676SJm2
         mBR2Td+u5fHaZC2l7B9VLSOXR9C7zg0MayIaeHCaxytz1r0jg3ejpc9Pnq1rL8l6Ye85
         kUKiodNvc9ZaFut9UQECdfcDuILZyVKjLWdZya8oACEzDT4LE3zN92OD2+I3S2THI68d
         8PzInptqSug0mLCeozPtOdS+PtnGI3zghxXS9fAXxd8d7SNsDxnAANj1EPk+FyNiGXXh
         1L77owkmVsK+TMVoFQu2J729GL2/ssoctgLcBmV9NQfDRqLBgaXiufsKlqMewf1W6VB2
         7wmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752093266; x=1752698066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DgPCMKZeL7C3iK6sKqzvsfPQgRGrIgyJ25H9MVcgXwY=;
        b=Bb9xZA6ZhipWDlFtB0LuCJUg8YvCPKMa+37s+jTRR6aVw8RcT7cGsMrbxhj5mnh1a4
         s6LS6t8dF9GtbtuWicbBJRr1QmyIzNugGQAA+GEuf1KOix7wh9IJCKmM/fOSWooEf9Aa
         iq4CMyO8HJAJCEO51TMvbfMQezT0SWQlj4+kyF7TMwKVgxu/hM5hfEDYyCn8gbzJ9lkI
         7C2YpnIbGZrNFXsuOtODfI/KVZRfCBcaurxU3mlgNw0W7IOnexttXZrI65FUf89nRowL
         v3/HKV9mFc/gRVW51W5hKuj/gRGeJEULaoDdQiQlXsy+l6K3laJ0g78trmyleRwenwno
         XD8A==
X-Gm-Message-State: AOJu0YyEcb42/+O6SI09xYev8INhvlc/DUYI0rw2AxEz0shvw4dy7/oJ
	AvoGHlJDjt1VQn9PpwEYAYbClbAqBfZU3orEd+7v9Znhj73KwricckS5+ahSGfASCnaEp0hRUhN
	eTMBd
X-Gm-Gg: ASbGncvwOR/PduR6COB3XOzFnaNDOGPX4n5ftg9Qy0IMxwGOyaVyOyepEv6aYLx0NdE
	k5rACV14NbFG/uTd69bRYAouvgKP3E5YgKh3Z0OWHoqSaKlhhgiKEnXjZk1u17/3y+ZWsbWTmUL
	eKCkVWVBBDwFjTg0HAF9w7WZYn1qNTl+FjTvGWaWJbIlxnwtahCYuhTIoCGJqltZFNGdV04sU5B
	SyN1rjlkt4wfmav/Qu7+7j83hpNl0oDWW/FG2cVQDPkgMad9YhWm8CgXLcL73ESvvInd4Hwvs20
	VhuDh9wuIeQC/UIYxuoaCMeUYKo4zITWmwutUurXf/oG
X-Google-Smtp-Source: AGHT+IH79dPBpTT3lIkeuxFUlKxNPH+komFyGqWxmyTU17palkWhe8UPF7BOGupZqKPMhwhrMKRBLA==
X-Received: by 2002:a05:6e02:1c05:b0:3df:34b4:1db8 with SMTP id e9e14a558f8ab-3e166fed7femr41233985ab.4.1752093266230;
        Wed, 09 Jul 2025 13:34:26 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e246229f5fsm125965ab.50.2025.07.09.13.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jul 2025 13:34:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/net: use passed in 'len' in io_recv_buf_select()
Date: Wed,  9 Jul 2025 14:32:41 -0600
Message-ID: <20250709203420.1321689-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250709203420.1321689-1-axboe@kernel.dk>
References: <20250709203420.1321689-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

len is a pointer to the desired len, use that rather than grab it from
sr->len again. No functional changes as of this patch, but it does
prepare io_recv_buf_select() for getting passed in a value that differs
from sr->len.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index d422c7fb2d14..144788bea009 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1081,7 +1081,7 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		}
 
 		if (kmsg->msg.msg_inq > 1)
-			arg.max_len = min_not_zero(sr->len, kmsg->msg.msg_inq);
+			arg.max_len = min_not_zero(*len, kmsg->msg.msg_inq);
 
 		ret = io_buffers_peek(req, &arg);
 		if (unlikely(ret < 0))
-- 
2.50.0



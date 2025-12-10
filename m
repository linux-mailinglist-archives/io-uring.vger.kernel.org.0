Return-Path: <io-uring+bounces-10998-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 26AF3CB277C
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 09:55:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1FEA73023B79
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 08:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5426D1CAA79;
	Wed, 10 Dec 2025 08:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ghHCercT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C342652B6
	for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 08:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765356918; cv=none; b=Gb7wQT4KHZj2BZ/w/r1p/6rxkn+LXMi1Kex46PN2fcafRBxeVZpVo8RgqKOhvC8Uv0B58tp4JzsCPpTvRsGWh+b2rxtPEHCkmpuL4LgqUAoN7kAruJf3vQcgXj2Q+sYFzejfNXvQvk27LCoajkv/9kXxTwGaR6eNWu3XibwvBJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765356918; c=relaxed/simple;
	bh=WJrRBvIliYqAm5GZgyft/3cN9t7zQifP0OVqjSGQJKk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oQwzZpvpeA6kKI9+KDXJUPxxMcvDPB2bxWKTt0EZPbnuZmoN0iBwpT//9t3k6IDugtc5OIQoGJvE7Hm27h1tZ085yv3kgW7tp3XRxFk1A13c19pFt9o8vKXDkT05o35HcB8m7Wsth93vj1aCbvda66CJ+x4O9wJ5FapgZ5Ao9Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ghHCercT; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7aad4823079so5940437b3a.0
        for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 00:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765356916; x=1765961716; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oWIGO3EyDprSucNjWe69O53NGHMzfwh7dNhqKVtdZC8=;
        b=ghHCercTLQ1O46pg0LJGSxZBNeSBbtd2MaWp/zMIXYWAEGjWx6U2V3AJKpWt4k7dab
         I5xOc6dOBx8F6b1BaNYmJJyZmXkSNKRJkxip4m9B8vjhmoGWU8RsiV7vUgcmVwqULqeH
         Bc3tzI7VIl0e2KcloVdn0qqGZ1AjR4vKZl3mET8cncWdGloZER2lW7LzK+MTJgDhlEJT
         WBVjc2UR4RZ6TbmmTN8wSb+1peyXcvyFmDxed5zt6wyp66+ynpeJ5oGcckZXhN187ogf
         rAjvJccNBevuI3Uzs+5E0nXd/RlHX9/fufjLBadg8rxWWjuCaS9ZP/CWNAwOE7VWdJpx
         f4CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765356916; x=1765961716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oWIGO3EyDprSucNjWe69O53NGHMzfwh7dNhqKVtdZC8=;
        b=u+HDx+5hJhyx+HvaKXsiBjL+yWbdbAe89PgXlXlDZBAkhTm1Mq4QqKQgoCIxVeJ4oP
         oYOH+xQbFlGOmVhN+0WpvG2I2qslzk2HGTrtTrgvX3O73c5d6GUWUJdYqQuT3JcPEC1/
         VblMGuPUvLv7/bX3LvoErUfr4Wvf/62BdCKYL0BdhbZs2sTVOuM1z1eBiuvH4eSZm7FC
         JihYOBttyM6rzjghszprISiQSKtBibkr8GWNfzKgihXAim3N6sq6xlgdrkG7P/FHrIQA
         prdsI4IhniHbxxw4sGh/HONDEYa5JzYXc8KBwG6wBbacDQGUlc3Nm7foZ4ol8XASnpnO
         xlPA==
X-Forwarded-Encrypted: i=1; AJvYcCXG2+7ngaKTj5qzyUgjVw5PrjkRKQ2UuLgqh/6+StaJ0MnKUhZE20tntG0vlOCEDP7kdouw6WbAQg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6c8Y4fJP020ybzsJnaUCLUzXCUwAEPq5H049ta5K514F/juLe
	ze/+9sFmeAYIxuahrQA1tcXeVTWLLtR6N6+Ym0jvlSsIA30WtR7wuD9P
X-Gm-Gg: AY/fxX7cCksBU9L9QlvZmaTS6cInCq3XyugDZ4Ip1lb0k1KOj0HLsAD5d7uZ4p2X3ST
	BpvtjmDNValdbmvV57/DY6GG1jXa3NUvsYUO8ETrmjjeuWTVrtsyxCcu4WIjcPezPwOw5l392Ao
	hU2xZ0B5LKMryqVSC/jjZrE7hn81EhKT7ugVw4J5BUWMT6UJ1VxAPTCBm7KKgQlWPrlzbMH5n2h
	RdRf9VUS92g6D8vResRJGB04+Je4My9EM/mcS7vt88UFTkHdQ+BxLGrwKChdtmCl7krnv9rUoIq
	lZZ5rWyZjdjjegZKbko6NYMOKFtur8lAZ/AH0jUE4A1FlfaAqzlYMZ6mF2wSno1ep/wqcr9sVHy
	7Dx9jhLrFmk4AsfXCpySYWqDjOF3+3Y6vOr1wKfai8SCKjesS6FjwfO/kGQBbKA8VZ7Sy/N75Jm
	dD8ODQ4KWGFmPG/9H3OGkRpnMJEVqk6wEUO8MbRZKmDfk=
X-Google-Smtp-Source: AGHT+IHX4jvUtLsD4qYjhKV3RoKpo7poN/Y01KH7aEBzs4wpIbjYwylBkqYluGswOfTEHHzVOAJnTg==
X-Received: by 2002:a05:6a00:23c1:b0:781:1f28:eadd with SMTP id d2e1a72fcca58-7f22cf1d47fmr1703697b3a.20.1765356916089;
        Wed, 10 Dec 2025 00:55:16 -0800 (PST)
Received: from localhost.localdomain ([101.71.133.196])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7e2ae6fcc87sm18681836b3a.49.2025.12.10.00.55.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Dec 2025 00:55:15 -0800 (PST)
From: Fengnan Chang <fengnanchang@gmail.com>
X-Google-Original-From: Fengnan Chang <changfengnan@bytedance.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
	Diangang Li <lidiangang@bytedance.com>
Subject: [RFC PATCH 1/2] blk-mq: delete task running check in blk_hctx_poll
Date: Wed, 10 Dec 2025 16:55:00 +0800
Message-Id: <20251210085501.84261-2-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20251210085501.84261-1-changfengnan@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In blk_hctx_poll, it always check task is running or not, and return 1
if task is running, it's not reasonable for current caller, especially
io_uring, which is always running and cause BLK_POLL_ONESHOT is set.

It looks like there has been this judgment for historical reasons, and
in very early versions of this function the user would set the process
state to TASK_UNINTERRUPTIBLE.

Signed-off-by: Diangang Li <lidiangang@bytedance.com>
Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 block/blk-mq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0b8b72194003..b0eb90c50afb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -5172,8 +5172,6 @@ static int blk_hctx_poll(struct request_queue *q, struct blk_mq_hw_ctx *hctx,
 
 		if (signal_pending_state(state, current))
 			__set_current_state(TASK_RUNNING);
-		if (task_is_running(current))
-			return 1;
 
 		if (ret < 0 || (flags & BLK_POLL_ONESHOT))
 			break;
-- 
2.39.5 (Apple Git-154)



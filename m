Return-Path: <io-uring+bounces-5883-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7B1AA1283A
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 17:08:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A98DB3A8CD2
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 16:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA52C166F3A;
	Wed, 15 Jan 2025 16:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GJcnXcF+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124E514A60C
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 16:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736957290; cv=none; b=jsdKMouxhEzEDaWdaR29AK/c1N7PZdJ/qRYE2HGClRTD/RQkgpVoMJUj2X0Do//p9xsvZS1sQ3e6rbtfaEHj6LdUecygUWWUYsj51aYT64QytW7T5geOtmrbxmSZE3ACcOMwaSJqeYkwUK1bXxqkD9uJNmI8fztOC+N0OppdwTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736957290; c=relaxed/simple;
	bh=yBgIJl/fDSrfu4WrineqOb0YqT3W6Ur4MM0UWV8Fc8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbBU5loI0Y5jXTCLOQjbN+bUTgf2ymuHzsrn07uhnLJ71BN60TRL+UD8GsIhnN9apPjAVY+qtsYDf7Uk7tJwxZVlgGumkLJgepU1EvZmV6rOnARqG8yWlRGvgKAdPGsxLAW2LxcgkPaF+WRFy5FG2Q8pEYngx7Fqkhe+NKA3hgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GJcnXcF+; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3ce886a2d5bso6039665ab.1
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 08:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736957287; x=1737562087; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z9x7IrsNmsaZltr4fv/sR4MH5dGbYxgvFKNl9SNU1Do=;
        b=GJcnXcF+6zvHIgah4ZFQdc15jm8v71TI2H8UolqEi/3dG3MES25bVLY8oB8rySBUm0
         7/1C6HpeYhy8gkIRZwqjJCCduH6HFs7ro73QYhK7I9JxCPNRu8hRBZIioQyNOfU0ey5A
         dVVTtiTJLwxvs0tfj57vsegatizAY8ON4fwVaQfnvrXHFdpzaq3LSLiVfmXxOaSQ53MH
         0Kzte2vplZHomQpBqhf9WiacDMMen8COP29sR+p8dbDf4b6Y6chvSjpRW4SJx+0Gtki/
         VIoaPv1OEA0MFcZxDNbDTOgBjh7SPQuzKzYDwfsojHKGZ4CBjVnxUSPUKbH+8kw/QqMv
         hHEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736957287; x=1737562087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z9x7IrsNmsaZltr4fv/sR4MH5dGbYxgvFKNl9SNU1Do=;
        b=l5l6pjzZmCVOg+2L7Is+EkcdilL3tZd7xC2SgxIBm9fLf+hIhtwc5OV8CDuH4Tu0ER
         taLj/8bD4pwtZcGxeBwegnxORysNE/4MTOgdL2MlxVke4zSgiE7GdACVR5B/VlWQEZnt
         EHNeRz5AMgmxKyKWraCqXpzyBOGTUBtWfYIbepyhxWJG7og7Uz52zTnbbsUAxcRSoJPN
         AEfEJMNFZq9uHbv9yN3UAOfxH/FIQZUb0UUvC34LTXAd2fkHHFDaOSCO7pei7gXpOwIz
         vHscXhR7inF5+icsWXG3sO+NJPQBEsmsPgeyR4IWSa8K60Ii3rcrM9bxk4FGt6eHNFPi
         VF/Q==
X-Gm-Message-State: AOJu0YwttBExaKi7ouJABKlyga/ODBrpm5QnY0VlkhTZ0ScNXDiPffp2
	k1Vzep3p/TjzNrp7h6AuThSt/IhwxkZWWckDkwjyDBaCdUFOwAzC2BDUdBPZhSK4ggx0DVFkZuH
	7
X-Gm-Gg: ASbGncuWEhS8WZK+YZ8QM9uO9zHEGvgnG4kBxyYSDGp2F80/WJXFnQXh2ON/6iuDdwb
	ZztzH4KEyTUOz6xkOvGTCbBZTYzWoeqEw6HxBuyA05q51b93qcPsEaNnteQlPJik8ECioR1oiNl
	pqTuW53siaECop26mm1sxH/3oD3yhdb/XhfTjH41td38nTciLJyHy39ugXsr0xHxk0KbRgHXCVG
	Umfprm7zJ2z7ffbnR1EnMQlLtUBRHMmvtFJkfszHLk+avkOegKhKzcTTGgM
X-Google-Smtp-Source: AGHT+IFT5uHBIN38EzZwdaGPAKY8QjZJybPNLCCmsUxKztdEwOIGOEPxiZLrjX5XkuiiogtItQl6KQ==
X-Received: by 2002:a05:6e02:12e8:b0:3ce:7e5d:6292 with SMTP id e9e14a558f8ab-3ce7e5d649dmr62785245ab.8.1736957287404;
        Wed, 15 Jan 2025 08:08:07 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce860d324asm4548715ab.34.2025.01.15.08.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 08:08:06 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: jannh@google.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/register: use stable SQ/CQ ring data during resize
Date: Wed, 15 Jan 2025 09:06:01 -0700
Message-ID: <20250115160801.43369-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250115160801.43369-1-axboe@kernel.dk>
References: <20250115160801.43369-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Normally the kernel would not expect an application to modify any of
the data shared with the kernel during a resize operation, but of
course the kernel cannot always assume good intent on behalf of the
application.

As part of resizing the rings, existing SQEs and CQEs are copied over
to the new storage. Resizing uses the masks in the newly allocated
shared storage to index the arrays, however it's possible that malicious
userspace could modify these after they have been sanity checked.

Use the validated and locally stored CQ and SQ ring sizing for masking
to ensure the values are both stable and valid.

Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/register.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index fdd44914c39c..5880eb75ae44 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -514,7 +514,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		goto overflow;
 	for (i = o.rings->sq.head; i < tail; i++) {
 		unsigned src_head = i & (ctx->sq_entries - 1);
-		unsigned dst_head = i & n.rings->sq_ring_mask;
+		unsigned dst_head = i & (p.sq_entries - 1);
 
 		n.sq_sqes[dst_head] = o.sq_sqes[src_head];
 	}
@@ -533,7 +533,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	}
 	for (i = o.rings->cq.head; i < tail; i++) {
 		unsigned src_head = i & (ctx->cq_entries - 1);
-		unsigned dst_head = i & n.rings->cq_ring_mask;
+		unsigned dst_head = i & (p.cq_entries - 1);
 
 		n.rings->cqes[dst_head] = o.rings->cqes[src_head];
 	}
-- 
2.47.1



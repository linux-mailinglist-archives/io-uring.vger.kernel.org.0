Return-Path: <io-uring+bounces-11592-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A65AD13A70
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 16:28:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8D8D93057A64
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 15:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057902EB856;
	Mon, 12 Jan 2026 15:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Td955bAl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621E72E9EB5
	for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 15:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768231154; cv=none; b=h+n/U+rUKzaCwG0zLNKrxrsaHOtQZuoCVEJaAoiT/SplUYVogJX9NxNxvnNy7p21l4IZrSKdSRGueju/iB5oV+VNoXcQ3uOCGhwduRFZTv6JB5Jol1couRGwnyEpGOZPEDmJ5y8NJnhHZ0joKAFmWFy3ipAP0gTDhJjt4ESgmY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768231154; c=relaxed/simple;
	bh=CHbFP2HctJ5wgVz6hnLqr0j713FQPStnFZTVjR2yOG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTj+bOC+xHVZzjJhBdeN39hTaoaYv9dT4AtDH4+f/dQqO9QDSZfXa7wmZVNmjho7WyGBBCTHp6Sa8/zQChp5REjfuf9r2T4FIHLR/RMef3mnnNyEcw1ZdOuJ8NbBDwOi56u+NEBUfv00QSVWdtcxeRq6HxtTKlkr7R9TIVryPOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Td955bAl; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-45a84c6746cso1287215b6e.1
        for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 07:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768231152; x=1768835952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yvxrXc5Fo3oSmC+rNCeaqTIuxJvwrD+I0fTX9JEQTZg=;
        b=Td955bAl7d5mjPL2yCGhDLt8XSuS8UOW+zVOVzvtGmsh3flyJjlw1Y43ZyG0fe69XL
         a/AExX4d9E8kJywsFuyE8Hp8IqcuXdbWn7XfjrQPRn1zw9pPSeXb9XaC/mjr0w+QY/21
         2andu23u7gecz05rj9HPr6MWECQsBMghPPZ+Km9m35TqNPDuAkb4iJ+oibQ/+fImutEG
         PG26mlhXN62yz4HCS+9wxffbKEzADArRIxQaa5icjvlI61knCyhnUf5g0b8eUV0nbHNm
         Lo7vH20Z2J+7DmwoZYG3fWpZPHsEINrok0lNX4L5DM336c2IlcVSpZTiQFUOUwLNasnY
         fpWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768231152; x=1768835952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yvxrXc5Fo3oSmC+rNCeaqTIuxJvwrD+I0fTX9JEQTZg=;
        b=gnE4j22ZH0OBCGUIvKYHTXGJ5BwsYO6YS8aEyFhSNteuqytCz2lw9GrI4kIhSOKOhv
         qPyT9n8lsSfT7MPcW6Q4qM62rCp8NjX+nk0FtVRUOmfCkYTOQ61JwpGx9VnieKY6b9u3
         MH3oYF7KF+ePvSB7hP3TEKnikQxXwlzt2lzoSdJTPbzbYcunFPMB0DOi1xGXm/LK67ik
         wKEa7moEeZTkDZpEPg1PJvi+zNN5YZaShtBMJpJrl9RMT08iCkKpk565l47q4U3cfyy9
         GD/wXfDOZ4Z1iwy/eb2P/R8OrjE6mGAhhn2tpYQDaSq/eFwHazX8iH+CNVJ9X3VgFkpZ
         DrKQ==
X-Gm-Message-State: AOJu0Yy0kAnfj49t0rMlaTNNlpSS30ABFZl0CqjlumNTlHGoPM5BsPps
	AgiebiC2bvjrlCE4+W8JQk95hH4GIqE+O5+IUJRkkmewEpdmOL3maMwyIsCUY6BcZWu+0YMG4r7
	HUw7m
X-Gm-Gg: AY/fxX702fA/OXEN0GcFaESxm569YlQwFVZ4Ep7p4Qxz6MZXYyHlqf0+ZT4lNeE/nyf
	UoDiy5kNUKoDqbRecxKG8I/8rC1Fw6u0hw+leQ3LVpLq6Aj00QMAikudSt1aHWZE/qAAgHGfNUg
	dGogrubxMPs68dkzVqvaw/ljJUyPVnXkN73k2QRTH0cDoBHyrpEILtnhLLw6IesFHqXER9fV08M
	9wk7i+Uz+69FdsDva+7kOrLBHauaoknYq/bXmUhDwSIYO8s+WOn721Mf3rQAp9MksHnZP0vfhPh
	JwYOGnevIcBXHVYlMBTmU1Sr+66Eho12RAwC99bTRBJouMGhAAlQv+O4kAUl45OkMILheRiw2/0
	wpmlVYS/AUUTh/NKScGhMjzT+gG98WfLqehZctjHtkGLdajkYCY5mc+9cdIdVBKSkXIbvKkI=
X-Google-Smtp-Source: AGHT+IG6sgfon3i7ym3yDAt7hX71X6PeQ8/5rxROFXeM/khMKXYFcOYDD3wV99iG2JUelFCiabqBMg==
X-Received: by 2002:a05:6808:4fd1:b0:450:c7b5:23d0 with SMTP id 5614622812f47-45a6bf118efmr9411134b6e.49.1768231151670;
        Mon, 12 Jan 2026 07:19:11 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a8c6b3fdfsm4210561b6e.17.2026.01.12.07.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 07:19:11 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring/register: set ctx->restricted when restrictions are parsed
Date: Mon, 12 Jan 2026 08:14:43 -0700
Message-ID: <20260112151905.200261-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112151905.200261-1-axboe@kernel.dk>
References: <20260112151905.200261-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than defer this until the rings are enabled, just set it
upfront when the restrictions are parsed and enabled anyway. There's
no reason to defer this setting until the rings are enabled.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/register.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 4b711c3966a8..b3aac668a665 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -175,6 +175,8 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
 		return ret;
 	}
+	if (ctx->restrictions.registered)
+		ctx->restricted = 1;
 	return 0;
 }
 
@@ -193,9 +195,6 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 			io_activate_pollwq(ctx);
 	}
 
-	if (ctx->restrictions.registered)
-		ctx->restricted = 1;
-
 	ctx->flags &= ~IORING_SETUP_R_DISABLED;
 	if (ctx->sq_data && wq_has_sleeper(&ctx->sq_data->wait))
 		wake_up(&ctx->sq_data->wait);
@@ -626,7 +625,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	if (ctx->submitter_task && ctx->submitter_task != current)
 		return -EEXIST;
 
-	if (ctx->restricted) {
+	if (ctx->restricted && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
 		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
 		if (!test_bit(opcode, ctx->restrictions.register_op))
 			return -EACCES;
-- 
2.51.0



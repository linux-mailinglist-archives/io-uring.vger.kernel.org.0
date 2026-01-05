Return-Path: <io-uring+bounces-11376-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D630ECF59BA
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 22:06:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BCC0D30A32E6
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 21:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E24B2DF3EA;
	Mon,  5 Jan 2026 21:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="TlQdqk7B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f99.google.com (mail-lf1-f99.google.com [209.85.167.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E532DCC1F
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 21:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767647155; cv=none; b=BuJl23rAKv/k9D6375AOrFLbzBiRw0yERq6Ni5YDO2f71FgW/V1PkWz2qRQ7Pi/ttKuFKVCFkQsTQ1zJslAqljJ3T3dKgIj4G/StoT8n6X3sAaaSbk1A/fy2/GaJuJBXBK3d1hQeFaiZRUY6lcHzAoywYzmqaprAdHayan2bLnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767647155; c=relaxed/simple;
	bh=B/TqW2AEv1uMhLD3CNnk8NlC/45nYR1F1/GepVbTJAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4n4VBDnyFospPic14HsDIF4BFkXQJELeCXW5KzUBgfclxV8KdiOL7PanWECvTzbimadMpGphcv7JX01cXGLm0IAyWwjmzPFtWJHhQIy2p+UswrAMJBE3lKsIZ6sZkElkLcgxMEPm4SwwcUROzc/HpqNJrj0aWfNwAS3VvTUNAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=TlQdqk7B; arc=none smtp.client-ip=209.85.167.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-lf1-f99.google.com with SMTP id 2adb3069b0e04-598e9f63169so21786e87.2
        for <io-uring@vger.kernel.org>; Mon, 05 Jan 2026 13:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767647151; x=1768251951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWGiugkBdzXdQk4lm2s3M65iuqmFUc9XsicklsZBNyw=;
        b=TlQdqk7BKwmKtEMqj2ByYabIL8ucCyWXgBEJfd8ms2yqcyB/Ip2g46nqCANYrGqvbj
         TvBvH27Ot8znlp/CSlqoKkHW4P/Jx005S4nWLt7dl8NOnMOHXdBUhE5wjAfLDlkP+NVV
         FVl6MUD/xDMoVj3mtrGQL77asN2js2z/jE6a0Sxn0W6oNeIOUrkSzd/uQDJhenkKNI8y
         OJNqa/XTapvBnOGcv1H3xHmtNdFqt2/hiNj4e0CStMr6kHRoSpeK8o7bjXuWHcCYUIEF
         Od0xb/R6yw8W3CBwc+rjRDlsdD5nSIP2IlJPDp7R1FzRR6j+omm7oam3Qkqwj9rMzbvM
         WqFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767647151; x=1768251951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XWGiugkBdzXdQk4lm2s3M65iuqmFUc9XsicklsZBNyw=;
        b=WGJnDzadrsls+kSHuJ8FgPFIhtvdrW+0ZjBjaZSk2BCPm+UU70JjCKa447QEh1yoQ+
         0Y09nbiIsxXYMalyAasq4lDo4vpHC2qhJR+G2KGkbCh7C3Ch7XmsJIP9Yx1pNHTzLA+U
         hpad3lLDqJapMHOz4VONLn7wAzY4mw/jJTUBCh4IZH12mLoKsiaYhMn1pRuj3ghGgcpU
         wRE0bI0sLmbOQEHcj4SORgCdiGuC7kMBQ1sjUHYDJMYYtseiO1CumdlmvXlSgXW8OiLL
         eP1lfiO4a3H1vLC3HjlbAb0CPTHkwIn+BUetck6dadfEaWpWZ1K83+W+Mu3j1NTycx3A
         8e1w==
X-Forwarded-Encrypted: i=1; AJvYcCWciMNFH6jjvtqSKchy3bjXmpQChBosQzBHf8LbTIxW0pM3L/KfcbsR7eucHhwChpadeunhHn1jDw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFyieFcz18O5b0mgBeYRitXtI2aMPAf782d8bDmklUu/PelIzO
	1VMeIXFO5OzDtuDjgSsN3IeQIjdP7NLRDV5kx+Xbo7iujgIFzk01tsumFLJA4vw048S2nLoVT1n
	aUd6fGZT9vmfUINsjGdBCo8V37bWnuLtrbyrN6w8vDMXQRdCLSLEn
X-Gm-Gg: AY/fxX4BLgcO/lQSH1yAF/7eJkXsUblZJ14nfaJRjVhIy6z453PdyYf72naDk4y8nNf
	BstMMClFLwuGZdUijbFmV9wW+elMUg+EhjHl+5hkNtUwh0n5yXfZwrR5XmNNBGt2A3ARHrTvQiO
	5UquFY/AFkSQwH+J2WGgiGv46tLM+u6/yzv0jmyNgXn3Vzzb5WREtXmMAETKEpBz4D9mr5BVLUB
	mmu5k/+X9lbLv5qiPcZMky+VbdpYkuvMPXkUUsLuTXJ0ybEs8250TU73BhMyFSvygOHXpJNV+LO
	ixrc5YrXfTYlsKQR5q41IX3+EBzyjE4wx6dArr6R21W3ny2QaDg5eQ9y2Sg/WciG249I1Y2nIDB
	RfM/COu/suX2xo15x5KCUjm4z3bc=
X-Google-Smtp-Source: AGHT+IH6Hr1qwriJCC85ndlQ1bvKXxyAoAHlS6y7iTKbZ7H1N7faF/tVmb56NvKrfk6smujvQ/oQVgYTIUfR
X-Received: by 2002:a05:6512:b90:b0:59a:10c1:8f27 with SMTP id 2adb3069b0e04-59b652bd49emr186687e87.6.1767647151238;
        Mon, 05 Jan 2026 13:05:51 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 2adb3069b0e04-59b65ce9861sm24671e87.10.2026.01.05.13.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 13:05:51 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.49.34.222])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 90EBF341C73;
	Mon,  5 Jan 2026 14:05:49 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 8D437E41BCB; Mon,  5 Jan 2026 14:05:49 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Joanne Koong <joannelkoong@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v7 3/3] io_uring/register: drop io_register_enable_rings() submitter_task check
Date: Mon,  5 Jan 2026 14:05:42 -0700
Message-ID: <20260105210543.3471082-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260105210543.3471082-1-csander@purestorage.com>
References: <20260105210543.3471082-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_register_enable_rings() checks that the io_ring_ctx is
IORING_SETUP_R_DISABLED, which ensures submitter_task hasn't been
assigned by io_uring_create() or a previous io_register_enable_rings()
call. So drop the redundant check that submitter_task is NULL.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/register.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 8104728af294..78434869270c 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -178,11 +178,11 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 static int io_register_enable_rings(struct io_ring_ctx *ctx)
 {
 	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
 		return -EBADFD;
 
-	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER && !ctx->submitter_task) {
+	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER) {
 		ctx->submitter_task = get_task_struct(current);
 		/*
 		 * Lazy activation attempts would fail if it was polled before
 		 * submitter_task is set.
 		 */
-- 
2.45.2



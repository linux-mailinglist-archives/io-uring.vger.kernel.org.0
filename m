Return-Path: <io-uring+bounces-6198-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EE00A2403A
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 17:24:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E33E53A3E7A
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 16:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D7E1E5714;
	Fri, 31 Jan 2025 16:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hCQki0gE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4052E1E47A6
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 16:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738340667; cv=none; b=bPX4ESwq8f/xnVns5gfM3vjOeXrEp6dhQMFVZuq6R/rANbP7OWTDFZHMTfVdkMTVRO7sp6z5Q3qPN7NWb7sVE75WAwsI9MUdPD48+zkLfhsxyxTAGmNiqHABE8rbgccxtcUZSs+9+us9VyhyXFGAg98Bh1WnoOGcvkOi9Z88Mcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738340667; c=relaxed/simple;
	bh=Q4n0BlU9xiYRE363wEGsujhBUpR2oikIqQOdkwZ1r9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHgGK+zUB617rv1FINVUUP463IKfUtcx4Z0MEjK5O12evU+Q8/rU7r1wYTkpaOjN6RhMz6U5MPURKy3Gdoya/OCKrXiPBn6XqE4yPly/bHOaF+z0+0yLfgrUDu3dgULrEixGco8GqrTAf/ixTS4TUQ5RyVOOcOVdcYa8dQoWuhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hCQki0gE; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d4e2aa7ea9so4579798a12.2
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 08:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738340664; x=1738945464; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HsiGWZn6vGNty14t/0TTWAT1Hkfe2j70nTerz+KVhvE=;
        b=hCQki0gEfSH/NKXGtX2OWgQuhZKHZK/5qD954jun7quSPA0FYhJQDBv3m5C5NrKgBS
         VdppfME1M+2dY/krGqKorJNbkDMXtk8v5YMoX218Zg3TudMyV1YXqei1UjYa/EgOMM6e
         HElQDOhGKJ7j3otNoTMZUxLPBOOrHjbQ/koybQyWJVpbjEPI6sWj8llnILy1Vf3G9+r4
         Bdpqt89N8PsPwsXxg7qORNYH5o5dT9loZqWEivEtP4TXhTLh/jw+JeajC7MTNg/IR8CS
         1Du0XcV6/vVFYadjJ3xiEczQa+POk6eeCWrlqR112cpILIui66kAfI17lOLUD87LeQVV
         CGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738340664; x=1738945464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HsiGWZn6vGNty14t/0TTWAT1Hkfe2j70nTerz+KVhvE=;
        b=jfHMbrR8974EQQ2ElLQ2l8SZ+EnzpVcqSYKYxJiauBoGMcjaVjfXqTmg4uBtet/lki
         Cl7Tr7UP0JDqs6MxJvN/b48YwOdRBCi6NaQoXc/bXidmdKJ0kfNZcnQ+XsdLtk6L0tDK
         2R45KBm3AEit4jGFETc70vTwxz4GNWSRJFTC45OcrvGZkw8JHoAjNMTb8epAOzHQCqdv
         mXsw+Jx3tRRqMZQVMdieLrOEL9PW2odmu7xlSAHCrxxgrNLFwkymHc9TKE9oVfg6gHW4
         cijSyhwpznhP1IKOEWqPyfGhQj/CiurJrdzIS5wD0fg8+cgJzlJK4flphhlbrsOaY9El
         JqdA==
X-Gm-Message-State: AOJu0YxDSdfHoaO5JD59r370Z3VwsyOkMO1lhAzaugiKdxX9dVt+KeA8
	2XWbSLq8IfxB85OlDNlrFp/tzDa6DSywARfSThEZAYq/9iXCg3NO0ey6kw==
X-Gm-Gg: ASbGnctjUIS4ezd4aYpvKj2j+1pZv4f+SpFOC2iQsUIcyxp1KnQsgcTQj4S+pLexTRF
	ncLBk/CZlOlCaXsYetcF2AOIQJOm5PFPnuYOuAvLiJ/Chl1gdylKbK/t6vkyDT4GPLTmhIuXx4P
	GKt13fM71eb7N3LLTWfiXHhCHBSTS8kKY64kZhfx+cHLQqvFQCZF+Cdk4rLNXKcjgM2DvvQVCSV
	fk6YIPf3amj1sdvlwKI8EH9ThX1SltSPdMvPvYpIJx9KeG079gl/J/EYSglaVBe017HsoVRdPw=
X-Google-Smtp-Source: AGHT+IEKlKEivl1r1d5w+zgkHEQhkBEpSf8qTddQGk3VmvK7iSeZIgxtxq9vyuZc07BEsQgrgNFwfw==
X-Received: by 2002:a17:906:da82:b0:ab6:f4e0:320a with SMTP id a640c23a62f3a-ab6f4e04bddmr441891066b.21.1738340663922;
        Fri, 31 Jan 2025 08:24:23 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7071])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a56587sm323292266b.175.2025.01.31.08.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 08:24:22 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/3] io_uring: propagate io_buffer creation errors
Date: Fri, 31 Jan 2025 16:24:22 +0000
Message-ID: <139e48488d160a13e81b170fe0499c4b756d527b.1738339723.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1738339723.git.asml.silence@gmail.com>
References: <cover.1738339723.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's very unlikely, but in theory cache creation can fail during
initcall, so don't forget to return errors back if something goes wrong.

Fixes: b3a4dbc89d402 ("io_uring/kbuf: Use slab for struct io_buffer objects")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9335144495299..b05580c1a6424 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3921,6 +3921,8 @@ static int __init io_uring_init(void)
 
 	io_buf_cachep = KMEM_CACHE(io_buffer,
 					  SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
+	if (!io_buf_cachep)
+		return -ENOMEM;
 
 	iou_wq = alloc_workqueue("iou_exit", WQ_UNBOUND, 64);
 
-- 
2.47.1



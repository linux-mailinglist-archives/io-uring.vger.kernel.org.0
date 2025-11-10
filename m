Return-Path: <io-uring+bounces-10499-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97BA9C46C32
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 14:05:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 752323BB2DA
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 13:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCBA81A704B;
	Mon, 10 Nov 2025 13:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VKXZqWer"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E2D2D373F
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 13:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762779904; cv=none; b=u/YtwEKbvLqgRk2/+NY4+TGVD5i6P5mFlJXzlkArBIGNHuLYZOZtfJQ8vy+THJlDNYtA+eI5ZkuACr7g122rR8rCE/QJgth0d2jqxnHTAJanfjA9ZVE0/rQ9sKEJdRSiMxJM21b13Aj/uPJ4Y1+OOONrPPSRatg5Cm+SlFpXOYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762779904; c=relaxed/simple;
	bh=kwEMnR94NMkM+f8OHcXHJnFIrVoi6qbtQ1zLgwdL7DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udbluKBrqHqN7WOFlYHSCDK97qvwT/D1ZIXQgGZmEzxVM1426hece2sqnVIr4By4JYlsb+ddL3U3uHzk6Lkqr9qcqs4nc3f8gNKfxrKlbCEINHYzkZDeuPZn4FX9L9/e5g0yRP/ZwZ6mBqbWipBWsgnT36aFKl1qqehGr5+XV9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VKXZqWer; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42b3b0d76fcso550529f8f.3
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 05:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762779901; x=1763384701; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HHY5C9oNMocp5qpKH3Mqaeh72lxqYBuYU4tuWipg2TY=;
        b=VKXZqWerQCWipSgm5nCSl1cw4E1Ien89rdoJJLMHDjXuN8qmweMptjs1Ex1LUWPbJ5
         xBf3BoEZoDiJ2zmgrrE41J8TjbLq9ABA40T4FEHPPTW/P3ZK/eVpoQZXCsLbYrBv+z+M
         U7ohbgskB0lIX4ILQ82OX1wNDX5pp2YruH1NfJEKWiGZ91gqnlwQF3REjegz7bsqLcan
         HA5bFdzm8p8n4uBI8F6kaUFOY69JYTFmxDbnDnV9HGvU87jbJvmA5H+9DD0soQWMGRcr
         DWvJsqV7pzoZ5VqfPtAcH8GUG7fgDLCfIflWBawwcAH3Ot+FLLorLC26zbFDRUtnkt6m
         ADQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762779901; x=1763384701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HHY5C9oNMocp5qpKH3Mqaeh72lxqYBuYU4tuWipg2TY=;
        b=xImVkjQXg2+YCufaeawUQ/PpAesUya4NuXIluL+ZeB2Riu9hFl89jTgw2KOFjJb9+4
         hV56pKxY39KVW92jsMbaPwcsdDgzrHYNw+8lpjA82lmDmFP2XLkWeBSimnZ+8h9URt7J
         BjDcnL5jv5hNhUUy50Ai3UdFPJirNnapbZ0pRpj3VwV+v63swRz+3RhiI4YHyF5oR7TO
         j1JwiMrhWhC9gIDZXOELuh4DYdYyTO5UERqirAt7412ScTbqQKbT++fJchQ/yyTBFy97
         /wlxJGiduqyGHSVXTN/yMwHhkQmO1HNrWo2JhMRbVlbaWzlIoY4kZqGi+yiBrJEMABFm
         3F8Q==
X-Gm-Message-State: AOJu0YxgJHF08Q1I/1VkekjpyWacY0XkjUBP4+K5Ctekg3o+1CluAVwI
	qq8lAcDqRQvvceMchshKUM7NlQVdmdQF+RRc5ABNXviKoalPl3lAgVUvSK6zLQ==
X-Gm-Gg: ASbGncsaYR7aunBLjb/YYcS49T9qTp9dFk0z+HMosqOKJQFBwdx3NiHvb2C/sgNyT7t
	6BH7zXy3N9QNRzYTTDl8RFXED0Lwq1hZc2DWD2Weho9yGaxh7QSWaD+K0vlhW0s/L8BebsZVbgR
	V2Al86QjbPHxoDll425mvSRtDeIu5E3b3K0L16esK38QJ0jYMaLDJS/ZUhM7EGK8j2xBB9Wp9yF
	Btl4CyfC/3Lu270sL2AOTerD5/6zQH6NVzDRNk1faM2H5h9n2zCoCsU0Ocsik/YnBwi7J45Arib
	xoOhAvKi0XWYR+K9rM77uKeIcvKXX/iSHZnA6v53XyO2yCtS0szT5963tTl8aEtzSG1Mq0ErF3b
	kmsfqk2GeyhpfoZUMz6J5ebAjRN+Iy5ZvmSaDwx1ClXH3CS0KruZvqXcbb1JoeDldu6r6cS4UFY
	bFFySF/gr7EG9H5v7daxEJtW/H
X-Google-Smtp-Source: AGHT+IHsMCQ4dDAh9bg7V6vwfQ8FkimmpFPngALhtrCddxoHQTOgfyHmM8NJrzzQgZ9XiyiTw0hkYQ==
X-Received: by 2002:a05:6000:2608:b0:42b:30f9:7998 with SMTP id ffacd0b85a97d-42b30f97b53mr6577957f8f.27.1762779900750;
        Mon, 10 Nov 2025 05:05:00 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b330f6899sm10584648f8f.21.2025.11.10.05.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 05:05:00 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 4/4] io_uring: move flags check to io_uring_sanitise_params
Date: Mon, 10 Nov 2025 13:04:52 +0000
Message-ID: <90d1f84d28afbf5bc619bbc82a5b7fa811212d89.1762701490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762701490.git.asml.silence@gmail.com>
References: <cover.1762701490.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_sanitise_params() sanitises most of the setup flags invariants,
move the IORING_SETUP_FLAGS check from io_uring_setup() into it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index af7b4cbe9850..7e069d56b8a1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3430,6 +3430,9 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 {
 	unsigned flags = p->flags;
 
+	if (flags & ~IORING_SETUP_FLAGS)
+		return -EINVAL;
+
 	/* There is no way to mmap rings without a real fd */
 	if ((flags & IORING_SETUP_REGISTERED_FD_ONLY) &&
 	    !(flags & IORING_SETUP_NO_MMAP))
@@ -3691,8 +3694,6 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (!mem_is_zero(&p.resv, sizeof(p.resv)))
 		return -EINVAL;
 
-	if (p.flags & ~IORING_SETUP_FLAGS)
-		return -EINVAL;
 	p.sq_entries = entries;
 	return io_uring_create(&p, params);
 }
-- 
2.49.0



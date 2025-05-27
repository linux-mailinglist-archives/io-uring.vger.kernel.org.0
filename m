Return-Path: <io-uring+bounces-8119-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9204DAC550A
	for <lists+io-uring@lfdr.de>; Tue, 27 May 2025 19:06:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 338C27A3F1E
	for <lists+io-uring@lfdr.de>; Tue, 27 May 2025 17:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D8C626868E;
	Tue, 27 May 2025 17:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cy+q1uxg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F8C2110E
	for <io-uring@vger.kernel.org>; Tue, 27 May 2025 17:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365594; cv=none; b=kueI6Xgs6PUxLMoxZG2UDYQfGLIOZl5EkSH5bpvz1PC0clqNGTgsp9I96hMutQTW/q8pzjSKJHzOt/GFfUM13IsqS3Eb54ksltq8OzkIFH/ULTASirO9QKB2O3+bO0XskNzW5fXFPV0UUC2S2ZU18MAA2ufp9WmPE0jltP0vhDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365594; c=relaxed/simple;
	bh=5Nz4Zm7belKEefZyKocszZrGuEIVhhQPby1AqhmBytk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sp+n9TIQgL+PcoNpcFW2adHiNKQAtpRGQ2+wZ6z5y/mSj3H1h2L/yNVkO6gpWOiiiOzTQ40J4vr++8CdNgiwgtEKAGMJLZYG5tC7Xk9831BQfsq4c7W+0T2IQMWgUxhigdpjCfa6yaOz+47hqFFN2aYU7znm0lC+W+gGbujKPpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cy+q1uxg; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac3eb3fdd2eso640530166b.0
        for <io-uring@vger.kernel.org>; Tue, 27 May 2025 10:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748365590; x=1748970390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7TuG7/bWEB2zccMGRAOYD+EfaugfyRMAqGHiZlE5mAk=;
        b=Cy+q1uxgLU1rTlZYrOGkjuXQSOItxo3bPslcmxBpWQN0pANX4ECJsMmVZJcKmQf6Vd
         VD9qrfT9k6q4ZDjP9h30adUd97tRfymZzLUkMhKn2UhRQ3KxAe1aj6BznuP4BwzsZ57H
         Wy7F5Dd/1esK1p3s6PiU4x10XhV+R3vLxQS9uU9DQQhJI3EfUYQy5sSubwvyZTmzQitG
         oPtvb67k6/VM1+aW7rw4TfQp08Dt8ZBQT+iP58SyoBugt+la5RHXSeSihiq9sp4OWmsQ
         0amuLj/2AyIU5Uxe56zq4LREVYoANDzpMZADcwPHZ4qAMasmHiYP9t99Fjcl4LYfzNt3
         1CHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748365590; x=1748970390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7TuG7/bWEB2zccMGRAOYD+EfaugfyRMAqGHiZlE5mAk=;
        b=wxYNyab+2YozPhisGkAovQo42l9bXCebcmjfn+VUuOup3MOTnM+iVpKJFIOy5OySjB
         D3VA6iNr+Z0T2hJOt/h71OLxpQo0Ra+sK60O9WUXMUTGJ3/hT8xEaWbbsFbASlteYLrN
         GmLOyYkOrqWgxogzKLfFqYur5awuT5DAA1tTUBq5SpLSNKM0WDwvwoSvClxlaV43FKvV
         8tvbcWTqQThxXh48e/uvAeZNEsdRfpxtmMtpgZ/WIt5l1ETLGeDJ6abZOS2WUtKrfrNN
         rquXju5ntVFMwTbOIDmxxv0rrUKV4H4bTjBgPaUKogegvtH4k4btSCojzh8+4zdtS/N0
         HoeQ==
X-Gm-Message-State: AOJu0YzrpF5pY9b+WV4bDMN6UOwBU6zb9HcQ2tA15Tkt3sQbtbhvdRDm
	bNH7ejQe35QlGEtibjjrzit134VYrrDuEp3XNle2GxlzUkzU2xqxlMAEF3K0mg==
X-Gm-Gg: ASbGncvds+EjiNeP3MNPRqJ4aVepgX9OXK/Q+AtIiAXhp3LaSbUaF6o0xB9tz+xKihw
	udVH/w35RGlP8T2Cld6vBc7REa9UBhYT8S2PdCYD772eWUYReybKldeByCPNRoArd5E1F3S7bvi
	alJFFe9uHL3V7gsMxKKF6g+zwtKyMsPIDn1krjSkWAQnlg5IhZv93UE8/kuzdLTa5xC+vX6UP0a
	beK4LJgm0C7yVUklIYvWuiSYmfZFy+OBX6dNxc94eWqilX+9j7kIcQKIhBpPVYnGrnZkG5hcI1Z
	aAA6py0j39WOuP6XGo8i32fx8AV2XeXZRfY=
X-Google-Smtp-Source: AGHT+IEjfXcGos8ZHzQBXpjbV2Ce2FVgLgM57/XHfvq65fNJs8N9skqbLv1gPYTSDIEtLkzZzrIOng==
X-Received: by 2002:a17:907:2daa:b0:ad8:9909:20a3 with SMTP id a640c23a62f3a-ad89909232bmr135540066b.43.1748365590116;
        Tue, 27 May 2025 10:06:30 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b3f0])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad88b1195e6sm159492666b.120.2025.05.27.10.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 10:06:29 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/zcrx: fix area release on registration failure
Date: Tue, 27 May 2025 18:07:33 +0100
Message-ID: <bc02878678a5fec28bc77d33355cdba735418484.1748365640.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On area registration failure there might be no ifq set and it's not safe
to access area->ifq in the release path without checking it first.

Cc: stable@vger.kernel.org
Fixes: f12ecf5e1c5ec ("io_uring/zcrx: fix late dma unmap for a dead dev")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index b037add86793..543796da5686 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -374,7 +374,8 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 
 static void io_zcrx_free_area(struct io_zcrx_area *area)
 {
-	io_zcrx_unmap_area(area->ifq, area);
+	if (area->ifq)
+		io_zcrx_unmap_area(area->ifq, area);
 	io_release_area_mem(&area->mem);
 
 	kvfree(area->freelist);
-- 
2.49.0



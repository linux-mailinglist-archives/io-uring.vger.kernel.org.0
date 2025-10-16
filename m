Return-Path: <io-uring+bounces-10026-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA5B8BE3088
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 13:19:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D55B424D08
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 11:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DCA314A99;
	Thu, 16 Oct 2025 11:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MdSgSSHT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C9831328A
	for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 11:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760613559; cv=none; b=reC/5dr8vTe3mJDSRgRfgDUTestcuV9iSObz0yt5+E/AXCOl6s4qT3N10rEbXvVGST32FLO55JyUVIK9rq93/jSGTYsVsOXDVW/rT0Da23s0c+6iS41UF2N1l4CjmpAxIXUvWEXkkrSgDhXawoHy0xJtEQ8Ud8dGen+VibIHbxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760613559; c=relaxed/simple;
	bh=VSrrxcijCeSqbnGlDlpGBPLkG0wRgOIhxT/UJUyi+Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W24HsGB+AtzoJOPNM7TBOnyKMoXqaWFw9oqw9aGBUEkewisAod1Yvl7hJpFs16NhXMDyHZ+Igp82Sstr4WnUVYbmLgR6OinNBYgHEBB8oJu7aTUvgxImpY7hlx0n3yGngcEpEpWxy3daJRIyoz2jDYiUtSMUNEasMLM1Sli5vgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MdSgSSHT; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42701f2ad61so220570f8f.1
        for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 04:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760613556; x=1761218356; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HNvP8pWg0nn3EDWlDWylpzXaJvYrEB3orjmF9fGUVaw=;
        b=MdSgSSHTvF1zeW3R/13QI+6+dDOy9UtQv5tIoqt1NDoTRAhX03NQfRwE3WehW0loQL
         +gEY3hnyFln4i13tRZTTdMeuIQz2CjbNplrg+0lov8EKSEc/HIrMcGcXgsSukzToJ77G
         3TBnqZknZ2TuYOx2KgKYIzgbUrmm/O+C2IDdgF5ntfb2qaToQg1napaVFtiLiJsIRRU5
         /suahhJQsoNoIJgUZHKM5toBvfRFvt9OSW8NOM9sCJJyb4rgoT7NiwzHawrHu4v60dYE
         s4iqv1Fd9pV3hclgIkAy64Ll+bj0QMf5tMyUdBcMMG8kFhEElXXGBbg6JnwZoukDJIfx
         WzYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760613556; x=1761218356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HNvP8pWg0nn3EDWlDWylpzXaJvYrEB3orjmF9fGUVaw=;
        b=jZ1y8Y5DEZKhSp4tzTRTilv8WoynUrW/Cjq8YtCqWUZ3wiru/s4cJ0Mtu/gjPzNCsQ
         jXDf7JIdcYL0s4xYdVoQRkxI5UYlnSlHy0X1LWRknkrZNkdZxD06qkS4fkzl1K0QKwIl
         KuB29WJsDnPxCWJ8Jr9x82mxSPEy6coHxD46pGvQIpC1EhFbpxSUexpHnhn5F209dqVl
         8fYvpH6WEV+oJeCY8S7ybDc/CBWRcRwLakZZY0pP4YtzXxudQvJh+l2Gsw2jyovqcQDK
         u+2sZRZ59Yb1EjLEQhDTAgfuhijgKobbvxsxiI4xcCMXBjtLzMSp6LhgV3HmvzaS+RaK
         iU8g==
X-Gm-Message-State: AOJu0YyTY+NBq/YtAPRH8H/2p4cqbQvQdFCw4yRcQYCapR06BDOIC7a0
	TWXiymOPb5uq8azciQ0YpzstrEb7nV52OaE3DgVEksT7YThrtc4PpMeeVRBr0g==
X-Gm-Gg: ASbGncu7f+UAp3+1fbB07Pee8hWgJKybo9oDLzHWu1srueWI4UlNE9h5UUzS1AP6/LV
	/SN5xAwRgf7oQHrnp3Iuof4tH1ck56fU2eg2lmk8Y62lpXUCbShG2AFg6B9kBKCSZONYg0fVovy
	QMNbsP7Clq2I3SHncEnr11MwisQ22xCa+dy8OBwPcgmViYRWOkO5evom050Z7T/SSUIq3JGRQo8
	aVVH+bZS0w1jUFEjc26W5ksUVeqBJYj+wS+GTYtgbFWk/8LIFF46CqHgWn5nCllCQO4PXwbKVED
	fFwVZxMhASJeQz4PUG3PBGzfVPc/gRjej0hOkiBBAbUzgICMl5eu5TZn8ju1e0p8Xs34A8fTU+I
	FYHgneZQOJVk0r5y2ObajqTmVNGyfahVd0wMYMG35dyPdwpTFIawKycoEUYA=
X-Google-Smtp-Source: AGHT+IFvAmSjEnkt+8QbN5TOszF+ZVpg/GGzvbvSMDU244RuGFz0Kindy54Vn3Li0r8rjlVJE1npag==
X-Received: by 2002:a5d:5f54:0:b0:3ee:1586:6c73 with SMTP id ffacd0b85a97d-42667177de1mr21388219f8f.19.1760613555436;
        Thu, 16 Oct 2025 04:19:15 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2b54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5833dcsm33828142f8f.19.2025.10.16.04.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 04:19:14 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2] io_uring: check for user passing 0 nr_submit
Date: Thu, 16 Oct 2025 12:20:31 +0100
Message-ID: <9f43c61b36bc5976e7629663b4558ce439bccc64.1760609826.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_submit_sqes() shouldn't be stepping into its main loop when there is
nothing to submit, i.e. nr=0. Fix 0 submission queue entries checks,
which should follow after all user input truncations.

Cc: stable@vger.kernel.org
Fixes: 6962980947e2b ("io_uring: restructure submit sqes to_submit checks")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: split out of the series with extra tags, no functional changes

 io_uring/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 820ef0527666..ee04ab9bf968 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2422,10 +2422,11 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	unsigned int left;
 	int ret;
 
+	entries = min(nr, entries);
 	if (unlikely(!entries))
 		return 0;
-	/* make sure SQ entry isn't read before tail */
-	ret = left = min(nr, entries);
+
+	ret = left = entries;
 	io_get_task_refs(left);
 	io_submit_state_start(&ctx->submit_state, left);
 
-- 
2.49.0



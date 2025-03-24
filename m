Return-Path: <io-uring+bounces-7217-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47442A6DEB8
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 16:32:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5E39166BBB
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 15:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADFB25D549;
	Mon, 24 Mar 2025 15:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YcNIfP8l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3847625C6FE
	for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 15:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742830313; cv=none; b=JQjb1b4nOp8uhnK91QLvwHtthuPEDxT1UhbgcHY2UuwZTDzixzrNRPD/tC0/Zc5PE03oAxFmpkwB3WpdfgxMjW0oIW5EI/TUfEYEkn1ajMRcAisZ0MndTUdj1WtypZkxJ2uiw4pHkvU4ItD9j2evHP+AsDW7ALL2Hctk0bghXII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742830313; c=relaxed/simple;
	bh=LsNI0USPFAuncr34BymGpfjkoyWC1xArSlzymftA65M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBud+QNAr6t/dKBz1lSAhTzSKbCSt6qZ/UNswL4n+QqEqGnjkrrvD0NNOxXjZFt/tS2BiIGb/QOEr5wBgRNR9p9qKe2MUH8rZEVpUN93UOyxqfCQ8eeu5Oec1Lv9S4A8NwVda9yvsGUgLzICtzoTj5Az+30DJP4Lw6Er7GhS3S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YcNIfP8l; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac2bfcd2a70so656639766b.0
        for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 08:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742830310; x=1743435110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1cO+EhHA16OqsY3ygqU32w92G4Ed7DE5nfg4/W+b7wk=;
        b=YcNIfP8lgTyaNGNNiphzhRUYIhdgMAmoJQF7XwLsT8Lu7LXWLjK5NmnQlxb59GRt6b
         pRJp15I2hdJ5bPkD0EPvji/zafMpNBeOIwSjnsKm6PVrt0UDZkZ0gCluvXPugBVEcUHU
         n4f8X40hK71WR10Xaucg5Phkk/3jtNKPTCBIJa7mYUQuRYv9ghXsRKjnRGvr+0VXERJw
         gGFZnOGFJFAEbUY/A9rIJ4rqWJG1bpyzzHQxrOz9LqFOgW/UxIInTW5rq6r6WlS8DGdt
         ZgDKN9OhPRdyRp1Qg4gyk7NNHSkH4MA83ivYn+KeuxCoT9IWxb+pZPXPYVEXEcHLLpQi
         XsAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742830310; x=1743435110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1cO+EhHA16OqsY3ygqU32w92G4Ed7DE5nfg4/W+b7wk=;
        b=mPlbXrZA3qEWeT0G08lS/spEMWUCsYpeezLuOVlTT1FiyZOlU+LrnzmOK9GRpWqg+d
         6M3Oy5GqwBT/0K+jgc+r+KAIA0PGAW0LBCMzVW5dqIbqNvq4wWp005y7Y2MRb98M8CJo
         UUq8410HIe0QIwYGScH3ecSrgNa848AMqpvPrgQY0/PnqDm2qACjggpiocHwbdYQkKUb
         8NNhUp41U8RPNeSiuh8bzYv4TGlwy9NjEY/nwNK4G/xJM/cEb9wzSWSMbcH0En1lzC10
         MRM/GeFw1+j8++aqr4uEF4AhZLn5sJO7ihG4rJN1Jp3bYK1uzoByVNB2UgVk4MSnZK7t
         5D3g==
X-Gm-Message-State: AOJu0YwHJ/OHff7/srVtWKwp5ck9/Uwciux5fe/plRlkdepO0ecsaayy
	zIq50sifthzRcIf5ymMRIHLMrLoezPrmViBFmTuV990MvmQsnG0lZe8XqQ==
X-Gm-Gg: ASbGnctQdqiPVQ8UePBFZncUfnJuMk4o0HDr5ccAWRQVzXC+j1a1LdRjrlcIdInetad
	ytGBZ661nKXzu59Uowk0bmoEsVYHEXb3uHztZN6FAGMOtNdElOEEoSW96T5lCDCi+EORbj77BZ9
	Pt/qTA3/YNHhKVGfTySdLJOmlIKLjWWmHGJh53VVeqCw9NRAey7E2WWX3CLRZLpYy6SZirCcMzM
	oiJDHD/c2hqLJb81zI4V/ivc+7bfZiZn1DQrMYxyQJ+6lOXvCngleIeUXEgi3ghccNNklptQvzo
	tW9als071whc4RmPPqIpBYbEk+dv
X-Google-Smtp-Source: AGHT+IHm3C0zqRujhejMEL6S6McycUGTNBlwxekSiPPQBzFuZ//k58bRI9im1DBoyYEY7p1ORc1lUg==
X-Received: by 2002:a17:907:d2dc:b0:ac1:e6bd:a568 with SMTP id a640c23a62f3a-ac3f26ae269mr1449763666b.37.1742830309695;
        Mon, 24 Mar 2025 08:31:49 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8aa1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef86e514sm688103866b.35.2025.03.24.08.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 08:31:49 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/5] io_uring: fix retry handling off iowq
Date: Mon, 24 Mar 2025 15:32:32 +0000
Message-ID: <badb3d7e462881e7edbfcc2be6301090b07dbe53.1742829388.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1742829388.git.asml.silence@gmail.com>
References: <cover.1742829388.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_req_complete_post() doesn't handle reissue and if called with a
REQ_F_REISSUE request it might post extra unexpected completions. Fix it
by pushing into flush_completion via task work.

Fixes: d803d123948fe ("io_uring/rw: handle -EAGAIN retry at IO completion time")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e1128b9551aa..e6c462948273 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -904,7 +904,7 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
 	 * the submitter task context, IOPOLL protects with uring_lock.
 	 */
-	if (ctx->lockless_cq) {
+	if (ctx->lockless_cq || (req->flags & REQ_F_REISSUE)) {
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
 		return;
-- 
2.48.1



Return-Path: <io-uring+bounces-6147-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0600A202C4
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 01:55:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F176A3A7412
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 00:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F194125DF;
	Tue, 28 Jan 2025 00:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FEiFgctf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DA1748F
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 00:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738025711; cv=none; b=fW4enlifKBa9D4GcKqAHQjr+i8UJqkg63nKSn8lxM88pkciWUIIFNJN2BgV+Xt+Va7qPDYmjAKw4suyX5yeEF8/ly26+naZeeYxO93/yzYrIlYF346xHYWx1J7Zjj8VYRtGV0EgIDPbih4lsdJ44REKSgYPvJAl2q/MGFxtil4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738025711; c=relaxed/simple;
	bh=yqhGe7ZplJkvX1PFeQJjpRGp46D5RrdO5Pv4spQpLMY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rCKKeON72Mlf05z10Xs+EFnAra2yvKj36fV+Yq+l+GqLHs86ITsHjlhXJF8uW/vx6YtPceewKZXvSsmNN0bVtY30IrMmoRFN/vadzl30Ym83Q9r7J4e1IWACI2cPVRCnqlSR40xgSdnYK4po4R5V1BjZd9RSVr3KNG8lFBegoRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FEiFgctf; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ab39f84cbf1so983395566b.3
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2025 16:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738025707; x=1738630507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h7bb5ucIfNXnxIyzLPLu7G0uwyPGzvUx5WbOXVr2w9c=;
        b=FEiFgctf5ec9LWf0ZyXamm4ESNVoOcyqjQq9k3jrcDTxaf2Si+eT6T4Kawxi/iWhRP
         iOfMCFFS0wJIiXwGgaGP26BO1d2k7Q331vJxo2N2U1vdYAx+9ksMo707LALzcjE8yzCP
         122wYjwFEDKvyAMoGabM1uZ48WzZfgFhP0liMMUzbDaqgqSlF2Sjsdo8qyv8gXQiKwOe
         5tt6ajVzXzYQywUGk/H7QrEQimz3gBrAJAr4qEsOdYcUX18043sR0N20C8XqP02Lmsy7
         5+gaYvqIc5pqoJ+m2pg1AOo6iUJJOPSCbxU6/cxu/BdKUqYVUE0PtMRGG0bV2THErWi+
         N44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738025707; x=1738630507;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h7bb5ucIfNXnxIyzLPLu7G0uwyPGzvUx5WbOXVr2w9c=;
        b=K3g6M7C61tg+L+S1nRavdCmzAQ2jopLpIP6Sd8/NM7SC7MJL5IlxLhiLB75oK6dbJj
         ceTdxtrf8XiXCgmD6uESjMNGgc4C6ice81scTL5YMsrb/8suL4KtAwSk+NYo1J6nzdDP
         XFq0EHI+KNWSeS0pX98nNvEvoipl52SHVFJ4Yjhck8K3w2hUWWycPtr3f54xTOys42cw
         JqxNGpGbPrSy34WtcfGGBlEPbWpzxmcg1YHnVb2wdLVNV7m1UfwXp4s4UzDerbnTJkgR
         ftEFARLezeoLjbYkQPTFAZXOlIHMPl7/EKGKKdGfwSgRrR5e5/dSiY+hW8hTlvG1xBBq
         DN1w==
X-Gm-Message-State: AOJu0Yz6lDBC8sT+Qqzx8QgR/s6g0NQ9SPKAnwZh8+Y7a4a4JgHBwNqS
	ZzAv2R9NbMHckLDNF4RxUtXQMCh0PT3pW7ZKw/Pprq4his7o4NKgqyopRw==
X-Gm-Gg: ASbGncsbEKHdVeprN9HQRndNbXd7S/WvVI4zPEcAUwZXJVm7UdXkw4zEPqv9NiJUG55
	ZYk1rAE9nAsEtLHoRKzGPs5qra+clstrLaXbyU9/TL1mMwC+DXjxRpRr/TT9yKLAMt4IUfVAzzq
	QBS3oA5iajYHfo0531XtGDRqZYt7LpQSQNDUGukjYz2sj7lSnEVENdkoscSrZFyR9gLLn6OIWmo
	4+DtgEyK1MVgkHjJ2/5GcIKxKii0opJ8yLREXqk99JYlZUbk3f80EvkrBw2Pka4A5CFL0BmLCZt
	z4R0ZP8Sit36BnzJGg==
X-Google-Smtp-Source: AGHT+IHWZcd6tbFOQJ6ag0mB8PiGY6sr9IuPGC9FssORls7MKsbmH0F1ZdC4cWlpnEtmf/Y4VbuJ7A==
X-Received: by 2002:a17:907:989:b0:aa6:a844:8791 with SMTP id a640c23a62f3a-ab38b378d8fmr4104021766b.45.1738025706789;
        Mon, 27 Jan 2025 16:55:06 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.145.92])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6a00be2b7sm319777066b.19.2025.01.27.16.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 16:55:06 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Muhammad Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Jacob Soo <jacob.soo@starlabs.sg>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/1] io_uring: fix multishots with selected buffers
Date: Tue, 28 Jan 2025 00:55:24 +0000
Message-ID: <1bfc9990fe435f1fc6152ca9efeba5eb3e68339c.1738025570.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We do io_kbuf_recycle() when arming a poll but every iteration of a
multishot can grab more buffers, which is why we need to flush the kbuf
ring state before continuing with waiting.

Cc: stable@vger.kernel.org
Fixes: b3fdea6ecb55c ("io_uring: multishot recv")
Reported-by: Muhammad Ramdhan <ramdhan@starlabs.sg>
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Reported-by: Jacob Soo <jacob.soo@starlabs.sg>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index cc01c40b43d31..f12a857bb8555 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -315,8 +315,10 @@ void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts)
 
 	ret = io_poll_check_events(req, ts);
 	if (ret == IOU_POLL_NO_ACTION) {
+		io_kbuf_recycle(req, 0);
 		return;
 	} else if (ret == IOU_POLL_REQUEUE) {
+		io_kbuf_recycle(req, 0);
 		__io_poll_execute(req, 0);
 		return;
 	}
-- 
2.47.1



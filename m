Return-Path: <io-uring+bounces-233-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA340805882
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 16:24:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DA381F217E3
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 15:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D728468EA4;
	Tue,  5 Dec 2023 15:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hCALABCn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C34310FD
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 07:24:06 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2c9fbb846b7so30535021fa.2
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 07:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701789844; x=1702394644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=znkkF+su/afd2Tr2p7STGGP/AsviaGZ8tXbxC7ntFQQ=;
        b=hCALABCnl83FhcjqFvzcJPWcEMJXr07LRURMFq3NByD8NPpinwYajyMDC0Ah2mhzNR
         NboLXzu0iyeOvRDIMaiC6zlUVO+PQN3HLpLN9qWuRwyZ7feihbZLV9UeAwe/LfeS/Hsw
         FNJpzfqqC88WQvVvuonklumOXM7uQ8ITEbHhV+7PIhlMGONoWa+7jsykDL5bJD/WCjdU
         OFgC4+lbVXVhIWiNwPItRj+QIWxs01Pb3CF71n3i7V+bmoiVzdqjgExP1Xji68PPhg+I
         Qq+VzfMVSb+rzZG2VAYLTZLiMid614dfg7VBO5z4dn1u2p4tNPC5BZ1Wk10Oc5dIZ+gM
         zQHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701789844; x=1702394644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=znkkF+su/afd2Tr2p7STGGP/AsviaGZ8tXbxC7ntFQQ=;
        b=mjkUAmFmJpDoMGJT5LlLj3kg0KhmPd14kNVUjIooO2EZkyhwgOKXg88RdMbAseKbPg
         PuqpsLpuCayrQeHPF3gnF0HgKruNNmrR8ZHaKYwIhJVZOy6j8A+ZNwV+VMgji+GRfrjW
         tg43dDX+LpDhIT7WEcPD2nm4g3AygSu4FsszFSiy9jLC2uETj1DYJvMsyK3bC6Apn1Dg
         NQfJHgd42UBYUHUzu3kHD2cia0Yk3NUVNRcTJt+iUHlq6DliJkz34wxfqoVKKNoDjdtc
         UZeFKYdnSEzSar1rZ1JaZiG2BN1CJfUgq4yJAprZfgD911A9Ian4VnvIsdWYe2jARa0V
         qDZQ==
X-Gm-Message-State: AOJu0YyXSfZA5iaAX6P+cC1dp66F4/UCflMid27zdS1e4yaO4Js2C1s5
	Atav2wmwj8K35rddKljVqEYESpARnxM=
X-Google-Smtp-Source: AGHT+IFlpRpn089H98dV9NwM34Q5Ev+v94RNwhj0dfp/1DKUHGb7pGTQYqI4UPWRvfFdyNNr0fmoBQ==
X-Received: by 2002:a2e:82c3:0:b0:2c9:f79d:1998 with SMTP id n3-20020a2e82c3000000b002c9f79d1998mr1993481ljh.93.1701789843771;
        Tue, 05 Dec 2023 07:24:03 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:ebcf])
        by smtp.gmail.com with ESMTPSA id s24-20020aa7d798000000b0054c9211021csm1221591edq.69.2023.12.05.07.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 07:24:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 1/5] tests: comment on io_uring zc and SO_ZEROCOPY
Date: Tue,  5 Dec 2023 15:22:20 +0000
Message-ID: <84f20fd3b1b0f6bd43b7388f7e442205bf9502f6.1701789563.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1701789563.git.asml.silence@gmail.com>
References: <cover.1701789563.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Application writes can be using send-zerocopy.c as an example of
io_uring zc enablement. However, it's a test, and we're testing all
weird corner cases. One of them is setting SO_ZEROCOPY for io_uring
zc, which is not needed, and applications should not do it. Add a
comment in an attempt to limit misunderstanding.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 9828ac6..1b6dd77 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -278,6 +278,10 @@ static int create_socketpair_ip(struct sockaddr_storage *addr,
 #ifdef SO_ZEROCOPY
 		int val = 1;
 
+		/*
+		 * NOTE: apps must not set SO_ZEROCOPY when using io_uring zc.
+		 * It's only here to test interactions with MSG_ZEROCOPY.
+		 */
 		if (setsockopt(*sock_client, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val))) {
 			perror("setsockopt zc");
 			return 1;
-- 
2.43.0



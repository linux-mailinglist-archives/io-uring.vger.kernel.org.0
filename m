Return-Path: <io-uring+bounces-235-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBABA805884
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 16:24:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8602A281E14
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 15:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 638BC68E98;
	Tue,  5 Dec 2023 15:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GzL3XbJs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED6210F6
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 07:24:07 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-54d0ae6cf20so1332767a12.0
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 07:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701789845; x=1702394645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YblFeZL8BaJUbavfZ9HG7Ur3HsYlTKtnN8xzvgYa01U=;
        b=GzL3XbJsTljcWTTrgAzLxkd4X/qCys+l+XkYOYjBQiGEyo4lqbOtvMUdgCm3X37UIJ
         WIXsf50HCd3m2gGJpPsoAOq7aw9LNNbeGG4iEs4qm1eSePdRtvifRv504Y/RBZm2rLT4
         8r/ScSi4WyZj3KjWSckY/N4dM80eWXuRagzIj+YpSU5NldtdedjFS1Ez0fYBfV0NXHS3
         DWh8yvsYTicBspmk8x7KkB3CRKQoNGy4/7t2rwft0WLbBFyfcox7zo2laG+DVVdWiUHe
         COyzR4Hbv7m8ttQMJzOhBY27seLbWXM2giZYxM7Ta436Rb7I0+9t8CcOdsoZRTA2Iu6n
         +rEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701789845; x=1702394645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YblFeZL8BaJUbavfZ9HG7Ur3HsYlTKtnN8xzvgYa01U=;
        b=H8Q1Js5yn5tBx5F0JfnikudPPZvmwlyGn6v7c03fz22Zc4gYatLlmtcQjbvOjsZOLG
         cuVejzaPkozy1KfSKMHnlRZVfJdKzlLtKzOm4vC85VORzLb8lUHS2u+bGxxIy//Fb3en
         6nDsv24Ie55uPF1IC+bhZ7YM1IUWreiFbVLjMsetAScfMh/HoyYg5b8dLtnnS/uRUTxB
         C308EyrMjcfcmZyXtE1c8KQ7r2DcYm2crdhVfRpNYlc2ZFg6cSGo5R+/Q5yrqiCiLKBQ
         bZq7srXILDLbaz/T1GTmuAdHb/nYWbGm1ioZHt1dztZs/a4G6uyI502bqA9G02edKYY7
         ii9Q==
X-Gm-Message-State: AOJu0YwCsYN0dlf4HdSoImjvgHvCbwMMsYsAG+MDZ/pLTzVkMdTIpdXr
	Z46F1jySKqtf1BSOdPvkLf/HRMtlyPk=
X-Google-Smtp-Source: AGHT+IGrokBjR+N5ErTVcO4R3x5IXIMqVQf1fwTrZ+UXR1FDGY+QX12HUXL1nSZCgQwqRWiCYap4TQ==
X-Received: by 2002:a50:8e4f:0:b0:548:4785:e4f9 with SMTP id 15-20020a508e4f000000b005484785e4f9mr4585482edx.39.1701789845318;
        Tue, 05 Dec 2023 07:24:05 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:ebcf])
        by smtp.gmail.com with ESMTPSA id s24-20020aa7d798000000b0054c9211021csm1221591edq.69.2023.12.05.07.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 07:24:04 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 3/5] examples/sendzc: use stdout for stats
Date: Tue,  5 Dec 2023 15:22:22 +0000
Message-ID: <4401869d414e2d503a8a16e3c3791f5ef86b375d.1701789563.git.asml.silence@gmail.com>
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

stderr is not the right place to print a valid result of the program, use
stdout.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index 19cf961..9725d0b 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -596,9 +596,9 @@ int main(int argc, char **argv)
 	tsum = tsum / cfg_nr_threads;
 
 	if (!tsum) {
-		fprintf(stderr, "The run is too short, can't gather stats\n");
+		printf("The run is too short, can't gather stats\n");
 	} else {
-		fprintf(stderr, "packets=%llu (MB=%llu), rps=%llu (MB/s=%llu)\n",
+		printf("packets=%llu (MB=%llu), rps=%llu (MB/s=%llu)\n",
 			packets, bytes >> 20,
 			packets * 1000 / tsum,
 			(bytes >> 20) * 1000 / tsum);
-- 
2.43.0



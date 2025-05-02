Return-Path: <io-uring+bounces-7822-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD71AA77C7
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 18:53:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D55374E447D
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 16:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C00D2571D5;
	Fri,  2 May 2025 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H9EX9j6o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FEA267F46
	for <io-uring@vger.kernel.org>; Fri,  2 May 2025 16:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746204789; cv=none; b=SXXiAmELeNlEZLDfMFR7jqQb8gHAZgQfbb+Oe8HFkII/uL/C0vwMOo5eIO9ohNu/cxeMuPTewMh/wAc2Lb4K5iuJOqu7fmKuAlSU0SkxnHOglisjAGPDezSgyTeEsKtWuB+FQH6A9rsXKYOk5ItIpytIXhIkSa4HbCMzZmwX55A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746204789; c=relaxed/simple;
	bh=NQS92uUnIR/i7+Ls0pG+mFb3i7Mjs9HIi6QLzCb3Kd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TV7bbgCp0i2NEql3uraRo+rMVRSnv4Z2S3fD5Hb8fE521laMMMANB/KpGRg3wOgHvm3A97Ej3FMIXBlAe3ba0KcsKly8Wz/1iK3nAjgIPMMWIglIyWeh6o6ZXQraRiuaaEXIA9GoUJctQdF/AzEinrLOywL4T76St06MA5Qu75U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H9EX9j6o; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43cebe06e9eso12615965e9.3
        for <io-uring@vger.kernel.org>; Fri, 02 May 2025 09:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746204785; x=1746809585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qtVzeB8ezdSemwFCLrrTHepWGa1HuBQc0/8Tg6yYa14=;
        b=H9EX9j6ouS8E8h9xxRAu4cNESUEsOXcFvPqnoixrphYInZU/diYqlzAjbOCVaTT01V
         s8egxI4+dNH7Q8kBGMz7BaGkWmB8kvJvqJwaO97Vx3Q8PAAnSx4/xyDki51iLzeKGbXd
         qTopKFswgsYY65L5uPI0P8SCbDW17jU699ydx7eOAPO6Gj0h51Xg/axKKW1CEu+XlzjO
         cXViJMdoaL0DpYVHQfsTTZAanq8HHpXXgvO4x/lx/LzVoA+2LD5DSyVAK/q28+Z7SFJO
         Kdjn5HOKbO+Y/EcPUCVBRHXe2QY3lDT7bFEpCJysbUkx8I+a5xF4XID3vOMhY/slYguY
         A+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746204785; x=1746809585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qtVzeB8ezdSemwFCLrrTHepWGa1HuBQc0/8Tg6yYa14=;
        b=e/OhaKlZ4qah3Xi5prkVvTHbJRSkKMFa3CQtcOENp+Jd+HiczI76+z3TKK8xcrbBQI
         YCeexYVpg4e45hFYiLNCHryRKT3XlQSV+JryTocd+0Ku7/WuBiUDNoAIqGaBWfARPbRm
         T2imuJ8XMBf/3od/7A76wwpXmHqhVPJuo9Jc9Vfm0APNe86LdVCXlbs9PxbAQV4JygKc
         mcRrNlbKtJCPff6gzZBXA9+dhByv30O11E46OB2qG5wdE03rAPg8ooDiG8LcWYUI7bK/
         nwEW1H+0VtwBJuKZTv2BLf4UOad/ShRCUkyA5KRp1TuYHuNgsdHsDvMag23cEmPwDmMt
         b9CA==
X-Gm-Message-State: AOJu0YzfOOPuyUtq6hleHeGGF6gvrBbTPxBsBtIe980S5QqR2KKWbmBk
	f8vmUFKsq899XRq+fxki9c6bjJF/I3bJRrLU8EVuHQNtBFcoJwgXk+1YNQ==
X-Gm-Gg: ASbGnctWBZwGEQL/E34gdQrmN0gkK5D0AtzIMtdj5/ZTChys9CP/kI3u2KpkmMB00FO
	MKWDVsxnJxpyiC/NM5dWshIytmjBsW1fXYnXNOH3zhfpkCstEKGfCSov26idsZMFbwbvtxNXAcx
	jXAFhpFwBrQNQpEQv9U+ByUTjWMkOE8mvVd8/t5EEN19JiqT0sVOFesvWUKeFyhgSJuVbL41zmB
	q5whNb/3vEbEIy7nnItB7FsXgNGdXCmTTzpjRmvPIZirMMRPefbOR0ZehCFodDTf6aF0IrkuJGJ
	/YfrNHWBRvhR+TclvixWmfW6QbJOqamvIB3U1Yt2OzbgXCg6frGUmHs=
X-Google-Smtp-Source: AGHT+IHKOoxt/pZFz/c+flwRhSO3uR8fZGrPrf8HKImtoI56cy4MaI0+K70YAoj3kdaMH0qhzWD1gw==
X-Received: by 2002:a05:600c:450d:b0:43c:f00b:d581 with SMTP id 5b1f17b1804b1-441bbf37e63mr25539275e9.29.1746204784933;
        Fri, 02 May 2025 09:53:04 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099b0f125sm2586013f8f.72.2025.05.02.09.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 09:53:04 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v2 4/5] examples/send-zc: record time on disconnect
Date: Fri,  2 May 2025 17:54:01 +0100
Message-ID: <0a9ede715e71e8eef7c169d5a32decfe4437834f.1746204705.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1746204705.git.asml.silence@gmail.com>
References: <cover.1746204705.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Record time even if the other end broke connection, the server can
specify a small timeout, and without the change we won't be able to
print stats at the end.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index a7465812..be8da2fc 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -458,7 +458,7 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 				td->bytes += cqe->res;
 			} else if (cqe->res == -ECONNREFUSED || cqe->res == -EPIPE ||
 				   cqe->res == -ECONNRESET) {
-				fprintf(stderr, "Connection failure\n");
+				printf("Connection failure %i\n", cqe->res);
 				goto out_fail;
 			} else if (cqe->res != -EAGAIN) {
 				t_error(1, cqe->res, "send failed");
@@ -469,9 +469,9 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 			break;
 	} while ((++loop % 16 != 0) || gettimeofday_ms() < tstart + cfg_runtime_ms);
 
+out_fail:
 	td->dt_ms = gettimeofday_ms() - tstart;
 
-out_fail:
 	shutdown(fd, SHUT_RDWR);
 	if (close(fd))
 		t_error(1, errno, "close");
-- 
2.48.1



Return-Path: <io-uring+bounces-8079-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 395DAAC0F62
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 17:06:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F22B14A4363
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 15:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE8A528D83D;
	Thu, 22 May 2025 15:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="UZjVpM9c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f99.google.com (mail-ot1-f99.google.com [209.85.210.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B94728C865
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 15:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747926349; cv=none; b=ZoY5xcgn6TzRqHHZLa3akEs2PtcfLEpahqdfH2UQnT5lM1sCmfy9DwchWJ9VIvItxoQPzYGD08x4EPbiXMyFwkrZGp2BDFdCIadcY6nu3SGQ6Og0mKNUoumfuHEjMFyNPzKBLDPY727/77APZ/v/9746B4Uiw9rmQuhhmzhDUdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747926349; c=relaxed/simple;
	bh=7H2/E89fciRxCRq+D4loQo9VPhae2DqqRu/RRY5fbaw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YjaatowgQldAiV4lyeiEYR3+HwOzbKsz/PaSMmdZWt5+qiee+ptMqz6mgq9ifRVsA33/thueBDn8U0XqkokhAY/90ZFlDAU7RBkp4+1o+eq0Y4izyf/+cIPRoi3IRinP7rPQPfryYCPRbjV6BjZkQDR57ZldebM/h5nVZWRCivI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=UZjVpM9c; arc=none smtp.client-ip=209.85.210.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ot1-f99.google.com with SMTP id 46e09a7af769-72c73b2558eso906547a34.3
        for <io-uring@vger.kernel.org>; Thu, 22 May 2025 08:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1747926345; x=1748531145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PfVvvdWGG0adnBwzws5Hqth/btOaihCNY1aQF7gASIY=;
        b=UZjVpM9cu7Ti7Q8ewkdTEhmJqXeQw69vvPJIGnzX5h7ZrezZAZ5Ibj4oIYXZPR9sWy
         ujHyfYif5Y6xt7mAmrmy3qY1ywPit2EJQX0y0FFWSVgRBdIcMNV3cpYNrgOGguJ3yqls
         ybXYWcyKZ6RK8mUJ9sOErf/9Lvo4O0wVkoqxn9IgG90EJn/CLqmqLnuLxqovuiau4dIN
         vsB+qbXgJTCCFHlxfcpxiVSeC+DxtDwJ/8FMTzQyAGbNfpTs2qjpSLJ2a9J21LjjAZVs
         Nlc66XqKAiF2ii9xSi+jFbtURt32bcM30J22W4K9EuVUnuxUBikoe5a9RgcW4Q8imnDi
         sAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747926345; x=1748531145;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PfVvvdWGG0adnBwzws5Hqth/btOaihCNY1aQF7gASIY=;
        b=TQFSsrp0/4CuHUJoHG9T4HskjDpQeDNHZF4sEMYw7/iJLmy/aVeec6rY/Xb+wb+Wbu
         i49B0GXQY3xu3Wp1CqVyQ/JG/hVyZGBGmf78ZgEA5I2pj1wQfAey9XtSXtq9oM1Sd7Mu
         J1Ye6pUvHww/jDv0rGPbfDbcfFQcbXvbaCTMetqJEuUuNZx8hH8wIcgjBrV4dXgVJd5n
         SYdfVRTla7/b0iXbTTGg0N2sGWo4ysnshD394eo9ZWZYRuu9sA/mDoqY5Zg5NWOEhfaJ
         5fJ/FKZEMhfbAYFx1+SOvT201IF8H9yYG8z9oitcb3BBqdJxhcFdtq5hDe0j304aaBGS
         wErQ==
X-Forwarded-Encrypted: i=1; AJvYcCVss4yba0xUnCa19qmxdTxcPqrAnTorKEA5EoWUFgzWMmOw323QG8ZlwjWoBdOnBDpoacW3Du+YtQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxKRKh7IOUuSuG48H3nrBr9QmiQRUU8h01zDYoCEOim2uxl02O3
	RBt5t6NtSDJA4OoGAY2UWNhxJn6G3PcOLM3XDyE2zskU9N6KBmPFN5QZmXm+ZoVA2bskmzfNgi1
	gYx1l3l7aQduBQsIgqyq+eD9G7bRXG3a2ab7gArcxSHWBY/Y4FSyC
X-Gm-Gg: ASbGncvVcjkaTMvoNGmDlM4nFxy2uCshL0RssxJdsfGE7wwJm8BezcK1JVW77uRMizq
	C+YP8zLy5D14UUirdSk2MDKbVFsvS2C38lbEoZnSYGo8DDIC6hXyW/+msRJG6KYhh1k84dDxXt9
	sgt3QAB3EfwW8aDz3jtEdGgaA68EjLYFADI7UMXfcxy15Qyqv9c0FVyE0SyvWlIWGs3hNLsUmj+
	sEnuyYYwGrbdKeeYotevO97XEhtiV6sJdKtutgS02HX3Ct5uzmdlIbIxjt2Pv5B3TW0Lao8rZj7
	9weqaRgnLn5XENSoSIWydv5EbKOWbA==
X-Google-Smtp-Source: AGHT+IEYt0bFnFpqhd2H1XnceM8lYVhuAHUarQy8gh4pLinv73lfLkgJKvqyllIgt5EGZDv1rrVoDWxaCb89
X-Received: by 2002:a05:6870:fe85:b0:2d6:1e7:f583 with SMTP id 586e51a60fabf-2e3c1b8e07dmr5370430fac.3.1747926345338;
        Thu, 22 May 2025 08:05:45 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-609f2fbf362sm587638eaf.12.2025.05.22.08.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 08:05:45 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 90DE9340286;
	Thu, 22 May 2025 09:05:44 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 8A9F5E419EF; Thu, 22 May 2025 09:05:44 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH] trace/io_uring: fix io_uring_local_work_run ctx documentation
Date: Thu, 22 May 2025 09:04:50 -0600
Message-ID: <20250522150451.2385652-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The comment for the tracepoint io_uring_local_work_run refers to a field
"tctx" and a type "io_uring_ctx", neither of which exist. "tctx" looks
to mean "ctx" and "io_uring_ctx" should be "io_ring_ctx".

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/trace/events/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index fb81c533b310..178ab6f611be 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -643,11 +643,11 @@ TRACE_EVENT(io_uring_short_write,
 );
 
 /*
  * io_uring_local_work_run - ran ring local task work
  *
- * @tctx:		pointer to a io_uring_ctx
+ * @ctx:		pointer to an io_ring_ctx
  * @count:		how many functions it ran
  * @loops:		how many loops it ran
  *
  */
 TRACE_EVENT(io_uring_local_work_run,
-- 
2.45.2



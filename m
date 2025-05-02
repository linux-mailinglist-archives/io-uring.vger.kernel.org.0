Return-Path: <io-uring+bounces-7819-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FCE3AA77C4
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 18:53:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D14C4E44B1
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 16:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 423AA267721;
	Fri,  2 May 2025 16:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U085lBul"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A14267733
	for <io-uring@vger.kernel.org>; Fri,  2 May 2025 16:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746204785; cv=none; b=O1QLTvePVvNiiC1/mJ0+xWx58qFFlHegHNpI3vKxzM4M3u6+6tp8NEAcVjWX+BCdinjTkr2Pd+VQNl323A0hYdJDacGWxKJNEeEmz5IW27W7FxOWxioYs2kgb9sowSXgFzznCYtJUCYl/awcZykGPrGfZghk66bO1ulSy5iOQGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746204785; c=relaxed/simple;
	bh=bdnp11WQkfATqLfaum1+MMkeitNwIzXTTeHDwkgKPxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XX0QJImFwfF0R19MPk3i/IoSoim00RlDKJg5xEvHsCqtzaBZbuTKCS0l+ilO7SrUdmHRG0QRh49WBmsZkOpAUe0/NH132NuXPLgKDML/lHEfmk9tzgt6fKamnhQeY49YbaX1KCgPrmGbshKaYz1tWs6Ci8MQCkAS1i0MD1kupaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U085lBul; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39c266c2dd5so2480787f8f.3
        for <io-uring@vger.kernel.org>; Fri, 02 May 2025 09:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746204781; x=1746809581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KeYpTu8ecIheByVwig5sPzWO0DlawPk7adGKRGsLjBc=;
        b=U085lBul9D+q5prqJo2o7rTak1U4nEVk42YNKfvcDz0qBZqzFPYJbj8xT+C6SyO1y4
         iDj94vx3rmHXlxHjRXWIJBQ4kqgT6SoZjjx+KNmBPaWu0umAJ8PJopWjt1YzMBiOphyY
         DrpBbRtROTkZS7v+1HGYr4VuKWsQ7ZzYmmSSZgo6PdBTe6Lfsq5Wha6qDObKpjUSPR9l
         R9SEqg+wGLtPv7B+fqJFiYYwPnOukYI7ONfv1UaadvmJV+YHCIt57uhTuy16FhmfaQzX
         VSVWmvKmy3x3E/qLfzLCgjRN4FszlwY5gYl7R5YVu0HoJOfcNRAP1pzPVLLXoMFp1EhP
         1y0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746204781; x=1746809581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KeYpTu8ecIheByVwig5sPzWO0DlawPk7adGKRGsLjBc=;
        b=rAX7os5L8LI05Sb+6fyMkaPvpCbl1/aVB+++0OLZQFB+5ZbcEuUIEaA7PJl06iaSl4
         PDsrp1e4Aiz22YdZEVBSKCLwJq+1Z3fuj51NIHLntYXeP5n5mvYRtEl4m8HnkAT26MNY
         XB/IlxNXUBwLs9VKsX9Tty8HKnO4hMlH+6BdpcguWmdccyNtWl/O2MxO8PWcRz6gp45m
         qwFNcIGleR4K4HI2MyLxke06J9HRiopgFzFKdI99pWTnPHdsyUeu1CwIIxS3z0JjunZ3
         VRagmoO3Rr9VZaEcShczaeAkfPkXiA0Hom+Vmw6eb/FKMwsGyc5LS0dSMYD5TwHFqGc2
         CjQA==
X-Gm-Message-State: AOJu0YwophHoBBAX3W4h0EhiBHc+gR/lVxLPyde9QY7rpf33J+YLnlCU
	Lq8bLersZrExbIzCu+OP01Uamc7Kemif25k2kxbsuaaPCG40NfTn08M4Lw==
X-Gm-Gg: ASbGncvIqY2+aDofI7LScJtLhUywh41ODRIL47QzBYz0LmqgCH+8/5ahtfq56S5cXMm
	VWTyj/378wsLt0O+RhXZgL5JhO6LqcuIuzPQezejwSmh0E6Vj1uXELfIHeFeZhFCC8S6l149m6A
	YxUH06fPKLj5XmdHbPHAvoe8L1AUhgA6OK8WaEC5i5YMtummYTUeHu9BFGH9j+rsIcBuqcRUaCS
	/UKRSPRkE6CMKqQvRIej7f8s1ZCLitxDmnQUT6cMzJQxnn6uuy4Sfk5ilrWAIgY0jEG/8+SlW6M
	gMyzeRcGWmVPl5eo5JLPsxLtcvvZwpq/Q5VQKtgCT4kClzZxw6z3wgE=
X-Google-Smtp-Source: AGHT+IG7INA17GqYElbi2GoiHmAPseifOwSpEdgOBIhuy3PCohHE9sM3RzHJn4qDEAonsgLlkuc7VQ==
X-Received: by 2002:a05:6000:40dd:b0:391:4889:5045 with SMTP id ffacd0b85a97d-3a099aee24cmr3067762f8f.36.1746204781199;
        Fri, 02 May 2025 09:53:01 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099b0f125sm2586013f8f.72.2025.05.02.09.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 09:53:00 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v2 1/5] examples/send-zc: warn about data reordering
Date: Fri,  2 May 2025 17:53:58 +0100
Message-ID: <c0612ea07d8678a2247e24d268a8929c2ad470ef.1746204705.git.asml.silence@gmail.com>
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

Data can be reordered if there are multiple outstanding write requests
for the same stream / TCP socket. That's fine for a benchmark, but warn
about it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index a50896c6..c83ef4d9 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -501,6 +501,7 @@ static void usage(const char *filepath)
 
 static void parse_opts(int argc, char **argv)
 {
+	const char *cfg_test;
 	const int max_payload_len = IP_MAXPACKET -
 				    sizeof(struct ipv6hdr) -
 				    sizeof(struct tcphdr) -
@@ -573,10 +574,22 @@ static void parse_opts(int argc, char **argv)
 		}
 	}
 
+	cfg_test = argv[argc - 1];
+	if (!strcmp(cfg_test, "tcp"))
+		cfg_type = SOCK_STREAM;
+	else if (!strcmp(cfg_test, "udp"))
+		cfg_type = SOCK_DGRAM;
+	else
+		t_error(1, 0, "unknown cfg_test %s", cfg_test);
+
 	if (cfg_nr_reqs > MAX_SUBMIT_NR)
 		t_error(1, 0, "-n: submit batch nr exceeds max (%d)", MAX_SUBMIT_NR);
 	if (cfg_payload_len > max_payload_len)
 		t_error(1, 0, "-s: payload exceeds max (%d)", max_payload_len);
+	if (!cfg_nr_reqs)
+		t_error(1, 0, "-n: submit batch can't be zero");
+	if (cfg_nr_reqs > 1 && cfg_type == SOCK_STREAM)
+		printf("warning: submit batching >1 with TCP sockets will cause data reordering");
 
 	str_addr = daddr;
 
@@ -589,7 +602,6 @@ int main(int argc, char **argv)
 	unsigned long long tsum = 0;
 	unsigned long long packets = 0, bytes = 0;
 	struct thread_data *td;
-	const char *cfg_test;
 	unsigned int i;
 	void *res;
 
@@ -607,14 +619,6 @@ int main(int argc, char **argv)
 		}
 	}
 
-	cfg_test = argv[argc - 1];
-	if (!strcmp(cfg_test, "tcp"))
-		cfg_type = SOCK_STREAM;
-	else if (!strcmp(cfg_test, "udp"))
-		cfg_type = SOCK_DGRAM;
-	else
-		t_error(1, 0, "unknown cfg_test %s", cfg_test);
-
 	pthread_barrier_init(&barrier, NULL, cfg_nr_threads);
 
 	for (i = 0; i < IP_MAXPACKET; i++)
-- 
2.48.1



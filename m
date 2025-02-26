Return-Path: <io-uring+bounces-6825-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64877A46CB3
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 21:45:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70A8B3AD754
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 20:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5CCD27561E;
	Wed, 26 Feb 2025 20:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nReWZbLe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1796275614
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 20:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740602742; cv=none; b=juAIaKthlhHW9bGxrpjRK1pfKim7fZHQMUsAB+qktfCfAEQOr8A0kePgEf2k392g4g4QXX4ZCGM6mKG9qV32YCLgAvGps9UNTqpC74bouSuOi6wmDt4Hr2Fh03cfeAOZ3VIeuB7yZ+gtpr8lLbq94/sY96bXgv1bx4jc1IxvqgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740602742; c=relaxed/simple;
	bh=gN5ptnFPL1Eavg/tGFRqiXzHpSxMWA4IDbXzDMGth2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G32Ht9j0BDzdvsrI7+CbsBEzf6efwEur0xFc1do7937hE/Jkb23Vy3Zig/io9GykKW/t208LAPC4RO6h2cCwPQ2JsEcxIyjWFBlVPrM86oxOqMvtU1R5Z8q+H3XQWMBhDni/br/5n0S1WYtilwGhVomFs0tDcTbCStjUlh0MHSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nReWZbLe; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-abec925a135so31344666b.0
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 12:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740602739; x=1741207539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d5OkdHrD9QiCz+CB89cQEzcFF0kCNJ8x1Jtev0C6O5U=;
        b=nReWZbLeOvn3lAWPQoUI8Clv54FK42cmtuyHZ6HXjD9zY9RKMnhvQmok1aathZbLgS
         xw+/orL6VTD33GkQw22w0JV+/Su2xAEEMTwu5BHkeiQbqruwwTvmjfG1kxzpRKCcN3iO
         t0r4ofyWoDaNdWnBn0feKj3dNc1+6jUioqJZyNNp79ocY7BHiD6iib9Cm1Uufepfn4wN
         OIszNGT/JwgrFHBQVT222hFNsY/3Rn4e8n4HPo1WOoVKP5DLqkn9zyTjG1oRAMUaJUc+
         ea/2KeYYcaYI7WT4t0X9aSGby29oKHmmoqkvrUqbp494iZGvvkHFbjomQo5C+0bQ/HB/
         GavA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740602739; x=1741207539;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d5OkdHrD9QiCz+CB89cQEzcFF0kCNJ8x1Jtev0C6O5U=;
        b=ggP+o388ypfd8JmZVVGfU9Q8XIofKWmF2aDNLvB5hbXvvLGSHLrQa/aPJyIKmwfX1I
         J5zA9rPaGlKvCsBYy5facPEsPR16S0x5f8FQ+fZqYvTJVHpE3O5HK4xgUQNDTH3Z0fNi
         z5X5NkaGW73AjM3h/09GT34t+snS846r8pBHRCLo/tJAYQELwwHMspaXaPRUeHEDE2L3
         91gg3TqdpSIxw98RoUffYGDfyeqegBoG1USMjjT+zEHXHZuOzB4NyKoerWN6mQ9lAVba
         oh9YCPGXbSzmjKPSxxg7DFjABGYnNEsYmoNQre/sT2ASkkZFda7tOF92torWrjEKD9Wn
         ScKg==
X-Gm-Message-State: AOJu0YxUSigHmNdIB+rkZRsetvX+LjM863dOZn5n0WqZiVynlB0zpKV8
	5jC12R5a9zjfVUusKiX830oe+r1Jngx26voIiedhHLi3pDwi6noxHIFMXw==
X-Gm-Gg: ASbGncv5DY+7mrouapUYWp08nXraQMdQzzk/J9FT0NAOJmLqJp0f0K/3tYWOz4NT3Uj
	I4tBK+jKKEUPcrjmRPKTL99RbhkPFgthTOvcWGzh/gQatwWmnmLeyyHenZmpnttKbLwN1L5IVCK
	HMQ5V35x0vi+smkxL+T3hXx2wlfTMm3O6qsvvF+D33y2TbNfDMWsHsgaWFjcbKJUPLZsqJGOIqF
	C+mzyutP1KVVbBeiEUTsl7qA+CR7lVa/MyJjaee7vPk9Rl1x97yCcYUxk56i6rqhGMSfP2wqc6c
	Od+PUo2gV9tEYEMMM4KvPryrAbCHT4ESwISNRw==
X-Google-Smtp-Source: AGHT+IEs/8tECykk7KCWdEJw7kBQkdCIXhFCWJETqHBORRFiynr+3SXp6Xw1IVlRZItoybMh5luU2w==
X-Received: by 2002:a17:906:c142:b0:ab7:beeb:d1f1 with SMTP id a640c23a62f3a-abeeef76330mr592431366b.51.1740602738625;
        Wed, 26 Feb 2025 12:45:38 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.21])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c74fb39sm993766b.132.2025.02.26.12.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 12:45:37 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 1/1] io_uring: rearrange opdef flags by use pattern
Date: Wed, 26 Feb 2025 20:46:34 +0000
Message-ID: <ef03b6ce4a0c2a5234cd4037fa07e9e4902dcc9e.1740602793.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Keep all flags that we use in the generic req init path close together.
That saves a load for x86 because apparently some compilers prefer
reading single bytes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/opdef.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 14456436ff74..719a52104abe 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -7,6 +7,12 @@ struct io_issue_def {
 	unsigned		needs_file : 1;
 	/* should block plug */
 	unsigned		plug : 1;
+	/* supports ioprio */
+	unsigned		ioprio : 1;
+	/* supports iopoll */
+	unsigned		iopoll : 1;
+	/* op supports buffer selection */
+	unsigned		buffer_select : 1;
 	/* hash wq insertion if file is a regular file */
 	unsigned		hash_reg_file : 1;
 	/* unbound wq insertion if file is a non-regular file */
@@ -15,14 +21,8 @@ struct io_issue_def {
 	unsigned		pollin : 1;
 	unsigned		pollout : 1;
 	unsigned		poll_exclusive : 1;
-	/* op supports buffer selection */
-	unsigned		buffer_select : 1;
 	/* skip auditing */
 	unsigned		audit_skip : 1;
-	/* supports ioprio */
-	unsigned		ioprio : 1;
-	/* supports iopoll */
-	unsigned		iopoll : 1;
 	/* have to be put into the iopoll list */
 	unsigned		iopoll_queue : 1;
 	/* vectored opcode, set if 1) vectored, and 2) handler needs to know */
-- 
2.48.1



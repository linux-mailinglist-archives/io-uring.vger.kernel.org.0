Return-Path: <io-uring+bounces-7478-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E8CA8B498
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 11:00:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2298A169D62
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 09:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41ACC234987;
	Wed, 16 Apr 2025 09:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tg6uK/U4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A45235354
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 09:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744794019; cv=none; b=NbGI/L8z7ZwpsR8Vz7LHd7S34jx3Rjd+BixqyCyE0WFF2UXt16ZlyU8JKRy2LBR8MfVlxddmvUgx5NjrNBWo5Fgs4tyPit57gsuRe5eyo7V9xJO6ivUmGrNEBKr04fLdoIFATVGpucTwlt4dx3GUpHVfS9IsnmJ+KRlW5PQf6F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744794019; c=relaxed/simple;
	bh=KYqT4a8yBzBdy8aDV2910T7e30+31D1VIcvATYKS5ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Spt8nMUH3ytO2EvTLIJX/e/To07nTIqwo/65L40hSNPBaYfEPVZSRHYjQozD/OF5HWVrxcdJ+vPgoTrxin0If0Po7ZQ87ma5o2kD6VMZhiLJymw6+YBjglurPnCYVfSyzzxpAPmP3EGpMKR07UpMcj4ozmlaSm8Lsx5zJhzJ9m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tg6uK/U4; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ac2963dc379so1078859466b.2
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 02:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744794015; x=1745398815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0pZrLuHUnta2/sPhbnXhWJAmTZvO/papu5zxqaScLAo=;
        b=Tg6uK/U47XWYsb/Ts0HgalmS9EauXbFNNQNIjFPVpncikB4Rj4th+/q4iAUr/fMGfg
         vJZB5+VjpfHNAx7fqHjj3TOuETZJr3yHhfRj4wPY9YkwMBWZKAftAxm5Rzw+cx/SB4fB
         C5HLjby+SnoFez02BRnBeuRp7gcs3jjb8PB41pKPyjPmoQmhjaM/AQwikalvHuCCLXDc
         w3YsfxigEjsw441kn4eEviJ5bgNl6luODZpePpQldx/B6qYT2HtRFgPecy74l1M5U3rU
         YvlmEpW2GlaW3Ha2nsmQhdqPBB7XxY857DGis4n44nj6QviG5HHta7bhrOEp5eyImLd7
         ZRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744794015; x=1745398815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0pZrLuHUnta2/sPhbnXhWJAmTZvO/papu5zxqaScLAo=;
        b=q8+rzqlBqfy/Y5eIaM1ZzxLcI0mAI2zDWux1o8Rv/xeVy8Ls90+4rJFXEKZeuTucpX
         nBghir1ZlVUhbGyZ9zeQP00Bh/5JMFUIQEkwrw0jdkVGWQopDIDfDC8rsvWXzspJPg5N
         sdOxvFjp3SDEu5CA0z9rOFKOO/0jVe7XO8rpnVuMRDt77sgB6PrwZRYSjAdpYBkZAien
         GFkxeQKPDwZV7p+7fD9x8CCFAa/ms5Q1jBOVSnQ6gV5Pjw4oY83/ZE2q7cs08S5uJKVk
         trrL/p8e7hI9UBCHE1CYYE0yHbbQshY13PliUustKn900Zrb/PMNO6CcCY906rEhkAU1
         Ugng==
X-Gm-Message-State: AOJu0YxWtpmSPsdXpXy+M4KvtO4giJj5hqtsBeQQZAwFcU8d0MO/qB88
	LUaVnP093E+n29Pr/8qTnA2O7veNw6cA4wL30h5clZqQvoaOZyzZ1Vtz5w==
X-Gm-Gg: ASbGncvB71KwXeNK9K9de34topARZ6UI7hzvPcgQt+laufPgqg7JAVxb/HE2fdEX5uL
	/EoDc0DlFPlEb76moigkDz1et3cEbnTTrLQZuW0Ys4cIwdOcw3FGKtWcg3hPErmqAjW1YB/jV8P
	tzaR4VxNXpGdNtAebNHy8+DaaIp4jlqeEQaU4AJldqVX+qg26hMVWhmwYCExnVrgfhIpQEKLMib
	U9lQEJBapRKmFJI/xcw89KYz0fu1YEnRFhFX8YudKV7cFyso6l6krXJYJYO05DrZYPxhR+HLhUv
	ejpk1S39K5OV2Bv9tleKXy1hGTW1DZE26b4=
X-Google-Smtp-Source: AGHT+IExv2rEJfqNGQvC3d//5IUZlQLaIiD+80MW1OB8yPcJM82zeQaBGZeyWqfNOCwpVkrMohwYBg==
X-Received: by 2002:a17:906:d542:b0:abf:6ebf:5500 with SMTP id a640c23a62f3a-acb428f0524mr103570666b.16.1744794015081;
        Wed, 16 Apr 2025 02:00:15 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:d39e])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f45bc75b4fsm3378097a12.18.2025.04.16.02.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 02:00:14 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 4/5] examples: add extra helpers
Date: Wed, 16 Apr 2025 10:01:16 +0100
Message-ID: <647b27b73b644e9425f07c79c1c987c7c483c517.1744793980.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1744793980.git.asml.silence@gmail.com>
References: <cover.1744793980.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/helpers.c | 15 +++++++++++++++
 examples/helpers.h |  6 ++++++
 2 files changed, 21 insertions(+)

diff --git a/examples/helpers.c b/examples/helpers.c
index 59b31ecb..0c9e0160 100644
--- a/examples/helpers.c
+++ b/examples/helpers.c
@@ -9,6 +9,7 @@
 #include <sys/socket.h>
 #include <sys/time.h>
 #include <unistd.h>
+#include <stdarg.h>
 
 #include "helpers.h"
 
@@ -70,3 +71,17 @@ void *aligned_alloc(size_t alignment, size_t size)
 
 	return ret;
 }
+
+void t_error(int status, int errnum, const char *format, ...)
+{
+	va_list args;
+	va_start(args, format);
+
+	vfprintf(stderr, format, args);
+	if (errnum)
+		fprintf(stderr, ": %s", strerror(errnum));
+
+	fprintf(stderr, "\n");
+	va_end(args);
+	exit(status);
+}
diff --git a/examples/helpers.h b/examples/helpers.h
index d73ee4a5..c8bf7332 100644
--- a/examples/helpers.h
+++ b/examples/helpers.h
@@ -2,6 +2,10 @@
 #ifndef LIBURING_EX_HELPERS_H
 #define LIBURING_EX_HELPERS_H
 
+#include <stddef.h>
+
+#define T_ALIGN_UP(v, align) (((v) + (align) - 1) & ~((align) - 1))
+
 int setup_listening_socket(int port, int ipv6);
 
 /*
@@ -11,4 +15,6 @@ int setup_listening_socket(int port, int ipv6);
  */
 void *aligned_alloc(size_t alignment, size_t size);
 
+void t_error(int status, int errnum, const char *format, ...);
+
 #endif
-- 
2.48.1



Return-Path: <io-uring+bounces-4899-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EF1AF9D4498
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:39:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7FDB6B21952
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2C41BD9F3;
	Wed, 20 Nov 2024 23:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="icj/RNg/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269F513BAF1
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145956; cv=none; b=QJrrvMLKI1CCeBFRoxrXSPm7G9IHXQckdPpzeavNPn1/IOGeKsqpz5fmgdUblkNp32RrVxoICOZfJWQXHQoXjYAY6rPRZ0erctzsup/GupP5SRHnpkVGSGqtgrTM16UYavI6BBjRpmr6vRO002rtzcpLriNUX3XQqIdzPDbZM6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145956; c=relaxed/simple;
	bh=xwFEwAYXzGc+61bRh6SB/gdhJrx19rQhmFsTg2GHffI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJ+N3X+9Mu0+GHx0JMXzH+1KXIEm8gpLp2NA2esqTFKwUX7TPd+vLrmePt0wcsteAs7SxfaSNKRBSUAOQwIQZ1HCpapnI3SjWjLsfuCqEIjRNhCAklzwe4PfIWcqED9JXENsHZlTL0FAcdtbogniYEcimbcNOC+Vk/jpAkq6D1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=icj/RNg/; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a9e71401844so43913666b.3
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145953; x=1732750753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UvLyi1ypbShfBcpFgFfb91kKYrhXAl4bDfKTMTT2lIo=;
        b=icj/RNg/7xFcHn+KmxpFjo6/B/oCJrxsJSvtW8wMP6EIgLvNm3h3WV77F39nJq6drS
         z+AGFZSGKEowMuYVUWVVfl27grsCeeY6OU2ehXw/1LBR0gJJ20H/zTREuvO+EVtyQ64n
         AzSXsVmuINUAmVGP+qHO57mwdL0WJNhPJEISR9JwRIqCDtVxkDpOfczL/ZhSglLkKggq
         8iaOhoq+blEspkl6m6HvanMLurKY1OtzO4mlyArIQSU0qQ7Ri7wldrHtbOXOkJIq8qII
         zYtjW2E/gY4zlU1xmkIS8Kf7dXmHBLqWzlIny6JHhcHbzO/i8Mvl5ql4A+GkFU5m6CMC
         IB7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145953; x=1732750753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UvLyi1ypbShfBcpFgFfb91kKYrhXAl4bDfKTMTT2lIo=;
        b=ekXyGNVmZ+w/DD7LZ8YOwKVhQYVkXnZbEDF5Yj6mYwRvHmuKdAGQ860TOevOCE/8qc
         af593/BqfTKYWXz6d8wo9T3NuWEn6L/TMZU78SfdKELHR6BWLQnjgQA9idaUcv4Wtlii
         nRCfDASAwAsa5Eu4veEQEl0FcPMfmaFt7ZbplGNjsTe10Vg8ePAaMlJJ/d40wa8R72Sl
         mjgMEYJhOnoj2n7ho5F1oDfoTqwmLJnpaYz92eeiBkSGwcmD+0limejgYJQQiyRrDgsN
         ox4WilvVoKeKOUPTM28vTqCBJUQuZc0b0tEgcYZVgxhqlVCIL3M13ATszPxmeIpDa+Tn
         pL2w==
X-Gm-Message-State: AOJu0YzPVsyfAGStezxgde/j23EhJopFL6+YqC/ZLtOu92+HcIfctlXS
	vFjxBlj/zW/Ek/kQ1zu/sqWvWUEcjzUJHewFqTZlMIy+3/jkJTAaEgET5Q==
X-Google-Smtp-Source: AGHT+IHev7Ocog45eWBKkWCsWCv5GXbOa778XkAIueouq8FLaE4uHofVjf9fOTLJ+5tY+J7VMKE6zw==
X-Received: by 2002:a17:907:9407:b0:a9e:8522:ba01 with SMTP id a640c23a62f3a-aa4dd723feamr470529966b.39.1732145953207;
        Wed, 20 Nov 2024 15:39:13 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f418120fsm12544566b.78.2024.11.20.15.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:39:12 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 1/4] tests/reg-wait: test registering RO memory
Date: Wed, 20 Nov 2024 23:39:48 +0000
Message-ID: <206a368e30ce838626ee998cecbe39e1d15af0f9.1731987026.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731987026.git.asml.silence@gmail.com>
References: <cover.1731987026.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mapping should be writable and those we can't use read only user memory,
check that it fails. It also exercises one of the fail paths.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/reg-wait.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index b7c823a..544cd48 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -365,8 +365,22 @@ static int test_regions(void)
 		return T_EXIT_FAIL;
 	}
 	rd.user_addr = (__u64)(unsigned long)buffer;
-
 	free(buffer);
+
+	buffer = mmap(NULL, page_size, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (buffer == MAP_FAILED) {
+		fprintf(stderr, "mmap alloc failed\n");
+		return 1;
+	}
+
+	rd.user_addr = (__u64)(unsigned long)buffer;
+	ret = test_try_register_region(&mr, true);
+	if (ret != -EFAULT) {
+		fprintf(stderr, "test_try_register_region() RO uptr %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	munmap(buffer, page_size);
 	return 0;
 }
 
-- 
2.46.0



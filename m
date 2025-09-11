Return-Path: <io-uring+bounces-9733-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B0B0B5304E
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 13:26:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF5867A8E88
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 11:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C0C231B117;
	Thu, 11 Sep 2025 11:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EkDr4jGe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7719131B10A
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 11:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757589907; cv=none; b=LJgvAn/OMOB4XSeuqozWjF8ScUtk5uTVPlmRsYOdEntLpkOAr0dOwFXMJvxcdhn277G4Um3kDqJk2rOsoxnXwZ84+CtrC1yCRK4bjo8ubNfavl3jWUBdS3V9HXyNyjiAPR3zof/+vlSSUG/AsfDicgRQvu5KaoEc9nrVlHyxAWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757589907; c=relaxed/simple;
	bh=tg6cvGJcy9FlL688AwZQXd1mKjfuIOEUhLive2Es8ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8l4ly9aFMhvDWcRaa/vCRyGHgVaahcP3NEyb6uR4rhpE8cfqv+jxZGue578NMbtHfFDbZbhq6y17QsmUzpCaYNDY92QNP/6H0S2Pt3LgJev3r6612LHhvIG3gG2CK/FavYJK1C7NvXseKEUa8Y8dwiw5ukH3ZIQtevdCJo+R84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EkDr4jGe; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3dcce361897so447845f8f.3
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 04:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757589903; x=1758194703; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YnPoK6pGaOfPpK46XAG4sTox1N8KhBdXjBg1MQFKF8M=;
        b=EkDr4jGermNlZcuZztH2/G43VYl2eAXtEa4FM40MEHYzBsvKbCm6qEkuYyrgtRLEPH
         6rYM/O/rrH+o5ghHG2S+u4+7KxhjiL5TS7b3yqn9NUdnSf5ahaCD1/jsaejuYvDyKXwx
         fBR0FjRz5utfrDuUYZgR6lSv8/MLNWbRl+TsU/wv9n9ANLncdA51m0XajOCAql9plNY4
         R7KZRWji8RC5AjUJd/FjG/d7pa2UkgF4TU7mIHS34gQDSM1WRXfxxwdLp/VMGX1R93/d
         YtT7u3qotWmloXMl8zNWJ9fl21THECJINaVP5RESDOTpg8LlACI895M/PPRYMkfHvXpZ
         n45g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757589903; x=1758194703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YnPoK6pGaOfPpK46XAG4sTox1N8KhBdXjBg1MQFKF8M=;
        b=J/c9xUEmYEzZok/e7kLGAHsLXpHrH1K153ZsYlDEf2ZrJwvZfx5p+15MtekUwKU9rQ
         aJ5JIhahiB0auw4xinp0q3TrPnFXkks+Bx964C5oJcua/AvIiPtjv+whmgWPnaHV6OEC
         7v9A4mw9yZW0mE+OuFSJmafy+fk6pnubYqOM2vsTRCWW9/WNCmgc4BkCsiTMNTNnLo4/
         kM4R9Q6e0GRjIlPT02RN/zPxqEEPNfeLi156O9Zy9Ht+eyHnZKW8507GZReZ8kl7nFVj
         NX2xdZivPNmZblAmvQaMQrQIGX+pAS0gpOKxnqa7Xl+qcWQ/RW2oy8EqmLYQCg3dnVXY
         Y4Lw==
X-Gm-Message-State: AOJu0YzT4CS5qLQEgpQLVrGSPOa5whVo02uSbielaCMDdSHfMOKEqlBW
	v/NTtlz6wqWhP4eUrw2eERLDUXeMqbbVlWU8JM71rcV+rwAIEid6bSyayx28jg==
X-Gm-Gg: ASbGncshnpWIexBBRbPOxhMuWIaICaJq6/w4y42Ir+PBByv/unFrXT0kjbzDKzvBN5a
	v+2VDhVIlNSIG2RzlqT44iOdRNXg4o2hyWOkbkieVYYfuHKYJhPXBM817ztv8JEG6eCLuN9tfb9
	b1PnKO4iT2jerq54hIOIGVCj+uGDGFSFyCD2YwH9j5cG9qbTGYY6df3gTPm//bnH7oangu8p8tV
	qxJNVz7gamnGtDmGDuVKaEFHaaGEyfWMyhJR7mH+rZBu3V0Pal0x/m1TXDYE32ebvFR79SQsC30
	OdL/QfduCKarA/22FxY9Shszxw2amNUY0u2FHtDHe0O8klndobKTfB35tuJoKmhglRrkjfxoQrV
	sr+XHMQa6IhwdIqCs
X-Google-Smtp-Source: AGHT+IEXsMVAh2lrHhLkpJCitCO8PFNdUlRKoU44wEvea+S/ggdfmhsjqFNtDtrM5NaXqxa/YXv+8A==
X-Received: by 2002:a5d:6588:0:b0:3e7:4277:ddb0 with SMTP id ffacd0b85a97d-3e74277e059mr10615366f8f.43.1757589903170;
        Thu, 11 Sep 2025 04:25:03 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a309])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607d822fsm2095608f8f.53.2025.09.11.04.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 04:25:02 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 2/6] tests: add t_submit_and_wait_single helper
Date: Thu, 11 Sep 2025 12:26:27 +0100
Message-ID: <d65fe2ea1b1e5c4c680ea977da51dbef5cb6795d.1757589613.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1757589613.git.asml.silence@gmail.com>
References: <cover.1757589613.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/helpers.c | 17 +++++++++++++++++
 test/helpers.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/test/helpers.c b/test/helpers.c
index 05895486..18af2be8 100644
--- a/test/helpers.c
+++ b/test/helpers.c
@@ -509,3 +509,20 @@ void t_clear_nonblock(int fd)
 {
 	__t_toggle_nonblock(fd, 0);
 }
+
+int t_submit_and_wait_single(struct io_uring *ring, struct io_uring_cqe **cqe)
+{
+	int ret;
+
+	ret = io_uring_submit(ring);
+	if (ret <= 0) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		return -1;
+	}
+	ret = io_uring_wait_cqe(ring, cqe);
+	if (ret < 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
diff --git a/test/helpers.h b/test/helpers.h
index 3f0c11ab..b7465890 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -122,6 +122,8 @@ unsigned long long mtime_since_now(struct timeval *tv);
 unsigned long long utime_since(const struct timeval *s, const struct timeval *e);
 unsigned long long utime_since_now(struct timeval *tv);
 
+int t_submit_and_wait_single(struct io_uring *ring, struct io_uring_cqe **cqe);
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.49.0



Return-Path: <io-uring+bounces-7805-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EFAAAA633E
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 20:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB3501BA20FA
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 18:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B66C6223DC2;
	Thu,  1 May 2025 18:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lk8Ck15a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE22A2153FB
	for <io-uring@vger.kernel.org>; Thu,  1 May 2025 18:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746125746; cv=none; b=OTNnoWgQoUiw2FYGSJL8l3uYDWaOvq+PXoUMqyw0lRJMH6RwlotmsBkjbArZGFqUvDMgQj6rBrd6eQFgCVdjbWNDrYqCWWW/oRCLPqx6YpA67c/qkZdCKfbXrNGQywq3S3NL0f4EE0e4Is5uvMKzz7qw0/l8IrWlgc+6vKxBg2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746125746; c=relaxed/simple;
	bh=bdnp11WQkfATqLfaum1+MMkeitNwIzXTTeHDwkgKPxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZF5nEA6v8O3h48qRXOM7nFz2O3ORA0bcWYfOM58unvBtuTlGiTmP+2ei4T7SOnPNBXzBu0n+gULRGUIfYhak1dtOvJ5Ur87ku6DyhcxVnsDpx8BfG02zlzB4MEbAUX05aIlOOgSsHKwtBT4tnCI6+pljQYECqx0IY7ghxFr5k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lk8Ck15a; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ac2902f7c2aso190257466b.1
        for <io-uring@vger.kernel.org>; Thu, 01 May 2025 11:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746125743; x=1746730543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KeYpTu8ecIheByVwig5sPzWO0DlawPk7adGKRGsLjBc=;
        b=Lk8Ck15aPGBN5HNARZzTfONvfFyE1oXjlvkx5OwwO5ZPmhYlPsfGlmYdlmt4mR41WJ
         f0LnAwnBG3Z9vU5osOA0qikrQVUG3clK32t8sknW7M/8c6f0W04Qgu1hQZrK/nXRQ7yY
         evkaL5AVhH4kcDmBS0rXBN78uaWY2pFyYTdSZzfQQJfenNPHKED90KZOAK7nUHyZx6ix
         Ft/d3fSoKPCo9MLaynLMnYiNYrhC6C60TfKkTYC/Kj8OXXDrEHZGmxa8OIR1Zq7oJZY4
         0Upcuq8JMAHVC1KxfQILRDXtt7PyXN55t7QUVBcsh/bVRTFBKi5WC1XFj25nd9Gvkbvj
         dHBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746125743; x=1746730543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KeYpTu8ecIheByVwig5sPzWO0DlawPk7adGKRGsLjBc=;
        b=G51I297IY/6dTIKx7J5dKDp01ubRJqpXEz5R5sIDjWHhmmm0vOUyugDB6N7q/Bqt8Y
         vIw+TCVwN9eUmiQecWlHU7FHcEbSVkXBzDbroUvMEP+XCsg8o4Md2sV4A4Le0KqgsM2r
         NpmjK5aoA28PmcraU+3cXmjLv62Y5vrA6iI9CailGIn7tjjiKFrVGXLeCCXuGEx5UKUX
         QmYO06PT5e6xd4TnP3XBmXykhd/9OGWxdDOBfrE61lhktaKD0XeHRh1tH1rSTLqD7yDO
         9/NmYizm0b/k/eOunp1aFgxwR0SulaZ8nIn8TNwFiTiwz2+y6mqvSCM8kM3bwdHdtMoy
         N71A==
X-Gm-Message-State: AOJu0Yzak8IZzTBjlMfWkf6cN43qhJtP4YZvpnKWmlb2w2Nm0Le4HIwG
	ECFypnbJZ90V59+JVX+Zy5ClPzwjtR4Ng+ElmG8h5kaGqxBiYrlxfDGBhQ==
X-Gm-Gg: ASbGnctLXSQTDkPaNTTGQhya/5+GLLNXebaVvsJ5v4gffs3YNP/D23FBNmB+qAg8M8Y
	2OZzbyWnmd2/qKAo5UV667z7r2oYGLw9cmQ4g9ZUjMZc+IFwUWX4pPYMDPySpwcVpxJPx/hWOwj
	uHIhJRN5eGcrctBJd5OaI5ojkWevdWUDvc74ZzWI7gtOSe6V/EFhKxkW56kvAk/UyzriCERvamW
	Qr9SizwS5rAOhsx0Kx+VkeSAup6wSXqnR7Qdob/sgDXgLFGG0MPh7Nq7X6iT3GUoSaDeXwJgEES
	aTbAw3TkBmlrKZZlmFwdRbFCOEzZYu1UpX3LZayRn4IsWZTu8eos1A==
X-Google-Smtp-Source: AGHT+IG9sIujWEQvC9M/zQU9dWKyuruSx+/rs9psikTRTrJvmF2Fx8RHOQskHXZdmHqObToQi20SKw==
X-Received: by 2002:a17:907:c786:b0:ace:d883:3aaf with SMTP id a640c23a62f3a-ad17ade8266mr30693266b.29.1746125742457;
        Thu, 01 May 2025 11:55:42 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad0c70d3955sm79059566b.7.2025.05.01.11.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 11:55:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 1/4] examples/send-zc: warn about data reordering
Date: Thu,  1 May 2025 19:56:35 +0100
Message-ID: <c0612ea07d8678a2247e24d268a8929c2ad470ef.1746125619.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1746125619.git.asml.silence@gmail.com>
References: <cover.1746125619.git.asml.silence@gmail.com>
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



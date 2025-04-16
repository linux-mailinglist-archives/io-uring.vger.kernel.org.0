Return-Path: <io-uring+bounces-7476-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29681A8B495
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 11:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A28BB189700D
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 09:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB1523373F;
	Wed, 16 Apr 2025 09:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HyUNB3Re"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094CA1C862D
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 09:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744794016; cv=none; b=Sh3PXqym+4pnls08IT8lCbQoe2tmon2xHlfSHRGwf+xZ4phLS0lE4GbCoCOdiPGAvwvcT6zo7FyiWY8m8iJ3UTldl+d6Mfov9WtT40HkaCnt4zhtuf/Qyw/ogB7IvK2U1AHV5uQ2JVMN4W5QG/wMDZMXHl6neqUvnuzjsh4NDAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744794016; c=relaxed/simple;
	bh=k5OLm1aPSubrFFRPqYq9rNrQxf3klRTPtWDWmZy5tiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mH+FNusHm+s+Mfv4wfL2Ba9MQtmj1VgFJBmS2OdSC4GgkbK/HjxpaYyYmVb/Y49/4aEJ4ZqaZikssl2xhIsqDBnFwARMDfEDE6jnPrFsqfH5ss4U4Ikn1FOeYWPZ4kxBigHyTYY7Irxq7OlWSNZ/udb7J4wCegI2hfDIGTeZX6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HyUNB3Re; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-abec8b750ebso1088692366b.0
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 02:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744794013; x=1745398813; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zz567AAiPOLYldJYHy8NYnRvB5vf3UkWfB0jb+jwGCQ=;
        b=HyUNB3ReasTcbFKXTdsdU5sXF9zdoxHtRnLkGCjn9M9gskyqMNzRvVyUi5WIkARooQ
         MeyZ4IVb2zy2oRTjEDs30D3EcBfll39fiiNi0x2dbsAJDTG871Y+LDVUV+2uTB5aQTbj
         HZasuK+ErgZJdZBnBGauGSlW9f/ldqK9z8ZhNFX98fBqqWSEaa+m6aKOS4wle7quOdnp
         XYF1ytvJCLljKL2jbMsiyFnormlJFXCudk/XuHVRiu7e7XiS/jM3hGOXqsXNMYDsYtx0
         lVL8K1KWod1EEYcAirP/0Zpsd6lu+jSGf6MBEIT/VBrV5m3gRkglg4t+ZwB8P2c1F8LW
         PVHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744794013; x=1745398813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zz567AAiPOLYldJYHy8NYnRvB5vf3UkWfB0jb+jwGCQ=;
        b=DOq9RDPotg/ZMEsHw8dj/g0Hh07YIevFy9TA9mQQCxC+s0rlti44z5H5HSpg38h89s
         1BpnXqD4zyfApDgLaRGBmtzS07UBTEV/cTD44AO/MdQwhOQY3V5mi8vilYs8SQsM+M8d
         CpSs4z2AtNSvBzhG8NI1exTMCmIZHpCBcLdoJ3ZovOuLGxMvGFnGn0BzXt/hHSkEdAsc
         bBjcPiyJhRFG+gy32NdIO5f7EnXIZA8H8BRIlezlHDOjAoXg0JWzb7F74Pn6RpTDFYpk
         8b+PZbCOfYKK7VBKYHs2G1Q7Ev5/OjN4yVKOH0xABKIBJtm5zljDWXCdf0GdCRfCzX0D
         aUSw==
X-Gm-Message-State: AOJu0Yx9J77PQZWTeX9xT/sAphoqEIwCcSX9/M6g1wlFWOGac9PJJwAA
	ZBSjifYN91WfJCtOf+ThftoaESxRW/gkWHo3XSWUQ4mYCuac7Z3V3ooLmw==
X-Gm-Gg: ASbGncvDZXN1jyTGuB7Z/TPDYVWz4qJTsgj9aSMxOIxqR7Fo0o96QdYzfBIi0A+hKq1
	Kk2c6j9bLh+LUmh4xRRp52ppIH+D7UnnGYBEA2k8vwziY5E3f/BglmxeGSMUS9CGwaTNivQZI9T
	Cxdv0ICvV2xcux2HyPT2IWsOO/8miCyQ+jt06kl1mYisWyRf5IrDJfNrKpCb/q+uYSXWo8y66lj
	PYNs3JCeXeEYjXmsOIRfhRSZ6pv0jxIFUofVFXNKbEXqrRCY+oM2n2fn6zpyJqlawUgetcHFk6o
	dnsjogPYsAx6ercwY0yh5+Rm
X-Google-Smtp-Source: AGHT+IEl8dGUVA4jyANQLQ+0RxgGfBrDGicusQV0i8hSLU6TvPjzH2scynKuFW8Yg2McYI1PQINSVg==
X-Received: by 2002:a17:907:7f8a:b0:ac4:3d1:e664 with SMTP id a640c23a62f3a-acb42b73ce2mr76574066b.46.1744794012458;
        Wed, 16 Apr 2025 02:00:12 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:d39e])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f45bc75b4fsm3378097a12.18.2025.04.16.02.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 02:00:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 2/5] tests/zcrx: rename a test
Date: Wed, 16 Apr 2025 10:01:14 +0100
Message-ID: <d6a30973d9c364228db0805522bcc13b8a762860.1744793980.git.asml.silence@gmail.com>
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

There should've been some mishap for a test to be called
"test_invalid_invalid_request", rename it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/zcrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/zcrx.c b/test/zcrx.c
index 95230c65..0fa8f2bd 100644
--- a/test/zcrx.c
+++ b/test/zcrx.c
@@ -401,7 +401,7 @@ static struct io_uring_cqe *submit_and_wait_one(struct io_uring *ring)
 	return cqe;
 }
 
-static int test_invalid_invalid_request(void *area)
+static int test_invalid_zcrx_request(void *area)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
@@ -901,7 +901,7 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
-	ret = test_invalid_invalid_request(area);
+	ret = test_invalid_zcrx_request(area);
 	if (ret) {
 		fprintf(stderr, "test_invalid_ifq_collision failed\n");
 		return ret;
-- 
2.48.1



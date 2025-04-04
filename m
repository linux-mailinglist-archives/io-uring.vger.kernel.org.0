Return-Path: <io-uring+bounces-7404-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D10A7C173
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 18:21:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE82617CDD2
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 16:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 083F83C38;
	Fri,  4 Apr 2025 16:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1QkGM/d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D89B20ADD5
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 16:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743783670; cv=none; b=IxqcbTf+l8xsbV6LI7TW+e1myUMeIPs5wkcdpQx4ZeuMSCebn3pytD06OQNdGeTKD/x0Vj98IAxDbFR2OwfmqEskk2Cy8JsowJUWFSd2d/XvUuUAFfJRMvpyHadhIjw87VpRA3O0PLjrn1LCx3Z432dgXzkRXGl8lKfU9ThnxF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743783670; c=relaxed/simple;
	bh=/eaRuqUBlgqkRoy26AaBK/Rg6uR+UHhdwO5PjPGQrtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eo2iF5rFKFic5lMJXsDd4Klk9ZkN5KbHR7999ytti16w1pHRIP2PXyly97AWoUbGarbnDBeYWimH73cUoB7S+VHWW+dQDmL4fm69GvfegnzN1mIOinQanu139TbZZYyoTlXBwhQfeh6KtxnNni8mE0pxTdmnrR0DEA35ug4vHxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V1QkGM/d; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5e61375c108so3080889a12.1
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 09:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743783667; x=1744388467; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6OhjmtmCDME3DRXsETFG1/DtMblO4RfJlQAZuTIgAyo=;
        b=V1QkGM/dF7KE82Wn2+XgF/2wFBXUppfm4yOfn5PDd3RunrE+KwOptKXAeKIL7Gw9G2
         FTi7E9l3726Jdv7wKm3KlHN2pkUbLBmpS4tCLLRi8HwCrKOcC8IIAciKAbG8sp1+z++o
         PZtweJEuoOaEXrVu2WuhX969qiQNUf3cPWLzKH9kUBivE7o88m9JctI4ZNcYkeLIaYZv
         H+NX0g5IAfoUU3uAyVfV0fIj4WGFqdGH9iVp4aivV2/6YDkaMuS553I72oap3qsIOci3
         786kcBCs5KvYcSvyPRoYZpzjhWDhEEYiMJFlf8tM8U2BVvsKjsTe49aEN51qAaSaXO9Y
         aDyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743783667; x=1744388467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6OhjmtmCDME3DRXsETFG1/DtMblO4RfJlQAZuTIgAyo=;
        b=gREFJJBeV+jVJkSzazl01CifchgfmDyKAHUIMsWRvmyIajcd2LsAwh4sNW7jnaK2oY
         1am3ujw8fSUpCj8gbKIhpmyVxFOVi8UhjW1gX6qceWWM/CSOAMK8qMTtClKTyn4LlXUt
         qhO+GHDUXxTME9rXqpj1tokk/XvxsZPgPLD0Rw13tomzHB5wqt4dvmwN6tDstjLVVCvt
         RO6G65RlFuMoMVml1t6WEQm2X5g4SDygFJHODSJ1zLIyFdJPhgZCZ1lZjDTYZuwZdS6g
         kSMhcBqkqP4FnzWIPaxWNKfzaEOOyUHbu1CVSM13u+CxvFjw+hKF2svHTns8wZcneQ9f
         PwLQ==
X-Gm-Message-State: AOJu0YwkEcZ1Zt+GKw0/xxBbTgBQnj3lcfRqGljK7DI0gyOC+gWo9wl/
	P/jPSJlsxIH7+GTc2Dky9/GCuSKNZxIqdkLKkS5OhYDMpKVlJPEZ6REy+A==
X-Gm-Gg: ASbGncu+oG/P4iW7NgFLycmkTTWYP1e19vS3onskdJstEfO+5GwfdCxj/vaNHya7SJ3
	41Zg+rFyEI2JpI4zSboHXfV3puQJ6AbcwCft8iArBh1tproHMn9ZdSJpxaqeWo+GOG+2KWmZn5D
	3K+1LqL84xBGRcFAC7szuVzwbb1FFmqA7P1iogqposuJ9wFTGZPXBHnHNntfFTZ8dS9BK4xqpUE
	JVJOF17rAeGYDyIp6MRVt2aB+tIe3ewesLE8T1jU5Jx5r0Ei6C7sUamvDJe9l4iChlIEmRyxK76
	86+Jm/QqSETGrtk1r5yjxFtJVaIl
X-Google-Smtp-Source: AGHT+IE1TaHj5fhfRK6gJwLdxmTO9BoVYnDeaS7FmMkOKvxNa5OkYMHch8GWBO3uPArji1GvmoND6A==
X-Received: by 2002:a17:907:3f89:b0:ac6:e42b:7556 with SMTP id a640c23a62f3a-ac7d6cbd8acmr261904066b.11.1743783666881;
        Fri, 04 Apr 2025 09:21:06 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:ce28])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c0184865sm273316066b.124.2025.04.04.09.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 09:21:06 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/4] io_uring/rsrc: avoid assigning buf table on failure
Date: Fri,  4 Apr 2025 17:22:14 +0100
Message-ID: <668bcc8f0590e9b8b8a51599a5832b48e387e396.1743783348.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743783348.git.asml.silence@gmail.com>
References: <cover.1743783348.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The fail path of io_sqe_buffers_register() assigns ->buf_table just to
implicitly pass it into io_sqe_buffers_unregister(). Be more explicit
by using io_rsrc_data_free() for destruction and passing the table to it
directly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index b36c8825550e..3c6e6e396052 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -914,11 +914,12 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		data.nodes[i] = node;
 	}
 
-	ctx->buf_table = data;
 	if (ret) {
-		io_clear_table_tags(&ctx->buf_table);
-		io_sqe_buffers_unregister(ctx);
+		io_clear_table_tags(&data);
+		io_rsrc_data_free(ctx, &data);
+		return ret;
 	}
+	ctx->buf_table = data;
 	return ret;
 }
 
-- 
2.48.1



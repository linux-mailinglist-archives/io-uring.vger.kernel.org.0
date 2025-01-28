Return-Path: <io-uring+bounces-6162-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED2A5A2134B
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 21:56:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C1071673BA
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 20:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38FD81DFDA2;
	Tue, 28 Jan 2025 20:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EToUmMIE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F86B1B413D
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 20:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097764; cv=none; b=fe33J7ARiSM6uXS9Bf+MEdAqVvYcsVkZRNPFjnaVKoGOS6vFvFgZVoWurFmixEWnR/hbkdEaP9+vwODPR/6voPym8ZvH6XmBrC07HRwVlyOlwyyC9RKIhp8s76W0cu+2Me/WBbOoEY9Hnad7a+MTnMoIghlLMTmzYJW7aVmCmMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097764; c=relaxed/simple;
	bh=T8Z1eAsO6oaR9W2nRVlYZ7AJd6NuTCg9Cd8nE904Bm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/3WwQo5M0Npjg52mdO4+8/9wikT7YovRZIsavpCc/nX9YVehmaFv9ExlxGArbKfew3sL5VcvWux9jkdVJh0lxGijXu3Iw1NFrv2Z64tuVebNwG/DBLVXS6QKKBWOBZk8dkJ+yaCoiYyV8sebpY4j2oITuJPvFWk5j7fJH4GCQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EToUmMIE; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aaef00ab172so952613666b.3
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 12:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738097760; x=1738702560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t+nOJtAX6+kYF1bb2sQ5F6RVPoNx6++/YurYOca8ufk=;
        b=EToUmMIEL4KMEetpPFBj702C7XB3UiRKjLZmGpLWlKAEcP1EIK4Ms79HUfZgftu5p3
         Nv6pATWIy5usUQ9lmts6gk/HjGw+JdOkyDbfd3xuOPzD6/HgohhB2JmFEXNdH2sKDzcU
         oYXmanCFoU/5kNQ9ukDEM+C68ID9Wb5zWQOt0GHYpUmS0zUH1teFSRNWJ0plCqdDizmK
         t7gvWnRpzbC8ptgchQIFNiIE7jK3nonSEr0fpvVAM65rv36fDLc/BSB8UiCOqZhEXXlo
         VVaU0ZNdtzZpnrwb0uJL9V9JIEW1gGtFbJpUObfsMjzo6ZW4vNMcJ7MIVumTdeDQZZvE
         +8TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097760; x=1738702560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t+nOJtAX6+kYF1bb2sQ5F6RVPoNx6++/YurYOca8ufk=;
        b=fNUaTlGhyCdjWEfMgydgQbBc2WnXGykoeB5XmdEjRdRnEYx4QqZWgGpZBVJ1Z3VNnP
         BL+KvUv/QLL7KlmKwwksUMxGb6riI4/Nmm9k2pmEBxrrwrcbniT+nvXE6XJsKp7R7acU
         iwLV5cnz2mYOjwgnVZvNKAeyB8ok0/PGoWgDbR8y3lphqAsX07wNJ6LzHQrnwBoUKhuE
         y3foxkd4/0vnlwIYt6sVhEsEs0kX5iQgF0zcpCgnfWapMcVMe9r+acis8OWUYmNXI3LV
         0tJXbJEHruYWMlalg0UYSz2QQuiqb79GNaxKTfyNrLMvnVtp0NPsFmzaLkaqeoBnjhTR
         trDg==
X-Gm-Message-State: AOJu0Ywdso30kLj0fXt2ay+unM4iF1dwAzNCB0SKUumTIOzhsXdQmQ6h
	4BcMCzArMmySwQAy4qvpNTZceeerTiDNsZuIn3EctZKGycmtte5UFcDNaQ==
X-Gm-Gg: ASbGncs0oFsFnMezbPzedESXjLOrhtdXpFcp5xnakWltFb3CgG8jFpYTINkvdRMJVRk
	Oc81lhsGh18++ZTQG7DTFIn4e6oEjenwu1ke7nL1jXx/ldfTzg9ayUYYSK3lOUSVDdJRDOC82PK
	rHT2fH7oCQ7TBZuk87s7uZq7JmPM5TZLtB0UOziZ4K5kL5vRGLtEbEXp4cx7YVcnJ6HmnOE3YlQ
	uRPay8nl8mo1AptFR7VQFgnlIJg3TpA9Aqy6e8bxc45Cb2OZ3A05Md7NoTA28Guo80Ena2sGPLI
	Riz+04cJ2Rq8YA6CN4heONRD/ui6
X-Google-Smtp-Source: AGHT+IGlHRji2yB2tlCKGhe58ZErsy4bpaSFYHUO+Sw4SeApm8sxSW5D/LWEpeN0t/Efb0mk6XZw7Q==
X-Received: by 2002:a05:6402:2348:b0:5d0:8f1c:d9d7 with SMTP id 4fb4d7f45d1cf-5dc5efa8a6emr1141142a12.4.1738097759810;
        Tue, 28 Jan 2025 12:55:59 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.145.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc18619351sm7736949a12.5.2025.01.28.12.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 12:55:58 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/8] io_uring: include all deps for alloc_cache.h
Date: Tue, 28 Jan 2025 20:56:09 +0000
Message-ID: <39569f3d5b250b4fe78bb609d57f67d3736ebcc4.1738087204.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1738087204.git.asml.silence@gmail.com>
References: <cover.1738087204.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

alloc_cache.h uses types it doesn't declare and thus depends on the
order in which it's included. Make it self contained and pull all needed
definitions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/alloc_cache.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index cca96aff3277e..28436f413bd2c 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -1,6 +1,8 @@
 #ifndef IOU_ALLOC_CACHE_H
 #define IOU_ALLOC_CACHE_H
 
+#include <linux/io_uring_types.h>
+
 /*
  * Don't allow the cache to grow beyond this size.
  */
-- 
2.47.1



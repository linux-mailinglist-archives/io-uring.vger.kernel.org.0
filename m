Return-Path: <io-uring+bounces-6261-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 526F3A27BEA
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 20:49:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF6737A1BB5
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 19:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ECA421A444;
	Tue,  4 Feb 2025 19:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iQnT28YV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1631121A430
	for <io-uring@vger.kernel.org>; Tue,  4 Feb 2025 19:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698510; cv=none; b=E7LZbNjYchpZOjoGgL/dCxftyNt/G8F3o2Tb7NHVnIr0oJm+o32P3dDmIqwP25ZxGUWizZFBucDClt/1FxVqmTCQcZI/3j875579oKGYzyCenZZJK9fCU1xskVs1+8ipmvXEjq85B63FGZa7NfScc8LYgqZHInMDpQsGueC16TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698510; c=relaxed/simple;
	bh=iDg1pcafrTMf1M9THTPfS2st6QLt98jXRHhiBzRj5oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFaQJgUwRuuvwc+47xqFGhF5u1udNL5F5FN5WEHWWrxtsVKSIWXk1f7GX3P9CwWubw6LFkFCXSOMunqzymmXxqZed8l+7yQLypJ0CnO08fqgKs1jVlmM5SlDg5bp8m/GeHLKavtLH62fLN1YnIYgwgY0Io5pRTmvGQ1Awl9jcZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iQnT28YV; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-844e6d1283aso3904839f.1
        for <io-uring@vger.kernel.org>; Tue, 04 Feb 2025 11:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738698508; x=1739303308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1DNE4ajdvoJ7lxr6HNYBzebwW7qzyN+uH2k2BONZWcI=;
        b=iQnT28YVwSV9Z2vBpZk4m77N/DpfBaU2BP70tZxHLHYdXmiEsj6Qw1CRan1uWQM926
         PRiQbvOJTa/aFo9zNbRJdEYXepBM55tnzkB7VMrpBEgzwDjRSiPTmt7eEsOrNxMs7Vfk
         ZNDN2aCdEC9tms2i/PVWKHw6qQXLgy7yrO1l7EXa8Sp65njp//ie2UG0PW5yMVY0AZ6l
         tqDTcIAi2dZuxx+CAt817FQP7GPljxyMwt+/HAaNW0DXzcZFYuRkUSZ06lKDXkyNhb7K
         ikkqH6J3un3gv7sDJ4RgFnUWlr28p8RUSIxbQy3QZ3rYs1FWPhfCPa/mZ5ZYGvhNszgx
         j2SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698508; x=1739303308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1DNE4ajdvoJ7lxr6HNYBzebwW7qzyN+uH2k2BONZWcI=;
        b=ONB8G0bauLxu6EleJ2gGBXyGOy63E3EAsDFGiM9vtrRdfY+k+WFA/8JjupZqFgEifZ
         K+9Bohph4FrjxYouAufGSx8B81L0/d6C2v73izLd73G9c+xlIfWJ4yjNpGkc9Hkf8GnY
         u4U9uqa021naA1kvSqcv/vEtlZGgrgebRl89N8g9JbGNkv07fPbQKOWdHg13Iu2mPwJ+
         ESAZOlJXjTXIB380R0aZxH5DhI7ntxnN47oMOXFMwlO5tdfH4Lsw/3ftl6LecTVVe7/O
         OGk/cbgAO2Z0UWx8Z/drsPzMHj5rB8BlF5eCKbeG5CyRKkNFXDqRiA87LZehJ+i+FWYJ
         FW1g==
X-Gm-Message-State: AOJu0YwM23iU6cJV7+vYFLAXF/6ftKB4azEmAWlpsYol2ckiCrkczUzl
	WcD98aoCH07zuGvE45GdGValWl66epXmBu/CLjh0axyWRuXTWq6M1J4gYlAKoZgY8hnBmNlUbFr
	/
X-Gm-Gg: ASbGncsPx4I2bN3/u9dKldW4L4DbczpLV8UStcQhO2DJvchO88qNGALnvpqnLQj+8Ig
	PSw3baJVZnx8l/veHVGkhZRZM8DRTlL3luB3vCM8Vm7wlKB4oS+KVt1f1H0ePZYa8TRH9RCZb0d
	OKD5pOMmBzYZoNclOZHHHBJdB9Hj3BQYOLtGL3UTZs1Y0J5OOTX+1p+hxy7ScRRz5Nm3wXgORc0
	+OcR751LuO5qKDsXXI3kpDayDDtoYIgWAZNl2opYFVHpHcEtwunVthnwnPC2dm0Ct3mHkp+oO4V
	5u4kDHbI2jvLNXhVVh8=
X-Google-Smtp-Source: AGHT+IFNPD1IIdcxu8TcCpr/goDKctc2AwLqLRzlAImxHhejCrluUFCk1NTnS7+2N+VAFH1n4BQjJA==
X-Received: by 2002:a5d:8d91:0:b0:841:9225:1f56 with SMTP id ca18e2360f4ac-854de076c3fmr394580239f.3.1738698507837;
        Tue, 04 Feb 2025 11:48:27 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c95c4sm2841466173.127.2025.02.04.11.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:48:26 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/11] io_uring/poll: add IO_POLL_FINISH_FLAG
Date: Tue,  4 Feb 2025 12:46:42 -0700
Message-ID: <20250204194814.393112-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250204194814.393112-1-axboe@kernel.dk>
References: <20250204194814.393112-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the same value as the retry, doesn't need to be unique, just
available if the poll owning mechanism user wishes to use it for
something other than a retry condition.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/poll.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/poll.h b/io_uring/poll.h
index 2f416cd3be13..97d14b2b2751 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -23,6 +23,7 @@ struct async_poll {
 
 #define IO_POLL_CANCEL_FLAG	BIT(31)
 #define IO_POLL_RETRY_FLAG	BIT(30)
+#define IO_POLL_FINISH_FLAG	IO_POLL_RETRY_FLAG
 #define IO_POLL_REF_MASK	GENMASK(29, 0)
 
 bool io_poll_get_ownership_slowpath(struct io_kiocb *req);
-- 
2.47.2



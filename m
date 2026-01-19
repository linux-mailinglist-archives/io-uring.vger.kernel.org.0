Return-Path: <io-uring+bounces-11828-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BD6CD3BC2E
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 00:56:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D7B913027D84
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 23:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1CA42D1916;
	Mon, 19 Jan 2026 23:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lpB4k8rX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415BE29D29F
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 23:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768866912; cv=none; b=gvAODf9wQSw0A1/hwbQ8azRrZALpzDo8PpooFrgRUMZZGgi4JvQVd31uup/raKoYiCGtI+Fty3TFhIbtURO2InV7BiAphFjufb759esmNhEdDT3wh1p8lRQTVVfU4Kf8dIl2lWnfiXu/s61MfTrTywUv1a8sjtoyh1NEMDeMeSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768866912; c=relaxed/simple;
	bh=sRNry0qI9r624KnwmWF9H5x/9jkZNJmMCRWqZATokeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiOkhGTZWCKPZsF2EQWwSd7+yt1GcSlglpRZ3l6h9fWqVrN9P+VG8mD+A4vl30glPtevlOXgH/jaM8vh/P53u1y2hF/gAfEHz9hSbM3OSYqW/wgbdJJfMes+T6NcCwkVTfiYQ8hJn6wydrIiVCcfga0VMsec+w1TEKh5xunRN6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lpB4k8rX; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7cfd9b898cdso2691041a34.2
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 15:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768866905; x=1769471705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0/yinU6+w9r6igWKZzO18FXLkzgImDXu9/PF5FCYnQ8=;
        b=lpB4k8rXDVCvov57IuYVf4d9ssGJJ0QVHwotpPyHD3xYOkRZNDiWDHFEYhx3/vvQkA
         SGhamRmY6CwtWv3Yn+HwAAeEBd2U/0Mjz8vepj0F4avuAgH8lRoB8p1lBgoGfJcUL2Xa
         GgX5/WD35FnX4I4fE80FXvVtZzH7IIcU/hzKur4kV4vXaogjMy+MNfdWvDUCZegx7GHC
         /7ftiDV/IKuecfHePFpohss46Cn06UYWC00BLMtGjlg3B4epEOvyfWpopFhKBeLsYUbt
         R28zL6r/XGU3JEuU8cw+UWGR86nLZC/TuN53I++EC11P7rOVodMjN9GLcDgIMjwNMhnf
         5ytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768866905; x=1769471705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0/yinU6+w9r6igWKZzO18FXLkzgImDXu9/PF5FCYnQ8=;
        b=cIc4iDzRWH8zUE2R1Gk5XN6K2j9rvr+z7POXCFERQylbabA1H3IXV1BA9BEQE56Uhr
         6rmH5KFyLwesTKwEJgDJPkHrrYmbyiM1laXrbDDddW9mFvvRiESuFqN/YyK02XQADCkI
         wpnI5kO3+K+fYkXlcOofVrp9ny4So4NzTIoAMYRnSmkZaS4SWNOyQ/lig33xewrbFDwi
         lEv1c9zfThvDDoqL9JQh+mSmn1uleKvPAnk8fr9Qb0wOA5foj7JzOxWzW4X9Hqq73MJ7
         YtVEm1N/5T9KRE9u5IPzBcMbHoyfIar49Pk9LUUQHEDeMbMjGUhjSRC+QTTkTKduSEu/
         tL6w==
X-Gm-Message-State: AOJu0Yx4AY+jMHGnAgVKI/PPAQWMFE1pN7PF9V4fnphqTcF5nLu5mD+E
	zuW4F+/BC1AlT563vuYybTHUKwLB7ShL9TJnzBe7qFVhmt7M7makrJ5IKxGunILlbPaGATGXYjI
	kRGxL
X-Gm-Gg: AY/fxX6/xnPTOfN4YM9lJX1zFhnVOscd0OooeCY6VYaVPqNRXb+NpyIVeHZV9W2dAI6
	wMCJtTfxl+dktdr+k0Jf+ZAZpyD9HSCJCu6MQQ4AQ7KfuC7nuE0lUH5y8c0ychAEi86xu5OG9ou
	QHSnxufuM8E5M6fHKReDLWRdeBHJjqRyWPnmvdcvZaaJ75iCv5+8CvL+L7UmzPOsKqxYag6saP5
	qixgCL/JMs2J2zqoZWh3CWwzQXV8+garyss4wz6XPm356eMAIXMxzHVVZMBW/qC3nJfcO3BW4V+
	4FUSjz6fwwGti6d/7Phzdx82Dl3rFQ5g62wb9eqult2ZScrT07PPrRdXZkCzqIHSoXCCZ7W1B9/
	560Xs0r5+/IfKLsXFRXZMVjwMVQjjEHESX2T8CjDqKkKBR4b5PZcxagqz1z9TNfkcX2Ta1I37lM
	paLly017TueCi8SNBdvPo4qgQ7TgrO7OHuvkPK8zy5EJw4K7H9YZHJKzxt
X-Received: by 2002:a05:6830:3982:b0:7cf:db69:5475 with SMTP id 46e09a7af769-7d140ab6895mr73287a34.24.1768866904938;
        Mon, 19 Jan 2026 15:55:04 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2a5f02sm7509997a34.25.2026.01.19.15.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 15:55:04 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	jannh@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/7] io_uring/bpf_filter: add ref counts to struct io_bpf_filter
Date: Mon, 19 Jan 2026 16:54:28 -0700
Message-ID: <20260119235456.1722452-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260119235456.1722452-1-axboe@kernel.dk>
References: <20260119235456.1722452-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for allowing inheritance of BPF filters and filter
tables, add a reference count to the filter. This allows multiple tables
to safely include the same filter.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/bpf_filter.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
index 06fad04c4b54..fc9eaf29fcbf 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -15,6 +15,7 @@
 #include "openclose.h"
 
 struct io_bpf_filter {
+	refcount_t		refs;
 	struct bpf_prog		*prog;
 	struct io_bpf_filter	*next;
 };
@@ -129,6 +130,11 @@ static void io_free_bpf_filters(struct rcu_head *head)
 			 */
 			if (f == &dummy_filter)
 				break;
+
+			/* Someone still holds a ref, stop iterating. */
+			if (!refcount_dec_and_test(&f->refs))
+				break;
+
 			bpf_prog_destroy(f->prog);
 			kfree(f);
 			f = next;
@@ -304,6 +310,7 @@ int io_register_bpf_filter(struct io_restriction *res,
 		ret = -ENOMEM;
 		goto err;
 	}
+	refcount_set(&filter->refs, 1);
 	filter->prog = prog;
 	res->bpf_filters = filters;
 
-- 
2.51.0



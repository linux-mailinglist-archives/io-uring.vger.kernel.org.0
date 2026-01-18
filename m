Return-Path: <io-uring+bounces-11801-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BC82CD3986E
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 18:23:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 87673300C0E2
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 17:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AE2D16A395;
	Sun, 18 Jan 2026 17:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mp4TFZou"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0E66A33B
	for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768757019; cv=none; b=XHn9k1fzyUAuHEv1nrBSP6KST2mL/oeomUsjx58GocjgvBoYBzR4JEIagNeEzohmHWwOpngWXy6Fak95wU9gQ7ItD6tQRv1AffoBQHTQp6GXGTXwsShBkb4nWGSf7KI0bm41SEkwPI8FH4SwxKdvPyyJteWp8kHWy6/pNmoES2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768757019; c=relaxed/simple;
	bh=XD3gP1J1XVHc1OrFIeapijhewSqXD0MxUqnRMKGr+/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUH64zI/YR5h0YPQK/MIy6mBwnXUyYDR/kMWgzu1O93XlRvRonZmXTcnGfvHtQnDn/BJIVvSCATT6hDHvxnKE+7u2Cx8K5pHFc7vIbT8/B0oHJz+zzGAWWkZdEiLCTcosz/GLCwymkVtoo4dLIKH3WJlPEJWymACh5c9+n3IY4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mp4TFZou; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7cfd04f1be8so1316005a34.2
        for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 09:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768757016; x=1769361816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LviSKyA9MMDBrSXuXlY/wzrZoPc/OQGQBfahGF6N7ak=;
        b=mp4TFZouKkXNSv1MENheUsw6wW2w9d6Z2dUOvNWecQ+cbos72SOTwz6HRwsYqg0A8d
         ZDcu9EceJHmgDOl1PoewvtTwO4RdVxYA/w0geU0GoYYDjKMp0/+VaeP54ZW4v+lcqTIM
         ieRSxsf6NB4IbzFMKMCxVs7ZV7IAkco6A2pbYSPRdHuQs4bca73qOLBC2H5oLrpi91r+
         NdGEi3h1QJ/lJrti7mQZiBpvjLy2Vzcn2P4kgBcUfKz2PDiw3LBPdBr+HiP0iGGszpRJ
         m8i938i+jExnEbUnRZsC0Flt5ZsWnVROijd15QWoruomzefIyTtoA4BX37MXmDd1JiEE
         3MCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768757016; x=1769361816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LviSKyA9MMDBrSXuXlY/wzrZoPc/OQGQBfahGF6N7ak=;
        b=sgckNHgUWlkqMwlhrJZNAwCLwhWJTjFYVAxkSiJapTP9kHqL4BQVaxnkYGRylVSNdy
         V/DNJutv5NKPJ0XPam8TCpBBa1UePmwFHMSalkp8dgKmTaEK/djzQdMgjQqs1Ct2J4OE
         blt3/fGpSh5GTwcPU1bc3I6W0yI2zaI+MCl5yIN3JFAFZGvuf8JlbFxG6tWBG2xbndV5
         2rv1Cah9PawAqUEytvTYu0Mv0OaZAuk2zrDilvpVO5L4DaO69/GQZTCIlOKm46wysW/q
         jBr/XL7Gd49zBIDVM0aoTvenpjn6yR0VpyfccVnHCgsKr+HkskILzr8uScbi/w0wuoMX
         fwew==
X-Gm-Message-State: AOJu0Ywuuu5Li2BsHPfrO4qGklonFgFoemQVGDNMpfJLnCHWJumfEoQe
	vrJTkfx2pmgSFTqaKO5kdm5gaJycnyrSqZ3AVM4D8bnliyUtec3mdKncxIYASsuCayRZygVu0K/
	E9ghs
X-Gm-Gg: AY/fxX6QBVBxbXbFjMJoMff4FfZnW9n2/Sn/blj/aC6sSYHtiAA6K+GJYQrUVEXX1zF
	75H3WfwRX13IXwppWXdXKbqpLx/U2Kmpa7jHYVbwAanxAyTUDo9Vq1Rr4jCTH6sMB7IHj8/w6Re
	wV3tvI7PhSo9ox0JPt3FTMIVokSNrkmpszTDLwe59Jo47kWHsyImsaFFIFicnJd8Mi/0v+rDPzm
	FfV5Bg7MIyX3TH/dGYyGmWpqt0hKWRKSPrhKldKffU8WEnCUtDzrsGIQ67kqB3ld//4932amw+H
	rn6CwaKbN62di61kZwLzE7gC+G9IpRuJtItfMO5mqjhUG5kWOUaoXKx8PLwpeTwDYh2XwwexuVu
	WyAC9DNqpTF3qmTHPXEnkb+JBmLhAnE7bR7QwHFoBIYy/TtD+f4IfR3VzD3Eb4q1p3GmmV6fzz5
	Io3BxpueKEoMFsY3NVCyEKtE+nDeKB/20BksJbyCuxLeBwwev30RhvHdH0
X-Received: by 2002:a05:6830:25c6:b0:7c7:2d7d:5d0f with SMTP id 46e09a7af769-7cfe020859amr4283691a34.20.1768757016294;
        Sun, 18 Jan 2026 09:23:36 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf101198sm5489558a34.13.2026.01.18.09.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 09:23:35 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring/bpf_filter: add ref counts to struct io_bpf_filter
Date: Sun, 18 Jan 2026 10:16:54 -0700
Message-ID: <20260118172328.1067592-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260118172328.1067592-1-axboe@kernel.dk>
References: <20260118172328.1067592-1-axboe@kernel.dk>
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
index 0e668852b3ea..545acd480ffd 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -14,6 +14,7 @@
 #include "net.h"
 
 struct io_bpf_filter {
+	refcount_t		refs;
 	struct bpf_prog		*prog;
 	struct io_bpf_filter	*next;
 };
@@ -123,6 +124,11 @@ static void io_free_bpf_filters(struct rcu_head *head)
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
@@ -298,6 +304,7 @@ int io_register_bpf_filter(struct io_restriction *res,
 		ret = -ENOMEM;
 		goto err;
 	}
+	refcount_set(&filter->refs, 1);
 	filter->prog = prog;
 	res->bpf_filters = filters;
 
-- 
2.51.0



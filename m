Return-Path: <io-uring+bounces-10412-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B483C3CAC7
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:02:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A1A553449A5
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A34434CFDC;
	Thu,  6 Nov 2025 17:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="enm5AzV8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D51B34D4DB
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448528; cv=none; b=R3Ki/n/TS9r5DdHiBK/L+2XCe9+Ldg7nn6EoGYwAlO8waNTlbXYfkzrTJHBz29xZQ1oXn5t1W+I7n1zS6bn0+9xPuhl3ds/ZVEdFPLs2TXJ3LbfESpsUVZrDkXp+sf9tiTLNcQtSChjh8acGhmfXBFG//VndQzc0MCcvr/exv84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448528; c=relaxed/simple;
	bh=dxQMmdTJpadoWlz7/sBiBYEBd5UMEeYqg3h1Pha+F3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbNZxs+LO7lhEK3nD4yA+oFhocy9gJWqH5CWItQYBW91Yi+5GEIIbMEuimKQyQjTr9Nq6fYX+wlr0PRJ36jFFHumz8nCCP+zUshSk+5wQEH6v9dG5vfCEorznNxj2eFLYfzBDe+fx3FZduI4ici+bYhx9d8zboti7HDXQX6obPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=enm5AzV8; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3ece1102998so730314f8f.2
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448524; x=1763053324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NHmGe+XtZWrYRMXuXLmzUYr1h1iBiZjMHDqqzjd6c24=;
        b=enm5AzV8OisWZrWSnPjCCL8THi5yr5VSzQlWp0M24xp/1U+eeZgjspsmR+VXoWpSqE
         GsWZ9e75bSWOKbRc4w86GCvlYS2zoP2q/Hm5n87sNBGIO2dOvSYYW3C4mxGpphq37PyW
         AgC7jz4sRl4BxdNznCXmjaOZEYdVTPwhLlX8HjBV9xeymdEghURza7jbhU3xElutKJhQ
         QffOSv1cjtVJkDT14Nyd3zoIKuP23+0in+0u28FKP8jvC/MGgkpWs19SwJvUMSkPRGeZ
         YQqgNJKxYCcZrloZbVKSO9pyxjd4O/gH8+ZkSbm5SyEMmnWLXFhSoAWHKZnVzKD9lfr6
         qZMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448524; x=1763053324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NHmGe+XtZWrYRMXuXLmzUYr1h1iBiZjMHDqqzjd6c24=;
        b=TKaBRArs23asa/wSU6yde708VZak+hNg9e1JjZFqqtw/oc2Qk2mamb8KzugDZQK8tT
         YD/bc4H0uF7wrY+LsHXiM7XshTFfktyQ+aQLC1dB2rxs1ivlRzxFCdWFYONKdklPkg0N
         EjlN+weQfLzJqvc4Uf6Jxpt4ausFCxnGyo/INc0icpfq/eDlFXGJgtcacyf7HI9vU1Tu
         Fv93tEWM6M6DOO16wBrvPl+VWBD4W6S1RcMa60Bl2C0pmyzzYnixBjSVKCpbOjM0R7rm
         i8Pd8YZTc+5PSiaC/AZpAFuuC1AfPn4KeavcCZNYjtrJl2iDh0nJtg0OPBdt/TSKDTqA
         k4/g==
X-Gm-Message-State: AOJu0YyyFaBGopWFAr53iZ0jopxaFTO1k34y/WBUlk8uILLs71dZl/Zg
	eYR/lCNTnzweL6r0/IhFKcY4Ap8I4MPVDQtraGhwT4Z7eXI25DKMaf+JFZsKTg==
X-Gm-Gg: ASbGnctlaqnxsM5jR+x+529+Sf5Me7zxCV1lCRLMUXwss7Z7PRf7IFfZNcu2+c5rMKM
	mwgNRmy+mJXjIOtzNUuXeEZ4gZw7n8DNDUv5njfSIjoCcxnMGyVP6oAqwYCy9uKSIzTKpX2QfRT
	2IFS+n8Ju4fHzh3tGOYC1uW9quSbivJbQeEHZh8MkvF1Cucf53ylYPCu4nx6+FhslKgTrYe+WXI
	g8fnJHZPz0zbQWe2rZmI18fERBLWDVMr/CoI+Vlw8RpT5AF9naTg510CcL1pj8ochGCc3RprHZ1
	1fSXPcLFmmiPruaRkpXgFR22q1o6UUXb/X6TPNXYRkc6FuWT6G16S+CVmcLGUG7zjUnLjMWoQrD
	UW9jErZBHifNKymI5e4iJ6CZhGJfr20dch/nqwOuLDWLNnQx6xrabcxJKRO8szjpCJDq8XXJfDa
	ADaSU=
X-Google-Smtp-Source: AGHT+IH+1dt/rPsDfQGOsY7ipx9PDKZU/BaSE2FhJTRNsvVG7GQxTRPpBE48dU1CmQuV4DGzzDYRCQ==
X-Received: by 2002:a5d:5886:0:b0:429:d391:6438 with SMTP id ffacd0b85a97d-429e32c8250mr5891227f8f.6.1762448523893;
        Thu, 06 Nov 2025 09:02:03 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 04/16] io_uring: move flags check to io_uring_sanitise_params
Date: Thu,  6 Nov 2025 17:01:43 +0000
Message-ID: <b2c01a7ddc7475d3fed868612008d046b1facd4a.1762447538.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762447538.git.asml.silence@gmail.com>
References: <cover.1762447538.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_sanitise_params() sanitises most of the setup flags invariants,
move the IORING_SETUP_FLAGS check from io_uring_setup() into it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index dec37cf7c62c..ef1b75c5a4d2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3435,6 +3435,9 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 {
 	unsigned flags = p->flags;
 
+	if (flags & ~IORING_SETUP_FLAGS)
+		return -EINVAL;
+
 	/* There is no way to mmap rings without a real fd */
 	if ((flags & IORING_SETUP_REGISTERED_FD_ONLY) &&
 	    !(flags & IORING_SETUP_NO_MMAP))
@@ -3696,8 +3699,6 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (!mem_is_zero(&p.resv, sizeof(p.resv)))
 		return -EINVAL;
 
-	if (p.flags & ~IORING_SETUP_FLAGS)
-		return -EINVAL;
 	p.sq_entries = entries;
 	return io_uring_create(&p, params);
 }
-- 
2.49.0



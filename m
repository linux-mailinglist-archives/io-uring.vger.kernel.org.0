Return-Path: <io-uring+bounces-9172-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9D0EB30033
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 18:37:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 825A8AA22D0
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 541172E06EF;
	Thu, 21 Aug 2025 16:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Z/jc+XYW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f97.google.com (mail-oo1-f97.google.com [209.85.161.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF5C2E03F8
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 16:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755794001; cv=none; b=NP+OwsYi99An0dcsuFY/s/TK6m/H3Uioh1zZL/yx50vuCWxdVpqJhOwaHbvgV9IIj3UxslIXflSCNl1CYasRgo6n9Rb5Y83w6HIV/VKivjfkmbdJ+gqjUYJ+YBtZoXKOlv8Ek7narm/bUFfRMST2+VuVN+EpvF/F234izKFH0YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755794001; c=relaxed/simple;
	bh=yT8+/DFGQr1pLzFGzhFO+q3xuAFiq1wbTq1MAreZf54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gG3HknsKq1gDgCmsiJrKkT6idXzpNMP/jBb4dk0YO93BoWCmCLbm+cDnITMF7pCUtpmxvKpcSgYre/bAm6OOwsNY6fdINe7xecWLsBQ7c/JRRI276ziSlhKcE9eC9Vh6cRMXZp+9o/PJgtcGJcfQ+lp0f6KK7hCutdPSVQfcjMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Z/jc+XYW; arc=none smtp.client-ip=209.85.161.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oo1-f97.google.com with SMTP id 006d021491bc7-61bfaa21c32so28849eaf.2
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 09:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1755793997; x=1756398797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1XkEISWF4rB5LxRd6OtcHowA7+alPH0Qh+jw1qSoVos=;
        b=Z/jc+XYWM3gRLfnz/HEgblYJQmv0b6o5n/YWsJ0LN36vlbu1pz8/ek41h4z0JTU8V0
         eJ3HWGBYbU0U9Fvt/BjTdwnTz0aZVecdsB43S+ebFoQKm/f+rVfu9MMKvFhwMR5wppEv
         xcmNKLZcgCBFsyETPDhHZYqm/Q6B2VlwYh3hT0Ae0xNnltrZ0uDDBNvX75U48Uui/0qo
         LthnONOeeid1PIxYsL+ymitwFsmgJ9K4KsAxj/uypKlJBKFcypMurIMDzL0Ca6WQmaEa
         ddya6mNe+uepB2UEi2KJchaQgtNUJ4Uvc3EDWmUy7IfyiY1mn1E8g47/q+28NmJUmmvN
         /gsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755793997; x=1756398797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1XkEISWF4rB5LxRd6OtcHowA7+alPH0Qh+jw1qSoVos=;
        b=scf3O6T69GZmL6L7jhWHQhhTkuHaxAKov7pePdrxqGARwggvM30FNLj7LT2iufgMgg
         caQQ+HC7XRa0wkm4XaPcqE65qXGSgHML0HyKP2GXb4wFuqwFrMv1NQ/jt77DcwLVp4IG
         sZ+THtj3ROQOYTVU2/Mbl5A9i+ozTlSrAITupA5QtOMVzduE/VQ0CZEe/Zc0L7O2oZ6x
         +f2s0hWFRdO3PbwmZNuZE77mmTyfNjhnjn+xpskxNipifKJ6hY+FOyon1rOrMOYbxmwi
         RA20CeBZffeTW+vX1EnHVgsMSQipA+2VibrIwAp+hd+rMk8JnLwus4IGgNCVUuY4amCG
         89dA==
X-Gm-Message-State: AOJu0YxN5JrBn8E62ZVcLaNULhO5qQmSZ+f3eH7jZH7+yWGcYjx4pr1L
	gm7scEL2fV/1CKMS0tOB0Zemj5x11zcFa9S3b2GcreL8VMYHJ7B3+OTddxuubVdKNB/qO7hrmw8
	MvLkK4Vq6JUsAlsuwUT6Vx0+kUkmH49fi6f5W
X-Gm-Gg: ASbGncv1dy23bv9ZMr01XUS4/rOq3DABf10OdO0JBSiRTTZBrY2g0fqmdfDcaUsK3kR
	nKg7Lree47rLjlt6cvb3v4KqwcIKXs0gJBCcMfzOLY0kBD2PX8VNCM3Ad9jF6rm2GRcSgo4M2zt
	1UAXrscYcLlKllEfkbdY5J0CdKETx46gKWpWPq6AT3HjFivLDLcnSavKJtRJ2gq497hC7KhVqzf
	CqUNN3nfX/iuTGcvbdOyUdEwzBHfuRtcVKb5V0dWrKJ6Aua4LxoiCMnhiTKsDhP5cLFrS8QvcMR
	5th3IMzyR664jhNoyGb0tE971kkLEpGnHM4aAVdyGwtDo17Nq8wYd580m+1beUNZ1dHkSgA1
X-Google-Smtp-Source: AGHT+IHdBpb0qJ7fWLnts/E3AiKHZZ0co1GDXyYenLYzXZQGbX9xorLdtmLSViW6SGR7rcolp9RMIrru1Z0A
X-Received: by 2002:a05:6820:705c:b0:619:b57d:6673 with SMTP id 006d021491bc7-61dab2f359bmr652510eaf.2.1755793997504;
        Thu, 21 Aug 2025 09:33:17 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-61bec16637dsm206021eaf.10.2025.08.21.09.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 09:33:17 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id C4A003403CE;
	Thu, 21 Aug 2025 10:33:16 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id C2AC6E41D60; Thu, 21 Aug 2025 10:33:16 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 1/3] io_uring/cmd: fix io_uring_mshot_cmd_post_cqe() for !CONFIG_IO_URING
Date: Thu, 21 Aug 2025 10:33:06 -0600
Message-ID: <20250821163308.977915-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250821163308.977915-1-csander@purestorage.com>
References: <20250821163308.977915-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_mshot_cmd_post_cqe() is declared with a different signature
when CONFIG_IO_URING is defined than when it isn't. Match the
!CONFIG_IO_URING definition's signature to the CONFIG_IO_URING one.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 55dc643dd2ad ("io_uring: uring_cmd: add multishot support")
---
 include/linux/io_uring/cmd.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index be0e29b72669..f746f6a77e96 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -122,11 +122,12 @@ io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd, unsigned buf_group,
 			   size_t *len, unsigned int issue_flags);
 {
 	return (struct io_br_sel) { .val = -EOPNOTSUPP };
 }
 static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
-				ssize_t ret, unsigned int issue_flags)
+					       struct io_br_sel *sel,
+					       unsigned int issue_flags)
 {
 	return true;
 }
 #endif
 
-- 
2.45.2



Return-Path: <io-uring+bounces-8579-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFFD8AF5B1F
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 16:27:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 182A74E75A9
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 14:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9578E2F5325;
	Wed,  2 Jul 2025 14:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TCBca5Pp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3816A28B503
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 14:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751466472; cv=none; b=fPd/tQOxzknwol7GbxF7/t8G36+2Fra4zSRxCb7iJcD+cnstMeXHA0RZvF/8mK1m3gycIrgCd2OMfzvKv59syiF+XhaEBr2i2M1iuxiFx/sY3VLWEaFqBrtPCQmcwX8gxuxe1uY1CzRgh0s2ZW8nedM3op+CYbRcqFBUKl3TY3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751466472; c=relaxed/simple;
	bh=khLbo7AY0XNMqrKqR2HAeyMwqC7DiaXDpc51InbtiRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDQbga7MrndHfwX9YtHoT1UfzNo+aCNFKqhDstPWkuw4GhUWvE2I0YtPrvshuNrwSlKTmuKMDtu+kXHSLeuTUlbvAIQajAwwpCCXOGvMkdCtNl4rJLV69NakMXRNFyJPyevwlDjNe3bBEnkQeNfxA2vU4o40bFAiakfkB8xXtPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TCBca5Pp; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-747fc77bb2aso4285318b3a.3
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 07:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751466470; x=1752071270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TEmS8Af/aHhQvsLKosgnrovtauhdpoXEJZZn0CNILNg=;
        b=TCBca5PpVZKPQNsiJNahSJD4jjO5hbgGhAsFv9SBQN+e8mxSxDG2YGNP6NIufx6fXf
         HF6l0S1P05fragy4Ht4WZRD0Z3ZnYVbZPoQOMm5tBjUiNjnbinCbA5lCQVC4Yp0X3wIk
         udB+nlpErz887beJOkAUgbYPKqHn6xCrGCEs+sMGdFJky8bv9K6hp0bdilCplhxBySuG
         4g0DcpTPEkK74TuuFtqBKZVqjo11C+mgIqO8jbKb3Z9yjkxWvkPHEyGI5QWQfRxmq5JE
         nj45AtjZ+UwTdEZBQmQs5mtzmG3ioLR6OdzIdZ3nml3Iax+lU2GYb3fNRAQRcRmzprA3
         CVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751466470; x=1752071270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TEmS8Af/aHhQvsLKosgnrovtauhdpoXEJZZn0CNILNg=;
        b=e91IB3pDFt/DHoRFHjI5yTo07QlDRMY117MLl0/374rb13krtorlVL2S19mVL1hlK6
         94V4i6FC9kyx30je5YJ4H+JNxTcwfnzwEArJS1YIsPi9If5GpQuxzxbx3+lb5Uf54WV5
         tDkQraqPHuLbMJeqdFIHTqLwdH5Glxp4W0LKjJ1pVs7c27BTm30PCH5GS6QEfaKYFw67
         Fk01zmiElLaeNHx3tuKiRpPEjxQc7gVLINTX0dkrbl0riB3HQ6LBd5IFRlerTgfjGdbD
         X6r4+d16CguHn6KSh/dSXnpXjgmPYtW1Ntz0ahjkBjHlJ51g8ldB5fHgHnGFfEEutmLG
         g2iw==
X-Gm-Message-State: AOJu0YwqFGFxKpxooSuYLYkNbMC9YYQXGbGDGuikonUPYQxor95WpPeq
	xnVWw1Dz4ampWbEr2m7ddQqnULNFtsqyboHZh1/9NpoQ5OyPK3YQauPBRV1+0pde
X-Gm-Gg: ASbGnctC91VbIYFIJrrXSfG0wECXB1eR21HN/lnGt7O2WiO2y6PQ8EMLXZRWTJbmfWU
	dK2Uw3uTg+2w3Bd+YWJT5yj9Ih++DtFE2n//toqkGGgetFBiZEjQ7weAvxVRGm04T6XTOFCyVcD
	L4h0HyBSdUNb2JYHYupWVkJ6GK0mvv0ACFWax4ys7rEoylKRAB8AWjrMnvEds2B0Nlhz8IDovX/
	o36XFgOjh92A8z7fiB5omeOBxx9xiK3U27nDbrTtrTONS77RB24D2jQ0mLqXYKMH+mkdD0J3tFm
	hKQXGn/E4Mw9a5s/mmOQOPRNnqjUty5t4VbTG6T4n9MudoPzqLTKMx6G1l4=
X-Google-Smtp-Source: AGHT+IEEbYnK/qt8tYD3oRgfl1OKHjk43c8fQWeCjm/LqB2iSiv2M+R6B20jceYrDqJlWrSQsp8E0A==
X-Received: by 2002:a05:6a00:3c8f:b0:74b:4eef:c001 with SMTP id d2e1a72fcca58-74b50e5c6aamr4834441b3a.2.1751466470074;
        Wed, 02 Jul 2025 07:27:50 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5409a41sm13765094b3a.29.2025.07.02.07.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:27:49 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 5/6] io_uring/zcrx: assert area type in io_zcrx_iov_page
Date: Wed,  2 Jul 2025 15:29:08 +0100
Message-ID: <c3c30a926a18436a399a1768f3cc86c76cd17fa7.1751466461.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751466461.git.asml.silence@gmail.com>
References: <cover.1751466461.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a simple debug assertion to io_zcrx_iov_page() making it's not
trying to return pages for a dmabuf area.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index fbcec06a1fb0..fcc7550aa0fa 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -44,6 +44,8 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
 
+	lockdep_assert(!area->mem.is_dmabuf);
+
 	return area->mem.pages[net_iov_idx(niov)];
 }
 
-- 
2.49.0



Return-Path: <io-uring+bounces-8557-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0987AEFA9A
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 15:31:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B008486B66
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 13:27:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68525276050;
	Tue,  1 Jul 2025 13:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BEJ63NCV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20AB276036
	for <io-uring@vger.kernel.org>; Tue,  1 Jul 2025 13:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751376382; cv=none; b=YLI52YJKprNo1ll6/+PmgKqh9406c5nFoKjJyHJ97GzhiPp+I6vdomEl3NyQC5J+fdgL6noBZJFeMosOTIzzZYrXxOtHGks8O23NJDSXGo0PL4FAN9b9uUleLiTdfcyAD4F/VC1l6Rx1mXDk9jsbR2wc8LlVP0a6VV8rIUBG3Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751376382; c=relaxed/simple;
	bh=khLbo7AY0XNMqrKqR2HAeyMwqC7DiaXDpc51InbtiRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwZ4PSvmSjvt0uaoGMprOtQv14Lu6SoCz/jNPP0kjAWIlw4/fUCKkQw8TDhnGM+oGoAmDaxpmM/1Enqcf/OJQzwnDNNrcbbDTbSZqlTL3kM+QgAKhXfcOIK9MjhIlS/AgAbQIJ0GkAbxFsTgYIfxbC7eJaIY3OnbejJjII7Fv9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BEJ63NCV; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-742c7a52e97so5615709b3a.3
        for <io-uring@vger.kernel.org>; Tue, 01 Jul 2025 06:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751376379; x=1751981179; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TEmS8Af/aHhQvsLKosgnrovtauhdpoXEJZZn0CNILNg=;
        b=BEJ63NCVXl5Lic3Ke8TPVMSfEzv+MLIVL4YbwSa8OROOrPlvT8gPTRAkhtkzAD0bd/
         86mkx8GSLp5s8Uyn8OgSHlpk520YNZuQd1g2ZWtZ9CGXTA9zsEsPmeZ2cyvdTZbI7IW1
         MrPe5+iALc+8ICMXi4x34NlasTKhJggE/WNCQWmyYFPtIM+l8VSgZ7Bc2WqA9VR2ds8N
         1xjkKlrGon+4A/OCiby+hoi1UUNKXcrYSri8oHqkVFXY941yJKb70qq0G4bZdfr4rMf1
         AXW0/n11P1Ewqw8Ug/6qawBGiV7Wws6NJ40t3swsBK5Ci26Lj6ZtSu/DPmHADM2GjSFo
         FgSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751376379; x=1751981179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TEmS8Af/aHhQvsLKosgnrovtauhdpoXEJZZn0CNILNg=;
        b=wegTLQeLBjp9eCMPtTTHQzmonduOCIMsOZYRqaqkHQdoKAgr4Qd1j6Tpr5Wz+8BHqq
         c6YzPu02diqZQ9zxhxmqggvuMw4sJrSMBiOM9cmwRnVzd/wOzkWnd8MKB0dISNumf/o4
         61MG+cE69t2AOvS3Df16++gCxtpaDOfw7/+oAPXHf4oAxdj9E4TFu0/dNcR4mATxTpc7
         aWUrkm+yfoq9rOnQo3dQDjg4ZoYq3K/wYvgVcX/AopEb+8qwB6Pk1QhSaBt+cSLbGcG+
         bieIBq73w4bru8zc65ba7AhL/AjrVhiZ08cFe7a0DTRZnFSKWDDvxXe9LWA2vRwYUyjY
         jipw==
X-Gm-Message-State: AOJu0Yzw9p2zajAnWHPZ1fPkDeJEqtO24sler+G2HUvlerUDb56FOahk
	15NiERkvS7R9IabHs5GF/+4apdC8OOhNZaWx3eZ1b9m69gRHJCxpCw/1m17Rx1fn
X-Gm-Gg: ASbGncvSAdyJANLEFN/d847fQOkpv+pGUE+/805P9nDopFIkw5tzEJWKBMIJRFynSSW
	DmMaQKiJ5UtSlq+wXreKISFIplUwxQzzFtk+X7TPaKtFCeBAVxpFdjUnC8stq1jTlXWAE7ESDX7
	g3Vh01HjURY7Mc/HCdhlM1PmKBDZJJpR5i9v/Hv067sR34K6jOYE6nEQom5KRYQI5QmxsH2iiRY
	sJs6c0SCRObHutxV7FJQEFnMnCygwYRdIG8gshje80vBtvS5DhYRDE8oCs+5anqjcF63cUb1p1e
	dQLwLYpsLNL48/pXeKW7xsdg2NazLEIvLynwdiYwJeEZ3Fy2lLkPfYx650I=
X-Google-Smtp-Source: AGHT+IF+JCm4ampap5Wwg/h/h6S8xKt8pWC+qVzeU3A6KmSdkaO3GSzptijU+XIfsrt41aYWD2IMJg==
X-Received: by 2002:a05:6a00:845:b0:749:540:ca72 with SMTP id d2e1a72fcca58-74af6f5b39amr26332364b3a.24.1751376379374;
        Tue, 01 Jul 2025 06:26:19 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af557439csm11788025b3a.80.2025.07.01.06.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 06:26:19 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 5/6] io_uring/zcrx: assert area type in io_zcrx_iov_page
Date: Tue,  1 Jul 2025 14:27:31 +0100
Message-ID: <c3c30a926a18436a399a1768f3cc86c76cd17fa7.1751376214.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751376214.git.asml.silence@gmail.com>
References: <cover.1751376214.git.asml.silence@gmail.com>
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



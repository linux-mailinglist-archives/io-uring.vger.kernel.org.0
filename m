Return-Path: <io-uring+bounces-10033-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75735BE3AAB
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 15:22:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 830C13BAB9C
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 13:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16FBF26E71D;
	Thu, 16 Oct 2025 13:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lMSbr/2V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CE7202F7B
	for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 13:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760620932; cv=none; b=HqBulg0IpSJ3T8CUE9dHYGvdqrj4SfmHxqatEHCLmRJz5izLmnt+1RjMrLpmYIbPALa8z0tGCYE6ADLbZVM0ix8oo7znq4YZz4NKR95yp0bHZzSTkr/+TSJgFIzsF1SzdrN+2KZDA4wbFK910xlRPHWVVaQokAXLaM4Rj+9Zbss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760620932; c=relaxed/simple;
	bh=uY75fFHZcikIht7ra9wyNz3xG36K+/d0LkKbalNgXeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDHk1e2MIWPmnjwy4sjpnxzB//McYLNy2JNaPq1Xo4V68s5VaD7erGfNv2sEzPUST2Vw9sfxqYoOAESGVENXNv4A/nW9daysLPnNO4kvlvIqQLVogIUjk4DM8E2YyfgrDgIPFp+lJ43Ii72tbMJlI0p0x240l4jWG1xnNX9nEFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lMSbr/2V; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-426ff694c1fso470852f8f.2
        for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 06:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760620927; x=1761225727; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tPX7MpU7XzUBtezuaxvovGfzXL4PvMtQOCUVR+a/sjI=;
        b=lMSbr/2VB6Avdg7bV/CrCH6ZPbwH3zQqxLcaQP9y8m3EG+v7O0g1vAEeJNcq87E5+3
         BLHKZIwFNgKpX9cXMg6O3KhhwMNnf1uBHx6W0WitIulLqNvSgW89eOKLxpYIWVTTGjpr
         lESALblRUtOomr1vYjEKbyGmOjePEus2ZmpCdFeIBiZlKMacoKsJvl46M/lWaVoXlAon
         tTarvrAoF8VT9Nu5kootjHyL3IlaB2JZ5DafZ2MQpmEr7o20EpFuR3vRGcCD5KPcA1mX
         QK+jmfUW2XPpPCWw8tjrVx28zT4co7q4KCXX9PmFZqyVtDdmjYv8JrzoCxxdcdfy73t6
         Z1pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760620927; x=1761225727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tPX7MpU7XzUBtezuaxvovGfzXL4PvMtQOCUVR+a/sjI=;
        b=dUXowf3ZNO9xieXjOhIbhuudp7j//EMLflnX77ArfcCiK5ChQ6NIUBu1y4pJqvl0+k
         lReo1a1qqnnTGcnL3soiiwINmBN4njQ0TId2kpJLZiF9vmloemykS1cYusJbCaSNgrPa
         6QohCaeigQx0y4/ocOg2LilJDzOwDZWU7WJisaMd1Ctvcgrif21m/FmQhLn277VjMG6N
         b1N2KP4TKhLIsZQPRZFsBN8cxn7oypmFPhSnrFVqN2RKUO0YIOo79KwCwwhXufV3Papg
         fmo+f7OJ+x72OXqQ3/quAZjG8Z4SziAlVEb74aDRNUZPYepHLeDfcgCBsMQ/a2RmZDez
         87Cw==
X-Gm-Message-State: AOJu0YyQ3lifl9AczE+syELePZbohrOPktUdmmZNnnIcoAe46rV3tezK
	ScT2s7TGDeITgLimyV6LJ/zv+OChozDGMyt9AbKEHj/ZokXPmXZqhrpaL+mwIw==
X-Gm-Gg: ASbGnctUxWEPdIQ7cgLTCzP8W9WFdWFo4K1ORVRxYCpCrsbeOjJhIbPNi43ovILLgdZ
	5ASWmfZIDRGDa3dEEVx6pFjmaGego3E0X8K42MTjeFRP0EvRXLs8thVJQdabaWFOoLIeezdIGVh
	PEnFYb0846m2uQyoPDgwhkRmO1nWPCCGVGUPBNiXG7NcEAnekQUgfoPnJxdZoxVtuwF76Wd0se0
	g3CokixN85Th5e6SE9Xjs0fLh2yZx/rpf7m0OAGnTT9puRyJuxC5Vc0i6dqGGxS+Bx4taTc0TEj
	vDpcJuRWFovh19GnvDMisIMnWFv6HHeDxeKQCQXiFL67QaK19Dem/PAZh7CqI5PxUSKG/1uWfo6
	zfmxZWa05vgbwj7jXQuPrTmyW7madQQX5JEmPvlMbjRADibQXLSGpJqO0h7SP2B3IWnJpyxCdWo
	wmgZAM
X-Google-Smtp-Source: AGHT+IHZHGKN1/iIQJT/X2HaAbp0RqESFpu8LBQ4i3KL1XZXeB3ASDXarKPt5mEqmtIOtuj9iDNS5Q==
X-Received: by 2002:a05:6000:2384:b0:3ee:13ba:e133 with SMTP id ffacd0b85a97d-42704d83e59mr72428f8f.1.1760620926878;
        Thu, 16 Oct 2025 06:22:06 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2b54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144239bdsm41834385e9.3.2025.10.16.06.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 06:22:06 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/7] io_uring: deduplicate array_size in io_allocate_scq_urings
Date: Thu, 16 Oct 2025 14:23:17 +0100
Message-ID: <7c00931f29e27f48cc14f2cd5ee16295265fd65c.1760620698.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1760620698.git.asml.silence@gmail.com>
References: <cover.1760620698.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A minor cleanup precomputing the sq size first instead of branching
array_size() in io_allocate_scq_urings().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e8af963d3233..f9fc297e2fce 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3607,6 +3607,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	struct io_uring_region_desc rd;
 	struct io_rings *rings;
 	size_t size, sq_array_offset;
+	size_t sqe_size;
 	int ret;
 
 	/* make sure these are sane, as we already accounted them */
@@ -3636,10 +3637,11 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	rings->sq_ring_entries = p->sq_entries;
 	rings->cq_ring_entries = p->cq_entries;
 
+	sqe_size = sizeof(struct io_uring_sqe);
 	if (p->flags & IORING_SETUP_SQE128)
-		size = array_size(2 * sizeof(struct io_uring_sqe), p->sq_entries);
-	else
-		size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
+		sqe_size *= 2;
+
+	size = array_size(sqe_size, p->sq_entries);
 	if (size == SIZE_MAX) {
 		io_rings_free(ctx);
 		return -EOVERFLOW;
-- 
2.49.0



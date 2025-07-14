Return-Path: <io-uring+bounces-8661-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A39A0B03CA5
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 12:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22E3716365B
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 10:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7123823B63C;
	Mon, 14 Jul 2025 10:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RH85yYC1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C1345009
	for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 10:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752490560; cv=none; b=DyBOOCTyOe6XX+oSaxEy3K7FXu2ZM3f4U71D+L2XWaipln6WdRoylsDN1oQxKIPUQpH+XOiEl+0IPF6wt7C/y3J82drExnABQh5NVcyXEDQ8p9fOPnCxejdgUAh4PdtYl8ZBY+F6ljU4Y7gbSsYcEWoKAGNnlR1bujtmGm2/7J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752490560; c=relaxed/simple;
	bh=56iJGbGBmK4HIQ3+qBDgdJvO+5MHkVxjSRnLkbQmcrw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j/faBu9w6dtM4q2JNmjsJI9X27Kd9RU7JETpdqmwPVe/bcFJEvTkTlJutX5mSz56qAtY0OadMwh0DH1RpX1Q/++NcBNyzNfbJBuxjY2CGd363m+Y2jtN1vsH7D1LmgfmsJlXSxR5pdWk4DyX3aoGxtD3aHbVMEj/0TIZ+SLTc7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RH85yYC1; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ae0a0cd709bso1085680366b.0
        for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 03:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752490557; x=1753095357; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7DgyYkLexSIHoEBqqQnRf0+I83z//sUBDLlThBweUQk=;
        b=RH85yYC1DaXq/urdOERdMQxMr67zO0xekxKpsKbWHeF1vqXAXaTL79OC/KzaPs6BCS
         MMKscGYKPiGMzwAE4Y68p4z+IRi5wxa8IlY5sTkHfZRO9hLhp/tiJC/Jwul6Yxb+U7qM
         3u3MI0owjbOtiosURGc4YczlpyWN8ZYPGzCGd8poQvWEYfwojGE+5q1Q+GbnqFwGZwBu
         NqJqL+OBRNc4JRfI7StFgMmLYCNznc0DBluSOky275Zo5GMnYvUKId1MpcmjtQM1rVa9
         2PA8kYkPVjT/mGKn+0GIgVTrUartU0qBd96z8p9UEKEtXssHeQF+2Bp6Qn5ETMe8jeVJ
         EIkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752490557; x=1753095357;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7DgyYkLexSIHoEBqqQnRf0+I83z//sUBDLlThBweUQk=;
        b=efRqmKA+N4FJb59bIKNvUm0vix8I25ElzJqfigXX8YOCoqONBo03MJ8MMcJDLZSdpZ
         DLOcP59Fp4Q70wdx7r73ZPVhC3ow6jcm3sswjZEwp133BRIXpa1Q3t+6Bqk3ZG/m2Uo8
         vh+Qy+rm8fyTrEbSYakXtc98ZMO+hgQBB6uYR55h76O9tfwBIh1FHgNTzwO5AmuUb0Ix
         99ZsWQz0lzamKRzgN7IT9skqkS+QUWdklJyjo3tJGdgCCyYZ4G7d1CY2lxhTWxjKSGBU
         iS9OrsV7R78jNNqBo2v1UAvdpzMs6vwwz0POh4/ulhKi30USMcMNHkw+Rh0xPbEZ2+NH
         E7yA==
X-Gm-Message-State: AOJu0Yz6CFkNcdPzhLgf6dc5WkEeCAxSJ6FjZ0IXHoxdl1/8FxzQ/BSn
	cZ+4+D7al9xHoDlzvc81HubfFdKkfpC2VUlBMhnwZPHCjL5vjSBxtN5Mt3mvXg==
X-Gm-Gg: ASbGnct0uPS91B0wUwFpZdApF9KTX89MplcuSBhineepJMDyTpaPuUcQ3U8eq9XyPzV
	Cd9kDQA/kOZMoD04yZ9Dff0nVDkFy/7yzXEM7HTvJEg9NFdIU6/ayE2u7uU3nQlkTsty2RmmD3k
	7ohj2FByPYQLh958vICyBPFvRBFKiuuP1IBWP2pHbCEsVo8Xmmo1RUDggowyee+r+TD512FPlvJ
	nNRIS11v/g0i4Km54gs4rEB6D/TLYPfR0lf8/aDDJHg4Xj7AfCEnNaoDtOM3omASFi/yL8D71w2
	3MqGS3r1R3sCYVmmcWms9F8LIywZT7FICeI1pZLAJYk+eYVeTDbSJOgkciJPRNBlwTRlzJggOXU
	FkwV48w==
X-Google-Smtp-Source: AGHT+IF5lt7b+n5h9y94XLOcxJVDIXfcUrUAb3jKT/3iTX47Xo+mdhzw7HhuN/KMr8M/madOjsk6MA==
X-Received: by 2002:a17:907:9604:b0:ad8:942b:1d53 with SMTP id a640c23a62f3a-ae6e2540128mr1433600166b.27.1752490556275;
        Mon, 14 Jul 2025 03:55:56 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:f749])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e7eead7csm812380966b.62.2025.07.14.03.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jul 2025 03:55:55 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dw@davidwei.uk
Subject: [PATCH 1/1] io_uring/zcrx: disallow user selected dmabuf offset and size
Date: Mon, 14 Jul 2025 11:57:23 +0100
Message-ID: <be899f1afed32053eb2e2079d0da241514674aca.1752443579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zcrx shouldn't be so frivolous about cutting a dmabuf sgtable and taking
a subrange into it, the dmabuf layer might be not expecting that. It
shouldn't be a problem for now, but since the zcrx dmabuf support is new
and there shouldn't be any real users, let's play safe and reject user
provided ranges into dmabufs. Also, it shouldn't be needed as userspace
should size them appropriately.

Fixes: a5c98e9424573 ("io_uring/zcrx: dmabuf backed zerocopy receive")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 67c518d22e0c..e3eef4ee4454 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -76,6 +76,8 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
 	int dmabuf_fd = area_reg->dmabuf_fd;
 	int i, ret;
 
+	if (off)
+		return -EINVAL;
 	if (WARN_ON_ONCE(!ifq->dev))
 		return -EFAULT;
 	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
@@ -106,7 +108,7 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
 	for_each_sgtable_dma_sg(mem->sgt, sg, i)
 		total_size += sg_dma_len(sg);
 
-	if (total_size < off + len) {
+	if (total_size != len) {
 		ret = -EINVAL;
 		goto err;
 	}
-- 
2.49.0



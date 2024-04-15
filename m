Return-Path: <io-uring+bounces-1548-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B57478A5004
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 14:59:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 729D82857E6
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 12:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EAF3128379;
	Mon, 15 Apr 2024 12:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q1Y/HSf9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B2B128391
	for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 12:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713185417; cv=none; b=K2eaMPHRrM+XZXie2/ug0ndRMlDFIpsdvgeVisM/DeZ4PIavSXsH9Ec5DsPZCTAfLRdU23hBssYx14idTjNDLBFJ3KRTLn5wh9FNHbYHDD7F7frLEDp6nyshW44zlexFXJyaEI0URVANdD2bGR4DV8zkavF+cVr7jjCdWa0PFEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713185417; c=relaxed/simple;
	bh=4NnbX65Kg2IvqFTZ/HG8uZicY67C4dxXDpKHre9oz74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OchVfqhIZGu/aWVLuxPf5KhtcxMiPpdLAcNzVor21SJl9s3LCFU9DxlDVOTppGnO6U22ufhMidaQqstQUz9qqM39ULDbxu3lAF03Gc9fwcFtigojHwzSa8AifDRxhAcQa1LoW9a6/GKmznLu/jAvOA0MjucoNTdzVZTdTWh0LOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q1Y/HSf9; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-343b7c015a8so2627353f8f.1
        for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 05:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713185413; x=1713790213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lQ3AM1VffgdehiFKtUuqAnNrVTntHp04Mu4cHKZqkgg=;
        b=Q1Y/HSf9o6XG6zWkcLNJvLHDTatRD1h8ThW8ZLx85hHTziv97m/tVzxVwhwMQWUYbh
         gSEeJ7cGXQ8WX6cRPHmUecrMZPph8f5tJ1ywiVmB+vsE8uqWHN3yKQdE2cafDjovCls8
         c0fRQdK1aUgKh8ZGARVk1goRXKM33bXaW3UOz3oiqA02iGTzXyQqbQa3hlS9o3L71MdP
         wQ1Ltv4Dm12PLKuJTW4zeM+xKi4D6W1QpTxeBbMnJfnEw6LXZ0k49i4k6MCUchsO5epV
         CEiASA4o8dFNJAb6lqTpYKwCN/fmC5HlgX0DPUJQ9tVM7JAp7w3V4rZ6yztodR0GP5wR
         vNzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713185413; x=1713790213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lQ3AM1VffgdehiFKtUuqAnNrVTntHp04Mu4cHKZqkgg=;
        b=TRplX7fNQfYCoRLEQ+bnasTsK6XJ5otWRHLtNptljuQrAt2g5yvUobi0nJ0zBZcW0U
         IMgdQUnB0IVeEsDXodqRZS4WKVQkeb4KlrmSRbWKrhEmSDacanxCnWfIOIvYoLnTacM/
         MUXsALHKBSMoFeuavZ/IPsu6/r0vCeE/FZv6MMrH4BYp38jq/eaCF26FO3vs9iayoEKO
         8ZauxRUiTbaNcY+eASAGGVSjDfBOKehlAL2c0NMRIItRLwzMoJgYjqhYKsXGH9Vq3KW1
         n021xZpAUDrYYiNUA7RWtNQ3fwc/FrByb6zSm+vP7mMDFNUcvodu/HH0JJXJc/T9P5pQ
         U7dA==
X-Gm-Message-State: AOJu0Yzy75JfeDDKYvoKxaWUw30NB1g9SIQ0fyv2T4dx8jL5nz1g56hL
	OXjnUHDSCVK31Qw9MKgmDQMA1e/PCik/q68qaQHiHWJPBLRcmj6k/p0xdg==
X-Google-Smtp-Source: AGHT+IFMWmPjB7UuqSVWNLXJHQrhWlQqIyxxV3jdSVqileWsKl9IQscBmQ21MozIl1Asu1pcCqwMfg==
X-Received: by 2002:adf:ed88:0:b0:347:62e:b606 with SMTP id c8-20020adfed88000000b00347062eb606mr5566898wro.11.1713185413144;
        Mon, 15 Apr 2024 05:50:13 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-213-93.dab.02.net. [82.132.213.93])
        by smtp.gmail.com with ESMTPSA id h15-20020adff4cf000000b003432ffc3aeasm12022170wrp.56.2024.04.15.05.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 05:50:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [for-next 3/3] io_uring/notif: shrink account_pages to u32
Date: Mon, 15 Apr 2024 13:50:13 +0100
Message-ID: <19f2687fcb36daa74d86f4a27bfb3d35cffec318.1713185320.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1713185320.git.asml.silence@gmail.com>
References: <cover.1713185320.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

->account_pages is the number of pages we account against the user
derived from unsigned len, it definitely fits into unsigned, which saves
some space in struct io_notif_data.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/notif.h b/io_uring/notif.h
index 52e124a9957c..2e25a2fc77d1 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -13,7 +13,8 @@
 struct io_notif_data {
 	struct file		*file;
 	struct ubuf_info	uarg;
-	unsigned long		account_pages;
+
+	unsigned		account_pages;
 	bool			zc_report;
 	bool			zc_used;
 	bool			zc_copied;
-- 
2.44.0



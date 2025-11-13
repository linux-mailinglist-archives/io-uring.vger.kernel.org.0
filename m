Return-Path: <io-uring+bounces-10573-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E10D2C56FFD
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:52:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A28834EB81C
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7676F337BB5;
	Thu, 13 Nov 2025 10:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TM+Py9TZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB78B33858A
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763030791; cv=none; b=Zn6YxwSIR+bW1SU/M1AMcCfwqE0fjJdL8gONCIE595rlWEz678fKzRi+4HvFrVtn+C/kEdKFSpe25wjsJCXs9bI0sVHfs9me0CQ14SXQF1AUNm5TIHQKgttGmlWpL3Nxw8D9ncb0cbjZg4yEbdu3rSdcEMN//BkkaCzBtL1gjN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763030791; c=relaxed/simple;
	bh=X39KDvAwy/CrKEtq5OmIpNZxcBKw/URvO24fiCsTcb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cp1qvffJKElZbPVcb6+WTuflBQf2CYnnvYWF19xE/15xVWBntWZ71SxU9y32lYwhEAwynHUPptL5hN6W6qM9B6qiBr6kmV/adRBxXF7VImnUVDjjklQ6qtiKjNrhM2mvxR8jL05A/a7s0kN2fDP/S5VTxjzi/haddAyhztnep4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TM+Py9TZ; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42b2dc17965so587271f8f.3
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 02:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763030787; x=1763635587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HSZJowsGSgNVlodrBamdaFT1Q8MzsnuAhDUFTnHqXhQ=;
        b=TM+Py9TZMi21XkqwHxRpR3pmjQq0Wd9J0bERx/TKRLbk6D5yzuqC7bv7bDoS1qt0oU
         du0EzEpM0V1ZgGU2lJYepMZtFGYkX7xV9uRZY7gEO6dFXRYpEQBLijbONrhJwl1ObmYy
         BYu0J/+kDavekQF4OMu+9HIUnMQU67MsC7grZncW45km/YnifC1pv6sgA0qutlaUv3/i
         9BBc9XZwmr1Zu2FN4LTd7KBmKe5czOyjFjNGLMzYQ/VROiSXxNjIQbPHSg4o18iuU6r4
         9s7z6GmEDp3GhnyAojYnlnbJrT9ZpQ3lNRYsjlPirk6IqZyR1b9xWxO7VWFfdKsDLNS+
         vMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763030787; x=1763635587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HSZJowsGSgNVlodrBamdaFT1Q8MzsnuAhDUFTnHqXhQ=;
        b=UPFdyAkMih+2SAWIMWntbuc8B/tM+wUnBGcmujnr8r0wchXNsxock7tWz4ppz7+9cA
         k1Da6c7iJ5IT3VfXTF9eXVOs+cRBWX6pvohQuCYmOgTz8YN3Lmp5NV0G7oU9G+UbSxQM
         9NHACdbfOKseLgcnJfR3vTUrhXIeJeGdnAXz4zy9Z7Xyv33kLXC7tmYjdFCULwumhAHt
         kbmhcy8KZa85JjEMMU5HI8KfJT1ge+dIP/I0RDakuGpY+Z2/gkt0jVDKuDPLjJZl0pLY
         ydBy4fwW2RrEaXOxNAG5mT7LLIkqA6+J2QIxupUSHIkmN0J107y2lHe8mnFLdtCKjQy9
         zPDw==
X-Gm-Message-State: AOJu0Yx76E6TuM38HbzAiwui+e0BXE9RewfoMdZvlZvAeL8OGJhO7p5u
	ZRB3HmyrDsvxu2uHfx6p+zd2Auet7iskjjKmbXEBChqKx1ZnwI9u/OTSs9K3QQ==
X-Gm-Gg: ASbGnct4KxiGQ2GABYKvN0/cLlKnFCftWqoD9/eGdcj9Qzju5BJgEshXY4gHvtvdZI5
	RxgsCcpp/E3fVIGVXI1k4pvDE9kVHoIfRtK4Q6ZNbcX2i1vcMJM9+GejLJ5WdSPbJJDFi1LZFAN
	b2a6McXNSf6DzpjhvR978BAagGR9jm0JOi0vUsQeXWp9uuimiwgi21lv6Crnf6s8zd1ZNuCIGAC
	xti4etKkDA/Knogk0s3uiEm56udbkWBkIjAMl32X8s5May1BJisfRGQrfaMYVWzATpZpGqOwerL
	2ULkeDPFXQx3Qwx+l4ozn1m7RbZgaU9PjEZaGty8xna7xpc2Ej8AlNv2gihN7eo/Korsgw1AKlE
	CvJg4PjDIT0LU5iW+0txIenrEFwdXYETmCGVfy9EVzZtRPu7qYohVDrkDQiY=
X-Google-Smtp-Source: AGHT+IH6buxWpu6XO/rSqD1Gk+kcSbXBWVnCikm3r91Dz9tCMzmbS6mC7q6gPH4+gvRXo5+V3D5LiA==
X-Received: by 2002:a05:6000:24c7:b0:42b:4223:e62a with SMTP id ffacd0b85a97d-42b4bb7d329mr5845939f8f.23.1763030787479;
        Thu, 13 Nov 2025 02:46:27 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e7b12asm3135210f8f.10.2025.11.13.02.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 02:46:26 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH 02/10] io_uring/zcrx: use folio_nr_pages() instead of shift operation
Date: Thu, 13 Nov 2025 10:46:10 +0000
Message-ID: <083a8ca834fa7c5a0eedf355c684148b289b5135.1763029704.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763029704.git.asml.silence@gmail.com>
References: <cover.1763029704.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>

folio_nr_pages() is a faster helper function to get the number of pages when
NR_PAGES_IN_LARGE_FOLIO is enabled.

Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 635ee4eb5d8d..149bf9d5b983 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -170,7 +170,7 @@ static unsigned long io_count_account_pages(struct page **pages, unsigned nr_pag
 		if (folio == last_folio)
 			continue;
 		last_folio = folio;
-		res += 1UL << folio_order(folio);
+		res += folio_nr_pages(folio);
 	}
 	return res;
 }
-- 
2.49.0



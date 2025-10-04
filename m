Return-Path: <io-uring+bounces-9891-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0930BB88CA
	for <lists+io-uring@lfdr.de>; Sat, 04 Oct 2025 05:14:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 603074C0F40
	for <lists+io-uring@lfdr.de>; Sat,  4 Oct 2025 03:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C60722AD11;
	Sat,  4 Oct 2025 03:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mg9fRLsj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C39219EB
	for <io-uring@vger.kernel.org>; Sat,  4 Oct 2025 03:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759547669; cv=none; b=oD4WNTisysXaI/c67evipbttgsKaTT7JVxecfGeb55kRoxaBTtpU778CusmpUn0HzNdc9sDJjiKyMHRxK5cbIOl1OTz8yTu8/JS0HFNLGyhK0BDw9FB59tA4yJdFXcsbHueGQbNSkt0BWHMjXnKc7EPSTJhzbWkFvja0t8JM++A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759547669; c=relaxed/simple;
	bh=SEs+jxvnoDQ+gggMj/8O8ffrzojjD1lDA2vNrhX7WTI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hZXmbKOZa0/zLNh8Zou2D45yQxlzGpio2/snm85YH1r5kJnqZIi/qnUPjiK6W7513zqzN7Irt34wmOKxiLXhJODCoTnaIujOZFl7OSVL9E4vwaavIUIYrHOvN8MQ2mDztyvB67RGFGS8CEaLpV9oI0RQ5W7HrwxWGoIydeB/zA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mg9fRLsj; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3324fdfd54cso3507604a91.0
        for <io-uring@vger.kernel.org>; Fri, 03 Oct 2025 20:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759547668; x=1760152468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CCOemn72vvobbf7j0Qp9leAd109mBGP1uki9wP+tOMI=;
        b=Mg9fRLsjsl9t+qQW+KOMgBXtUndaMa8UNwUy/ZF4AU/EIFIw2Tfwo73PPDijoqv/Ly
         pVqu9T+0yb30MgAKtf+KCA/1Kf+eGwkahVn8WzUeOMHAvKLMlJVnpsFg6rV33ScreVHI
         wydh4xWhVlixOZ0zGxDuXMeWln3tMM9wZhRtmJivr4tSOJkdnfGzrcVhagW4Fa+Jqg8q
         5pMGhdxmgwXJVIRCgX16uB5mOezxmUE725HhSXuWHgqEtTAKmXXX/mq5HVrcGFnSo2xm
         fhwSictpq2bIZl+USULxH+M4zP8EJspNEsz+09kJNlScf1GAWY7YeF2c0G+2ydJMSHjm
         tSJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759547668; x=1760152468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CCOemn72vvobbf7j0Qp9leAd109mBGP1uki9wP+tOMI=;
        b=ZiNy/DckLaMBwMf85sGrEq5C+JjVKSxzhc4pJCYqisc+0reukYSMlQx0t2sbUJ9RiD
         rWAVoz2HYW48yFIxZusS7q7S+rZViarliNiz7jjoq0cQKYmZAgTZT+a/GFgU9rYm7RcW
         H6EKu/EBaO9rC6aO38Jmv24FimGjsI17omksYEp9pgzZFk434uUBWGA904HVCyJZTEQh
         u5jykzD+rsdnRI6CmyP4u7p3BhEIfPgC3c6dULDqPSb9/ivyJnzUKp3147pAQmhBG/ZC
         7bs7ZDbg/3SDirDHwPAY2mGr6qN1oCWfI0Yko+xSnDZPAY9qBGrlEXPY4Bwu7cZHjlro
         DsTg==
X-Gm-Message-State: AOJu0YxFb43uD0gK2d9z0OdOZVrvEW1vTjjvu1FyHTlNrN6pJYqW2I/i
	qXNHPXsrfjttIQygGnIIxDEY7FnM5h39mZGJsmdRXHDbPWe3tz5RA64D
X-Gm-Gg: ASbGncun28hFs+hHTIkZmSln16IP9vsAdNpXJbZRukjn6h4yDND4qSoPO/Nif9l75G8
	7JTOsCaBH+kw4DkSWmSQq9GegrlO5dplgNBP0Mv2T3p2dzCBxAZU6K2OgII5BkAYmodzbpZaw1H
	EyXFAL5Mhoi+ZDwaZBl26bBiX35T5+eVDsMosOJo3YhvQVwYlmy6VtImrXRMwtpnZf2c8jraF3J
	HMPDvRRO6Iu4u8AxpmKcbTeupDkAl5C1gMkArWuD4V6lk12wOTPQ/b0ncziIVxjidBoyvVtHI9L
	KVhyN5S3pz8fT2xl2GqZ+d3bEZrqc5i139mvCSgZC178zRcyjUIrg2jd55DxLJx3tf6ra/h3UvZ
	TJkZ+RXhoKij5vDH7osyb5U04G0NW+nMbmu6lK9biCa7aT73xqOOhZ+WGNnSV7Q==
X-Google-Smtp-Source: AGHT+IHFhY7jMV7cBJzt9SHbTOialNjWOSBE1RIX+l1qo+ZwVRnG+J5+DyjyP0hLFNjHqTBLVQ2Isw==
X-Received: by 2002:a17:90b:380d:b0:330:4a1d:223c with SMTP id 98e67ed59e1d1-339c2722811mr7005796a91.15.1759547667654;
        Fri, 03 Oct 2025 20:14:27 -0700 (PDT)
Received: from ryzoh.. ([2804:14c:5fc8:8033:c5aa:36f3:14cd:8995])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-339a70246c1sm9481967a91.24.2025.10.03.20.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 20:14:27 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH] io_uring/zcrx: use folio_nr_pages() instead of shift operation
Date: Sat,  4 Oct 2025 00:07:33 -0300
Message-Id: <20251004030733.49304-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

folio_nr_pages() is a faster helper function to get the number of pages when
NR_PAGES_IN_LARGE_FOLIO is enabled.

Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e5ff49f3425e..97fda3d65919 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -172,7 +172,7 @@ static unsigned long io_count_account_pages(struct page **pages, unsigned nr_pag
 		if (folio == last_folio)
 			continue;
 		last_folio = folio;
-		res += 1UL << folio_order(folio);
+		res += folio_nr_pages(folio);
 	}
 	return res;
 }
-- 
2.39.5



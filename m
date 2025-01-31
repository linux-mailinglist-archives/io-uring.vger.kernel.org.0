Return-Path: <io-uring+bounces-6206-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D6CFA241E2
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 18:28:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8840167A2A
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 17:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64CA21C3C18;
	Fri, 31 Jan 2025 17:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JHWJMwWU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2266136351
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 17:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738344492; cv=none; b=kmQJ69yD3mKwCW6U2Rp88w30bW3BcdeNsgiQeCzYUSZV85tr+R8XcLVZcPdWFAWa6jNLf7wjcsLdTKTd19LIhfnr1kKWYkByryyeOu1Qu8veGvPjj11jCUmJjeozUcYvce6XNQ7OUgK/pxMgO0XQEMOhx6WHtJjHpw54UUR6gM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738344492; c=relaxed/simple;
	bh=ozTEm+S37RquHiEWuFvZNWNVyaEaUhNf2+puBALeOJg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I56ERoekLjTmMWIXHInBPwSp3bkvKkWVk3QTI2Yz00g4/euKM2VrBw/C0z5GFjDTdFSnI9JSYRrhnbdDzlhSSX2NY2WczY300twSaDgpo79fPzMHxNRoTUusXlI6dSSzDqaYkXu2nkai2brl2A5ZIpm3p562mtxrwSZ3DkZlqRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JHWJMwWU; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ab6ed8a5a04so317500866b.3
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 09:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738344488; x=1738949288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dSMqhGjCnh2icx3eBn/umw/Pm6A+NJfu87cyEiFX1rY=;
        b=JHWJMwWU3Fxhs96lx9i1twkIK7jkazW9OKdxSGGz30sKutXGkxRTRPiorvXWrUZwt8
         F40S9gTccbNmV1j1Fe9N68+4jhz0K/h9YCVBy/Lyguw6Gt9iDPzCiLcsHGHP/4QxitYr
         JtWF/WNuQ7qNbTp6tjpgVk+/UcsZ18qPKoZmdrAO9NsKlFfYQ1XGXHssPgNFhP70Ta+/
         H2vANSA9qX7vHXkzzgbqQe2EJ3AUv6nUCewog0w5yf3cOpQprtyqDmHo/W8N5fm7PQkw
         R1aqj5tsQQoZOsewmC8JtFJz6Nu+GSXnSyFdwqzzZAGE6aXkTXv+FwKz8USS8y/Ao08E
         JIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738344488; x=1738949288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dSMqhGjCnh2icx3eBn/umw/Pm6A+NJfu87cyEiFX1rY=;
        b=NShipSv6zmWWjEv36ZYnt6x5jofCeywwbCmAPLBRK+EAnxjlAmfMdcluy1EycXx29m
         uStwzihgEcyzaEaDNc0BWXLeeWrvgcBcUcU52Gq3i3WN/caFUjgzQ0MP7z6R3fzwMGkN
         mhv9sbn0J/JF4lslYCZbnHGPv8vtmJPa0Ig9v3qvIrr4quKhVEKKr9OLfEn24fOEwBoT
         sTGi5kbCF+EP4qUp47y0mJp98AR3HkydBuBRjIz0fiESzDl6gMStjJWFNRH5t/k87V+7
         ID8q+mo2tpRYe5yd1FG9LJTsZYpNu68kbZVhPOFFG0TqRUJtXqzeMAOnydQp4Fi2ISa3
         dplA==
X-Gm-Message-State: AOJu0Yx5TATRYNktwQqmly8gzhGUbn7Pf1/b0tCQn9BDB8ibGDi/lT7O
	A/JpXMRF5dBlCULHP8eTZqO+yKF/4kkrfcEbuzqiFuDyq8OZtFo3ffJW0A==
X-Gm-Gg: ASbGncvl9mcoG2uFcGuSh09U028ohVauKOrOq5vGgwXV8Pop3uVLTEuKqbN2FPP21L2
	tULvTz94YMiLsVaAP0bXbdwdSc52ZdiqFn91/ZNhLhvMtePIsUB/DLdh8FOdu5dbUQVODVh+uk/
	6ooLiOQd5XKokXrvaYFxoZVkrHrDvcs7JS+W1Uz5Bspncoff9090CqxUhI0flsA5qiJfrnOCEXg
	ScaSCdZI4GQc4/L+n+AS0CQdU8/0zhceSg4GWTGJeu81nidcz4yoFlHt1NPemr/+yxmBhYbx4A=
X-Google-Smtp-Source: AGHT+IFsX0Z4hRD5fhvMNcy5K/JcosyJcweJX8eK8nDcftJbFhXbfSRBYZvtJyc5EHfpJAHsHMDSsQ==
X-Received: by 2002:a17:906:f5a9:b0:aa6:a87e:f2df with SMTP id a640c23a62f3a-ab6cfce8a6amr1236776866b.25.1738344488397;
        Fri, 31 Jan 2025 09:28:08 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7071])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e47cf8bfsm324311766b.40.2025.01.31.09.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 09:28:07 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 1/1] io_uring: check for iowq alloc_workqueue failure
Date: Fri, 31 Jan 2025 17:28:21 +0000
Message-ID: <3a046063902f888f66151f89fa42f84063b9727b.1738343083.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

alloc_workqueue() can fail even during init in io_uring_init(), check
the result and panic if anything went wrong.

Fixes: 73eaa2b583493 ("io_uring: use private workqueue for exit work")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v3: BUG_ON() since it seems nobody checks errors
v2: drop kmem_cache checking

 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 263e504be4a8b..dfebd949b8f37 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3920,6 +3920,7 @@ static int __init io_uring_init(void)
 					  SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
 
 	iou_wq = alloc_workqueue("iou_exit", WQ_UNBOUND, 64);
+	BUG_ON(!iou_wq);
 
 #ifdef CONFIG_SYSCTL
 	register_sysctl_init("kernel", kernel_io_uring_disabled_table);
-- 
2.47.1



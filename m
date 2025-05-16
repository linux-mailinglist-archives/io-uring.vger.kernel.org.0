Return-Path: <io-uring+bounces-7989-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 653F9ABA0AC
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:15:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A44E189C28E
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 16:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E465A19007D;
	Fri, 16 May 2025 16:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dReseL/o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9BE1A256B
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747412100; cv=none; b=hfkULiNlzcSDQ8tEPXuDb85484OQlBEtz9qBxVK7HYK5Z5qCAPo1KRhhcG9aWKrrScPKxBRK6M4Yw3QQkYVXBvskAKAQBw+YLvsEP24xiXEzw4grzBm6u1qLShMQAO07TKaJXr9tHC2Ar/LV2Lr458Pnr997M4fgnBKR8itKx1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747412100; c=relaxed/simple;
	bh=2pY8FQZV45SB0qkWiEsX2p3g0KclEixblj9jbmchGL0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SnoChDaxWqrWg+9h6hXdixYnlQ5j0Wpl/NW6BekMxUkSBv9UpuEqYV5q6yLP3UqOmtzZ+49vlg6bWcHghhbSD9DUoZHQbcBE4Y9qW8LuIl3ziXMpEVFuNq37pkrVJgD+U4+byRA+CYYNmThKZVjDewx1HQc2wIKglFj3JmyQp50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dReseL/o; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-86135af1045so247172039f.1
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 09:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747412096; x=1748016896; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gyeHJ8D8BKlilez6xmuBX29fTEI/U+R/ypbS8BgkRJM=;
        b=dReseL/o0KRaQTK0kZKbHWYaCa/QWPR+kI0wtOwPinFRbWCtKoCXS+8lYHe0KNi78y
         GBLjpux8bXtjfAqVTp5/M5do/85RDveYHp2hVa6vIyuw+/yEVSgFp1ZesUeUCjEiZIus
         bZgz5RTlaYYdKqqmzmzDOWUj/qEdoa0PODrfkPME9uoFGcE5FzLAThPyNuczBBNmBUlK
         +lvRWn60jp7v1m/94xLJhhvT6fF1zOVxEaSAXSrEsYDn2sBPRT6Ijt67qmJfgWjxRbN4
         Bh64kL+5kM6ekOO8iCzzjpbOi1gbzk2lm6+sZohJfxzz/siwNftqBmPjOjJPjMo9uqw/
         lH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747412096; x=1748016896;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gyeHJ8D8BKlilez6xmuBX29fTEI/U+R/ypbS8BgkRJM=;
        b=Trl3dcBb7q2/EWo9NdXNg4i0i/5xCAjAiKRNAba3ACCPUH2Ql4w4QbigdlZNybh0/J
         yuot+CttTIOGSqgNcL7rZxMmC84mI6kwj8a1cpe0MTBuiKiUcVoVDXaijL1WBXbRrCs7
         40YVpB0eKgjlezCwd5DLSqZojlxUQ0bnU/fxSwC50DKUEwN6/xKF9Q68gZ17rZqJSBMn
         n9TdgEMJrL53UVV0wyu/wmz93CT729emES32b+rSM8oLsB2dIk6qYiIZ7yXg3RqJDL2h
         wEiXd0n4MkKYwpw3VpyN0coKJzX9M3bd73/tLgu5q2/YG1/9G73C0rjFLbEf9y3tWrN8
         nNkA==
X-Gm-Message-State: AOJu0YzBeglo15Ue2HciKSG41aLsIHO0SKxQZu+R0A8+xwFzqWYagV2r
	BzUI539vjBGymATTM49H8qItJPSSzcnGcNqSdMU42J/XKJhQNqeDlmukk6K/bEV05ZVKJ6wYuUB
	G28jC
X-Gm-Gg: ASbGncvNfQ3MfUgVuAFn32zigjIpeRwYstggeqkLIs+hobQ/+XUhE5VNxS+Z9wQn4aE
	kqUv8QbvdBSW2akv8xIP3aRnkeL4jggWNq8s90E0zAXfb0UoLybVpt5saaVptEAQQfehRohsIJY
	mEz9ibY/5MW5XrJfREstWx6WLPpaQi2EerbFFiPgl4TlHQLKCqED4Iel9n836POc5yleGQl8SoJ
	Cge9t8/Pms82mnmZLokJcgri80MB8VlN//pvqHDLr1Wzw6rh/dEZQfKjpDf7X8ZZjUfJ016fsB4
	GUjhHBFFQ/Q3Ud9vFUOWMQZdwpcPGJzwzvEWDp8bzIoYZbd9anH5sXY=
X-Google-Smtp-Source: AGHT+IFCeZzz72WqdaCbM4RnqioZJhYn0JIzoV5q4LZmg6hr076iNeUJBv0tgqJavS8OFyRT7h07wQ==
X-Received: by 2002:a05:6602:4186:b0:861:722e:2cbc with SMTP id ca18e2360f4ac-86a2327c37bmr522248639f.12.1747412095714;
        Fri, 16 May 2025 09:14:55 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc48c5cdsm467439173.84.2025.05.16.09.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 09:14:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCHSET 0/2] Allow non-atomic allocs for overflows
Date: Fri, 16 May 2025 10:08:55 -0600
Message-ID: <20250516161452.395927-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is heavily inspired by the series that Pavel posted here:

https://lore.kernel.org/io-uring/cover.1747209332.git.asml.silence@gmail.com/

since I do think that potentially increasing the reliability of overflow
handling is a worthy endeavour. It's just somewhat simpler as it doesn't
move anything around really, it just does the split of allocating
the overflow entry separately from adding it to the io_ring_ctx context.

Further cleanups could be done on top of this, obviously.

 io_uring/io_uring.c | 79 +++++++++++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 27 deletions(-)

-- 
Jens Axboe



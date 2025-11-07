Return-Path: <io-uring+bounces-10435-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A44CC3E338
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 03:07:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 723703A398C
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 02:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FEE02DF3E7;
	Fri,  7 Nov 2025 02:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="OYp4ubuT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E272D7805
	for <io-uring@vger.kernel.org>; Fri,  7 Nov 2025 02:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762481221; cv=none; b=XDDxf70Qq95osaVzOMhOgp/x6vQ1Zj9uyEhxrhlsu/66JDvYClCFmfXNWbFkW2aYEQBmB7/06PaMExvybe9Yg7j7D/CekV0j8qnfgX19VkxY38gTbWpbVzrFhDPdr0hEPnvHzc8uURd8joRLVnFVbQhJwK0uukMh44GjR3bfDnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762481221; c=relaxed/simple;
	bh=5/T0SIm0UdNO/IdzRZZKEiu//zm3DFK1QFan+BlZfc8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lD+SxPMoMoY+Qpr2r3FKkzhy6jaFeyu99c/fqAMP67Hn/n3fqRwBLqtQxEjszud5G+1LIWko5626aC8r/h2vpC9Sm1I2Hl0Uf0Wa6047y/PHSD1yjEgQP2TIA4tx23NxjDF2hYUsYUwHRz0Cqz23boO0VzyhweYGu9jTMtgUHJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=OYp4ubuT; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b6ce6d1d3dcso160171a12.3
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 18:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1762481219; x=1763086019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oWHtEzv8Rq5cRO8AqC7Ez/zeQln1yPOIQJdYebnSBzQ=;
        b=OYp4ubuT3gFc60iNpOyqfZR5wKv5fjTWfjquldjj3yOmqwOqHhb+gL5tBGy1h6g19a
         mE9JKBplmSkVKkEn3gsbnssVeL3P2OnVme1LfIGDUWl5uwketcnYSSPYd40ovl+AAtli
         qK20UzYrZWuzXHfZvM8pZD6J1OS8frr4sUeuoh+AKkoH53mA0fbtfwSUkKSjloevMJ8H
         BKbPC7Ggm5NBb6iCHtS/VLhpM2bxPrrfQKV92pW54zrGq7nwYO5NHJQ/ZCweBAVuV4JQ
         X8QjrT3Jou7mvj0bxG/giBOc833ri2zbOH18PTI/qb3Ld1KMUxR3ET8eZjBe147luRUB
         lIig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762481219; x=1763086019;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oWHtEzv8Rq5cRO8AqC7Ez/zeQln1yPOIQJdYebnSBzQ=;
        b=JsHnQmCxM4dijULGF4pxoz/NUmTdOnH1xf1sD1VjzAnIwrlaAZOdtUKk1KBIWvkMHT
         iuxRpl3XzZgTE2qAh7QTkaYaocrgTz3cYHEwplMe7ESHc+YhiaqJKYJ1IZ1yHFQgAbNB
         ZtrkaSi62l2WBVuDPTTVHQwaJY/kaTtYhaXoF2jF1wnXTvlouZW75ahScART1uVhS6Ij
         oIV3cAf0r1bDsem3J1iv/sLDyaLfwLDyePTCM4LK3BETxtseuCCRZp+Vks72I4A+FKK8
         JW3ZYXV13RxmScGzdoIA9lS59dLCNx0MPzfSNQpIrXOrYvnK3wxwKQ0xIcBtmGhVyz9g
         UrPA==
X-Forwarded-Encrypted: i=1; AJvYcCUCEATG3MFcB0VamCs8uSdfTJjUW5vhI6S6zFC95mnwhFdfvUQlSDPO6v7n5OrpmiKlsPR9ysZ6CA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3M2oxryEFkuHeaVWKeHRlKgLV/nmIw65MD4Bjkt7eTiKKoExw
	tHh3Ci2PKQz99ELeydR/Vju525zLjRA3yaTZf3hAlkGJ3drWuUN7OtAYUEXlCL7zKPA=
X-Gm-Gg: ASbGncuZJsIIxAqmNND4WfKyt8lMHcPuHEazPdGfztb3o8+srngR9UITd6H+SuUBO54
	kXsY/zWZwTr0RJY9f05vqsjpJXK03mw5HyWIBaH3ZZtCeWIXNTMsVHj7k/QjfKfnW5Ogv9aazG+
	xZ3Rhr1M9vfaDiURnTzbEJhg3J7W9V1ORJUYubyS1HUE7EA4G56zXf7i09rco2iAwWobyyuFjhY
	VOULUea87/gKFIf0b9LERJB2oQ2otb5Dd/bncF3qDP2OmndrAA92ICZti4LXfPgRfpmQMAhpkmf
	ED/uuu7jY2twD4ptJdBqQUXYludYGk4Ldak/cZ/9LYS8wMQncB00Lxhj6kCXXQy4SreCNc7X2nd
	3PKYDysii2k5CYFLLXZpQTgxbkVNzXsG5n2G2Y0Bvp3eYOoeiNZ98jLALHEy/ozgDclI+n+eJPm
	2OeEjg/rr11S5mE8MG
X-Google-Smtp-Source: AGHT+IEQ1r7AsblEW15F6NrWnCgQgZkngBPtkNTOIEI5NyInjWIPCo6YMVNtFNrYGdMqGrYdOjvVJw==
X-Received: by 2002:a17:903:1ca:b0:296:1beb:6776 with SMTP id d9443c01a7336-297c04aa6abmr21929025ad.58.1762481218563;
        Thu, 06 Nov 2025 18:06:58 -0800 (PST)
Received: from localhost.localdomain ([2408:8740:c4ff:1::4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096825esm43129885ad.3.2025.11.06.18.06.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 06 Nov 2025 18:06:58 -0800 (PST)
From: Fengnan Chang <changfengnan@bytedance.com>
To: axboe@kernel.dk,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	asml.silence@gmail.com,
	willy@infradead.org,
	djwong@kernel.org,
	hch@infradead.org,
	ritesh.list@gmail.com,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org,
	ming.lei@redhat.com,
	linux-nvme@lists.infradead.org
Cc: Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH v2 0/2] block: enable per-cpu bio cache by default
Date: Fri,  7 Nov 2025 10:05:55 +0800
Message-Id: <20251107020557.10097-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For now, per-cpu bio cache was only used in the io_uring + raw block
device, filesystem also can use this to improve performance.
After discussion in [1], we think it's better to enable per-cpu bio cache
by default.

v2:
enable per-cpu bio cache for passthru IO by default.

v1:
https://lore.kernel.org/linux-fsdevel/CAPFOzZs5mJ9Ts+TYkhioO8aAYfzevcgw7O3hjexFNb_tM+kEZA@mail.gmail.com/

[1] https://lore.kernel.org/linux-fsdevel/c4bc7c33-b1e1-47d1-9d22-b189c86c6c7d@gmail.com/



Fengnan Chang (2):
  block: use bio_alloc_bioset for passthru IO by default
  block: enable per-cpu bio cache by default

 block/bio.c               | 26 ++++++------
 block/blk-map.c           | 89 +++++++++++++++------------------------
 block/fops.c              |  4 --
 drivers/nvme/host/ioctl.c |  2 +-
 include/linux/fs.h        |  3 --
 io_uring/rw.c             |  1 -
 6 files changed, 48 insertions(+), 77 deletions(-)


base-commit: 4a0c9b3391999818e2c5b93719699b255be1f682
-- 
2.39.5 (Apple Git-154)



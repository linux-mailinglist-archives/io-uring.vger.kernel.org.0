Return-Path: <io-uring+bounces-10630-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9989DC5C3FD
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 10:26:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFB5C3AD640
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 09:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6147A30649B;
	Fri, 14 Nov 2025 09:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="AMh70ouL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336153019B2
	for <io-uring@vger.kernel.org>; Fri, 14 Nov 2025 09:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763112136; cv=none; b=pTThE7PQLdMCfZkX5NaHrkPkP6u3yFW3Yp2I0NL7lHx5Qj5GcNWKAHDVMuFsVp1mMu01kgXDhXJNKLt6EgVKgkfyRPD5yaoWanI5X2qCsY4yQvt4g0tQH6dw7FwJjnOvQCpm1JVZacae1/Y+PsW7L40xKjH+Bff+zANHhfx1K3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763112136; c=relaxed/simple;
	bh=3yKmCrbAdSfO2k3GcxeDVFzxOqz5BImDvVOtgCC29lQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mBaQ2Q3LXqnYOvIxyE60gTIc2H9UNYD2yswmulAQZE54X2q+0hGPpLWg/BAcfZ8Neb4glXYkpA08huXxjqdHqWCpxXBMrFkR2HQ8piv0XCXqck8ovP+EXYg9Hy0aLGzeWBVKA5j+sRRtHRptTzRI1JMbnGGTy/jWAZvflhLwrZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=AMh70ouL; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-29808a9a96aso17146025ad.1
        for <io-uring@vger.kernel.org>; Fri, 14 Nov 2025 01:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1763112133; x=1763716933; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VOUcl1KTNJ6yNbLI1Tyvpph5ES1zSXb7oj0QZ81RI5c=;
        b=AMh70ouLRszzEBY6WQZeYRCj1O4XxwjqQOj8XGUCFBNcIVfE9P+bAcsy2QMKVHj7K9
         zKbMYwESq3+4J54eIW4h3ofW7+19+oCd/fLKVhgapYb+uhhHLzelhDc4IgjX9UVvF6P1
         V9Y56unZ1bsHJVw+XjvEo/DE7yFD5oj2sj/MTlGWq8XeFuAK6QMQa4tAi+t/HJbyBa6t
         6kM/PBY8BZjkSugTDlP9ywabgXtJY1Vic7CpMnYC9gxbx8IlwrK8GbmFE5MDXQd/IzzQ
         rU04v3dxv9BW+RpD1IXTckglzGgKNaLSxTCH+7AIBe5CGPQVZagLUUr3zgE1vzn4bzdR
         r9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763112133; x=1763716933;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VOUcl1KTNJ6yNbLI1Tyvpph5ES1zSXb7oj0QZ81RI5c=;
        b=SbhTSWYALvdEz9ip5jKyuxGtLyhPkeTcYd1L9g1XlA0wyNwzZY4VUiZxU917WBAI/N
         boh5VCdj7Wg20k+2SdCeviTS7cmwvAWlibRRhabR/Sl/B/Bsi+L0zhbkOZTxor9ABAPI
         yryBr1nF1LR+b8af7sSAGNhHAIPgoPZAi/fDIYKmi8nqWuvEjbt8BOznY766nJZNqNC+
         6U7NCBvzZwiijXqAxwV5kzwV3c8O4KaZd+JdsCTzXksOS2dWo/gJGda9BMJwK4uvyR/Z
         nOVQC6xwhk0MbObWMYwmuGDjHPn+Fji46dMW7YN4gAHAgPiygj5jAFw2qDeNSDQJoHNH
         RT6g==
X-Forwarded-Encrypted: i=1; AJvYcCWfbIZv8nXkugM5ie49q2LOOMg8Nmt8BrINKkru1ykorPHudet8AY45hbViMoVfrtjaVI9f3Ms0wA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvhUKbhP+/xpjn4CbYx70aLODOFKwT3/hRsmQDeX4BUdVyaafa
	bGjy8ei0yzYLw6oYPtGEaOcChtqGvnXp2I6z2YgfgXr1lUhb4DqhSzRHtmz3UQEuteg=
X-Gm-Gg: ASbGncuzKvnnZZPCa6jJ/D1Wa2dN4T05ELPPJE5MiDF95F4agVxXSr2iAqosQH4viS6
	kpPHo+lTFazGbM2S2XG4FwX0FsGxE1jlYMMSU4+ZzQ1KtIGbnv3BCooNlFc54TamUiwwn/s90so
	Wb2LoVECHhvjwrkP01gP3Ew8wDHBA02NTNymzCBnHsGfpJShCjoFjulhb5nNabq3BXRYJmBjTXX
	QLlCHF0JKhoirKBvIQxnT90vPENvpTfN2dQLQrcCVS7fvh4qC7/ex8YTRBvN5yD7xkAcIiVgi3/
	R5Mk+UeUNTnWpWzx3K6+VKB4YACTdBwO+u3ucN1YDJrD/yb1DgSJwKotcERPFCQE08n6SycoTrj
	eKZb75WBQccXmYcm6PHwiaBEKExsLnQk9VKYisTR/1hyODNxLAlOwgix+SyMR95yqriGAxFpFwk
	AQxR83a5UFHoh81+VcR1ECZYTDWKhz7khX8w==
X-Google-Smtp-Source: AGHT+IF+L62VoDL311ziY3WGmIGqOUF1aAOhbYoj7EpJUNyw6PsD2tlvnXHX5j5jjprmk+4XNcS2IQ==
X-Received: by 2002:a17:903:198b:b0:267:a95d:7164 with SMTP id d9443c01a7336-2986a76b6c5mr23867635ad.60.1763112133120;
        Fri, 14 Nov 2025 01:22:13 -0800 (PST)
Received: from localhost.localdomain ([203.208.167.151])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b0fe9sm48725735ad.65.2025.11.14.01.22.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 14 Nov 2025 01:22:12 -0800 (PST)
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
Subject: [PATCH v3 0/2] block: enable per-cpu bio cache by default
Date: Fri, 14 Nov 2025 17:21:47 +0800
Message-Id: <20251114092149.40116-1-changfengnan@bytedance.com>
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

v3:
fix some build warnings.

v2:
enable per-cpu bio cache for passthru IO by default.

v1:
https://lore.kernel.org/linux-fsdevel/CAPFOzZs5mJ9Ts+TYkhioO8aAYfzevcgw7O3hjexFNb_tM+kEZA@mail.gmail.com/

[1] https://lore.kernel.org/linux-fsdevel/c4bc7c33-b1e1-47d1-9d22-b189c86c6c7d@gmail.com/


Fengnan Chang (2):
  block: use bio_alloc_bioset for passthru IO by default
  block: enable per-cpu bio cache by default

 block/bio.c               | 26 ++++++-----
 block/blk-map.c           | 90 ++++++++++++++++-----------------------
 block/fops.c              |  4 --
 drivers/nvme/host/ioctl.c |  2 +-
 include/linux/fs.h        |  3 --
 io_uring/rw.c             |  1 -
 6 files changed, 49 insertions(+), 77 deletions(-)


base-commit: 4a0c9b3391999818e2c5b93719699b255be1f682
-- 
2.39.5 (Apple Git-154)



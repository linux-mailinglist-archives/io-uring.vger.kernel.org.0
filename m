Return-Path: <io-uring+bounces-7224-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 269A1A6E3ED
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 21:06:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB74A1890AFF
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 20:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1AE11AAA1B;
	Mon, 24 Mar 2025 20:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="OeSvl8Vx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f102.google.com (mail-ot1-f102.google.com [209.85.210.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E72B192D77
	for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 20:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742846783; cv=none; b=kmw+NuI1zpP/wiorPRl215Kttek98hW2ZYh7Pb6Nq9zrYgHWRs8XztK9ACqI77Qz9uNAlMxsoc+e+rOgz3msqlTfAGBm/oR6PRoQDoULWJIXKPyPR3bQvPt+tHXsRmb0YT/ZPwVPmfBgJceOiFd2JRuqv+A5rx1Hy5/dtlD0R6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742846783; c=relaxed/simple;
	bh=RU4KBmaVK3ygmet+S+vCB8NQAqxuQcm6KN9RxfBHPp4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mc6gS9RJMoVJZf/d6YAxk1fXNKX2zWkSezBeRy7Wb4JSa1gEaOeIgISZxA0AN2wMBcFPIOJ1csOU3rBcF+5r7VPDC7Gsbk/FlK9fEyFm87r07iPUy/SaYodi76gsjveNGRO/e46pYJ4CkdO2+r2rqe6fiW3Ef2Iz6pLuWFy0bVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=OeSvl8Vx; arc=none smtp.client-ip=209.85.210.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ot1-f102.google.com with SMTP id 46e09a7af769-72c02e22d96so206270a34.2
        for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 13:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742846781; x=1743451581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qTwm9kKLcwau7i+44COu+WxPnQuj//ctrEfQZj6FqwM=;
        b=OeSvl8Vxgg1zNmkrzf+/gwkC1byPqftM8T1ljAntcdi6dkqsaudI6jQgHQY6BOd/jt
         D32zNRQp5JVmxx0212pJBTOdPPwEmeyLFeP5ftN+o89IkVKglm71Bw86hSEDghTI/9kx
         g3MV77vTWnnZttK9dzdlXKwOCnMKJSUqyDLdRP70IVQlo9pbYQlsATTZgXHtR1lgl7ZV
         4Sr/afRvtYZxG84JCpjbtImVQjvJvHESNKsDlf+SiZ4R27A8W/p9FNIA24FeHwfEiF8V
         zqDSO3C3wVuBj2/XIXNzpoG63ckkP0zR8QwvSUjYigd4jUIl1QGeLpyZVthHSi1gwskI
         BA6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742846781; x=1743451581;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qTwm9kKLcwau7i+44COu+WxPnQuj//ctrEfQZj6FqwM=;
        b=YqD6cr4B9W1LODv/ArkvApgooJvYTWaMHV3YL31k3/GZYt7suAkd+lU/auOSzmuTJD
         BYxThV0m6t+UZWdJUijBLRzbl0XCjsnYDuXBIuxCgTDCeh5MVoj4zgypNGZalJe+TFKa
         Xe3ods939VDuX5NtVK8LuSB9WJ/8w6pzKdgVXOQrNSn54pp81W2prMY2DGqvUeg/OgmC
         nuL0PIvj+tngwpMXCuAohpn9J5N3e30JyAg0SgaETmk2L8pSikPe+1+63X8MY5osBpxY
         XHGFhHqmz9CaCHoFBR4//j771mL1knp0gyVq2hvcr2BxSqu9YQhQxRtarIUO64jBuZuS
         ayNQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5L37EcVbxR7ZxpSiPLGth2HQS7ABsSTZ3a+wwkj9FHnhmcOezOdj8P4vOY6u/+OEioLBB6OJepQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxCIonMqQR+/hS/DLRr+8jbxn+ddIBhQdCKAlBGAHKHPkPRyQIY
	0j0EoxVkP0usqlDt0v7sjWuDHbCA8IdHcJURFtba3TboxDs2yGLJHvw+lANqNxXtlFqsppzBZ+Q
	vOLmGoiWdkZxkgDjdsn2VyRZD5csbyZ6XH3L2RPkLNQzgSViw
X-Gm-Gg: ASbGncu6ciZqIgHrFQPwxrg2qxBajEuF2oEXTq9GghA6PVI+1kikhzwmddbR1/2RtD6
	sjBfCJPm95Ftave70y7vRSsPqkxH5Hn8sHNF5IpCjB/2WFR05x0V96NuUnlLqVMbpeU1nlJC8ir
	HAKIonngidE6KNPQW/IVU1j9Mh1JHdKmVHsMOaNBBZllEE5I+20qOwOpkvH3v9KnKMb1E/I/fCL
	LdcACm5arBqypqnRyxWO7m3krN5riM/wuFmalz/Hg6UcYTSjA/FF28t75UkdKyNxZngU+Q33HbP
	3zgC2y5sMO8pwZwx/h0ajlNJjW/Cp1nfZg==
X-Google-Smtp-Source: AGHT+IGbzC5rsYnWtKfoFuox71C8ckicLGxH9xUNA20u9la2CI41xNym4wlWLHGUxDyKBzS1y+QuAI2Xu6p3
X-Received: by 2002:a05:6830:2805:b0:728:b605:4bf9 with SMTP id 46e09a7af769-72c0af05ce6mr3394263a34.6.1742846780972;
        Mon, 24 Mar 2025 13:06:20 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-72c0abb89cesm76621a34.6.2025.03.24.13.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 13:06:20 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 23E1D340363;
	Mon, 24 Mar 2025 14:06:20 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 1732DE40ADA; Mon, 24 Mar 2025 14:05:50 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Xinyu Zhang <xizhang@purestorage.com>,
	linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v3 0/3] nvme_map_user_request() cleanup
Date: Mon, 24 Mar 2025 14:05:37 -0600
Message-ID: <20250324200540.910962-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first commit removes a WARN_ON_ONCE() checking userspace values.
The last 2 move code out of nvme_map_user_request() that belongs better
in its callers, and move the fixed buffer import before going async.
As discussed in [1], this allows an NVMe passthru operation submitted at
the same time as a ublk zero-copy buffer unregister operation to succeed
even if the initial issue goes async. This can improve performance of
userspace applications submitting the operations together like this with
a slow fallback path on failure. This is an alternate approach to [2],
which moved the fixed buffer import to the io_uring layer.

There will likely be conflicts with the parameter cleanup series Keith
posted last month in [3].

The series is based on block/for-6.15/io_uring, with commit 00817f0f1c45
("nvme-ioctl: fix leaked requests on mapping error") cherry-picked.

[1]: https://lore.kernel.org/io-uring/20250321184819.3847386-1-csander@purestorage.com/T/#u
[2]: https://lore.kernel.org/io-uring/20250321184819.3847386-4-csander@purestorage.com/
[3]: https://lore.kernel.org/all/20250224182128.2042061-1-kbusch@meta.com/T/#u

v3: Move the fixed buffer import before allocating a blk-mq request

v2: Fix iov_iter value passed to nvme_map_user_request()

Caleb Sander Mateos (3):
  nvme/ioctl: don't warn on vectorized uring_cmd with fixed buffer
  nvme/ioctl: move blk_mq_free_request() out of nvme_map_user_request()
  nvme/ioctl: move fixed buffer lookup to nvme_uring_cmd_io()

 drivers/nvme/host/ioctl.c | 68 +++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 32 deletions(-)

-- 
2.45.2



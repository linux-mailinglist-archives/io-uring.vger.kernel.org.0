Return-Path: <io-uring+bounces-7223-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8208DA6E3EB
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 21:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6ED83B2FB8
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 20:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3135619CC08;
	Mon, 24 Mar 2025 20:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="EMpTPOyS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f98.google.com (mail-io1-f98.google.com [209.85.166.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3CC157A46
	for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 20:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742846755; cv=none; b=Xz6L2uU7S4awpj8MDcKMy0clJlQv1whOiiFaOZpRvLgjC8KA44cayqaEwaB8ErtgKGTSPL1tNNFDI3dUN8uFZHSQzuFL/MhVnvR3FkWN8vWv7wcJIEcwd01G42F+aQ3nnokW8Sy4rE/ENasXvyt7nbeI1tRK2d4GKKSEHaE914A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742846755; c=relaxed/simple;
	bh=0LC7Q01bxxbnCKtP7LMgIv4+nf3GB8o6wu8YJoicAZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkXdEiSBmxUTf1OMtr7J9d56cr/DeEy1aJ3Ay8t0jY6suh1WqpUO5sxZqPAlPIwrhrzS2ZNOGNyqwDV54befyLNVwD07+Eu1QzVUk03wxyH8O+pga8im34LtABvpZP8919iLc9FGHMHMbtZyoKGgQUI62t0Y0Oakhhtlz1d/Q98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=EMpTPOyS; arc=none smtp.client-ip=209.85.166.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-io1-f98.google.com with SMTP id ca18e2360f4ac-85dce1987e5so15820639f.2
        for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 13:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742846752; x=1743451552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLYdLYi0Kpc4+Nk8DSJMTWzWqA+/v9byHziOX03/Z28=;
        b=EMpTPOySdRcUTicFETqRG0fmMJ3ekNKJtomJ5kDKUIHd5/jVsnM+iZOt9HepyufrX1
         IJ+F9pcX087NDG+h2rFEauMZ/6/ctmfhhxXdy2sCiJ1Ay54i1LGihs7ZMyjFYqmXULco
         ipR4Gg1r5pK9VIeZytEt6vkVFJsNZN1zecT90/gOT3tjhXjz4m/8VdvzUzd1SNCMi3da
         +jjeGoMx+OAKA1G9poi02OzzASN5y9feR6IHBAzyAb19hZCjwtghbwee1HZh9IXCn3oq
         4ICttyYpFiZWdEmkHwJRGJ/urKqn5adU5uwhK4/v/FO/o1NYwIfjarUCfAGIe53Lc/El
         o8QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742846752; x=1743451552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hLYdLYi0Kpc4+Nk8DSJMTWzWqA+/v9byHziOX03/Z28=;
        b=LoxSNY8iZwNA8EcuD9c4btn8YHxCGdTl6Rv0NBGYJBAPkhGuGhdXxgLsovWEFgX2af
         QrX/9azFMrZ4d6pRo5pcV5cK6kNu9CUVzZ0R8/nK/+jSWZWEf0JPdSycGStp02MC0AKT
         wnpzBfcQ8l/RM3JYyPVjamuGZf7sq93WzjklyGpQzF7TxGZZixeH82U4uILQXn6Qzowj
         N4mhtaDK2pPrjM8QtO5V2n1CrsIAVex1NwWfqPGWQbYry9esOzTORVeR6Zz+29GxUI9m
         252BJYhjPQWpB0cpj54OZwTVCwvv7Z67O62nURX6n6RdBp1OHCT1dNz+exzt9ZMeVDai
         dD0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUOxaJjnOECTDmMb+4Y5VbVVbbeIluDTcwGwwKmQe3MO7SuG3G8CsWvluoiLM2JfyFstPfg1kbjAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzN4HLsu81JDHbJ4eI4EKX7mEBfRx0CnvyyF0Dnmv+JPv8Kg9GJ
	9u9Au3zy5XhC93acMgbQELlwE4Oz8B5957/ntIppNqZBwKe3qi/Vpuwl+9P3srWoIb+Uvhn4K8E
	UhVQ6/QQsVQLEuDmBQE8Wdeu+8AJ/vANU
X-Gm-Gg: ASbGncvMxoB93R1MmhPQISXrcH6dAC1q/noTE4GBPmbCum+EsIK4ZrSduuQqkR9SiiJ
	fKLjlmum6MInRBIOcdc1uWZezSS1OSeFbuxss2EXGB4RVTFzvYqf7ublT3QLEoGsM+SuSNhb2Sc
	AZYk+32FKEmws/7MvZjlwguzL7JMK/LnZr4FI8rSTGZPMC7F09zfQsMajD/GZJt7+3nj36EXawb
	Vi/90xbXcSnwCpc4CHNbGPJdiVB/bmVePkJeoaqngoz23wPb0mW2Q+GWCyGRJvwogjgJwrAr6ys
	iY2ZmUxOWIKoylAIBKO7BACI8C8EXGd+/jSFGO0xSgjkEs8r
X-Google-Smtp-Source: AGHT+IG7NfVe7U+p88IpRxBam/nm1KKUWSAXa7Zk+pdMgEJimwgpeukdWWuZoB24s3/zM5KbGcgbaUc9bdSA
X-Received: by 2002:a05:6602:6926:b0:856:2a52:ea02 with SMTP id ca18e2360f4ac-85e2cd45a5amr332775139f.5.1742846751879;
        Mon, 24 Mar 2025 13:05:51 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 8926c6da1cb9f-4f2cbe4032dsm371909173.27.2025.03.24.13.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 13:05:51 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 411AB340363;
	Mon, 24 Mar 2025 14:05:51 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 3C6DBE40ADF; Mon, 24 Mar 2025 14:05:51 -0600 (MDT)
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
Subject: [PATCH v3 1/3] nvme/ioctl: don't warn on vectorized uring_cmd with fixed buffer
Date: Mon, 24 Mar 2025 14:05:38 -0600
Message-ID: <20250324200540.910962-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250324200540.910962-1-csander@purestorage.com>
References: <20250324200540.910962-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The vectorized io_uring NVMe passthru opcodes don't yet support fixed
buffers. But since userspace can trigger this condition based on the
io_uring SQE parameters, it shouldn't cause a kernel warning.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 23fd22e55b76 ("nvme: wire up fixed buffer support for nvme passthrough")
---
 drivers/nvme/host/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index a35ff018da74..0634e24eac97 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -140,11 +140,11 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 
 	if (ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED)) {
 		struct iov_iter iter;
 
 		/* fixedbufs is only for non-vectored io */
-		if (WARN_ON_ONCE(flags & NVME_IOCTL_VEC)) {
+		if (flags & NVME_IOCTL_VEC) {
 			ret = -EINVAL;
 			goto out;
 		}
 		ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
 				rq_data_dir(req), &iter, ioucmd,
-- 
2.45.2



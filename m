Return-Path: <io-uring+bounces-3819-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0299A437B
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 609871F249D2
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 16:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A875F202F6B;
	Fri, 18 Oct 2024 16:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PEUHRgZz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844751F4266;
	Fri, 18 Oct 2024 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729268186; cv=none; b=l9cNLft7HMkyGiuykbXBTSkEyxN9LW2BpQAOQ608wRVr7Q0cJ43YA+nsfAbNWwjd64nVFU7z9t+4Cd/ym1IGXZ5Xb7m9zGn+5N0jat1mHRyo9ABIpyusjSdU8fKRT4x525RwAfzPPrgRbMDyIXXDwDCOjCiLfpDjbboYyhrXNFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729268186; c=relaxed/simple;
	bh=wibQo2950us28tv1DjwcUnXv7qQRyhUR6Z43GQKkfMk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PyqAwKGLdlSxeDUGX8D9P53YxDMpQuMrOdXdlvIc+HCpNKRKtKud/YXy+nBgXQf16G6cbkESd14vRFNQg7vTu+KAxgESaS/XUejQo7odYYT2psGjDj9RPg0/RZA9mGFAeQaFW7qrmXuf6VWhS54aiGHXA4nUtaQnfPxqNvIMvAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PEUHRgZz; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539ebb5a20aso2529992e87.2;
        Fri, 18 Oct 2024 09:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729268182; x=1729872982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N7UdTrbaZ/hJPfr6th5jKszoKdJHe7S6bjSoYVBHtoo=;
        b=PEUHRgZzHH+e2c6lrGFST6OVMGzXXmZVhEp48cRhoFXSzo3w52ae/ZMOd1f70OAvJ4
         Ph+/g/6TRntTSCoAq15QimIUuRt1rCecmPNOf7GHxbqOnLaymh7UhRb3k+hWe7utvpZo
         BlzTnA1T7DOK7E8yD9QA0lx5PB43bc3wrQawQMxndLayx1b0v49e/8SKPmslE4TMZPE3
         xHpnglwDTpyqlwOtpw4apIc7xnHQGojbWY6pggdzrxFUZZEKPwEHgsxKRdPn9FS9keTY
         8TawYOlhYjBdNYOulmZ8FcLEraRp3Tsu0Ov1ARPuH6AukduF9XMyOz8dqUgDjOEDhuRT
         0Rag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729268182; x=1729872982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N7UdTrbaZ/hJPfr6th5jKszoKdJHe7S6bjSoYVBHtoo=;
        b=JqVJnaA9Lm9EaMuQqZ6Yd/T/8kq7JzOFNCtdyiZY0ZvO+wQHwdihPtNSvGH16eK2kE
         GPQlxJlnQgSvhZkE1MUqBRz/KiwfEhdc7LbBIuhvLOXXjqlJzLPpni8jvfirsiBwmArr
         7syWP0N8V6QutINua24m8e7ISHAwlHqFfdwVr31yl4Nm9aEVtVMobEbc3TrCCE0hPrWz
         7DhplL5HmzymOuqNFlsftmhKRvHBzfkqwgCk24oAlJnxEi8t/vIpyUmSMAVqPKoQdhxc
         I8v+5GUTI/yzAELszXlAQ6BXpJ8ZcL0vJpMUdVmNY7TymjtlG87cevcwMHNUQfH+vMYG
         f61g==
X-Forwarded-Encrypted: i=1; AJvYcCVqUqBqPLirjHRCtWwW0k/LkISBXDUrZq5o0YpijhteqIKmAFfAuPI2cErFaLT1lERoYBg7+zGJ1UNKKQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyW4BBZ3gDAtS6l5+YJMmj8vNWBee4tCrGwNvE6y4GYsTMo9b2n
	0vWBMlbCaSKCDc3T7vkpjmYXmR4tO48wbxWsOacEetgP3GoDRbTutUkIWQ==
X-Google-Smtp-Source: AGHT+IHCGV45twwfqcMfJz9YHWQuN7/cuU2QIcKsAWSpTYsHu5Dhz68Kk9pWbR5+KOmbh2WK7Hu3hw==
X-Received: by 2002:a05:6512:12cd:b0:539:968a:91a8 with SMTP id 2adb3069b0e04-53a154f8eafmr2121321e87.47.1729268182055;
        Fri, 18 Oct 2024 09:16:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a68bc4cdesm113623266b.104.2024.10.18.09.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 09:16:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	linux-block@vger.kernel.org
Subject: [PATCH for-next] nvme: use helpers to access io_uring cmd space
Date: Fri, 18 Oct 2024 17:16:37 +0100
Message-ID: <c274d35f441c649f0b725c70f681ec63774fce3b.1729265044.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Command implementations shouldn't be directly looking into io_uring_cmd
to carve free space. Use an io_uring helper, which will also do build
time size sanitisation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/ioctl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 1d769c842fbf..6f351da7f049 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -404,7 +404,7 @@ struct nvme_uring_cmd_pdu {
 static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
 		struct io_uring_cmd *ioucmd)
 {
-	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
+	return io_uring_cmd_to_pdu(ioucmd, struct nvme_uring_cmd_pdu);
 }
 
 static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd,
@@ -634,8 +634,6 @@ static int nvme_ns_uring_cmd(struct nvme_ns *ns, struct io_uring_cmd *ioucmd,
 	struct nvme_ctrl *ctrl = ns->ctrl;
 	int ret;
 
-	BUILD_BUG_ON(sizeof(struct nvme_uring_cmd_pdu) > sizeof(ioucmd->pdu));
-
 	ret = nvme_uring_cmd_checks(issue_flags);
 	if (ret)
 		return ret;
-- 
2.46.0



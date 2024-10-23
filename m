Return-Path: <io-uring+bounces-3946-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6268A9ACF99
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 18:01:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16FA728151C
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 16:01:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F521BC065;
	Wed, 23 Oct 2024 16:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vIAvNGBO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CE13A1DA
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 16:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729699271; cv=none; b=fn3bfROqf5kJpRgbhojUzZY2DdzpVEETw6Tev43JCkemFYUEl6dPkn4xwU6rtGynx+nkRtbpjVlK2SpEs4nWyMAWw9lZP21Knqxsrbg85qD3neLVurVCHGOy8obW80URrsKIRjfI6+HkpgMdJsNn3dQnKQVAhz9FfhB5wFOuUMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729699271; c=relaxed/simple;
	bh=qchMT7hbIiEyogRsYCkZMk7506oZcyRjnmUUJY+D3kE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=jkxzv9v14xdvY3OLvC8Fto1NEiejJOIFSrI/TnLSK6xWRNSg+7xarGN+lkmtZEi9vQakgSB/byLl5YfGL+278KpZpxoMn7P8u/HxBxfDNV0ARtMh3GL/Y+PhMFsfGKsZsgG/2/E0+As8hr4FlMild6Fu/WCX3nBxponEEyso+lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vIAvNGBO; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-83ab94452a7so237749639f.3
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 09:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729699268; x=1730304068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=K42NlZY9h6St9EBsFVti5tQjLDPA9y8WdhV7abLF5GM=;
        b=vIAvNGBOq0uBZfIIgDH+HwpOtfMT2zLC4jHcW5vOD+33Jns/DFVEUfSTh45on55lyX
         MLbtKbAb5nt9Hi/NdNbZYwneHX4UzZhfALai0XdwuReymrtwZI7ucqiojcHbZQh0m8ra
         lcyIiGZfUrzNQaFb7AAoLWkjxanynonCbNQyrYvqeLClRTdbkLIF4lOx+UUZtex7EE70
         vqB6Ff9Z5btwqmYQYyWeds2vXxZ7RAw0iKnz7n7ve1VFBm48Lzdo5DKAGC7wdSL1qtqe
         6OSTyHJnxxQgQp0vZ2dY04lVJhrWjO34zy1VXkiIhC+neqnaoepprfl0NszBka3MbyML
         35pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729699268; x=1730304068;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K42NlZY9h6St9EBsFVti5tQjLDPA9y8WdhV7abLF5GM=;
        b=C8J0wvZ//SMwo5Lvw98sqmdDmyBWj+Di/mL9vFjJKEGQtbywIFqWL1ApCEg8QUgm5f
         WvetO66W57Fc8bwS/+QOXFUCvBm+UwgzC2EM0fGPP6GROfmExKTtzgeEaukK8o2IBfkt
         6gUq8vebP4VgkiU/pg/UvWoFxnrKPB2MCfu92VoSCnUWdDkv3fvfuDCZ4No8qu1cyCla
         w/yzkrlJX7lJOF5sCidg7+x7H4V6ZvAjlAzlO/vo5vJ6stHHke4gklPVMuFQPtdh9dIy
         MkBZMpUMqZ99Don2idMLkt3SVfzXKtD9HeUCGGQMIwenNRa+tDKoORBFv5yOKZgD5RYe
         USKw==
X-Gm-Message-State: AOJu0YxsuicUwhCCJrmHuDuZQuhrSdfqw1PsJGgvNb2BHwlt6oB2OVdD
	5SQaj8Ep0WmC7qvVeKsjXNtvaNpwo1kmF6HxEVtDofVhcRE9e7Dg1ZkTyUSi5YuN4ZaEBicLBnE
	g
X-Google-Smtp-Source: AGHT+IGFz8Wj8l6STjLErMifb5cZTPCI1WjQuyVXvoCdOJFnGPRTtdXEsXSR86YC/BJp2JDzeyMY5Q==
X-Received: by 2002:a05:6e02:1448:b0:3a0:5642:c78 with SMTP id e9e14a558f8ab-3a4d599d224mr35171605ab.15.1729699268019;
        Wed, 23 Oct 2024 09:01:08 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a6301ecsm2115191173.135.2024.10.23.09.01.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 09:01:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/3] Add support for ring resizing
Date: Wed, 23 Oct 2024 09:59:50 -0600
Message-ID: <20241023160105.1125315-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Here's v2 of the ring resizing support. For the v1 posting and details,
look here:

https://lore.kernel.org/io-uring/20241022021159.820925-1-axboe@kernel.dk/T/#md3a2f049b0527592cc6d8ea25b46bde9fa8e5c68

 include/uapi/linux/io_uring.h |   3 +
 io_uring/io_uring.c           |  84 ++++++++--------
 io_uring/io_uring.h           |   6 ++
 io_uring/register.c           | 177 ++++++++++++++++++++++++++++++++++
 4 files changed, 232 insertions(+), 38 deletions(-)

Since v1:
- For SINGLE_ISSUER, limit resize task to owning task
- Fail the resize if the operation would result in CQ or SQ overflow
- Expand liburing test cases quite a bit

-- 
Jens Axboe



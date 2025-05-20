Return-Path: <io-uring+bounces-8049-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2829EABE4E9
	for <lists+io-uring@lfdr.de>; Tue, 20 May 2025 22:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 839177A19F5
	for <lists+io-uring@lfdr.de>; Tue, 20 May 2025 20:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 813542882B9;
	Tue, 20 May 2025 20:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SyZvc1p3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB5026B085
	for <io-uring@vger.kernel.org>; Tue, 20 May 2025 20:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747773439; cv=none; b=WiYayXDRpo1VFMTfuid9vdBYcM+nAnt/sw8I3mt/ahvmftQZChAN8JfdtktwTVNDfVteCX01SlepfIo2PuCg/LnSJpt+dya4kTlFoBV1Ks7XkO8JBX+SfMGdaVMfia8X34hES93ETUO3Ech+706OmRA+71cScwYxcgSFMIPuWAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747773439; c=relaxed/simple;
	bh=PcGonA1RR/Bh4aDPJWXGR/GCW6N0h55uO6CJptM5iA0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YP9c8u3ClXQ0n/5V7+eg8H1CssTgLraNTr/f8fmM3z233BBW1S1zF/OL5bT8bB2LeJFpUNX1tCIeoTJnLUXHRhhzXSmEHi5XMss2c73gg5Lx4IQvXXIKvHIDIQIZwJOqRAEogb+5H4kPfSrJ818a6G2PisafbN2y6xSoO01oPuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SyZvc1p3; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3dc7c19a4c6so4197975ab.0
        for <io-uring@vger.kernel.org>; Tue, 20 May 2025 13:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747773435; x=1748378235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yr2qm/uVt8l/rpjOe0yZQh8gZ09b5P0fXzbngb/+feE=;
        b=SyZvc1p3eyXk2rRMDqEt7kQsTRE7vy4Ai8HonGJgyH8qA8Y0qFrQwbD7/6Falidal5
         fIb6wD5wAYen7CcBaQDcjY+wFdMqgqPdoNy3ByTeF2tC25PvKZNY+XhavaYTqYASc81L
         5lvcYSfYbx7OQm35dKEg5xJOXW4+U0R5jpF0e2nPrkryqISDrKx1/4AdE59sT8dL8cez
         Er7h4+1ojYQniPU7dDn+MmWhbixvgTfml/6hBfCKw/+VyVM9QiCotF6qXT3BpZ19JYqg
         pRvwr0A5A8YSHLCuwUBjDEGzr7wG3S92AuIShdVJhifO9Z5aOrKsP/QoNwLIL71BnSO5
         oxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747773435; x=1748378235;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yr2qm/uVt8l/rpjOe0yZQh8gZ09b5P0fXzbngb/+feE=;
        b=PPEU5nd8tP4Sk1urhicMj8k0PpFg2C0/jctbve5QNODQfulNmVFYjggKnDu9278DVW
         sjEWhki9C/Pok3PkPBN9/Kzc0T24u0qcbhSVbMag5Pfb6hZ3iDP0QXI2OEnAy1v5FEaV
         3mIvDs0stSn2ftl5Z9nh14WzGOOtcmUJkvykUtgHesUdVfTQY/wO5wurDyHpK8zCyBDU
         whfGzH1igx/KLUqAKGL65k1eMV/mHh401c9mlk9w3RoauwmSXIb69XNKrZdPYxXXQlJY
         EwlFgorI9rg/UVq3km3jzBxmlQZJdLFCi8TOgpf5sGg7OuNAHitsfUt8qTb+BdsZpBo7
         6FCQ==
X-Gm-Message-State: AOJu0YyBWmxgm2ZNEDUXUdRHFKxh6FtXPib5I8yPQCNcG2ZqN9vj/B6L
	vKfyksWT/9YQIR+Jz6+lRu43uWCvBmaVMbUTt157Ul+Vy1iIXuETcct3BrSyZp39h6M=
X-Gm-Gg: ASbGncuaV4pDyVu5n8/H3LhRKtIUy0VUkdBuOsaPzq/w2QwHRleWcqaJsmqpD4IOkNH
	QzkadgbOIRldaAKyxp7JRuWGRzzDcoec5tQh4lVFr0DzStiKlmRL8FwtFdrL+zNP8omM7OacMPa
	/F8gRGoy3/M/vzEDAKIBqky/7C6FFmcJFTeM7YAY+JT4g8bCmYyRBT01K8+TZx3Po0yu2O3t6nd
	sj7i3iruWrlLwOYjUzaNEu47mAnDa4ldQmWy3ii9hFpMh38Uc0ZIB6b1LbgP9nd3uHPvHUBkNZd
	9KSC3Hoo4CZULxdEZ5u3SI9FjFZVTHyjMK7CSwUumw==
X-Google-Smtp-Source: AGHT+IHQOfx09EhKv18CXsHHzPjzP2hJg44ctRPVvRhmzfoiRLtIk23NWCiO4sg7r/4nts0urSf4PQ==
X-Received: by 2002:a05:6e02:1a6c:b0:3dc:8273:8c81 with SMTP id e9e14a558f8ab-3dc82738eadmr11155935ab.22.1747773435659;
        Tue, 20 May 2025 13:37:15 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3d2b49sm2388684173.59.2025.05.20.13.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 13:37:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250520193337.1374509-1-csander@purestorage.com>
References: <20250520193337.1374509-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/cmd: axe duplicate
 io_uring_cmd_import_fixed_vec() declaration
Message-Id: <174777343432.778148.1451499189557344108.b4-ty@kernel.dk>
Date: Tue, 20 May 2025 14:37:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 20 May 2025 13:33:36 -0600, Caleb Sander Mateos wrote:
> io_uring_cmd_import_fixed_vec() is declared in both
> include/linux/io_uring/cmd.h and io_uring/uring_cmd.h. The declarations
> are identical (if redundant) for CONFIG_IO_URING=y. But if
> CONFIG_IO_URING=N, include/linux/io_uring/cmd.h declares the function as
> static inline while io_uring/uring_cmd.h declares it as extern. This
> causes linker errors if the declaration in io_uring/uring_cmd.h is used.
> 
> [...]

Applied, thanks!

[1/1] io_uring/cmd: axe duplicate io_uring_cmd_import_fixed_vec() declaration
      commit: f1774d9d4e104639a9122bde3b1fe58a0c0dcde7

Best regards,
-- 
Jens Axboe





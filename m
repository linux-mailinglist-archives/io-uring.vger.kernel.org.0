Return-Path: <io-uring+bounces-10138-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA53BBFDC64
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 20:09:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54CE41A0493D
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 18:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 978042D0C60;
	Wed, 22 Oct 2025 18:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P7Qo1HIO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16F32E8DFE
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 18:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156551; cv=none; b=WklGrePB7EDLVeLPEdFMowWLxOfGrLs6VyQCMV55+QrygiMSE2QV+a5IwnwKWH72bn63BwW98iWnNBxKBcB1I7mHc5adb+rlQRBKS3Fb8OMCDlapO2DrDHpotPzWSaqqunKCo1I70LewgPeefaAqB37trwjiNTsstghG1STGJEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156551; c=relaxed/simple;
	bh=H4kVfb570eMVCeYl+Idfz04QOrqPvCiAiwptgN0ZmmM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VyD/M2qKEEfeq8XC3K4WIwdntnOiFOcuPPHG5EyaPsWd3dStd+7ykL+N/7N2MzoHopPPBM7xrODhPZdXUXsARbz92eFHrqc0bRp6qcA8Xug8gKAeF8chnyDA+06V6mOIe0irCh51vBp2BG2Xi4wrCABnnJv9yIcEL+8cmGN7Qr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P7Qo1HIO; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-940e06b4184so347560139f.1
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 11:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761156549; x=1761761349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4B89QQHAoLI6cZxmkAmPH7xuXZM9tsR8X+ew7/wdgfI=;
        b=P7Qo1HIO6hZtYu8Qs1xj+kN0ROWO6YTtMp3XADki8O4EXrW0AjFNHghsFw53NMQSkw
         29kG6J4Nw5M5jviNlOpntQtdY8qQbDXuvR1696m42kTG+i3IZeA+m+0A6rSI0KaBW89R
         PCbN/ZXMLicFIPNwM+bftmlyeA5mbmuz+9ubN/x962G6w5thGgbM8kg02O/1hnm3qO0E
         ASqenjcf/J+4un4D5mvsMUERmCVDvFuHsTqa8f6u3HOnnKcIWBzWWuxJYbiX6FTgzUYo
         OWTNzeQsaN1O8Vgbgi+Np0wUvyrpdPPoUCJ4HpuMWjJVjqOZ7/l+9nZYdH0TTpnIahXC
         W24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761156549; x=1761761349;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4B89QQHAoLI6cZxmkAmPH7xuXZM9tsR8X+ew7/wdgfI=;
        b=YrH3uR4D7cqDAA3cGVB04jUOv00bKIGlBeAExrxiemVJuDWJCKA572o1iWsURKrGDz
         GaXap0cnqDonlyi+nwwa/Pe1BuyMHPIc6OVw9I9rKGYc/RmRkx+HQWf/LbdLC7qwXpLb
         RNWlQA/k/y+00TSLCnS37nCTZV0KKI6IEsxJZCMBVfmov0apnqz0j7NDDthtu8BPysPt
         93yBov53nMqcxupezcqUZL4hj/ufh794/xpEpJOYjhS5kvUXoXFy5qad1wFk/owDHMNe
         WayA6Rn1zgGtMe/oElVLQwztHJBRKBMfn8QV8WufSB4uEvsuCH2aVpIff+gkKvgLii7z
         0yjw==
X-Gm-Message-State: AOJu0YwE3vqdW3YvFaba71LPMX0VsQY1tEsFU2rjJdLt5S4rCHhgvJSR
	KvhVwF34mFjuROob1snlLCIZEksaMjXUCCQktB/C2KreQu4idmVWXYsOZ4ejWZKZoyk=
X-Gm-Gg: ASbGncsWYlmNNMuITt5Te74P4TAn7ZmbOwnQy+vD/f5uxM3ACqr+nKTOYXBNtybXlHo
	/V597Teeqpo8eW61tZYsRTfiBUWbmYz0AJmzTmDz4X7jiRZJnsJeG6gzlAhBLUE8HcOivDCuEVP
	O7mjbxZBJnxvy24M3t86QJlL1NWaXQj/XQKV+jnvIZoio2nY0wdvQW9nE9uAJGupR6lxNZkoBOH
	DCkAyAiLvkwRYcYps9RtCGUp+YrNpOkz1MMfVfH1OTMm+KcurvifdkoXt44xuykttn7WFSHOatV
	fF/n83ShPa2dnyt/TXQi3NJC957l1TntHaUH+bRaELjUbf5Lhhp8KYMP1GfuR6Fd3Q3HS3y5Y/M
	rIm5RgwJafj/ay9NxY6l/krQeaTPEBuf13qbhASTOSWAFCradi93rzPeWDiUnkvzLJGg9UeO+tR
	ucYg==
X-Google-Smtp-Source: AGHT+IGw1UHqStrwRmE8a9X/c2SSobdk+Zsj7JLQipRAE+tEIxZV7H6CK/wljFcQ8cn8tJjuI+b03Q==
X-Received: by 2002:a05:6e02:188b:b0:430:afe4:6a4b with SMTP id e9e14a558f8ab-430c5294d91mr310869825ab.19.1761156548798;
        Wed, 22 Oct 2025 11:09:08 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a962833asm5358326173.25.2025.10.22.11.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 11:09:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Keith Busch <kbusch@meta.com>
Cc: Keith Busch <kbusch@kernel.org>
In-Reply-To: <20251022180002.2685063-1-kbusch@meta.com>
References: <20251022180002.2685063-1-kbusch@meta.com>
Subject: Re: [PATCH] add man pages for new apis
Message-Id: <176115654729.154128.7783815780379742559.b4-ty@kernel.dk>
Date: Wed, 22 Oct 2025 12:09:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 22 Oct 2025 11:00:02 -0700, Keith Busch wrote:
> Add manuals for getting 128b submission queue entries, and the new prep
> functions.
> 
> 

Applied, thanks!

[1/1] add man pages for new apis
      commit: 35a7e0a0bc69178cbb5ab3ffaa453a7f5a481333

Best regards,
-- 
Jens Axboe





Return-Path: <io-uring+bounces-6861-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A4C1CA49B86
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 15:12:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B78C1756C4
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 14:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3008826FDA1;
	Fri, 28 Feb 2025 14:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bCGnvShL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD13D26F479
	for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 14:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740751843; cv=none; b=lbyhkyIa8gTQDgzqGp8Pl4XZmGLbX82tOgB1qdkVVKkQWlbKeSNn2XJIwy/qPKLbNI0LctnlPw8mjFEbYb9MWEf2sk2DzUNhr4KYfm8LEeF0IyDl0xn7N6QWVECaqYGO9CBZxRfkEciATeb+kxnMzGcRD2bpQrujXdhid11Vtng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740751843; c=relaxed/simple;
	bh=qlU/sGPMC0tcvat1IxiDyGf5cOV/DzV5KKedIaP0o5Q=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=a0/5vnovNv+PRyqTZ7UxxbHAHdPAN/bcHXihB0Ytrvd1bav6sXp+CDz9mvqxBz+U08nDib0yhLobUhGRmPJ0PHgNURVCKbzhY8dBemFPoJsx5xgW+mwlR7VctOxElYtryryfZlV/NmxUHI8iO3zLLXnRflVZEF+hx/eOr94isf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bCGnvShL; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22349dc31bcso39633715ad.3
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 06:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740751840; x=1741356640; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2FhVQYh5w7G2tFTWIPVqXBj3p4XzU1ssQQXEfH0pLCQ=;
        b=bCGnvShL+VLsSybuTq7o90/EqZXLhPkdhj7ywwg5MJNnU3J7GMkx+KHBzodawa8fJI
         NfQCJMDe3ol3WpFgppInxjjm+14eJv5FJplVCx8yWhbK6c+O69BT2cgtS5XoEYG3+CqG
         QBquTABkdjJ+l5KPRA1zEC81m9oYzJhv7GYlYJUkyAnfIE9wQ6/oXSotAlzEJII7Tfss
         HY6PF5J8VQq05YT8/TemmVocx3wuLPRJIFs/HAjk/GeZVNRUUiCzJ7E1VYMrFORvUlrG
         arzFhwzfx8djFXC77KYMocgQH47EfPVV6ZgnCG+FQPOG6uJgbB//Ya8Z1gaL8acs/UIZ
         kWiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740751840; x=1741356640;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2FhVQYh5w7G2tFTWIPVqXBj3p4XzU1ssQQXEfH0pLCQ=;
        b=K6LBMzSaFdnn/AZY8L7TsIxGtJK/pJ9pky4Z7P7K3gAnVYNX1+K9i11rK8jNmmw/sd
         gZRzEv1nW6mzhT2emzMuZOCFXIL8LStUx4zcgOSjG39+Vt8wZpIE5ABC38Y2OFYRPlhm
         bmSvpMB6h9uXyx8s7HMO5zzy7Jkbg4jF5v73arX5A63vcMz/0Mug3gGKQERfRJo/KyZm
         DllEovk6/VgFZdXJFym5Moh7OWqR0ue3NxGt443fzTUtk1uJ3PC60n0Cf6v/LWzQak8H
         ie/Rrfcp24WAy5tLw75K8gVd+eR1ws6/aZ/bPw/Uay7PRAdm8iitSEaWddsK+3mO5ny8
         c6Ig==
X-Gm-Message-State: AOJu0Yx8RwwMdltcgiNRfQIYz2lU4QOuVjNwK3FG1OJzQRTD1yG10f6p
	XzvKS7qGrlcFiNKGvyd61/HAcRbhbY25OXwUIT5zO8z6yl6/WRfcaoUXmZZPfEIxxiPltSstn9U
	L
X-Gm-Gg: ASbGnctDbkJ40w3/AEvNTSxW/29e9ETmLMQL/uNThtcb7h3PujeDciikZtD4ke8ZoVO
	u7TF0MtPImP1ik9p4T9ly8edFQWZiv7yIoAN45KDaH3R0CC078YaFbyhrWcOH/UlQE3QoJsKECw
	x/ln09sE94jwqMk79dc5rxB1BcePLo6pJu1kkwZu11WUsjam9VN/GGIT8bwFS/tSDKncEcfJX5m
	/Ac3fTh4Id95LiUwe40C7ZyF/7xKmHUNwqZ2qRtpgSWsEFpCF2PLYFHD1cuErOSTpW88H4YZxEc
	6DHvvGb12ts46PRXa/s=
X-Google-Smtp-Source: AGHT+IHINitedHzgVwZF1yOEJgL4V45gjKeYumo7f+TblPD40Z4GMCLL0G8SYDDkoRRYWqaP6hsCkQ==
X-Received: by 2002:a17:903:18a:b0:220:c066:94eb with SMTP id d9443c01a7336-22368fafb28mr51266745ad.25.1740751839872;
        Fri, 28 Feb 2025 06:10:39 -0800 (PST)
Received: from [172.16.2.60] ([4.96.84.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22350514239sm33211005ad.219.2025.02.28.06.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 06:10:39 -0800 (PST)
Message-ID: <6978bfa0-3fb0-4a4b-8961-56996d3f92d7@kernel.dk>
Date: Fri, 28 Feb 2025 07:10:38 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.14-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single fix headed for stable, ensuring that msg_control is
properly saved in compat mode as well.

Please pull!


The following changes since commit 4614de748e78a295ee9b1f54ca87280b101fbdf0:

  io_uring/rw: clean up mshot forced sync mode (2025-02-19 13:42:22 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.14-20250228

for you to fetch changes up to 6ebf05189dfc6d0d597c99a6448a4d1064439a18:

  io_uring/net: save msg_control for compat (2025-02-25 09:03:51 -0700)

----------------------------------------------------------------
io_uring-6.14-20250228

----------------------------------------------------------------
Pavel Begunkov (1):
      io_uring/net: save msg_control for compat

 io_uring/net.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
Jens Axboe



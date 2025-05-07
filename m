Return-Path: <io-uring+bounces-7893-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5D3DAAE8F2
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 20:22:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85CB8174DC9
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 18:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25FE1A2C3A;
	Wed,  7 May 2025 18:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yt3DtsqW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550777263D
	for <io-uring@vger.kernel.org>; Wed,  7 May 2025 18:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746642046; cv=none; b=UVdmaw0bGHYwb2TzzYL/JdS+LmWUaGVfVwOXL0gCK+w6oVR2B5cOTXDmNJQfiwOLihPMDsMou3RWgspPC7abuPr1itWKafPgSw7bc2mmaMKeWya39TJEkMiVUaro1GneWUEXn8tPH5YSgJLE9GBNA0Z5BIBSrslVFjX3I8L/Q0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746642046; c=relaxed/simple;
	bh=Dlbrntof8PkxCYt7Bp4lDBBDzE/+wld6bvSkS28DINc=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nztiHLKGXMdlELOJauvwknUnqYOuuMUx9Clqa/qnfvPfGqLc4SFudxORiz1/ub1deS/U4Grq9etLn8Mx0JG1bK2JLy9gjKkZvL6ScRtAiV6ilr4CECZythAWu7wfanG9rdLvMs0XCrS9cFt2uOqDyhTrRgjCEie/kRPS5gdNdvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yt3DtsqW; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-86135ad7b4cso5899839f.1
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 11:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746642043; x=1747246843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Si6UQBGdpzeUdmgNGXAsRmGfZlP1EEBF4cS+W9fRLk0=;
        b=yt3DtsqWLYPvNZxp9Lhp4Df+4IVoK/o5dpwqSTpnknGaFm6A8UBCutcwfC/LnNflUR
         L3n/cwjOYmTImspFu2rUz9mgFPEFAhNvw0kaFR9FlV7sLqjCALDUh1k+aEN5tckiC7C1
         +JP2+qkJixmonoSdZ30dsqJyWDOHQM6EELDhR6sd1xBVkHIqSvB8Nbtz0rHVwuPoee6A
         YX5halizPTUhz6sGRAo/MFi+2dJ87lP58dylPaKdaxwWbUAlDWbYV5pM81NywMvQxGm+
         5v/kIok3AzzSwh1jchmk36hennHqdmLs1U/lPPWskSvSjWbLJUjwLU09D2pXLTPRFppI
         7GHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746642043; x=1747246843;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Si6UQBGdpzeUdmgNGXAsRmGfZlP1EEBF4cS+W9fRLk0=;
        b=ocUwxt+XqNyOHxzN+3DHO6eHioQ+uNzzx+0BHQY7WWDaAiTmiAGdy1EgNopJgW1xMr
         jDR0senElCDRikNPdbZvwjYGYt7EGmizd89lfMdnByGFt+MHNUInXaf2hAd8tQXfNoMu
         +Letx45C+HIjXlTGaabCX4j9aXhE2p1DMD9jtPpEb9cM5hr+SaVRTwyLxJGKrzd6k3PF
         QwoEaNDieTxc2LVX/52d1ZKZME90DI/4oSMYjMgL+nffWSC/YAtdTF3sscXDc1Pr94p4
         toWeW1TB6n8wU04La+Q87gR5aT/GO7dcnqyRHfuGXwRExDslE1f0oyYQd1T04stfpLNP
         i6Rw==
X-Gm-Message-State: AOJu0Yy0mpgPx0uTExnDpQcvjmTSQMEdDtLvjQXnKmcH+moPmGaW5kz0
	AnAYCE7M4MJLYXqfZjOtfl3t0QHI3qCtmpkn5a5lL9akRDdnEYfnajjDhXndgN0m0VLHPZKHGnh
	8
X-Gm-Gg: ASbGncsikbv1s+7ihTUqCymYDW4RqdqaT8rDsdBAo11CatYqaONmRLDHcnKfhGsxQPn
	UOQtA0c830iYw5E8rs7FPVLfGSirwhTXMhtk0vhKyIuHFEWo8Gq0FnTNW0w9G9PCWK4duZs4ctX
	aMDvn79Qrq2n5cj0g5ldlkPmMIpj7voALkA3ony0Gozd4cwHCiCOfh1m474i5fzT0av3ZNstFki
	hF4ZgBYD0n2ZvprDCbNytLqBziKxaGtzPE18uX92MJjSyUnu7jZN9LqKe7hoMfoP+UhS8KXYGoC
	RgyFyvQATRT1yqjTUpU34TkwUwm8ZJ+b0Ry6a1j3mA==
X-Google-Smtp-Source: AGHT+IElfgjqAqrJT045OyvhwRI60IVnlZTyy8xKkkmtvYTsHYIslKdGYdJzMiFuzerCOI3xM7fMEg==
X-Received: by 2002:a05:6e02:3485:b0:3d9:6cb6:fa52 with SMTP id e9e14a558f8ab-3da738f0dafmr53254455ab.12.1746642042815;
        Wed, 07 May 2025 11:20:42 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d975e2a1a5sm31790295ab.6.2025.05.07.11.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 11:20:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Haiyue Wang <haiyuewa@163.com>
In-Reply-To: <20250507180051.28982-1-haiyuewa@163.com>
References: <20250507180051.28982-1-haiyuewa@163.com>
Subject: Re: [PATCH liburing v1] io_uring.h: Use Tab to separate macro
 define value
Message-Id: <174664204176.2018366.11509995717397363155.b4-ty@kernel.dk>
Date: Wed, 07 May 2025 12:20:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Thu, 08 May 2025 02:00:35 +0800, Haiyue Wang wrote:
> A nit patch to fix the Tab style for macro value definition by running:
> 
> diff -Nur
> 	liburing/src/include/liburing/io_uring.h
> 	linux-uring/include/uapi/linux/io_uring.h
> 
>  /* Use hybrid poll in iopoll process */
> -#define IORING_SETUP_HYBRID_IOPOLL      (1U << 17)
> +#define IORING_SETUP_HYBRID_IOPOLL     (1U << 17)
> 
> [...]

Applied, thanks!

[1/1] io_uring.h: Use Tab to separate macro define value
      commit: cc7a17ecce8b6d692c4d1492d4877161166bc322

Best regards,
-- 
Jens Axboe





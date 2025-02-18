Return-Path: <io-uring+bounces-6534-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FBF6A3AC94
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 00:32:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0192A163FAE
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 23:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1163619CC17;
	Tue, 18 Feb 2025 23:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xLuCUpjl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D9A1474D3
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 23:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739921520; cv=none; b=jpOjHACtVyZrJ95XXg8Lp1kwIWL5ragHvkttr60u+yA0B78wjHYD+k/5nYi9EceVi4TJtGQ4kuhh6bFX8un6CT1wTqB5MtubzvbGGdf3+Y1o0O4uEFasopnrsw3qMqyEnSvFOdxYFBVM1SYJ8S+II1xdf7wr5OFNjab2bA1JckQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739921520; c=relaxed/simple;
	bh=JDgZ2iQYhDITXl1JZ/HUoW5reIXRGMylGjJ1XDxoalk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Uq0lFxcC+atyfsIxVROpIc8fA1WEeb7uR3l2d83zg2i4pCnPcLjssfAiRRJ3Ya3h9VNIBKysBvexfapqTIc2J/DZEyeSXC4q4KJZGLG4fqFr5+6Lk9/3OFoupjaVL6ar1Ncjcylmf+t0rAIcY2dC0ZMpxtMeZ++dEQe3zyj93VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xLuCUpjl; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3cfc8772469so19538995ab.3
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 15:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739921515; x=1740526315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oJ6wy4Lqqln0rnWdEiOXUcdQIg6geC/lyDaFPvxwzns=;
        b=xLuCUpjlL4UIEwwiLyLGfrgbhwPk4DE43qDcg1ld+3vSy8jV7Hc7BWs9L10W7XCdmb
         aH7603MjQW6vY1NReNtHHW0DnDiUPQl1cgK5mdjN20hKbUi/VZBWyeTB/keS3ExCbSkL
         ATMrERndTPxuY6NjMc9E5s/pVZqb3Yy8yL8x15cQslyDnTDclBXS4lxre1TMMreuX3F3
         68tjA/Oon4omkn3A+yRGyq1PxEj7hXAlSxu/WeNJ/7qzQCqMnv0A783kjOl4iaWW7Yz6
         SblALuHl0loMXo6CWJh/hcutK4Jy60ZbvZg83hBAZgdbepbQ+YWIheTRO5N0dXw699Q8
         Kt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739921515; x=1740526315;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oJ6wy4Lqqln0rnWdEiOXUcdQIg6geC/lyDaFPvxwzns=;
        b=A2NyJi+f4Z4hX5T4hmImAipTlamJXDV3gcfApirWKDXpw4ZAcd3LQyfBUOiwMONidP
         x9UyUaEbJXxHa2GD4ECCAvtY3euy2aaYPfYb8PhD+2Oy9psccPSHpP6hPFLuH4X75bTF
         LSMruUIxscKdY51ImWJMbIi1YOF46/HRobhCDJPypt/DXtQUKbmhhxWBSIQX14eozJQT
         sA104ikqFiRu+4Bkpg3L7/aD6aFZOzLthCr98xyjp21zQYqpHlnFpYk+XUp+nvfkQvg/
         EbxcNLnibXTnzECDD/T8Gf92amcJA6dWfsRhiJ803JOa5FGXtjAnHzltcJCQYnpuNVBB
         wemQ==
X-Gm-Message-State: AOJu0YwWkJGitxW/BZn4LqT5KyRGii+M0hkswQQ7wZfoHczKAdR60aHq
	9oPZTkB1CEPA1mc8CM+fc9ijciyPhp8lnnF8fksaqnBuoCdx/CUyAPL8qnZHgK8=
X-Gm-Gg: ASbGnctj+Mw0z7/6ieYgqrwtLhB8x03g0Xk/W0g4WSfnwAy+82oclmOkmpzKS3W1G8r
	NAdrps63Tj4VTRUSVTgd+NpDcqfnG+Nz8ZJwBaDr3Un67ZNB+h1Ii2XTWR3GYuqFsUDjpuuk/ki
	Bz2j6Emv5Z8QMsbUFW+uwH2RQaRYuJrFCeS/fRv3t0c5gMuBSVTe3tjJUP4vgaS5qLnFE5NogXu
	i9st+coW1TVyo7W0Zu4WXvKzYKF9wT8dFq2MfktVd4GE5V8U/8su2Gq3YiuKO4fdII3uZrzYofN
	DPFGS4A=
X-Google-Smtp-Source: AGHT+IGR/kT92sXk29R8JLojJe6Xfiv5lmdMiSaeOnSB0V2oRZfD1+c6xvan3VbksWUk3i4rKX32wQ==
X-Received: by 2002:a05:6e02:1d86:b0:3cf:ae67:4115 with SMTP id e9e14a558f8ab-3d2b52bd961mr14441925ab.8.1739921515014;
        Tue, 18 Feb 2025 15:31:55 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d2b3258a9csm2537195ab.62.2025.02.18.15.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 15:31:54 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, David Wei <dw@davidwei.uk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250218220136.2238838-1-dw@davidwei.uk>
References: <20250218220136.2238838-1-dw@davidwei.uk>
Subject: Re: [PATCH liburing v2 0/4] add basic zero copy receive support
Message-Id: <173992151397.1502615.16217151247335702612.b4-ty@kernel.dk>
Date: Tue, 18 Feb 2025 16:31:53 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Tue, 18 Feb 2025 14:01:32 -0800, David Wei wrote:
> Add basic support for io_uring zero copy receive in liburing. Besides
> the mandatory syncing of necessary liburing.h headers, add a thin
> wrapper around the registration op and a unit test.
> 
> Users still need to setup by hand e.g. mmap, setup the registration
> structs, do the registration and then setup the refill queue struct
> io_uring_zcrx_rq.
> 
> [...]

Applied, thanks!

[1/4] liburing: sync io_uring headers
      commit: 48d8d54e524a9c37e0cc52921bb41070156a597f
[2/4] zcrx: sync io_uring headers
      commit: ce3a65747d43a405cc19a630d5f8a0f613293f5c
[3/4] zcrx: add basic support
      commit: d7ec4ce3421fbbdaba07426d589b72e204ac92e9
[4/4] zcrx: add unit test
      commit: 30bd7baa5627f066fc0bfbca293f950fdf3ef3f1

Best regards,
-- 
Jens Axboe





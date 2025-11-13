Return-Path: <io-uring+bounces-10613-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C650C59846
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 19:39:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D6FD834179A
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 18:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 809053126AB;
	Thu, 13 Nov 2025 18:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nUsr/XBB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D65E30F53B
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 18:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763059116; cv=none; b=HulPGP3TH5Fq7gNMBMIYjRXC5pdYwQ1JXk0AyHi7xFOl8qj1ppz2bHTWerJNfPGvixfZTaNA/OeoWaq5JFxOrSJ4h9bIwqAu14mU9Y04FIGoZSjAq1xPW+aIhPf7h4Fxh90H1i2bj6TdEk1zcz1gpVRR+Kkjps6ADPDMCBOb9aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763059116; c=relaxed/simple;
	bh=ed+I1CuteA8FSw/oh6VR1KNowh8X6u93nywir0V7H4g=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Bdov+qqbm+AGfWgNNhyZdtvfmj9b8O7ZgkyFQct+PmHhCrtsRd/ypsezuR+yknYU44DCrE3nr1mdB8Bfah+xX8uJD4PJZzLwzpxFmsLPXq8Ltz1c7Gy2Dg3EAe1hk2kghTXnY0es8+aeultw6kuadhFBSEOzG1OH7U0ijE/mBVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nUsr/XBB; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-433217b58d9so5195215ab.1
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763059111; x=1763663911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JdIghRjm6pinSIazoITLc9UKWKBq70HsSo7XqxFwVEI=;
        b=nUsr/XBBfbcjDMHOIsLX2iC787KlT/yC2KyU4dAH4wjijGNN9ewD161wKoB4twzRgO
         W0dfvqdmwDBVjcOBafdptXQfw4Qgb3SBH0QI7fNmIETUqlwimvSlCtMe81M2M0saS/41
         FphGUtQwLLELVnGZ9cuBbq+BdSiziaKqbq4lGnajoNeEXovBu1f1H09DdPlY+zcTsoYK
         l6O8Cwr0elRBrg+XeKRW5fCE0NBOXxYSPlX9fFtfEWyHPJYyDgfq1djhnXnxrMMpUilT
         GvwglaMRrugN8Iy5WZiWSn72aIqQgP32O9Fev9VHBjJOSCc7mU3acN/J3TrAv5sdPvEt
         m5Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763059111; x=1763663911;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JdIghRjm6pinSIazoITLc9UKWKBq70HsSo7XqxFwVEI=;
        b=e/DHHsxKub6e1ZfDzyagviEY4oP/oob1VI4yjwUNG13BzdSwiKvgVslGa5dIaZ42bj
         RGh3HqxpjrlSPuF9bn/tyMYV9olystWK6dqPO5tUYSZ8n4LMeV4HpYt4mbVlu34DTOJX
         VYzVcmAIRAfmDqJMbIbl6FEoR3/VuR2ldUOjvJjXcUuCo8XRrsduccOtFUIRnBXCST8X
         5d2GxZ6ZDtYxKXdqCovn4hOrZLKvFX1fOED+JKxPpTXsdvPJHBbFKqow5EsOskVp4A8v
         s8dPP6VR71IFyugZj6yaqbMnajdMDKAWkTNi1KiJdRwUWQ3aHxkAkgRvqQ/JAWkROhLI
         KpSg==
X-Gm-Message-State: AOJu0Yz4T83IUGDcHxUQJnl9HBriXKh410qvvI/eUfe88DICxUAsiAzu
	U1twoDSZpQslt7L3fuE15SPWwhubG5pM3AiV56FIbdxUPyj82TY3EXqGbwPER59HWqptZvnwZv5
	UIPfv
X-Gm-Gg: ASbGncuyDLQgofoi9Ps6/LSe2/QrIpwVwK6HMjglK7SIC8murQdjSbIKVp3BNfpCqyH
	y5cHZbluplQwpcJt+RwyWlJ/Y4RlK8e+WxeIeY7OSQKyg8QlBlLjmKlnvPJEqAoLS1ktxwXBYZ0
	CUNZmhz4BNzyU/KAxsqYGg/FXqvems+0aNv0gm/+6CkFQlvpjz2Zm1jVOZCCPWMdnEvKmH7/FmO
	B80Cz4+ZCHZCwvstmGW/gg6Xbl3mTeGEq2EFMe2OOITKS8iLD3hCafewE92e1yfDbalGXesGkVx
	l6JaFxbbWUapEOjEGx7Qjauzqzgz3ZiVOt82vqwA47nkfoEUHxAop8gfrmU1VK6lqs7oaJXfKOn
	vm2ZrXWaIMweZax809IKr+D1LsQZZN7aGi9/OCGPIHbNOQ7y4h92wYbctX7i38L3Ox6M=
X-Google-Smtp-Source: AGHT+IGfY+aKV3ecElKx3Y3hRT2aQ33xeEL8nvFnjclCyJsT4SQIlw3cH7JAVuOYcJN6ZjR9aSgebQ==
X-Received: by 2002:a05:6e02:3049:b0:433:2fcd:e6ec with SMTP id e9e14a558f8ab-4348c87bcc5mr8295985ab.8.1763059111636;
        Thu, 13 Nov 2025 10:38:31 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7bd24d922sm955030173.10.2025.11.13.10.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 10:38:31 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1763030298.git.asml.silence@gmail.com>
References: <cover.1763030298.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/2] zcrx and SQ/CQ queries
Message-Id: <176305911101.263645.6470145475091048450.b4-ty@kernel.dk>
Date: Thu, 13 Nov 2025 11:38:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 13 Nov 2025 10:48:56 +0000, Pavel Begunkov wrote:
> Note: depends on the 6.19 zcrx updates, and based on top of a
> recent 6.18 query patch.
> 
> Introduce zcrx and SQ/CQ layout queries. The former returns what
> zcrx features are available. And both return the ring size
> information to help with allocation size calculation for user
> provided rings like IORING_SETUP_NO_MMAP and.
> IORING_MEM_REGION_TYPE_USER
> 
> [...]

Applied, thanks!

[1/2] io_uring/query: introduce zcrx query
      commit: 2647e2ecc096d2330d6b6a34a3a1f0a99828c14c
[2/2] io_uring/query: introduce rings info query
      commit: 4aaa9bc4d5921363490d95fe66c4db086a915799

Best regards,
-- 
Jens Axboe





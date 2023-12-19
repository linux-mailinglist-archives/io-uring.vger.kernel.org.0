Return-Path: <io-uring+bounces-294-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19815818B12
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 16:22:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F20D1F234FE
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 15:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C271CA83;
	Tue, 19 Dec 2023 15:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cI5fDbWI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42761CA80
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 15:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d3b84173feso4914095ad.1
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 07:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1702999360; x=1703604160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l4X/t+TrQywqn2cB1k4Ph2OrjI7UqsZZQOkDIluIw2Y=;
        b=cI5fDbWIt3vivpt4qfJ+xERO3f3ISJ+agd8v8pTtWUfwnKWaAi47BNHPynbuTB3As2
         lx7q6fQeTKA/slGZW2rXjvjZGp1i+UmvbqDb1GT5djDl1PPwA46D/zMsjnip8AwAT1X+
         ZJ37MG7bjsZtUIfa1ehC5Qx9h6iSXyma7V4h8HQ4/6sRKcxik/ci1e7YS73coDynIehR
         F79+9ZVoVpp6OziFwUH2hjo+AHW2rC8NMZBMUyI/iXzBQSw8yqyRbV2+fn+5Dlq6JsjU
         HVsx6aXRviAwcdi4DVW0fXBJi/uQZ8Wwc2Mx5jyphdT9mffEzxNwfz2VCabejT229nij
         Q93Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702999360; x=1703604160;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l4X/t+TrQywqn2cB1k4Ph2OrjI7UqsZZQOkDIluIw2Y=;
        b=bhEET8DJohmOVbhH9UPo0owx/y+EggMwpl6icLgNna1LXbq+KmyoqyYgw/z/fj3UsO
         4FZR6UbqzANoFqW5BjwwOXf6oV3gdH59TkpUvXcdAdt7tNPjkFR0Hj2vKF+H6ceIBdOF
         b7weV4AMezUsta2L3PZpTUBtMrhg7Wzvp0Gy2qXnszKCQHCdwFMYhfARCaxF/1Nr+JSn
         4CenbpEffT0SEVyEzV3ax3ELHcKWGmrhcTbwBOHB/wjg9fDXrPOGq3JAJ2uoK8WV6QPg
         Jjh5z5Z/1T/HgwELCRqmgtPtdTewUTpgv5KcC2yWPgST1qFkqgWnCQLeb1JQ74W//Wjg
         89QA==
X-Gm-Message-State: AOJu0YzdxoH/hZIHGztvHQcg7tDzIBnKjHBO/GdPFOL8IYMQRvRfpf+S
	2KUsMsf9KM0h8VYEGU8DmftFlg==
X-Google-Smtp-Source: AGHT+IFFVPgVeQrzoWw4fxcoePk6KxRxSLLaAhp376iURBzFhdb+zXuHnkKxClPLX2ufrx/iRuaPgw==
X-Received: by 2002:a17:902:db12:b0:1d3:dbdc:4c9d with SMTP id m18-20020a170902db1200b001d3dbdc4c9dmr2677146plx.3.1702999360121;
        Tue, 19 Dec 2023 07:22:40 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id s14-20020a170902ea0e00b001cff9cd5129sm4331741plg.298.2023.12.19.07.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 07:22:39 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>, 
 Michael William Jonathan <moe@gnuweeb.org>, 
 io-uring Mailing List <io-uring@vger.kernel.org>, 
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
 GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
In-Reply-To: <20231219115423.222134-1-ammarfaizi2@gnuweeb.org>
References: <20231219115423.222134-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing v1 0/2] Makefile and t/no-mmap-inval updates
Message-Id: <170299935907.459636.7506375582198265132.b4-ty@kernel.dk>
Date: Tue, 19 Dec 2023 08:22:39 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-7edf1


On Tue, 19 Dec 2023 18:54:21 +0700, Ammar Faizi wrote:
> There are two patches in this series:
> 
> 1. Makefile: Remove the `partcheck` target.
> 
> Remove the `partcheck` target because it has remained unused for nearly
> four years, and the associated TODO comment has not been actioned since
> its introduction in commit:
> 
> [...]

Applied, thanks!

[1/2] Makefile: Remove the `partcheck` target
      commit: 4ea77f3a1561bbd3140cc0de03698a67d08f4f27
[2/2] t/no-mmap-inval: Replace `valloc()` with `t_posix_memalign()`
      commit: 7524a6adf4d6720a47bfa617b5cb2fd8d57f16d2

Best regards,
-- 
Jens Axboe





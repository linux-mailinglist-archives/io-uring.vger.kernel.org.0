Return-Path: <io-uring+bounces-13253-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KADZAxLG/Gk8TgAAu9opvQ
	(envelope-from <io-uring+bounces-13253-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 07 May 2026 19:04:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 41D0F4ECA33
	for <lists+io-uring@lfdr.de>; Thu, 07 May 2026 19:04:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B0169300FC7D
	for <lists+io-uring@lfdr.de>; Thu,  7 May 2026 17:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4772E7179;
	Thu,  7 May 2026 17:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="LrxmRQOo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694463101D0
	for <io-uring@vger.kernel.org>; Thu,  7 May 2026 17:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778173341; cv=none; b=i8/itqQipQck6YGaj5dyYddn5q9CSgaaM3nSkbuRz9vKD0FJc90Mcx1bj6LePdxcQRzDp9hhrS7DEbzSagmgiMlf42Yd1mN7/v9idGmV5DlV9005JUDDewb+tV7UQ+AEhXWfktRpX8lfMn5/JW31D9NiL/jANcMG6UVGCsZlSWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778173341; c=relaxed/simple;
	bh=b2KO+vGAmlAdiLmbJHj84GLYMYPSR+wrhbiYzc8ZOU8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZoIjsIQjJWEax6xHsQaAqriFFPEMElXaRhe2lRy8HIzHvCvoOYETyR43d9Sjx0RjGMwHufGRjV5jW9Hd2Bs32NdgWNGlW9gsB5B2CgW6Td2hZF3A5cblkkT/HHkNr4OZwqG/HhIrTAkqnD4WSwJMNBq2tG3uFtjETgnZ2IqkXXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=LrxmRQOo; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-47cbd445021so621060b6e.1
        for <io-uring@vger.kernel.org>; Thu, 07 May 2026 10:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778173337; x=1778778137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dr1f+k2G7Q4pJHzdrEFR1p1EeCHfdbjz5eyjTckzs1g=;
        b=LrxmRQOoAT6jPj5X77zhMw3F1kHtpuyGkFHqY1WFBXuYkL+4nsAIGFqlQ2ErRkWVb6
         vEkU0Be9OL+athTRFwmWKfdVkEL9JifsPRhePJGDZw78tCO4KgAYlb3FtSmNxRDGB7OY
         ml0deUiXtcOezfzYdOiniSPOeeTZPJobA3lvCdk/h9m2AYZjS28drjTUaDP7/SU3HJkg
         WYOHlE1yUW3BeSKx1cbvqrMmoqmCXeoBSS8GR89M7iErFbBOU4WSXBOaUlbn7j1Zb+21
         +kqGpPvdr0F0tfVk9utkmSXNJTlkfXruPMdps1XFe+r2BrJjvJr8uOQxU+JRqkdD/du/
         cGgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778173337; x=1778778137;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Dr1f+k2G7Q4pJHzdrEFR1p1EeCHfdbjz5eyjTckzs1g=;
        b=KHuaOINRZT/Z1vi5+evlc5LAOJ6pDsmRcxXnMAXSTeGxI6WxF4gtReAR+IrmNy5SBR
         P9Nnpl4+HVQ7PxCrqSXiZAxCvfKexAg24dthRQatDVIgurPNT3OUXNjJ9yrKmEXcL65g
         FQJXSd4UNMjx5Rqn4wkp/q3ieuU6yHkSo6qg1oqKjZdL83ETK+0/S9u0mmcCJvszl5c8
         VGuAPg/e1QqA+u+P8bFVr2oJaSMuDaAtD3Gr+VlEtUkoPFvXcfJ9hZ/1XXUZrZrbhqtv
         GAgO4dxrMlIALkGLopJHdQv/sKO3OGiRXst0XStQBbyaC6YrkcT0GeQDEAXYc9SLQt9n
         0yWQ==
X-Forwarded-Encrypted: i=1; AFNElJ9neEqk9Ai1etrJIATehq1W1GeutdZupsxEmXgvMaHrDLGzrgU4yz1APVNkXSHk87mzjQnnZycV/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxcOm32JLbqoX4DiN4Aaq9rGgfB5U8BNKLJMS3oPawddR2gfrnP
	FJMrMpA/cg3aMo5UKbgGs8+zqge3KKnTsDowX43KhnnomDy+mrVU3M3F47l2cP+GaomUX4RoDJv
	W9Je8DxQX/Q==
X-Gm-Gg: AeBDiesSfpSA1+4zMYOi2LAACQlsLBnpu0oh9BV3QOterSrMmWnEjkD+QBbsgT8GN5B
	hir7BW/qSXiS1Xyr5l6oxetB/V8vI/BPePCWO31TnM+dTj6vKqHM5JLALxg5Vnel20GkkEGFvLU
	dwMVfg2QQ0FFSF33I6BAqWDZ0GXTt7wkWCRXHXkKc4ivBq2N4vQFeY3OpdT0utfxw/T5RIDR6cC
	ohqKcNu7/d29R9cVHn79qr91ZIYooc9931DmhvvPpS8san+iWVpobsAa9sWcSxU19Ff0IjxSL+L
	YIDNrfiYxSPm53ecIPS/s4vnq549r3FzaBSXbTIecBDOJb7JoGlWAIjsqT0+8O0HMZ/xTqu4nTM
	c4W1tK+RlI0NGZITtQkSZcNI1GNMKDkDmbdNPC6RMob/+qgjioTurFgkb0C+HzMCQcosLmIgzim
	CN+/9URICzP+UO+wZs7Wj09bmWUidGKjK4ex1alm5OhE0Uvg==
X-Received: by 2002:a05:6808:448d:b0:479:d605:64ab with SMTP id 5614622812f47-48041e6977cmr4930056b6e.0.1778173336786;
        Thu, 07 May 2026 10:02:16 -0700 (PDT)
Received: from [127.0.0.1] ([99.196.129.84])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c763ffe6csm12917637b6e.6.2026.05.07.10.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 10:02:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Maoyi Xie <maoyixie.tju@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 Maoyi Xie <maoyi.xie@ntu.edu.sg>
In-Reply-To: <20260506135935.2420124-1-maoyixie.tju@gmail.com>
References: <20260506135935.2420124-1-maoyixie.tju@gmail.com>
Subject: Re: [PATCH] test: add timens-abs-timer regression test
Message-Id: <177817332932.83373.16098591660907172956.b4-ty@b4>
Date: Thu, 07 May 2026 11:02:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 41D0F4ECA33
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-13253-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,ntu.edu.sg];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action


On Wed, 06 May 2026 21:59:35 +0800, Maoyi Xie wrote:
> Add a regression test that exercises the two ABS timer paths in
> io_uring with the submitter inside a CLONE_NEWTIME time namespace
> that has a -10s monotonic offset:
> 
>   - IORING_OP_TIMEOUT with IORING_TIMEOUT_ABS, parsed via
>     io_parse_user_time() in io_uring/timeout.c.
>   - io_uring_enter with IORING_ENTER_ABS_TIMER, parsed inline in
>     io_cqring_wait() in io_uring/wait.c.
> 
> [...]

Applied, thanks!

[1/1] test: add timens-abs-timer regression test
      commit: eb8dd984881241bd206b0503a3bc2627f7ad0d09

Best regards,
-- 
Jens Axboe





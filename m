Return-Path: <io-uring+bounces-8089-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B17BAC10BC
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 18:07:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 210577B5256
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 16:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4594429A303;
	Thu, 22 May 2025 16:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="In63vS5y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AD2299AAE
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747930073; cv=none; b=feXKPP59JhVqn+TuQACDF1A7BNDH9dn74xWPtU6wECK7oyvaIJCmH6NkRxxdwzrEShCViEZ9N1Gd8cpIAUM8zA+TRzaX+NdmUfC2SuXelg1EndOX13/8pBrmucYLXo6b2LntCyNTYv1qx5WSSJ4k+JRS1RhKdiWtssCtBxtINtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747930073; c=relaxed/simple;
	bh=G8Mv8bQiaDJa5SmClYhERN31MEnqOBxSaleO48WeUSw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=S5bjbsJLbFfJb2iu18Mj5P0FZbna/srfgOO61zGcY/gK2z3qhhyLoBE9NjLJF2weBq8Qc2FJHiZJGelJDBkGn9ot8mqwhlCwltZgte/kz5GFZZY99WkQEcSIJwDZsx1ufmCPMN4gNS8iYe0I+mnFDu6hfoQB/gu3wMaoDuBtRNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=In63vS5y; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-85b3f92c8f8so762266839f.1
        for <io-uring@vger.kernel.org>; Thu, 22 May 2025 09:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747930071; x=1748534871; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v0F+3sCLS0bt8X7P5AVbJqQjk87UjImEe9PD0EgmZH0=;
        b=In63vS5yi1yBruF6/7ppKhAMk0ufMqn1C4oO9lk7jjIxCScnYkDTIoLFj8f6F0L11o
         wjkvnr7UJh83oJRuMHuAsiBhCe2AIvV1Jtf+3G37pLrEJwbygiwn0v5ZWHjxVGwqBLZr
         TyGzn0SpAW7hD71GVQ6iaRR1esAlbGhPMY1NdqgFz3RcIohK60Bo5/wh0phcUdYRv9aA
         6Xn8mlYrU63zEU+kNJtCi1J5N+txC3BSerZVAMa8SACGm4RW771EEOxjUuLm9ErdrrZl
         mrnRh7+XRnBjBS9TEVrBVBxtc16RFa6E9mEwTRxAvWY6lRkMdDSLukdVtqQmclQhCUa0
         Oa4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747930071; x=1748534871;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v0F+3sCLS0bt8X7P5AVbJqQjk87UjImEe9PD0EgmZH0=;
        b=JSkjwVLnU4m2TgzdeAnPUiYN582W+XQUkXBikyEX9YLe0Fzq8C9+hzEbz6NC6ot321
         imaVh6zLpE+GeDQcFx8mae4t12njE+xaLTYdmrV1G3IpwCs1YrtHkUp6qGw39kbeDCHG
         AS33BXTh6DA9kunCBA50YKb1kQXPGuDoia3mRf6hhfQQnlEui0rhAG54u6jx5aQ4VpKF
         m8sgJd/WVVATvASqrofK4VpzXrWC0VPNwV4XB00agXX+vN1OVOammne6E1Y5R5FHNp/q
         kLpLzmRR6WL0ns+o7in0J+/RBTZlsN1qLXAXKYqr15LD1Vh0dbVdTYSEepMOOz5yCouh
         hftg==
X-Gm-Message-State: AOJu0YyEbZe+teOXfQ5I0U/ttnnf3ATpMmK2eyCyAX2qkfgufgHIKA9U
	IzfJUVnHI83gHsldo+lOg7+Wlk0ziqxNoNaqg0gysPy3X6ujL4ARa0fY+TcdWPGedu8=
X-Gm-Gg: ASbGncutlGNLaPpD+BSXPRaxhD61dDXKGgy+0YdZomB7YW8zOAQtMAc7NBXK+/DLDhB
	Q1DiOUAQ47Au9r5Sk6gAb7/E3z9feoBX2WrUiXQYnxw8irSqzifrv+pngOjA6scO3t8t6uiDz4m
	PEAmyz/sdhWf2hWN1sN0uzEflRB31ENapPtQBWbeG//rfFsvMi0xmNbbchhs18KDODzFCS2gigT
	e4XlG31HnT0zy31ibFaqrBZifEksF3KqxTE7jFRJXhGHMzgl/cd3fnBQbHB1nRjYUIGKuLVp7CI
	EBwrTaLxmgfYoz4pswAtTdjHqCETKPDB13a5hDT5PQ==
X-Google-Smtp-Source: AGHT+IEmmT09lNxt6NVOQQPJ4Ie1OiNcfqxW+xqlr7SYGEsMkYruK2UASM5a6xpf1CgsBSaRB00c5g==
X-Received: by 2002:a05:6602:19c4:b0:86a:25d5:2dbe with SMTP id ca18e2360f4ac-86a25d52e54mr2466836239f.4.1747930070711;
        Thu, 22 May 2025 09:07:50 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86a235e377csm305088639f.17.2025.05.22.09.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 09:07:49 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org
In-Reply-To: <20250522150451.2385652-1-csander@purestorage.com>
References: <20250522150451.2385652-1-csander@purestorage.com>
Subject: Re: [PATCH] trace/io_uring: fix io_uring_local_work_run ctx
 documentation
Message-Id: <174793006954.1178150.14780914506137939683.b4-ty@kernel.dk>
Date: Thu, 22 May 2025 10:07:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Thu, 22 May 2025 09:04:50 -0600, Caleb Sander Mateos wrote:
> The comment for the tracepoint io_uring_local_work_run refers to a field
> "tctx" and a type "io_uring_ctx", neither of which exist. "tctx" looks
> to mean "ctx" and "io_uring_ctx" should be "io_ring_ctx".
> 
> 

Applied, thanks!

[1/1] trace/io_uring: fix io_uring_local_work_run ctx documentation
      commit: 28be240c763a44932bfe573f09e145d182e52609

Best regards,
-- 
Jens Axboe





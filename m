Return-Path: <io-uring+bounces-5918-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECB5AA13BE8
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 15:14:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5798E3A8D82
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 14:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2441822ACFA;
	Thu, 16 Jan 2025 14:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TV5QrHkQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A01B1F37DD
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 14:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737036818; cv=none; b=qRycmLYeztZMqgw6pQuwA0ot6dcvlAUFMrTmtoTfvJ57j1rYy+fcwGnbeiU7WwlGTI5nCucZZItiU3WAnx7I7vdQFl81rrVB1ia0FHhd22H+FXNwvDE87GxK20XAcBNvo73NKh7eGgYLNxnaeaancTs1dzpQ44ncFD3xrQe7+pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737036818; c=relaxed/simple;
	bh=jklf77cQvAqZJ/Tl2hKIbP4y9cxOBSQcS1UsSlX3Nfs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TFHH5NG7nC3D+pL1TT0nQnS8F8TBBO7DvNfRlFdwPJIpTq1O1mBtPWeP2RB1pF13jqeccz9oJNpdmmCMJ3hpCvaKwbSvOPtfEhfVFbzNzr8ZnQDjYDuElTvu/IExs/h+8cZpnMTwFi9gf+YiB81lImpVKzBqHnV+x9v9nePH15o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TV5QrHkQ; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-844e9b8b0b9so73368539f.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 06:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737036815; x=1737641615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bL/GyekQBgTf+5p3mdaN9UaIM6BQ+hf2PyMsVTBo5MA=;
        b=TV5QrHkQRnJXgeBPdsFrVf7c8PHiOa7XiU+cvdKc0AVbWILSqtYm9L+WxB3roZJ27M
         VDkhlZEnVQF0ICcPdjfxwuAN65mkPBm0oLUM99HW7QRyQKFfnamPNVJHKJKQBRkIGvKz
         shBJ3slK+8EOPcW8YbluyXAajSxZQQvhcB3UhkHEKdf9nU/GjmYWl/JLXByct2Bub0qC
         pZR3pFKq/8b7/6YmiHe4AwGs1259IC8lWKFyMLVBU3edrJbT6aYrGap3tO7hIWc4yay/
         SqoDGdMaFRexyGLV2k0Pc1incpeQ46aSRtAHbgVYiicxs4BAElUs8EjCZNZA7S13kkaW
         rHhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737036815; x=1737641615;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bL/GyekQBgTf+5p3mdaN9UaIM6BQ+hf2PyMsVTBo5MA=;
        b=f0nsxsWD7k2jxn9jG/DTKJRKJhn/Jrhz/UDhv3kywMffcdQCPlaKUowXzJ5AEJjlxL
         iRVw+B400wwuXj725APtziTQofO0TXaGq/WPQ37P6QGz6L9PJYwCkqeA1LHszaDIdhvz
         BBJyF5x6ryF/NeqIJqe6j0bJ0x0pbbI1YLX9LSlmW80nT/yox3unRbYcLp+G4EqNdqSh
         VFFNNTDrSE8UTH/5WGtb4e+Ovmg2g3wZI7NcgZqQuOyKjVZI+ITRcJdLeFhhsc3pm6zS
         WnMA12K8rbVCT9QjYyjhWH5zRpiHzw5iI26CPD5LW6Tyq6n8b9X1LbpO6yORTkm300eC
         67Gg==
X-Gm-Message-State: AOJu0YwXlWzh5qFkQBmeKPkmyN9BtlITP4DcrY2qLzRqTjs9BZtVgMl2
	BQQP254N8WAIdXYn/H5t7xQAqs4zW/s6gXYC9HgPZyEM3GeTc40+Dv41kzQ1UbE=
X-Gm-Gg: ASbGncveNhqKAwdUeqJZpmFZIPTd0XJ7DE0vEklDTgPjZGu5tLqJe4yWFiExmHM+De9
	CjfT3E+P2SUEF0anu74rnVWQX77PUq1aRj0fgex8+vVy25Zv1WKzu2XsVYpren32Ovyukbg1G93
	mHlC4yP5+FJ95iqCwSshPi1bnlweXTry+FlAjgUINh6402a+Q60SnCn971WK/nb7p6Lp5Y/lvIN
	eW5cOzOE2vl+lgIDp7X7NWmCePGstJRr6QkJVgORiIvQTA=
X-Google-Smtp-Source: AGHT+IHTn49Ss1T1Jwr6CpOINfiGp/sUX6BBjtUgCBEI/nGq12Ta78Qu4Rt/JBsWOVPXYBhsmlOXAA==
X-Received: by 2002:a05:6602:7512:b0:84a:5133:a257 with SMTP id ca18e2360f4ac-84ce0036d8amr3335085539f.1.1737036815443;
        Thu, 16 Jan 2025 06:13:35 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea756bae75sm36808173.132.2025.01.16.06.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 06:13:34 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, Jann Horn <jannh@google.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250115-uring-clone-refactor-v2-1-7289ba50776d@google.com>
References: <20250115-uring-clone-refactor-v2-1-7289ba50776d@google.com>
Subject: Re: [PATCH v2] io_uring/rsrc: Simplify buffer cloning by locking
 both rings
Message-Id: <173703681418.10865.3728594442935840848.b4-ty@kernel.dk>
Date: Thu, 16 Jan 2025 07:13:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Wed, 15 Jan 2025 21:26:03 +0100, Jann Horn wrote:
> The locking in the buffer cloning code is somewhat complex because it goes
> back and forth between locking the source ring and the destination ring.
> 
> Make it easier to reason about by locking both rings at the same time.
> To avoid ABBA deadlocks, lock the rings in ascending kernel address order,
> just like in lock_two_nondirectories().
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: Simplify buffer cloning by locking both rings
      commit: 8865af703c087b8bcc2fdd04b6a93d3cc0fb0e9f

Best regards,
-- 
Jens Axboe





Return-Path: <io-uring+bounces-6838-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E177DA48233
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 15:58:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9D8A7A350A
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 14:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9BC125F7BB;
	Thu, 27 Feb 2025 14:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xjkB67m1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAA325F7B0
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 14:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740668259; cv=none; b=FHL6P2l7HYF/uDInnBqik2Ref7LHcv42GzDr4Z3qgN2p2PhefhyKsdY6qkkBeAsCiO9kWWHVQcM+SEEg5XgvYVN0xy3oBfalrU23vEjJty/Hg9nDCXpZluGE2ERDmsZNk9a3Be/VbSilbXp9EgiPg3x38L4M2T/B5Vt+dIR5QYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740668259; c=relaxed/simple;
	bh=tZaT0Zj5QAhJbLmAkDnK4TyAUYj8HZf2s6d5FLh1JMI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=h2/yUn9F28ybwwGnSL5RUW/7XYhuD4djIEzJD+Nc6FvYushYx/7b+ug9hYxFiT4rM11zEEReYOZiGuZm0PDSSh3/9DxopA5ySPwsDvIbdITB/ijtqIgJqz6w2TZpHEzmpqQXa6TEK6ecH64WloLtfx8UOiEDTwvI5vGVUq5Ua0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xjkB67m1; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-855d73856f3so77100839f.1
        for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 06:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740668256; x=1741273056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pvehVzeKkIphPFqeGIU7tN9oKpOYBtTWjoy4djcKaCY=;
        b=xjkB67m1WeQ72ZSGaD8hCufBunuvaYg0AvXX9R6mVDAxnRmViYK5lADDpEQzf41jdr
         x/3lnnkQTrG9kOckXWkRyfdCXBqOeCCdeK/s7y56Y0q4eaSdvaGLXBPvbSIhT+Y24tVG
         8yCYOk5k2dFeSGccGuq/u/+8cYBbB8OOZ1RXXUkdkeqkYCBPD6eANBxmkL4FdpHOtnc+
         xlT+rA5dYsgAa7v4UVo3v0yz1UQ2ya8Wf48/4PgcykmUx94UpnQi8dQ04NzPesQcw1YS
         CEZQH7+gyglCAmY+BXiit9LOswmFnjfcf4rt2wZcEHt5SSmalXq3HM8gfw3yyyZLI4Iz
         DvSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740668256; x=1741273056;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pvehVzeKkIphPFqeGIU7tN9oKpOYBtTWjoy4djcKaCY=;
        b=HfibPn6/ZmU+cshgq2VB01hfn068J04LVtE150hYQ8sHxuee6k5K3RFrZJ2bZmOkY1
         6IMnoJ5zkohLrBnAo1TmZFjLxFF1a5oGMczBiSJ6jraraGL0b5e7kbx99MKVUcj2frer
         MmW8/kxWFfIHbax5HpGALZEGh8huVoqIOWPLr3SI5H74pn2fovNEQj/RpnXG9HOdrJzf
         Kj0OhYNHo5RNtr2QHWv/KT0Gb77jNON/nZldtON5ihUdQGZw2NVEaPChL5fQ92BN3dA8
         8cwBV+QfJ1IY5YSKXhvTc+amaV5DnRF//JtC7+Aq2jQJAt0vMQRxTjO6kNoLbx3vMKCk
         d3cQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRZ6yz/W5W9j4MLGbh5ndEBX7lwSu5qmzXfb/NnhlqEjuchrkzpGgnELsU0phq00PmD1H3eTigTw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYir40y1xSOOFgC3zNHyhzfP07+oKXg447pU3oCxzCcZYq37Pa
	oEex7k/1cG3R1xQ7cFVZuOvj2fZWSBH9mE630U8samrCSIP+59yazJ1+AQa/CxAMB2o8U+Jjszs
	W
X-Gm-Gg: ASbGncuWHx/A/0XfJalCiXEQYXGexViyqoww/Out72lSPpXcPW10jmlrwcVvuCuQwjv
	htgdaC9cfq6f3TAKo56WaJ+EgF+ASpF53h6SgDnlTgQ7GY/BhWfcjsJJDLhpoQFH6YXj35zw5zy
	8/goSkOWWa6lst9s2xWLDUI7YRbTOK4xzMrqIGGAmREA5v4mRJPLy11shQs4obbdOXMjmcaSDoq
	e0X+GGZyjkqi3+VmPgO9xJi1bKVcQHT1hhrWwi5mUDMPzBkdcjRw8qJ5FPzPfamBY+eN1Dgnilj
	Cd92MlX9MP4SEj6R
X-Google-Smtp-Source: AGHT+IG5JkAqegx0ZeMLyNqVGpCwsaoLZ+LfxM2FEBqUJ0YGRH/m4CUfZaxxbTUZb0rM5nn1Gv82HQ==
X-Received: by 2002:a05:6602:154c:b0:855:c7a0:1e33 with SMTP id ca18e2360f4ac-8562014a579mr1351845039f.2.1740668255864;
        Thu, 27 Feb 2025 06:57:35 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f061f7c580sm378883173.130.2025.02.27.06.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 06:57:34 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Arnd Bergmann <arnd@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
 Gabriel Krisman Bertazi <krisman@suse.de>, David Wei <dw@davidwei.uk>, 
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250227132018.1111094-1-arnd@kernel.org>
References: <20250227132018.1111094-1-arnd@kernel.org>
Subject: Re: [PATCH] io_uring/net: fix build warning for !CONFIG_COMPAT
Message-Id: <174066825461.2448424.2288181673828962428.b4-ty@kernel.dk>
Date: Thu, 27 Feb 2025 07:57:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Thu, 27 Feb 2025 14:20:09 +0100, Arnd Bergmann wrote:
> A code rework resulted in an uninitialized return code when COMPAT
> mode is disabled:
> 
> io_uring/net.c:722:6: error: variable 'ret' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>   722 |         if (io_is_compat(req->ctx)) {
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> io_uring/net.c:736:15: note: uninitialized use occurs here
>   736 |         if (unlikely(ret))
>       |                      ^~~
> 
> [...]

Applied, thanks!

[1/1] io_uring/net: fix build warning for !CONFIG_COMPAT
      commit: 4afc332bc86c34b74f1211650f748feb6942a9cc

Best regards,
-- 
Jens Axboe





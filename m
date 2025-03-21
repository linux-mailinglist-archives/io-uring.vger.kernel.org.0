Return-Path: <io-uring+bounces-7180-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBE52A6C3C7
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 20:54:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 476F217B114
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 19:54:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 000B322F16C;
	Fri, 21 Mar 2025 19:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yxERy65R"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D00522F38B
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 19:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742586827; cv=none; b=WqE5hq76yKB/+bi/iRynPm7lbs50PFhTft/d52rzi7iFdQK0yZSCqRXV7RL2JURjEAe17rdR1M4SgDHDJYof5erGkotaqe9J9MmN2gXjPzqyr8kAp01OCxnnbDpA69wEQWrj+kCT2fyEfhrCjlksiylyk+nQxRacV0PPpXJXlDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742586827; c=relaxed/simple;
	bh=R1bFxZwTHqysjq7Q8LQpThhzLH0VTcsOTt2iO+OFDYM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=DmcUbNhZ0W7Y+YODn4UXlMynfjORBzj3gq+RHxxkaXSM7+EYh0pKmibdb62VmXdGHQ3txBD5APEwDDR5brFaBWPBaRpPZ2CLwuHSBvFy/BON2HGiq6ja7Z9IvV8nJvur7ecbJZBUsulzVmAKXihBV/n+LE0mfOCsMYp59ajhJoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yxERy65R; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d58908c43fso6497215ab.0
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 12:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742586824; x=1743191624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YzesUfd46zeebs0CrPG+xIoJVH8zLtMaJo8L9ii+mr0=;
        b=yxERy65Rk7349aDhsUFGXhyYl4dTWQpcERfGYO42dUDpwhr2IOb+Piv0hdJmz8Jrc/
         eQx5ns6VS+N3w7OkLaM8Dw6VArcNuTi7klx94FWEIB98duNhlsvXJlLH5fRVvZcfoUgw
         n9729LoDEbgGHxL8jB7UsRpl1GR8WOeYuhuZiPj6IB5KM4qsAZ8Kj2ES4IsZJnCPRepf
         b4DQTh7lkMu2ujMy8waGhMwke19/dxPwCwmQVmuPfZ/age/Er916soQZxgIdPxLmQYZy
         ZCT7gufJNW0VrUM7drfNYB0qEC/0LO/T5qb6uZxpZS+8jsq/0b6UTHuj0IqNV/sO/e1f
         CfHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742586824; x=1743191624;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YzesUfd46zeebs0CrPG+xIoJVH8zLtMaJo8L9ii+mr0=;
        b=cElOkYMndpL8LNieaXUMZsPDuME5/73QIun1xvh46FUad44c6tNcAVS5dpCfuhk77u
         b9hIbpTmRGa5ZmYYG4/9kRMkB9vqFiGNGMWqWKfL5uTW3NUtWJC8o1Q7PHvYH+sQVhqX
         TKfpuvsl/rn6MHzblTbRzAMLqf2Vvx0WL4X9anxcP1MJrmakcPzUpc5FOx/a+O/HnIOQ
         xZdwQi5fL342ORFWPREofBq8hNjGmc/miZEb9Pu+Fs5hI4FSURfKEmEMlgEKHHmgrWIV
         jB3A6i2KGpq3FhQKU0FwpzPtFZiNQ6dxjpLjLUxHJmSJ7YHhJf15JX+14SATPC7TbG62
         jP4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUifEuFF4ui1csIyHqeF8ki6Y2iXGULdX3dVYsRBI0j00OCndS1MmNNTQcmyrHQAYV+tw5H19kTUA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyCiRMu578JB8/5Ge+KU/YJYM93ROAM9pICxEOX2xpfUwiJFTid
	+VnrMmZbkImnLHO309oSfu1iwZWR+iw9dGEfKihu20uPgM0Ir9n22ZsWlI4w/d7XpNuzgciWj8k
	1
X-Gm-Gg: ASbGncu0ciMQYFijGUWhRGjbcqloTmJyEtOI8mN8bKBXWd6fYNwsAUhQlxwNi1Het6g
	TcUGO5O+u9HJp+vXpw6H9Hh/Cs1mmjmlASElZWjTHr32DSBSaJrNUfPUFfUeJMReI3DHqTjMBqx
	dDLdUkIBWKQvzirx3g72wkpRzjlwa2sK5tN1nvxII/RMvDLZhHb5hS9o3lJaou9LEGXJc+Ju2WK
	jKIOsybNW1cZ/r2k+n3ApSL6r2mwt3DZ494/dZv071ZhBXAhcjTxbeRpe84NA+KXkW3MP/Hrvb0
	OaT2n0kZ8SG8G56wanYxQUR5718MF13lvb9s
X-Google-Smtp-Source: AGHT+IGn7T9SD5ve8iBciVQ/OCx5fdDy3xWn9IiJSqNMPE9sGxY4HUf5wukQHEc1lEXa/fwCOdPLkg==
X-Received: by 2002:a05:6e02:3112:b0:3d5:894b:dfc7 with SMTP id e9e14a558f8ab-3d59616b1c9mr51603165ab.16.1742586824296;
        Fri, 21 Mar 2025 12:53:44 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d59607e77dsm5694405ab.16.2025.03.21.12.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 12:53:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>, 
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: Xinyu Zhang <xizhang@purestorage.com>, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
In-Reply-To: <20250321184819.3847386-1-csander@purestorage.com>
References: <20250321184819.3847386-1-csander@purestorage.com>
Subject: Re: [PATCH 0/3] Consistently look up fixed buffers before going
 async
Message-Id: <174258682264.742943.2572990287219952668.b4-ty@kernel.dk>
Date: Fri, 21 Mar 2025 13:53:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 21 Mar 2025 12:48:16 -0600, Caleb Sander Mateos wrote:
> To use ublk zero copy, an application submits a sequence of io_uring
> operations:
> (1) Register a ublk request's buffer into the fixed buffer table
> (2) Use the fixed buffer in some I/O operation
> (3) Unregister the buffer from the fixed buffer table
> 
> The ordering of these operations is critical; if the fixed buffer lookup
> occurs before the register or after the unregister operation, the I/O
> will fail with EFAULT or even corrupt a different ublk request's buffer.
> It is possible to guarantee the correct order by linking the operations,
> but that adds overhead and doesn't allow multiple I/O operations to
> execute in parallel using the same ublk request's buffer. Ideally, the
> application could just submit the register, I/O, and unregister SQEs in
> the desired order without links and io_uring would ensure the ordering.
> This mostly works, leveraging the fact that each io_uring SQE is prepped
> and issued non-blocking in order (barring link, drain, and force-async
> flags). But it requires the fixed buffer lookup to occur during the
> initial non-blocking issue.
> 
> [...]

Applied, thanks!

[1/3] io_uring/net: only import send_zc buffer once
      commit: 8e3100fcc5cbba03518b8b5c059624aba5c29d50
[2/3] io_uring/net: import send_zc fixed buffer before going async
      commit: 15f4c96bec5d0791904ee68c0f83ba18cab7466d
[3/3] io_uring/uring_cmd: import fixed buffer before going async
      commit: 70085217bec1eb8bbd19e661da9f1734ed8d35ca

Best regards,
-- 
Jens Axboe





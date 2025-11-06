Return-Path: <io-uring+bounces-10434-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 15DA5C3DDBB
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 00:33:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C563B3AD589
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 23:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672BE2D0C7A;
	Thu,  6 Nov 2025 23:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SO5Z8Nw7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23F92773E6
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 23:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762472024; cv=none; b=mbST/Vi3DJBRk3uZufI1DhG9vmaMPnzY23CJTo1A6fRFTrrXDnc9urjT3EaQxjMUx4JkymwAC5cjVj7fltpSjevDom4BhazZxtMnaOqEdMlqgHmkUsXkYyQ53YPbIOVBgOzqEWkIdTd1Sw5UzzgCLTKrEMlMLtz9AzD4yytyIL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762472024; c=relaxed/simple;
	bh=uVa+80SqJp0y0RXeeFiN28qeU835AOXtHIdVY/1wNKc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=CpOYa+vN7FFNSQ0SQCEdC8CMddFZTt++dPxZEetATA88GlCEqCJnteQh8g6+tAfL7cW5gPLNodELBxtxJo8WBwM3iQJiZ0CqejaT+68fSMQRbRi3SjW/AVuBx0dUD1Gj8PAajnxjfj7zt3yrV6IoshPw4UHwBiUDxFLWDSvIBsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SO5Z8Nw7; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88056cab4eeso1006776d6.2
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 15:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762472022; x=1763076822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/+pBzK7/wpXJADn0lLoNWn0nWhhGMwMp4Bi3akJQRuo=;
        b=SO5Z8Nw7QC83kFEa3nHqUWqRSMAX85wFAz6ml/DVJjcg/CBpmAg7tuIHz2cn56LrGj
         4rB6uKfitRX+3biIMgC75OwY5FOPBCb8IlUKWoGaydNKgp1GpeQqSNRni1Zt/PKUb4Su
         xkEvd+0PjA0KQhT9hw46Ek1vhFF4dCXSmT7SqxsvsWxu3dBq1ljfE16tqxl+rKOOymD1
         KWoJlEQB2Q74RuLMk7fx6BOWAyEsCqv6Z6pXc0kiY+uLNAjBKJbkTN7YXjo9xJG8sXbl
         xZqNpnb/ogn2SYQDqWL+CTBx0hQFWBzpujn/DHq9ypTOn5kFLH6DwIpiYKNUEyPCAouv
         i+Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762472022; x=1763076822;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/+pBzK7/wpXJADn0lLoNWn0nWhhGMwMp4Bi3akJQRuo=;
        b=IFexp7cSwnh1FAnUJVR33keDMTBRdAVzIni965Lx3GUubmKzDzISdH8zths/PKoq2m
         OkLz96YCwsS0qlC0DHiyn47BMCcDuZl/XsqP9H8nmY3QxMwlHEtqP/qCTpOKk8PKkQTq
         +M3CwDkJUVQ+5ehZLZJ+Kyf90Tn4HTkyx4GTy5GhY1F38lu9QrLdfoIeK7RInpZxZn0v
         mjuU+NdpznMc8vSciLP9yzhvsPMUZfrwWvbxVY996xUUcbqHQzq4zc+B571T2G6j4TJ6
         3/2K66PEOW3QusGJrXYNk5/LOmDs4g7MbeQe9MFVrOumNBBx7CFtIuF4cGHr8B5FGtCG
         xEDA==
X-Gm-Message-State: AOJu0YyWjywBV/GzvG0bhdHmeRnMNGS7+pPh8o//KU9/OGfuytnmAT7M
	pZzd1AUmntrYahVEdcymAnBovj2lCAtZolRuDv8v7HnrKAOVduiS1XXbCK+iciTAZFw=
X-Gm-Gg: ASbGncuB+hh6lGuBv/1gjAAEvYwaz9gwC53GbdwpCZZUL7e0/sGXbZ11GNI9N3sEMUS
	uRoBFZTP23UgmFsuH4IQDfSiIC31/MQ7DkrDkum5Im5hQQb2EUlbEuc702ADgeOuVo0E8kBxv1O
	JBlsvRth2ccF0yX6m8SqyBLhqh95TRpSiTddcNVEhmG8ilk8tC0jwB/Dyy05bPYUl4OLrdVFJzJ
	AWxdowRxlTgcReIb/PvrmbjWoMap6PXUwtJ7uXlsgCNyHT3PGaIOQ4dlUIo/cQlFMP9HLC2drxo
	wzEUx/Q/IKgUcOJ9BOJpY/oIs+6zxGmtFtwJfaK+hfR/dGcKkji8U/ilWeqsyLBocb20le/9M64
	odGnclpiMQQC3PiBBacZRj1+2FsnkrveB0JpqerBIgAcdEqb/6aR4JCisD46a8dcH05fQSRs=
X-Google-Smtp-Source: AGHT+IHPKDYPPwfhjep5UH/Wn3BeC7cqCWtW+YSHn4/RaMpF3isc03s23Ya/Ab3MhZWrU8KdcUe0Bw==
X-Received: by 2002:a05:6214:dce:b0:880:477f:88eb with SMTP id 6a1803df08f44-8817678c77cmr18435436d6.66.1762472021649;
        Thu, 06 Nov 2025 15:33:41 -0800 (PST)
Received: from [127.0.0.1] ([216.235.231.34])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-880829c83edsm27627626d6.31.2025.11.06.15.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 15:33:40 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 David Wei <dw@davidwei.uk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>
In-Reply-To: <20251101022449.1112313-1-dw@davidwei.uk>
References: <20251101022449.1112313-1-dw@davidwei.uk>
Subject: Re: [PATCH v3 0/2] net: io_uring/zcrx: call
 netdev_queue_get_dma_dev() under instance lock
Message-Id: <176247202011.294230.15780174146072373826.b4-ty@kernel.dk>
Date: Thu, 06 Nov 2025 16:33:40 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Fri, 31 Oct 2025 19:24:47 -0700, David Wei wrote:
> netdev ops must be called under instance lock or rtnl_lock, but
> io_register_zcrx_ifq() isn't doing this for netdev_queue_get_dma_dev().
> Fix this by taking the instance lock using netdev_get_by_index_lock().
> 
> netdev_get_by_index_lock() isn't available outside net/ by default, so
> the first patch is a prep patch to export this under linux/netdevice.h.
> 
> [...]

Applied, thanks!

[1/2] net: export netdev_get_by_index_lock()
      commit: 0da5d94bbc6af079f105264849dc3afd01b78aaa
[2/2] net: io_uring/zcrx: call netdev_queue_get_dma_dev() under instance lock
      (no commit info)

Best regards,
-- 
Jens Axboe





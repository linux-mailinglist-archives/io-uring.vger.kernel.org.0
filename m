Return-Path: <io-uring+bounces-11443-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 253B3D01051
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 05:54:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B3C5301E199
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 04:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C162C21D8;
	Thu,  8 Jan 2026 04:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="yK/NKH77"
X-Original-To: io-uring@vger.kernel.org
Received: from r3-24.sinamail.sina.com.cn (r3-24.sinamail.sina.com.cn [202.108.3.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF75C2C1594
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 04:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.108.3.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767848072; cv=none; b=FAf+l+cImMPWLocXnC0tPC8ByGcZp6A8vQZLRXEAlhRNjsz3Thj89jXpMLPFUK8NysRMXQGYZNMp1Rdy5ZIUW7jGClmEaxFDaNToAn7bqH8voc/ZUfBAeontO3Nf75emJdVyP2JW8EgYoQn+v8CjJeBmblk3IaPdSKuG57RISOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767848072; c=relaxed/simple;
	bh=vVjYwHyfgUhh6DS7YzXYNomb2xYGTCVqA5B/VCEM8KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYz4Mm9ML8Ij5q+7XPvylUsMZpGjfP63IVwL7U6Jm0CqfvpElCtlTR0awc3AhDur9ewnYkf7p0bAucCLSSBOww07EMLLPRBt7LMIOMXLBqSTb8tF27eHPk7LZekzyvMj6Kz9G2WqBTW46yA5N8mL5DNtZZowDX0T0nbuKS+6Q+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=yK/NKH77; arc=none smtp.client-ip=202.108.3.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1767848068;
	bh=Gi0Tv0v6a4anWhDoDm8lf489JPPOWwWT7fmmkNQJmWU=;
	h=From:Subject:Date:Message-ID;
	b=yK/NKH77BXJ9i8Gsg7EenFvjCeP8R7ywhIjGVISERuabQxKtWH9rh1aiRS678J4yQ
	 bdSPD6/EzncEjaCX073pVpl+pnel3meu5yq7Hee35EhCGycpES+rJk1LS1fIDtshdI
	 nYjKKFo1MIgE3Ej2epm9fSyTYsBaU4fMw78p70dA=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.57.85])
	by sina.com (10.54.253.31) with ESMTP
	id 695F387800002EE8; Thu, 8 Jan 2026 12:54:18 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 4913906816390
X-SMAIL-UIID: 5852822BC2AE42CBAEC57551A4654F72-20260108-125418-1
From: Hillf Danton <hdanton@sina.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Joanne Koong <joannelkoong@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
Date: Thu,  8 Jan 2026 12:54:11 +0800
Message-ID: <20260108045414.2028-1-hdanton@sina.com>
In-Reply-To: <20260105210543.3471082-1-csander@purestorage.com>
References: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon,  5 Jan 2026 14:05:39 -0700 Caleb Sander Mateos wrote:
> io_uring_enter(), __io_msg_ring_data(), and io_msg_send_fd() read
> ctx->flags and ctx->submitter_task without holding the ctx's uring_lock.
> This means they may race with the assignment to ctx->submitter_task and
> the clearing of IORING_SETUP_R_DISABLED from ctx->flags in
> io_register_enable_rings(). Ensure the correct ordering of the
> ctx->flags and ctx->submitter_task memory accesses by storing to
> ctx->flags using release ordering and loading it using acquire ordering.
> 
Given no race is erased without locking, can you specify the observable effects
without enforced ordering?


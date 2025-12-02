Return-Path: <io-uring+bounces-10891-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59F79C9CB74
	for <lists+io-uring@lfdr.de>; Tue, 02 Dec 2025 20:06:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 190553A836D
	for <lists+io-uring@lfdr.de>; Tue,  2 Dec 2025 19:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 372142D6605;
	Tue,  2 Dec 2025 19:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNmLBrJp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C5F2D24B8;
	Tue,  2 Dec 2025 19:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764702357; cv=none; b=ZX+0QVeW6GtZvtv/zRI5nCmSoO1ETMsnlI9hg9l3NNJuhCxNS2S9fFNqpGTJzfBuxLHRelpYbE89VzX7GXmG4nRYfWIrJS+GaMB22NEpzEiovjEIPdcsCntZo2d/byBdmb/X9abZzKBtf2a/+NfT2fMmGz2iyYVQrKbMJntEMqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764702357; c=relaxed/simple;
	bh=CXgSEc8toth8yNeWoS67p6sTDrgrV08zl5sCjrJM/Xc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G0n+dLMygklMbaC+kzUcgYJx5E3b8AYWyGOWaHpFiuncvW7IVagq/t4TE1WdNjUDORwVjiL+zNRziByQUVt1dw5AXGNfpG8ftf3ETJ3Z244p0aJeOKt3hNMOXDDG0ZWf83DqwRQQ7LeEITOHt+pYoi8G5WiMHJQrefvHb0m5TCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNmLBrJp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEEBC4CEF1;
	Tue,  2 Dec 2025 19:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764702356;
	bh=CXgSEc8toth8yNeWoS67p6sTDrgrV08zl5sCjrJM/Xc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mNmLBrJpXUxzlnJumMthBiqoLv6uAlsg+mE4gKNBVJVvDE5Y/7/3hLxzsoRum0Nec
	 DRXX9moGHF10riIRM6xjJ2BX/xw6gNv+cOPRTsYjFQ80mww9+DsY+au+lj8rabR1oR
	 pN3k9BGbjQJ4xLTABfyt8+jNPTMb/XpDdip0iJVqgsiet5RUTNWRgAumQTHxKO+PgE
	 S3QKJDjdTtfZghl+OHVCG7r/jX5R38j/mGUWYI4DkGoJKShIh87SUkzhqWrkNUJ/25
	 A5Qsc64VWAMDVOZw8N4J2v+VSWppRcbbj+G1IW9Hz9zZwp6rzAhXW4xE5focsNUdqB
	 K2/wvS51sTzBQ==
Date: Tue, 2 Dec 2025 11:05:54 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jonathan
 Corbet <corbet@lwn.net>, Michael Chan <michael.chan@broadcom.com>, Pavan
 Chebbi <pavan.chebbi@broadcom.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Shuah Khan <shuah@kernel.org>, Mina Almasry
 <almasrymina@google.com>, Stanislav Fomichev <sdf@fomichev.me>, Yue Haibing
 <yuehaibing@huawei.com>, David Wei <dw@davidwei.uk>, Haiyue Wang
 <haiyuewa@163.com>, Jens Axboe <axboe@kernel.dk>, Joe Damato
 <jdamato@fastly.com>, Simon Horman <horms@kernel.org>, Vishwanath Seshagiri
 <vishs@fb.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
 io-uring@vger.kernel.org, dtatulea@nvidia.com
Subject: Re: [PATCH net-next v7 0/9] Add support for providers with large rx
 buffer
Message-ID: <20251202110554.1f088a82@kernel.org>
In-Reply-To: <cover.1764542851.git.asml.silence@gmail.com>
References: <cover.1764542851.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 30 Nov 2025 23:35:15 +0000 Pavel Begunkov wrote:
> Note: it's net/ only bits and doesn't include changes, which shoulf be
> merged separately and are posted separately. The full branch for
> convenience is at [1], and the patch is here:

I'll apply the first 2, LMK if I'm wrong about the reconfig behavior,
still a few hours to the PR.


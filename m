Return-Path: <io-uring+bounces-7281-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 594A2A74F40
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 18:31:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62BB8189102C
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 17:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA5F41DDC36;
	Fri, 28 Mar 2025 17:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D1oEExVc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AD51DDC20;
	Fri, 28 Mar 2025 17:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743183071; cv=none; b=pSl21a8PNcnEXpq1LbJAkkjBq3AdfgUAcARQsUSb7up/tOHmCzfhDNPoyn1T8eUpibchlXgXi80NqbETjg/EwTkIN1BatayJ3qyaJL7vasWJooiu3MPS77g6Jzi5iLshB6uecrqyPyVvUqUCDVq+gudlZe642AeZXYkMnJOVzRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743183071; c=relaxed/simple;
	bh=YbxivTapwxnGN4pqI9VK6fEXAti0c2E3era2k3yXVM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2wxrebUTheGInrTT6uId9AfQiZazTJGWu0/EU4iozzzMHT7TcAgyyQCqu/XKWRYLUZfUylbwDL9QL1NbJZMDGYCUTc+Wq6i8pZxgwmIygSOuh46CsfIY0Tos4ZwXul3YlE1RU3DPhn2c//2Hg6FHNd8UQ0ZQq5jop/ClIRVGcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D1oEExVc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3F0C4CEE8;
	Fri, 28 Mar 2025 17:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743183071;
	bh=YbxivTapwxnGN4pqI9VK6fEXAti0c2E3era2k3yXVM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D1oEExVcXQbCEh2YWXY33OVsDVJYwbiuItRF9rNQv6dH66HeXXkjcYskgDFE7OYWx
	 OP7QmH6lMxk4kT1NSWmKN5a4TouMb4PuyMPXGjVXvrr4vykQzrL0z1Lglxy4GSYoqV
	 Qa4/ntx7Kcec7IL2iPiMaUfaTHqtmouHRVsh8NZxARYAjin6PjObu5b2PL9bGWtKQQ
	 GP7R3TPIRzSQbDiKaQecA5HkU/xSWKociWe8UC1axnp49qOEpABOloaZiyY7Lelpqt
	 rxnuK9txRzhgr0P4FbLNmp26d+VVsb5R0kb0CH6sqs9OQiJWKzCWgKuG/Qdsgt+gEW
	 rXHzrWEc+po3Q==
Date: Fri, 28 Mar 2025 11:31:08 -0600
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Chaitanya Kulkarni <kch@nvidia.com>, linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] nvme_map_user_request() cleanup
Message-ID: <Z-bc3Hjc2eVSRK7X@kbusch-mbp.dhcp.thefacebook.com>
References: <20250328154647.2590171-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250328154647.2590171-1-csander@purestorage.com>

On Fri, Mar 28, 2025 at 09:46:44AM -0600, Caleb Sander Mateos wrote:
> The first commit removes a WARN_ON_ONCE() checking userspace values.
> The last 2 move code out of nvme_map_user_request() that belongs better
> in its callers, and move the fixed buffer import before going async.
> As discussed in [1], this allows an NVMe passthru operation submitted at
> the same time as a ublk zero-copy buffer unregister operation to succeed
> even if the initial issue goes async. This can improve performance of
> userspace applications submitting the operations together like this with
> a slow fallback path on failure. This is an alternate approach to [2],
> which moved the fixed buffer import to the io_uring layer.

Thanks, applied to nvme for-next. I'll replay this to nvme-6.15 after
block-6.15 rebases to Linus master.
 
> There will likely be conflicts with the parameter cleanup series Keith
> posted last month in [3].

No worries, this actually makes some of those cleanups eaiser.


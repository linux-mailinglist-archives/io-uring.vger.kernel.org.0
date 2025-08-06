Return-Path: <io-uring+bounces-8891-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9041B1CBBD
	for <lists+io-uring@lfdr.de>; Wed,  6 Aug 2025 20:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 41DFE7A41B5
	for <lists+io-uring@lfdr.de>; Wed,  6 Aug 2025 18:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33CEA1F8723;
	Wed,  6 Aug 2025 18:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P47mGj2I"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0881110E4;
	Wed,  6 Aug 2025 18:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754503870; cv=none; b=dCIL56pZURYGAsX9/z5vMzeDYmu0qUIiTCq/EpF8I6cQVE5qpG4pP45+lF2/JmfqMeClsmM61UPyZL+5cedrss5xJWYSMjVceapRsjkAx/FQlsGZtYSocpqG1Mubyt/r6sNnkfLx6bRe4LEaGknTFlo3zMdLAAg/iVSZzHRRysU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754503870; c=relaxed/simple;
	bh=zfOTfbqzLxQrzqYlCJpxFjKQoFwZjiEZuM/1/1OHL1w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sKKA6aGtYwjle7wK/P0MChbtRpovfWGJ2FyIlY+RzIAb0ZYWT0l7hi/0RSNWjilAV1sGBr712eKpOgs07P+thpiA5N837GG9d3FJMwf2Mskz+MItm+caNgaMhujsaaA9pHVjj1hGcmENcCC7AHlpZe2+wkV6L1fnZEy38SE97RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P47mGj2I; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAC3C4CEE7;
	Wed,  6 Aug 2025 18:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754503869;
	bh=zfOTfbqzLxQrzqYlCJpxFjKQoFwZjiEZuM/1/1OHL1w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=P47mGj2IRg0wNUvhSIIFMhZFHoN/SrWyiguX797+0R4OCqBdz0cSm3cJgX0ULqCkD
	 9rmBRhsRC4sA9jYrpXAp28gsCLya5cVNZ30tNvNGn4PfXXgWaqZbBZzQAy2/gOp26T
	 /SQrmaFU1ebwDNJPqCuXXiUCN6Co1jXyTrH7gqoaeSATv81R0hErmhnmpbUHkxjfwT
	 ES7+k5LPFnSSOZ29ZSOexnM1nrUvV7F+aZ+HzsrbdozSw1Wwfapmegsbr15Ja1g9ua
	 Iv47hFlVCK+K10nvtYJq+0wMe6Z82cHbUBSOd/fd8mJL99iYGd6OvOT82iK5SNFLcv
	 S98GpZvA0D1GQ==
Date: Wed, 6 Aug 2025 11:11:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org,
 io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Willem de
 Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, dw@davidwei.uk, michael.chan@broadcom.com,
 dtatulea@nvidia.com, ap420073@gmail.com
Subject: Re: [RFC v1 21/22] net: parametrise mp open with a queue config
Message-ID: <20250806111108.33125aa2@kernel.org>
In-Reply-To: <CAHS8izNc4oAX2n3Uj=rMu_=c2DZNY6L_YNWk24uOp2OgvDom_Q@mail.gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
	<ca874424e226417fa174ac015ee62cc0e3092400.1753694914.git.asml.silence@gmail.com>
	<20250801171009.6789bf74@kernel.org>
	<11caecf8-5b81-49c7-8b73-847033151d51@gmail.com>
	<CAHS8izNc4oAX2n3Uj=rMu_=c2DZNY6L_YNWk24uOp2OgvDom_Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 6 Aug 2025 09:48:56 -0700 Mina Almasry wrote:
> iouring zcrx and devmem can configure netdev_rx_queue->rx_buf_len in
> addition to netdev_rx_queue->mp_params in this scenario.

Did you not read my message or are you disagreeing that the setting
should be separate and form a hierarchy?


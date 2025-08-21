Return-Path: <io-uring+bounces-9133-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D897AB2EAA9
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 03:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4698F1C86059
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 01:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C384217736;
	Thu, 21 Aug 2025 01:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pv2bELXf"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4A918991E;
	Thu, 21 Aug 2025 01:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755739594; cv=none; b=O0uLPbtiLmXXfWlU74HsPMCEBnkfm/SEzGs/nATbqAGyQcChKrpUYwTTONUQf0CQStJRoRD1ESzW0Ox07Qjf2kCrJhqK0kB7con+0g5djZJlF0ZCqIxqbxlucoGa5WMjvPVioo3uUpKy2iQgeJemjR7J3yODaf41W78T8u92kSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755739594; c=relaxed/simple;
	bh=nt1wmkMzdycDN1HariQos43upByKwX/rxUM0DpMe4/0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SuxTio3SEx6dFFUqWYKO1pWGCToANszhfZtH77T+6UUxpTG5ZnXqyfUxVVA216r17uU5nF+5cSGpsFNLiiCuYlPny1QT/IBM1ob4M+Jez8zn2Zze82S8xJnclaK5+R+g6bMEDuOv/004THn0RHMZxqPLG6HOM+uwDbLWgJeQje0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pv2bELXf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6247C4CEE7;
	Thu, 21 Aug 2025 01:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755739594;
	bh=nt1wmkMzdycDN1HariQos43upByKwX/rxUM0DpMe4/0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Pv2bELXfWtTeYycHKkro4DewMzQ4mvDaEtTv7yJLs2P9xCZt1Sv8asex3zLsxMiK5
	 zoCsNk/MHlRPWOllAjCWahRoL0I6W06AvNn0PSF1MZjI9LpNmTvNWnvo/JTBL48mo+
	 BIrki7sBA7bhCflLXuJxmD/ylw3a6QeGG5ln3R+VpsPxRzTQ4uxp6DInswsu+V6bLV
	 M2Pa3zUGK3LcsNO5BAYoWfwT8WRNZMQKbL8ue0XUPYbqnmT/KAHa4tCJpmI+GTcfMY
	 hGqXCfwSG1q/FUFluvmKYHXE84I2hgkQ8KR3H1RXM5vtBQJvHtiZYW9dDpu0vOO3cB
	 iBE3t/Rs9/5JQ==
Date: Wed, 20 Aug 2025 18:26:33 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org, Eric
 Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, Paolo
 Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org,
 davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk,
 michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/23][pull request] Queue configs and large
 buffer providers
Message-ID: <20250820182633.71e991a5@kernel.org>
In-Reply-To: <CAHS8izP2odYCfEfB_JMdT26nUzniXRdp5MaZgqozYd7wV9Z-gg@mail.gmail.com>
References: <cover.1755499375.git.asml.silence@gmail.com>
	<20250819193126.2a4af62b@kernel.org>
	<fb85866c-3890-41d2-9d5c-27549c4b7aa3@gmail.com>
	<CAHS8izP2odYCfEfB_JMdT26nUzniXRdp5MaZgqozYd7wV9Z-gg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 Aug 2025 06:59:51 -0700 Mina Almasry wrote:
> We could make sure anything touching io_uring/zcrx. and anything using
> netmem_ref/net_iov goes to netdev. I think roughly adding something
> like this to general networking entry?
> 
> F: io_uring/zcrx.*
> K: \bnet(mem_ref|_iov)\b

Right, I think clearest would be to add a new entry for this, and copy
the real metadata (Jens as the maintainer, his tree etc.). If we just
add the match to netdev it will look like the patches will flow via
net-next. No strong preference, tho. As long as get_maintainer suggests
CCing netdev I'll be happy.

> I had suggested this before but never had time to suggest the actual
> changes, and in the back of my mind was a bit weary of spamming the
> maintainers, but it seems this is not as much a concern as the patches
> not getting to netdev.


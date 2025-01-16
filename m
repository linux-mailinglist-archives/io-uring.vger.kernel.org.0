Return-Path: <io-uring+bounces-5906-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EFCBCA1306F
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 02:06:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43344188813F
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 01:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF821367;
	Thu, 16 Jan 2025 01:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bqtd0ds3"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EDC1BC5C;
	Thu, 16 Jan 2025 01:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736989606; cv=none; b=PhPnO+dS7+Qewyp3GmTCZaHSUpruf80OkoRrSBHKXYLzvHtjCJDk5wGjfgDARX7Br5OZzwDtG/PLLLP8DDhigrV+Li+tqd/e2N7qsESBsVmS+BFVquj/uJR5Of+BgS3/Lqi/h+d9M6bYb/IfgjdrZG9UiILxpHxhs3hhJzYT8MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736989606; c=relaxed/simple;
	bh=UQQiiL30G3r33FoVp0obeVSSHC6ulsJNvln4oYba1ss=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NynwiOMc9wakghECSNMv03GHHnfKS4vnQhv7nzQ+3NRq3Ycvn+iObO2FjChzhSS9LlqkaolwL4mTUyEvqN+d0mSF77biIRQ6f+7TMeXAU1VFde1fHS9u6u5XXok/TXDeeegBl+yrZKEtFxCvtBpSZvkO9cnvS8TYSAB3ELZ8e7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bqtd0ds3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7B7C4CED1;
	Thu, 16 Jan 2025 01:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736989605;
	bh=UQQiiL30G3r33FoVp0obeVSSHC6ulsJNvln4oYba1ss=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bqtd0ds3AU1BHN84VkcdUC2BnlEq9Z7KSBqLqXe5+16+GIhzQEDjI+umFqD5UZ3Ks
	 cHlrSZvI2+gsMrbky+qZsJNavXD2ulrl2w6extl0aZaJJVmQvXDCkJVvJomVon7LML
	 bzra9OioDbUt9Qe+dmMrNpfAcryElDtLwpOmKtdhb8uMv0Q/poFE/cr+n1ppBKknF8
	 9ny6pm+pfODQDK0S0/VddQ+movkujx9OILKY8NJb13pfywbZpBrSBixHW26ce/UUHg
	 eUb34xh83f6JuytjS+S2bKK8rHX6OV5sfulSlQmlRHLAr/TYktLFKzyui6WFDvFP9t
	 kGZ7fkWCROMRQ==
Date: Wed, 15 Jan 2025 17:06:44 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v10 14/22] io_uring/zcrx: grab a net device
Message-ID: <20250115170644.57409b2f@kernel.org>
In-Reply-To: <20250108220644.3528845-15-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
	<20250108220644.3528845-15-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  8 Jan 2025 14:06:35 -0800 David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> Zerocopy receive needs a net device to bind to its rx queue and dma map
> buffers. As a preparation to following patches, resolve a net device
> from the if_idx parameter with no functional changes otherwise.

How do you know if someone unregisters this netdevice?
The unregister process waits for all the refs to be released,
for *ekhm* historic reasons. Normally ref holders subscribe
to netdev events and kill their dependent objects. Perhaps
it is somewhere else/later in the series...

> +#include <linux/rtnetlink.h>

Do you need anything more than rtnl_lock from this header?


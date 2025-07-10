Return-Path: <io-uring+bounces-8644-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C648B00FDD
	for <lists+io-uring@lfdr.de>; Fri, 11 Jul 2025 01:49:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 101F71C47D7B
	for <lists+io-uring@lfdr.de>; Thu, 10 Jul 2025 23:49:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2866E28FA9F;
	Thu, 10 Jul 2025 23:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WxY38zkV"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC61718BC3D;
	Thu, 10 Jul 2025 23:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752191347; cv=none; b=OdvgUB67M63+9xoUPqu50Dosh4yYmSv0mLE6bVIuFtMfHmW9Im/7IsG3GFF/vHLeQ01hLFIFml5ysNtIuC8Lr49YiPTiHUyVfl1o2ujwHBKdiFdCN3UN8BMiVuGbusRnyADj1sz2orRQL4eXvabL5eAezbDqMc1iNd8MoFp2w0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752191347; c=relaxed/simple;
	bh=Cc7T+ceri3CC7yFcfgXnh4yNqtpkNoltJ4xLl75ICmM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vFn6uyNkpu4PiO23OMUKq8gzMedilbeWMCelu6AZeWrcVpT4KhS0kbZKHCcqJm7zcovX8Iez/glVyA9ibaBkyPFQTn6OBr4yFTgt+MBMRIepUeIa4zsvhU6Y2HBQ9BuxmK1Q8OOz9stA4uU4w/l/T76unF9Vz3gbHLO00X5owws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WxY38zkV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3866C4CEE3;
	Thu, 10 Jul 2025 23:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752191346;
	bh=Cc7T+ceri3CC7yFcfgXnh4yNqtpkNoltJ4xLl75ICmM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WxY38zkVPsMzJMHAqIX5+LWywtP0++HgxbhDoGsumzxmjzsA1k/3hMFUivbE2RUbF
	 8jOL8SvtDlN1T+Jydco6NKKoYtXgUfT65iCuUs9PWDLeAYAZQLwTR5tf677etiJq4s
	 QRAVe+3gsmi1E5xYbhJ8z/FTTc/cvfyJOy4FEGksYNKi+I4MYVY6UKxj4wDoq3migB
	 D5hy7S1sFN9QeXdS++SSoW5YhMwm7bJqccrOFyY0yrhZHGt7YsR+qUGh7g88OEXSzd
	 +5Y5ZIg8368yamG9wwsqaJyrJQ9sEeEeHnb2xLyQhtmv2MxXvkeA2kgVdwGubUb3sj
	 XrDPW6ELHAh5A==
Date: Thu, 10 Jul 2025 16:49:03 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: <almasrymina@google.com>, <asml.silence@gmail.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, Jens Axboe <axboe@kernel.dk>, Simona Vetter
 <simona.vetter@ffwll.ch>, Willem de Bruijn <willemb@google.com>, Kaiyuan
 Zhang <kaiyuanz@google.com>, <cratiu@nvidia.com>, <parav@nvidia.com>, Tariq
 Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>
Subject: Re: [PATCH net] net: Allow non parent devices to be used for ZC DMA
Message-ID: <20250710164903.03a962fc@kernel.org>
In-Reply-To: <20250709124059.516095-2-dtatulea@nvidia.com>
References: <20250709124059.516095-2-dtatulea@nvidia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 9 Jul 2025 15:40:57 +0300 Dragos Tatulea wrote:
> For zerocopy (io_uring, devmem), there is an assumption that the
> parent device can do DMA. However that is not always the case:
> ScalableFunction devices have the DMA device in the grandparent.
> 
> This patch adds a helper for getting the DMA device for a netdev from
> its parent or grandparent if necessary. The NULL case is handled in the
> callers.
> 
> devmem and io_uring are updated accordingly to use this helper instead
> of directly using the parent.

Sorry for the silence. I'll reply to Parav on the RFC, I don't think
the question I was asking was answered there.


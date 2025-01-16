Return-Path: <io-uring+bounces-5915-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BFFFA131AD
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 04:12:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A20231886238
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 03:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DD3826AEC;
	Thu, 16 Jan 2025 03:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJIZWcvU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316D4136326;
	Thu, 16 Jan 2025 03:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736997141; cv=none; b=mRAwxWnbmfGbhjueY6LpgE300syRA22z2unVgtutwbK6+nEUO6CRXun0SwM9lS89M4D6qo+zJASBAhgYT821K8BFzh6171L7knDzsU/+GWw4inXjHQleWRK1jo9A19MtYYc/SIRUmR3NXuQ+nKN0MGqqVUb6aLa4EP7/U1T/w7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736997141; c=relaxed/simple;
	bh=ayWlPiJDYf6hwDZV3evf4S+Fawp2noEsHywZrdNbg4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T/iWoEBj8DlV6whoZyVtdoguNcTUWirlTQ5IMd1HFnvr360XYNmI9Yv5dJ45QtJaQdnZ9clKg1ZX3MhR+vN7NhH84HOyU9D8zTqeqwckMBgRd0ilD6ZdipWcQnf66lzjeKEOJRlEL7v8ol4/CYsb7tYlq+2lpEoVe0WB9HbEAaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJIZWcvU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B241AC4CED1;
	Thu, 16 Jan 2025 03:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736997139;
	bh=ayWlPiJDYf6hwDZV3evf4S+Fawp2noEsHywZrdNbg4Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dJIZWcvUC0m82XbYEiG7+EgFCNPTbE6mvPr4BnEZ1TAxyXZ6lNx965Bt67NJfozzS
	 6nCIoSgMsNkxQ9s4eQa3BhEqghitNFjLeYyuL40bYIUwlLxUnISAgmOXs9KqU+kZBh
	 W1t+cYTW7dmgrU0wwdv5ms6j4ueLIgCkc+p85HT6ruhUnJHIrOIa1O/AiHYQ3oYr9F
	 HSgoAV7C53e61yR3vfamTAj13FcLD4Np9KObOIgK8Gea/mQvW6OGbb8ncfiqSJ9fMT
	 kpznUSbCS+zmLsJPZxdzK7Y3WN3F+lMxNx+OTnA/HvFmQKn6nV8dNuufegE8nbgMyg
	 vVcG5QW6cC5gA==
Date: Wed, 15 Jan 2025 19:12:17 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v10 14/22] io_uring/zcrx: grab a net device
Message-ID: <20250115191217.5ab89aa3@kernel.org>
In-Reply-To: <bb19ef4d-6871-4ae9-b478-34dd2efcb361@gmail.com>
References: <20250108220644.3528845-1-dw@davidwei.uk>
	<20250108220644.3528845-15-dw@davidwei.uk>
	<20250115170644.57409b2f@kernel.org>
	<bb19ef4d-6871-4ae9-b478-34dd2efcb361@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jan 2025 02:33:06 +0000 Pavel Begunkov wrote:
> On 1/16/25 01:06, Jakub Kicinski wrote:
> > On Wed,  8 Jan 2025 14:06:35 -0800 David Wei wrote:  
> >> From: Pavel Begunkov <asml.silence@gmail.com>
> >>
> >> Zerocopy receive needs a net device to bind to its rx queue and dma map
> >> buffers. As a preparation to following patches, resolve a net device
> >> from the if_idx parameter with no functional changes otherwise.  
> > 
> > How do you know if someone unregisters this netdevice?
> > The unregister process waits for all the refs to be released,
> > for *ekhm* historic reasons. Normally ref holders subscribe
> > to netdev events and kill their dependent objects. Perhaps
> > it is somewhere else/later in the series...  
> 
> Ok, I can pin the struct device long term instead and kill
> netdev in the uninstall callback off
> unregister_netdevice_many_notify(), if that works with you.

I think that would work. You mean the "underlying" device, right,
netdev->dev.parent ? Like page_pool itself does. SG.


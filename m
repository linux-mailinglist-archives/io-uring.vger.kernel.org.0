Return-Path: <io-uring+bounces-5902-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D947FA13025
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 01:45:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E3011888701
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 00:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B73D217578;
	Thu, 16 Jan 2025 00:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tccUHMO6"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907B1F4FA;
	Thu, 16 Jan 2025 00:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736988303; cv=none; b=Fpjl638tElzpTfFWb64euuXgDpMGb89wJyQmX5mzjCpsIiUIp6gB00TybvXNH10BL7j+dyoUb7CZCGa7Ty98Heku+YBDWONGA3roNZo2aEvryv1so46ktJlKnOnicUlx85OuW6xbf/KcmJLEpOefpZcnKuISdK8ASKORMBbO0KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736988303; c=relaxed/simple;
	bh=xbB3LtN7a7AiiyUthvz8iksP7nB3Z7W+NKcNzFvOCAs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tCmOMLrvjdZdRs3ab/sNcLPVqb9/UeBcOKe3LncUeO+5qG2+V0CGTaQsBypj2xW37dyrYxjQgw0BqU6m+w0bUbbTGpWxDP+TBorlVCqYehnAuaNE03whDRYKz45XFG0b8Yhbdn2MjHuTO8aMaUT4pq1wKnS6sfToUN4xxSAP0Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tccUHMO6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F15FC4CED1;
	Thu, 16 Jan 2025 00:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736988303;
	bh=xbB3LtN7a7AiiyUthvz8iksP7nB3Z7W+NKcNzFvOCAs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tccUHMO6bwQUBvkkRG4hKbyJmB8G5PuuEI3t9ez1ZzgknKXZqFBwmG0B6+Ow81gXx
	 UsRol6UBSZxhJrTZoJw/+tKRKbhSo7l7ACtJR2XyKp6/N1g+KHpLvZ1ri0wHrnHJjK
	 H1LdtYqMz9jYG/mUSzbWf6Qa7TB0yIoxYEXfYeaHnc6K43iKjftprT7D0p+BnVwVE4
	 pPaxOmmEyjxjqyXWGaX1UCI7yQTWnanRUhCFxBITJ+v56ErB9M6nFNl6uHrmcSbIFQ
	 LUQWF8aynK9+LT71Hln0zhijwJJAlKjyFv1I27lTOqISPZFvANZLiH/KWn4QY4xMUf
	 K9lA9Jx+UVqWw==
Date: Wed, 15 Jan 2025 16:45:01 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v10 07/22] netdev: add io_uring memory provider
 info
Message-ID: <20250115164501.0d727a98@kernel.org>
In-Reply-To: <20250108220644.3528845-8-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
	<20250108220644.3528845-8-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  8 Jan 2025 14:06:28 -0800 David Wei wrote:
> Add a nested attribute for io_uring memory provider info. For now it is
> empty and its presence indicates that a particular page pool or queue
> has an io_uring memory provider attached.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>


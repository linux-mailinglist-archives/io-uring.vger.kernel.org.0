Return-Path: <io-uring+bounces-5955-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAB03A147E6
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 03:07:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92C403A75F4
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 02:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE5F1F5616;
	Fri, 17 Jan 2025 02:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q3E/d5r2"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D7B1F5614;
	Fri, 17 Jan 2025 02:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737079646; cv=none; b=BUH4qPH3XAYqp3eSZJ11+K1mryq6rv/ZVyzNc63kiyYOwgT4TokC2KnfFmH7XqaC17PhubfVwm8vb7wsrqrfY4fD69Mc/Ms0BbMYf6CvIcMwWKMNQ6UXJH51jh3s73lJrR3Z61oyNPZ6WCeJXQ/0soBPHfTp34uOhW8K9OY2+dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737079646; c=relaxed/simple;
	bh=kkzjE1abC9f4YTR7CcARJX5dGGH7iZDQUJXe5bBq5Tk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HABATZBDa3jzqS5lTgwTDuhMgT7cLhr+n2iy/1fIyT/VQTq9tZBtLsuK+ICZ8kY5sSGebsiqPOz8aQHlJXMU2zLI9m9ayNX3a0csypKgU/BB43clA2EGGredsH21hBajRld3SjUqhyvIOH/INKWvWoz+k0rKxEIdWTGX9zjpOag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q3E/d5r2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C601DC4CEE4;
	Fri, 17 Jan 2025 02:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737079645;
	bh=kkzjE1abC9f4YTR7CcARJX5dGGH7iZDQUJXe5bBq5Tk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q3E/d5r2fdAZ6LQh0tManqWn+gvDtcCTi0/roDt1h0XzabAv4NtQA/IrIvJ2K9FmK
	 BEwr6RFDjKYP0CEb25IypNVdTB927Lw2BHlyQIRKEl4wVaE/fVSBy6YIlh6bHS0Lka
	 zDsJ9O70pDUcE0oSos9vhQpYXJDWiHCNEHYn5/HU2INRNszGDer9O3q3mPd/4Nvp81
	 kMhFQiQNVGgQZWIaJzeOD4no6C2CmVXOFgU+eRygUUVLxbTWwKHNsMMJuialiNtLKm
	 VT+K895Zp0ewsXYsY5l+cie/8pOLHWLaUwAl0pRQ3xaTY62gykWAutMUXcjvsrKyj6
	 KjCVJM3OF+ApQ==
Date: Thu, 16 Jan 2025 18:07:23 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v11 14/21] io_uring/zcrx: implement zerocopy
 receive pp memory provider
Message-ID: <20250116180723.21a4e637@kernel.org>
In-Reply-To: <20250116231704.2402455-15-dw@davidwei.uk>
References: <20250116231704.2402455-1-dw@davidwei.uk>
	<20250116231704.2402455-15-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jan 2025 15:16:56 -0800 David Wei wrote:
> +	type = rxq ? NETDEV_A_QUEUE_IO_URING : NETDEV_A_PAGE_POOL_IO_URING;
> +	nest = nla_nest_start(rsp, type);
> +	nla_nest_end(rsp, nest);

nla_nest_start() can fail, you should return -EMSGSIZE if it does


Return-Path: <io-uring+bounces-5954-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DDACCA147C4
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 02:53:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1163D1649BB
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 01:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8490C1E1023;
	Fri, 17 Jan 2025 01:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YAq5rekm"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8C617084F;
	Fri, 17 Jan 2025 01:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737078778; cv=none; b=JralM9OwzOClYg4E7aov1nZ/h1f7hz8GVqh9HIDx3wX0PNZHr5hObzGP6c9zEAR60QN9GUDBp4EfG5DO0oF/EcYW6U6OO7b1p/coC/CQXtEEVxNp9r59lxl7XhItRy1GQOkmkjSQyFnszMzDwayTrPGSytJad1ajA2L0ipQO/Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737078778; c=relaxed/simple;
	bh=8P0nfmSONtg9xE/89d2qRdrgytSOGiC3tWtSxIADAic=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=diYISPqUYavesvdTygGEIlGvRxZ3+km1WjhGkutLdwVrpOfiVvolTofeOwFMeWZtzIuO60P4WlbwUWtuT8+CGLEzY/4Jp3KZrxvLemIa899UP3sdGliivtLWxmu+3+RvDpe1akXfuDlzqQKWPZamefGE3rCIw9vebLouhmqAZqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YAq5rekm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A46BC4CED6;
	Fri, 17 Jan 2025 01:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737078777;
	bh=8P0nfmSONtg9xE/89d2qRdrgytSOGiC3tWtSxIADAic=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YAq5rekmeZE68ZEiDU5txVN7KBxSX8eHne04f557/YgHFp2r9NsFSbaFai4+qolWP
	 4HLzZyTcn2nN8YZM4wShV7EqgwVnVY2U2BSd2c5840YPW+JUr21nF/mqt9HW/pwwZ5
	 XuVOcRhinohZqXie2QJtOoOJoQmuFAcNjUrG3RiR5EuemdAyyhyQT5o0kllv8XJQpf
	 lkgwLiw5yvb+nn7ttHUaksdVZclqlB4T5VISbnp3WpPKM9cEFtmjA3Nqwo9PSw0QkC
	 c0EYmHa2/vSaIZdwvdyAcqSgeNLgKuFwYcLvvlTY4tqk9uGunkDRjadIRaFqw3sSey
	 Jj0H35HKM5rFQ==
Date: Thu, 16 Jan 2025 17:52:56 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v11 10/21] net: add helpers for setting a
 memory provider on an rx queue
Message-ID: <20250116175256.6c1d341c@kernel.org>
In-Reply-To: <20250116231704.2402455-11-dw@davidwei.uk>
References: <20250116231704.2402455-1-dw@davidwei.uk>
	<20250116231704.2402455-11-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jan 2025 15:16:52 -0800 David Wei wrote:
> +	ret = netdev_rx_queue_restart(dev, ifq_idx);
> +	if (ret)
> +		pr_devel("Could not restart queue %u after removing memory provider.\n",
> +			 ifq_idx);

devmem does a WARN_ON() in this case, probably better to keep it
consistent? In case you need to respin


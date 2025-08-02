Return-Path: <io-uring+bounces-8880-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8600DB189C0
	for <lists+io-uring@lfdr.de>; Sat,  2 Aug 2025 02:10:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4602A3AF3E2
	for <lists+io-uring@lfdr.de>; Sat,  2 Aug 2025 00:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02ECA7F9;
	Sat,  2 Aug 2025 00:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBZj/tsa"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF606367;
	Sat,  2 Aug 2025 00:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754093410; cv=none; b=Ky9R4zOY/t7en+VyZoA9awSyQRU+XOCDmNibsB6stDdIe6BMFHiEUAOUwbwq7Xoj5N9a2uIhrAX7iaqEUY1LTK5T1JbIoFuVQM926Jpq5YBuwfVp22UEwLo8+bLdMktprGMoivmMoys089lj5+vXHnR6wqUsuPdIOMGQ7OibhJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754093410; c=relaxed/simple;
	bh=/MnMpxIUciJbNrcAK4yL1/ewUFVeLs44lMszgY7U2DI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U2lxPnGbZB1+2/aYeRdf4k9d21FB2uGTAsCTY85233UDGP8GzYG6uFoaInee5qlOOXgn97X76npCd6q8gkwx6HH7/HP4+RrdVHPbxbK1MXmbF0vtwYhdxuzH8fYmV5mSPvie8HaGlhvTzzkg97Ii+yHmTPuhg3AzI7iREQYwi+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBZj/tsa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D357CC4CEE7;
	Sat,  2 Aug 2025 00:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754093410;
	bh=/MnMpxIUciJbNrcAK4yL1/ewUFVeLs44lMszgY7U2DI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dBZj/tsaZuFPcHjJyPOgeP7ytQJpyOYBT8VXtQET5lgtWj8unMsROz7KqaHGkCMlN
	 0sqOtH8HcU9KXVqKmkINdsdNi7Af5xOfak9fRI54e6HxKt1QsjCtukuqtYi+jbCQhA
	 djlkdZvu3z1UZHtwBqrivlvHquKWXn7oa6YVCxwfIc8ditP3xK2dYuBIPFsXHUBg+p
	 uzx0HW5us6Y7Doh97AUbAE1RPhEPDW/9RHwOCHw+NuHou7Kj4mLGWx7LROxLE7xfZM
	 v05Z229rxXuNsDWsorEzhorBr6KgfMpezJ4U+7BtBqt+mg+b/8XpCBHcmvhCyjuIjc
	 AqoWiNtGqA0OQ==
Date: Fri, 1 Aug 2025 17:10:09 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, io-uring@vger.kernel.org, Eric Dumazet
 <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, Paolo Abeni
 <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org,
 davem@davemloft.net, sdf@fomichev.me, almasrymina@google.com,
 dw@davidwei.uk, michael.chan@broadcom.com, dtatulea@nvidia.com,
 ap420073@gmail.com
Subject: Re: [RFC v1 21/22] net: parametrise mp open with a queue config
Message-ID: <20250801171009.6789bf74@kernel.org>
In-Reply-To: <ca874424e226417fa174ac015ee62cc0e3092400.1753694914.git.asml.silence@gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
	<ca874424e226417fa174ac015ee62cc0e3092400.1753694914.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Jul 2025 12:04:25 +0100 Pavel Begunkov wrote:
> This patch allows memory providers to pass a queue config when opening a
> queue. It'll be used in the next patch to pass a custom rx buffer length
> from zcrx. As there are many users of netdev_rx_queue_restart(), it's
> allowed to pass a NULL qcfg, in which case the function will use the
> default configuration.

This is not exactly what I anticipated, TBH, I was thinking of
extending the config stuff with another layer.. Drivers will
restart their queues for most random reasons, so we need to be able 
to reconstitute this config easily and serve it up via
netdev_queue_config(). This was, IIUC, also Mina's first concern.

My thinking was that the config would be constructed like this:

  qcfg = init_to_defaults()
  drv_def = get_driver_defaults()
  for each setting:
    if drv_def.X.set:
       qcfg.X = drv_def.X.value
    if dev.config.X.set:
       qcfg.X = dev.config.X.value
    if dev.config.qcfg[qid].X.set:
       qcfg.X = dev.config.qcfg[qid].X.value
    if dev.config.mp[qid].X.set:               << this was not in my
       qcfg.X = dev.config.mp[qid].X.value     << RFC series

Since we don't allow MP to be replaced atomically today, we don't
actually have to place the mp overrides in the config struct and
involve the whole netdev_reconfig_start() _swap() _free() machinery.
We can just stash the config in the queue state, and "logically"
do what I described above.


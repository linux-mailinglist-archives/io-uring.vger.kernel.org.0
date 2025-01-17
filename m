Return-Path: <io-uring+bounces-5990-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF581A1596E
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 23:11:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D2603A8A52
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 22:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8A01AA1C1;
	Fri, 17 Jan 2025 22:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="It+pmkgG"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EF019E7D1;
	Fri, 17 Jan 2025 22:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737151898; cv=none; b=qv5EAWr3A+dTRibJ7MYOY36DmEU8LBwzciXJfRnmd3eqzdj245m8E4Hz/J9TJyUNh8d62t7Y9JrvB136T51qpGklMyOsBT3prkyTR2lZ38QyJAc+kbsHZ9ausotkySbqUl3jhHfI0rAVM2Kl55tGJ+FE1zadGt3Z3zknqBmzmVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737151898; c=relaxed/simple;
	bh=zcwjmtBQNAQplmMGQ+SiJQ3wHsv/XEhjfI5+v6/YY8I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p81avnJm7eFnfIZeks2m7hZ1abAicVA/lBOVQ5Wg8GzMbmJx6lcFs3zHwpsudtxbn0FxEUzrX5dJUl7eAmV2ATRgkKrRePzakLQ06Qt+wsdv5ZesumSI8RMa6xKazyfNFgaHONF93Pkg6SOh8VLn/xB6zYhVWjOHoubIsCMt294=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=It+pmkgG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557EEC4CEDD;
	Fri, 17 Jan 2025 22:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737151897;
	bh=zcwjmtBQNAQplmMGQ+SiJQ3wHsv/XEhjfI5+v6/YY8I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=It+pmkgGEDzmQCrxJxN3K87r8bn0odnpo17kNjgt2q0gZD+clpAvX/8/Y4ffwm4Ag
	 oFFemwqDKPTjz5KuWFrhVx5imyrZ7Bhq9Iq/oUME5ck10QvW2QzC2JV3oXTwPkXt6Q
	 WH9xD+uqkxWhpaiuT0KyqLRARSY/BhIHp7I/4jbFpERpEGbaHscMlhAmbmlChUD1l+
	 7uSUZsPYlU+mkGQl/uE2mKIfoYIxbRjcgQFZ9leDgQdkbbnM1lvaM4KotT5BAttwba
	 uz67AOexRdgq9XQ4+lTm4fuNEmCHAoigj2qdcafUN1FiJ5Dy0Bh88p7uLVKQTlQPGn
	 NH9lMrN8K4U+g==
Date: Fri, 17 Jan 2025 14:11:36 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>, Mina Almasry
 <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Stanislav Fomichev <stfomichev@gmail.com>, Joe
 Damato <jdamato@fastly.com>, Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v11 10/21] net: add helpers for setting a
 memory provider on an rx queue
Message-ID: <20250117141136.6b9a0cf2@kernel.org>
In-Reply-To: <939728a0-b479-4b60-ad0e-9778e2a41551@gmail.com>
References: <20250116231704.2402455-1-dw@davidwei.uk>
	<20250116231704.2402455-11-dw@davidwei.uk>
	<20250116182558.4c7b66f6@kernel.org>
	<939728a0-b479-4b60-ad0e-9778e2a41551@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 Jan 2025 02:47:15 +0000 Pavel Begunkov wrote:
> >> +	rxq = __netif_get_rx_queue(dev, ifq_idx);  
> > 
> > I think there's a small race between io_uring closing and the netdev
> > unregister. We can try to uninstall twice, let's put  
> 
> They're gated by checking ifq->netdev in io_uring code, which is
> cleared by them under a spin. So either io_uring does
> __net_mp_close_rxq() and ->uninstall does nothing, or vise versa.

True, so not twice, but the race is there. It's not correct to call
ops of a device which has already been unregistered.

Mina, did we consider that the device may be closed when the provider
is being bound? Perhaps that's what you meant when you were reviewing
the netdevsim patches! 

Do we need something like this?

---->8------------

From: Jakub Kicinski <kuba@kernel.org>
Subject: net: devmem: don't call queue stop / start when the interface is down

We seem to be missing a netif_running() check from the devmem
installation path. Starting a queue on a stopped device makes
no sense. We still want to be able to allocate the memory, just
to test that the device is indeed setting up the page pools
in a memory provider compatible way.

Fixes: 7c88f86576f3 ("netdev: add netdev_rx_queue_restart()")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/netdev_queues.h |  4 ++++
 net/core/netdev_rx_queue.c  | 16 ++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index 5ca019d294ca..9296efeab4c0 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -107,6 +107,10 @@ struct netdev_stat_ops {
  *
  * @ndo_queue_stop:	Stop the RX queue at the specified index. The stopped
  *			queue's memory is written at the specified address.
+ *
+ * Note that @ndo_queue_mem_alloc and @ndo_queue_mem_free may be called while
+ * the interface is closed. @ndo_queue_start and @ndo_queue_stop will only
+ * be called for an interface which is open.
  */
 struct netdev_queue_mgmt_ops {
 	size_t			ndo_queue_mem_size;
diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index b02b28d2ae44..9b9c2589150a 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -38,13 +38,17 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 	if (err)
 		goto err_free_new_queue_mem;
 
-	err = qops->ndo_queue_stop(dev, old_mem, rxq_idx);
-	if (err)
-		goto err_free_new_queue_mem;
+	if (netif_running(dev)) {
+		err = qops->ndo_queue_stop(dev, old_mem, rxq_idx);
+		if (err)
+			goto err_free_new_queue_mem;
 
-	err = qops->ndo_queue_start(dev, new_mem, rxq_idx);
-	if (err)
-		goto err_start_queue;
+		err = qops->ndo_queue_start(dev, new_mem, rxq_idx);
+		if (err)
+			goto err_start_queue;
+	} else {
+		swap(new_mem, old_mem);
+	}
 
 	qops->ndo_queue_mem_free(dev, old_mem);
 
-- 
2.48.1




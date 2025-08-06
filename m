Return-Path: <io-uring+bounces-8886-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97342B1BDB7
	for <lists+io-uring@lfdr.de>; Wed,  6 Aug 2025 02:05:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64C8C189D0CC
	for <lists+io-uring@lfdr.de>; Wed,  6 Aug 2025 00:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE6B336B;
	Wed,  6 Aug 2025 00:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mYaHZHnE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67131114;
	Wed,  6 Aug 2025 00:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754438713; cv=none; b=iJpqvdiworuDeMr7bRmTEkx9lQgblB9QqaigD48bia5Dk3TEAbFzgTrwyFm4abT+b9002nyDHLP5SC5b4H4wm4gDZdUp1xSSz94NALDXbmFO+m9Js2hcnqqy2iFsubcuN50HeBmmLEpbNw7P9i7xGQiSC1s3Vd2k/IHA5wQtofo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754438713; c=relaxed/simple;
	bh=P00i4GtZejZ/n1LkusAVklmnoOuvCTiojcgIjHQOTpU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ffq63IS3+miDwBJuy7jgf+6HJDgriz2oVMHHlZmQo7KXGTuRLVZxbzhl9jxtIsdGtoU4X2cLKOOtSX4z0S8F0My7roGLkhfc5ZF6iB5/LblSJK2DjL0jK6qHmuz8qydgqbZt5cppfl8XPeQ6TdwOb3/l8vplESz4lnP0X2JSucY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mYaHZHnE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAF2C4CEF0;
	Wed,  6 Aug 2025 00:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754438713;
	bh=P00i4GtZejZ/n1LkusAVklmnoOuvCTiojcgIjHQOTpU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mYaHZHnEVHImcBFttT9nh2lADoXszkW+AdmZSkil5HEL4e2a1+R2ILrqvkU3H+9Mr
	 hBue5jzuFH7DSNYJs93mw8wLBxG2o+UIbavu8ahIvHyUy1iGV1gq9uTFXvj09Rffe1
	 zUviiaDLqTyb0Y8Js+zjglX6sPH6bgk3t2LayL1HRXfdCYnrpYRWKZUy3ZOCyOFqxR
	 DNIjXgMtG8S5fESEE18URYxvJ6C/zaGEfsXGdm8JwHKUkxyB9M/ywItaWTNwO+oQY8
	 l25Ieyg5ohaXB1PpagR6RdhWICBC038BHNAtwguVNZH8hc20faaFpsD6PIb19ljWs5
	 6BkG9DItHrtDA==
Date: Tue, 5 Aug 2025 17:05:12 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, io-uring@vger.kernel.org, Eric Dumazet
 <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, Paolo Abeni
 <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org,
 davem@davemloft.net, sdf@fomichev.me, almasrymina@google.com,
 dw@davidwei.uk, michael.chan@broadcom.com, dtatulea@nvidia.com,
 ap420073@gmail.com
Subject: Re: [RFC v1 21/22] net: parametrise mp open with a queue config
Message-ID: <20250805170512.37cd1e7e@kernel.org>
In-Reply-To: <11caecf8-5b81-49c7-8b73-847033151d51@gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
	<ca874424e226417fa174ac015ee62cc0e3092400.1753694914.git.asml.silence@gmail.com>
	<20250801171009.6789bf74@kernel.org>
	<11caecf8-5b81-49c7-8b73-847033151d51@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 4 Aug 2025 13:50:08 +0100 Pavel Begunkov wrote:
> I was thinking stashing it in struct pp_memory_provider_params and
> applying in netdev_rx_queue_restart().

Tho, netdev_rx_queue_restart() may not be a great place, it's called
from multiple points and more will come. net_mp_open_rxq() /
net_mp_close_rxq() and friends are probably a better place to apply
and clear MP related overrides.


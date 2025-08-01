Return-Path: <io-uring+bounces-8875-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B84F5B1895C
	for <lists+io-uring@lfdr.de>; Sat,  2 Aug 2025 01:13:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41DB01C8458A
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 23:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75C52367AA;
	Fri,  1 Aug 2025 23:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a03KvqCc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803A6207E03;
	Fri,  1 Aug 2025 23:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754090008; cv=none; b=omQ6OTM1XSorGFC/LCRC8wTj3BH+9qa3QUhFlFnTJZjiY8BJ6byXDquRclF/rkQ2eu4oO80HoD3dcrCGiLdLORNVqAjEfKeuJwJOg5FSCrxFEaL8kmKV2luN/VLA+x1GBs4K7Gi/O5xmAf62vpOPLmj02T0VOpAQklFBydkz/1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754090008; c=relaxed/simple;
	bh=PbmVT+aZ97NnJsYCnw1t/hlWOFNuS1awopSGnf7MeIs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oC1nrJpaeWrZhK73SkqZQWP1jUBUXHU2fV079M/lCLbWVzznfJVFqY5J5r9Yfr3S5SPwjua3TDMiNQm/qUjZ4shQncQFqTtc93qIz6jBYcqx1rS8PVeeeYzqHuICSPzOYb1IHJIqUdsV+FgSzs1DALYPfKRGLKMRnK2dFWikoAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a03KvqCc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796B6C4CEE7;
	Fri,  1 Aug 2025 23:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754090008;
	bh=PbmVT+aZ97NnJsYCnw1t/hlWOFNuS1awopSGnf7MeIs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=a03KvqCcA6AsOzfJsa8AEV1/rG+HvYRORZ3L4tzVubNbZFaWla1kMULUhYoG3NI+O
	 8H2YGfVFbhiZk+850/6o3y/Oizg6KyKANK6LOGeUf2PQ89NyMu1q74MsASx9zPo8Uw
	 C2FT0YSTp41xrUKYpm6srGAV+JxGSYSHAEn7nK2CiBvfcD2epIyBuVeH5gWnO5e6Qi
	 ixykn898TIeLhT71eMDEDNWbwr/msOGw03KqOC6BpBNsOXZdtHo8YE25c9aQdtsOOD
	 WcEFfCZjphuEhhcc3a70E2CgEkQnvD78ZJJquROHsGjWxyw/HDU8krIT0wMG+oD3/H
	 cgitqFNpeU+Nw==
Date: Fri, 1 Aug 2025 16:13:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org,
 io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Willem de
 Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, dw@davidwei.uk, michael.chan@broadcom.com,
 dtatulea@nvidia.com, ap420073@gmail.com
Subject: Re: [RFC v1 01/22] docs: ethtool: document that rx_buf_len must
 control payload lengths
Message-ID: <20250801161326.6dd670be@kernel.org>
In-Reply-To: <CAHS8izN_TEY3PuHmW6czP0Ce00gfCOgUCW0vJNzakBeYRFAGgg@mail.gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
	<e131c00d9d0a8cf191c8dbcef41287cbea5ff365.1753694913.git.asml.silence@gmail.com>
	<CAHS8izN_TEY3PuHmW6czP0Ce00gfCOgUCW0vJNzakBeYRFAGgg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Jul 2025 14:36:37 -0700 Mina Almasry wrote:
> > +``ETHTOOL_A_RINGS_RX_BUF_LEN`` controls the size of the buffer chunks driver
> > +uses to receive packets. If the device uses different memory polls for headers
> > +and payload this setting may control the size of the header buffers but must
> > +control the size of the payload buffers.
> > +  
> 
> To be honest I'm not a big fan of the ambiguity here? Could this
> configure just the payload buffer sizes? And a new one to configure
> the header buffer sizes eventually?
> 
> Also, IIUC in this patchset, actually the size applied will be the
> order that is larger than the size configured, no? So a setting of 9KB
> will actually result in 16KB, no? Should this be documented? Or do we
> expect non power of 2 sizes to be rejected by the driver and this API
> fail?

This is an existing parameter.


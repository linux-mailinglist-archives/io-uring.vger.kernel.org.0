Return-Path: <io-uring+bounces-8893-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB8FFB1CEF1
	for <lists+io-uring@lfdr.de>; Thu,  7 Aug 2025 00:05:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D708958034A
	for <lists+io-uring@lfdr.de>; Wed,  6 Aug 2025 22:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7634F221269;
	Wed,  6 Aug 2025 22:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKKKifhf"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5D920E6E2;
	Wed,  6 Aug 2025 22:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754517938; cv=none; b=oE6Fh58/5n+vj2a3hYvZHU94TZwrM2SYzMJdhyMQTjaOUscnJX3glQRmudiTgcozjxnmhzouTNOobRS/kgyFxQXLepTDjs3WEVpFFadRZqvL4eI8611oz0FG6J0V57/pdtF0AogSaP6tkIYzmB5Ioqp60p0sKhOKcWHphRJ5Mdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754517938; c=relaxed/simple;
	bh=on45DUwgwYPDa4uHN4l08kiArDOB9mQ8576Tohd6mAc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=skdYHAO29x9lRnLzM43k/9KOVjaj9YcnoZt/M/JYqdbQkWQD9FVyXXmrgUTR1s7WrvggTtkAa18kZIcuqPwimKtWexnaLkmspYa4owRl08Tlt51xC3Ayj46YfwLHzEFiYb88bup7GgPj7QccF4aATiuAjfWJ128oU+A1xo+31ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKKKifhf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF3BC4CEE7;
	Wed,  6 Aug 2025 22:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754517936;
	bh=on45DUwgwYPDa4uHN4l08kiArDOB9mQ8576Tohd6mAc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dKKKifhf7Ybr5W4CMnHQd44iRar6TLvLPv10J/qsUYTNP4IRbXLoiZ1ABdYFGtexm
	 oaUe17yc1T3DWXW7PZbhpl/IxDTM5cntlCWEFBCs3liI4rcO92BgnG2uIjbH3vCaWY
	 8gzcLQVwLuo72r9yCRQhD/1zUZTYXxCoB8biH23wJpv94EIQuTsDhLziIN99S86qaa
	 OmBJQR0LzWIZDsMKXp4bpwKF7x8Wwz6CTggYlTNm5TULwt2AKQ3BZCyNaEjNqN2QGr
	 EzqJCsyQvvnyf46kQCVSBYIJW0znZpWgwryQgI3sMZ3VmA6lk1HWtvWFROwlStqWRJ
	 +4Xz0s/nKmnUA==
Date: Wed, 6 Aug 2025 15:05:35 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org,
 io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Willem de
 Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, dw@davidwei.uk, michael.chan@broadcom.com,
 dtatulea@nvidia.com, ap420073@gmail.com
Subject: Re: [RFC v1 21/22] net: parametrise mp open with a queue config
Message-ID: <20250806150535.4ce40014@kernel.org>
In-Reply-To: <CAHS8izM-JrPV7R4wk7WnO-Zskb=7gj+HtewoW91cEtsQP1E5rw@mail.gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
	<ca874424e226417fa174ac015ee62cc0e3092400.1753694914.git.asml.silence@gmail.com>
	<20250801171009.6789bf74@kernel.org>
	<11caecf8-5b81-49c7-8b73-847033151d51@gmail.com>
	<CAHS8izNc4oAX2n3Uj=rMu_=c2DZNY6L_YNWk24uOp2OgvDom_Q@mail.gmail.com>
	<20250806111108.33125aa2@kernel.org>
	<CAHS8izM-JrPV7R4wk7WnO-Zskb=7gj+HtewoW91cEtsQP1E5rw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 6 Aug 2025 11:30:38 -0700 Mina Almasry wrote:
> Sorry, I was disagreeing. The flow above seems complicated. I'm
> probably missing something that requires this complication. I was
> suggesting an approach I find more straightforward. 
>
> Something like:
>   nedev_config = get_driver_defaults()
>   qcfg = get_driver_defaults()
> 
>   for each setting:
>     if qcfg[i].X is set:
>        use qcfg[i].X
>     else
>       use netdev_config.X

IMO the rules on when to override/update and reset qcfg[i].X will
get much more complicated than the extra `else if` in this logic.

Plus I suspect at some point we may want to add another layer here
for e.g. a group of queues delegated to the same container interface
(netkit, veth, ipvlan etc.) So I want to establish a clear model
rather than "optimize" for the number of u32 variables.

Most code (drivers) should never be exposed to any of this, they
consume a flattened qcfg for a reason.


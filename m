Return-Path: <io-uring+bounces-8876-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC5CB1895E
	for <lists+io-uring@lfdr.de>; Sat,  2 Aug 2025 01:14:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DCD2628669
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 23:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC5EA22E402;
	Fri,  1 Aug 2025 23:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBh5gK0M"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2567207E03;
	Fri,  1 Aug 2025 23:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754090081; cv=none; b=PONsbZ5M0Z7T76M9Pq0nqovDykQOFAurj76SoAeD+hJN8RIm18FNldEpUnOMAkPzA/MmCZ9YJDlbypI4H/YRJDe69IfLOemb6oxuP1uJFQSf9AEw+d64zmRcmxPVYi8FkgkDLEGWk6xBYpfTjJX/dycGvcC3g6ffoGx/NKQWEq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754090081; c=relaxed/simple;
	bh=gBhqMNzqmY1g6sGDtalrkkGd7h16B/XJTEH0J/Nxl3s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KIUdL+nVKYphqo85ekbkSebE0acX4uC32KA24QHf+a22GFOea+2KD8IdxnxHDKOyyqc+fb/YkUCsmArQqPv62IKQnz6O72UmaKh6yV2ihD22pn8dJ6eiXOxESU1kqn9pGtwVmey1RQGP0XHCAxpfmfx0JWVI/SNA3h3OtndA9Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBh5gK0M; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0466C4CEE7;
	Fri,  1 Aug 2025 23:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754090081;
	bh=gBhqMNzqmY1g6sGDtalrkkGd7h16B/XJTEH0J/Nxl3s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NBh5gK0MdIORNUolEQcD5oIDSGRzss59e4ev5HesVodIrUNj0ZUsO1Z9EsPouoG5G
	 advf4bZ8DFbUNH35O9fYibKp7xum2mYAJXkzylwjb4HNOGaL16IfRKKG3uFVCg0jyk
	 oyiAQKd7ODIeM6/jCn5znkx5Jbq0/NOOpPkk13o+UQR/f2s0UcztJrfrUaSGpfpAWq
	 NCzHBM+kuEmPG8gWS2yZ1ohS1PCtYc30avmPJDKZsb45euhIWm+lcXX55pvSMkgWab
	 DBRN0bH9hUTiGxjkfDS8+G40Msmk4NLiN4kIJhQ3TYa4pEoQurOeeK0WM9mrwFQ7aH
	 tbEgcZmI6EC3g==
Date: Fri, 1 Aug 2025 16:14:40 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org,
 io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Willem de
 Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, dw@davidwei.uk, michael.chan@broadcom.com,
 dtatulea@nvidia.com, ap420073@gmail.com
Subject: Re: [RFC v1 04/22] net: clarify the meaning of netdev_config
 members
Message-ID: <20250801161440.6f8aeee8@kernel.org>
In-Reply-To: <CAHS8izMAc+fTADD9Uzj-XssdSiUYt81U59+hYkB5b=4W9sGz8Q@mail.gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
	<d8409af4cfe922f663a2f8a7de5fc4881b7fa576.1753694913.git.asml.silence@gmail.com>
	<CAHS8izMAc+fTADD9Uzj-XssdSiUYt81U59+hYkB5b=4W9sGz8Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Jul 2025 14:44:19 -0700 Mina Almasry wrote:
> >  struct netdev_config {
> > +       /* Direct value
> > +        *
> > +        * Driver default is expected to be fixed, and set in this struct
> > +        * at init. From that point on user may change the value. There is
> > +        * no explicit way to "unset" / restore driver default.
> > +        */  
> 
> Does the user setting hds_thres imply turning hds_config to "on"? Or
> is hds_thres only used when hds_config is actually on?

The latter.


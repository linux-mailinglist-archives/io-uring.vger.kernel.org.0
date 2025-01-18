Return-Path: <io-uring+bounces-5993-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 70BF4A15B01
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2025 03:09:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAA8D188AFE7
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2025 02:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17B1D19BBA;
	Sat, 18 Jan 2025 02:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XjNzjv1L"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C474C76;
	Sat, 18 Jan 2025 02:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737166139; cv=none; b=n/SsO0YrsAZ2oe34E+j4MFL8zpmOAgVGyE8PgGHN+uyJrgdXpWgvK6y8deV6y6Ldz6dSNAZ5EnNoCC8hHQUXJdTsgdFMmUcOfG+5xS5HSc44akUqNg7nHXpQfDAQqgUmbRQqzjvHE5fptTzi06/8IWc2VUlc5wgIxZAEfTWrjDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737166139; c=relaxed/simple;
	bh=82C9aPdSv/h/M468ysfIZYI0zf8jEucpgVq4+gRpbxM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Symkhrk1ecl2l2S3IoySJ01p4vecJ2L/npwCC2cbQLrJV25LZLJQI8IeuezQP1A9SjxFvWt6lc4QjRghzgaSHGwGngC/giaEHZaM+zzEb5NGbmmURrZYQsSkLW1IE9+vh4VqQt5Eym/GcX6b6btielKPPxHb1xauvDjeBIQFG7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XjNzjv1L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E34C4CEDD;
	Sat, 18 Jan 2025 02:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737166138;
	bh=82C9aPdSv/h/M468ysfIZYI0zf8jEucpgVq4+gRpbxM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XjNzjv1LeIbPLecxDOAWDXq59StZL1jshSDn87RRVbZAEL64EMtTo9OgV5MR1gC58
	 voLZQs42YUhTJG5F6q92cfn92ONay3KWo7jELDV2elrHmu6CzDSBJUt36DIg4eYMFO
	 wZLlMZn6ftXfHTLGtZ+THh7IxOMMQxR6QcSJoH/3Fol7CcSxHckiVU5tHN5vZ/x2Gd
	 aPW0HTb4bYi3goEu7l7k9TFL1XHMsv8f6PXVCq5MSKSrunVuth4R+SEk/V6uoVJIZH
	 44FvIBtiKJhJB5UpCDVUzI5fOo+M+cTzeiPTA29K0t3DzkipmUzq4bW7Wzizbj7oBa
	 pwS7lP6xEJVcg==
Date: Fri, 17 Jan 2025 18:08:56 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jesper Dangaard
 Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, Stanislav
 Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, Pedro
 Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v11 10/21] net: add helpers for setting a
 memory provider on an rx queue
Message-ID: <20250117180856.42514e9b@kernel.org>
In-Reply-To: <0d851165-dfe3-491a-be8b-77d01ee00de4@gmail.com>
References: <20250116231704.2402455-1-dw@davidwei.uk>
	<20250116231704.2402455-11-dw@davidwei.uk>
	<20250116182558.4c7b66f6@kernel.org>
	<939728a0-b479-4b60-ad0e-9778e2a41551@gmail.com>
	<20250117141136.6b9a0cf2@kernel.org>
	<0d851165-dfe3-491a-be8b-77d01ee00de4@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 Jan 2025 23:20:58 +0000 Pavel Begunkov wrote:
> > True, so not twice, but the race is there. It's not correct to call
> > ops of a device which has already been unregistered.  
> 
> Ok, from what you're saying it's regardless of the netdev still
> having refs lingering. In this case it was better a version ago
> where io_uring was just taking the rtnl lock, which protects
> against concurrent unregistration while io_uring is checking
> netdev.

Yes, v9 didn't have this race, it just didn't release the netdev ref
correctly. Plus we plan to lift the rtnl_lock requirement on this API 
in 6.14, so the locking details best live under net/

The change I suggested to earlier should be fine.

 - If uninstall path wins it will clear and put the netdev under the
   spin lock and the close path will do nothing.

 - If the close path grabs the netdev pointer the uninstall path will 
   do nothing in io_uring, just clear the pointers in net/ side. Then 
   the close path will grab the lock in net_mp_open_rxq() see the netdev
   as unregistered, return early, put the ref.

Did I miss something?

> Does your patch below covers that?

My patch below is semi-related. It prevents us from calling 
the start/stop but we shouldn't call the alloc/free either, 
after we enter unregister. IOW this patch fixes devmem but
io_uring needs more. I think the "entry point" such as
net_mp_close_rxq() is appropriate for netdev state validation,
rather then the bowels of netdev_rx_queue_restart().

> Or does it have to be resolved in this set? I assume you're going to
> queue it as a fix.

Yes, just hoping to hear from Mina first.


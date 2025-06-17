Return-Path: <io-uring+bounces-8405-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E76ADDEBD
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 00:29:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CDD0F7A5B2B
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 22:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D5A293C5B;
	Tue, 17 Jun 2025 22:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RufVZDS7"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AAB2F5312;
	Tue, 17 Jun 2025 22:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750199365; cv=none; b=noSPpztuBzvF9pt+cDCRJ+aLugF0mMyRvX7zwj+IHhrh6RmJXq1B1eI/eTtbg/JpzIeaux5J0vLsnRgojjUL5ZvvREDdwTarHXZ7+j/SwYpDOCUOAMJMApu1v7GRpOtg2Uhin1pM8NmEju+xF4lBlKt9BAMk3pQ4yvphe0BFC80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750199365; c=relaxed/simple;
	bh=QJ1n1NnRMG8vhqAxWWAHSQAiiQAgwBeioj7GJRcNK4o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BV8aaTpyrszxPGHbTzZna8ceNCIQddqxO2jaguS9E1n0Sj8i6/OSHenJylRW1tERUSQZrdnIiO9xu9/cvntwmrN6YJbReBvAMeL7ia8sxewuOkkxcAkT1PT6Hm9ogsXttVR1OGy6jsjpqJGPcAehFYcqRSbkiOnUDpc/g7EQmpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RufVZDS7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A976C4CEE3;
	Tue, 17 Jun 2025 22:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750199365;
	bh=QJ1n1NnRMG8vhqAxWWAHSQAiiQAgwBeioj7GJRcNK4o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RufVZDS7kZNYjt6zFgqrNkcRj/yaq1iBekMAK9vEZFtmRvUEB6ObgV3kiXPD0pkih
	 uB58xPP55H7o7mo8z30a12p/7wbjY7+9H5CvySrmgTmiZN1yx/kmV1YidADoxJiD9i
	 T7zY15kFWkcV0A1AVQfvB3jHP+bq+LRVTVsYYsJF95HxeCUCh0jQPwDQr2wf65ArZ5
	 iBqIgmLAISKtsId8PC3XE36CxEB2i1Ol0zHHuza2x76xr8p25c5ie1efi2Z28xXshY
	 Qraw+MkCu6CnifaMK0bE/85fQeZ2JeSIixEHMQCRdgJJe0u6pRh+pwgnnG+oqLYWc/
	 N5Vg0g7IO/M7Q==
Date: Tue, 17 Jun 2025 15:29:23 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, Vadim
 Fedorenko <vadim.fedorenko@linux.dev>, netdev@vger.kernel.org, Eric Dumazet
 <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni
 <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, "David S .
 Miller" <davem@davemloft.net>, Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing
 <kerneljasonxing@gmail.com>
Subject: Re: [PATCH v5 0/5] io_uring cmd for tx timestamps
Message-ID: <20250617152923.01c274a1@kernel.org>
In-Reply-To: <efd53c47-4be9-4a91-aef1-7f0cb8bae750@kernel.dk>
References: <cover.1750065793.git.asml.silence@gmail.com>
	<efd53c47-4be9-4a91-aef1-7f0cb8bae750@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Jun 2025 08:52:35 -0600 Jens Axboe wrote:
> On 6/16/25 3:46 AM, Pavel Begunkov wrote:
> > Vadim Fedorenko suggested to add an alternative API for receiving
> > tx timestamps through io_uring. The series introduces io_uring socket
> > cmd for fetching tx timestamps, which is a polled multishot request,
> > i.e. internally polling the socket for POLLERR and posts timestamps
> > when they're arrives. For the API description see Patch 5.
> > 
> > It reuses existing timestamp infra and takes them from the socket's
> > error queue. For networking people the important parts are Patch 1,
> > and io_uring_cmd_timestamp() from Patch 5 walking the error queue.
> > 
> > It should be reasonable to take it through the io_uring tree once
> > we have consensus, but let me know if there are any concerns.  
> 
> Sounds like we're good to queue this up for 6.17?

I think so. Can I apply patch 1 off v6.16-rc1 and merge it in to
net-next? Hash will be 2410251cde0bac9f6, you can pull that across.
LMK if that works.


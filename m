Return-Path: <io-uring+bounces-9629-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B256B47CE9
	for <lists+io-uring@lfdr.de>; Sun,  7 Sep 2025 20:47:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 06A574E0116
	for <lists+io-uring@lfdr.de>; Sun,  7 Sep 2025 18:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408101A2389;
	Sun,  7 Sep 2025 18:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="rjl9vFWb"
X-Original-To: io-uring@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFBC23741
	for <io-uring@vger.kernel.org>; Sun,  7 Sep 2025 18:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757270861; cv=none; b=ZfO8Gjpb+H3jYHUaz4sNbTmaR3gxBk81GzbNbvf2zzAiIrDvSqxNCBiCFlWMJYd0cAZkbGInzvjdFE0dngsXbIjB730ycc06WkpGc7oJPFppg3adQJamP2Ga+T3qA/gpsxCAC4uBeVozytHL/DKn35Iv1Vpj1piIFMxP3unOgTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757270861; c=relaxed/simple;
	bh=KLPAPQig9CQDwMtRC7oPOJlFO1Wve3y8xv6yBggX+6I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FBUMAa/iRAnkF1HoBc8OZ/CNu3T0UFZEz6v7yJQkVtqykhYckxahB5moGHL+ep+sA8bOJilDsGchlnq/dcMuNZXNWvqQKPWdx38Mdp9UMh7bUwgEgBr6yqMDx7nVcS3wEQkfNP4rSA/YfLM48StSjQJM1R91j4YxrYfOMDMG5Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=rjl9vFWb; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 8760E40AD8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1757270852; bh=KLPAPQig9CQDwMtRC7oPOJlFO1Wve3y8xv6yBggX+6I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=rjl9vFWbP1Ey3m329KM2wlTbd08ciWUFggT6xKMENkBqj+HR2snaOeoFvgukhI7O1
	 6NY2IiefNnZTvEgVWRru2cKRTHHQ1lYqs4btLMICXuZzEjGIzdjU0zuGrjdmrOEsS2
	 0UeXnJGQPPwhVSLvUSDbg/TMSlKtjDoA8h2phlRMkFl1W8DHgcamWZPXqah48G4Wxu
	 zWQ27UlIYMDio0REPko4DVGsWzo1//1Z7oE2kOnWXvjqNjAtKkQRFFIRvSAgCJ6ct+
	 OADrBkWvJgK4xyTRawEgl2Zx8mdC2Ig3XNsgNOgU7q3KvQsHBZ2SbXwDsruphO49bm
	 Jhast45NTAL8Q==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 8760E40AD8;
	Sun,  7 Sep 2025 18:47:32 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Jens Axboe <axboe@kernel.dk>, Linus Torvalds
 <torvalds@linux-foundation.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>, io-uring
 <io-uring@vger.kernel.org>, Konstantin Ryabitsev
 <konstantin@linuxfoundation.org>
Subject: Re: [GIT PULL] io_uring fix for 6.17-rc5
In-Reply-To: <a65abd25-69bd-4f10-a8b8-90c348d89242@kernel.dk>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <f0f31943-cfed-463d-8e03-9855ba027830@kernel.dk>
 <CAHk-=wgkgSoqMh3CQgj=tvKdEwJhFvr1gtDbK7Givr1bNRZ==w@mail.gmail.com>
 <72fb5776-0c50-42b8-943d-940960714811@kernel.dk>
 <CAHk-=wgdOGyaZ3p=r8Zn8Su0DnSqhEAMXzME91ZD9=8DDurnUg@mail.gmail.com>
 <a65abd25-69bd-4f10-a8b8-90c348d89242@kernel.dk>
Date: Sun, 07 Sep 2025 12:47:31 -0600
Message-ID: <87ecsiyu9o.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jens Axboe <axboe@kernel.dk> writes:

> But it does not have to be in the release notes. Just a separate email
> with LWN/Jon CC'ed, and boom you have your story and people will see it.

No need for the separate email :)

Thanks,

jon


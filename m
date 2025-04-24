Return-Path: <io-uring+bounces-7720-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34D7CA9BB80
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 01:58:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49FDE468186
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 23:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC14222561;
	Thu, 24 Apr 2025 23:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lMSMWtOY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F19A93D;
	Thu, 24 Apr 2025 23:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745539115; cv=none; b=uxc8an5ke9+9VK7zjUfUJGql1GREBbk3rszFvqoT5HfM16BeyNBhgyTkTvI+e2IBMKDoa2OrOZTWrOHhxIVIFFvDe/pJaXYClAsw5wv2j17djdCC5TvXhmvWoDGGFs9OlWPJ9Ijtm+V2HiaJaThGFNarGIvWvcV9eu9ShEvJMKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745539115; c=relaxed/simple;
	bh=XFCFd8zqT3DpwXLOJz4pN3T7itV9dSNzZ5ypj5MV1eA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UiuPjU8nN6+v/tm3puE9e4FLhUzkmaBKJ/xyvxSgiApRd7oHayvlOMO0f+p3MyW4QmsSff2NUklZIi2MhyGHn60746nFZDr4vVMPzCgaFnuziZm5yEbGEKJpsT4Tqbju4jTu2XGPhqDJKf9iXR+nsdUDe36z6ta+6knuAUqerh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lMSMWtOY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCA1C4CEE3;
	Thu, 24 Apr 2025 23:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745539113;
	bh=XFCFd8zqT3DpwXLOJz4pN3T7itV9dSNzZ5ypj5MV1eA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lMSMWtOYmj8X6FOgwf4oyshSamb/wcTl0N2j7OBSewHHqvQv6hRu6+vFyWs10cHN1
	 PA5hjAtnsoNWnmF5jmXwQhsLAByiHt94E73L//J9ASErNwwvluJgZ/nBpW9AERBETn
	 C+bOMzL3mwJCwbBIxtQTbX9Pi5qnAOv0ohN6GozQBNNk1dVGOWtg6giwjZyhArrerL
	 0B3s60p/ZUTcU219WYl1rVi7JBPaA/jE0JQV2DOLgLecgIdN0kEtai+S7sdIVZTXX7
	 MAbhKXLpvFJTe0O0r+rGpFSpiuvRv0t7cHaH27qz5TOCDV8PX04srkAD1Swjrc9HMY
	 KwllSicmAX+cQ==
Date: Thu, 24 Apr 2025 16:58:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Haiyue Wang <haiyuewa@163.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Shuah Khan
 <shuah@kernel.org>, David Wei <dw@davidwei.uk>, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] selftests: iou-zcrx: Get the page size at runtime
Message-ID: <20250424165832.76343239@kernel.org>
In-Reply-To: <46deb974-5e60-477e-8f0c-9eb358369d73@kernel.dk>
References: <20250419141044.10304-1-haiyuewa@163.com>
	<174553616879.1018402.4580438030053211278.b4-ty@kernel.dk>
	<20250424162923.3a0bdfc4@kernel.org>
	<46deb974-5e60-477e-8f0c-9eb358369d73@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 24 Apr 2025 17:34:00 -0600 Jens Axboe wrote:
> On 4/24/25 5:29 PM, Jakub Kicinski wrote:
> > On Thu, 24 Apr 2025 17:09:28 -0600 Jens Axboe wrote:  
> >> Applied, thanks!
> >>
> >> [1/1] selftests: iou-zcrx: Get the page size at runtime
> >>       commit: 6f4cc653bf408ad0cc203c6ab3088b11f5da11df  
> > 
> > Why are you applying this, Jens?  
> 
> Nobody else had picked it up so far, and I already did the equivalent
> one on the liburing side.

I pinged David yesterday and was waiting for his tag.

> > tools/testing/selftests/drivers/net/hw/iou-zcrx.c
> >                         ^^^^^^^^^^^
> > 
> > This is a test which runs in netdev infra, and which we asked for.
> > It was incorrectly initially routed via io-uring trees and then
> > we had to deal with the breakage during the merge window because
> > net/lib has diverged.  
> 
> Come on, it was a one line conflict due to another added test, the
> simplest of all conflicts. If that's "breakage" worth mentioning,
> well...

c0f21784bca5 ("io_uring/zcrx: fix selftests w/ updated netdev Python helpers")


Return-Path: <io-uring+bounces-7718-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EADF5A9BB45
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 01:29:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 31F227B2A26
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 23:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4503628BAB6;
	Thu, 24 Apr 2025 23:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQONbRpD"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092B022127B;
	Thu, 24 Apr 2025 23:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745537365; cv=none; b=qJgMd41H+wBXYvngYKGth6HQ2zHri4fheQFEIb8m5YtmlCW2z97WkiPtuGZaZi6HKJUsWp9M6wQhkAE3xEoP45+ntWgj98UcQGfByl+eZ7sueTMyRBabZEU8bm2V+INiouuVOXJsJfO/qPkHIyNhCWdS/qeVxY+XxWaqcpaR2Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745537365; c=relaxed/simple;
	bh=nZbBdKENwNvL+Rt84Ml95lTelgdIW8nYsNY0qr6f4gs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eKd9FPaVD0JiIDNLWkua2l44rpZQIx3zUx067UJK+mv/Buh7+EFsCJpoHUtmhVG94lZP7R/CGJBM/NJdqUBl3oTeyH7nDvgbnuCCKI2dCH0azWy9eWdGqIqqtBHuUoSXWeYhPoZFcuRaBcxmv4SApcwXAs7RU2nXIfDb5biml4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VQONbRpD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05C3C4CEE3;
	Thu, 24 Apr 2025 23:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745537364;
	bh=nZbBdKENwNvL+Rt84Ml95lTelgdIW8nYsNY0qr6f4gs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VQONbRpDCJpahZ8puEHABJSEPYkAOvPGJwF1j5VDp+xC9uIKXqkpH0rVG6Vk/qBUO
	 A/dXJuPaIeIR8J1OP5TSrDR1uQ5+iR4yQCgvUmMCiyX4qniOlkGgC7NpflFSZrEfez
	 9VCFxzQPr4Y+vjqHpZD2c9fXs/8zMvewC4kan6qbEoFhwR9VZ6OaK2q3jtra05kU4r
	 Mf8LlN7p1hdNHddZ4DIJcdrqygRUzgr5IDBGljq/H62sZIDuNSI3cQMXmHq+40WJQ+
	 eNsIMgdcC7I7gZoHdVTTl8S02BW/f0bJBtd/WrwfxV55CCO2QtdH75wESqQjHtEQTg
	 RbId/3VNuZMdg==
Date: Thu, 24 Apr 2025 16:29:23 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Haiyue Wang <haiyuewa@163.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Shuah Khan
 <shuah@kernel.org>, David Wei <dw@davidwei.uk>, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] selftests: iou-zcrx: Get the page size at runtime
Message-ID: <20250424162923.3a0bdfc4@kernel.org>
In-Reply-To: <174553616879.1018402.4580438030053211278.b4-ty@kernel.dk>
References: <20250419141044.10304-1-haiyuewa@163.com>
	<174553616879.1018402.4580438030053211278.b4-ty@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 24 Apr 2025 17:09:28 -0600 Jens Axboe wrote:
> On Sat, 19 Apr 2025 22:10:15 +0800, Haiyue Wang wrote:
> > Use the API `sysconf()` to query page size at runtime, instead of using
> > hard code number 4096.
> > 
> > And use `posix_memalign` to allocate the page size aligned momory.
> > 
> >   
> 
> Applied, thanks!
> 
> [1/1] selftests: iou-zcrx: Get the page size at runtime
>       commit: 6f4cc653bf408ad0cc203c6ab3088b11f5da11df

Why are you applying this, Jens?

tools/testing/selftests/drivers/net/hw/iou-zcrx.c
                        ^^^^^^^^^^^

This is a test which runs in netdev infra, and which we asked for.
It was incorrectly initially routed via io-uring trees and then
we had to deal with the breakage during the merge window because
net/lib has diverged.

Please revert.


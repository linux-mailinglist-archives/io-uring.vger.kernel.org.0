Return-Path: <io-uring+bounces-10097-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF549BF9439
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 01:40:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAD693B3E1B
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 23:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5191B2BEC31;
	Tue, 21 Oct 2025 23:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QRTYpb/n"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2670F296BBA;
	Tue, 21 Oct 2025 23:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761090001; cv=none; b=WPive4TIvsDwPYtkjRTPaxeZj006j0Hw4keuJuOo5pr1BSrUWZmtNXW7I0bGd1SMsfwtkFKWzQExRR7NW8G91Xvqdh4CNwjhDMcD9+vrHyFs/At1RLUr8BbH327ceKlLLJZLbXxGVdzJ5z1D33slC8g+ShSQKykbTETDbPKFILY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761090001; c=relaxed/simple;
	bh=c5OEpMa2lRTQjoFqV81dEoOSZpF2E3I3SVaf/pU6AHg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j8TL+XbivE2hEoljN5CCEpFdVoZ3WrOLGQbS9MpEvroeLf345D3ACmL9VAJP2GHcZUIvaz4UOG0LFC+GsIBqJYTcNcHN9z8y5YdX7f0hqX1nCXcQhNTobGTqrCG019PD/ibn3NXOxGW2uV2JdJ4E/XWLohSfh520by5P5u/Kn4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QRTYpb/n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754CDC4CEF1;
	Tue, 21 Oct 2025 23:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761090000;
	bh=c5OEpMa2lRTQjoFqV81dEoOSZpF2E3I3SVaf/pU6AHg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QRTYpb/nXwtcnWTJD6YnnVRTC0sM2sciSSp/+5vOIAfR6xP/OAo/4JDJT79z83DaE
	 5Ff9LKAeB8F8ssNBhjGD5hZ4htYNE52m0rwkpNAWK1XU3qX6XV6FMxUD8IDfhnZ3a5
	 fjrH6FrlYALvfjEEuuCwYmPgOgvSZyERA9P7glosIvKgfwCZ8mx/MzykTdR9EJqtxJ
	 Np7dEZto2G6QoUiOVxNkzyKb6N80zU2AdsgSkBpg6IVaHzI8fJDiBUUzvdw+8yPpA3
	 uORLDG2fss4c4eqto1OJCqWkP2WmmOWO7BMj5M3KXC9TVV5HIkOELkFNsd/EB+P/Hi
	 5XRkTk6ZMiFRg==
Date: Tue, 21 Oct 2025 16:39:59 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Pavel Begunkov
 <asml.silence@gmail.com>, Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH 1/1] io_uring zcrx: add MAINTAINERS entry
Message-ID: <20251021163959.5040b7d6@kernel.org>
In-Reply-To: <20251021202944.3877502-1-dw@davidwei.uk>
References: <20251021202944.3877502-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 21 Oct 2025 13:29:44 -0700 David Wei wrote:
> Same as [1] but also with netdev@ as an additional mailing list.
> io_uring zero copy receive is of particular interest to netdev
> participants too, given its tight integration to netdev core.
> 
> With this updated entry, folks running get_maintainer.pl on patches that
> touch io_uring/zcrx.* will know to send it to netdev@ as well.
> 
> Note that this doesn't mean all changes require explicit acks from
> netdev; this is purely for wider visibility and for other contributors
> to know where to send patches.

Thanks David! Not sure how to read the double T, I expected the entry
to be more of a copy of the existing IO_URING one. But it's a step
forward so if Jens is happy with this:

Acked-by: Jakub Kicinski <kuba@kernel.org>


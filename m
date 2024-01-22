Return-Path: <io-uring+bounces-441-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA52F836A55
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 17:25:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64FC9284357
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 16:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C3F61350ED;
	Mon, 22 Jan 2024 15:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aDGgh7M9"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FE554BD5;
	Mon, 22 Jan 2024 15:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705936528; cv=none; b=fIYr2UZdNKki2dJuqcC7W9nB2Kf57VIQO5jDwPbjfKJAaho0MbY4Jjatcreb7qUyN85ewp8YX7DhDtBTqfAHB62KOXl6iPhwON/QNOBFqahN5Yqt69DmibpJUfFkVGnUCm8pOkcuyN63/4TTIZFviO3uU0yBBcEh8wCHA8vvN+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705936528; c=relaxed/simple;
	bh=Wq+J/bSX6S28UFYnl8/zjpUJ5WTGG8m/F/NgLIhrORM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fg1UclE0O61jHwineY0Djj7sI3ocb0MWiMOXkKQu02epjOvqN3xTe2T6c+g0XzgT7GXj13r8cEMYufjLtXskgw5D4gb4/uZcalSRqR7RVxerXGPBkHK/wtWwNmMRgDpYJYk18OBLOVQL26rML+qawMQxeaF3PvP/bygAmL0a3KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aDGgh7M9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C408AC43390;
	Mon, 22 Jan 2024 15:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705936527;
	bh=Wq+J/bSX6S28UFYnl8/zjpUJ5WTGG8m/F/NgLIhrORM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aDGgh7M9VTpABRqrW07YcjUA+clfyADYBM0PPIjRinJwyELMHMNhWC7PwmRhPzSpD
	 R8t8QUFvSqFc8f8bmM9t79CL3oKD8aXAz0pWKQ4y4L7fFgGy46WKzHs53tOL9l+apU
	 r2Kuo/mJ0B+NjdNQmwviSA/pomikSrKwoQMALB50hCUI0H11TtjHs7V5WndvVIfgy/
	 pwqc1h/FLvc/DAfImse7gvq7xd6N6gTqqFE6gxCw902gpDmzF5YnviiayAODkSPVQv
	 axHy1pMubcW1CrbOtwTDCkYc8rsV5p5IS7I21/euVnIK0r89QoW3tYnoUvH51llLz5
	 NSO8/5HObyBUA==
Date: Mon, 22 Jan 2024 16:15:22 +0100
From: Christian Brauner <brauner@kernel.org>
To: Paul Moore <paul@paul-moore.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	linux-security-module@vger.kernel.org, audit@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: IORING_OP_FIXED_FD_INSTALL and audit/LSM interactions
Message-ID: <20240122-desaster-weiten-967544d0d5a1@brauner>
References: <CAHC9VhRBkW4bH0K_-PeQ5HA=5yMHSimFboiQgG9iDcwYVZcSFQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHC9VhRBkW4bH0K_-PeQ5HA=5yMHSimFboiQgG9iDcwYVZcSFQ@mail.gmail.com>

On Fri, Jan 19, 2024 at 11:33:37AM -0500, Paul Moore wrote:
> Hello all,
> 
> I just noticed the recent addition of IORING_OP_FIXED_FD_INSTALL and I
> see that it is currently written to skip the io_uring auditing.
> Assuming I'm understanding the patch correctly, and I'll admit that
> I've only looked at it for a short time today, my gut feeling is that
> we want to audit the FIXED_FD_INSTALL opcode as it could make a
> previously io_uring-only fd generally accessible to userspace.
> 
> I'm also trying to determine how worried we should be about
> io_install_fixed_fd() potentially happening with the current task's
> credentials overridden by the io_uring's personality.  Given that this
> io_uring operation inserts a fd into the current process, I believe
> that we should be checking to see if the current task's credentials,
> and not the io_uring's credentials/personality, are allowed to receive
> the fd in receive_fd()/security_file_receive().  I don't see an
> obvious way to filter/block credential overrides on a per-opcode
> basis, but if we don't want to add a mask for io_kiocb::flags in
> io_issue_defs (or something similar), perhaps we can forcibly mask out
> REQ_F_CREDS in io_install_fixed_fd_prep()?  I'm very interested to
> hear what others think about this.

Right, completely forgot about the creds support in io_uring. Just
disallow this together with FIXED_FD_INSTALL. That's also the gist of
the rest of this thread iiuc.


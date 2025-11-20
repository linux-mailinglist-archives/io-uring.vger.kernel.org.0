Return-Path: <io-uring+bounces-10670-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2202BC71AF4
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 02:30:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9B5664E357D
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 01:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB82238C15;
	Thu, 20 Nov 2025 01:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qZuXaKDP"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E945E10957;
	Thu, 20 Nov 2025 01:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763602158; cv=none; b=qXBAYP0KUSYHuEvwXvQemUWtg3FunNcYELoW+hdkTiu0X3UNOcWyb84pYCbSh05JP+feucQREWAxUKKUx2m1sWt4CTzQgp4S/kISLjribhxRqy8mLqShvSKsY/V1MwMcjTJwbH9KqBRqXfDOSQOYmqLGFRgIlaR5mxCMpIhMCkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763602158; c=relaxed/simple;
	bh=/gsuOrSwXMU6ajTuh8Pi9FCSoC2761pArh9tUcwpPfs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CnQHH03Wm5tgKcA+TlFUwhdmqa20NWk/Ak5dY0ZPFkLkE6RZgQcbqps4RyyTZMYcghviKtAf0nNQR2MRqpcW2OreOm4RUxrMIpb6gUnl8q7j+eneW2OGB6fq1rGrI0b6YM86j3lV3VLffPW9qpFY5vQokBtFcmVuSDz02c6/ig4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qZuXaKDP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AE7C4CEF5;
	Thu, 20 Nov 2025 01:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763602157;
	bh=/gsuOrSwXMU6ajTuh8Pi9FCSoC2761pArh9tUcwpPfs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qZuXaKDP8UOjVOTT3DCza1zvEsEcJLKKICWX5CdeZhmws+kyVkmDYx2C9KC0R7jBX
	 O6W0JewJNAuRY518vpJkHgaEbuulG7ZoTVGAhubYAzrKbeBM2e7Y8q29uXsLgN8tCG
	 zxEzuWJgzPdTutVRrZ6qRw8bAa/WQ++i/jQNGflkMuwX7LOPlqjoCm4Whcn6Weia8Q
	 Z4iyFqJdDvuLowOSRlR8JYlh1UBU+JQd0RxHjmHupEUP4hfbBK6iGrph6w87LTZ3ma
	 eYjmTb+lv9LqIbs3NnBEgnH5Duij925XmPaOtivVPn3eHbk+u0XmKXqFYmonwdHVB6
	 xFArSzxeXWNYA==
Date: Wed, 19 Nov 2025 17:29:16 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Gabriel Krisman Bertazi <krisman@suse.de>
Cc: netdev@vger.kernel.org, io-uring@vger.kernel.org, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 0/3] Introduce getsockname io_uring_cmd
Message-ID: <20251119172916.7fd4a8f1@kernel.org>
In-Reply-To: <8ab727b0-e377-457b-9b3e-2499ea38abc0@kernel.dk>
References: <20251024154901.797262-1-krisman@suse.de>
	<8ab727b0-e377-457b-9b3e-2499ea38abc0@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Nov 2025 16:30:38 -0700 Jens Axboe wrote:
> On 10/24/25 9:48 AM, Gabriel Krisman Bertazi wrote:
> > 
> > This feature has been requested a few times in the liburing repository
> > and Discord channels, such as in [1,2].  If anything, it also helps
> > solve a long standing issue in the bind-listen test that results in
> > occasional test failures.
> > 
> > The patchset is divided in three parts: Patch 1 merges the getpeername
> > and getsockname implementation in the network layer, making further
> > patches easier; Patch 2 splits out a helper used by io_uring, like done
> > for other network commands; Finally, patch 3 plumbs the new command in
> > io_uring.
> > 
> > The syscall path was tested by booting a Linux distro, which does all
> > sorts of getsockname/getpeername syscalls.  The io_uring side was tested
> > with a couple of new liburing subtests available at:
> > 
> >    https://github.com/krisman/liburing.git -b socket
> > 
> > Based on top of Jens' for-next.  
> 
> Ping netdev / networking folks on patches 1+2...

Hm, I think I was hoping to exercise the moderately recent MAINTAINERS
entry here:

NETWORKING [SOCKETS]
M:	Eric Dumazet <edumazet@google.com>
M:	Kuniyuki Iwashima <kuniyu@google.com>
M:	Paolo Abeni <pabeni@redhat.com>
M:	Willem de Bruijn <willemb@google.com>
S:	Maintained
F:	include/linux/sock_diag.h
F:	include/linux/socket.h
F:	include/linux/sockptr.h
F:	include/net/sock.h
F:	include/net/sock_reuseport.h
F:	include/uapi/linux/socket.h
F:	net/core/*sock*
F:	net/core/scm.c
F:	net/socket.c

but now I realize that the submitter hasn't actually CCed the
maintainers :S

Gabriel, please repost this with a more comprehensive CC list...


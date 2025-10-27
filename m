Return-Path: <io-uring+bounces-10251-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E50AC11EC0
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 23:58:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EDDEF4EC91F
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 22:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E59022D12E7;
	Mon, 27 Oct 2025 22:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDJ6/SFO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF471E47C5;
	Mon, 27 Oct 2025 22:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761605874; cv=none; b=ZVRDCrLf3ZH9/pp1gxP8CGPPZEbnG3/EJk9X+EZcggm1qVPUg7iex3zYWWm6g6m2P12UDOClg7T6RGzSZosoS0mRabScfjlYa4ASPj5Z/ILBekIgHF70bQ0yoQnxhJIt2YKxP+FK8XpxvaikqOcsE3BQ4xpejaCjxiIScj20yhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761605874; c=relaxed/simple;
	bh=RKqoVbgI2Ca7FhAx6Dox7tUiovpBfjFmJnQ0ouZqbf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I/MhUROT44uZ77FW9GSrUyhyi7AfYfQz79my6TRbMKytPTq9AfLb1a7e02AuF668FdRRNQAYMqY0FlYD2nAmiLKLo2beay8Qp00BrVy1w/XI1HZ1BvwyIGjx9tT3RlugsMaKH2Tl29rjlnsXiJVQ++BDyV8qHZkqyXRt3N3+3BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDJ6/SFO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8673C4CEF1;
	Mon, 27 Oct 2025 22:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761605874;
	bh=RKqoVbgI2Ca7FhAx6Dox7tUiovpBfjFmJnQ0ouZqbf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gDJ6/SFObwozsNrQ6RmtzoG1PbqVMbMarNQMgNC3w3n9mYxj3dyPS0l7gyo758ab0
	 XPdzii5ZEFJNwYex5O4530LK2PNqvyt/hpFM25Bke/XwAC3zCqPaD1grXHgZltQzR+
	 2gFZEaHlQeX0l+P8xM7ZG0HIcNuR0z1BoDwJDOa57f1/yV1LWMb0EFt9j5jXEob3Xo
	 EKdmUpMmiKppp4HNhLRW19WFXlLUP+r+G1R4aZkk/XP2g/Msg/18NR91AFQwyYtAcb
	 U/mwMKb1oOc0z2RvJuHKQIy4SpUH6jkCWkKjhMXvSHDCPkEu9PJ2AjacHliW+4dezn
	 go1UTn5roVWsw==
Date: Mon, 27 Oct 2025 16:57:52 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+10a9b495f54a17b607a6@syzkaller.appspotmail.com>,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_uring_del_tctx_node
 (5)
Message-ID: <aP_48DOFFdm4kB7Q@kbusch-mbp>
References: <68ffdf18.050a0220.3344a1.039e.GAE@google.com>
 <d0cd8a65-b565-4275-b87d-51d10e88069f@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0cd8a65-b565-4275-b87d-51d10e88069f@kernel.dk>

On Mon, Oct 27, 2025 at 04:04:05PM -0600, Jens Axboe wrote:
> 
> commit 1cba30bf9fdd6c982708f3587f609a30c370d889
> Author: Keith Busch <kbusch@kernel.org>
> Date:   Thu Oct 16 11:09:38 2025 -0700
> 
>     io_uring: add support for IORING_SETUP_SQE_MIXED
> 
> leaves fdinfo open up to being broken. Before, we had:
> 
> sq_entries = min(sq_tail - sq_head, ctx->sq_entries);
> 
> as a cap for the loop, now you just have:
> 
> while (sq_head < sq_tail) {
> 
> which seems like a bad idea. It's also missing an sq_head increment if
> we hit this condition:

This would have to mean the application did an invalid head ring-wrap,
right? Regardless, I messed up and the wrong thing will happen here in
that case as well as the one you mentioned.


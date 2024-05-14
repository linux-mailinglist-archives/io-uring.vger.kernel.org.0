Return-Path: <io-uring+bounces-1893-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 395938C4A5D
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 02:13:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE726B22F0D
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 00:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A44F8365;
	Tue, 14 May 2024 00:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UMXZf16K"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C786191;
	Tue, 14 May 2024 00:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715645628; cv=none; b=OigBx5E8040YvtZaanvpCBNzt2ZfgDN4mmNLmXshVW8ihdu5gRPgJ0KerG1YGX/KwvB8/C+zfY6/s9epYMLGcFObiaZXdMP8VEbyYeatMcKeMk/hHPOid1W7Wo+S/+R5ZjBjuVdLTwOg/r3LIuUB26ZNPTorGd1iCK/atERNMyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715645628; c=relaxed/simple;
	bh=SuP+peOhTTYtRti5yXBt8HeCLjmMXBePgLHnggDT25c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y3BFqxSf9xeB27vVzvmza4AjoKKGV5nyMbFZe399DhLEcs2zDtFLg04qMIkuHW7xNgpIZNAhzWLRpRgUbxZ0KEeA7H7SJ+yvGWMGS0friuMUnKnmjNgjoY2KCZhJAkxq8lBRiekRB7PS81KX4JdU20nDwhot0I1+96B3GEEGlao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UMXZf16K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BD0C113CC;
	Tue, 14 May 2024 00:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715645628;
	bh=SuP+peOhTTYtRti5yXBt8HeCLjmMXBePgLHnggDT25c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UMXZf16KYSsuibX1expZr5p+rJBV7rDj8qT3/MADGItEaBMItE27fU4jwxQ0+4CsN
	 FZhrmN3RUM410+3V9siEQMED+HxHHs4VptcRfi59iJiy6dZnHX3reUwIlXomIeaPET
	 eZpqziasOygryLPD+yAQM/hCaO0s8wGqZZScApQ96Q9M+VSJJbFZY1ZALUwcIh7/z0
	 MgXC9B7MNmAJEh/Eu4nR0hp7DyHTEHNxBeNM1ey2qlPyNwHuv8aijfGS+gx3y5h4iX
	 LOEPDk7YKnJdFOXhkCybQ6cIoq4WgpIBEmKUqyA1xChkZ2EqNkbJ9PQ38TT4OhxNvT
	 L9btaFmWYAqRA==
Date: Mon, 13 May 2024 17:13:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCHSET RFC 0/4] Propagate back queue status on accept
Message-ID: <20240513171347.711741c7@kernel.org>
In-Reply-To: <20240509180627.204155-1-axboe@kernel.dk>
References: <20240509180627.204155-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  9 May 2024 12:00:25 -0600 Jens Axboe wrote:
> With io_uring, one thing we can do is tell userspace whether or not
> there's more data left in a socket after a receive is done. This is
> useful for applications to now, and it also helps make multishot receive
> requests more efficient by eliminating that last failed retry when the
> socket has no more data left. This is propagated by setting the
> IORING_CQE_F_SOCK_NONEMPTY flag, and is driven by setting
> msghdr->msg_get_inq and having the protocol fill out msghdr->msg_inq in
> that case.
> 
> For accept, there's a similar issue in that we'd like to know if there
> are more connections to accept after the current one has been accepted.
> Both because we can tell userspace about it, but also to drive multishot
> accept retries more efficiently, similar to recv/recvmsg.
> 
> This series starts by changing the proto/proto_ops accept prototypes
> to eliminate flags/errp/kern and replace it with a structure that
> encompasses all of them.

Acked-by: Jakub Kicinski <kuba@kernel.org>

Feel free to submit for 6.10, or LMK if you want me to send the first
3 to Linus.


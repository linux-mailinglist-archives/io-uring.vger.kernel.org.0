Return-Path: <io-uring+bounces-3308-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB3949865C9
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 19:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 614581F2221C
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 17:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4E882499;
	Wed, 25 Sep 2024 17:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="FF8LChJJ"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BA46088F;
	Wed, 25 Sep 2024 17:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727286001; cv=none; b=bdB0ZHoY8Zy9edkHTk96xIt3pzrRRbWO/dfmM1cCUgQy64INliyGv8CIbIQ8tiHvwveeg+hanp9WfgUtsZ7UNNsjl3S7ANLV5JAodqJSmce+xR2VhFfdMrVYPYUJLpDZ0iFxjPOkYaMzxhfUlkirqRigZX9UwlhnsUELAlyhFXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727286001; c=relaxed/simple;
	bh=B1WQjEIQGrOJ/PLZ5OjcdLv/UifhHY5PZQRRrDOqCig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fcpilB1ZcadPZEUAYoc6NJxuiVwWiqEnjpHjxyd9pivRuXtUFErQyGt1L+CrmINCGwgJtphfFLT0BG/l0nEKvNLVBoANhRP0BwFbsuoF4mx0gwEG3G0dCdl5e9Zhy2RDpoGx2Yub9zMTl4eVhP8ZAuBxkCde4vXn7ucnRRUKkTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=FF8LChJJ; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DTJvr3atCjaZIV/PegZmismfgT2uDexg0lHnt+dea4o=; b=FF8LChJJu5OLl/UMxGoEtv087u
	dztdix0Ia6Ukw7lh6wLGodKI3E7lihY8B3e1/Kw1ii/9B13p95QAyVPbfmESIV7pKaKJXdfy59sSG
	blfsK2HyBb7QTw+d9CVA+I3bng6xd4SQnPkDnYT6kHZTfxLix5vklXyC4x+serISPoQGRc3vOn7qp
	qkLQNPnGgRI8SIEq8HajPyxpbQzCl0kFisd6PSQCrh/ol6upi6UCmCjD7oXKV+cOrdhb5veyiGEu3
	qUlcczbK8J0FrWvErrk4/x9Kl2qYpe2UiAaeXE0eJXtUXXxYVtLZjEveGGmEC85NrJtsv6jHiOQJB
	fqyJ7UKw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1stVzY-0000000FTxA-2qpN;
	Wed, 25 Sep 2024 17:39:56 +0000
Date: Wed, 25 Sep 2024 18:39:56 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC] struct filename, io_uring and audit troubles
Message-ID: <20240925173956.GI3550746@ZenIV>
References: <20240922004901.GA3413968@ZenIV>
 <20240923015044.GE3413968@ZenIV>
 <62104de8-6e9a-4566-bf85-f4c8d55bdb36@kernel.dk>
 <CAHC9VhQMGsL1tZrAbpwTHCriwZE2bzxAd+-7MSO+bPZe=N6+aA@mail.gmail.com>
 <20240923144841.GA3550746@ZenIV>
 <CAHC9VhSuDVW2Dmb6bA3CK6k77cPEv2vMqv3w4FfGvtcRDmgL3A@mail.gmail.com>
 <20240923203659.GD3550746@ZenIV>
 <20240924214046.GG3550746@ZenIV>
 <d3d2c19d-d6a3-4876-87f0-d5709ee1e4b2@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3d2c19d-d6a3-4876-87f0-d5709ee1e4b2@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Sep 25, 2024 at 12:01:01AM -0600, Jens Axboe wrote:

> The normal policy is that anything that is read-only should remain
> stable after ->prep() has been called, so that ->issue() can use it.
> That means the application can keep it on-stack as long as it's valid
> until io_uring_submit() returns. For structs/buffers that are copied to
> after IO, those the application obviously need to keep around until they
> see a completion for that request.  So yes, for the xattr cases where the
> struct is copied to at completion time, those do not need to be stable
> after ->prep(), could be handled purely on the ->issue() side.

Hmm...  Nothing in xattr is copied in both directions, actually.

AFAICS, the only copy-in you leave to ->issue() is the data for write
and sendmsg and ->msg_control for sendmsg.  Wait, there's that ioctl-like
mess you've got, so anything that feels like doing (seems to include
at least setsockopt)...  Oh, well...


Return-Path: <io-uring+bounces-7017-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FC65A56E21
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:44:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7808A16E149
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA3C23ED77;
	Fri,  7 Mar 2025 16:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="GlLMGCB0"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930C923F273;
	Fri,  7 Mar 2025 16:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365741; cv=none; b=NuykMf5B7WU0PUpJSryUXTw23gAwsIL040LleBdS5omoLB8YwysVwLVBI1mqvzSRjoI3JiK9CoRpG/6nGnQVCdvWX7c7Wstry1BohWs4huhBYLX0QLAENro0RjhfdBazSA7RDwj3SXQyi1UqzvN2CEYdyi0tmifcA6C0tKm/rG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365741; c=relaxed/simple;
	bh=UycmM5AsU5bGLdya72jZ8Wg0jbrSi+KsR4bU3ioKj5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PFEJTug9QLdr5q32DQDsb9p911l7juF/r10fDMZd+G9//R20epIT1zMIOkcE3kYggEbJRIi3Xl1NYO4NXHHy8HXDiJ1rtSbGb6xXF9o4rZIQkZg/XMM3m8kJ9bbR9KTVBq6uEeGgJi/qSp7sIEIkTUT4ddieJT2OuuMmV6boj8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=GlLMGCB0; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Pq1RR3focNbO73aOn8Bc610gmKDMWcPGHT9zN39vHko=; b=GlLMGCB02bPVoMuL44TuLmqmgn
	CIUTMJa6zqXvrvNV+YfJCsmx/oM0anIzoxg87d93njxX8/d5JxyV8noTvTBpGLqepvAdz9D9zQP5e
	HSKlnc40crfVLlyYVg3W7TkJr2thg2x6TULxod8ivR9py6V/+hSHRqPj6ebtEnMUabMAtbF8EhG/w
	bRzIcDg1mrj2Otg0cFJlMEBb8oC2nYsrDsWwAbuTuTYtX1GB1YLMMe2bMhqAh0y1WfLdwufsxhMjs
	+434dvalVyNae6Mt3YzqwBmDS3/zY68BUi49dUxJzdijrvFsnnRxnotRR0dL6qEJPexw+op4IV2ug
	aMlemSpA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tqam8-00000005hxV-322l;
	Fri, 07 Mar 2025 16:42:16 +0000
Date: Fri, 7 Mar 2025 16:42:16 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, jack@suse.cz, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	audit@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] fs: support filename refcount without atomics
Message-ID: <20250307164216.GI2023217@ZenIV>
References: <20250307161155.760949-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307161155.760949-1-mjguzik@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Fri, Mar 07, 2025 at 05:11:55PM +0100, Mateusz Guzik wrote:
> Atomics are only needed for a combination of io_uring and audit.
> 
> Regular file access (even with audit) gets around fine without them.
> 
> With this patch 'struct filename' starts with being refcounted using
> regular ops.
> 
> In order to avoid API explosion in the getname*() family, a dedicated
> routine is added to switch the obj to use atomics.
> 
> This leaves the room for merely issuing getname(), not issuing the
> switch and still trying to manipulate the refcount from another thread.
> 
> Catching such cases is facilitated by CONFIG_DEBUG_VFS-dependent
> tracking of who created the given filename object and having refname()
> and putname() detect if another thread is trying to modify them.

Not a good way to handle that, IMO.

Atomics do hurt there, but they are only plastering over the real
problem - names formed in one thread, inserted into audit context
there and operation involving them happening in a different thread.

Refcounting avoids an instant memory corruption, but the real PITA
is in audit users of that stuff.

IMO we should *NOT* grab an audit names slot at getname() time -
that ought to be done explicitly at later points.

The obstacle is that currently there still are several retry loop
with getname() done in it; I've most of that dealt with, need to
finish that series.

And yes, refcount becomes non-atomic as the result.


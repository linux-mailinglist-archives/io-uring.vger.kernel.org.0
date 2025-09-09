Return-Path: <io-uring+bounces-9674-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08779B500C6
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 17:14:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED741179102
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 15:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D3934F483;
	Tue,  9 Sep 2025 15:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a6LQysXA"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABBB34F47E;
	Tue,  9 Sep 2025 15:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757430861; cv=none; b=jxbfgHviK+Rm2mGkdueqLI9GiaD5ETDrAIWyGc8iVsMZEOYG+T4PqBoXpOOu6FmxkbRlVIA/Q+FXSyH7Zq1qakR7+ZegidKEz+8VKfhFvFk8glt5efGya6bhxFOxRCUaf24FMTRwzIskckLEfP2Do5+oh3VnznzWQCZYDN8pO/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757430861; c=relaxed/simple;
	bh=q0CAo9AaS+g1TeiWkOjsPGE8x7Tgir3wLwXBVLvxzbI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:From:Subject:
	 References:In-Reply-To; b=teNiZ1jgWnQxlPZCpoLGqSIKeZIihuKE5uwf6z5Q6/va12xf3Ecm06yJ56qoyG6IZ7CRVnFE/7pDQcWRGQgf19TO74tbtgUYYGY7CwhuZ/ntnvAO9dAnKgbcrVjv+dOErM3wLOUlNHzl5jLjIf0Qg0UXxMaQSHPJJhHyyjghNCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a6LQysXA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4012FC4CEF4;
	Tue,  9 Sep 2025 15:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757430861;
	bh=q0CAo9AaS+g1TeiWkOjsPGE8x7Tgir3wLwXBVLvxzbI=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To:From;
	b=a6LQysXATxV4KFZUPFzOzrvrsS+4F4pnFGoizKfvqhRe7XrsLsibYhFc+CynFUN0R
	 74xndH+WNb0A3NTvHRXH5P/umsPuGipW05Bn6+QpU866QdvdTcmaseOuwtjwGcDSjy
	 j/xc7wcEBG8wOgxlSuMkmxMn/SyCPXFhOHLL8Q0BVatFT1aCVAw5E8m/OlkUvPX1tZ
	 2vArph/RbOYnwpbt4J6RD3tnTH7kEbzOBSM3IP6WHg91s5fCAnShdrz4dZn9pvIJVJ
	 kbdxzgnnTm5cGLJxS9NN4fQmOjDPNzW+07t9ThRGibX3GF52T3DRUgFd8s5MKg3Kc6
	 j0R504QwwA6Lg==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 09 Sep 2025 17:14:17 +0200
Message-Id: <DCOD8UB9RTHW.29Q8UXKPRDIGN@kernel.org>
Cc: "Jakub Kicinski" <kuba@kernel.org>, "Konstantin Ryabitsev"
 <konstantin@linuxfoundation.org>, "Linus Torvalds"
 <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 <dan.j.williams@intel.com>, "Caleb Sander Mateos"
 <csander@purestorage.com>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "io-uring" <io-uring@vger.kernel.org>,
 <workflows@vger.kernel.org>
To: "Jens Axboe" <axboe@kernel.dk>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
 <5922560.DvuYhMxLoT@rafael.j.wysocki> <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>
In-Reply-To: <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>

On Tue Sep 9, 2025 at 4:35 PM CEST, Jens Axboe wrote:
> As far as I can tell, only two things have been established here:
>
> 1) Linus hates the Link tags, except if they have extra information
> 2) Lots of other folks find them useful
>
> and hence we're at a solid deadlock here.

I find them useful too. For instance, I regularly use them when I come acro=
ss a
patch, e.g.  because it introduced a bug, and want to see the full context =
of
the entire patch series the patch originates from.

IIUC, the complaint about those links is mostly about not being distinguish=
able
from other links that have been added for a more specific reason.

I usually refer to additional links from the commit message by referencing =
them,
such that there is an obvious difference:

	Link: ${URL}

vs.

	Link: ${URL} [1]

However, for links that are automatically added and just point to the same =
patch
on lore, we could also just use a different tag in the future.

What about "Patch:"?


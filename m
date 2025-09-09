Return-Path: <io-uring+bounces-9691-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 665FFB5056B
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 20:35:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE1497ADD1A
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 18:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 635AB369331;
	Tue,  9 Sep 2025 18:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7S5fUZL"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272CA369325;
	Tue,  9 Sep 2025 18:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757442676; cv=none; b=EoYmIKY9EmpztzZw6NdB+LZrkStB2rdtPDM3EFRCHolpdYIxe3IvMVi5ZCwlh3fByczCAgEPjJPi5UWo2nHBXwf6xozb9bnoVBSejxyStU41dehcmRlS+FecMFfbNBD+dhnNnFD5bb03lCqqq49luaBMKDDfn81kWsKciZcABR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757442676; c=relaxed/simple;
	bh=U+8cGGxdMKAK3+g3uYEoGNshqNn7XrOcxEGGs2HE1cw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V9+hKQyYDGjXqBMt0eP8/M+4+YxCMDGsMfhSohUvg2tER9tOag2JQmp471RcuapuY6cNyfez1+7vo22YXTKZcIKVjNT54kAWbqP3cL8G422aanb/OiHP83kbaWX/iWKUVCgu8liTjqHgbGBhZHC8Mxf+x+QJL/9FTSh4hKWCS9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7S5fUZL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED57C4CEF4;
	Tue,  9 Sep 2025 18:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757442675;
	bh=U+8cGGxdMKAK3+g3uYEoGNshqNn7XrOcxEGGs2HE1cw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m7S5fUZLM0FsgbT3hmz7xiWKG6R4+wzDFYKJB6mafLSRvSz0EGfGU+N0cFtBICuOG
	 6Xxq48GEIoCLKl1j5+yzHKrviCK746OmAd4Kxl8AG2EBtSpckupuGpLMyl/0YhiINt
	 v3i2C4uFBtsVACspNeuIpFb0tXlJEzZUPVFba+A4=
Date: Tue, 9 Sep 2025 14:31:14 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Vlastimil Babka <vbabka@suse.cz>, Jakub Kicinski <kuba@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, dan.j.williams@intel.com, 
	Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <20250909-impetuous-swine-of-chaos-2aa9af@meerkat>
References: <5922560.DvuYhMxLoT@rafael.j.wysocki>
 <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>
 <20250909-green-oriole-of-speed-85cd6d@lemur>
 <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz>
 <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
 <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
 <af29e72b-ade6-4549-b264-af31a3128cf1@sirena.org.uk>
 <CAHk-=wiN+8EUoik4UeAJ-HPSU7hczQP+8+_uP3vtAy_=YfJ9PQ@mail.gmail.com>
 <CAHk-=wh2F5EPJWhiEeW=Ft0rx9HFcZj2cWnNGh_OuR0kdBm8UA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wh2F5EPJWhiEeW=Ft0rx9HFcZj2cWnNGh_OuR0kdBm8UA@mail.gmail.com>

On Tue, Sep 09, 2025 at 10:58:53AM -0700, Linus Torvalds wrote:
> On Tue, 9 Sept 2025 at 10:50, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >    patchid=$(git diff-tree -p fef7ded169ed7e133612f90a032dc2af1ce19bef
> > | git patch-id | cut -d' ' -f1)
> 
> Oh, and looking more at that, use Dan's version instead.  You almost
> certainly want to use '--stable' like Dan did, although maybe
> Konstantin can speak up on what option lore actually uses for
> indexing.

It uses --stable.

> And you *can* screw up patchid matching. In particular, you can
> generate patches different ways, and patch-id won't generate the same
> thing for a rename patch and a add/delete patch, for example (again:
> the traditional use case is that you generate the patch IDs all from
> the same tree, so you control how you generate the patches)

We can't control how the patches are generated by submitters. If someone
generates and sends them with --histogram, this won't work. Here's an example
right from your tree:

    $ git show 1c67f9c54cdc70627e3f6472b89cd3d895df974c | git patch-id --stable | cut -d' ' -f1
    57cb8d951fd1006d885f6bc7083283d3bc6040c1

    $ git show --histogram 1c67f9c54cdc70627e3f6472b89cd3d895df974c | git patch-id --stable | cut -d' ' -f1
    47b4bfff33d1456d0a2bb30f8bd74e1cfe9eb31e

Or if someone generates with -U5 instead of the default (-U3):

    $ git show 1c67f9c54cdc70627e3f6472b89cd3d895df974c -U5 | git patch-id --stable | cut -d' ' -f1
    0b68dd472dc791447c3091f7a671e7f1e5d7a3d2

This is more than just annoying -- this can be misleading and confusing. If
the submitter sent v1, v2, v3 with the default parameters and then sent v4
with --histogram, then you may think v3 was the final version that got applied
and it will waste a lot of your time trying to figure out why it doesn't match
what's in the tree.

I don't have precise statistics, but I do have firsthand experience trying to
make this work with git-patch-id, because this is how git-patchwork-bot works,
and we can't match a significant portion of commits to patches.

-K


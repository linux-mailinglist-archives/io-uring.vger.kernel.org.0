Return-Path: <io-uring+bounces-6362-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EC07A32966
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 16:01:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A57318866AB
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 14:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97C48210190;
	Wed, 12 Feb 2025 14:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fln25A67"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5AE20E315;
	Wed, 12 Feb 2025 14:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739372388; cv=none; b=svRZZnqzpDpp1rXpCFpjdCV9hJVlSc/4Uw8yWZVcy6StxFk/76Bx8mWngTGlzwKAqxDFELZkLfH/bf2+b2Qbs1eHmstJPs6Ntjijo/dn0moaTB81G3y3oKLkCHo4mfFFusNkCVyWRN3jHrwxpTCZCiKFLpCRMmjJ5eH+g21xsVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739372388; c=relaxed/simple;
	bh=yUBfouDmMP3GLpYRGL5S8ufUfx5vX9c/zpv9yoMFvxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U6ig1xH/FYNkPjYqxjEseHdlGOAhRtxIE1yJcmYFDhhmuReHG/+XMFsjzGQpnTpJB1PbbSIVMN2zUre4SdRiQf+t2bDSjc28aklU1rq2zEEK1hkxb9szs1ZE8y3YesJFjW/OvWz1vRdvHmxeLbhLXRkLNT2o0xKazJ3s9OLVcag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fln25A67; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E47AC4CEDF;
	Wed, 12 Feb 2025 14:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739372387;
	bh=yUBfouDmMP3GLpYRGL5S8ufUfx5vX9c/zpv9yoMFvxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fln25A67D3152wWZJ6k/QqEHbzXgrMvMnVOvGhT6DQVcZ8+XTZlrljbT5yzvUMwpb
	 uochPYmySi/2E85jarClL8xirbmBBfI387b2rI/kY6Vyz6eldUpg+aS48xt9IJIY1X
	 nkL7e3eRGm8l9vaYl8Fb2svO8fodvtwr0W9Qb4lZKzoIekE6Ta4GKMwgrS2or4Hl47
	 1hhdzx78f3fpEfjqyRujNpJXs2qwXTHGw0IKzkqNf1vH4cJ5wcP0/tWbvrsDpr5VUG
	 73nY18urw0C+o8eIsV9qO1CLhRSbc6k23pXHAkK44ca91r1sQvXMml0kSAr2xr4/i7
	 RYX6pmNaYjEuQ==
Date: Wed, 12 Feb 2025 07:59:44 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com
Subject: Re: [PATCHv2 4/6] ublk: zc register/unregister bvec
Message-ID: <Z6y3YNX4-Ln2tjyX@kbusch-mbp>
References: <20250211005646.222452-1-kbusch@meta.com>
 <20250211005646.222452-5-kbusch@meta.com>
 <Z6wMK5WxvS_MzLh3@fedora>
 <Z6wfXijUX_6Q3HiC@kbusch-mbp>
 <Z6xo0mhJDRa0eaxv@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6xo0mhJDRa0eaxv@fedora>

On Wed, Feb 12, 2025 at 05:24:34PM +0800, Ming Lei wrote:
> On Tue, Feb 11, 2025 at 09:11:10PM -0700, Keith Busch wrote:
> 
> However, it still may cause use-after-free on this request which has
> been failed from io_uring_try_cancel_uring_cmd(), and please see the
> following code path:
> 
> io_uring_try_cancel_requests
> 	io_uring_try_cancel_uring_cmd
> 		ublk_uring_cmd_cancel_fn
> 			ublk_abort_requests
> 				ublk_abort_queue
> 					__ublk_fail_req
> 						ublk_put_req_ref
> 
> The above race needs to be covered.

This race is covered. The ublk request has one reference taken when it
notifies userspace, then a second reference taken when user registers
the bvec.

The first reference is dropped from the abort, but the request won't be
completed because the second reference prevents that. That second
request reference can't be dropped until the ->release callback happens,
and that can't happen until two conditions are met:

  The bvec is unregistered
  All IO using the index completes

I think all the bases are covered here.


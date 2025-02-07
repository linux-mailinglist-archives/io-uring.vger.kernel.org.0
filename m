Return-Path: <io-uring+bounces-6315-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C512A2D008
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 22:53:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 510223A9557
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 21:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC961B4159;
	Fri,  7 Feb 2025 21:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="BRYwDEQI"
X-Original-To: io-uring@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABFB518FC7B;
	Fri,  7 Feb 2025 21:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738965217; cv=none; b=ofkN3RbCoYUyhjt5ehdkkbIQcesZlDkAH/iu4t1aQbdszV8gvgZSv8PYVVr6Pzrs94F/sZhMzuLoHrBXfxP0V01KOz1tCR88uYtDWc5Q2vy/hbnHpnJjTM4Eat9icZ7w/Miq2RHs6p9PqOkk8Slyb2RkPfVdiRDDHi5roubTDPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738965217; c=relaxed/simple;
	bh=x4Z6WRtu5lkf0X2Z+obuDWDRP253TsBa4Ew3V/418fI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G6TrQxDaFj8DErSJVvORecZPiGSJvtGGPxbaAspbU3EMLMoudu7UlqKdlNDeRknzOEoOIjpx9DzJSYvuySVUJzBJw9nghgfLxSomID9gvOrrsibf2ONVslJI4DTlkf0ZE7girKbPhpH+unwtjvCv9RLAdEgRwdAbO0KhqDds5sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=BRYwDEQI; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from hm-sls2 (unknown [142.114.216.132])
	by linux.microsoft.com (Postfix) with ESMTPSA id 3D7FB2107308;
	Fri,  7 Feb 2025 13:53:33 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3D7FB2107308
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738965214;
	bh=EWelTE8BT8WAHtbmQhEVDbdCq7fJfmLfrnbaZGFFKek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BRYwDEQITWAB1GpXwrZu3QTnzFr0/lLsXDKJb9fa3QjbPyHGHBEaknwt5Wktgdnyp
	 TpDffaxfN5hW7EZ5BcbH5OkTGWZvmUFgpRUEWU23pcUeuEXcPVaERhDTz93kz89/kz
	 15JPCWxZpP/c4cEIOdWDLnPGIcYkjfdZAeyFxHHQ=
Date: Fri, 7 Feb 2025 16:53:21 -0500
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Bram =?utf-8?B?Qm9ubsOp?= <brambonne@google.com>,
	=?utf-8?B?VGhpw6liYXVk?= Weksteen <tweek@google.com>,
	Christian =?utf-8?B?R8O2dHRzY2hl?= <cgzones@googlemail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
	selinux@vger.kernel.org
Subject: Re: [PATCH v3 2/2] lsm,io_uring: add LSM hooks for io_uring_setup()
Message-ID: <Z6aA0cWte6rZQSbo@hm-sls2>
References: <20250127155723.67711-2-hamzamahfooz@linux.microsoft.com>
 <a4541fab007858c599aed1d1e3e98883@paul-moore.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4541fab007858c599aed1d1e3e98883@paul-moore.com>

On Fri, Feb 07, 2025 at 04:42:57PM -0500, Paul Moore wrote:
> On Jan 27, 2025 Hamza Mahfooz <hamzamahfooz@linux.microsoft.com> wrote:
> > 
> > It is desirable to allow LSM to configure accessibility to io_uring
> > because it is a coarse yet very simple way to restrict access to it. So,
> > add an LSM for io_uring_allowed() to guard access to io_uring.
> > 
> > Cc: Paul Moore <paul@paul-moore.com>
> > Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> > ---
> >  include/linux/lsm_hook_defs.h       |  1 +
> >  include/linux/security.h            |  5 +++++
> >  io_uring/io_uring.c                 |  2 +-
> >  security/security.c                 | 12 ++++++++++++
> >  security/selinux/hooks.c            | 14 ++++++++++++++
> >  security/selinux/include/classmap.h |  2 +-
> >  6 files changed, 34 insertions(+), 2 deletions(-)
> 
> Thanks Hamza, this looks good to me, but we need to wait until we get an
> ACK from Jens on path 1/2; he's pretty responsive so I don't think we'll
> have to wait too long.
> 
> As far as the return/label issue in patch 1/2, as long as there are no
> other issues, and you are okay with the change, I can fix that up when
> merging your patches.

Ya, that sounds good to me, thanks!

> 
> --
> paul-moore.com


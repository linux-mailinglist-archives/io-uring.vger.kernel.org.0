Return-Path: <io-uring+bounces-6754-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F021BA4464B
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 17:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5C68168D95
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 16:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D82641624D4;
	Tue, 25 Feb 2025 16:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hUslR0U9"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF81414A60A;
	Tue, 25 Feb 2025 16:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740501332; cv=none; b=ovyJMoyg4LxYqOdWP67KPU00E9B/iIkZICWO4tdylJF9FRYPruk1b9HgwI3C23K9lc+f6131eCQRDz2M4N/g2CNBwsa5cYzujJlP1L2glGEt8PkB46yymxYEA5vID+AMK5eR9GbS4xqBK6/hNVbKzo+i8fLuBQVxFuIZU5DuZSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740501332; c=relaxed/simple;
	bh=Ykn0C4HLFEsQK4qrX/0l8sje7kziHCbfxpSSCii//EU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MMZTUkTekUdsFlkpl+tk7xrdL4IpNcPHID7xUxEyjbrLdeWt0pMg4xnCQDMlBhcWcbEEpd5fChrQQ2GCL0W01NMNf213ugqoRep/i9TunDo4XZa1HwrG5TPHSyU3elHHOlbQcHbF0NE82CeAUTgFdsFoyQKiYQwbyP1qaTc6Oac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hUslR0U9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9874C4CEE6;
	Tue, 25 Feb 2025 16:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740501332;
	bh=Ykn0C4HLFEsQK4qrX/0l8sje7kziHCbfxpSSCii//EU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hUslR0U9ai+X6gm+GJ/cS7VXQTeV3aAElXNexNV3a91PkV7Sl55ZXNZmldY8Tf0Ar
	 C/H+N8eEe5fmr6swT2BFA8N302TMp7Ccvt8xMKkA4ISAm/G0jAChau5tl63V0n3bIm
	 z301KeA9GY5HZCDl4BauKgP4asbgx4vq+O6LOWGMDH8rnjK7s8lOiUn+uv1scwusKE
	 dW1rybdxAhLCp3/Mee/P9AnNwXWSWorCqXOBpKhxMTsgpPuVlDzpmSCopvVP0YKT6G
	 DOIxNBw8nlJ0XgYj2Jx56EEd1qX8/DsdP6+IsvRBVVP+6CLK7URIFSV2SS9Z22Ha9l
	 hnsKTNUqLyJ+g==
Date: Tue, 25 Feb 2025 09:35:30 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com, csander@purestorage.com
Subject: Re: [PATCHv5 09/11] ublk: zc register/unregister bvec
Message-ID: <Z73xUhaRezPMy_Dz@kbusch-mbp>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-10-kbusch@meta.com>
 <Z72itckfQq5p6xC2@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z72itckfQq5p6xC2@fedora>

On Tue, Feb 25, 2025 at 07:00:05PM +0800, Ming Lei wrote:
> On Mon, Feb 24, 2025 at 01:31:14PM -0800, Keith Busch wrote:
> >  static inline bool ublk_dev_is_user_copy(const struct ublk_device *ub)
> >  {
> > -	return ub->dev_info.flags & UBLK_F_USER_COPY;
> > +	return ub->dev_info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY);
> >  }
> 
> I'd suggest to set UBLK_F_USER_COPY explicitly either from userspace or
> kernel side.
> 
> One reason is that UBLK_F_UNPRIVILEGED_DEV mode can't work for both.

In my reference implementation using ublksrv, I had the userspace
explicitly setting F_USER_COPY automatically if zero copy was requested.
Is that what you mean? Or do you need the kernel side to set both flags
if zero copy is requested too?

I actually have a newer diff for ublksrv making use of the SQE links.
I'll send that out with the next update since it looks like there will
need to be at least one more version.

Relevant part from the cover letter,
https://lore.kernel.org/io-uring/20250203154517.937623-1-kbusch@meta.com/

diff --git a/ublksrv_tgt.cpp b/ublksrv_tgt.cpp
index 8f9cf28..f3ebe14 100644
--- a/ublksrv_tgt.cpp
+++ b/ublksrv_tgt.cpp
@@ -723,7 +723,7 @@ static int cmd_dev_add(int argc, char *argv[])
 			data.tgt_type = optarg;
 			break;
 		case 'z':
-			data.flags |= UBLK_F_SUPPORT_ZERO_COPY;
+			data.flags |= UBLK_F_SUPPORT_ZERO_COPY | UBLK_F_USER_COPY;
 			break;
 		case 'q':
 			data.nr_hw_queues = strtol(optarg, NULL, 10);



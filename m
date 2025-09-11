Return-Path: <io-uring+bounces-9747-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80823B5330B
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 15:02:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E24B05A51B1
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 13:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C83320CC7;
	Thu, 11 Sep 2025 13:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="srChlePY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16AC32142B
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 13:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757595736; cv=none; b=sJCNlO6nZ/NDvyL0oBkJlznKd13tW79NJrVVOnGUbEXsSgVjuoUbpiyIdr6Qv2ni67pxhRMa1EigAAklaYGuUHMG0CLdcIv5n1Y+cYkwo5nku7mnxHz5nO9Jk2p4v9lIbw8W2Cxm9l19lARxvyFC9bJU+BwZIaOoGKKRPkUzbTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757595736; c=relaxed/simple;
	bh=1kooGra0E7aWJPPwjjd142TdftXEElYPipUhRSp10hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=utFMRDdGvwRg9lY2F1TqEOaSN0fghMbY7/zQvISZ42C/YJAA5dBSjQzZgx1zLA0i49txckxeIEX672R+TMCSyZCeO1hR1DVc7Gb9dRCK/cD1Ljxf4nrgo3oIsZ0AcFIQ11ETxKihnkxaRh3VKaFaml9HcLuDS5sqbtKq1EZlq9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=srChlePY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C19C4CEF0;
	Thu, 11 Sep 2025 13:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757595734;
	bh=1kooGra0E7aWJPPwjjd142TdftXEElYPipUhRSp10hc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=srChlePYlYGsxx6GI/gJpBVEuuyz/lpQu5liz/M/fna/8HFsDTqS9gOAVvIxV6CSN
	 q6nKUu2sV9jXl32bqoFLIUADjJq5p7melhriTmXJvXjLVzNFUV2TvIhwagv1XFV/IF
	 IvE6O6dFpWA42ihLNAVlfjFFvh5/OSrlipjtA47XdbajiqG7MT2nTesc8Ebhj4zBwm
	 58ZaCl3ToSbJMZm8ZK1nfpDH3YqfIDhEb4PXRDJywXTABQIw2k8/amONhF6VF8/fyv
	 VLLysf9PTZJqPbvGdbxLeKaA8GVfZpzY0cPXE9bK9GT/DgTClhm/qcZIs3tQJdB0uB
	 tF/WUW+d/yDFQ==
Date: Thu, 11 Sep 2025 09:02:11 -0400
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org
Subject: Re: [RFC PATCHv2 1/1] io_uring: add support for
 IORING_SETUP_SQE_MIXED
Message-ID: <aMLIU19CfgOAuo8i@kbusch-mbp>
References: <20250904192716.3064736-1-kbusch@meta.com>
 <20250904192716.3064736-3-kbusch@meta.com>
 <CADUfDZrmuJyqkBx7-8qcqKCsCJDnKTUYMk4L7aCOTJGSeMzq6g@mail.gmail.com>
 <8cb8a77e-0b11-44ba-8207-05a53dbb8b9b@kernel.dk>
 <aMIv4zFIJVj-dza5@fedora>
 <aMIxmiGv5D0GvSro@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMIxmiGv5D0GvSro@fedora>

On Thu, Sep 11, 2025 at 10:19:06AM +0800, Ming Lei wrote:
> On Thu, Sep 11, 2025 at 10:11:47AM +0800, Ming Lei wrote:
> > SQE128 is used for uring_cmd only, so it could be one uring_cmd
> > private flag. However, the implementation may be ugly and fragile.
> 
> Or in case of IORING_SETUP_SQE_MIXED, IORING_OP_URING_CMD is always interpreted
> as plain 64bit SQE, also add IORING_OP_URING_CMD128 for SQE128 only.

Maybe that's good enough, but I was looking for more flexibility to have
big SQEs for read/write too. Not that I have a strong use case for it
now, but in hindsight, that's where "io_uring_attr_pi" should have been
placed instead of outide the submission queue.


Return-Path: <io-uring+bounces-9836-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48482B871EF
	for <lists+io-uring@lfdr.de>; Thu, 18 Sep 2025 23:25:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86E23B63A2A
	for <lists+io-uring@lfdr.de>; Thu, 18 Sep 2025 21:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26AE62F90DC;
	Thu, 18 Sep 2025 21:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cSWDloZ4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F152A2F9C29
	for <io-uring@vger.kernel.org>; Thu, 18 Sep 2025 21:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758230532; cv=none; b=osMxzw1OKDgV4xDTgdXjqJik1fmb4RoeNCs1ChG1aOucedJfnfLZviq+cBBkLSILN82b5L3j9M3f1apbboUarlJ5CMTac2Im0Wy/sqSPlPuju7O6MMYM+5fWudtWlADh372kP84dBCV1TfVzHUJKnPXbefwiKm7LMcl5IKqXg0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758230532; c=relaxed/simple;
	bh=7vqRJk4iBQ/Otl+4Rvp1QtfUCsJX0AOROT7QwyxhFh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VjQNOGv4Cmr1Rjd5CLhMZOsPE6tTy3nhS7xSll72qYXg6jhjpbilJiVmSmeqQVLuYto8DuhOd1tVT/QUDKz3AWdg2ULEMd9kuppP9PWRx9XBtUi1uL1kDjcGp30jtnICOZSrh/El+QDHXujqDeeQ+uD2c/NRaLfY9F9fceJ/S64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cSWDloZ4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB5BC4CEE7;
	Thu, 18 Sep 2025 21:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758230531;
	bh=7vqRJk4iBQ/Otl+4Rvp1QtfUCsJX0AOROT7QwyxhFh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cSWDloZ4itL9OJ5JZi4fYr7RU7BfCyc+VkzTsaR6zDjeuNR3bHW9jDQg+rChdtybR
	 /ktQ6grFWymWKTXje2FDo2TF9cK4/hDiCyRQi7xFftdLi1MQ/THdhjFHmbY8louA6B
	 SJNfyoD6VUiARV+zpo9bA5FlKBJfh115zVRwCtNC5aDGWTO/ZSzuy20+a7hOvgPa6a
	 ZVPZVVtYwDsIzXYFVukPav5t4NJRNnpW8cDW0FlLyBt3YUB7/2sqYgUtVhedhhFJIX
	 QX6SZtR9++l2jyh2Dz5m47kmOj3NUzkQ4wAgEnjYOJ6jtKsn3t4OYPPk7gERDvBSSe
	 ScTy0n4iwd8BQ==
Date: Thu, 18 Sep 2025 15:22:09 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org
Subject: Re: [RFC PATCHv2 1/1] io_uring: add support for
 IORING_SETUP_SQE_MIXED
Message-ID: <aMx4AeMtiyUoC8-X@kbusch-mbp>
References: <20250904192716.3064736-1-kbusch@meta.com>
 <20250904192716.3064736-3-kbusch@meta.com>
 <CADUfDZrmuJyqkBx7-8qcqKCsCJDnKTUYMk4L7aCOTJGSeMzq6g@mail.gmail.com>
 <8cb8a77e-0b11-44ba-8207-05a53dbb8b9b@kernel.dk>
 <aMIv4zFIJVj-dza5@fedora>
 <aMIxmiGv5D0GvSro@fedora>
 <aMLIU19CfgOAuo8i@kbusch-mbp>
 <CAFj5m9Kbg_S_rES1BXRXpaGGnatiEmwEsN+-f4t6zGUH79LPCg@mail.gmail.com>
 <c68af2c8-4b2f-4676-8e0a-d3593e462986@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c68af2c8-4b2f-4676-8e0a-d3593e462986@kernel.dk>

On Wed, Sep 17, 2025 at 08:44:13AM -0600, Jens Axboe wrote:
> On 9/11/25 7:07 AM, Ming Lei wrote:
> > On Thu, Sep 11, 2025 at 9:02?PM Keith Busch <kbusch@kernel.org> wrote:
> >>
> >> On Thu, Sep 11, 2025 at 10:19:06AM +0800, Ming Lei wrote:
> >>> On Thu, Sep 11, 2025 at 10:11:47AM +0800, Ming Lei wrote:
> >>>> SQE128 is used for uring_cmd only, so it could be one uring_cmd
> >>>> private flag. However, the implementation may be ugly and fragile.
> >>>
> >>> Or in case of IORING_SETUP_SQE_MIXED, IORING_OP_URING_CMD is always interpreted
> >>> as plain 64bit SQE, also add IORING_OP_URING_CMD128 for SQE128 only.
> >>
> >> Maybe that's good enough, but I was looking for more flexibility to have
> >> big SQEs for read/write too. Not that I have a strong use case for it
> >> now, but in hindsight, that's where "io_uring_attr_pi" should have been
> >> placed instead of outide the submission queue.
> > 
> > Then you can add READ128/WRITE128...
> 
> Yeah, I do think this is the best approach - make it implied by the
> opcode. Doesn't mean we have to bifurcate the whole opcode space,
> as generally not a lot of opcodes will want/need an 128b SQE.
> 
> And it also nicely solves the issue of needing to solve the flags space
> issue.
> 
> So maybe spin a v3 with that approach?

Yep, almost got it ready. I had to introduce NOP128 because that's a
very convenient op for testing. I hope that's okay.


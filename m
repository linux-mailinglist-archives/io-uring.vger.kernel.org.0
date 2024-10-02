Return-Path: <io-uring+bounces-3374-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FCE098DE10
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 16:57:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDBFC280E36
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 14:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35E21974F4;
	Wed,  2 Oct 2024 14:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLdUxDo6"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D0C10E9;
	Wed,  2 Oct 2024 14:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880975; cv=none; b=pxp8Gl+skZobOSFliaLxt3ngw2PuGlUaDmAYu7ZYOQBSUG63mazFxA8uGwCZSBf4bIj6WJtV6G019mwB+ujgv2JhEqlEoDgiGdkPj7XZ4C7vLimrIWiwGehaDjf7ZWCT4owo6axqCWGNpEz9BgYTT2cb5ddKY0u+LtZ18xt0izo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880975; c=relaxed/simple;
	bh=pVnVfcpz/RiPzp4rkTfj+QlwzOpGdatVNLnuREHq27Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nb8Oj8yGAxVp/DmDlfOoD6dqvad2oIEyU3w9YU6VY5wwI8K8R05otXOiXUtrKwKUZpjZAtQnx8alw8RHKHKu11h+lN/+fcOX4zkb/jclcSlcaYoFl3N1VSelAYnefrROQiOtTlDSVvAisR9t/OUCWm8yJlsOr5eGLQp/ky2CSFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLdUxDo6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F8BC4CECD;
	Wed,  2 Oct 2024 14:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727880974;
	bh=pVnVfcpz/RiPzp4rkTfj+QlwzOpGdatVNLnuREHq27Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PLdUxDo6GA43EbldKvRJu+xC4QoZhOIk+w4XCLbDR4npEsVHOa/jQqbZxD4U7uZ/m
	 mLd+a+wxeSSVw8q1S0vv3uVE7YOb/xc1JnBR/CYUdEIw8A2rgx2MngTzDelaHtJ/ZC
	 sUit4lNTSmwrWS8DOKhqcK92eoN6OG0usaaTo8hvtZMzMMsSnpyk7+DDIW4sJqN7fV
	 F/sTaTEYuhRHGVy8yZCzpoh0gH8QbtxXc4PO1E9F3hXo6T2qpi5v4jqdlqaE7uHT6X
	 th7x9VnEi29gwHBdnsai/mWx6dI+tX/Wf0CNwvMixmXL5zqYoiV9LluDXR87tfVa9z
	 SuY8vatgRSG/Q==
Date: Wed, 2 Oct 2024 08:56:11 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hare@suse.de,
	sagi@grimberg.me, martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <Zv1fC3qYVDfxn3lQ@kbusch-mbp.dhcp.thefacebook.com>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com>
 <20240930181305.17286-1-joshi.k@samsung.com>
 <20241001092047.GA23730@lst.de>
 <ZvwiD0v3ASF8Hap2@kbusch-mbp.mynextlight.net>
 <20241002074926.GA20819@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002074926.GA20819@lst.de>

On Wed, Oct 02, 2024 at 09:49:26AM +0200, Christoph Hellwig wrote:
> On Tue, Oct 01, 2024 at 10:23:43AM -0600, Keith Busch wrote:
> > I think because he's getting conflicting feedback. The arguments against
> > it being that it's not a good match, however it's the same match created
> > for streams, and no one complained then, and it's an existing user ABI.
> 
> People complained, and the streams code got removed pretty quickly
> because it did not work as expected.  I don't think that counts as
> a big success.

I don't think the kernel API was the problem. Capable devices never
materialized, so the code wasn't doing anything useful.


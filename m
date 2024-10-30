Return-Path: <io-uring+bounces-4221-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01D959B6AA3
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:16:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65ACDB2353E
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 17:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8BE622EF1D;
	Wed, 30 Oct 2024 17:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5B+uCf1"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F4522EF1C;
	Wed, 30 Oct 2024 17:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730307906; cv=none; b=Zdr5CXQaEzbUTwMlGXqz/NLvM4bVJ6BjxlyXipeYnTMjpIUqrdGdu2X+zB51E+Ht+aE4lQLcDamWlC064tAcAwmljg/sZOfi3KHX8aKcerKzgMOZ2MZtawivPVgdVzoNXSaTZ+Vot63ThAGkjRd5SOCF7enMQPgvc6xGTcEbyTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730307906; c=relaxed/simple;
	bh=3DtqE1Xm3h/1759Uwrs5AVCXCgSav+wxnTVicElldR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hiPyAYCPaIESa2OzxmTVMTL1tIwOzZr9sRUkY/kAf/m5kpLFUU09Sq1tFtf73SrE//qBckwOGw7QXZsHj3m8Hhrtkn9WT43e70WJ/dky0QdDlevxMCSQuKcQCCiR5Xk/jkC59RzKwo8e6iHyHE3Wi05wbcuU5v5sYoxHwB8WTtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q5B+uCf1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BA4C4CED0;
	Wed, 30 Oct 2024 17:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730307906;
	bh=3DtqE1Xm3h/1759Uwrs5AVCXCgSav+wxnTVicElldR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q5B+uCf1RL9n9/HcoMYEhvnpYkDohIwvQgt5BsVCpivE8c10FEeCMZV2NGjy2k8h5
	 vkPqdSn6hSwNwygEiKLDA9l9DTmbBY/mxtxELLR3MsBivajYApT7jr4dOJNvBEhvf0
	 kM+crSIpMac+xGhPlcmpcvPes+kroyzg3RtAwhp5SorjHy6LaRmWJHaNZVKLVDMKLF
	 Sorvd2SBOMzsWCHwfbBcEHUN6GjrZb+p6Ser8X+B054K72MfeV0yCbcLU6UnZ4Ec1/
	 sgJWLkuE2GesRYxZthGfEtblBgSNiCHdor6TD9f32Lg+RB6cV2LmoIVqgrbR4cX0zL
	 QqrRRBMWSyaxA==
Date: Wed, 30 Oct 2024 11:05:03 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <ZyJnPwqIufrcMkFg@kbusch-mbp.dhcp.thefacebook.com>
References: <ZyEBhOoDHKJs4EEY@kbusch-mbp>
 <20241029155330.GA27856@lst.de>
 <ZyEL4FOBMr4H8DGM@kbusch-mbp>
 <20241030045526.GA32385@lst.de>
 <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com>
 <20241030154556.GA4449@lst.de>
 <ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com>
 <20241030155052.GA4984@lst.de>
 <ZyJiEwZwjevelmW2@kbusch-mbp.dhcp.thefacebook.com>
 <20241030165708.GA11009@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030165708.GA11009@lst.de>

On Wed, Oct 30, 2024 at 05:57:08PM +0100, Christoph Hellwig wrote:
> And once it uses by default, taking it away will have someone scream
> regresion, because we're not taking it away form that super special
> use case.

Refusing to allow something because someone might find it useful has got
to be the worst reasoning I've heard. :)


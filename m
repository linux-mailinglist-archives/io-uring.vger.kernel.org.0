Return-Path: <io-uring+bounces-10137-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D4187BFDC46
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 20:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1C1018903AD
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 18:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B30932E228D;
	Wed, 22 Oct 2025 18:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L45uF16e"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9FB8460
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 18:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156385; cv=none; b=Cu7seonuUWxHAHbj7aE1BsIsatHLneT0ACXuVlXlttHkBifUSiOQf3PpUvIjeHcdSH5wqt5NQMxSPn/IDuNwV85bJEQsvPftZniom9T8VaC5HjgRuHR9plxF6qgVao24SZL2xLfpzToDVM2RIHaPUqLFMZxikU4A0s9IGHWztUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156385; c=relaxed/simple;
	bh=gKj5ymae+Gd/9DTbjmdKzjKBSBE3K4W4fPOUCE62+LE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fuYIuAgb8kZXDB/qBwVAbn+6f4i8/2+B/MXt5+NZsBf34qGzoWHUYgl9PSczlbPk540YGXIziN4w51fHBLGF/BycWIDUj6Q123zv7Sp9i587Pdb6Wu9aWf1PjEO7wy2uY/Zi5jJGq9gcfyX/LQjZmE0+bXEDCm+SmYGrNe2gYfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L45uF16e; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB7DC4CEE7;
	Wed, 22 Oct 2025 18:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761156385;
	bh=gKj5ymae+Gd/9DTbjmdKzjKBSBE3K4W4fPOUCE62+LE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L45uF16e72ss2U5YYy7mWwpkYhhB7BNi17x5vSMhAOH51YRoXXWU+FVusWlTXk0+k
	 XD7xVYvWAnUDzb1HeVuV7h6fFlMvp1gPwWcpY6wsiDc3lhyqHkTN34qUsRsK8VDP4w
	 uA6FwvCvw3JgAFTD7QsTM1japbqOT4samAtl3ZqTB6hiJZGEc+40pSKlOR+W0kSlzK
	 s51pYEiYjIAdKvESkybdyk52+Dyr4lONGWGdhT2TabbdnRwp6xhwVoGnJoEaVujIdO
	 yhhqGsLrvDXUotEQqHg36ADdrp0ws5eGQVgpJLancjnvCDdvHSH4x2Pp+Isks+j21q
	 Cybp8o+RB3w/w==
Date: Wed, 22 Oct 2025 12:06:22 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH] add man pages for new apis
Message-ID: <aPkdHow085ple9Zi@kbusch-mbp>
References: <20251022180002.2685063-1-kbusch@meta.com>
 <f3b648e2-94c2-46c5-8769-a59e89890910@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3b648e2-94c2-46c5-8769-a59e89890910@kernel.dk>

On Wed, Oct 22, 2025 at 12:02:02PM -0600, Jens Axboe wrote:
> On 10/22/25 12:00 PM, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Add manuals for getting 128b submission queue entries, and the new prep
> > functions.
> 
> Thanks! A bit of too much copy pasting in terms of versions etc, but I
> can just fix those up. Also needs a bit of man formatting love, I'll
> do that too.

Ah, thanks. man syntax is weird, I usually see projects generate them
from a more friendly markup rather than committing their raw format.


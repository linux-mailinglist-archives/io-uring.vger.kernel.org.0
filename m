Return-Path: <io-uring+bounces-10532-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85C25C5127B
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 09:45:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CFC63ACDBB
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 08:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E8322DEA6F;
	Wed, 12 Nov 2025 08:44:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8D41F2380;
	Wed, 12 Nov 2025 08:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762937097; cv=none; b=kQWvaMApnBY3J8gH9v4BNHsl/QKAVgmI/LEDvfyC2zhdqePNZeozXRCffBGNGbn7ihW5qp8jyryLe5pp00kgzhjysP1/qvNi1ROwMNk5QgJRzvz5udVPtJ7hK5AL9tjOVYu0SY5R2oYjHF9lZ6vIc9U7nzH2gfVuQjSK3c4BT1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762937097; c=relaxed/simple;
	bh=i/75lYNlaOAPoz8kGUwkkFVSfZ5GPAL9rLFwgN3wCsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BlgiSiyaCGKkMhp6Yq5Ibhv1ywomILftyJc8VjnK//tgaO8h6BWfwVIRl9BHnmvrDZlLWF+kycrNu5Agozq/L7afKd2dMEeBPce5LPwpNdw846Q0IL8h0BfmSe7U8B4VAFJ+vNJbkFtfwdOxnZxjL1m9J0XLYkXJ8pmaouvwhgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 906D3227A88; Wed, 12 Nov 2025 09:44:51 +0100 (CET)
Date: Wed, 12 Nov 2025 09:44:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@scylladb.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: enable iomap dio write completions from interrupt context
Message-ID: <20251112084451.GA8742@lst.de>
References: <20251112072214.844816-1-hch@lst.de> <8c957ed5-ce4e-4207-8757-47b8ac168832@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c957ed5-ce4e-4207-8757-47b8ac168832@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 12, 2025 at 05:43:05PM +0900, Damien Le Moal wrote:
> Where is the zonefs change ? Missing a patch ?

There's not zonefs change.  The zonefs fix is the core code now calling
the read ->end_io handler from workqueue context after an I/O error, and
thus now doing what zonefs incorrectly assumed before.



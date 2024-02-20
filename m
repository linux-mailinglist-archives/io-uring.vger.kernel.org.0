Return-Path: <io-uring+bounces-652-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F12785B339
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 07:56:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D02532814F0
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 06:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B25142E3EB;
	Tue, 20 Feb 2024 06:55:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12F228363;
	Tue, 20 Feb 2024 06:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708412158; cv=none; b=lY0v+ZOJHFhQGQPcWUZiTCFuSgzBFZ+QUzyz3eazSHyoxWKKauU2ggoMu3/WGZrebbQZYbEEaTE3LLQ9g9QFBkO21EMPvoCRMVR0n704ZYxi/95+XxQ5UVmxyCmmHxnbS44WovcBTjUU0tu2Nrnn7r5Cd2f142r3DQ5DXq1nsh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708412158; c=relaxed/simple;
	bh=VD2f3ZBDoRPeSmVFOg7Jqi6oPwh+0fQd471Gme7Rki8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lmJvI/0avbbuJXeuUQ0X4yN2I83pQpaAImWGXMc/z2y8jfZ+QF1uUG5Xm5H9/bQvLSdnFhY00Sw1awld1VueCGwwm2uP0lNVrSkTgObZD1nN1z7AaVEtnDUIOVHxlTHhOS71ufPt2Nf/IaZQFxCuaTTa7fMO0npmd67i4qrtMJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5332168AFE; Tue, 20 Feb 2024 07:55:53 +0100 (CET)
Date: Tue, 20 Feb 2024 07:55:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com,
	djwong@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
	dchinner@redhat.com, jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, Alan Adamson <alan.adamson@oracle.com>
Subject: Re: [PATCH v4 10/11] nvme: Atomic write support
Message-ID: <20240220065553.GB9289@lst.de>
References: <20240219130109.341523-1-john.g.garry@oracle.com> <20240219130109.341523-11-john.g.garry@oracle.com> <ZdOqKr6Js_nlobh5@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdOqKr6Js_nlobh5@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 19, 2024 at 12:21:14PM -0700, Keith Busch wrote:
> Maybe patch 11 should be folded into this one. No bigged, the series as
> a whole looks good.

I did suggest just that last round already..


Return-Path: <io-uring+bounces-4088-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 00C249B3AA6
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 20:46:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABB611F2261D
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 19:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A743A1DB;
	Mon, 28 Oct 2024 19:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bx5NAOQS"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B3F524C;
	Mon, 28 Oct 2024 19:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730144800; cv=none; b=VCcPLHK3kWrAAuKiCW0tg5HT0b3/MgLQb6W6unK8EVgo+DqiwX0gVM9jOLd0WzXvGgluhDDD0Qu7l8K2Psa1RzbgagiXvJ3Suf6lfCYJYEbDD/FaOi6NTFIqWYZWuYtFBVM9xcLUcyIwvrw3nfO04C5V7bFvWcxrsZickbcD8ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730144800; c=relaxed/simple;
	bh=qZt8mJEDRl+Yth1e6zFjf+4BIU5q5r0ncS6SezGz7b8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=In/AA7WwQVKwBJ1zEXcPtPSIERw3ZU8s5sa7QTHSE+Rx+R+QFRLdMagGey4Oz/uM6P4f4XOBkffwYrk+5BOFdkTguCfj+1WPVrRCLplvCmb7DG4LT9ggHgrBZvUWY+3RB4utP7Yz/I3SwzwqU1ZNgXmrrtTgLU77wb89OPz/Ytg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bx5NAOQS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F33C4CEC3;
	Mon, 28 Oct 2024 19:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730144799;
	bh=qZt8mJEDRl+Yth1e6zFjf+4BIU5q5r0ncS6SezGz7b8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bx5NAOQS/qZimCwhu4Tm3bsAGYBRGjZwoqtP1zKvpbF3pT9s4gfzbc2zgrfenOZxM
	 zdZx6V1GKJeeI3+fls+Mx6UJfo4cVmLb0T/WZETo/fTXodQMVaxzL4KpJJbIT5dKVG
	 3svJm0EpMXZmnG8eoR6/0xvc8BLpglaWX9OTudu69TonjzK73RHXZimXm/5AEVQsVD
	 yLbjvDq27Hnr1p/9R5hfXS1hrxbPWwjmulI+itn7PHPZc/qB8v6lT54MVddl9Umfzu
	 nTuuhsKPauBDPxabGkrHj1EVc35BnyDJthVXBlOVp4WTHiSQNw6coamAekfchPx/fS
	 QksMEwbvoRQaw==
Date: Mon, 28 Oct 2024 13:46:36 -0600
From: Keith Busch <kbusch@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de,
	joshi.k@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCHv9 3/7] block: allow ability to limit partition write hints
Message-ID: <Zx_qHAqoFpl7Ivj7@kbusch-mbp>
References: <20241025213645.3464331-1-kbusch@meta.com>
 <20241025213645.3464331-4-kbusch@meta.com>
 <626bd35e-7216-4379-967d-5f6ebb4a5272@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <626bd35e-7216-4379-967d-5f6ebb4a5272@acm.org>

On Mon, Oct 28, 2024 at 11:27:33AM -0700, Bart Van Assche wrote:
> On 10/25/24 2:36 PM, Keith Busch wrote:
> > When multiple partitions are used, you may want to enforce different
> > subsets of the available write hints for each partition. Provide a
> > bitmap attribute of the available write hints, and allow an admin to
> > write a different mask to set the partition's allowed write hints.
> 
> After /proc/irq/*/smp_affinity was introduced (a bitmask),
> /proc/irq/*/smp_affinity_list (set of ranges) was introduced as a more
> user-friendly alternative. Is the same expected to happen with the
> write_hint_mask? If so, shouldn't we skip the bitmask user space
> interface and directly introduce the more user friendly interface (set
> of ranges)?

I don't much of have an opinion either way. One thing I like for the
bitmask representation is you write 0 to turn it off vs. the list type
writes a null string. Writing 0 to disable just feels more natural to
me, but not a big deal.


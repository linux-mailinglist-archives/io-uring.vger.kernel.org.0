Return-Path: <io-uring+bounces-6708-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F368CA42E86
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 22:03:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 004D117852A
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 21:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 372261991B6;
	Mon, 24 Feb 2025 21:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nAtOVsI3"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF12198845;
	Mon, 24 Feb 2025 21:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740430978; cv=none; b=En9QYB/qNfY5RNy8DkuvHia4khAlBFYbtpcyd/U2hemHIIdA80RwJIvl6ZuYj/Su5JujLxDWV3JcHfsuEkX51wzQgAoUhrhAM5ojrLWo0cw+vHulBzrbBm5sS2+4OXe5cjRG8W6KgNR+uWoizMu75e1GfpbySXxz7tzWzToPnbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740430978; c=relaxed/simple;
	bh=kQH4FSqGsTf/ENWED5gZDj0dZrVdaW+FNJywspK3HIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L3IeSWUkhNkhCexy/j1lkr4rKlPoeUK+LLwwUYzXn4Wy/CdduYW2httv8+UoB5tD73l5HpjpYgFOZHyEY1swLp8EO8oRGbdgyEMpu7t8W0b8nf52X1ZMSwpbuN/1gfpG+HvB2IyIDN38+dmOSExUMkBGrNYllktUu518zrGoBMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nAtOVsI3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A64CC4CED6;
	Mon, 24 Feb 2025 21:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740430977;
	bh=kQH4FSqGsTf/ENWED5gZDj0dZrVdaW+FNJywspK3HIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nAtOVsI3YqUYJWG8HrcXKlB9XpTS1OFq53s9KkZSbHHGcF+i28xq2JAoeYNo1BxfV
	 rh1wUsIGIG8XYNbUP7bfILz8n2IfhuxnnVFKgX5nZWYHdeVTUu/D8/QdH7Q544zigF
	 ZA3GhjwD2KGJlvLlyQVAgUBsN2c5fHq5wAGVHJMcSfeD0MyNJB1zXlsBJVyFl1BXNW
	 ILi6bqdCoMfvRz4vKqIn25Y9SpOfETdTeAX4ByMUz5A3qrUDG6GHTvSHkG0TDEzb5P
	 2Xva+CXOQgBSB0i/Aj6XOBFxQYNxtRhwdToGfnz0Xkd598xVPKci2nCOyxssLnvysA
	 6xOoeHl5WB2TQ==
Date: Mon, 24 Feb 2025 14:02:55 -0700
From: Keith Busch <kbusch@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com, csander@purestorage.com
Subject: Re: [PATCHv4 3/5] ublk: zc register/unregister bvec
Message-ID: <Z7zef3Ty42PbXxkT@kbusch-mbp>
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-4-kbusch@meta.com>
 <a636d5fa-1c60-410a-a876-52859df7277a@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a636d5fa-1c60-410a-a876-52859df7277a@gmail.com>

On Thu, Feb 20, 2025 at 11:11:59AM +0000, Pavel Begunkov wrote:
> On 2/18/25 22:42, Keith Busch wrote:
> > +static int ublk_unregister_io_buf(struct io_uring_cmd *cmd,
> > +				  struct ublk_queue *ubq, int tag,
> > +				  const struct ublksrv_io_cmd *ub_cmd,
> > +				  unsigned int issue_flags)
> > +{
> > +	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> > +	struct ublk_device *ub = cmd->file->private_data;
> > +	int index = (int)ub_cmd->addr;
> > +	struct ublk_rq_data *data;
> > +	struct request *req;
> > +
> > +	if (!ub)
> > +		return -EPERM;
> > +
> > +	req = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], tag);
> 
> Shouldn't there some speculation sanitisation for the tag as well?
> Looks like a user passed value directly indexing an array.

There are no other array speculation defenses here, so looks like a
pre-existing issue. I'll send something to address that separate from
this series.


Return-Path: <io-uring+bounces-6758-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF68FA448C2
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 18:47:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF570885111
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 17:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DFF518C034;
	Tue, 25 Feb 2025 17:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X079AkK5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D1715445D;
	Tue, 25 Feb 2025 17:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504753; cv=none; b=XHZJgea/DYe9t0OpsjdAQy32XQP17nPoHv+58Io9la4e9rjQ2PHbuzksXJk7Jh1Ex7+6xSbsHiawnBk/GrpBkEVaB+ARs1+rdPBCWhEQe0aC0S/m5F0T1Ey9r+XApQdfqlzg1fLCs2jaYC4yoEssU5viAaX2AfRCrlLKVQklnvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504753; c=relaxed/simple;
	bh=WXTf3EqU+ttyrsGnWXKJb8I6GmW83f0L9J4CqehU8Is=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tn+OqFeLKjcO9snEf5z8BTeBsDqXm4z1UN2SCyW/c3PquL4s2ejixXnRplz8GK6/VfVASIsImGxi5Z7sE1P+nVR2xjswFX77bX2seL1AECybm8c0u4yNCfKu1VjpM/HgsXcu0+ts7XSE9tXxTkMtBco09jCTORc9eV8NT6X0M9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X079AkK5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D09C4CEDD;
	Tue, 25 Feb 2025 17:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740504752;
	bh=WXTf3EqU+ttyrsGnWXKJb8I6GmW83f0L9J4CqehU8Is=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X079AkK5UjPQoakZXniCf36gK4StJwq2QKaa7mb3jAvAFIkV1rHc+WtKpglxSrUeI
	 mrAVWrB0eElkMF7lTkI3ik9ja0gwFKD8JkAxU7RZwEvrpNPiSKq/ew2RhOLRRBGWpu
	 EMrcePCe5gmiq1zRhraWyqHpK2jgglwfYPhlPdPoOhjeb1EqOL606N2SoizB9C80vu
	 wM4KlINOwfl7M/NvIW8eKj4H23SMoN8dUJGL7Tivt7czgQnPFG6p15ABk4jIVPvvPH
	 RVYJFLi+sA05+RSdViA4a6urHNSANtd0TlWVpqHX/cIFyjbEyP5ccrXp+qiZSmAinB
	 1+cyxbjIU2dtw==
Date: Tue, 25 Feb 2025 10:32:30 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com, csander@purestorage.com
Subject: Re: [PATCHv5 07/11] io_uring: add support for kernel registered bvecs
Message-ID: <Z73-rhNw3zgvUuZr@kbusch-mbp>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-8-kbusch@meta.com>
 <Z72P_nnZD9i-ya-1@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z72P_nnZD9i-ya-1@fedora>

On Tue, Feb 25, 2025 at 05:40:14PM +0800, Ming Lei wrote:
> On Mon, Feb 24, 2025 at 01:31:12PM -0800, Keith Busch wrote:
> > +
> > +	if (op_is_write(req_op(rq)))
> > +		imu->perm = IO_IMU_WRITEABLE;
> > +	else
> > +		imu->perm = IO_IMU_READABLE;
> 
> Looks the above is wrong, if request is for write op, the buffer
> should be readable & !writeable.
> 
> IO_IMU_WRITEABLE is supposed to mean the buffer is writeable, isn't it?

In the setup I used here, IMU_WRITEABLE means this can be used in a
write command. You can write from this buffer, not to it.

I think this is the kind of ambiguity that lead iov iter to call these
buffers SOURCE and DEST instead of WRITE and READ.


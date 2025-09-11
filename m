Return-Path: <io-uring+bounces-9725-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F265EB5264B
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 04:06:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 314F7188D565
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 02:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4A7D26ACC;
	Thu, 11 Sep 2025 02:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M1QtyayA"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C3615746E
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 02:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757556401; cv=none; b=mG+SLsAYLEHWEEHMa73TQ764EyEyJ5gGOSScJWQtRS0WchrsvV+9zQfolsVM76BJX/YIruHC4GPSfE0yN5Xn8SoVVWZBdMUg0uxpdri4Nxrs4KxsfukMtq1o8Sc2G/vrK6Km2ORA2yW0BS3gtPRMDb9wNMmJFnApCE52Rd131e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757556401; c=relaxed/simple;
	bh=WtaIn3MR8xwUk9n6PcYwXTpq5iluJhqa5/j6R/szb+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9lTaG9ZvU1jFKK9qd3pWcfRCltrf+dWXkBPXBKXR/jBDvVca+h37I1CNpxF8xx+9U5lWys4osjF5ZI1ORHzenO02+APykOT7NAIQTY/p4RQuvG9Rn2XTV66loYD0v1G3n9x78AkcUeoHP2ogCVAMJC+tIQFs1kikPa4g+zHHPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M1QtyayA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D1EC4CEEB;
	Thu, 11 Sep 2025 02:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757556401;
	bh=WtaIn3MR8xwUk9n6PcYwXTpq5iluJhqa5/j6R/szb+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M1QtyayAOkMnHKY1o+Qy7e/waLs5W1mObtqdB7tW5B1a/K0ml5lN6NqQZjMFSCxse
	 uzSwI+ksBRIAM/T5mDpIcq/9amBKyXUDJscLJcXAt4wavF3r88Zx1Uv1DI9jvkFVkv
	 /ZJ0Eb3pGRqYyFFWVQmV1xrWds81zIei4BPHuOA/xcOfCikERNDutqCUWl5xKlypSo
	 /P4xfk3Qk69M5qlp8EzsxsUVKndPShbrfTGMKFAKDCpsu6nwaY0VgW7bzbGRGSBpNS
	 R2wdWv2osBaOUBPnqJGqv85/AB9YJ4onG/+BekWCZBIVkds+t9tmqBrUES7WVwz8Dr
	 s+JC0vKDustsQ==
Date: Wed, 10 Sep 2025 22:06:37 -0400
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	axboe@kernel.dk
Subject: Re: [RFC PATCHv2 1/1] io_uring: add support for
 IORING_SETUP_SQE_MIXED
Message-ID: <aMIurWPAkYP0uWJI@kbusch-mbp>
References: <20250904192716.3064736-1-kbusch@meta.com>
 <20250904192716.3064736-3-kbusch@meta.com>
 <CADUfDZrmuJyqkBx7-8qcqKCsCJDnKTUYMk4L7aCOTJGSeMzq6g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZrmuJyqkBx7-8qcqKCsCJDnKTUYMk4L7aCOTJGSeMzq6g@mail.gmail.com>

On Wed, Sep 10, 2025 at 10:44:10AM -0700, Caleb Sander Mateos wrote:
> On Thu, Sep 4, 2025 at 12:27 PM Keith Busch <kbusch@meta.com> wrote:
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index 04ebff33d0e62..9cef9085f52ee 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -146,6 +146,7 @@ enum io_uring_sqe_flags_bit {
> >         IOSQE_ASYNC_BIT,
> >         IOSQE_BUFFER_SELECT_BIT,
> >         IOSQE_CQE_SKIP_SUCCESS_BIT,
> > +       IOSQE_SQE_128B_BIT,
> 
> Have you given any thought to how we would handle the likely scenario
> that we want to define more SQE flags in the future? Are there
> existing unused bytes of the SQE where the new flags could go? If not,
> we may need to repurpose some existing but rarely used field. And then
> we'd likely want to reserve this last flag bit to specify whether the
> SQE is using this "extended flags" field.

Yeah, I mentioned in the cover letter it may not okay to take this bit
for the cause. Using it this way is just a simple way forward for the
proof-of-concept to iron out handling mixed SQEs everywhere else. I
wouldn't remove the "RFC" prefix until we have agreement on how to flag
a big SQE command on a mixed SQ. One option, for example, might take the
highest opcode bit since we're a ways off off from needing it for more
ops.


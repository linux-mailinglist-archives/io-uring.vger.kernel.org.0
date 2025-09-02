Return-Path: <io-uring+bounces-9542-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C952B40CA9
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 20:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D7684815CC
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 18:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DB7C2BE64D;
	Tue,  2 Sep 2025 18:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZo29wCn"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC0C2877FC
	for <io-uring@vger.kernel.org>; Tue,  2 Sep 2025 18:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756836201; cv=none; b=IGqBZMWd4SEEoFsEfXstSXd28zJr7Fc2u1P/YIYtEMzbN30siRdhb844RTvVQh3JQFYF46wCWERvZpkaJPLjQemmeBWneGm3nTREFG1m4Xp2gHtkZ9LFfa4PgAsl2qEQypcPoeqEaWhBtaSJfX8F9OEO6KWyQ4yRm2U6mIt9oqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756836201; c=relaxed/simple;
	bh=xNsiOXk7ubONXSG8Yu74j0J32WOEqAThcTqWHznmpe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDX59MG6heJdi/UvJ61rJRxY6lmkkVwf+R0Fn8Ro4Viscf7AgwHwSJujnKIW5xb4Y8qw7wuvOXb3cDM7rz+E8QFHBpi3EqA/SQvBw3HyMblqAFiiovTHRn3y7MtZWbPoJP48lVtfPW5p64stte5yasPMXAXDJbqPBONMA8mIu+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZo29wCn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807CCC4CEED;
	Tue,  2 Sep 2025 18:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756836201;
	bh=xNsiOXk7ubONXSG8Yu74j0J32WOEqAThcTqWHznmpe4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TZo29wCnUQa6Ucjfhv/p4XZ5i/cYI90aCf9Q4j6xD7Bp7sj5I6ku7K8bAM6Q+lE7h
	 BI4f9xkxru5s7hlI0ByhEO5ebBJz6mWpRYY+9Ftn7hASZjdO2O8w1RZuudxW2SFrm2
	 gaY+rgMI55wWTvRMfyJstHvRuK4UwWCYQPng4CBYRiUXFHxX+JRRU6LvNQIRECkLqi
	 1KRaj/saf9RdGbWXFyNFlLJsWskhCb+Zl36cgyN+yTOeKAGx2haWq2rHmoRaInUe97
	 hQTNAnqJFrVBRo0h5yewtlAD2r8U2ZskfuM7XWV4q79qvgH0juCZEHWXZHP6mK5x1R
	 56tU1favfgV+g==
Date: Tue, 2 Sep 2025 12:03:19 -0600
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
Message-ID: <aLcxZ1mfG2pGDscF@kbusch-mbp>
References: <20250829193935.1910175-1-kbusch@meta.com>
 <20250829193935.1910175-3-kbusch@meta.com>
 <CADUfDZqpTsEOROA0Tkrq1WprpBvmzvhMPiFXZwLT4WMTSmAXqQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADUfDZqpTsEOROA0Tkrq1WprpBvmzvhMPiFXZwLT4WMTSmAXqQ@mail.gmail.com>

On Fri, Aug 29, 2025 at 02:29:39PM -0700, Caleb Sander Mateos wrote:
> 
> There are a few other users of IORING_SETUP_SQE128 that likely need to
> be made aware of IOSQE_SQE_128B. For one, uring_sqe_size(), which is
> used to determine how large the SQE payload is when copying it for a
> uring_cmd that goes async. And the logic for setting IO_URING_F_SQE128
> in io_uring_cmd() also needs to be adjusted.

Yeah, you're right. I did the liburing side first, and was a bit excited
to see the nop test was working correctly so quickly that I didn't
finish all the pieces. I'll get all that worked out on the next version.
Thanks for the comments!


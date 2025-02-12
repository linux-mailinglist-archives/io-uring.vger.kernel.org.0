Return-Path: <io-uring+bounces-6396-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55686A3334C
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 00:21:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC3973A1773
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 23:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 075F420011F;
	Wed, 12 Feb 2025 23:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XvaR9pTN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE69A1ACEA7;
	Wed, 12 Feb 2025 23:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739402465; cv=none; b=swRawNjRkt+f3Gc8lXujPKL0ONcoqk/AH0QxSgaasQBEU42DLTpFmeXsPfot3BlGI8evXAjkAVeOFPSy1lxUUu6hrab23YGjy3rL+OHWNm5YOF6y67xF4JcwkWgdICF1N+RlWYuDelM9k/eOJlOgO+z/hWFsHTW88q9ib9KGVfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739402465; c=relaxed/simple;
	bh=kQIYPQFo29OQZbO7m5+t8bb704m2oVi1kaalXm4t/uU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SoJrE1UdOdwzv8xcOC2H8xFSbHEJJdO4FOPCHBxhPRNJQUVOiCUtHVmm866ez062uumenOQ6u4nraVnOMFhUO35Q0du7J5z6S4HRVX+Ux9GFZn/44eQuEQ4CrfMdoqPP7AWgS+0V+0l0wbNzW6D+P5CywkbcHJjmHcebyYHoPSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XvaR9pTN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2B8C4CEDF;
	Wed, 12 Feb 2025 23:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739402465;
	bh=kQIYPQFo29OQZbO7m5+t8bb704m2oVi1kaalXm4t/uU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XvaR9pTNhJzyGfqx53XYp6aTYLyBRhVAymoOPiFrsZpbdfFvFXZdEUt3tx6VXYZWZ
	 zJTiheZy46U9hpIFgB0mKAojS0OgLaAbqhxUI0+Shv37Dm3Av+q6t206BicFQ23XxL
	 HIrJftRf5at4HWtV6x4az3Nsq6xbQjY/qhRASeriY1XPysOWlh/56M1bT40cvqs7hv
	 7dhwf0HFnrC8aCSt34gjLWBaafiF7ufRxISSeskkitT/BK2KFs1G9wykml6o6chv0N
	 yA0IgnI1ymhOTF9hSqGeMtNR+vyBxUaG/FfazeLO9xOlZQvO1On5Q5BP3hbUxvH5UD
	 u6xYTE8/r5STQ==
Date: Wed, 12 Feb 2025 16:21:02 -0700
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
	Riley Thomasson <riley@purestorage.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] uring_cmd SQE corruptions
Message-ID: <Z60s3ryl5UotleV-@kbusch-mbp>
References: <20250212204546.3751645-1-csander@purestorage.com>
 <401f9f7a-b813-43b0-b97f-0165072e2758@kernel.dk>
 <CADUfDZqK9+GLsRSdFVd47eZTsz863B3m16GtHc+Buiqdr7Jttg@mail.gmail.com>
 <999d55a6-b039-4a76-b0f6-3d055e91fd48@kernel.dk>
 <CADUfDZrjDF+xH1F98mMdR6brnPMARZ64yomfTYZ=5NStFM5osQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADUfDZrjDF+xH1F98mMdR6brnPMARZ64yomfTYZ=5NStFM5osQ@mail.gmail.com>

On Wed, Feb 12, 2025 at 03:07:30PM -0800, Caleb Sander Mateos wrote:
> 
> Yes, we completely agree. We are working on incorporating Keith's
> patchset now. It looks like there is still an open question about
> whether userspace will need to enforce ordering between the requests
> (either using linked operations or waiting for completions before
> submitting the subsequent operations).

In its current form, my series depends on you *not* using linked
requests. I didn't think it would be a problem as it follows an existing
pattern from the IORING_OP_FILES_UPDATE operation. That has to complete
in its entirety before prepping any subsequent commands that reference
the index, and using links would get the wrong results.


Return-Path: <io-uring+bounces-4150-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A925A9B5514
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 22:31:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B54AB216F4
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 21:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53561E1A2D;
	Tue, 29 Oct 2024 21:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spdIkOCm"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6629F1422AB;
	Tue, 29 Oct 2024 21:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730237511; cv=none; b=SngpPUMSHZtHd/eV5HiHbHgbVqraAMiSMJKds5QeFlQxX/7n6KMdV1SbTXH6N+ZBDJOZylfNXk1JTN48Zs0zvpTx0+6fKUowwIBrWSf6TUlrHVm/qbYiOKmDMUDJWpuiG5vrUw37iQW6JGzLFVqoEK8SwRieFVAaPv4LHJ4sw58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730237511; c=relaxed/simple;
	bh=56AYHcYUN+spbk38llt8j1FN9zcZj+uxltIZ3aCTggI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m3q8hSt5/BNmzc2Rv2QruGfA4Y+/IASZgWcmN58uE+aeNmlj4RiCvUul8l1glCJMOUxwJsptevoM+P1aMc1CpwwGDfJLD2bqiCKnLEPhysb2/qQ9I6QwNuXVqUi6C5NJYMjphvKLN1kFY8JLbWpXGUGUR27gySVz1whodG+ImFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spdIkOCm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBB2C4CECD;
	Tue, 29 Oct 2024 21:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730237510;
	bh=56AYHcYUN+spbk38llt8j1FN9zcZj+uxltIZ3aCTggI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=spdIkOCmPHZNkETdNxcFXTv47hnu2CVxJysnGzUTHqOTnqHNfBQSfqaRhTpCRz6+1
	 JgzMRlrE+ZqVtCKi7Xs2VcGCTHVoJ0y+MZMN3u+VilWEkEm3oU4+T1fQpSoe9WkjOZ
	 1PtMdJ/pbfJ7EzRvmS3Kn6IO9m2IuoOsjxiC4qMyXwBB05XpiYhEKih8rutZuUqOIT
	 7VREendKYBoXyTL0tO2fpxjukP5cSbgtsQ4jPzbgycb7Je3f8/PyuVbqsChbnoev4E
	 efGmHmCyXrehf7/BYL0lhJSO4dKc9ofOapI5t8/+7yuqvFfpR6R/1aaP1pyU2q4MgY
	 CMEaYVKpY+Sdw==
Date: Tue, 29 Oct 2024 15:31:47 -0600
From: Keith Busch <kbusch@kernel.org>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v5 03/10] block: modify bio_integrity_map_user to accept
 iov_iter as argument
Message-ID: <ZyFUQ78W35H73DMr@kbusch-mbp.dhcp.thefacebook.com>
References: <20241029162402.21400-1-anuj20.g@samsung.com>
 <CGME20241029163217epcas5p414d493b7a89c6bd092afd28c4eeea24c@epcas5p4.samsung.com>
 <20241029162402.21400-4-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029162402.21400-4-anuj20.g@samsung.com>

On Tue, Oct 29, 2024 at 09:53:55PM +0530, Anuj Gupta wrote:
> This patch refactors bio_integrity_map_user to accept iov_iter as
> argument. This is a prep patch.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>


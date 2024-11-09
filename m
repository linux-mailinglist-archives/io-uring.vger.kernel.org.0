Return-Path: <io-uring+bounces-4577-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0817B9C2C53
	for <lists+io-uring@lfdr.de>; Sat,  9 Nov 2024 12:56:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A3801C20C1D
	for <lists+io-uring@lfdr.de>; Sat,  9 Nov 2024 11:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41323188905;
	Sat,  9 Nov 2024 11:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CoLvH/fQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117C8154BEA;
	Sat,  9 Nov 2024 11:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731153347; cv=none; b=e0cyAjer9mjXEsKPrmESP1U9RhWiF+rgTHlhk2CQleJVf9OhhZWZqdIl3r/+91WLL8ksxzrMXGkDTIgAyAec93aIpieNljQciF6kM28foNHcFknb7IchtnCTnj1sSetBCpxyo+MH35fKVKvKdNJZupZeXUCC2GRALfiuImNebJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731153347; c=relaxed/simple;
	bh=VUyIoJgPqsF90ToPAFVYS3edk/MrcjNl+hh3pug7odo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qb/+vqUy7OTm1c+fMWnfMX3HkXzGW2DHwVwfz9EZzVycZKfzLVluqmN2gqu2OtZ9MRzOKIy2GKsWmYpJ5ObzAUOvwb6/wqb8X884RDyl9eXdBkCDFqlqr3uG7DmtS3gIW8h4BH6J3SipPVmNR0UL5ETPLlCVuJUt0u+FmcXCU3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CoLvH/fQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797ADC4CECE;
	Sat,  9 Nov 2024 11:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731153346;
	bh=VUyIoJgPqsF90ToPAFVYS3edk/MrcjNl+hh3pug7odo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CoLvH/fQuXcT5M7ex/CwwNH9sZLWyoTnocZcJRRm50duciVqZSviIhSa7KwkPrKH+
	 Hf3nmcLSPAZqqmujiGL4VUkeSyb6C2pGV/gb06riLremv5juorLhHOqTOVB/z/yZHI
	 Lom89WxXSdV3V2F6bMYI/euq4q0lQPc3e4c1ep81UWboWxek+CAX6fuQWZR1XkxMVM
	 8HQeTF3YwnBmRT0ctAzZVCn5/cZGPvWSojpw3Oyh3ZtDvlIcuOgCG5FCXY4bxzogBT
	 wgXYCpXnjj39geC58sDOfkhbC+lP/QsCorJxSKfHxRLqB7/Qdn/+a2/2XhnImuzO9X
	 b9BeQ2SKIB53g==
Date: Sat, 9 Nov 2024 06:55:46 -0500
From: Sasha Levin <sashal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: stable@vger.kernel.org, Peter Mann <peter.mann@sh.cz>,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: FAILED: Patch "io_uring/rw: fix missing NOWAIT check for
 O_DIRECT start write" failed to apply to v5.15-stable tree
Message-ID: <Zy9NwqnNjTOtN3RH@sashalap>
References: <20241106021214.182779-1-sashal@kernel.org>
 <7b5ea3e5-3d88-4571-a06b-7c952cb11613@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7b5ea3e5-3d88-4571-a06b-7c952cb11613@kernel.dk>

On Wed, Nov 06, 2024 at 07:45:54AM -0700, Jens Axboe wrote:
>On 11/5/24 7:12 PM, Sasha Levin wrote:
>> The patch below does not apply to the v5.15-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>
>Here's a tested series for 5.15-stable. I'll send the 5.10-stable
>series after this.

I've queued up the 5.10 and 5.15 backports, thanks!

-- 
Thanks,
Sasha


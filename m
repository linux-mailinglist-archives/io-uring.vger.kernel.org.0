Return-Path: <io-uring+bounces-9750-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2237FB536ED
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 17:05:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EDE51887C89
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 15:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11291194A44;
	Thu, 11 Sep 2025 15:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cfRn8LBN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9D75BAF0;
	Thu, 11 Sep 2025 15:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757603125; cv=none; b=Ql4spmNHWY2A1/InQ+bKTPpBWV6J8+f1YePWl8xpa/RWuENZ6Le63ibChJvA8pkwtsKFRwjYJYdOs40tA/jmQOzZCY4FMLdT5IbYZl0qfVm7Oa+CFlcNH6LhZNnWguOZQIXyIO/cww5JQ5PrUtEK3e9ZBoLG9i1s9FgrsrP6Lac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757603125; c=relaxed/simple;
	bh=kTQb11opTChZNj9h0F9lpqMyV8HyWYBUbODPI2uv1g4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CKm07QWSm2A5IzIaXG9qAfZIhAzB1ZXejoMa7h33qxXQfb0ivu4zCiNUAfU5yTfSlL250VRmy5scy4omkxqubh8ndTcEvqPIPfHfhG/XVUMnTEbiPg3J8RZAdsOAMtkUfVgA+/UABPUCx4TVy5KdItSohB5lBs2I3hbCooY+eyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cfRn8LBN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFB0C4CEF0;
	Thu, 11 Sep 2025 15:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757603124;
	bh=kTQb11opTChZNj9h0F9lpqMyV8HyWYBUbODPI2uv1g4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cfRn8LBN53W3g5rxlQyxFm9pg6iuwk5hR9MpMntJzFI8B85qH5c2dgTdUeB5DSDXo
	 mfijwuL5gAa49jlXr1/+Pt5sE41LWVAUQdrqg5Q+/KfLyWMidzMDhOuMg+fkqHPSMm
	 VBwqg3wfmCYigH3EXkbrXeJTgPynnm2hP7q8oHjE6yzTKZ6+pXIgiJwBE39czK8o0O
	 j1ln/pL+G6ba8LaJqPK7ecTpr3pn01jk7SbOTe/OuiaziryMDMkcBDj8k/UtoahZEm
	 lbyfEcP0KE3zKYRwXhP2MIEe/LT20FAMirThk/jU3c1Ds0wj9hd/E9JXd6cvO5vSYi
	 WypGneMjpBDsA==
Date: Thu, 11 Sep 2025 11:05:23 -0400
From: Sasha Levin <sashal@kernel.org>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: konstantin@linuxfoundation.org, axboe@kernel.dk,
	csander@purestorage.com, io-uring@vger.kernel.org,
	torvalds@linux-foundation.org, workflows@vger.kernel.org
Subject: Re: [RFC] b4 dig: Add AI-powered email relationship discovery command
Message-ID: <aMLlMz_ujgditm4c@laps>
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <20250909163214.3241191-1-sashal@kernel.org>
 <4764751.e9J7NaK4W3@workhorse>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4764751.e9J7NaK4W3@workhorse>

On Thu, Sep 11, 2025 at 04:48:03PM +0200, Nicolas Frattaroli wrote:
>On Tuesday, 9 September 2025 18:32:14 Central European Summer Time Sasha Levin wrote:
>it doesn't seem like Assisted-by is the right terminology here, as
>the code itself makes me believe it was written wholesale by your
>preferred LLM with minimal oversight, and then posted to the list.
>
>A non-exhaustive code review inline, as it quickly became clear
>this wasn't worth further time invested in reviewing.

Thanks for the review!

Indeed, Python isn't my language of choice: this script was a difficult (for
me) attempt at translating an equivalent bash based script that I already had
into python so it could fit into b4.

My intent was for this to start a discussion about this approach rather than
actually be merged into b4.

-- 
Thanks,
Sasha


Return-Path: <io-uring+bounces-2015-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D847B8D50CA
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 19:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D04A1F2151F
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 17:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A003BB2E;
	Thu, 30 May 2024 17:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cbdQ1Lso"
X-Original-To: io-uring@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AB0224EF
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 17:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717089372; cv=none; b=ZG+0IoERl93NymB7KsMvyRudW0/rDdiynbPoViSt1iYKOReI40RaWPRYkYJD55ioci91TgoN19DHcQ6FTCEbyE0WAM8mKRvbZ0TSolnztvzhbfJ0WPrwUITXPIVhQWsfZLlNIT7QeapwRCtPXBsk2pelnbFID16my4SPUhvffhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717089372; c=relaxed/simple;
	bh=3lzGOp7sF8vqreR4fWQ/fXEDhVryJycvRpkWMgP1ufo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F831HGXoV+w8VYXm7JfMAfV+l2LNWEiNz9LkfHmXAjANS4ktCy1gyq9M+vHCRLbA5NC7yONg+XJK4O+HdG/ikJ0EyMdSW+ESowmUwv+zmCTce4dJ7JIDwIVzQDC+ysmxWo/rHADPX4QqKTHpuzwnXz80jJwSydL8D/pZjma2RQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cbdQ1Lso; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: axboe@kernel.dk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717089366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+5pMemE92Q/Hlqbz3hKReYhxOMEPt7jEsfuulDZAkng=;
	b=cbdQ1LsodzTPXjrWT32Yd9zdGDNcSo3cyvQaEoh1clzzPGfw9+nsfk2MK0o87bbgw0WZc2
	/SonzfpuO069eS4OaZF8VqGbYCo77kwF3e1wEqB5kQ81g26/7EFJeB/9HJm28mnGmJNjee
	F5Z20qtYalupc5/jx0VPX+1674YPKKw=
X-Envelope-To: bernd.schubert@fastmail.fm
X-Envelope-To: bschubert@ddn.com
X-Envelope-To: miklos@szeredi.hu
X-Envelope-To: amir73il@gmail.com
X-Envelope-To: linux-fsdevel@vger.kernel.org
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: mingo@redhat.com
X-Envelope-To: peterz@infradead.org
X-Envelope-To: avagin@google.com
X-Envelope-To: io-uring@vger.kernel.org
X-Envelope-To: ming.lei@redhat.com
X-Envelope-To: asml.silence@gmail.com
X-Envelope-To: josef@toxicpanda.com
Date: Thu, 30 May 2024 13:16:01 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, 
	Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org, 
	Ming Lei <ming.lei@redhat.com>, Pavel Begunkov <asml.silence@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Message-ID: <tpdo6jfuhouew6stoy7y7sy5dvzphetqic2tzf74c47vr7s5qi@c5ttwxatvwbi>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <5mimjjxul2sc2g7x6pttnit46pbw3astwj2giqfr4xayp63el2@fb5bgtiavwgv>
 <8c3548a9-3b15-49c4-9e38-68d81433144a@fastmail.fm>
 <9db5fc0c-cce5-4d01-af60-f28f55c3aa99@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9db5fc0c-cce5-4d01-af60-f28f55c3aa99@kernel.dk>
X-Migadu-Flow: FLOW_OUT

On Thu, May 30, 2024 at 10:21:19AM -0600, Jens Axboe wrote:
> On 5/30/24 10:02 AM, Bernd Schubert wrote:
> > From our side, a customer has pointed out security concerns for io-uring. 
> 
> That's just bs and fud these days.

You have a history of being less than responsive with bug reports, and
this sort of attitude is not the attitude of a responsible maintainer.

From what I've seen those concerns were well founded, so if you want to
be taking seriously I'd be talking about what was done to address them
instead of namecalling.


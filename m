Return-Path: <io-uring+bounces-9759-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F954B53F10
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 01:24:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6234D1C86983
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 23:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68ACB2F3C19;
	Thu, 11 Sep 2025 23:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhFmptbu"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295AF2E1F1C;
	Thu, 11 Sep 2025 23:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757633045; cv=none; b=DtFMwt5K+CpIDIz5DImJyD4WNbWnchoogN/QbMRu9JJrU8KcneYGn4UWgjsVrC/25IF4WY+aQNGAiIPUYCzB6CFy8Vt4u3Cfcsd8O3YqpOLP7MRfqdrBNBpEz21ArEMypvtj5p4t3DbMlnbLaDheDrItqR6JQ7kuNAOLJ5pQfLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757633045; c=relaxed/simple;
	bh=4RN4G5nFo80zxCLbZcaoPW0025YHvftVo4h5LujOgBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pgwNIXDb9fFXQs6UCqpV50qCSpFkBpzK+MS6uho+fVyrs8Uj2C4vsHEwICr7OFwbrr8DxRzBoSWW6RZ0Sh/Ys2M1EStTCYl5MDc88zgOahbdSkNZuSPtG9MDfeRcBMxqWyEP2DspV7Y0KXZb7vyNSlKzXgNxvwaMNig5ZIfpHm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhFmptbu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB4BC4CEF0;
	Thu, 11 Sep 2025 23:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757633044;
	bh=4RN4G5nFo80zxCLbZcaoPW0025YHvftVo4h5LujOgBQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BhFmptbudL5b4JuehsACTMNCDxRh1Iw5069gjzBBhmvSipn230PVP9TvP/Y8+/bC8
	 yHXoPSyhdgzzNuxRqxI9lqumES5RHlIz73BMw1Q+NzMXXk94QXrB4oYFLZZ/teOu+f
	 4eRWwL4bwfLyaljawjJpq7Na9EEmwcAYOIFl4CKc=
Date: Thu, 11 Sep 2025 19:24:03 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Sasha Levin <sashal@kernel.org>
Cc: axboe@kernel.dk, csander@purestorage.com, io-uring@vger.kernel.org, 
	torvalds@linux-foundation.org, workflows@vger.kernel.org
Subject: Re: [RFC] b4 dig: Add AI-powered email relationship discovery command
Message-ID: <20250911-neon-speedy-walrus-dcc499@meerkat>
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <20250909163214.3241191-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250909163214.3241191-1-sashal@kernel.org>

On Tue, Sep 09, 2025 at 12:32:14PM -0400, Sasha Levin wrote:
> Add a new 'b4 dig' subcommand that uses AI agents to discover related
> emails for a given message ID. This helps developers find all relevant
> context around patches including previous versions, bug reports, reviews,
> and related discussions.

All right, I've got ollama working on my gaming rig now, so that I can get
back to my summarization work without having to rely on big vendors. Thanks
for pushing me in that direction, because it never felt quite right to be
using a centralized service for this work. At least that large nvidia card
does something other than help me deliver packages to Port Knot City.

> The command:
> - Takes a message ID and constructs a detailed prompt about email relationships
> - Calls a configured AI agent script to analyze and find related messages
> - Downloads all related threads from lore.kernel.org
> - Combines them into a single mbox file for easy review

I'm going to take a look at it, but I want to use "b4 dig" to analyze commits
and establish their provenance. I will then look at whether we can use LLMs to
provide additional perks like summarization or highlights of important
messages (those offering nacks, criticisms, warnings, etc). This seems like the
"least wrong" way of using an LLM at this moment, especially with the legality
of the code it produces still largely untested in courts.

Thanks for submitting this to push me into this direction. I won't take this
directly, but I'll rely on it to see how you get certain things done.

Regards,
-K


Return-Path: <io-uring+bounces-9757-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 59D0EB53C1F
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 21:13:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CB431BC7464
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 19:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2318625484D;
	Thu, 11 Sep 2025 19:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="UOEcDbdD"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC3F17C21C;
	Thu, 11 Sep 2025 19:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757618027; cv=pass; b=K5/vp0251Z1snRAlB2AlWH/m7z4d+syePiPQjWPm4a1XZYkdn/ov8EAZyngaj0gyueAm4aW+5ekABaPULJqwoAIME4Fmn6KCrVR5jI+RJuRYaP2or35ucWxqpPaKCPWg9f+pVcE4qOOfy5/jkvhAremzSF6dJpuAinw0eENpCtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757618027; c=relaxed/simple;
	bh=/y2tq5te3Hj2LI91DCTQpf3xen1/iW0P6TT+yTgBKQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s20UL9HgT9WnKlTkTT+cdGDuJA0zXi63ASK4DR58x2tlr/9dW9jbs1A86PA/DCffmnbacQP4GgbNKHCmdIvWY75/caVn9PNTLOctFoYY5kt08jDhja+s3y5jqNaoM+BW6QZowBV53dCEUsRCFi9JI4/evYNlGKVw1uCgP19egZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=UOEcDbdD; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1757618014; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=nkXkMBYuB0fMP4rM+ri0ba9ivOgkd18FJpOPQodcBczYjPhD8D2uAidm82JOGudYoywD8s7GCjucbpvU9VBUAn63XUv7GggyDCXqGqBXzr1xrw2yq7MZvwJYfVm9pjQKR8UG+d4Y677hSlhvAmRby1r4q9ShaZyhntYyjezSOMU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1757618014; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=L2UVdjsYZJkAnBBvIllckgQMsXgXuSQjpas1+bmt/EI=; 
	b=FxPsKOI78ZnzdPWaZ+al4EzmRrkvykuDshZui7tLWBF7sbvT8ODA1IoSKntKs9veZ2ZiYXOds9CA4QThjaHNUeXEPGWNmSwIH6kp9AD4t4Y/10SY82gf4/x2nsjyU67Wm48YA2LkB9SLRAUxZc9APsbG4/D7Ik7tnfa9+y7ivUU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1757618014;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
	bh=L2UVdjsYZJkAnBBvIllckgQMsXgXuSQjpas1+bmt/EI=;
	b=UOEcDbdDZXKH4kaBz8Gn0vu7mjxH9Ii+j4JLTrFG2YP00DrszIZ0D1kMpqHgONPT
	nN5EeJin6eIhxSKGkAVO090A2EMabXjJLdskdoWlRM8QU3SFwq3xJ2P7nwtC1Eha0vO
	OIIudVLSjGqkG3Eiet+rqTZmIH1WaM26Ek2E60Gw=
Received: by mx.zohomail.com with SMTPS id 1757618012484692.4540050345284;
	Thu, 11 Sep 2025 12:13:32 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
To: Sasha Levin <sashal@kernel.org>
Cc: konstantin@linuxfoundation.org, axboe@kernel.dk, csander@purestorage.com,
 io-uring@vger.kernel.org, torvalds@linux-foundation.org,
 workflows@vger.kernel.org,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] b4 dig: Add AI-powered email relationship discovery command
Date: Thu, 11 Sep 2025 21:13:28 +0200
Message-ID: <4278380.jE0xQCEvom@workhorse>
In-Reply-To: <aMLlMz_ujgditm4c@laps>
References:
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <4764751.e9J7NaK4W3@workhorse> <aMLlMz_ujgditm4c@laps>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Thursday, 11 September 2025 17:05:23 Central European Summer Time Sasha Levin wrote:
> On Thu, Sep 11, 2025 at 04:48:03PM +0200, Nicolas Frattaroli wrote:
> >On Tuesday, 9 September 2025 18:32:14 Central European Summer Time Sasha Levin wrote:
> >it doesn't seem like Assisted-by is the right terminology here, as
> >the code itself makes me believe it was written wholesale by your
> >preferred LLM with minimal oversight, and then posted to the list.
> >
> >A non-exhaustive code review inline, as it quickly became clear
> >this wasn't worth further time invested in reviewing.
> 
> Thanks for the review!
> 
> Indeed, Python isn't my language of choice: this script was a difficult (for
> me) attempt at translating an equivalent bash based script that I already had
> into python so it could fit into b4.

There's something to be said about these tools' habit of empowering
people to think they can judge the output adequately, but I don't
want to detract from the other point I'll try to make in this reply.

> My intent was for this to start a discussion about this approach rather than
> actually be merged into b4.

I know that, and you did get feedback on this approach already from
others, specifically that it did not solve the core issue that is
poorly utilised metadata and instead applies hammer to vaguely nail
shaped thing.

And your reaction was to call them personally biased against this
approach, and to loudly announce you would ignore any further
e-mails from them.

Now while I won't claim Laurent Pinchart isn't one of the louder
critics of your recent LLM evangelism, I can't really see a fault
in his reasoning: your insistence on finding an LLM solution to
every and any problem is papering over the real pain point,
which is that Link: should contain useful information, so that
you can click on the link and get the information and not have
to do a search (LLM assisted or not) for said information.

So the responses you expect to this patch should seemingly meet the
following two criteria:
1. we're not supposed to critique the implementation, as it's an RFC
   and therefore should not get comments on anything but the general
   approach,
2. we're not supposed to critique the general approach, because saying
   that this solution is neither reliable nor efficient is a result
   of personal bias against the underlying technology.

I don't condone the arguments based on energy usage because any use
of electricity in a grid that's not decarbonised will be open to
value judgements. For example, my personal non-workplace-endorsed
opinion is that electricity used on growing zucchini is wasted,
as they are low-nutrient snot pumpkins masquerading as cucumbers.

My main criticism on the approach end of things, if I am allowed
an opinion, is that this does not make Link: tags more meaningful,
nor does it solve the problem of automated tools adding sometimes
useless noise to something humans are supposed to be reading (which,
some may point out, your tool makes even worse.)

While bisecting, I often come across things where I'd love to be
able to immediately see what discussion preceded the problematic
patch with just one click and pageload between. Shoveling GPUs
into Sam Altman's gaping cheeks does not allow me to do that,
or at least not any better than a search on lore with dfn: would
already allow me to do.





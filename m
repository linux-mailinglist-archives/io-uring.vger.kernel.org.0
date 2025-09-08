Return-Path: <io-uring+bounces-9658-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18635B49CBB
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 00:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F7251BC2BD8
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 22:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA8AE1DDC2A;
	Mon,  8 Sep 2025 22:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O2rj+UlI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3787A1CAB3;
	Mon,  8 Sep 2025 22:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757369757; cv=none; b=GQxk6MkKafmycpEq22BtG8l/t1743X85xKJoT0zR2AchSGLx3YlDasQ4zgPHq4nsah36dRAGwkfpzstHJtOcV0FRsMPDcN2bXdWltBEsCaAUw62KtThyh9jtQut8B7xzPoP9ugig2Pyfo/SQBhfHKU9TA1D5osx7TjSHUSxoKAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757369757; c=relaxed/simple;
	bh=RwQ7UCz527ifaP8+Sv/1V2E2KJyy2+JYcgwQhQSMazI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kK9gM8ILZiXLPS4mYL1s3jKyht0c4usxQDqFhBdbxLJlzl5/FX2AwY7o9VteGhekWTrrWYVhpueOJlrNw8e5oYNlZq7sCcuIYtPErswrbRN0Gr5XXUklrlUbhctKQ+PdKm9eNXyid4eujq769XnEGnN0fHU9mSiiDS1S+DetuGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O2rj+UlI; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2445824dc27so48838625ad.3;
        Mon, 08 Sep 2025 15:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757369755; x=1757974555; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XmleHkclN2N7xiK207HC2jo02VYu1gJHqknqPHZCHKY=;
        b=O2rj+UlI+xDDotrfyFzqsVimAPeXlZdu/NizeFQkIYPH6VkSresx0dn5k5ONNQNZSL
         G7bsGn2Wyk9NnQ86N0atfMCsNpxHCWjgrE/ziIadHOAbUGSzWUjqaDs4z0l2Yp27Kpiu
         QaVBuanPO0LLDVc1m3OTdwnz2f3fQyGDUHH+PtBfANvE/n4pA7+f8q/GH9DerN1OQdZO
         0diJ3xs3EipIsJcL7Udujv6vJnpLRhoZXQUKr2+oJ9CYjKtLPGayR3bb9heVwd3mEH1P
         3Xcm1RpE73si/pwof3oaxaQ9olWigWdLVd2mPxFASMjSFyCdGeOhPU8pzrUUvbbdX7tG
         Jmcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757369755; x=1757974555;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XmleHkclN2N7xiK207HC2jo02VYu1gJHqknqPHZCHKY=;
        b=fpBWkS7hNYmjuwS6o6/OeC47/g62FoH7j4uY3YQVxvIC52jKY5w/8WEPiOrdezeMOy
         /bLyRiEP1+vi1udjdIFUL9vWsi+s3eVbntSqcDTj66gJwVPUFnVPWiSmuGWWjoY5Vjd9
         MXOS2uFUIXUoF/+avZD5hqNnbYD1fThnm7LVJk/KXZDjEQQgs/ghnRUDNN64TdR0lIpg
         aw72Rv5enP5BtVblxME8RtX5weoFLRDYPsoyjiNlBnDLfb6rejyvaqmuIOWOdKGXlX+b
         bdMo+5FKcXcF4qk6rtuNOareNa6c9SSlihz4Ay69+SjKCukI48CkKlyFI+U3E1Yv74jo
         77Xw==
X-Forwarded-Encrypted: i=1; AJvYcCU53SAO/FAi2zAvoGw5Dhphoz1ty+gIJYXcSyztDy0omrzjYsAVIjSFXCfy96KTtIW4Np4=@vger.kernel.org, AJvYcCWhBiJPul2FbsVt7oouT492Lo3atcCzV0jVHxMiFfGWKX8kJ5TXsCkBKcRY3GHP4/QyVURkNzUPXB0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbYquLh61bku9XCiZgDygnG45gWo0SXOyqeO1EB6Qzk6ma/YXg
	nPrLzzOuO7VtJgMGzzNpXuE6uvGlAAhyXdEDn3VcRcnFWS8W/L2bCJWR
X-Gm-Gg: ASbGnculvKyGxyv2Ru24TkqmaQDtkxbECvy9zVVbrajrc3gygtvnEdAzPQZi1gAa6ID
	Soj96rxrZhp3JlB2+iY5cR53ulmpqh5oo8YwEdUL8BSL+f3K0wARH3cKsGOZ+UiB4+tJlgrO97U
	8XyQl9w3PgZy1qR6JAq5mkt+hclh495wYnP9kT8tVpCM3LokNs1NnNMLfYh6lw5KGQ6AdgI1VLV
	VqX9bOD36sdkg0jzVvbnJhC+KX71kkrh7+2gpoL2HOGhiBrL2jlJAhLfZ+sc0rnWEgRH1wdi7kv
	mdAqISadDW0b9aVOCxP50X8eM5RwSmzc+r2p6pnHArxnKdEkNkNnrY3j+0qySVKz8rkfwcjCxwn
	M/PFuTHXypWSyM6ldlxzrBdNJQ5NPO5nl5AYesXE8qQzP4Dz6u5RuxOj8501HbQ==
X-Google-Smtp-Source: AGHT+IGsWoGRUEg2UW+xk0le/mjW+nq65zly6kSjWr/ClU/xlK6N1ucyeRRCp65bdRfDg0FeSN6JLA==
X-Received: by 2002:a17:902:ef52:b0:251:5f19:c3b1 with SMTP id d9443c01a7336-2516dbf19camr100172555ad.9.1757369755316;
        Mon, 08 Sep 2025 15:15:55 -0700 (PDT)
Received: from MacBook-Pro-49.local ([2001:558:600a:7:44e6:767e:cc5a:a060])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2490658999fsm288788275ad.112.2025.09.08.15.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 15:15:54 -0700 (PDT)
Date: Mon, 8 Sep 2025 15:15:53 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>, bpf@vger.kernel.org
Subject: Re: [GIT PULL] io_uring fix for 6.17-rc5
Message-ID: <lxevpprltteumg5r77ekdors6tlpy5vyvxxef737obpluz2u44@vgkpxkcwq76r>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <f0f31943-cfed-463d-8e03-9855ba027830@kernel.dk>
 <CAHk-=wgkgSoqMh3CQgj=tvKdEwJhFvr1gtDbK7Givr1bNRZ==w@mail.gmail.com>
 <72fb5776-0c50-42b8-943d-940960714811@kernel.dk>
 <CAHk-=wgdOGyaZ3p=r8Zn8Su0DnSqhEAMXzME91ZD9=8DDurnUg@mail.gmail.com>
 <a65abd25-69bd-4f10-a8b8-90c348d89242@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a65abd25-69bd-4f10-a8b8-90c348d89242@kernel.dk>

On Fri, Sep 05, 2025 at 06:01:01PM -0600, Jens Axboe wrote:
> On 9/5/25 2:54 PM, Linus Torvalds wrote:
> > On Fri, 5 Sept 2025 at 12:30, Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> Like I said, I think there more fruitful ways to get the point across
> >> and this picked up and well known, because I don't believe it is right
> >> now.
> > 
> > So I've actually been complaining about the link tags for years: [1]
> > [2] [3] [4].
> > 
> > In fact, that [4] from 2022 is about how people are then trying to
> > distinguish the *useful* links (to bug reports) from the useless ones,
> > by giving them a different name ("Buglink:"). Where I was telling
> > people to instead fix this problem by just not adding the useless
> > links in the first place!
> > 
> > Anyway, I'm a bit frustrated, exactly because this _has_ been going on
> > for years. It's not a new peeve.
> 
> What's that saying on doing the same thing over and over again and
> expecting different results...? :-)
> 
> > And I don't think we have a good central place for that kind of "don't do this".
> > 
> > Yes, there's the maintainer summit, but that's a pretty limited set of people.
> 
> That'd be a great place to discuss it, however. One thing I've always
> wanted to bring up but have forgotten to, is how I'd _love_ for your PR
> merges to contain the link to the PR that you got for them. Yes I know
> that's now adding a link, but that's a useful one. Maybe not for you,
> but for me and I bet tons of other people. At least if there's
> discussion on it. But hey I'd be happy if it was just always there, but
> it seems we disagree on that part.

+1 to above request.

Regarding Link tag. We've been adding them to all bpf/net commits
for quite some time and found them useful in many cases:

1. patches rarely come as a single patch. Even if it's a single line
fix there is likely a selftest in the other commit. When I investigate
a commit clicking on lore link and seeing the whole series saves a ton
of time, since search by commit name in lore.kernel.org/all/ isn't great.

2. patches rarely accepted on the first revision and we recommend developers
to add lore link to v1 when they respin v2. So by the time vN series
are accepted the cover letter has links to all previous revisions.
Similarly when I debug an issue: git blame, git show sha, click on lore link,
click on 0/N, click on v2-v3, since most of the interesting discussion
happens in earlier revisions. The last few respins will typically address
final nits.

3. even if it's a rare single commit the patch subject doesn't say
whether it was v1 or v2, while lore has this information in email
like [PATCH bpf-next v2] subj. Going to lore and realizing that
ohh it was v2 that was accepted is a lot better than search by subject
and seeing v1, v2, v3 versions of the same patch and not being able
to tell which one was applied.

So the only case where Link is useless is the case of single commit
without any revisions that was accepted on the first try.
We can manually remove such links, but this would be tedious
manual work, since automation is tailored for common case where
link is in every commit and they are useful.



Return-Path: <io-uring+bounces-9611-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A79AB46501
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 22:54:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 384021CC0547
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 20:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49EC02DAFBE;
	Fri,  5 Sep 2025 20:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CSyvRoeK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE3C285CB9
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 20:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757105665; cv=none; b=SdzEtzhUiH/wtUlT9N/hh53FezVvmolZeZS0kZ8S4n3gsgy194bWWExAAVMyH5gt1OG38xBX13Gd20ci2PeksD77DdwNoA5B0D6PSK40Z3wNUQHRYgghl+Au8ktEtNwRg4pwFQG9HvPmMNeHTJ2aac7L11qHargLQykWMUg5Z/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757105665; c=relaxed/simple;
	bh=MAf0SZO83um8RJakkKNX5oj2zVOPSjxCDK8t47hxPxs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aHIjgfuNvQaCbm2CisiYNzqhDZyUdDyAu8LbXvgrNuzURwgACP2D2iI+jy6kRmW8y5EyZ+K534ZY0c6TCMnCvZ8/WpnG+MXGFYpYaSiHBPx8kjzRFBsv08Xgh47ND3xde4LbmTjvSSe4lKxoS9J4TuqGm93w+YrOy4sxSC9KJlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CSyvRoeK; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-62105d21293so2653348a12.1
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 13:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1757105661; x=1757710461; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xeI5uxqqoARD89BnQ0NTAo1OVhNWzuVOTNFshiJtoyM=;
        b=CSyvRoeKcGOi7+3KpUQfH/ictYxQcL+PyLqV/Acol4OFBBumRK7PxpExKvzcA/1aYz
         +mB29za1VucwdBrrYZ/6kpBDV1XGVXuSthc+YBt+qZIqC+1rU2lKxVMimwtjRvW1p6rc
         /jolwbQvcNxyg7D2UoYEJpcb233U/DIlDbvNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757105661; x=1757710461;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xeI5uxqqoARD89BnQ0NTAo1OVhNWzuVOTNFshiJtoyM=;
        b=eUdpQ3Sxl2I/2HGfinV0kWPyPf7NpqVloZJCF5wP5Qh2ZbZrzmML3i/KOYWQ2ilSMG
         UOSbZEw9Wwj79cLR9eCM+lv6vX3GbaakPd9NZ/09eT/7bjJClGLLtaPN8qv+yus6Q7KO
         ijgdmXYcV7UxLY8zMROYgkgM5ZaZa5odi5/Ev0Nj1l6XPrbcnJub2eMuh6tLZysHa4zW
         3zfrIhqmylADZXwsUHtdzFPdZF2aj3Ss/1/XzXmtxfZW0aDHn8Es05XpN1RoA3nTQ0e8
         7Zs277p/eypzMDV71n7AZ4OXncEbMIpSaaN3PMuLhkmGcz6UTVkLPxj36aiJ5nBFlSAY
         T1UQ==
X-Forwarded-Encrypted: i=1; AJvYcCWszriEFIMC432qsz4EpyXlXM6cMifEyh2Pcllo+Eb9qIwFL6B4V1hEOC5ecMQnpBnayxuabd4t5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzCqt3sKO3Hgee454QCPSr6AelFM6hOwgiDj+G5+1wXoMpcJ386
	KhlFcrDn2BwaiuwAGiDwE0XXdL/Bxh+/Wvpbl2xMV2IVTLu6gmwMD/ZSVM6mA0OxZ/35CkFLtBO
	pKrMSSF4=
X-Gm-Gg: ASbGncusDFk4WNixmUawN8KhwOYyL2Tb/DhEUv9TEj4BMw/qtfv2N9zw7LuxIRuPUSW
	Q06RI/n57GT3E0uj6Xvhc8bNxyAmZphffwv7XtVujqGdauaGk1mxGaEeArrTpDoxS2g1zDBfp91
	m/FC0KxpYcpFtJ3wb1p97o0wOeZmKpEXASZw9CYZQi1yD2/NZd063NuQ0BbD/CXXkXvBvXE734d
	YIPd0RjgunlN6I2SMtybecfetVdgH8s78SY525zgHRRnsr8trdqIIkGGOktZR9g9yyMCrDjfMTO
	YyUuepTf16YAXkdqf2G2yVfM9/WZEfHUqrxKggA59oE7XbC0nknpm6T/Py9KpBFdd0kTbT8a+o8
	Xfz2AaiyZrG4SKxbslisMga5ac/82Gp/RmqquwtjQoDDD7vAo0/aZ7KeGjQC66+30+tSZqlx1dr
	k2Rr0RcVk=
X-Google-Smtp-Source: AGHT+IE7yLQGj/tILYCRItBcVpvBvDeDoiyAJdHq+ttSZVQBd2GlmSR7f1FdjCxbIaSMiZ62dQz1nA==
X-Received: by 2002:a05:6402:26cc:b0:620:1030:1385 with SMTP id 4fb4d7f45d1cf-6237845b164mr301835a12.32.1757105660823;
        Fri, 05 Sep 2025 13:54:20 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc5575dcsm17180395a12.49.2025.09.05.13.54.20
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 13:54:20 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b0472bd218bso454850866b.1
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 13:54:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWuiuOzZ8birnO6Oi+m4g3F12VX8+l3KtUXSr7by7kM8SqqEXmeGVGVuSEpuxyh1x6+ZGYk2EMOfQ==@vger.kernel.org
X-Received: by 2002:a17:907:1c10:b0:b04:1a80:35b9 with SMTP id
 a640c23a62f3a-b04b13cd575mr12690666b.12.1757105659694; Fri, 05 Sep 2025
 13:54:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <f0f31943-cfed-463d-8e03-9855ba027830@kernel.dk> <CAHk-=wgkgSoqMh3CQgj=tvKdEwJhFvr1gtDbK7Givr1bNRZ==w@mail.gmail.com>
 <72fb5776-0c50-42b8-943d-940960714811@kernel.dk>
In-Reply-To: <72fb5776-0c50-42b8-943d-940960714811@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Sep 2025 13:54:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgdOGyaZ3p=r8Zn8Su0DnSqhEAMXzME91ZD9=8DDurnUg@mail.gmail.com>
X-Gm-Features: Ac12FXzEOlqgAVNuWTXpkSiFOW32U1HDNta-OqsyqUoOurQaAKrWT8aonma6-lc
Message-ID: <CAHk-=wgdOGyaZ3p=r8Zn8Su0DnSqhEAMXzME91ZD9=8DDurnUg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 6.17-rc5
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Sept 2025 at 12:30, Jens Axboe <axboe@kernel.dk> wrote:
>
> Like I said, I think there more fruitful ways to get the point across
> and this picked up and well known, because I don't believe it is right
> now.

So I've actually been complaining about the link tags for years: [1]
[2] [3] [4].

In fact, that [4] from 2022 is about how people are then trying to
distinguish the *useful* links (to bug reports) from the useless ones,
by giving them a different name ("Buglink:"). Where I was telling
people to instead fix this problem by just not adding the useless
links in the first place!

Anyway, I'm a bit frustrated, exactly because this _has_ been going on
for years. It's not a new peeve.

And I don't think we have a good central place for that kind of "don't do this".

Yes, there's the maintainer summit, but that's a pretty limited set of people.

I guess I could mention it in my release notes, but I don't know who
actually reads those either..

So I end up just complaining when I see it.

And yeah, I will take some of the blame for people doing the useless
Link. Because going even further back, people were arguing for random
"bug ID" numbers. Go search lkml, and you'll find discussions about
having UUID's in the commits, and I said that no, we're not doing
that, and that a "Link:" tag to something valid is a good alternative,
and I even mentioned a link to the submission. So that could be seen
as some kind of encouragement - but it was more of a "no, we're *NOT*
doing random meaningless UUIDs".

I did go back and look in the git archives. The oldest link we have in
the kernel git tree is from 2011. Guess what? That email has had over
fourteen years to get more information associated with it on the
mailing list, but no.

That link has _zero_ new information that would be relevant outside
the commit that references it (f994d99cf140: "x86-32, fpu: Fix FPU
exception handling on non-SSE systems").

            Linus

Link: https://lore.kernel.org/all/CAHk-=wgfX9nBGE0Ap9GjhOy7Mn=RSy=rx0MvqfYFFDx31KJXqQ@mail.gmail.com/
[1]
Link: https://lore.kernel.org/all/CAHk-=wiUS4r788i5XjTtSwvfvKRm9uH2H5=eLHbZVu3Wo-YHCA@mail.gmail.com/
[2]
Link: https://lore.kernel.org/all/CAHk-=whRBX0aQq1J5S5nHXE2GvXnQ5z+cqu=iTY9xU34kvYMzw@mail.gmail.com/
[3]
Link: https://lore.kernel.org/all/CAHk-=wgzRUT1fBpuz3xcN+YdsX0SxqOzHWRtj0ReHpUBb5TKbA@mail.gmail.com/
[4]
Link: [ .. too lazy to look up more .. ]


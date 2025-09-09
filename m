Return-Path: <io-uring+bounces-9684-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E57EB504C5
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 19:56:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2668B7A8727
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 17:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C92617A300;
	Tue,  9 Sep 2025 17:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gWbRa9QP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F004B31D384;
	Tue,  9 Sep 2025 17:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757440600; cv=none; b=WAD7X0ToR6Umc0qFciIUAYB0+eYiiFxNCTI7QMyTaTidBbx/3+kA2E2cbITq4V0vXffhzqgL8ty1bW2QOe243IqX8EoZz6msy7WzKB9IRhwBEtWBND/ZWlw5d0gnFJTkGNKDsmYOV5W5n/JEeznA0+PbTmZd30TkswO4TekZpU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757440600; c=relaxed/simple;
	bh=Ol+uKe6MO+Z4Uhwd1isDJiAM1ZoehnPeBQlCs5kn2CY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SGwGnMn5NSdk5KocGKEupVW6xhCcbuGDzZkRGfAoOYiJEb3EgQkh3EscjYxZEm7xoHgekLCsrt37mx4RKDB+kJ2nFEhG75luDULQJFR5vJudJGc+T8e+NFjf5iUpF5/qK82gwlq8icmbFfMLG+FfWo1Le2GY6CyYRfGouHWsd+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gWbRa9QP; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-772488c78bcso5790193b3a.1;
        Tue, 09 Sep 2025 10:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757440598; x=1758045398; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qCCZb1yovZxeWDy2yNUvuBROJlg109CH/A8BUPdY4Bo=;
        b=gWbRa9QPCR+mw6wNJvzer9Znsi1xrqiQyFSz9E+jI3swudMgsra+AaEGIgHn9CnqZm
         BzjyMxxc5PX+mGdcUl2vW/VEZRTyecgSuGCEmzYS8+8VIpVA20v70JbG3o4CP3ji2n0E
         1S/QBzgM+C94wYsF+4Uhc+YnFBqht9PEiOTwRDntHUAFpOSfAKx26G1uCagQFAalrFmB
         sfkhZIumJwXwdB3wh7YfHywg3Aob3E7GhD380OzS5e2akFeiadEhzkX9IKrnBhyqQjUR
         SvxSz237xldmQrWhXE7lK/TEdv3+Il/gzkXexl35TSuSH2PnMf2iJaxmqMeTYTl6MWxq
         X7Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757440598; x=1758045398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qCCZb1yovZxeWDy2yNUvuBROJlg109CH/A8BUPdY4Bo=;
        b=OkCyITkT1U4TJSzqWWJKWJlFsESsaNq/INnWPas3HMcnV7WjJgom8fw41FhJ23UIEH
         E2+LpJy6d4fabRK+epjFyzOCY8qtnz7ldkE7m1ncmW9tXSGfQ/SMYTHWyY2vcDDveSpc
         bVnUa789lRK84LbCnmQtabFYEmpNl0oIvleBR0ZckieOOFU0tNurDSx8jhrx/hgJtEvp
         sT5Iz3UL9ouUbzl/an0z583NONjxehSNGnv66Z3yWfrA+HLRrrpGL95X2A7HK2ZX1kZr
         PMGOGlrUiaTcJZnhehiIZ/W+2Yq7Som5VUQbRTVDKEVAe3v6xE9d6F+1to0F5k7FXLT7
         GULw==
X-Forwarded-Encrypted: i=1; AJvYcCX2bHA9TQ+dbpNrhvlKp0KS2RiVS5yx11+bKLCksDtxrreKGL6U6P4h6HTAHnkbcaAF7DTOJ5PrSB93@vger.kernel.org, AJvYcCXEVBgYu8eYEjaB/6/Om5PW0Qe1AJqxFNOG07jtNjAP983FU3/S278O5Y6QwTySLQWUlqFCCyp2Jw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyYPn3iBVPpixP1RVfgj3CmR7xpW0KL6g52nSwYjtggDhVoIFOJ
	c2ZFBLGtWXwGBPKLVq7HVnCD59nWspmqDvKvJ7nhTu1tYyCvixNQUWfT
X-Gm-Gg: ASbGncsqvV2pWnR5tRhrnAY1E1B6maUt9FQFikMgP0PK5l71A0ETrh+gBBR052mrIF3
	Es6P08enzz3j3D30f54sXeSbzZ3NNpSwF7nOy6S/H8bJ3QK3MwVKnVdJFx0dW0eP1JKoWIXS/uR
	1jfPUQ+QsraMWg1aHgI6L2Ce6Ml/g0UbbOsD7zgK5c0wKRuWaKDTTrn3S2y61u3vb6BhpvCRFii
	wWYMXW5SA/+EYWsnxXbPhxKU1e4dLqgOI0DhUNhrJMSgUyA1Tg3r1Olrr/8potR0HucnEl5CqNR
	gv1SgMnkpde6a9TA5l7hY+ZItl9xdMsFSm0gBPjvJFWKC7JmYadBqBDUG9+DiHuhWR9CDjxkCSL
	N4tIjatrkRL0VraSlzwb0IURezJl/UVQ533ufJVbhmQ==
X-Google-Smtp-Source: AGHT+IGNqvhOu/ngQKCsJlPls2q5/T6BagRyNYXrvZ6qTiBs0qvJE4an9yUSV18OhTIWJBOrex/2cw==
X-Received: by 2002:a05:6a00:23d1:b0:770:56bf:ab5a with SMTP id d2e1a72fcca58-7742def592cmr14959182b3a.19.1757440598009;
        Tue, 09 Sep 2025 10:56:38 -0700 (PDT)
Received: from ast-mac ([2620:10d:c090:500::5:bbe5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7746615433asm2735987b3a.38.2025.09.09.10.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 10:56:37 -0700 (PDT)
Date: Tue, 9 Sep 2025 10:56:32 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: dan.j.williams@intel.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@suse.cz>, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>, Jakub Kicinski <kuba@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Caleb Sander Mateos <csander@purestorage.com>, 
	io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <u7jigxix5g3l274ciqkrcvg64fnrqute4vaiwn4tftfzs3cwzv@o4fyr7guogzj>
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
 <5922560.DvuYhMxLoT@rafael.j.wysocki>
 <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>
 <20250909-green-oriole-of-speed-85cd6d@lemur>
 <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz>
 <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
 <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
 <68c062f7725c7_75db100eb@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68c062f7725c7_75db100eb@dwillia2-mobl4.notmuch>

On Tue, Sep 09, 2025 at 10:25:11AM -0700, dan.j.williams@intel.com wrote:
> Linus Torvalds wrote:
> > On Tue, 9 Sept 2025 at 07:50, Jens Axboe <axboe@kernel.dk> wrote:
> > >
> > > I think we all know the answer to that one - it would've been EXACTLY
> > > the same outcome. Not to put words in Linus' mouth, but it's not the
> > > name of the tag that he finds repulsive, it's the very fact that a link
> > > is there and it isn't useful _to him_.
> > 
> [..]
> > Honestly people. Stop with the garbage already, and admit that your
> > links were just worthless noise.
> > 
> > And if you have some workflow that used them, maybe we can really add
> > scripting for those kinds of one-liners.
> > 
> > And maybe lore could even have particular indexing for the data you
> > are interested in if that helps.
> > 
> > In my experience, Konstantin has been very responsive when people have
> > asked for those kinds of things (both b4 and lore).
> 
> Hmm, good point. Lore does have patchid indexing. This needs some more
> cleanup but could replace my usage of patch.msgid.link.
> 
> firefox http://lore.kernel.org/all/?q=patchid%3A$(awk '{ print $1 }' <<< $(git patch-id --stable <<< $(git show $commit)))
> 
> Now, it does drop one useful feature that you know apriori that the
> maintainer did not commit a private version of a patch. However it
> should work in most cases.

It doesn't work reliably. Often enough maintainers massage the patch
a bit while applying to fix minor nits and patch-id will be different.
Here is just one such example:
c11f34e30088 ("bpf: Make update_prog_stats() always_inline")
and the commit includes the lore link to the original patch and
the comment how I tweaked it while applying:
https://lore.kernel.org/all/20250621045501.101187-1-dongml2@chinatelecom.cn/
git patch-id cannot find it:
https://lore.kernel.org/all/?q=patchid%3Afa0565c81e53682a83f4a0e6699c5664c53cda27

Linus's q=$(git rev-parse e9eaca6bf69d^2) trick worked because pr-tracker-bot
replied. That bot is not reliable either. Often enough we mark patches
in patchwork manually, because tracker missed them.

Really, there is no way for automation to detect the connection between
commit that landed in the tree and the original email unless git hooks
add something to the commit. Right now Link tag is that connection.


Return-Path: <io-uring+bounces-9678-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D3550B502DE
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 18:41:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EE941C63347
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 16:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CE35450F2;
	Tue,  9 Sep 2025 16:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GyeFSW18"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9D225C804
	for <io-uring@vger.kernel.org>; Tue,  9 Sep 2025 16:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757436077; cv=none; b=jh17S6PqjFOW/r4zhT7PA16+Wxk64sBctriE2dbEdiesigDP3EUJHgK0ieghqk2HB8/GemkP5N71oIo0mj3sd8IlRzus5/3V/aMn6Es8fXO5iSj3e9Nux8KW7VazhUXNveyW2eMkfFkh6H8vid+0TiyPfxWKRNs03a9n9pANjSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757436077; c=relaxed/simple;
	bh=b+eq1el9WWdjlwuvsxWxsndcwC4nSqXfdm4tqDwKyJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DZoeyskiIpgnUaTAFprwdQ3C7AFUYAnk8pyeDF9bzbYEBSVCDpk5y/LebvHYLfiTV76UPuWPnLlNTGQunD56fIt3wysqNe863YqAVXQI4lXhd/KHPokTobO8ISxovm9/o7Dac6lxGr8bbLs5UVMI8WZpqE1HIeqH+vtQTTrXwVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GyeFSW18; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6228de280a4so6698596a12.2
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 09:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1757436073; x=1758040873; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Zm70ml8cPcpAi6TuvLhkX9BGgRrXTC7qJApIV2KSD8o=;
        b=GyeFSW185PiM80xWagtorpThGojm4h67uZcI4Joi5SOWy9Nelp/9frPzWo9n7IyNzd
         L7sWaQMPGAuBmf64bb9YtLRdt3tyyFCu8YAKwTUpTMMPTHjhjJrV/Aaprn0rZKPpfUbk
         dAZqerwRB+ZO6eznNRiUy/gJ8EOKU4+lA7KG4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757436073; x=1758040873;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zm70ml8cPcpAi6TuvLhkX9BGgRrXTC7qJApIV2KSD8o=;
        b=ozD3HoaaP0simpoGdx4i2ywqftGzGuSSBCw1fEny8V17CY47K592fjIStUzH9wpbhw
         s59bNKfV7xTlAk54CAOZpi1KBpVSte8YtIAfivXVXHSNH3wfzcFdkSk4TyDhkyEqhcjV
         wEgADzZbyhNmZN2Wu4HEKovc9YjrLX/oG5VssWXjRpD7nTo8pG5TvQqtgM4/eSHwtjqK
         SHrj+gqdcFLNGuXVC0eAX9v/G8Lj1DLZhzsNL69yh3HlOHg/FXkFaw14gLMFtyGGd291
         QQbBoVa25wHiHJZKmRowlmYDFCYB5sSGA3wmy/w9rWcuWUxQ9p0cawH3+7ZHQXPFEwh+
         HOmg==
X-Forwarded-Encrypted: i=1; AJvYcCXxO5QoNcOtR5lT1JBvXLOC+8A/ALdGPD058/zHkUHGIwiBmZkVgn6wUCmFYmKVj9WvH54KfxYvaA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYXbdCHmm/dDxkGwnHkUexh6SP6qKkSzQHmVcyM8BonT3FGnI9
	REMbcxmEwSL8Xgk+omsFhm0ApntITHdjdMf1yT1TtWV1P0U5/yaCSo8hj2xbSTQUfzXe1pUOkXf
	GaEVoRSI=
X-Gm-Gg: ASbGncuifMuqxgZ7DECRjCkmy3/XGnPcrnOAtLjIKX5lmANqGOzBylf1Tc6Z3uyarbl
	tJV26eetJpYK5mNfYN4dT40RB0IeUF2fKbDjjJpjHq7FWu8WnUsVPp8fyTlBwJJn+JCG08+rUrA
	MSmQZqJl9ttrOaiZxUo3AxWczenFU725z4zHW4qwhXO5Pxkb192wFFb6bjOnHgklMRxWLKHN25b
	jkAMH7j/iq2EjHSxdaGdd9LRsJFn4Mxwua1r1L8cpJEIstmYO4f+mS3ME6+EHJyZmoJ44xljjh2
	bFLIyjSSqSEeihkdTVFgvoqRs1o5ApBxaMYXUrourRMXRfifsMe8gXJ5YJRt6lg08vPqXuFspHN
	sHUEJLalwcf3lxTwZrK/s5uM1yepEylUx7qskLPIHJhknUZ9ByOJO4frYIjqFvymMgNlzPPpP
X-Google-Smtp-Source: AGHT+IEkcKz9iZkin3Q7bt8e/MC50ZSGz/GfSYOcSUL9s+ileCSjnGQJ5esnkxLbE3Q69bCYQxnlTQ==
X-Received: by 2002:a05:6402:13cf:b0:626:3540:97d8 with SMTP id 4fb4d7f45d1cf-62635409923mr10570992a12.8.1757436072731;
        Tue, 09 Sep 2025 09:41:12 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62bfef6752esm1535526a12.12.2025.09.09.09.41.11
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 09:41:12 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6188b5ae1e8so6940484a12.0
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 09:41:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXTs/cJX2r00fruMPAPkAILN+sifoCQSyYbKCfP976XvSQkzrHoBV60d+ZZyftmTLPMOZKvWS00UQ==@vger.kernel.org
X-Received: by 2002:a17:907:7fa7:b0:b04:7ef0:9dd6 with SMTP id
 a640c23a62f3a-b04b17809fdmr1236710066b.55.1757436071516; Tue, 09 Sep 2025
 09:41:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur> <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
 <5922560.DvuYhMxLoT@rafael.j.wysocki> <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk> <20250909-green-oriole-of-speed-85cd6d@lemur>
 <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz> <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
In-Reply-To: <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Sep 2025 09:40:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
X-Gm-Features: Ac12FXxGb49o3C2-BXyn9vrQLDiODbjBGCOkSNDk7zLDI3tgl6nsApH54f3Udow
Message-ID: <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for 6.17-rc5)
To: Jens Axboe <axboe@kernel.dk>
Cc: Vlastimil Babka <vbabka@suse.cz>, Konstantin Ryabitsev <konstantin@linuxfoundation.org>, 
	Jakub Kicinski <kuba@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, dan.j.williams@intel.com, 
	Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, 
	workflows@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 9 Sept 2025 at 07:50, Jens Axboe <axboe@kernel.dk> wrote:
>
> I think we all know the answer to that one - it would've been EXACTLY
> the same outcome. Not to put words in Linus' mouth, but it's not the
> name of the tag that he finds repulsive, it's the very fact that a link
> is there and it isn't useful _to him_.

It's not that it isn't "useful to me". It's that it HURTS, and it's
entirely redundant.

It literally wastes my time. Yes, I have the option to ignore them,
but then I ignore potentially *good* links.

Rafael asked what the difference between "Fixes:" and "Cc: stable" is
- it's exactly the fact that those do NOT waste human time, and they
were NOT automated garbage.

The rules for those are that they have been added *thoughtfully*: you
don't add 'stable' with automation without even thinking about it, do
you?

And if you did, THAT WOULD BE WRONG TOO.

Wouldn't you agree?

Dammit, is it really so hard to understand this issue? Automated noise
is bad noise. And when it has a human cost, it needs to go away.

I'm not saying that you can't link to the original email. But you need
to STOP THE MINDLESS AUTOMATION WHEN IT HURTS.

So add the link, by all means - but only add it when it is relevant
and gives real information. And THINK about it, don't have it in some
mindless script.

Because if it's in a mindless script, then dammit, the lore "search"
function is objectively better after-the-fact. Really. Using the lore
search gives the original email *and* more.

The same, btw, goes for my merge messages. No, I'm not going to add
some idiotic "Link" to the original pull request email. Not only don't
I fetch those from lore to begin with, you can literally search for
them.

Look here, for the latest merge I did of your tree: e9eaca6bf69d.

Now do this:

    firefox https://lore.kernel.org/all/?q=$(git rev-parse e9eaca6bf69d^2)

and see how *USELESS* and completely redundant a link would have been?
IT'S RIGHT THERE, FOR CHRISSAKE!

That search is guaranteed to find the pull request if it was properly
formatted, because the automation of git request-pull adds all the
relevant data that is actually useful. Very much including that top
commit that you asked me to pull.

THAT information is useful in the email, not only at the time (I can -
and often do - search for it with git ls-remote when people forget to
push or point at the wrong repo, which happens quite regularly), but
look - it is also useful after-the-fact exactly because now you have a
record that you can look for.

If somebody wants to script that one-liner and make it some kind of b4
helper thing, by all means, go wild.

You might want to improve it to use some non-fixed browser (use
"gnome-open" if you're in gnome, or whatever).

But if somebody claims that a link to a pull-request would be
"useful", that somebnody is simply full of sh*t.

It would be the opposite of useful - it's clearly redundant
information that adds zero value, and would be a complete waste of
time.

Honestly people. Stop with the garbage already, and admit that your
links were just worthless noise.

And if you have some workflow that used them, maybe we can really add
scripting for those kinds of one-liners.

And maybe lore could even have particular indexing for the data you
are interested in if that helps.

In my experience, Konstantin has been very responsive when people have
asked for those kinds of things (both b4 and lore).

            Linus


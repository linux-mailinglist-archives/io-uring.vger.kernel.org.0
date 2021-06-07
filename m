Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D98939DC0A
	for <lists+io-uring@lfdr.de>; Mon,  7 Jun 2021 14:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhFGMRj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Jun 2021 08:17:39 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:54898 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhFGMRi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Jun 2021 08:17:38 -0400
Received: by mail-wm1-f46.google.com with SMTP id o127so9881991wmo.4;
        Mon, 07 Jun 2021 05:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=er+/0eWLszGYYMwsZgI+rpkLeZjwFwEwmzNutBl0m7Y=;
        b=aRWfiGRIb9ETdQTibZV0LJqq96hr3Uh8LGnBzOQNSrOxarVWN01zhzSaRLETvey2gh
         gdEUFzL25MUCGTHP/UA1t0JIpjSs+8HExbsYARqeyqpzJ/Y0DfG5OeHUZXWz1JkSYUaY
         r/twHo/62gcYiCCsMubign3XYAJEbw1eIjrbrQpZvB3R83v05EtlEIu0TS6BJzpeo80L
         +GENWeLa8N/Rmzl3qP17WBY3p0J3sD9TOV/BOP0THIB2Yy2MVzgWXQFQdAsr7HawAwBV
         8HPnNWNpy3FPTFVfF1fPSShphPPfMFZbi3GYnN6zjQcyOFOllldMIOv9ppvtnvXl6FA5
         roYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=er+/0eWLszGYYMwsZgI+rpkLeZjwFwEwmzNutBl0m7Y=;
        b=bTMtYXUAqrXv7wyI8CZeycEYqsZDkIbqY+YTwsJn+uXba0kZPmSznOb2jtsB3JAOk7
         Fom8P+iFgaB8cZCDDMY32p90aLC4Cwk3NE8fkUQb1CZWTCeHk3givTMgVCTJ91n8XUD2
         p2bk+CB1Lab3/bisd29fLFrdu3g1Q8YuKQAiCXoVkJlHzJF4noLcpxmKEdf+3UwQ9qK4
         8L1PfGcj5un2/b6bRdsS+/F+hGWZ5Y8w4CDP13wCI+ZNhQcXV3jsUDbeUcF655ecE/Og
         kJnAfbutD7B2aH/Jjza7vyVEPSJiBeMl6bBX6BS0mV2Jxb3A67rxfNUos0+Rs//jc3WB
         gv/A==
X-Gm-Message-State: AOAM5303o2WBdt5EigubKiGNfSFdWfEFIrZkQ17pAROOUJ0+SBYjqBjW
        v/1RXoF0qAmz0VRJ+UBSBAs=
X-Google-Smtp-Source: ABdhPJwcJbUALjuATNQJTnUaFTkwf0QXvPXqX3wLagIblxgY2ENJMfIlwyYCVz2rM6cLwv7iNY705A==
X-Received: by 2002:a1c:1bd8:: with SMTP id b207mr16070799wmb.80.1623068072985;
        Mon, 07 Jun 2021 05:14:32 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c092:600::2:457c])
        by smtp.gmail.com with ESMTPSA id f12sm115966wru.81.2021.06.07.05.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 05:14:32 -0700 (PDT)
To:     Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     Andres Freund <andres@anarazel.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>
References: <cover.1622558659.git.asml.silence@gmail.com>
 <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com>
 <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk>
 <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com>
 <bdc55fcd-b172-def4-4788-8bf808ccf6d6@kernel.dk>
 <5ab4c8bd-3e82-e87b-1ae8-3b32ced72009@gmail.com>
 <87sg211ccj.ffs@nanos.tec.linutronix.de>
 <30bdf12c-6287-4c13-920c-bb5cc6ac02bf@gmail.com>
 <87k0nayojy.ffs@nanos.tec.linutronix.de>
 <aba00834-2e1c-f8cf-e2ab-f13303eac562@gmail.com>
 <87pmx1yse9.ffs@nanos.tec.linutronix.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC 4/4] io_uring: implement futex wait
Message-ID: <2dbcf0b1-9cd9-1edc-08dc-5e758c68c0a3@gmail.com>
Date:   Mon, 7 Jun 2021 13:14:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87pmx1yse9.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/5/21 3:09 AM, Thomas Gleixner wrote:
[...]
> Here is _all_ the information you provided:
> 
>  0) Cover letter:
> 
>    > Proof of concept for io_uring futex requests. The wake side does
>    > FUTEX_WAKE_OP type of modify-compare operation but with a single
>    > address. Wait reqs go through io-wq and so slow path.
> 
>   Describes WHAT it is supposed to do, but not at all WHY.
> 
>    Plus it describes it in terms which are maybe understandable for
>    io-uring aware people, but certainly not for the general audience.

I actually agree with that and going to add it once I get details
I needed.

>    > Should be interesting for a bunch of people, so we should first outline
>    > API and capabilities it should give.
> 
>   You post patches which _should_ be interesting for a unspecified bunch
>   of people, but you have no idea what the API and capabilities should
>   be?

That's word carping. Some of the cases were known, but was more
interested atm in others I heard only a brief idea about, that's
why that person was CC'ed.

>   IOW, this follows the design principle of: Throw stuff at the wall and
>   see what sticks?

Exactly what it is *not*. Emails were chosen to clarify details,
nobody tells it wouldn't be reworked and adjusted. Do you imply
I should discuss ideas privately?

>   But at the same time you want feedback from the people responsible for
>   the subsystems you are modifying without providing the required
>   information and worse:
> 
>    > As I almost never had to deal with futexes myself, would especially
>    > love to hear use case, what might be lacking and other blind spots.
> 
>   So you came up with a solution with no use case and expect the futex
>   people or whoever to figure out what you actually want to solve?

Again, not true. Where did you get that?

> 
[...]
> Now let me quote Documentation/process/submitting-patches.rst:
> 
>   "Describe your problem.  Whether your patch is a one-line bug fix or
>    5000 lines of a new feature, there must be an underlying problem that
>    motivated you to do this work.  Convince the reviewer that there is a
>    problem worth fixing and that it makes sense for them to read past the
>    first paragraph."
> 
> Can you seriously point me to a single sentence in the above verbatim
> quotes from your cover letter and changelogs which complies with that rule?
> 
> It does not matter whether this is RFC or not. You simply ignore well
> documented rules and then you get upset because I told you so:
> 
>  > 1) The proposed solution: I can't figure out from the changelogs or the
>  >    cover letter what kind of problems it solves and what the exact
>  >    semantics are. If you ever consider to submit futex patches, may I
>  >    recommend to study Documentation/process and get some inspiration
>  >    from git-log?
> 
> And what's worse, you get impertinent about it:

Impertinent? Was just keeping up with your nice way of conveying
ideas. FWIW, it's not in particularly related to this small chunk
above at all.

>  > I'm sorry you're incapable of grasping ideas quick
> 
> Sure. I'm incompetent and stupid just because I can't figure out your
> brilliant ideas which are so well described - let me quote again:

That's your own interpretation, can't help you with that

[...]
> What's galling about that?
> 
>   - You wasted _my_ time by _not_ providing the information which I need
>     to digest your submission.
> 
>   - I went way beyond what Documentation/process/ says and read past the
>     first paragraph of useless information.
> 
>   - I provided you a detailed technical feedback nevertheless
> 
> And as a result you attack me at a non-technical level. So where exactly
> is the "we" and who started galling?

If you think it was an attack, your response might have been interpreted
in a such way as well, even though it haven't by me. There are enough of
weird phrases and implications in your reply, but I have no intention
of going through it and picking up on every phrase, would be useless

>> Exactly why there was "we". I have my share of annoyance, which I would
>> readily put aside if that saves me time.
> 
> I grant you to be annoyed as much as you want. But you are getting
> something fundamentaly wrong:
> 
>   "which I would readily put aside if that saves me time."
> 
> As I told you above: You have been already wasting _my_ time by not
> providing the information which is required to actually look at what you
> propose.
> 
>> Exactly why there was "we". I have my share of annoyance, which I would
>> readily put aside if that saves me time. And that's the suggestion
>> made
> 
> In my first reply I made that a recommendation, so let me rephrease
> that:
> 
>      Read and comply to Documentation/process!
> 
> It does not matter at all how brilliant the idea you have is and how
> stupid the reviewer at the other end might be. There are still rules to
> follow and they apply to the most brilliant people on the planet.
> 
> So, as I told you before: Try again.

-- 
Pavel Begunkov

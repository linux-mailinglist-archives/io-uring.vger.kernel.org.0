Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DDF39C4F3
	for <lists+io-uring@lfdr.de>; Sat,  5 Jun 2021 04:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhFECKz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Jun 2021 22:10:55 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56792 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhFECKy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Jun 2021 22:10:54 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622858942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NClVxu9bfsssulEGazSA14TvuzCR8/UTXfkXeENBUEo=;
        b=cZAk4NSraBwgBTpgy4ENYL7UOFTWOqs8SFYbAuTO4j+XM6PGZNbMgk5TvdsJklaMNyCikT
        oZFUHstv28XFoXLmoS180HKsa8YMTT0FTDlBoI6oEcNZQ+JYlPvbNEQDMPiIeRrmnuYxex
        EPjSEiFOfBz3hF0EjdjdKBBeh3PTuFpuwNfb5L9FVAwfpt0Nu2v3VPuy7gHImU76fAko52
        vrmfQCcaIWCNf+Cwge0qOb1xxB7iJPxRYHHKI5kx2YzhptTnzdBjGh5P/FEVilj9qDTh+B
        2Vu6BWTrLQKuUynt2cQxm1uG1zjWHspSgd0jUp+YQcqr3GnzcQOTIH1Hlc5L9Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622858942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NClVxu9bfsssulEGazSA14TvuzCR8/UTXfkXeENBUEo=;
        b=1P6cP8BRtFNXi888tuM3YVKsxpwr3uXouEF1NVOISN1wbKkPQC4Yx/p2v4ok8Z/ktj6uQx
        RTOMZWzQUm1GtlBw==
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Andres Freund <andres@anarazel.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: [RFC 4/4] io_uring: implement futex wait
In-Reply-To: <aba00834-2e1c-f8cf-e2ab-f13303eac562@gmail.com>
References: <cover.1622558659.git.asml.silence@gmail.com> <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com> <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk> <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com> <bdc55fcd-b172-def4-4788-8bf808ccf6d6@kernel.dk> <5ab4c8bd-3e82-e87b-1ae8-3b32ced72009@gmail.com> <87sg211ccj.ffs@nanos.tec.linutronix.de> <30bdf12c-6287-4c13-920c-bb5cc6ac02bf@gmail.com> <87k0nayojy.ffs@nanos.tec.linutronix.de> <aba00834-2e1c-f8cf-e2ab-f13303eac562@gmail.com>
Date:   Sat, 05 Jun 2021 04:09:02 +0200
Message-ID: <87pmx1yse9.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel!

On Fri, Jun 04 2021 at 12:58, Pavel Begunkov wrote:
> On 6/4/21 10:19 AM, Thomas Gleixner wrote:
>> On Thu, Jun 03 2021 at 11:31, Pavel Begunkov wrote:
>>> On 6/1/21 10:53 PM, Thomas Gleixner wrote:
>>>> 1) The proposed solution: I can't figure out from the changelogs or the
>>>>    cover letter what kind of problems it solves and what the exact
>>>>    semantics are. If you ever consider to submit futex patches, may I
>>>>    recommend to study Documentation/process and get some inspiration
>>>>    from git-log?
>>>
>>> I'm sorry you're incapable of grasping ideas quick, but may we
>>> stop this stupid galling and switch to a more productive way of
>>> speaking?
>> 
>> which you just achieved by telling me I'm too stupid to understand your
>> brilliant idea. Great start for a productive discussion. Try again.
>
> Exactly why there was "we". I have my share of annoyance, which I would
> readily put aside if that saves me time. And that's the suggestion
> made

"We"?

Here is _all_ the information you provided:

 0) Cover letter:

   > Proof of concept for io_uring futex requests. The wake side does
   > FUTEX_WAKE_OP type of modify-compare operation but with a single
   > address. Wait reqs go through io-wq and so slow path.

  Describes WHAT it is supposed to do, but not at all WHY.

   Plus it describes it in terms which are maybe understandable for
   io-uring aware people, but certainly not for the general audience.
  
   > Should be interesting for a bunch of people, so we should first outline
   > API and capabilities it should give.

  You post patches which _should_ be interesting for a unspecified bunch
  of people, but you have no idea what the API and capabilities should
  be?

  IOW, this follows the design principle of: Throw stuff at the wall and
  see what sticks?

  But at the same time you want feedback from the people responsible for
  the subsystems you are modifying without providing the required
  information and worse:

   > As I almost never had to deal with futexes myself, would especially
   > love to hear use case, what might be lacking and other blind spots.

  So you came up with a solution with no use case and expect the futex
  people or whoever to figure out what you actually want to solve?

 1) futex: add op wake for a single key

   > Add a new futex wake function futex_wake_op_single(), which works
   > similar to futex_wake_op() but only for a single futex address as it
   > takes too many arguments. Also export it and other functions that will
   > be used by io_uring.

  Tells WHAT the patch is doing but not WHY. And "as it takes too many
  arguments" really does not qualify in case that you think so.

 2) io_uring: frame out futex op

   > Add userspace futex request definitions and draft some internal
   > functions.

  Tells WHAT the patch is doing but not WHY.

 3) io_uring: support futex wake requests

   > Add support for futex wake requests, which also modifies the addr and
   > checks against it with encoded operation as FUTEX_WAKE_OP does, but only
   > operates with a single address as may be problematic to squeeze into SQE
   > and io_kiocb otherwise.

  Tells WHAT the patch is doing but not WHY. And of course "may be" is a
  really conclusive technical argument to make.

 4) io_uring: implement futex wait

   > Add futex wait requests, those always go through io-wq for simplicity.

  Tells WHAT the patch is doing but not WHY. Of course the 'for
  simplicity' aspect is not argued because it's obvious for anyone
  except stupid me.

Now let me quote Documentation/process/submitting-patches.rst:

  "Describe your problem.  Whether your patch is a one-line bug fix or
   5000 lines of a new feature, there must be an underlying problem that
   motivated you to do this work.  Convince the reviewer that there is a
   problem worth fixing and that it makes sense for them to read past the
   first paragraph."

Can you seriously point me to a single sentence in the above verbatim
quotes from your cover letter and changelogs which complies with that rule?

It does not matter whether this is RFC or not. You simply ignore well
documented rules and then you get upset because I told you so:

 > 1) The proposed solution: I can't figure out from the changelogs or the
 >    cover letter what kind of problems it solves and what the exact
 >    semantics are. If you ever consider to submit futex patches, may I
 >    recommend to study Documentation/process and get some inspiration
 >    from git-log?

And what's worse, you get impertinent about it:

 > I'm sorry you're incapable of grasping ideas quick

Sure. I'm incompetent and stupid just because I can't figure out your
brilliant ideas which are so well described - let me quote again:

   > Should be interesting for a bunch of people, so we should first outline
   > API and capabilities it should give.
   >
   > As I almost never had to deal with futexes myself, would especially
   > love to hear use case, what might be lacking and other blind spots.

and then you chose to tell me:

 > > Exactly why there was "we". I have my share of annoyance, which I
 > > would readily put aside if that saves me time. And that's the
 > > suggestion made.

Let me digest that. Your full response was:

   > I'm sorry you're incapable of grasping ideas quick, but may we stop
   > this stupid galling and switch to a more productive way of speaking?

Fact is that I told you that neither your cover letter nor your changelogs
give any clue (see above) and therefore violate the well documented patch
submission rules.

What's galling about that?

  - You wasted _my_ time by _not_ providing the information which I need
    to digest your submission.

  - I went way beyond what Documentation/process/ says and read past the
    first paragraph of useless information.

  - I provided you a detailed technical feedback nevertheless

And as a result you attack me at a non-technical level. So where exactly
is the "we" and who started galling?

> Exactly why there was "we". I have my share of annoyance, which I would
> readily put aside if that saves me time.

I grant you to be annoyed as much as you want. But you are getting
something fundamentaly wrong:

  "which I would readily put aside if that saves me time."

As I told you above: You have been already wasting _my_ time by not
providing the information which is required to actually look at what you
propose.

> Exactly why there was "we". I have my share of annoyance, which I would
> readily put aside if that saves me time. And that's the suggestion
> made

In my first reply I made that a recommendation, so let me rephrease
that:

     Read and comply to Documentation/process!

It does not matter at all how brilliant the idea you have is and how
stupid the reviewer at the other end might be. There are still rules to
follow and they apply to the most brilliant people on the planet.

So, as I told you before: Try again.

Yours sincerely,

	Thomas

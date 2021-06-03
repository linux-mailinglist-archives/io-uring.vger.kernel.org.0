Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C55A39AA98
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 20:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhFCTBc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 15:01:32 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40191 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229576AbhFCTBc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 15:01:32 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D174E5C0056;
        Thu,  3 Jun 2021 14:59:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 03 Jun 2021 14:59:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to:from; s=fm1; bh=1HhH0nGpEofBMD6mVIRlFI
        +fgZCZWFL3gEjf84ZKlKM=; b=PLxp/ZK6P3puogga2z7T88SLMK5XAGmBoxfAA2
        ZNrIRVwMmNxtc6MitszLU8BZwc/lTgqWGFKeT1/VSkQOV1Tw5DY7EhnHo1axTeSb
        FTBVDF6rnhFOuj4JRIJAXXiFN2tYYekodHgLqRFH0xHEL5Kvyjw3zmxT4i4W5ZsE
        CnNm6XEAi9Kge7xD11VOKwml6iu1YQrdXovgvaXNSBXECBsZCK2QjiOVH/s/jPPJ
        /EBbmgBhtj+VYRMzPf15wzGOvO6srjVTLDL2oOhiXY306OnaIdBLE8Rew10Qs+Mu
        gWDvwVBVNok5Ow5v37Ta1uouvWN44ZpPFX3677NUoWjTBgkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1HhH0n
        GpEofBMD6mVIRlFI+fgZCZWFL3gEjf84ZKlKM=; b=BXECjmeyA/5BTs5G79EV9E
        Afkp2S/ZaD415CyImVnr7P69xjykxGDXNTakYKrLWFbrBKO22xtaZDTiNBwLQaLx
        SkuBje6TmI3H/G30Muxr4+OOcKVj4mf/IHJkMZlsV8Xm5Lz9x+ie2NtSTZ9DrPet
        hQ5nyDtS8felCLpl0ryC81TIWnTwHpM67AVgWOpifNAGIYjQG+5w+Q9xgBSntnYQ
        iA3UbsCi8Ali0U4MRFxh1vtyITmrAgIZplX5CHFzZqj9k8LDJwKoHBHkjgiennQX
        hpqHnS8jwq+yCcbqdGVm7CXbc9H6m82VZ5LyevS8Y0xKKFEP6C9Pm5njNAPPewBw
        ==
X-ME-Sender: <xms:oSa5YHnCSU-QEoW89XaSjt5bgWMA7D6-z2OgEVxWteGLmBPpE-plcQ>
    <xme:oSa5YK2fooSex2kXuCNK3UJ2kUh1VgqLtzBFKNnzrGwUoN0SmMPcKTBpg4XxYZ2Lg
    PMn8JQ8zLr-qtb8Zw>
X-ME-Received: <xmr:oSa5YNrCj8VuBfwKvWVXwvFI-BBxDJ3qigC6DFL9jiWtQDtwnakNUmOEl_KW8txpE7rhERiS3H4ftmplcEljPXM44zPzYo9_irS9Iu_vzC79A14EBpmAV7fnCdTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdelledgudeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffvffukfhfgggtuggjhfesthdtredttddtvdenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrf
    grthhtvghrnhepkeelheeguedvhfffgeegkefgteeuueelffdvvddtieevgeejkeejgfek
    teevvddtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:oSa5YPk-ITmcGc24u3SDOFRTFFMtH2eGDe6GmYyOsGCpWSGeL4G94Q>
    <xmx:oSa5YF1Ki2lP1aBaeqsV98ph8hv6nNCQWpDXGZ8AS4mGn7UdW05fVQ>
    <xmx:oSa5YOvTwMmOZYhXynmh4FAQsgi7JmCc7bgD_phxfQGMfjR0ulAwZw>
    <xmx:oia5YClvVx8vg0zpbZUqm_uyxHlfq54lSHHTZpd7rh9Cssgzh98Weg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Jun 2021 14:59:45 -0400 (EDT)
Date:   Thu, 3 Jun 2021 11:59:43 -0700
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/4] futex request support
Message-ID: <20210603185943.eeav4sfkrxyuhytp@alap3.anarazel.de>
CFrom:  Andres Freund <andres@anarazel.de>
References: <cover.1622558659.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1622558659.git.asml.silence@gmail.com>
From:   Andres Freund <andres@anarazel.de>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2021-06-01 15:58:25 +0100, Pavel Begunkov wrote:
> Should be interesting for a bunch of people, so we should first
> outline API and capabilities it should give. As I almost never
> had to deal with futexes myself, would especially love to hear
> use case, what might be lacking and other blind spots.

I did chat with Jens about how useful futex support would be in io_uring, so I
should outline our / my needs. I'm off work this week though, so I don't think
I'll have much time to experiment.

For postgres's AIO support (which I am working on) there are two, largely
independent, use-cases for desiring futex support in io_uring.

The first is the ability to wait for locks (queued r/w locks, blocking
implemented via futexes) and IO at the same time, within one task. Quickly and
efficiently processing IO completions can improve whole-system latency and
throughput substantially in some cases (journalling, indexes and other
high-contention areas - which often have a low queue depth). This is true
*especially* when there also is lock contention, which tends to make efficient
IO scheduling harder.

The second use case is the ability to efficiently wait in several tasks for
one IO to be processed. The prototypical example here is group commit/journal
flush, where each task can only continue once the journal flush has
completed. Typically one of waiters has to do a small amount of work with the
completion (updating a few shared memory variables) before the other waiters
can be released. It is hard to implement this efficiently and race-free with
io_uring right now without adding locking around *waiting* on the completion
side (instead of just consumption of completions). One cannot just wait on the
io_uring, because of a) the obvious race that another process could reap all
completions between check and wait b) there is no good way to wake up other
waiters once the userspace portion of IO completion is through.


All answers for postgres:

> 1) Do we need PI?

Not right now.

Not related to io_uring: I do wish there were a lower overhead (and lower
guarantees) version of PI futexes. Not for correctness reasons, but
performance. Granting the waiter's timeslice to the lock holder would improve
common contention scenarios with more runnable tasks than cores.


> 2) Do we need requeue? Anything else?

I can see requeue being useful, but I haven't thought it through fully.

Do the wake/wait ops as you have them right now support bitsets?


> 3) How hot waits are? May be done fully async avoiding io-wq, but
> apparently requires more changes in futex code.

The waits can be quite hot, most prominently on low latency storage, but not
just.

Greetings,

Andres Freund

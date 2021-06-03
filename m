Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369E939ACAD
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 23:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhFCVX1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 17:23:27 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56227 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229790AbhFCVX0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 17:23:26 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 4F1695C0071;
        Thu,  3 Jun 2021 17:21:41 -0400 (EDT)
Received: from imap35 ([10.202.2.85])
  by compute5.internal (MEProxy); Thu, 03 Jun 2021 17:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm1; bh=XwJZ1Qrwq2Ad70llPp988Nl7IcepFjp
        HsXsYGbVQhTE=; b=RispqkflI17cuT2skjfNAsoQ5+z+Jh/6D6UPAxAeSWeDToD
        WBzRUkU/TJeoSf3oxUDbjsDEZd0Fr0gDRoClKNyC7rm16r3BVb4PFvjiEzK0t4fj
        nVAIMl969LXgJfpgV97JkJSoKKW7SUpcAlz4UV/X9PJu8VBQBOqiLWdmfGxDUW3s
        5W3E5EdMLDRlj+gEiwHLF7J0nBIoCUJb+D1NWafySpM/84P52Stl8tVnL4FscsEH
        dFQAaGniPCvYlGuJLJBelHkG3rBuNKiJ3QPOOydyWtpx2UhkTPzxgsudD8+k0C+K
        zUTVVtRrM8sbG0/JXVQh1tloylbso0gFJXndRVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=XwJZ1Q
        rwq2Ad70llPp988Nl7IcepFjpHsXsYGbVQhTE=; b=HzWH1FMZNnpImdXet+H2uK
        HC8G5Bn4rHH7M9sEDyrdn/mE4VHSYXQncoklSpUyj4Bal0jrohSrPefk5dhG5VgM
        3EcQjceahs1ba+hLtp8xfqF3dYbUu14Yvm+kRJ9Inf2GDyb90ApCZP239oZ66cqx
        i846GIO8rY0Uunrpr9qdK5D6e5mVuZgK9GBzqOflZEXhtuViMmH+FvUjILzT8Di4
        XieaKCutVtM5cPQhC+qXCp7vLNjOIZotjJDYxlsyUhnRWulTHbC8MTo8ObaDYIeX
        tr33Us8BDEFSbBxmjc7aG+k5eC2KqHbEkoqZHVK74xxLIemFn590RUvLkg7UVkQA
        ==
X-ME-Sender: <xms:5Ee5YJTnoky7AfIPOX8rsqu85wVXkmGP90DuDeG65wMJB9GZGupb9A>
    <xme:5Ee5YCyu0Rnei5jo6sP6RsPPz9fy9HXemuvW3iQrmMozLBrYzku87Z2QEFEpv4eN8
    oEB6d2LGC1oFNceeg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdelledgudehlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedftehn
    ughrvghsucfhrhgvuhhnugdfuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenuc
    ggtffrrghtthgvrhhnpeetgedvvdffgefhjeetveetveefgeffudduffegtdeujedvjeel
    gfevgedukeefvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:5Ee5YO0IsxAUYEcsXe971KrAflvrzAZf6Rp-03zyi7dRBlUERynIJw>
    <xmx:5Ee5YBAnn_scYI3bCJvOR8unraRiTNjPNsbYjIcgBz0VCrEuGmW7Sw>
    <xmx:5Ee5YCjG3z4mnA3xmFBRagXImGrcHqcTqjRKjRb9AL0KrWKW5TRjBA>
    <xmx:5Ue5YNVZqdVsdnr-biDDLMnWhXFugIpAmnalCb8bvceuNiMb6q3BTw>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 34FC115A005F; Thu,  3 Jun 2021 17:21:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-519-g27a961944e-fm-20210531.001-g27a96194
Mime-Version: 1.0
Message-Id: <16ead1e9-f07f-4a13-a066-122eca998d74@www.fastmail.com>
In-Reply-To: <20210603211012.GA68208@worktop.programming.kicks-ass.net>
References: <cover.1622558659.git.asml.silence@gmail.com>
 <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com>
 <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk>
 <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com>
 <bdc55fcd-b172-def4-4788-8bf808ccf6d6@kernel.dk>
 <5ab4c8bd-3e82-e87b-1ae8-3b32ced72009@gmail.com>
 <87sg211ccj.ffs@nanos.tec.linutronix.de>
 <20210603190338.gfykgkc7ac2akvdt@alap3.anarazel.de>
 <20210603211012.GA68208@worktop.programming.kicks-ass.net>
Date:   Thu, 03 Jun 2021 14:21:15 -0700
From:   "Andres Freund" <andres@anarazel.de>
To:     "Peter Zijlstra" <peterz@infradead.org>
Cc:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Pavel Begunkov" <asml.silence@gmail.com>,
        "Jens Axboe" <axboe@kernel.dk>, io-uring@vger.kernel.org,
        "Ingo Molnar" <mingo@redhat.com>,
        "Darren Hart" <dvhart@infradead.org>,
        "Davidlohr Bueso" <dave@stgolabs.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/4] io_uring: implement futex wait
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On Thu, Jun 3, 2021, at 14:10, Peter Zijlstra wrote:
> On Thu, Jun 03, 2021 at 12:03:38PM -0700, Andres Freund wrote:
> > On 2021-06-01 23:53:00 +0200, Thomas Gleixner wrote:
> > > You surely made your point that this is well thought out.
> > 
> > Really impressed with your effort to generously interpret the first
> > version of a proof of concept patch that explicitly was aimed at getting
> > feedback on the basic design and the different use cases.
> 
> You *completely* failed to describe any. I'm with tglx; I see no reason
> to even look at the patches. If you don't have a problem, you don't need
> a solution.

Note that this is not my patch, and I hadn't posted anything on the thread when Thomas sent that email? So I'm not sure what you're even referring to here as me having failed to do. If you think the explanation of my use cases I have since sent is insufficient, I'm happy to reply to that/expand on them, but you're going to have to be a bit more specific on why I "failed to describe any".

I just don't see why a simple "what's the use case" wouldn't be a lot more productive than this posturing. Particularly on a thread that is explicitly inviting people from outside the core kernel dev community to chime in.

Andres

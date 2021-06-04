Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F255439B5C5
	for <lists+io-uring@lfdr.de>; Fri,  4 Jun 2021 11:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFDJVe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Jun 2021 05:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFDJVe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Jun 2021 05:21:34 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5D2C06174A;
        Fri,  4 Jun 2021 02:19:48 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622798386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UtZCCmwycy6zhYy7Z1u7SlZ7V50PFpLJ9AuA4SdG6YE=;
        b=mnPcHI5f3lYt7eODmN54Nt743KJtMe51b501m9QbBMqcMZYBho3qajnRrtQEaqPUReZBt2
        xPKz/XGzbccE5J2VN4EMCpurJ64sdaD750lVduPCnBn8fP/4GZz+TRM330Ff2IPXGAw349
        qjtdDqwb9cloJ/CNfLl7bd4ljMfGvEEeQlr6VPl3bQb24tI5wmUCJ6/Zx4X82qvjvHBSXh
        LxTQtdt9j3ZQBJEvcPsu40O62UHadFPTGzKQU/VDMz+ws0q1oXcxDWmgY65eiFM+MxhlHU
        M7aBBjXDEo0p+rLtn07og/qHjteGdzm4P07yqL/8seqLOnNWheqO0oIikDnk0A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622798386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UtZCCmwycy6zhYy7Z1u7SlZ7V50PFpLJ9AuA4SdG6YE=;
        b=IzwhihPN78AE84ioOW2GQN4zHDHoe6x4yK3rHEd3XfITdUz8MbGRnZYJHf/v6ffgBAidxP
        jR997ibukS3AzmAg==
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Andres Freund <andres@anarazel.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/4] io_uring: implement futex wait
In-Reply-To: <30bdf12c-6287-4c13-920c-bb5cc6ac02bf@gmail.com>
References: <cover.1622558659.git.asml.silence@gmail.com> <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com> <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk> <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com> <bdc55fcd-b172-def4-4788-8bf808ccf6d6@kernel.dk> <5ab4c8bd-3e82-e87b-1ae8-3b32ced72009@gmail.com> <87sg211ccj.ffs@nanos.tec.linutronix.de> <30bdf12c-6287-4c13-920c-bb5cc6ac02bf@gmail.com>
Date:   Fri, 04 Jun 2021 11:19:45 +0200
Message-ID: <87k0nayojy.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel,

On Thu, Jun 03 2021 at 11:31, Pavel Begunkov wrote:
> On 6/1/21 10:53 PM, Thomas Gleixner wrote:
>> 1) The proposed solution: I can't figure out from the changelogs or the
>>    cover letter what kind of problems it solves and what the exact
>>    semantics are. If you ever consider to submit futex patches, may I
>>    recommend to study Documentation/process and get some inspiration
>>    from git-log?
>
> I'm sorry you're incapable of grasping ideas quick, but may we
> stop this stupid galling and switch to a more productive way of
> speaking?

which you just achieved by telling me I'm too stupid to understand your
brilliant idea. Great start for a productive discussion. Try again.

Thanks,

        tglx



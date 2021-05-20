Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B5D38AE01
	for <lists+io-uring@lfdr.de>; Thu, 20 May 2021 14:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhETMW2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 May 2021 08:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbhETMWQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 May 2021 08:22:16 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1171C043275
        for <io-uring@vger.kernel.org>; Thu, 20 May 2021 04:14:39 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id x8so17216946wrq.9
        for <io-uring@vger.kernel.org>; Thu, 20 May 2021 04:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4Cgl1A15rwsXyJ5aeTEeUrWrOH/VXSW7hEVC/gmh8DQ=;
        b=OmsNNNeixeyUHALXTubMGMH4V56blJJKIZ+YGJL9SiWz0uUX8gyKXRoMQ/k6RUkyKA
         aH6n8tpa21vBtR4pksNoG1HehLvtbP1hKiCdertfEJc7XnrO6MrS/YdEaQFkVg9MQBjB
         Wi3kWJGOwJavaXcQfv/rNDDwMK4UZwiJXSQE30/Sc58ii5fB0WAouYwlXyes6UFborKh
         TMIBmobJrLyCzCq3Oyy+sWDqKqsNps+XYmrMHrbxpmpY795Omhvl6B97XkfERhZyWkDi
         qpjItVyvHYapqqxVo05/0N7kUsqc8QZRRQcunPIBU/5hrNDSFas0Vd7A5qJjGmOhiV0U
         i9Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Cgl1A15rwsXyJ5aeTEeUrWrOH/VXSW7hEVC/gmh8DQ=;
        b=ULVlzeNdZ+7AkzKPu0qOREplNf9dysRMgTc6ABQAf7DASuAE9CMn7Vh4Lr3Anjvgib
         nQIR7v1CQiJwNJxm78sB/CsNDK225T9Gvb9ZFzZ+Xv+L3yTdjSa55JEz9c+S+wKtKrJV
         p0Gz0fLdIrpWOH8aw3sh3UrbY2A0g+tvW/ihZh0l9QdUUKZGDUxrO4+a5kJd5ucwZuFq
         8aeL89sF2wddPWaRzeAndJ+sNAdYf0flFa23YkIeUsfD6Bt5vDMeXtFTuaZC65aBjwxw
         rDHGesiq0j8Nu/xMuclP62U1XMLufBl9XjFbUsCQaSjUkQoGt2Jh6idE3vbQo94LIFAF
         1hFA==
X-Gm-Message-State: AOAM533yofh4t/TYM/+pAegkHKERQTBkf8D428ku+tnI+q33uZ7WORVJ
        R2x8enU3XlhhHtBih+oW9Mc=
X-Google-Smtp-Source: ABdhPJzN/qjfkMjHaz6mx/GtEAcLBCwHAbXHHhfVIr6mEcPen+PpzDMhF7EiJk55MDoD/Wemj9XMaw==
X-Received: by 2002:a5d:524b:: with SMTP id k11mr3771380wrc.292.1621509278376;
        Thu, 20 May 2021 04:14:38 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2810? ([2620:10d:c093:600::2:130f])
        by smtp.gmail.com with ESMTPSA id z3sm2844768wrq.42.2021.05.20.04.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 04:14:37 -0700 (PDT)
To:     Christian Dietrich <stettberger@dokucode.de>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
References: <s7bsg4slmn3.fsf@dokucode.de>
 <9b3a8815-9a47-7895-0f4d-820609c15e9b@gmail.com>
 <s7btuo6wi7l.fsf@dokucode.de>
 <4a553a51-50ff-e986-acf0-da9e266d97cd@gmail.com>
 <s7bmttssyl4.fsf@dokucode.de>
 <f1e5d6cf-08a9-9110-071f-e89b09837e37@gmail.com>
 <s7bv985te4l.fsf@dokucode.de>
 <46229c8c-7e9d-9232-1e97-d1716dfc3056@gmail.com>
 <s7bpmy5pcc3.fsf@dokucode.de> <s7bbl9pp39g.fsf@dokucode.de>
 <c45d633e-1278-1dcb-0d59-f0886abc3e60@gmail.com>
 <s7beeec8ah0.fsf@dokucode.de>
 <fd68fd2d-3816-e326-8016-b9d5c5c429ed@gmail.com>
 <s7bv97ey87m.fsf@dokucode.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC] Programming model for io_uring + eBPF
Message-ID: <0468c1d5-9d0a-f8c0-618c-4a40b4677099@gmail.com>
Date:   Thu, 20 May 2021 12:14:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <s7bv97ey87m.fsf@dokucode.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/19/21 5:55 PM, Christian Dietrich wrote:
> Pavel Begunkov <asml.silence@gmail.com> [18. May 2021]:
> 
>>> If we extend the semantic of IOSEQ_IO_LINK instead of introducing a new
>>> flag, we should be able to limit the problem, or?
>>>
>>> - With synchronize_group=0, the usual link-the-next SQE semantic could
>>>   remain.
>>> - While synchronize_group!=0 could expose the described synchronization
>>>   semantic.
>>>
>>> Thereby, the overhead is at least hidden behind the existing check for
>>> IOSEQ_IO_LINK, which is there anyway. Do you consider IOSQE_IO_LINK=1
>>> part of the hot path?
>>
>> Let's clarify in case I misunderstood you. In a snippet below, should
>> it serialise execution of sqe1 and sqe2, so they don't run
>> concurrently?
> 
> ,----
> | > prep_sqe1(group=1);
> | > submit();
> | > prep_sqe2(group=1);
> | > submit();
> `----
> 
> Yes, in this snippet both SQEs should serialize. However, in this case,
> as they are submitted in sequence, it would be sufficient to use
> group=0.
> 
> Let's make an example, were synchronization groups actually make a
> difference:
> 
> | prep_sqe1(group=1); submit();
> | prep_sqe2(group=3); submit();
> | prep_sqe3(group=1); submit();
> | ... time passes ... no sqe finishes
> | prep_sqe4(group=3); submit();
> | .... time passes... sqe1-sqe3 finish
> | prep_sqe5(group=1); submit();
> 
> In this example, we could execute SQE1 and SQE2 in parallel, while SQE3
> must be executed after SQE1.
> 
> Furthermore, with synchronization groups, we can sequence SQE4 after
> SEQ2, although SQE3 was submitted in the meantime. This could not be
> achieved with linking on the same io_uring.
> 
> For SQE5, we specify a synchronization group, however, as SQE1 and SQE3
> have already finished, it can be started right one.

Yeah, got it right, thanks


>> Once request is submitted we don't keep an explicit reference to it,
>> and it's hard and unreliably trying to find it, so would not really be
>> "submission" time, but would require additional locking:
>>
>> 1) either on completion of a request it looks up its group, but
>> then submission should do +1 spinlock to keep e.g. a list for each
>> group.
>> 2) or try to find a running request and append to its linked list,
>> but that won't work.
>> 3) or do some other magic, but all options would rather be far from
>> free.
> 
> Ok, by looking at the code, submission side and completion side are
> currently uncoupled to each other (aka. no common spinlock). And this is
> one important source of performance. Right? Then this is something we
> have to keep.

atomics/spinlocks scale purely, can be used we would surely prefer to
avoid them in hot paths if possible.
 
> Ok, I'm not sure I fully understand these three variants, but I think
> that my proposal was aiming for option 2. However, I'm not quite sure
> why this is not possible. What would be wrong with the following
> proposal, which would also be applied to the regular IO_LINK (sync_group 0).

You describe more like 1, the second was more like how cancellation
requests find their targets. In any case, all variants are possible
to implement. The question is in viability / performance cost
considering that can be done in userspace, and as it might know have
more knowledge can actually be implemented in faster manner.

E.g., if userspace is single threaded or already finely sync
submission/completion, the exactly same algorithm can be
implemented without any extra synchronisation there.

Also consider that it adds overhead for those not using it, it's a
yet another special case/feature that can't ever be undone (ABI
compatibility), has maintenance burden, and unrealised future
performance costs (when it stands in the way of optimisation,
as DRAIN does).

Not telling that the feature can't have place, just needs good
enough justification (e.g. performance or opening new use cases)
comparing to complexity/etc. So the simpler/less intrusive the
better.

> Each io_ring_ctx already has a 'struct io_submit_state'. There, we
> replace the submit link with an array of N 'struct io_kiocb **':
> 
>     struct io_submit_state {
>        ....
>        struct io_kiocb ** sync_groups[16];
>        ....
>     }
> 
> These array elements point directly to the link field of the last
> element submitted for that synchronization group.
> Furthermore, we extend io_kiocb to store its synchronization group:
> 
>     struct io_kiocb {
>        ....
>        u8  sync_group;
>        ....
>     }
> 
> On the completion side, we extend __io_req_find_next to unregister
> itself from the io_submit_state of its ring:
> 
>     u8 sg = req->sync_group;
>     if (req->ctx.submit_state.sync_groups[sg] == &(req->link)) {
>        // We might be the last one.
>        struct io_kiocb ** x = req->link ? &(req->link->link) : NULL;
>        CAS(&(req->ctx.submit_state.sync_groups[sg]), &(req->link), x);
>        // CAS failure is no problem.
>     }
>     // At this point, req->link cannot be changed by the submission side,
>     // but it will start a new chain or append to our successor.
>     nxt = req->link;
>     req->link = NULL;
>     return nxt;
> 
> With this extension, the cost for removing the completed request from
> the submit state costs one load and one comparision, if linking is used
> and we are the last one on the chain.
> Otherwise, we pay one compare_and_swap for it, which is required if
> submission and completion should be able to run fully parallel. This
> isn't for free.
> 
> At submission time, we have to append requests, if there is a
> predecessor. For this, we extend io_submit_sqe to work with multiple
> groups:
> 
>    u8 sg = req->sync_group;
>    struct io_kiocb **link_field_new =
>        (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) ? &(req->link) : NULL;
> 
> retry:
>    struct io_kiocb **link_field = ctx->sync_groups[sg]
>    if (link_field) {
>        // Try to append to previous SQE. However, we might run in
>        // parallel to __io_req_find_next.
> 
>        // Edit the link field of the previous SQE.
>        *link_field = req;

By this time the req might already be gone (and sync_groups[] changed to
NULL/next), and so you may get use after free. Also modifying it will
break some cancellation bits who want it to be stable and conditionally
sync using completion_lock.

Can be fixed, but you will find tons of such small things fixing which
will be a bone in the throat even for paths not really using it. See,
IOSQE_IO_DRAIN, it's in hot completion part, it's in several hot places
of the submission path, and got worse after links were added. Would love
to kill it off completely, but compatibility.


>        if(! CAS(&ctx->sync_groups[sg], link_field, link_field_new))
>           goto retry; // CAS failed. Last SQE was completed while we
>                       // prepared the update
>    } else {
>       // There is no previous one, we are alone.
>       ctx->sync_group[sg] = link_field_new;
>    }
> 
> In essence, the sync_groups would be a lock_free queue with a dangling
> head that is even wait-free on the completion side. The above is surely
> not correct, but with a few strategic load_aquire and the store_release
> it probably can be made correct.

Neither those are free -- cache bouncing

> 
> And while it is not free, there already should be a similar kind of
> synchronization between submission and completion if it should be
> possible to link SQE to SQEs that are already in flight and could
> complete while we want to link it.
> Otherwise, SQE linking would only work for SQEs that are submitted in
> one go, but as io_submit_state_end() does not clear
> state->link.head, I think this is supposed to work.

Just to clarify, it submits all the collected link before returning,
just the invariant is based on link.head, if NULL there is no link,
if not tail is initialised.

-- 
Pavel Begunkov

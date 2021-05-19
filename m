Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6C8389432
	for <lists+io-uring@lfdr.de>; Wed, 19 May 2021 18:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241623AbhESQ4e convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 19 May 2021 12:56:34 -0400
Received: from mailgate.zerties.org ([144.76.28.47]:44268 "EHLO
        mailgate.zerties.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237249AbhESQ4e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 May 2021 12:56:34 -0400
Received: from a89-182-233-163.net-htp.de ([89.182.233.163] helo=localhost)
        by mailgate.zerties.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <stettberger@dokucode.de>)
        id 1ljPTR-0002g5-S2; Wed, 19 May 2021 16:55:11 +0000
From:   Christian Dietrich <stettberger@dokucode.de>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
In-Reply-To: <fd68fd2d-3816-e326-8016-b9d5c5c429ed@gmail.com>
Organization: Technische =?utf-8?Q?Universit=C3=A4t?= Hamburg
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
X-Commit-Hash-org: d18408fc8e33b9521828b731e7d04f3eb9eaa916
X-Commit-Hash-Maildir: a291b83acc1ce21b73b97b8bdb9d710b3fe117c6
Date:   Wed, 19 May 2021 18:55:09 +0200
Message-ID: <s7bv97ey87m.fsf@dokucode.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-SA-Do-Not-Rej: Yes
X-SA-Exim-Connect-IP: 89.182.233.163
X-SA-Exim-Mail-From: stettberger@dokucode.de
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mailgate.zerties.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED shortcircuit=no autolearn=ham autolearn_force=no
        version=3.4.4
Subject: Re: [RFC] Programming model for io_uring + eBPF
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel Begunkov <asml.silence@gmail.com> [18. May 2021]:

>> If we extend the semantic of IOSEQ_IO_LINK instead of introducing a new
>> flag, we should be able to limit the problem, or?
>> 
>> - With synchronize_group=0, the usual link-the-next SQE semantic could
>>   remain.
>> - While synchronize_group!=0 could expose the described synchronization
>>   semantic.
>> 
>> Thereby, the overhead is at least hidden behind the existing check for
>> IOSEQ_IO_LINK, which is there anyway. Do you consider IOSQE_IO_LINK=1
>> part of the hot path?
>
> Let's clarify in case I misunderstood you. In a snippet below, should
> it serialise execution of sqe1 and sqe2, so they don't run
> concurrently?

,----
| > prep_sqe1(group=1);
| > submit();
| > prep_sqe2(group=1);
| > submit();
`----

Yes, in this snippet both SQEs should serialize. However, in this case,
as they are submitted in sequence, it would be sufficient to use
group=0.

Let's make an example, were synchronization groups actually make a
difference:

| prep_sqe1(group=1); submit();
| prep_sqe2(group=3); submit();
| prep_sqe3(group=1); submit();
| ... time passes ... no sqe finishes
| prep_sqe4(group=3); submit();
| .... time passes... sqe1-sqe3 finish
| prep_sqe5(group=1); submit();

In this example, we could execute SQE1 and SQE2 in parallel, while SQE3
must be executed after SQE1.

Furthermore, with synchronization groups, we can sequence SQE4 after
SEQ2, although SQE3 was submitted in the meantime. This could not be
achieved with linking on the same io_uring.

For SQE5, we specify a synchronization group, however, as SQE1 and SQE3
have already finished, it can be started right one.

> Once request is submitted we don't keep an explicit reference to it,
> and it's hard and unreliably trying to find it, so would not really be
> "submission" time, but would require additional locking:
>
> 1) either on completion of a request it looks up its group, but
> then submission should do +1 spinlock to keep e.g. a list for each
> group.
> 2) or try to find a running request and append to its linked list,
> but that won't work.
> 3) or do some other magic, but all options would rather be far from
> free.

Ok, by looking at the code, submission side and completion side are
currently uncoupled to each other (aka. no common spinlock). And this is
one important source of performance. Right? Then this is something we
have to keep.

Ok, I'm not sure I fully understand these three variants, but I think
that my proposal was aiming for option 2. However, I'm not quite sure
why this is not possible. What would be wrong with the following
proposal, which would also be applied to the regular IO_LINK (sync_group 0).

Each io_ring_ctx already has a 'struct io_submit_state'. There, we
replace the submit link with an array of N 'struct io_kiocb **':

    struct io_submit_state {
       ....
       struct io_kiocb ** sync_groups[16];
       ....
    }

These array elements point directly to the link field of the last
element submitted for that synchronization group.
Furthermore, we extend io_kiocb to store its synchronization group:

    struct io_kiocb {
       ....
       u8  sync_group;
       ....
    }

On the completion side, we extend __io_req_find_next to unregister
itself from the io_submit_state of its ring:

    u8 sg = req->sync_group;
    if (req->ctx.submit_state.sync_groups[sg] == &(req->link)) {
       // We might be the last one.
       struct io_kiocb ** x = req->link ? &(req->link->link) : NULL;
       CAS(&(req->ctx.submit_state.sync_groups[sg]), &(req->link), x);
       // CAS failure is no problem.
    }
    // At this point, req->link cannot be changed by the submission side,
    // but it will start a new chain or append to our successor.
    nxt = req->link;
    req->link = NULL;
    return nxt;

With this extension, the cost for removing the completed request from
the submit state costs one load and one comparision, if linking is used
and we are the last one on the chain.
Otherwise, we pay one compare_and_swap for it, which is required if
submission and completion should be able to run fully parallel. This
isn't for free.

At submission time, we have to append requests, if there is a
predecessor. For this, we extend io_submit_sqe to work with multiple
groups:

   u8 sg = req->sync_group;
   struct io_kiocb **link_field_new =
       (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) ? &(req->link) : NULL;

retry:
   struct io_kiocb **link_field = ctx->sync_groups[sg]
   if (link_field) {
       // Try to append to previous SQE. However, we might run in
       // parallel to __io_req_find_next.

       // Edit the link field of the previous SQE.
       *link_field = req;
       if(! CAS(&ctx->sync_groups[sg], link_field, link_field_new))
          goto retry; // CAS failed. Last SQE was completed while we
                      // prepared the update
   } else {
      // There is no previous one, we are alone.
      ctx->sync_group[sg] = link_field_new;
   }

In essence, the sync_groups would be a lock_free queue with a dangling
head that is even wait-free on the completion side. The above is surely
not correct, but with a few strategic load_aquire and the store_release
it probably can be made correct.

And while it is not free, there already should be a similar kind of
synchronization between submission and completion if it should be
possible to link SQE to SQEs that are already in flight and could
complete while we want to link it.
Otherwise, SQE linking would only work for SQEs that are submitted in
one go, but as io_submit_state_end() does not clear
state->link.head, I think this is supposed to work.

chris
-- 
Prof. Dr.-Ing. Christian Dietrich
Operating System Group (E-EXK4)
Technische Universität Hamburg
Am Schwarzenberg-Campus 3 (E), 4.092
21073 Hamburg

eMail:  christian.dietrich@tuhh.de
Tel:    +49 40 42878 2188
WWW:    https://osg.tuhh.de/

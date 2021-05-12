Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931B937BBAE
	for <lists+io-uring@lfdr.de>; Wed, 12 May 2021 13:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhELLVl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 12 May 2021 07:21:41 -0400
Received: from mailgate.zerties.org ([144.76.28.47]:58162 "EHLO
        mailgate.zerties.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhELLVk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 May 2021 07:21:40 -0400
Received: from eduroam-185-226.wlan.tu-harburg.de ([134.28.185.226] helo=localhost)
        by mailgate.zerties.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <stettberger@dokucode.de>)
        id 1lgmuj-0005E9-2r; Wed, 12 May 2021 11:20:30 +0000
From:   Christian Dietrich <stettberger@dokucode.de>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
In-Reply-To: <c45d633e-1278-1dcb-0d59-f0886abc3e60@gmail.com>
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
X-Commit-Hash-org: d18408fc8e33b9521828b731e7d04f3eb9eaa916
X-Commit-Hash-Maildir: 32898faea6b599e182c6b1687fb9971becc55f2a
Date:   Wed, 12 May 2021 13:20:27 +0200
Message-ID: <s7beeec8ah0.fsf@dokucode.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-SA-Do-Not-Rej: Yes
X-SA-Exim-Connect-IP: 134.28.185.226
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

Pavel Begunkov <asml.silence@gmail.com> [07. May 2021]:

>> The following SQE would become: Append this SQE to the SQE-link chain
>> with the name '1'. If the link chain has completed, start a new one.
>> Thereby, the user could add an SQE to an existing link chain, even other
>> SQEs are already submitted.
>> 
>>>     sqe->flags |= IOSQE_SYNCHRONIZE;
>>>     sqe->synchronize_group = 1;     // could probably be restricted to uint8_t.
>> 
>> Implementation wise, we would hold a pointer to the last element of the
>> implicitly generated link chain.
>
> It will be in the common path hurting performance for those not using
> it, and with no clear benefit that can't be implemented in userspace.
> And io_uring is thin enough for all those extra ifs to affect end
> performance.
>
> Let's consider if we run out of userspace options.

So summarize my proposal: I want io_uring to support implicit
synchronization by sequentialization at submit time. Doing this would
avoid the overheads of locking (and potentially sleeping).

So the problem that I see with a userspace solution is the following:
If I want to sequentialize an SQE with another SQE that was submitted
waaaaaay earlier, the usual IOSQE_IO_LINK cannot be used as I cannot the
the link flag of that already submitted SQE. Therefore, I would have to
wait in userspace for the CQE and submit my second SQE lateron.

Especially if the goal is to remain in Kernelspace as long as possible
via eBPF-SQEs this is not optimal.

> Such things go really horribly with performant APIs as io_uring, even
> if not used. Just see IOSQE_IO_DRAIN, it maybe almost never used but
> still in the hot path.

If we extend the semantic of IOSEQ_IO_LINK instead of introducing a new
flag, we should be able to limit the problem, or?

- With synchronize_group=0, the usual link-the-next SQE semantic could
  remain.
- While synchronize_group!=0 could expose the described synchronization
  semantic.

Thereby, the overhead is at least hidden behind the existing check for
IOSEQ_IO_LINK, which is there anyway. Do you consider IOSQE_IO_LINK=1
part of the hot path?

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

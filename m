Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5E6373F56
	for <lists+io-uring@lfdr.de>; Wed,  5 May 2021 18:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbhEEQOu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 5 May 2021 12:14:50 -0400
Received: from mailgate.zerties.org ([144.76.28.47]:37778 "EHLO
        mailgate.zerties.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbhEEQOs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 12:14:48 -0400
Received: from a89-182-233-83.net-htp.de ([89.182.233.83] helo=localhost)
        by mailgate.zerties.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <stettberger@dokucode.de>)
        id 1leK9j-0005do-SY; Wed, 05 May 2021 16:13:49 +0000
From:   Christian Dietrich <stettberger@dokucode.de>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
In-Reply-To: <s7bpmy5pcc3.fsf@dokucode.de>
Organization: Technische =?utf-8?Q?Universit=C3=A4t?= Hamburg
References: <s7bsg4slmn3.fsf@dokucode.de>
 <9b3a8815-9a47-7895-0f4d-820609c15e9b@gmail.com>
 <s7btuo6wi7l.fsf@dokucode.de>
 <4a553a51-50ff-e986-acf0-da9e266d97cd@gmail.com>
 <s7bmttssyl4.fsf@dokucode.de>
 <f1e5d6cf-08a9-9110-071f-e89b09837e37@gmail.com>
 <s7bv985te4l.fsf@dokucode.de>
 <46229c8c-7e9d-9232-1e97-d1716dfc3056@gmail.com>
 <s7bpmy5pcc3.fsf@dokucode.de>
X-Commit-Hash-org: 6d4641337834dfde749b899ec805359d074f9152
X-Commit-Hash-Maildir: 17bb32204bb02047dc6f0f754ffd7868c982f554
Date:   Wed, 05 May 2021 18:13:47 +0200
Message-ID: <s7bbl9pp39g.fsf@dokucode.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-SA-Do-Not-Rej: Yes
X-SA-Exim-Connect-IP: 89.182.233.83
X-SA-Exim-Mail-From: stettberger@dokucode.de
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mailgate.zerties.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        GREYLIST_ISWHITE,URIBL_BLOCKED shortcircuit=no autolearn=ham
        autolearn_force=no version=3.4.4
Subject: Re: [RFC] Programming model for io_uring + eBPF
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Christian Dietrich <stettberger@dokucode.de> [05. May 2021]:

> So perhaps, we would do something like
>
>     // alloc 3 groups
>     io_uring_register(fd, REGISTER_SYNCHRONIZATION_GROUPS, 3);
>
>     // submit a synchronized SQE
>     sqe->flags |= IOSQE_SYNCHRONIZE;
>     sqe->synchronize_group = 1;     // could probably be restricted to uint8_t.
>
> When looking at this, this could generally be a nice feature to have
> with SQEs, or? Hereby, the user could insert all of his SQEs and they
> would run sequentially. In contrast to SQE linking, the order of SQEs
> would not be determined, which might be beneficial at some point.

I was thinking further about this statement: "Performing (optional)
serialization of eBPF-SQEs is similar to SQE linking".

If we would want to implement the above interface of synchronization
groups, it could be done without taking locks but by fixing the
execution order at submit time. Thereby, synchronization groups would
become a form of "implicit SQE linking".

The following SQE would become: Append this SQE to the SQE-link chain
with the name '1'. If the link chain has completed, start a new one.
Thereby, the user could add an SQE to an existing link chain, even other
SQEs are already submitted.

>     sqe->flags |= IOSQE_SYNCHRONIZE;
>     sqe->synchronize_group = 1;     // could probably be restricted to uint8_t.

Implementation wise, we would hold a pointer to the last element of the
implicitly generated link chain.

chris
-- 
Prof. Dr.-Ing. Christian Dietrich
Operating System Group (E-EXK4)
Technische Universität Hamburg
Am Schwarzenberg-Campus 3 (E)
21073 Hamburg

eMail:  christian.dietrich@tuhh.de
Tel:    +49 40 42878 2188
WWW:    https://osg.tuhh.de/

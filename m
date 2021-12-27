Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB8047FA65
	for <lists+io-uring@lfdr.de>; Mon, 27 Dec 2021 06:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235248AbhL0FtU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Mon, 27 Dec 2021 00:49:20 -0500
Received: from mailgate.zerties.org ([144.76.28.47]:43096 "EHLO
        mailgate.zerties.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhL0FtU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Dec 2021 00:49:20 -0500
Received: from p4fc6d4a2.dip0.t-ipconnect.de ([79.198.212.162] helo=localhost)
        by mailgate.zerties.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <stettberger@dokucode.de>)
        id 1n1ism-000Abu-KU; Mon, 27 Dec 2021 05:49:17 +0000
From:   Christian Dietrich <stettberger@dokucode.de>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
        horst.schirmeier@tu-dresden.de,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Hendrik Sieck <hendrik.sieck@tuhh.de>
In-Reply-To: <78dbcb47-edde-2d44-a095-e53469634926@linux.alibaba.com>
Organization: Technische =?utf-8?Q?Universit=C3=A4t?= Hamburg
References: <20211214055734.61702-1-haoxu@linux.alibaba.com>
 <s7by24bd49y.fsf@dokucode.de>
 <78dbcb47-edde-2d44-a095-e53469634926@linux.alibaba.com>
X-Commit-Hash-org: f01fca33b1535359a4f3d7fe903261c35a059bba
X-Commit-Hash-Maildir: ac664cc432896bf059ddccae881df3aa66f23cf4
Date:   Mon, 27 Dec 2021 06:49:11 +0100
Message-ID: <s7ba6gmd2co.fsf@dokucode.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-SA-Do-Not-Rej: Yes
X-SA-Exim-Connect-IP: 79.198.212.162
X-SA-Exim-Mail-From: stettberger@dokucode.de
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mailgate.zerties.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED shortcircuit=no autolearn=ham autolearn_force=no
        version=3.4.4
Subject: Re: [POC RFC 0/3] support graph like dependent sqes
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hao Xu <haoxu@linux.alibaba.com> [27. Dezember 2021]:

> Hi Christian,
> Great! Thanks for the testing, a question here: the first generator
> iouring means BPF-enhanced iouring?

No, actually not. I've only shown the plain io_uring vs. linear
systemcall here. Within the generator, I call the io_uring+bpf just
'bpf'.


> I currently don't have a specifuc use case, just feel this may be useful
> since there are simple cases like open-->parallel reads->close that
> linear dependency doesn't apply, so this POC is sent more like to get
> people's thought about user cases..

That is in principle a good idea. However, as Franz can tell you, for
many uses cases predefining the followup actions does not work. For
example, for reads, it can happen that you get a short read, whereby you
cannot directly continue to the next action.

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

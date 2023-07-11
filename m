Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BD674F998
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 23:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjGKVLh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 17:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjGKVLg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 17:11:36 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5012410E3;
        Tue, 11 Jul 2023 14:11:32 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id A0F8B5C00A9;
        Tue, 11 Jul 2023 17:11:31 -0400 (EDT)
Received: from imap50 ([10.202.2.100])
  by compute6.internal (MEProxy); Tue, 11 Jul 2023 17:11:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1689109891; x=1689196291; bh=R7
        QkEbjro+BOdZOzehiTZUtwj8qIEEFGxlQad+UdsRc=; b=AeXBfOWMHoSufDunrY
        xFkFWeqkE6SShYIlFuxjP2N+mFpzXhvhP5BuXTHVimUH1XEvNJSLzuHaDen9ccDC
        qCx03+IMyTfXozlMPJaPc6YWPcFnoByULrH44f+KkrlfrxHs2R9r9uL5zNGMSkwP
        vpAVgGYLp19Uk5YX31QuJSvrL4ueNyePVYfiPXZM344Sf+0tRfC6aBmGwpIa9wRK
        0T9/n4wnyKr8TPK2JKKHDER4Cb5p/J1t+4Cad8/e2yo7lSGZXv1KJsXAzdHHr/3Z
        95IY2Gbni4+PQA/RY7pNgAjQmKWPnjL/omPjBtWbFJJuANDdPImb50Xa5Tt8za1i
        1MKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1689109891; x=1689196291; bh=R7QkEbjro+BOd
        ZOzehiTZUtwj8qIEEFGxlQad+UdsRc=; b=qlZYKm1kwWb+tL6szJZmeN/9buV+q
        rPHJQhCQUT9pswQpPQnuQgzkLGMO1ojmay7Mdo37uIoqRRaVIEakZp5pGYX0KIfU
        bS7VLl0g3QbKSjmcusAplusmA4H3B+fiP7QosZPaHQhctVgUlIsljBs7N2OXzzT9
        C3H3iR1w4BxeJdO4YKTSmCTop/FjYZuVWF6foxXsrdNZ2U72cxibmXF/goXhjqJC
        sosu2IoDV/EOXjgokYyhKo4pPY+PdYIAVGkkQKSpEzL9SVAbuE17Gynxqbz+Qhh1
        HJbWu7QsJE3YoqHGXX0O1kgxP6fL8M4AxoyO3Vec0NXsssOi8pl735zRQ==
X-ME-Sender: <xms:g8WtZDUYD6Zf6H0ihLk03fQ12kFmYkR19KMh1BQlxFFfhyij7MYBVA>
    <xme:g8WtZLkI_9JX-Rd9wseBLQo34K4O_xc2eMgEFZxGSjraNnc0oPXKK-hkPTK07cYps
    ZTmE5M4mAN7Si3xQcY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrfedtgdduheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:g8WtZPZEWWgtF7wazbW14K5YyxJeXjNXxPzrAsgOh8Wt2h8y3OHgZA>
    <xmx:g8WtZOXMos2jkM4pxOVPr3ua3B_gTd70vIrBO8sGsTaPTpSpsqv3KA>
    <xmx:g8WtZNm_xodOqcQN2OfO6zOwk69ym8sqxhBo1S3NK83NnLcl7VuuwA>
    <xmx:g8WtZNuvrpJrUPfEbozFbG2wzPcaEZMM1yuK3eCvGtPbEgFBqxbKgw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 2890D1700090; Tue, 11 Jul 2023 17:11:31 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-531-gfdfa13a06d-fm-20230703.001-gfdfa13a0
Mime-Version: 1.0
Message-Id: <8431d207-5e52-4f8c-a12d-276836174bad@app.fastmail.com>
In-Reply-To: <20230711204352.214086-6-axboe@kernel.dk>
References: <20230711204352.214086-1-axboe@kernel.dk>
 <20230711204352.214086-6-axboe@kernel.dk>
Date:   Tue, 11 Jul 2023 23:11:09 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Jens Axboe" <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Christian Brauner" <brauner@kernel.org>
Subject: Re: [PATCH 5/5] io_uring: add IORING_OP_WAITID support
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023, at 22:43, Jens Axboe wrote:
> This adds support for an async version of waitid(2), in a fully async
> version. If an event isn't immediately available, wait for a callback
> to trigger a retry.
>
> The format of the sqe is as follows:
>
> sqe->len		The 'which', the idtype being queried/waited for.
> sqe->fd			The 'pid' (or id) being waited for.
> sqe->file_index		The 'options' being set.
> sqe->addr2		A pointer to siginfo_t, if any, being filled in.
>
> buf_index, add3, and waitid_flags are reserved/unused for now.
> waitid_flags will be used for options for this request type. One
> interesting use case may be to add multi-shot support, so that the
> request stays armed and posts a notification every time a monitored
> process state change occurs.
>
> Note that this does not support rusage, on Arnd's recommendation.
>
> See the waitid(2) man page for details on the arguments.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Does this require argument conversion for compat tasks?

Even without the rusage argument, I think the siginfo
remains incompatible with 32-bit tasks, unfortunately.

     Arnd

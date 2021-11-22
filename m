Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939B8459461
	for <lists+io-uring@lfdr.de>; Mon, 22 Nov 2021 18:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbhKVR6p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 12:58:45 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:42729 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239678AbhKVR6p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 12:58:45 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 5C2183201C3F;
        Mon, 22 Nov 2021 12:55:37 -0500 (EST)
Received: from imap46 ([10.202.2.96])
  by compute5.internal (MEProxy); Mon, 22 Nov 2021 12:55:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=donacou.ch; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm1; bh=cYX68/tlnyBJ5NTK8kDwRhrwensMZNH
        1rRq5EtEsxJg=; b=JR4QLX6PmJCeeJG5PTVokYUz+hjko0ZBEXTofFB11T7kP5V
        NGOYsXgk3EZOndMm5tAeIWw/jrj9RT71Gpo0WiI4M9pe0hu3t3lKQUeBDrlo8C5M
        o5hDjgCXHhMyajCbCwzyWor1y0pez69t4tz3Xq1QHMQSuumAGVeVW9ohrFof19mz
        eqSmXPvmSPnB7/uMay7nlx+Q6J4X2EMfhxpZ/A0UEM3Mshc++MHLu9XzMW0n4FUD
        b+KfEdu+bWkpahzbWJKUSpQ926ktJN1nOgUhKFXchLAofEhtxHIpntftWQBfqPj3
        0LO7g2znE0LDw09mo2wSM92NqVVJV80gGPs9Q6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cYX68/
        tlnyBJ5NTK8kDwRhrwensMZNH1rRq5EtEsxJg=; b=nKw0WhAv/bihxTfTzquONb
        TTwocn0G+XI14kQqLPJ3od5Q/h83eAz/NvwySq3Sca1Cdk7cS6GCHN6p0dAuNRvN
        QaYCVPchkW3yF+K/TxmuMOWILsTiNMHiMqVNiPRtB/4hc9hEtdPP0GhUsMVwQL10
        9vjQzVpYV9Le1fbfnoFM/EZLDLHnphoCLw5reFWjfcyTJW5RkOp49Hd7VsLd1Es0
        Lj4FkYkP7JaXhKlaKMe41M7BCQSu9iBZeEUufFWbmwBQYMJejPjTcBYdgyAWe5uQ
        Sxg0XnDjA2xAdP3dmoJ4NCtJ5fkyTlxJD71Htp4jtXKdtmjkCpul2HMX/HWJO+Eg
        ==
X-ME-Sender: <xms:mNmbYTox6gGWVwoDHPtUmXvu0-alMYrnjXNVyymB-09xHL_SPzjpng>
    <xme:mNmbYdotXy4Eu4HSo1MGc16RJi54C7RXOo8RCOSTI0712loKK3swy47o0dX1Tbzmq
    83gaIZ9ycuPefvO>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeggddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdetnhgu
    rhgvficuffhonhgrqdevohhutghhfdcuoegrnhgurhgvfiesughonhgrtghouhdrtghhqe
    enucggtffrrghtthgvrhhnpedvueegkeehudelhfeuvdefffelueegvdehueefgedtiefh
    ffetjeeutddtkefhudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegrnhgurhgvfiesughonhgrtghouhdrtghh
X-ME-Proxy: <xmx:mNmbYQO6EIoJG-adK0lppqYh8-9kA6g514Kx3Su4kVrzug_U0EXO8Q>
    <xmx:mNmbYW5R5SkhCLIxjQ5RJvYmB1wWo2ndF0iR0TW6ZZLHtDohh3gdRA>
    <xmx:mNmbYS5EeI-nRscdHzMH71x5Y7grKR1c-ha1IrFpXmQH6yPh2abozA>
    <xmx:mdmbYZbit_2JjYeMckTaBaihK41udfrfN4Dv_8k9rBsQ3hKezlM5uA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 9B7941EE0076; Mon, 22 Nov 2021 12:55:36 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1371-g2296cc3491-fm-20211109.003-g2296cc34
Mime-Version: 1.0
Message-Id: <8f219a64-a39f-45f0-a7ad-708a33888a3b@www.fastmail.com>
In-Reply-To: <b84bc345-d4ea-96de-0076-12ff245c5e29@redhat.com>
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
 <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
 <CFQZSHV700KV.18Y62SACP8KOO@taiga>
 <20211116114727.601021d0763be1f1efe2a6f9@linux-foundation.org>
 <CFRGQ58D9IFX.PEH1JI9FGHV4@taiga>
 <20211116133750.0f625f73a1e4843daf13b8f7@linux-foundation.org>
 <b84bc345-d4ea-96de-0076-12ff245c5e29@redhat.com>
Date:   Mon, 22 Nov 2021 12:55:16 -0500
From:   "Andrew Dona-Couch" <andrew@donacou.ch>
To:     "David Hildenbrand" <david@redhat.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Drew DeVault" <sir@cmpwn.com>
Cc:     "Ammar Faizi" <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        "io_uring Mailing List" <io-uring@vger.kernel.org>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Pavel Begunkov" <asml.silence@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Forgive me for jumping in to an already overburdened thread.  But can
someone pushing back on this clearly explain the issue with applying
this patch?

The only concerns I've heard are that it doesn't go far enough.  That
another strategy (that everyone seems to agree would be a fair bit more
effort) could potentially achieve the same goal and then some.  Isn't
that exactly what's meant by "don't let perfection be the enemy of the
good"? The saying is not talking about literal perfection -- the idea is
that you make progress where you can, and that incremental progress and
broader changes are not necessarily in conflict.

This tiny patch could be a step in the right direction.  Why does this
thread need dozens of replies?

Thanks,
Andrew




--
We all do better when we all do better.  -Paul Wellstone

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9D222B09E
	for <lists+io-uring@lfdr.de>; Thu, 23 Jul 2020 15:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgGWNiE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jul 2020 09:38:04 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:35671 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728134AbgGWNiE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jul 2020 09:38:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 961D2B7C;
        Thu, 23 Jul 2020 09:38:02 -0400 (EDT)
Received: from imap10 ([10.202.2.60])
  by compute1.internal (MEProxy); Thu, 23 Jul 2020 09:38:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9mco5f
        JJTIwbB3aNFFiVQMevd5UiiUsgphoo0oYGF24=; b=rtHW9H+X9+1zQ3LSnXSHNT
        pblNyZl2noCXQzVcDENcy/SjYvwXx4UsTxmC3aBUHxX2jbcbyDTwe2FOqaloPIAX
        gqGF2AgdIHbnLOrtpI3a/rg35ifIhI5B7SzSc/WCn++leiddoW5lFwbM30lkBDsQ
        mTTb7wVX1KPS8TNF5B4IZdp2dDlnYmt3njGgKWiMxdQwTLL1AYjmuIZ82oXvkxP2
        mnTzHpqYj8+5G+X8+WaoB1fQHzwOdpUWwfeKzOIFyrL2CJgV4CX6OmVgJyenfhu5
        R4qmMLh2sIrGDIRe5CyWG5QCt9RszpeC3KkJ3sIKfAFV6bgFES5WAQLaGK9+LO0Q
        ==
X-ME-Sender: <xms:uJIZXyvOt54dY396Ng-a5VkqMdxzQN-hq07zu_qySFTjv1mRQXJNtA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrhedugdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfveholhhi
    nhcuhggrlhhtvghrshdfuceofigrlhhtvghrshesvhgvrhgsuhhmrdhorhhgqeenucggtf
    frrghtthgvrhhnpeehgeehheeiledugeelleetkeeijeehueetteeggfeivdekudeghffh
    ueffledvvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpeifrghlthgvrhhssehvvghrsghumhdrohhrgh
X-ME-Proxy: <xmx:uJIZX3eGF1nonShfrDoGke5vtzpktwatS1yFFhjJ7CXAF40ACCDRpg>
    <xmx:uJIZX9yC5zB3rUSblqIAhl5sOdWqksXMdYW0LZnavy4cipordcUzOw>
    <xmx:uJIZX9PL14F8brVuf6ix41yLjyKqM2Nr5m7Gjg0ZUAgX4WY6NGoIDw>
    <xmx:upIZX9UI-s1S7NtPGDJf2lcO01pkbD4TioauY_1YYgjiPB9yhTmwAao0c5o>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id DE5CD20061; Thu, 23 Jul 2020 09:38:00 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.3.0-92-g11c785d-fm-20200721.004-g11c785d5
Mime-Version: 1.0
Message-Id: <d57e169a-55a0-4fa2-a7f2-9a462a786a38@www.fastmail.com>
In-Reply-To: <20200721155848.32xtze5ntvcmjv63@steredhat>
References: <D9FAB37B-D059-4137-A115-616237D78640@amacapital.net>
 <20200715171130.GG12769@casper.infradead.org>
 <7c09f6af-653f-db3f-2378-02dca2bc07f7@gmail.com>
 <CAJfpegt9=p4uo5U2GXqc-rwqOESzZCWAkGMRTY1r8H6fuXx96g@mail.gmail.com>
 <48cc7eea-5b28-a584-a66c-4eed3fac5e76@gmail.com>
 <202007151511.2AA7718@keescook> <20200716131404.bnzsaarooumrp3kx@steredhat>
 <202007160751.ED56C55@keescook>
 <20200717080157.ezxapv7pscbqykhl@steredhat.lan>
 <CALCETrXSPdiVCgh3h=q7w9RyiKnp-=8jOHoFHX=an0cWqK7bzQ@mail.gmail.com>
 <20200721155848.32xtze5ntvcmjv63@steredhat>
Date:   Thu, 23 Jul 2020 09:37:40 -0400
From:   "Colin Walters" <walters@verbum.org>
To:     "Stefano Garzarella" <sgarzare@redhat.com>,
        "Andy Lutomirski" <luto@kernel.org>
Cc:     "Jens Axboe" <axboe@kernel.dk>, "Christoph Hellwig" <hch@lst.de>,
        "Kees Cook" <keescook@chromium.org>,
        "Pavel Begunkov" <asml.silence@gmail.com>,
        "Miklos Szeredi" <miklos@szeredi.hu>,
        "Matthew Wilcox" <willy@infradead.org>,
        "Jann Horn" <jannh@google.com>,
        "Christian Brauner" <christian.brauner@ubuntu.com>,
        strace-devel@lists.strace.io, io-uring@vger.kernel.org,
        "Linux API" <linux-api@vger.kernel.org>,
        "Linux FS Devel" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Michael Kerrisk" <mtk.manpages@gmail.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>
Subject: Re: strace of io_uring events?
Content-Type: text/plain
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 21, 2020, at 11:58 AM, Stefano Garzarella wrote:

> my use case concerns virtualization. The idea, that I described in the
> proposal of io-uring restrictions [1], is to share io_uring CQ and SQ queues
> with a guest VM for block operations.

Virtualization being a strong security barrier is in eternal conflict with maximizing performance.
All of these "let's add a special guest/host channel" are high risk areas.

And this effort in particular - is it *really* worth it to expose a brand new, fast moving Linux kernel interface (that probably hasn't been fuzzed as much as it needs to be) to virtual machines?

People who want maximum performance at the cost of a bit of security already have the choice to use Linux containers, where they can use io_uring natively.


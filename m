Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4BD14F765
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 10:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgBAJnM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 04:43:12 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:41775 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726216AbgBAJnM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 04:43:12 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 608944DA;
        Sat,  1 Feb 2020 04:43:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 01 Feb 2020 04:43:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:subject:message-id:mime-version:content-type; s=
        fm3; bh=EyX9u001IFaEAUjYEikyF6lI/TbLggo8sofdj2w2bRo=; b=cfAR7Khy
        AC3acBHVawaHMi3FBJ5EdYWcrJL/vTaeEu9dBWNmJ2TtiZGxquD31mjsDH1D1oH4
        5f8NtJQ61cqHuDC/rS0AhlczPD81GEXzYsOQTNYdsLdvyPkmrj4UAUmowg7ywQjV
        f1eIfHFNQonBz+XVvmeGZzKRNiD0+d+fRGh0PAK9vR2az+TOYs7Y+P545C34ef6H
        2Xmo1/y4dcTipmMGywQzjqdoRY2X1kLGU1/eXF6VwDrQhqxAb1aLfOdqIUuKGfi0
        TQAFTp4qAYJF48zOLF3dwcqQR4uGlqHldpKZNmQHxGknbaB3bhC09ea0BUDmuFVf
        5tY6F64TgGenJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=EyX9u001IFaEAUjYEikyF6lI/TbLg
        go8sofdj2w2bRo=; b=VMZgcYg0Q6OCVkfHz7wEjCigYACEt5jmTjR0SNGDW2AGi
        uBJKYu/WYE28Ldbwm4zUMQZ6vbK1DaTRfDgFQNXF/s9v3fqoMSGdylmok0EbkAqV
        f32/+HHDYSfPjZ13U9szBNcYvuhE3y75TXijGS/LIZlwH7ntaBz1eRp09BQB8jAL
        ovWpLIKlb1uxd30PX0V66KsfKaKRFPi96hAxG/H1dgLpwxRUUlqPsUTiArDLE1/4
        ghqlHFY6zwdotwp87Xo+Lqyagc0WGu9ONC/ze18DoVQczIvhBTOaNaOT6aEVqsJG
        exjrhC9DmeBxReG0YeiEXjDH4b7pF5y3lCeim9hGQ==
X-ME-Sender: <xms:Lkg1Xv3cuod4GZ1RZYsRXAoftTWgWf1RUCkjIx4om54-aZJ3lmJqbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrgedvgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkgggtugesthdtredttddtvdenucfhrhhomheptehnughrvghsucfh
    rhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecukfhppedvuddvrd
    ejiedrvdehfedrudejudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:Lkg1Xj8lnczoCFA5Z9t42FX_pFGBAbcL6i_7bR4Atga6RgWOfGHuFg>
    <xmx:Lkg1XiWWO-Lih093v9FipP-FDWJLDg4PsoLzg-5kwaTwRicXNM8N8w>
    <xmx:Lkg1Xl_xtJVHjnHfZMK3M-2xHVFUlyuosfoTC17zlDjgOGuhnKmTuA>
    <xmx:L0g1Xofd81P3xG5m64EQdHqXjdrHs-wE47dArbcJu51OZWSzxjWhjg>
Received: from intern.anarazel.de (unknown [212.76.253.171])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5E1223060B27;
        Sat,  1 Feb 2020 04:43:10 -0500 (EST)
Date:   Sat, 1 Feb 2020 01:43:09 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: io_uring force_nonblock vs POSIX_FADV_WILLNEED
Message-ID: <20200201094309.6si5dllxo4i25f4u@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi

Currently io_uring executes fadvise in submission context except for
DONTNEED:

static int io_fadvise(struct io_kiocb *req, struct io_kiocb **nxt,
		      bool force_nonblock)
{
...
	/* DONTNEED may block, others _should_ not */
	if (fa->advice == POSIX_FADV_DONTNEED && force_nonblock)
		return -EAGAIN;

which makes sense for POSIX_FADV_{NORMAL, RANDOM, WILLNEED}, but doesn't
seem like it's true for POSIX_FADV_WILLNEED?

As far as I can tell POSIX_FADV_WILLNEED synchronously starts readahead,
including page allocation etc, which of course might trigger quite
blocking. The fs also quite possibly needs to read metadata.


Seems like either WILLNEED would have to always be deferred, or
force_page_cache_readahead, __do_page_cache_readahead would etc need to
be wired up to know not to block. Including returning EAGAIN, despite
force_page_cache_readahead and generic_readahead() intentially ignoring
return values / errors.

I guess it's also possible to just add a separate precheck that looks
whether there's any IO needing to be done for the range. That could
potentially also be used to make DONTNEED nonblocking in case everything
is clean already, which seems like it could be nice. But that seems
weird modularity wise.


Context: postgres has long used POSIX_FADV_WILLNEED to do a poor man's
version of async buffered reads, when it knows it needs to do a fair bit
of random reads that are already known (e.g. for bitmap heap scans).

Greetings,

Andres Freund

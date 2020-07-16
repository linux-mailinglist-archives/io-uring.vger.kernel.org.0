Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FD6222C77
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 22:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgGPUFq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 16:05:46 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:43685 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728907AbgGPUFq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 16:05:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id D0CD7E94;
        Thu, 16 Jul 2020 16:05:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 16 Jul 2020 16:05:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:subject:message-id:mime-version:content-type; s=
        fm2; bh=9zDyUSL/Ui92GdDOeIsSEp/i8ZIVIYjrHnPly3xU5Ig=; b=eayywe3x
        pY1x1DSarVFNVEojXhhGekm6Dkobp9134tRO6R4vzOPdmGYLm2wtKqD5isJ+BAe4
        kolZgPOX20MZWI00riZDR8XP4Ws/+m1ePdZ2w2iVOZf+R3imimvY2cgh/O5D9OJr
        UQHaQjmGK88Ab1MoPWpMqe4om5XHYOpeniIRk+C0x+TY46FPLbMIWHbk8Mrg57RI
        +kWgONUSyf1LTNKkJcI1/2d322w3lqcXUUjia74VU1KWvjHiR9Z4y0S2aczS4C5f
        sKjPHqAAcWT+IvLgkFJ4DIEBkjC6iixeAYHA4X4L8yxSi1vUp1h/JQfZNIBMuBDk
        c2CeGFDKAFA9uQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm3; bh=9zDyUSL/Ui92GdDOeIsSEp/i8ZIVI
        YjrHnPly3xU5Ig=; b=M//TM69zcPj3p11se/l+ho5rsMRcws1Q621BDUjkEUu7L
        E8vV/6t7QGSKIEe/bqEiDicVxzT/3QFzp54Ux33LmObr3iusZdroBbjwr5BC2XWh
        xBQiPpXCYYIcM+AK/wMze4Cncxp6FQySOR21XytcEus7VBeChZWyUNPZuYRVgZl4
        D8+RNagvgH+hgilGOqT07CIq5RhNxuLDeMUZgEz5KJh5XJFQoH24sMffB3JUkds6
        SNSD9OT6LIqcpXCQO+KpPri2R8Dnkp7DzWrPezpykMsDd/aNVWnYTTUw9tYPz/sy
        ZDR21cdl6OFNZsdvY/g/1XAomhdNwWeK9Ed2rgnjQ==
X-ME-Sender: <xms:GLMQX6KEmv6GK0JpFue0cDQ4x1DM_3E1sIRL4hBqErB3AlHi19a10Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfeeggddugeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfggtggusehttdertddttddvnecuhfhrohhmpeetnhgurhgvshcu
    hfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrghtth
    gvrhhnpeeivdeileegueeutdefudfhfeethefhvedvleejtefguefgtdeltddutedvheek
    ffenucfkphepieejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:GLMQXyIhQkT3KeCeIU9iumDuh_tI-YcsDZZ-Y_Y_TqEgn18flUk12w>
    <xmx:GLMQX6v_pHgB5DI5gPYBesQ9dzw6q2V01oUdIT5gnGFnEV_9Ifhxfg>
    <xmx:GLMQX_bpe9xZlxndPrIYx4jtEchYThNLpryusoXqVnizk3aLvrxL6A>
    <xmx:GbMQX6khBiBZsRnavfWf0Dgk5UHzPjxZ25vcDZcdxR6pTJMMpXbkoA>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id B423130600A3;
        Thu, 16 Jul 2020 16:05:44 -0400 (EDT)
Date:   Thu, 16 Jul 2020 13:05:43 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: io_uring_setup spuriously returning ENOMEM for one user
Message-ID: <20200716200543.iyrurpmcvrycekom@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

While testing the error handling of my uring using postgres branch I
just encountered the situation that io_uring_setup() always fails with
ENOMEN.

It only does so for the user I did the testing on and not for other
users. During the testing a few io_uring using processes were kill -9'd
and a few core-dumped after abort(). No io_uring using processes are
still alive.

As the issue only happens to the one uid I suspect that
current_user()->locked_mem got corrupted, perhaps after hitting the
limit for real.

Unfortunately I do not see any way to debug this without restarting. It
seems the user wide limit isn't exported anywhere? I found
uids_sysfs_init() while grepping around, but it seems that's just a
leftover.

This happened on 07a56bb875afbe39dabbf6ba7b83783d166863db / 5.8rc5 +
16. I left the machine running for now, in case there's something that
can be debugged while running. But I've to restart it in a bit. It took
a while to hit this issue, unfortunately.

Greetings,

Andres Freund

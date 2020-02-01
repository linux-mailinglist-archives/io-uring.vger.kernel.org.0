Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4AAE14F7D3
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 13:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgBAMxx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 07:53:53 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:39239 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726297AbgBAMxx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 07:53:53 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 8AB92483
        for <io-uring@vger.kernel.org>; Sat,  1 Feb 2020 07:53:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 01 Feb 2020 07:53:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:subject:message-id:mime-version:content-type; s=
        fm3; bh=djPvWJmYuTTIGdVAunT9mOFvyj3L45qe+zvD9eenmPw=; b=X/XdC0+p
        kUcFAMK4oyggLCtNW5qPbXFTMBFIyD6OJzMRsLLPCAcK08T5RLa6i5ydemfH/6W5
        VFn1TkgYJHpelTIH6wRyO3wS0gSoknNnsy4EBc1s3c6kKqo9NwnMQowY+vI6FVs5
        E8vxKB6KLJ0eGklIk2yz0gyHwSqo6vagnI5A5/4VkRApFhG6E9EdRfR7rIsAT21Z
        aQ1dvHvvw87mBLKzbOJxE7cclC2x4b6uQMoTAnXu5jitIdLiyAV/fIStyzGQZ9Pd
        mn3Rc6HVsDJ+Ze3IHQTGMQqeEyZWXArilVCjKGE/eV3BBxt55jj+x07rH8NZhrac
        8OBeB+uKSZEzqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=djPvWJmYuTTIGdVAunT9mOFvyj3L4
        5qe+zvD9eenmPw=; b=jl1cdr4FGIOjt7DgDrJahBvZrRTGypruBu1aKuuGIiioQ
        o72eiAFn6a9xkCGiLxBBtFCpm30+9/gawalYj9pfppU/859pLzkElOrwe6YS0jZs
        /wHv7754ytILJ3zCih+4HdpLiS4NsxQSb+OJ8vgmU9tq9hkM0oBktT5dZqDeO55W
        BtWMH4hAruqvecWutj8ZEjiZ232/VLfcYRbvCbd+8qz4qs3s4wlpwOLVcQ9HJ9tv
        6pqCW6/nR10byhTBr6uLQ2ADzsWVL8DDkkxRP6ayy6q8rNwO6JWbGchOBgHQOVSV
        Lv1vhQoSzc/OWe6NKiyhf0+EQNbrPaXeNnW6PSlMg==
X-ME-Sender: <xms:4HQ1XtlqkGsIzRocArY-GRyVMigvGZCGGzzIHiNMQrwEsR5W9-jDpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrgedvgdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfggtggusehttdertddttd
    dvnecuhfhrohhmpeetnhgurhgvshcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgr
    iigvlhdruggvqeenucfkphepudehuddrvdduiedrudefiedriedvnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgr
    iigvlhdruggv
X-ME-Proxy: <xmx:4HQ1XsF8Bm8Lbh7do8zGrCPrWc_WMP0VBN8lnq9ijePeTQ5NH0qWlQ>
    <xmx:4HQ1XtEHj2IanG1fmwiMBh7AYaHgSvz4v06HzadlxUDxnEBauSzA4A>
    <xmx:4HQ1XpOV-VQeUP15xnmiDuTIsVWTC0TjL2eK5QJfteWXhVMN4lraoQ>
    <xmx:4HQ1XsT57LIdQh3B8Yxpzh7XceA1nHeTyFmZzw0BquNkOxuGNgC-sg>
Received: from intern.anarazel.de (unknown [151.216.136.62])
        by mail.messagingengine.com (Postfix) with ESMTPA id F07FA30607B0
        for <io-uring@vger.kernel.org>; Sat,  1 Feb 2020 07:53:51 -0500 (EST)
Date:   Sat, 1 Feb 2020 04:53:50 -0800
From:   Andres Freund <andres@anarazel.de>
To:     io-uring@vger.kernel.org
Subject: liburing: expose syscalls?
Message-ID: <20200201125350.vkkhezidm6ka6ux5@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

As long as the syscalls aren't exposed by glibc it'd be useful - at
least for me - to have liburing expose the syscalls without really going
through liburing facilities...

Right now I'm e.g. using a "raw" io_uring_enter(IORING_ENTER_GETEVENTS)
to be able to have multiple processes safely wait for events on the same
uring, without needing to hold the lock [1] protecting the ring [2].  It's
probably a good idea to add a liburing function to be able to do so, but
I'd guess there are going to continue to be cases like that. In a bit
of time it seems likely that at least open source users of uring that
are included in databases, have to work against multiple versions of
liburing (as usually embedding libs is not allowed), and sometimes that
is easier if one can backfill a function or two if necessary.

That syscall should probably be under a name that won't conflict with
eventual glibc implementation of the syscall.

Obviously I can just do the syscall() etc myself, but it seems
unnecessary to have a separate copy of the ifdefs for syscall numbers
etc.

What do you think?


[1] It's more efficient to have the kernel wake up the waiting processes
directly, rather than waking up one process, which then wakes up the
other processes by releasing a lock.

[2] The reason one can't just use io_uring_submit_and_wait or such, is
because it's not safe to call __io_uring_flush_sq(ring) while somebody
else might access the ring.

Greetings,

Andres Freund

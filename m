Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE02C582993
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 17:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbiG0P0i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 11:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbiG0P0h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 11:26:37 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E3043E41;
        Wed, 27 Jul 2022 08:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Bp/g6eNlnCBAoZ0LWknApR0tx19tg/4ymXOK+EaQ2xI=; b=PGKLeNIv6uHmwfWjKHrBIZJjtU
        YcVbDBx12Zx6rEP8m7PHB9OY5VmANeGtzN/g+el8JBPwOnDURJW68ZevdlXKf72dILCEjMA7z8QkS
        ZC0PRbXypxE3ld9TjNqEg3nmZ16XaL8Dw0ZrqcAVPFvEKLrKUjgIfa8nhqPm9nvVP5CL0URUuE2Om
        xPsiekYDg9QEe6MjhHuEUoQVbIEDMaaBxx2+RIehyCgEncFobpl1mM0T8zO1LHsAtwRmehd4wRpjF
        IxCMBJrz/aCbsrztgCs3+w8AW5nWAq1l0QYziAyfTLMv84wgvMxkg3co2D3ofoV08tkfV4w9tQCb6
        C43YC4rw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
        id 1oGiva-00GPdH-T3;
        Wed, 27 Jul 2022 15:26:26 +0000
Date:   Wed, 27 Jul 2022 16:26:26 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@lst.de
Subject: Re: [PATCH 4/5] io_uring: add support for dma pre-mapping
Message-ID: <YuFZIrvTaKBQtml/@ZenIV>
References: <20220726173814.2264573-1-kbusch@fb.com>
 <20220726173814.2264573-5-kbusch@fb.com>
 <YuFHeT0UaQsYssin@ZenIV>
 <YuFQPYvOHzpVimJA@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuFQPYvOHzpVimJA@kbusch-mbp.dhcp.thefacebook.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 27, 2022 at 08:48:29AM -0600, Keith Busch wrote:

> > This, BTW, is completely insane - what happens if you follow that
> > with close(map.fd)?  A bunch of dangling struct file references?
> 
> This should have been tied to files registered with the io_uring instance
> holding a reference, and cleaned up when the files are unregistered. I may be
> missing some cases here, so I'll fix that up.

???

Your code does the following sequence:
	file = fget(some number)
	store the obtained pointer in a lot of places
	fput(file)

What is "may be missing" and what kind of "registration" could possibly
help here?  As soon as fget() had returned the reference, another thread
might have removed it from the descriptor table, leaving you the sole holder
of reference to object.  In that case it will be destroyed by fput(), making
its memory free for reuse.

Looks like you have some very odd idea of what the struct file lifetime rules
are...

> > I really don't understand what you are trying to do here
> 
> We want to register userspace addresses with the block_device just once. We can
> skip costly per-IO setup this way.

Explain, please.  How will those be used afterwards and how will IO be matched
with the file you've passed here?

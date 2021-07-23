Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CA33D4373
	for <lists+io-uring@lfdr.de>; Sat, 24 Jul 2021 01:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhGWXE7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 19:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbhGWXE7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 19:04:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE01C061575;
        Fri, 23 Jul 2021 16:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8SxMLjYw0e0mPm6nMo2BIduVNWoK1Bl40gyExsHwCZo=; b=PnvHaBYqI2UUgh3VWtFHonn9eM
        KgUiiOCblYXOZJZAHruGfHGUdiYbDf8lG09m4Em+2UlF5/RPwCYeVUxVA1H9+uBANzWf+Ga+fINtQ
        xPgu69qpReLlEBzGvQO0q3UOVIDjItWN3F4y7dBMd1AgVgv9Q6v9A4tTKnp2w5HAL1++tv/4fl33W
        0kLMbylFrEXzgbYgBRrT9ts52jM6ddNp8Sdm04EFUDa/UZz/P0aBM4wxLhG0vmdpJgAr3+mHVCl4n
        /1w5wyafgfHNhsnRI1DpV3zVSvGnvKQe7ni1ZokQS5JyXV4UV3PM4ifhR4BB9aa7o2d+Hbeu7XQJV
        LJCL2Smg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m74qu-00Br6u-Md; Fri, 23 Jul 2021 23:45:15 +0000
Date:   Sat, 24 Jul 2021 00:45:12 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
Message-ID: <YPtUiLg7n8I+dpCT@casper.infradead.org>
References: <YPn/m56w86xAlbIm@zeniv-ca.linux.org.uk>
 <a85df247-137f-721c-6056-a5c340eed90e@kernel.dk>
 <YPoI+GYrgZgWN/dW@zeniv-ca.linux.org.uk>
 <8fb39022-ba21-2c1f-3df5-29be002014d8@kernel.dk>
 <YPr4OaHv0iv0KTOc@zeniv-ca.linux.org.uk>
 <c09589ed-4ae9-c3c5-ec91-ba28b8f01424@kernel.dk>
 <591b4a1e-606a-898c-7470-b5a1be621047@kernel.dk>
 <640bdb4e-f4d9-a5b8-5b7f-5265b39c8044@kernel.dk>
 <YPsR2FgShiiYA2do@zeniv-ca.linux.org.uk>
 <YPskZS1uLctRWz/f@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPskZS1uLctRWz/f@zeniv-ca.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 23, 2021 at 08:19:49PM +0000, Al Viro wrote:
> To elaborate: ->release() instance may not assume anything about current->mm,
> or assume anything about current, for that matter.  It is entirely possible
> to arrange its execution in context of a process that is not yours and had not
> consent to doing that.  In particular, it's a hard bug to have _any_ visible
> effects depending upon the memory mappings, memory contents or the contents of
> descriptor table of the process in question.

Hmm.  Could we add a poison_current() function?  Something like ...

static inline void call_release(struct file *file, struct inode *inode)
{
	void *tmp = poison_current();
	if (file->f_op->release)
		file->f_op->release(inode, file);
	restore_current(tmp);
}

Should be straightforward for asm-generic/current.h and for x86 too.
Probably have to disable preemption?  Maybe interrupts too?  Not sure
what's kept in current these days that an interrupt handler might
rely on being able to access temporarily.

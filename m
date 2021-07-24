Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2673D443A
	for <lists+io-uring@lfdr.de>; Sat, 24 Jul 2021 03:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbhGXA5y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 20:57:54 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:52902 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233366AbhGXA5y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 20:57:54 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m76WA-003LRe-8C; Sat, 24 Jul 2021 01:31:54 +0000
Date:   Sat, 24 Jul 2021 01:31:54 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
Message-ID: <YPttinG3AaygvUeR@zeniv-ca.linux.org.uk>
References: <a85df247-137f-721c-6056-a5c340eed90e@kernel.dk>
 <YPoI+GYrgZgWN/dW@zeniv-ca.linux.org.uk>
 <8fb39022-ba21-2c1f-3df5-29be002014d8@kernel.dk>
 <YPr4OaHv0iv0KTOc@zeniv-ca.linux.org.uk>
 <c09589ed-4ae9-c3c5-ec91-ba28b8f01424@kernel.dk>
 <591b4a1e-606a-898c-7470-b5a1be621047@kernel.dk>
 <640bdb4e-f4d9-a5b8-5b7f-5265b39c8044@kernel.dk>
 <YPsR2FgShiiYA2do@zeniv-ca.linux.org.uk>
 <YPskZS1uLctRWz/f@zeniv-ca.linux.org.uk>
 <YPtUiLg7n8I+dpCT@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPtUiLg7n8I+dpCT@casper.infradead.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jul 24, 2021 at 12:45:12AM +0100, Matthew Wilcox wrote:
> On Fri, Jul 23, 2021 at 08:19:49PM +0000, Al Viro wrote:
> > To elaborate: ->release() instance may not assume anything about current->mm,
> > or assume anything about current, for that matter.  It is entirely possible
> > to arrange its execution in context of a process that is not yours and had not
> > consent to doing that.  In particular, it's a hard bug to have _any_ visible
> > effects depending upon the memory mappings, memory contents or the contents of
> > descriptor table of the process in question.
> 
> Hmm.  Could we add a poison_current() function?  Something like ...
> 
> static inline void call_release(struct file *file, struct inode *inode)
> {
> 	void *tmp = poison_current();
> 	if (file->f_op->release)
> 		file->f_op->release(inode, file);
> 	restore_current(tmp);
> }
> 
> Should be straightforward for asm-generic/current.h and for x86 too.
> Probably have to disable preemption?  Maybe interrupts too?  Not sure
> what's kept in current these days that an interrupt handler might
> rely on being able to access temporarily.

->release() might grab a mutex, for example.  Scheduler is going to be unhappy
if it runs into somebody playing silly buggers with current...

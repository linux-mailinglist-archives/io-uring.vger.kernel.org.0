Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75813D416C
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 22:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhGWTjT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 15:39:19 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:50180 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWTjT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 15:39:19 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m71e9-003HJ9-Rf; Fri, 23 Jul 2021 20:19:49 +0000
Date:   Fri, 23 Jul 2021 20:19:49 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
Message-ID: <YPskZS1uLctRWz/f@zeniv-ca.linux.org.uk>
References: <57758edf-d064-d37e-e544-e0c72299823d@kernel.dk>
 <YPn/m56w86xAlbIm@zeniv-ca.linux.org.uk>
 <a85df247-137f-721c-6056-a5c340eed90e@kernel.dk>
 <YPoI+GYrgZgWN/dW@zeniv-ca.linux.org.uk>
 <8fb39022-ba21-2c1f-3df5-29be002014d8@kernel.dk>
 <YPr4OaHv0iv0KTOc@zeniv-ca.linux.org.uk>
 <c09589ed-4ae9-c3c5-ec91-ba28b8f01424@kernel.dk>
 <591b4a1e-606a-898c-7470-b5a1be621047@kernel.dk>
 <640bdb4e-f4d9-a5b8-5b7f-5265b39c8044@kernel.dk>
 <YPsR2FgShiiYA2do@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPsR2FgShiiYA2do@zeniv-ca.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 23, 2021 at 07:00:40PM +0000, Al Viro wrote:
> On Fri, Jul 23, 2021 at 11:56:29AM -0600, Jens Axboe wrote:
> 
> > Will send out two patches for this. Note that I don't see this being a
> > real issue, as we explicitly gave the ring fd to another task, and being
> > that this is purely for read/write, it would result in -EFAULT anyway.
> 
> You do realize that ->release() might come from seriously unexpected places,
> right?  E.g. recvmsg() by something that doesn't expect SCM_RIGHTS attached
> to it will end up with all struct file references stashed into the sucker
> dropped, and if by that time that's the last reference - welcome to ->release()
> run as soon as recepient hits task_work_run().
> 
> What's more, if you stash that into garbage for unix_gc() to pick, *any*
> process closing an AF_UNIX socket might end up running your ->release().
> 
> So you really do *not* want to spawn any threads there, let alone
> possibly exfiltrating memory contents of happy recepient of your present...

To elaborate: ->release() instance may not assume anything about current->mm,
or assume anything about current, for that matter.  It is entirely possible
to arrange its execution in context of a process that is not yours and had not
consent to doing that.  In particular, it's a hard bug to have _any_ visible
effects depending upon the memory mappings, memory contents or the contents of
descriptor table of the process in question.

There's really no way around that.

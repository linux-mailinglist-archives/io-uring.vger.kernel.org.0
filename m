Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9227D3D4175
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 22:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhGWTn6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 15:43:58 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:50240 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhGWTn6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 15:43:58 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m71if-003HMY-7I; Fri, 23 Jul 2021 20:24:29 +0000
Date:   Fri, 23 Jul 2021 20:24:29 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
Message-ID: <YPslfT91brz3SsuM@zeniv-ca.linux.org.uk>
References: <YPn/m56w86xAlbIm@zeniv-ca.linux.org.uk>
 <a85df247-137f-721c-6056-a5c340eed90e@kernel.dk>
 <YPoI+GYrgZgWN/dW@zeniv-ca.linux.org.uk>
 <8fb39022-ba21-2c1f-3df5-29be002014d8@kernel.dk>
 <YPr4OaHv0iv0KTOc@zeniv-ca.linux.org.uk>
 <c09589ed-4ae9-c3c5-ec91-ba28b8f01424@kernel.dk>
 <591b4a1e-606a-898c-7470-b5a1be621047@kernel.dk>
 <640bdb4e-f4d9-a5b8-5b7f-5265b39c8044@kernel.dk>
 <YPsR2FgShiiYA2do@zeniv-ca.linux.org.uk>
 <3f557a2b-e83c-69e6-b953-06d0b05512ae@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f557a2b-e83c-69e6-b953-06d0b05512ae@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 23, 2021 at 02:10:40PM -0600, Jens Axboe wrote:
> On 7/23/21 1:00 PM, Al Viro wrote:
> > On Fri, Jul 23, 2021 at 11:56:29AM -0600, Jens Axboe wrote:
> > 
> >> Will send out two patches for this. Note that I don't see this being a
> >> real issue, as we explicitly gave the ring fd to another task, and being
> >> that this is purely for read/write, it would result in -EFAULT anyway.
> > 
> > You do realize that ->release() might come from seriously unexpected
> > places, right?  E.g. recvmsg() by something that doesn't expect
> > SCM_RIGHTS attached to it will end up with all struct file references
> > stashed into the sucker dropped, and if by that time that's the last
> > reference - welcome to ->release() run as soon as recepient hits
> > task_work_run().
> > 
> > What's more, if you stash that into garbage for unix_gc() to pick,
> > *any* process closing an AF_UNIX socket might end up running your
> > ->release().
> > 
> > So you really do *not* want to spawn any threads there, let alone
> > possibly exfiltrating memory contents of happy recepient of your
> > present...
> 
> Yes I know, and the iopoll was the exception - we don't do anything but
> cancel off release otherwise.

Not saying you don't - I just want to have that in (searchable) archives.
Ideally we need that kind of stuff in Documentation/*, but having it
findable by google search is at least better than nothing...

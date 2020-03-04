Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189E3178723
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 01:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387396AbgCDAns (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 19:43:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387411AbgCDAnr (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 3 Mar 2020 19:43:47 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63596206D5;
        Wed,  4 Mar 2020 00:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583282626;
        bh=XK+G6khwr7qN7maCq0un95O3asSsmGLGZKgaeyZ8QJo=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=r2vyvhyOjhZfzp1FAIqdC08o88JrIhx/u/bbn1kQvQNxBDTOV+qcLjAPm+Ida5K3I
         5zIFr1eORpbxN8SBYUNDjMf4avi2m7pFmOHqpOIzJkYt1kGj/EPu+Phz/MzB+he1q+
         cfpzTf/Shj5a6E29mANy5ty1modEpIcpwyQo6mxg=
Message-ID: <68870b663dadea8d287ca7cb39d224bb4affd01c.camel@kernel.org>
Subject: Re: [PATCHSET RFC 0/4] Support passing fds between chain links
From:   Jeff Layton <jlayton@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Date:   Tue, 03 Mar 2020 19:43:45 -0500
In-Reply-To: <20200303235053.16309-1-axboe@kernel.dk>
References: <20200303235053.16309-1-axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 2020-03-03 at 16:50 -0700, Jens Axboe wrote:
> One of the fabled features with chains has long been the desire to
> support things like:
> 
> <open fileX><read from fileX><close fileX>
> 
> in a single chain. This currently doesn't work, since the read/close
> depends on what file descriptor we get on open.
> 
> This is very much a RFC patchset, but it allows the read/close above
> to set their fd to a magic value, IOSQE_FD_LAST_OPEN. If set to this
> value, the file descriptor will be inherited from the last open in
> that chain. If there are no opens in the chain, the IO is simply
> errored. Only a single magic fd value is supported, so if the chain
> needs to operate on two of them, care needs to be taken to ensure
> things are correct. Consider for example the desire to open fileX
> and read from it, and write that to another file. You could do that
> ala:
> 
> <open fileX><read from fileX><close fileX><open fileY><write to fileY>
> 	<close fileY>
> 
> and have that work, but you cannot open both files first, then read/write
> and then close. I don't think that necessarily poses a problem, and
> I'd rather not get into fd nesting and things like that. Open to input
> here, of course.
> 

Nice work!

I think this is a fine interface for about 90% of the use cases that I
can think of for this.

It would have to be expanded if we ever did want to be able to multiplex
several fds though. Might we ever need to do a splice or copy_file_range
between two files like this? It's at least worth considering how we
might do that in the future.

One idea might be to give each chain a fixed-size table (8 or so?) and
then add a way to basically dup a private reference of the LAST_OPEN
fd+file into a particular slot.

Then you could just define constants like IOSQE_FD_SLOT_1..8 and then
you have a way to deal with more than one "ephemeral" open at a time.
Those dup'ed entries would be implicitly closed when the chain returns.

Then, you could do:

    <open><dup><close>

...and just work with the private slot descriptor from then on in the
chain.

> 
> Another concern here is that we currently error linked IO if it doesn't
> match what was asked for, a prime example being short reads. For a
> basic chain of open/read/close, the close doesn't really care if the read
> is short or not. It's only if we have further links in the chain that
> depend on the read length that this is a problem.
> 

Ok, so a short read is considered an error and you stop processing the
chain? That seems like a reasonable thing to do here. The idea is to do
this for speed, so erroring out when things don't go as planned seems
fine to me.


> Anyway, with this, prep handlers can't look at ->file as it may not be
> valid yet. Only close and read/write do that, from a quick glance, and
> there are two prep patches to split that a bit (2 and 3). Patch 1 is just
> a basic prep patch as well, patch 4 is the functional part.
> 
> I added a small 'orc' (open-read-close) test program in the fd-pass
> branch of liburing:
> 
> https://git.kernel.dk/cgit/liburing/plain/test/orc.c?h=fd-pass
> 
> as an example use case.
> 
-- 
Jeff Layton <jlayton@kernel.org>


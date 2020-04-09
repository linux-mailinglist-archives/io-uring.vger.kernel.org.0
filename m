Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15E6E1A2DDC
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2020 05:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgDIDRR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 23:17:17 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:45873 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgDIDRR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 23:17:17 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id A55BDFF806;
        Thu,  9 Apr 2020 03:17:11 +0000 (UTC)
Date:   Wed, 8 Apr 2020 20:17:08 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 1/3] fs: Support setting a minimum fd for "lowest
 available fd" allocation
Message-ID: <20200409031708.GC6149@localhost>
References: <cover.1586321767.git.josh@joshtriplett.org>
 <90bf6fd43343ca862e7f61b0834baf2bdbd0e24c.1586321767.git.josh@joshtriplett.org>
 <20200408120040.mtkqmymfazrv3lqk@yavin.dot.cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408120040.mtkqmymfazrv3lqk@yavin.dot.cyphar.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 08, 2020 at 10:00:40PM +1000, Aleksa Sarai wrote:
> On 2020-04-07, Josh Triplett <josh@joshtriplett.org> wrote:
> > Some applications want to prevent the usual "lowest available fd"
> > allocation from allocating certain file descriptors. For instance, they
> > may want to prevent allocation of a closed fd 0, 1, or 2 other than via
> > dup2/dup3, or reserve some low file descriptors for other purposes.
> > 
> > Add a prctl to increase the minimum fd and return the previous minimum.
> > 
> > System calls that allocate a specific file descriptor, such as
> > dup2/dup3, ignore this minimum.
> > 
> > exec resets the minimum fd, to prevent one program from interfering with
> > another program's expectations about fd allocation.
> 
> Why is it implemented as an "increase the value" interface? It feels
> like this is meant to avoid some kind of security trap (with a library
> reducing the value) but it means that if you want to temporarily raise
> the minimum fd number it's not possible (without re-exec()ing yourself,
> which is hardly a fun thing to do).
> 
> Then again, this might've been discussed before and I missed it...

It was: the previous version was a "get" and "set" interface. That
interface didn't allow for the possibility that something else in the
process had already set a minimum. This new atomic increase interface
(which also serves as a "get" interface if you pass 0) makes it possible
for a userspace library to reserve a range. (You have no guarantee about
previously allocated descriptors in that range, but you know that no
*new* automatically allocated descriptors will appear in that range,
which suffices; userspace can do the rest.)

- Josh Triplett

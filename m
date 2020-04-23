Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191B41B53D3
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2020 06:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgDWEvW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Apr 2020 00:51:22 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:43895 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgDWEvW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Apr 2020 00:51:22 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 36D75C0005;
        Thu, 23 Apr 2020 04:51:14 +0000 (UTC)
Date:   Wed, 22 Apr 2020 21:51:12 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     "Dmitry V. Levin" <ldv@altlinux.org>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mtk.manpages@gmail.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Aleksa Sarai <cyphar@cyphar.com>, linux-man@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] fs: Support setting a minimum fd for "lowest
 available fd" allocation
Message-ID: <20200423045112.GI161058@localhost>
References: <cover.1587531463.git.josh@joshtriplett.org>
 <05c9a6725490c5a5c4ee71be73326c2fedf35ba5.1587531463.git.josh@joshtriplett.org>
 <20200423011253.GA18957@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423011253.GA18957@altlinux.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 23, 2020 at 04:12:53AM +0300, Dmitry V. Levin wrote:
> On Tue, Apr 21, 2020 at 10:19:49PM -0700, Josh Triplett wrote:
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
> Please make this aspect properly documented in "Effect on process
> attributes" section of execve(2) manual page.

Done. I'll include updated manpage patches in v6.

> > +unsigned int increase_min_fd(unsigned int num)
> > +{
> > +	struct files_struct *files = current->files;
> > +	unsigned int old_min_fd;
> > +
> > +	spin_lock(&files->file_lock);
> > +	old_min_fd = files->min_fd;
> > +	files->min_fd += num;
> > +	spin_unlock(&files->file_lock);
> > +	return old_min_fd;
> > +}
>
> If it's "increase", there should be an overflow check.
> Otherwise it's "assign" rather than "increase".

I'll add a check in v6, to make sure that the value cannot overflow into
the errno range. (Note that this is not security-sensitive, it's just
providing a footgun-resistant interface. It should absolutely check,
though.)

- Josh Triplett

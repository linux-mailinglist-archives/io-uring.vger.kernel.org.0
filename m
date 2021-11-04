Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63928445549
	for <lists+io-uring@lfdr.de>; Thu,  4 Nov 2021 15:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhKDOaV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Nov 2021 10:30:21 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56400 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhKDOaV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Nov 2021 10:30:21 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EE26E212C0;
        Thu,  4 Nov 2021 14:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1636036061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AthaTNwsWhomj4CQfeFfXNvryAZHBE+ttAigqWJELZ8=;
        b=Zpi2sSr3zc7coy+kFgUoMlTkQCgsnC715jzM/5jmMXYG/Sq82yypiXPgvIjaOQkCJ91dqX
        P3tGUZOAmlrKHUTArkOSrYFmQ64/XFKgOmm3cq6x03HeaLFtdisFXs+wPiN1HS+F/t7UEP
        JLMQ37GxOac31JZeHY8cTQgsVWmrUyk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1636036061;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AthaTNwsWhomj4CQfeFfXNvryAZHBE+ttAigqWJELZ8=;
        b=NhFnKZZJtHkXF4aRTfwvipQQhUoWn5TpVEhK/YVKeBNP28C1AONZvzrOitda6nYc+EQCp+
        2x+3Uodke2J2E1Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DAEF613BD9;
        Thu,  4 Nov 2021 14:27:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7QWcM93tg2EbUAAAMHmgww
        (envelope-from <chrubis@suse.cz>); Thu, 04 Nov 2021 14:27:41 +0000
Date:   Thu, 4 Nov 2021 15:27:32 +0100
From:   Cyril Hrubis <chrubis@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Drew DeVault <sir@cmpwn.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Message-ID: <YYPt1PaGtiSLvyKw@rei>
References: <20211028080813.15966-1-sir@cmpwn.com>
 <cc3d7fac-62e9-fe11-0cf1-3d9528d191a0@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc3d7fac-62e9-fe11-0cf1-3d9528d191a0@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi!
> > This limit has not been updated since 2008, when it was increased to 64
> > KiB at the request of GnuPG. Until recently, the main use-cases for this
> > feature were (1) preventing sensitive memory from being swapped, as in
> > GnuPG's use-case; and (2) real-time use-cases. In the first case, little
> > memory is called for, and in the second case, the user is generally in a
> > position to increase it if they need more.
> > 
> > The introduction of IOURING_REGISTER_BUFFERS adds a third use-case:
> > preparing fixed buffers for high-performance I/O. This use-case will
> > take as much of this memory as it can get, but is still limited to 64
> > KiB by default, which is very little. This increases the limit to 8 MB,
> > which was chosen fairly arbitrarily as a more generous, but still
> > conservative, default value.
> > ---
> > It is also possible to raise this limit in userspace. This is easily
> > done, for example, in the use-case of a network daemon: systemd, for
> > instance, provides for this via LimitMEMLOCK in the service file; OpenRC
> > via the rc_ulimit variables. However, there is no established userspace
> > facility for configuring this outside of daemons: end-user applications
> > do not presently have access to a convenient means of raising their
> > limits.
> > 
> > The buck, as it were, stops with the kernel. It's much easier to address
> > it here than it is to bring it to hundreds of distributions, and it can
> > only realistically be relied upon to be high-enough by end-user software
> > if it is more-or-less ubiquitous. Most distros don't change this
> > particular rlimit from the kernel-supplied default value, so a change
> > here will easily provide that ubiquity.
> 
> Agree with raising this limit, it is ridiculously low and we often get
> reports from people that can't even do basic rings with it. Particularly
> when bpf is involved as well, as it also dips into this pool.
> 
> On the production side at facebook, we do raise this limit as well.

We are raising this limit to 2MB for LTP testcases as well, otherwise we
get failures when we run a few bpf tests in quick succession.

Acked-by: Cyril Hrubis <chrubis@suse.cz>

-- 
Cyril Hrubis
chrubis@suse.cz

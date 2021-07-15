Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6702B3CADC2
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 22:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343590AbhGOUUt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 16:20:49 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:60670 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241154AbhGOUUn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 16:20:43 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m47nj-000xOY-8c; Thu, 15 Jul 2021 20:17:43 +0000
Date:   Thu, 15 Jul 2021 20:17:43 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH  05/14] namei: prepare do_mkdirat for refactoring
Message-ID: <YPCX5/0NtbEySW9q@zeniv-ca.linux.org.uk>
References: <20210715103600.3570667-1-dkadashev@gmail.com>
 <20210715103600.3570667-6-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715103600.3570667-6-dkadashev@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 15, 2021 at 05:35:51PM +0700, Dmitry Kadashev wrote:
> This is just a preparation for the move of the main mkdirat logic to a
> separate function to make the logic easier to follow.  This change
> contains the flow changes so that the actual change to move the main
> logic to a separate function does no change the flow at all.
> 
> Just like the similar patches for rmdir and unlink a few commits before,
> there two changes here:
> 
> 1. Previously on filename_create() error the function used to exit
> immediately, and now it will check the return code to see if ESTALE
> retry is appropriate. The filename_create() does its own retries on
> ESTALE (at least via filename_parentat() used inside), but this extra
> check should be completely fine.

This is the wrong way to go.  Really.  Look at it that way - LOOKUP_REVAL
is the final stage of escalation; if we had to go there, there's no
point being optimistic about the last dcache lookup, nevermind trying
to retry the parent pathwalk if we fail with -ESTALE doing it.

I'm not saying that it's something worth optimizing for; the problem
is different - the logics makes no sense whatsoever that way.  It's
a matter of reader's cycles wasted on "what the fuck are we trying
to do here?", not the CPU cycles wasted on execution.

While we are at it, it makes no sense for filename_parentat() and its
ilk to go for RCU and normal if it's been given LOOKUP_REVAL - I mean,
look at the sequence of calls in there.  And try to make sense of
it.  Especially of the "OK, RCU attempt told us to sod off and try normal;
here, let's call path_parentat() with LOOKUP_REVAL for flags and if it
says -ESTALE, call it again with exact same arguments" part.

Seriously, look at that from the point of view of somebody who tries
to make sense of the entire thing.

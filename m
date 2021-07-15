Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D106E3CAD5D
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 21:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbhGOT6n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 15:58:43 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:60476 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245084AbhGOT4l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 15:56:41 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m47MI-000wuX-6Y; Thu, 15 Jul 2021 19:49:22 +0000
Date:   Thu, 15 Jul 2021 19:49:22 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH  01/14] namei: prepare do_rmdir for refactoring
Message-ID: <YPCRQo3vsSgBwzCN@zeniv-ca.linux.org.uk>
References: <20210715103600.3570667-1-dkadashev@gmail.com>
 <20210715103600.3570667-2-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715103600.3570667-2-dkadashev@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 15, 2021 at 05:35:47PM +0700, Dmitry Kadashev wrote:
> This is just a preparation for the move of the main rmdir logic to a
> separate function to make the logic easier to follow.  This change
> contains the flow changes so that the actual change to move the main
> logic to a separate function does no change the flow at all.
> 
> Two changes here:
> 
> 1. Previously on filename_parentat() error the function used to exit
> immediately, and now it will check the return code to see if ESTALE
> retry is appropriate. The filename_parentat() does its own retries on
> ESTALE, but this extra check should be completely fine.
> 
> 2. The retry_estale() check is wrapped in unlikely(). Some other places
> already have that and overall it seems to make sense.

That's not the way to do it.

static inline bool
retry_estale(const long error, const unsigned int flags)
{
        return unlikely(error == -ESTALE && !(flags & LOOKUP_REVAL));
}

And strip the redundant unlikely in the callers.  Having that markup
in callers makes sense only when different callers have different
odds of positive result, which is very much not the case here.

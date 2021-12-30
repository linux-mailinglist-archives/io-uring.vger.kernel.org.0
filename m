Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CE7481800
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 02:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhL3BKJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 20:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbhL3BKJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 20:10:09 -0500
X-Greylist: delayed 1257 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Dec 2021 17:10:09 PST
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FF9C061574;
        Wed, 29 Dec 2021 17:10:08 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n2jd0-00FqbD-5S; Thu, 30 Dec 2021 00:49:10 +0000
Date:   Thu, 30 Dec 2021 00:49:10 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH v10 1/5] fs: split off do_user_path_at_empty from
 user_path_at_empty()
Message-ID: <Yc0CBiduomJ8TCSm@zeniv-ca.linux.org.uk>
References: <20211229203002.4110839-1-shr@fb.com>
 <20211229203002.4110839-2-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229203002.4110839-2-shr@fb.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 29, 2021 at 12:29:58PM -0800, Stefan Roesch wrote:
> This splits off a do_user_path_at_empty function from the
> user_path_at_empty_function. This is required so it can be
> called from io_uring.

Umm...  Why do you bother with that wrapper?  filename_lookup() is already
there and already non-static.  Granted, its user outside of fs/namei.c
is ugly as hell, but looking at this series, I'd rather have the damn
thing call filename_lookup() directly.  _Or_, if you really feel like
doing that wrapper, make it inline in internal.h and have fs_parser.c
use call the same thing - it also passes NULL as the last argument.

Said that, I really don't see the point of having that wrapper in the
first place.

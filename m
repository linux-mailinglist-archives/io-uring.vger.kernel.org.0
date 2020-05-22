Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D8A1DDC53
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 02:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgEVAu6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 May 2020 20:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgEVAu6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 May 2020 20:50:58 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190FCC061A0E;
        Thu, 21 May 2020 17:50:58 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jbvtl-00DEYB-GH; Fri, 22 May 2020 00:50:53 +0000
Date:   Fri, 22 May 2020 01:50:53 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] io_uring: call statx directly
Message-ID: <20200522005053.GK23230@ZenIV.linux.org.uk>
References: <1590106777-5826-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1590106777-5826-3-git-send-email-bijan.mottahedeh@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590106777-5826-3-git-send-email-bijan.mottahedeh@oracle.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 21, 2020 at 05:19:37PM -0700, Bijan Mottahedeh wrote:
> Calling statx directly both simplifies the interface and avoids potential
> incompatibilities between sync and async invokations.
> 
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> ---
>  fs/io_uring.c | 53 +++++++----------------------------------------------
>  1 file changed, 7 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 12284ea..0540961 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -427,7 +427,10 @@ struct io_open {
>  	union {
>  		unsigned		mask;
>  	};
> -	struct filename			*filename;
> +	union {
> +		struct filename		*filename;
> +		const char __user	*fname;
> +	};

NAK.  io_uring is already has ridiculous amount of multiplexing,
but this kind of shit is right out.

And frankly, the more I look at it, the more I want to rip
struct io_open out.  This kind of trashcan structures has
caused tons of headache pretty much every time we had those.
Don't do it.

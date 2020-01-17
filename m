Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19A1140FB1
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 18:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgAQRPw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 12:15:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50993 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726603AbgAQRPw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 12:15:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579281351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oC32WOtUyxpUEYO4VwgcmnBAMeDI2L+c4IivPsq/j1s=;
        b=Io1dIRTE2gPjXcz27+Kf0aP7SfrR5yiCs+WE3qrcl5sDIix/UlpLleY2r7x9cIuzLwfN02
        W5ZSvwVxCeXdoH9ug71qTj2ekpVRUhr5+b5Hj9OZev617MtL1fEfnTDgPBQCsMs5YUmSWD
        5LuQMopgwaoPn4NmhS/BY0k2rqioRTc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-L_yQQ2ffOZW4-sUPj4ec0A-1; Fri, 17 Jan 2020 12:15:47 -0500
X-MC-Unique: L_yQQ2ffOZW4-sUPj4ec0A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7D3C100550E;
        Fri, 17 Jan 2020 17:15:45 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 476B660C63;
        Fri, 17 Jan 2020 17:15:45 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v2] io_uring: add support for probing opcodes
References: <886e284c-4b1f-b90e-507e-05e5c74b9599@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Fri, 17 Jan 2020 12:15:44 -0500
In-Reply-To: <886e284c-4b1f-b90e-507e-05e5c74b9599@kernel.dk> (Jens Axboe's
        message of "Thu, 16 Jan 2020 19:58:18 -0700")
Message-ID: <x491rry3sxr.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> The application currently has no way of knowing if a given opcode is
> supported or not without having to try and issue one and see if we get
> -EINVAL or not. And even this approach is fraught with peril, as maybe
> we're getting -EINVAL due to some fields being missing, or maybe it's
> just not that easy to issue that particular command without doing some
> other leg work in terms of setup first.
>
> This adds IORING_REGISTER_PROBE, which fills in a structure with info
> on what it supported or not. This will work even with sparse opcode
> fields, which may happen in the future or even today if someone
> backports specific features to older kernels.

This looks pretty good to me.  You can call it with 0 args to get the
total number of ops, then allocate an array with that number and
re-issue the syscall.  I also like that you've allowed for backporting
subsets of functionality.

I have one question below:

> @@ -6632,6 +6674,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>  			break;
>  		ret = io_eventfd_unregister(ctx);
>  		break;
> +	case IORING_REGISTER_PROBE:
> +		ret = -EINVAL;
> +		if (!arg || nr_args > 256)
> +			break;
> +		ret = io_probe(ctx, arg, nr_args);
> +		break;

Why 256?  If it's just arbitrary, please add a comment.

Otherwise looks good!

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>


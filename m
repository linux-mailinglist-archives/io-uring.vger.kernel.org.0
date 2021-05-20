Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FDD38B93E
	for <lists+io-uring@lfdr.de>; Thu, 20 May 2021 23:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhETV41 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 May 2021 17:56:27 -0400
Received: from out2.migadu.com ([188.165.223.204]:18796 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230382AbhETV40 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 20 May 2021 17:56:26 -0400
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1621547703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NybrJWDonQA4CcEg5zwcXbJxHmQZjvoWSjX0H6A4XdI=;
        b=Qb3QboeEJHcJnmNwR1dFYKxZ7QeT134wgaL1JoPmZ99+LoVzSAGWLXC6udk5tVkhe7JSP+
        AIErH4vh5fq0OL6HMKA9/9n48CxQ3SBL+GXaeD+fUSflRYPh9UrU/vsvt7M/C1/h+G9eX0
        zJuwSsZ6su7KT4Kdb0QG4TRRqKjNXulFsvi0csXYj5RrsGRQpGY/Muj3hhHCk1Fl/e31Qq
        ozxHKHOAHD1m4MmFdEqmnOldP9cs6DBRSSF+dHRViQ8/Jd1izmksFBqJRZH6wwn4mJYtDo
        cxygJcSKkB/v2whDpEx3hL5SiZewtOmcPIyVx9QRFxoahvbVMnomV/NL/ej3nA==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 20 May 2021 17:55:01 -0400
Message-Id: <CBIEOQ7BRJ0Q.3O3QZBY0ZZPFI@taiga>
Cc:     "noah" <goldstein.w.n@gmail.com>,
        "Pavel Begunkov" <asml.silence@gmail.com>
Subject: Re: [PATCH] Add IORING_FEAT_FILES_SKIP feature flag
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Jens Axboe" <axboe@kernel.dk>, <io-uring@vger.kernel.org>
References: <20210518161241.10532-1-sir@cmpwn.com>
 <2bbb982d-c9a4-8029-83e8-3041327e04dc@kernel.dk>
In-Reply-To: <2bbb982d-c9a4-8029-83e8-3041327e04dc@kernel.dk>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu May 20, 2021 at 9:32 AM EDT, Jens Axboe wrote:
> > diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_=
uring.h
> > index 5a3cb90..091dcf7 100644
> > --- a/src/include/liburing/io_uring.h
> > +++ b/src/include/liburing/io_uring.h
> > @@ -285,6 +285,7 @@ struct io_uring_params {
> >  #define IORING_FEAT_SQPOLL_NONFIXED	(1U << 7)
> >  #define IORING_FEAT_EXT_ARG		(1U << 8)
> >  #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
> > +#define IORING_FEAT_FILES_SKIP		IORING_FEAT_NATIVE_WORKERS
>
> I don't think this is a great idea. It can be used as a "probably we
> have this feature" in userspace, but I don't like aliasing on the
> kernel side.

This patch is for liburing, following the feedback on the kernel patch
(which didn't alias, but regardless).

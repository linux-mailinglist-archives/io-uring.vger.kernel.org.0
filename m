Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852A238BA4B
	for <lists+io-uring@lfdr.de>; Fri, 21 May 2021 01:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbhETXLI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 May 2021 19:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbhETXK7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 May 2021 19:10:59 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C671C06138A
        for <io-uring@vger.kernel.org>; Thu, 20 May 2021 16:09:33 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1621552169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q7VYybn0aXJJd/StjM+8v29xexpesdVyPqt+4hcZ+JE=;
        b=ywkxNbeGOwpuxNMajn0kF8O4OvLJx42SN2ahwZAHUVhSVN34H7/p3yqXRW80RB2XkJz/VI
        faq0Xt0a3MIz2Q83WS3Vb23DGKtSsClmt4zU2xyMdikqO09EYsOMYha20MXypda2MJlzh0
        36QOVjSazbv4BXSHvqj5FUI1LQB0xykKBChiRmxJHlfGl59kSf5/nur22UXxi7nSM+cVN7
        s8neT5z6BvV9KNIFTFzx87CLI9bFj+Emrd2vfiXs8BDHdrZ8855kBtEXNVmZO2kp/bk+YN
        7C8AEDCKoOnRZh1h6VxLekxha6/UshqksnOBYciiI7Plq4PjrJRCViOlJGOmyw==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 20 May 2021 19:09:28 -0400
Message-Id: <CBIG9Q8TNX28.EG15ID94GQPJ@taiga>
Cc:     "noah" <goldstein.w.n@gmail.com>
Subject: Re: [PATCH] Add IORING_FEAT_FILES_SKIP feature flag
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Pavel Begunkov" <asml.silence@gmail.com>,
        "Jens Axboe" <axboe@kernel.dk>, <io-uring@vger.kernel.org>
References: <20210518161241.10532-1-sir@cmpwn.com>
 <2bbb982d-c9a4-8029-83e8-3041327e04dc@kernel.dk>
 <CBIEOQ7BRJ0Q.3O3QZBY0ZZPFI@taiga>
 <ffc6e349-3834-a380-fc2c-c58bc15827bf@gmail.com>
In-Reply-To: <ffc6e349-3834-a380-fc2c-c58bc15827bf@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu May 20, 2021 at 6:54 PM EDT, Pavel Begunkov wrote:
> On 5/20/21 10:55 PM, Drew DeVault wrote:
> > On Thu May 20, 2021 at 9:32 AM EDT, Jens Axboe wrote:
> >>> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/i=
o_uring.h
> >>> index 5a3cb90..091dcf7 100644
> >>> --- a/src/include/liburing/io_uring.h
> >>> +++ b/src/include/liburing/io_uring.h
> >>> @@ -285,6 +285,7 @@ struct io_uring_params {
> >>>  #define IORING_FEAT_SQPOLL_NONFIXED	(1U << 7)
> >>>  #define IORING_FEAT_EXT_ARG		(1U << 8)
> >>>  #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
> >>> +#define IORING_FEAT_FILES_SKIP		IORING_FEAT_NATIVE_WORKERS
> >>
> >> I don't think this is a great idea. It can be used as a "probably we
> >> have this feature" in userspace, but I don't like aliasing on the
> >> kernel side.
> >=20
> > This patch is for liburing, following the feedback on the kernel patch
> > (which didn't alias, but regardless).
>
> This file is a copy (almost) of the kernel's uapi header, so better be
> off this file and have naming that wouldn't alias with names in this
> header.
>
> I think that's the problem Jens mean. Jens, is it? And I do still
> believe it's a better way to not have an itchy one release gap
> between actual feature introduction and new feat flag.

It does itch, but I don't think it's actually wrong, per-se. Unless we
expect features to be removed or optionally available, it might make
sense to have used an incrementing number rather than a bitfield.

What should userspace programs do if they're not sure if they can use
FILES_SKIP? What was the previous behavior if -2 is used? I'm guessing
it was EINVAL, EBADF, something like that.

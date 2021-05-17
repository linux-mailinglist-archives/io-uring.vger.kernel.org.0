Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D84386DA4
	for <lists+io-uring@lfdr.de>; Tue, 18 May 2021 01:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhEQX0h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 May 2021 19:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240516AbhEQX0g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 May 2021 19:26:36 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFBAC061756
        for <io-uring@vger.kernel.org>; Mon, 17 May 2021 16:25:19 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1621293916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=luP+IIIcjcSoD7A4/FoLgXOAyS3hVQ6hBIMQ1v9/C3g=;
        b=cUr0akqvzktpNbRMhGyJvOv3I/nBFot6f13Uk6+BnV4tbv2sNj6tt3FFLZpMiHlPsdINL1
        SLgJRLwf7qXtXDclyMJAoEIDiKIONBukvYr9q8bN/utKrDNbpmrNCabkQpF4UL6mVRUqt/
        qzge8YGqSmygi7owCfaRqYbNkP1D7qltSKElTSP9wtqFyJEYzfvt6cCUIVEs/9fBu50eGc
        //7SOuk4Hrs92k80ePzgibecaj/pOqcqLHGgqrRXhK7/teR3nSjXlNCOM/BgGdxo93N7JM
        0JklMl72aV6Fjgp4jg79OyYDQXLNClKsaxfJ2vdIrUVM1fnhU7cHtmUxJUFZrw==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 17 May 2021 19:25:14 -0400
Message-Id: <CBFWQ64F7PWU.3EOQ3BQXFHZY7@taiga>
Cc:     "noah" <goldstein.w.n@gmail.com>, "Jens Axboe" <axboe@kernel.dk>
Subject: Re: [PATCH] io_uring: add IORING_FEAT_FILES_SKIP feature flag
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Pavel Begunkov" <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
References: <20210517192253.23313-1-sir@cmpwn.com>
 <b836b9cd-e91b-7e46-ce29-8f32e24fb6ab@gmail.com>
In-Reply-To: <b836b9cd-e91b-7e46-ce29-8f32e24fb6ab@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon May 17, 2021 at 7:19 PM EDT, Pavel Begunkov wrote:
> On 5/17/21 8:22 PM, Drew DeVault wrote:
> > This signals that the kernel supports IORING_REGISTER_FILES_SKIP.
>
> #define IORING_FEAT_FILES_SKIP IORING_FEAT_NATIVE_WORKERS
>
> Maybe even solely in liburing. Any reason to have them separately?
> We keep compatibility anyway

What is the relationship between IORING_FEAT_NATIVE_WORKERS and
IORING_REGISTER_FILES_SKIP? Actually, what is NATIVE_WORKERS? The
documentation is sparse on this detail.

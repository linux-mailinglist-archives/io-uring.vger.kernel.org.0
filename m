Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1815621C521
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2020 18:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgGKQRF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jul 2020 12:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbgGKQRF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jul 2020 12:17:05 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14083C08C5DD
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2020 09:17:05 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id u8so3998305qvj.12
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2020 09:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LNnArQQnn8L2tqPnidmsMdfebleLTdlkyERObBvE6Xk=;
        b=fB61mZ9Szh/AQ0TfqjkGvCXjAAgT5OIf5W9IsDjrBq+0Gmh+PYcXIIuHDMhsT70u1T
         hu1FKioVxabgTlGYEQdmZvZNYFY+x+k08KBO4zAXmTIi9hoEnA6Kgh70xLATx/juSUDJ
         uU3fY7hnliysHDIpo4iKcR6adOfKWY2YrFGByrKyldSvHtpmQ/RtZF++l7iQSMOp0zwV
         20d+5La0Xeh6uhbXXpNiVEpeFqTicA2ez1z2b597Ci8novjmJrwktjJyeBa9L7hDL96Y
         ktXJewuLfj5Lfy8tiPedthQlbo6f1rJynn7+re5L1ty+PRl4Ac8PJPq0Cd1+h8eRWtvU
         dcjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LNnArQQnn8L2tqPnidmsMdfebleLTdlkyERObBvE6Xk=;
        b=nXOL5+yxMtYtFPO3rw1m9WKb3EKOFIMfSxBIgJflGgHKM/LIKI8vgHXyT1jTJINc9E
         oQc4YkG594ByGCFP2FyfAoNiN/pIj/vtdyXB0e86iXV/2By+qSRiBgRE5VVHPv3lTEdB
         MSg3XAnyZ8RlOVslJHS76MQs0677g8c+OJDHesN1+zngkKJt1HSFCnrlJZ0cz8rQg7U9
         CUu4hMMiYqPysuUJbq1dvljufzy+WKYp9yfINMeDv7k0hyj8LgjSdnj8aBL3VRKO6huO
         W/IKoeIW94BtvR19fu1K43gRfd+mwdTsAN1XrlX2F/oIWfEvC2PLDK4fmRfblBeCt4zN
         h0Vw==
X-Gm-Message-State: AOAM532f0VWS8+fSXO+M8igQa8BQPKepxXguNkyRHAxWvqQ5vzFXqgCu
        YYAaE9kanm/ZqtrBK16qg4XM+AAj3Ozm7k/dV0WHa6HK1vs=
X-Google-Smtp-Source: ABdhPJzgQPTWB3zQoMub0wGYWlEWxCCeAXNSLg9v9qgyuivDy8VUW2gSJstW0OZmUdwO4fMIonYcuv+0k0EVQR3Q+AA=
X-Received: by 2002:ad4:408b:: with SMTP id l11mr17762217qvp.80.1594484223692;
 Sat, 11 Jul 2020 09:17:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200711093111.2490946-1-dvyukov@google.com> <7d4e4f01-17d4-add1-5643-1df6a6868cb3@kernel.dk>
 <CACT4Y+YGwr+1k=rsJhMsnyQL4C+S2s9t7Cz5Axwc9fO5Ap4HbQ@mail.gmail.com> <7f128319f405358aa448a869a3a634a6cbc1469f.camel@venev.name>
In-Reply-To: <7f128319f405358aa448a869a3a634a6cbc1469f.camel@venev.name>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 11 Jul 2020 18:16:52 +0200
Message-ID: <CACT4Y+Y36NYmsn1nA16YFzLDU_Gt1xWZF+ZXvbJr9y-0qqP+DQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: fix sq array offset calculation
To:     Hristo Venev <hristo@venev.name>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Necip Fazil Yildiran <necip@google.com>,
        io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jul 11, 2020 at 5:52 PM Hristo Venev <hristo@venev.name> wrote:
>
> On Sat, 2020-07-11 at 17:31 +0200, Dmitry Vyukov wrote:
> > Looking at the code more, I am not sure how it may not corrupt
> > memory.
> > There definitely should be some combinations where accessing
> > sq_entries*sizeof(u32) more memory won't be OK.
> > May be worth adding a test that allocates all possible sizes for
> > sq/cq
> > and fills both rings.
>
> The layout (after the fix) is roughly as follows:
>
> 1. struct io_rings - ~192 bytes, maybe 256
> 2. cqes - (32 << n) bytes
> 3. sq_array - (4 << n) bytes
>
> The bug was that the sq_array was offset by (4 << n) bytes. I think
> issues can only occur when
>
>     PAGE_ALIGN(192 + (32 << n) + (4 << n) + (4 << n))
>     !=
>     PAGE_ALIGN(192 + (32 << n) + (4 << n))
>
> It looks like this never happens. We got lucky.

Interesting. CQ entries are larger and we have at least that many of
them as SQ entries. I guess this + power-of-2-pages can make it never
overflow.

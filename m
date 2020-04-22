Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFD81B3A02
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2020 10:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgDVI1h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Apr 2020 04:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725811AbgDVI1h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Apr 2020 04:27:37 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCE2C03C1A6
        for <io-uring@vger.kernel.org>; Wed, 22 Apr 2020 01:27:36 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id t63so1260204wmt.3
        for <io-uring@vger.kernel.org>; Wed, 22 Apr 2020 01:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daurnimator.com; s=daurnimator;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Gtj2gwV4AVCr2al2GPmJtFyaeakVl+PxNigrn8lVSYk=;
        b=TRIv6S9J+/2purFW94ZbHbaVN+t17OZqe2NY9pTciTmS3qfpXKP5RbtIKTadoCJkhH
         JrLfZucciQk+B5CURlt1b3fyiti9JSh28G5HFaaPj8pUyUBMinNui1RF0k+/pCwLRxAV
         yN5dYcdXcXaQV+1GbKMg4p+B84CXut0HvTckQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Gtj2gwV4AVCr2al2GPmJtFyaeakVl+PxNigrn8lVSYk=;
        b=r6nv76pUqq/b7bMlw4b3flxw5PkVX6IMYijWtqc2CtEz2tE4OMPpkwy1jtrJwXCvTw
         v0Rwx3/bWo8MYi1//12ImBCNMaOeq/2QOR8Kq6bRFhCYWAKyxjWAXEigcvzgDTxR8lgL
         hr3rgwDgwY9QaHi5iQ+CiQfh9rTHqngKsClmwu1W+1Ttya3vIB+GQxMraALlsbWQSqha
         T4Iwu633TqhbwAe0rJE/LaXXfrA1bfxW7TIGdtPIYDzp9tKIJhr1oHc1iRb1Vb1YUTaz
         qJ3sleld8BvC9IH0CFuXUWe74k8KDXQHh0xq91oEdSJvH93RQZBMG8kMlPBkHgHiPeMG
         Yv4A==
X-Gm-Message-State: AGi0PubvNnaabWEvEQpSZuFRkzKb5v9TKbD2A/KjYMv46ezJYHfMA1gW
        k7soOflAT36Jlzb+kLEjhKXGgd81ZgXy0wgHHpwCwg==
X-Google-Smtp-Source: APiQypLys21v2XA3w7wPgbknTcuipVrxWwgEobgm9uqusSUVMzDY93NqngoXEYHzXojhCFjQrkM3Xqd6jQWQl/29iNU=
X-Received: by 2002:a1c:7215:: with SMTP id n21mr9594288wmc.145.1587544055597;
 Wed, 22 Apr 2020 01:27:35 -0700 (PDT)
MIME-Version: 1.0
References: <233BE31C-B811-4715-97B6-7E3F965A5137@icloud.com>
In-Reply-To: <233BE31C-B811-4715-97B6-7E3F965A5137@icloud.com>
From:   Daurnimator <quae@daurnimator.com>
Date:   Wed, 22 Apr 2020 18:27:23 +1000
Message-ID: <CAEnbY+dyDgb=0dq=1Vfo5qKVEps8U88azO_ufPFcf55GSTxquA@mail.gmail.com>
Subject: Re: Feature Request: SQE's flag for when you are not interested in
 the op.result
To:     Mark Papadakis <markuspapadakis@icloud.com>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 22 Apr 2020 at 18:13, Mark Papadakis <markuspapadakis@icloud.com> w=
rote:
>
> When e.g manipulating epoll state via its FD, most of the time you don=E2=
=80=99t care wether e.g EPOLL_CTL_DEL succeeds or fails, or you know that i=
t will =E2=80=9Cnever=E2=80=9D fail. In such cases maybe it =E2=80=98d be b=
eneficial to support another IOSQE flag which, when set, would instruct the=
 io_uring to not include a matching CQE for that SQE when processed.
> It=E2=80=99s not a big deal, per se, but it would probably help somewhat =
with performance.

I don't know if this makes sense: it could always fail e.g. due to a
security module.
And because you always need to check for failure, you need to know
when success happens so you can stop tracking for possible failures.

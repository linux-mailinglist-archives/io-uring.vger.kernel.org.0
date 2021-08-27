Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F5B3F9216
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 03:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243938AbhH0BlU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 Aug 2021 21:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243923AbhH0BlT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 Aug 2021 21:41:19 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAAFC061757
        for <io-uring@vger.kernel.org>; Thu, 26 Aug 2021 18:40:31 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id x11so10516233ejv.0
        for <io-uring@vger.kernel.org>; Thu, 26 Aug 2021 18:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=5l6dY2NSfDTkTi5u2ZAKaNv+XU1y8Ly6QGKk5ZWSkiM=;
        b=oQkGWFb67E9R3i7EN1ekhE2qGzNQPgN2ZMRA5O3fSqswSJEoquF8Wf6wY3mpP21lAX
         Jp54vKamAAilcUbGLXZug0FnxNLTAhYscfnRXAQBBMTd3vjOKxXF2jzaNdzGUVrpd/Yh
         BGmZDCVU7N3v9f6sQM9qp9F7jIoIDl8xVi4GtURxvQ8+xBzNyORshe0W1UaiNlK+f1fe
         lGcHDPLyQwRMP61aMgu2NwjXHFBoe5EIni15fIkqXsAmtJ1sXao3zQGqlq41b/o8z/55
         mHoFgfRQhs+o9S4FMoVI+nu/PXOaUQLiR/ok6xsVw2c0mVmewJ4f8NdybsaOLViNmc7T
         yopA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=5l6dY2NSfDTkTi5u2ZAKaNv+XU1y8Ly6QGKk5ZWSkiM=;
        b=j44R8w7nkJufjHAsR0SgrBcqdvcKVLPkXrxTxOsEVDKZVI2OlNzVZcCnNmTNWlIiR2
         7/m6REnSAWU9NyYdLmGFfavSWWKK3we/hYDELUXINlEYE0ykraNQUwK1vhq31SQPLDay
         vCr4f3PpMeaFMi5zn7UU6E2yStQoGxQJXNtqwNcvcybjn7ql78OI8nD/Uj1d61dTb9+N
         6AonH6GYnSqmGcX/Ft47q3kD3FRdRmeELdy3BVaOF4naOFWONj6Vkaci/G4qEHWVTvSV
         pO8ogIC+fCBMR+tK8DDAXs0oN65bTS/elPNr7GRhd2Mlf6TXFzTg7S223PWh3VTDrnpu
         8TWg==
X-Gm-Message-State: AOAM531EBFz8PFdCvOWr3p2/SGdMAd/3To+jerdegjbafU4K6VqO3iUD
        QemYlQ3L8xVBd83ms6DVT1jQgh7GY2Rd3MuDrEp3woSqaLrCQcj+LAU=
X-Google-Smtp-Source: ABdhPJyvblCKgK/JGp+S/6mQ0mbmXxZBalkG/NpZw/z76CYs2Cz8QjuUYpY/ZfISNYbYY0nvUWydw9KiIy6JIhx1M88=
X-Received: by 2002:a17:906:ac1:: with SMTP id z1mr7229977ejf.261.1630028429976;
 Thu, 26 Aug 2021 18:40:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAM1kxwhHOt1Ni==4Qr6c+qGzQQ2R9SQR4COkG2MXn_SUzEG-cg@mail.gmail.com>
 <CAM1kxwi83=Q1Br46=_3DH46Ep2XoxbRX5hOVwFs7ze87Osx_eg@mail.gmail.com>
In-Reply-To: <CAM1kxwi83=Q1Br46=_3DH46Ep2XoxbRX5hOVwFs7ze87Osx_eg@mail.gmail.com>
From:   Victor Stewart <v@nametag.social>
Date:   Fri, 27 Aug 2021 02:40:19 +0100
Message-ID: <CAM1kxwiAF3tmF8PxVf6KPV+Qsg_180sFvebxos5ySmU=TqxgmA@mail.gmail.com>
Subject: Re: io_uring_prep_timeout_update on linked timeouts
To:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 25, 2021 at 2:27 AM Victor Stewart <v@nametag.social> wrote:
>
> On Tue, Aug 24, 2021 at 11:43 PM Victor Stewart <v@nametag.social> wrote:
> >
> > we're able to update timeouts with io_uring_prep_timeout_update
> > without having to cancel
> > and resubmit, has it ever been considered adding this ability to
> > linked timeouts?
>
> whoops turns out this does work. just tested it.

doesn't work actually. missed that because of a bit of misdirection.
returns -ENOENT.

the problem with the current way of cancelling then resubmitting
a new a timeout linked op (let's use poll here) is you have 3 situations:

1) the poll triggers and you get some positive value. all good.

2) the linked timeout triggers and cancels the poll, so the poll
operation returns -ECANCELED.

3) you cancel the existing poll op, and submit a new one with
the updated linked timeout. now the original poll op returns
-ECANCELED.

so solely from looking at the return value of the poll op in 2) and 3)
there is no way to disambiguate them. of course the linked timeout
operation result will allow you to do so, but you'd have to persist state
across cqe processings. you can also track the cancellations and know
to skip the explicitly cancelled ops' cqes (which is what i chose).

there's also the problem of efficiency. you can imagine in a QUIC
server where you're constantly updating that poll timeout in response
to idle timeout and ACK scheduling, this extra work mounts.

so i think the ability to update linked timeouts via
io_uring_prep_timeout_update would be fantastic.

V

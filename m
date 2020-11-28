Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06E12C7218
	for <lists+io-uring@lfdr.de>; Sat, 28 Nov 2020 23:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgK1Vuo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 16:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387457AbgK1TJu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 14:09:50 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B145C0613D1
        for <io-uring@vger.kernel.org>; Sat, 28 Nov 2020 11:03:35 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id d17so10618935ejy.9
        for <io-uring@vger.kernel.org>; Sat, 28 Nov 2020 11:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=J5ztRFQCdtanNrHE25VrNsg+JV2YM93MTmAbQqGYIZI=;
        b=VPbhsY0tFjIj4sbEj3cHdAi+Bji8IOigXghtTWl0uNiHu+4Khoo66P2UtfUrTlihxN
         Y91eRle+vm4Z+SS6rEfskF86Z+lNJ+HQaty82qA6hpHGv/hCgyXD/g9FYCngIfte+9/Z
         PAlOlHKzbBLJiTQZ4irJ5q0IxJCWW6DRL5pHL0+0XqIfABOE1uxRD5LvdAKdgVW6YM7d
         DeuMo9JTB0sHaBDUovKBvsXTeFB0CWZUXWQseL5SH9FpiByO5356MNVSq0DYcHpgQjHY
         ecp5L8CKTRRfirH8AXWbxg4ibFigz/2ufl3imvhGJmBRpAWZ297lB/TslAfK2XD6MfZy
         E9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=J5ztRFQCdtanNrHE25VrNsg+JV2YM93MTmAbQqGYIZI=;
        b=IkrGES8ysqRptzSf42aHhVj/ghPhRVcy0zfOFP0WoOJueO05za6i/CSmaJHjXLOVYv
         xMmfNfuOo6aUm9HiWk15gV1WsRk0iK7LExqY6wX9MWMHIC31a+zojCEGpKRC4Q9mQEbp
         4N1M51vTNQdMjniR/QB70n0fHUI7331ONXKHIa4soN5Zr4g3+TsLmKzhvZeHWqQxtsuR
         EIBI/1xLKQOdUeK4uQiV02bfj4wyt3s78c/Hk1c15jCq/XNzjaJbyHdjCTjcxJ7Olxb6
         7KlOMyJPUdB9Zfq2XL5mwyvogRw5/3jBXSk6gUZnlEJif5E+hJvcmZKdzTwFeQRIoxUY
         WePA==
X-Gm-Message-State: AOAM530saCmiE/0HQkAdTqxNGau1gfwSSR1N+SsqfcGacnNzPnKknFHh
        CJqrEBHz8wWwLIKCuG/W/2amyiXhrFY4dO05+qFJSE+bFD+jUSve3kE=
X-Google-Smtp-Source: ABdhPJwmrBpgHdwwSHS4SMMmE/womAVdIhBBGHDJEHmK/MsoahjRVbI4dYyHUZM9P84yYq6JAAF/zXmp6lJnrs7CJTA=
X-Received: by 2002:a17:906:b143:: with SMTP id bt3mr13881847ejb.318.1606590213414;
 Sat, 28 Nov 2020 11:03:33 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com>
 <4bb2cb8a-c3ef-bfa9-7b04-cb2cca32d3ee@samba.org> <CAM1kxwhUcXLKU=2hCVaBngOKRL_kgMX4ONy9kpzKW+ZBZraEYw@mail.gmail.com>
 <5d71d36c-0bfb-a313-07e8-0e22f7331a7a@samba.org>
In-Reply-To: <5d71d36c-0bfb-a313-07e8-0e22f7331a7a@samba.org>
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 28 Nov 2020 19:03:22 +0000
Message-ID: <CAM1kxwh1A3Fh6g7C=kxr67JLF325Cw5jY6CoL6voNhboV1wsVw@mail.gmail.com>
Subject: Re: [RFC 0/1] whitelisting UDP GSO and GRO cmsgs
To:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Nov 26, 2020 at 7:36 AM Stefan Metzmacher <metze@samba.org> wrote:
>
> Am 23.11.20 um 17:29 schrieb Victor Stewart:
> > On Mon, Nov 23, 2020 at 4:13 PM Stefan Metzmacher <metze@samba.org> wrote:
> >>
> >> Hi Victor,
> >>
> >> wouldn't it be enough to port the PROTO_CMSG_DATA_ONLY check to the sendmsg path?
> >>
> >> UDP sockets should have PROTO_CMSG_DATA_ONLY set.
> >>
> >> I guess that would fix your current problem.
> >
> > that would definitely solve the problem and is the easiest solution.
> >
> > but PROTO_CMSG_DATA_ONLY is only set on inet_stream_ops and
> > inet6_stream_ops but dgram?
>
> I guess PROTO_CMSG_DATA_ONLY should be added also for dgram sockets.
>
> Did you intend to remove the cc for the mailing list?
>
> I think in addition to the io-uring list, cc'ing netdev@vger.kernel.org
> would also be good.

whoops forgot to reply all.

before I CC netdev, what does PROTO_CMSG_DATA_ONLY actually mean? I
didn't find a clear explanation anywhere by searching the kernel, only
that it was defined as 1 and flagged on inet_stream_ops and
inet6_stream_ops.

there must be a reason it was not initially included for dgrams?

but yes if there's nothing standing in the way of adding it for
dgrams, and it covers UDP_SEGMENT and UDP_GRO then that's of course
the least friction solution here.

>
> metze
>
>

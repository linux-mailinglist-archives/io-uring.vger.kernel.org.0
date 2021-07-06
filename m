Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4453BDA76
	for <lists+io-uring@lfdr.de>; Tue,  6 Jul 2021 17:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhGFPsy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Jul 2021 11:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbhGFPsy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Jul 2021 11:48:54 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5484C061574
        for <io-uring@vger.kernel.org>; Tue,  6 Jul 2021 08:46:15 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bg14so34864851ejb.9
        for <io-uring@vger.kernel.org>; Tue, 06 Jul 2021 08:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=minter-ltd.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=IkF7egv9BNNazamO+7yGIWy4rZpf81YvXaC6+IMPkWQ=;
        b=1R94P96FVn4xMWvszAr/gXxnRoy22MyJBoxBnGsTItngHOK1n8jQYe21f2rMur+BSx
         yoeldFZGYGE54Ods4AaUgbKZFz3TLKXmNTuAzy4Dx2iujbuCZwMUEihdNEW7f/HTdac+
         hZW3qu/FOMpn1ywYJBD2Yqqafb3Zngl6RQK4pXXtyi1iKOqP6OkCpxdEBKYoiBV9JXb/
         PnoyzpIbxo+9zR8x8hy8x6xjPiKeJg/0vpIZxYdfdvC1dYokDEtEtDQZuh0Xdo7aLUfC
         AloDIiMEYaaz37rEsQha3Juva/wRQTZBFJpx8I4l6npDJJu+fODR2YjA9e0NxiBqfZJf
         oe8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=IkF7egv9BNNazamO+7yGIWy4rZpf81YvXaC6+IMPkWQ=;
        b=Qp/sotTmjZvNcScqzzJ7SH/G+o1ZVJio1ERyfPS6zh9AFrGTNVXd7H3PFCJilKGTEZ
         kjXqKm6CHvrLdTTGJ/wF8rl7RatHTsj5Jf31eoZ7QvIiw7Uv4Qp3wuxLMGPBaIJSIjYc
         0QtFlTZofVje+SDNsiUqf0xX/t1x6qCCGLkVF9qMMr6GWHJhkg08nAPzhTfVroyqLpPE
         xyJXpqV1YgAeUivkVemrHhY/FGGTmtIiefIObHVGEZHW475ngd3LErZpxBO8wMyVPbSP
         eS9VBR+Q8Qdfba0p0HC9Z1mVMpaU0hGKay+KMFgVowY4R4koCwJqWg2fKjMBvkzzRtpd
         x2iA==
X-Gm-Message-State: AOAM530bUBskrLgS1+TLAsKFlUvQcDXjA+0h4zBRtEXAVaLvFXRMvdRv
        3t7RY6Nb+p9gPdydvwhMG0btp9NYc70Qbc6/ODqdNB/vaOpCh5bGkRk=
X-Google-Smtp-Source: ABdhPJy9n5tNOR59riPxGtPDo9xYpgKpwqmpuCtKiiJWiz0AgD8OL22s/+8GP2rzwf45NSN9S4y5htIXPQdTBuEazf0=
X-Received: by 2002:a17:906:2306:: with SMTP id l6mr18902672eja.362.1625586373344;
 Tue, 06 Jul 2021 08:46:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAGxp_yhoUAAvbttOaRvWx3EsmPKZVumFZQz2uQGUPGhuN8AiVQ@mail.gmail.com>
 <d322265e-4863-4087-8f74-ae5d2d668980@gmail.com>
In-Reply-To: <d322265e-4863-4087-8f74-ae5d2d668980@gmail.com>
From:   Mauro De Gennaro <mauro@minter.ltd>
Date:   Tue, 6 Jul 2021 17:46:02 +0200
Message-ID: <CAGxp_yjChwCTcHa6PqM9-KEo5efann9brxW5+5gB_8YhooMCLQ@mail.gmail.com>
Subject: Re: io_uring/recvmsg using io_provide_buffers causes kernel NULL
 pointer dereference bug
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Great, thank you. Something I forgot to mention on the Bugzilla ticket
is that recvmsg() always returns the same provided buffer id even if
this buffer is being currently used in user space and hasn't been
returned to the kernel. For example, if you provide 100 buffers (ids 0
- 99) and never return them back to the kernel after each recvmsg
call, then further calls to recvmsg() will keep returning buffer id 99
until the kernel runs out of buffers. I suspect the kernel null
pointer dereference bug might be related to this behaviour as well.

Thanks again.


On Tue, Jul 6, 2021 at 12:47 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 7/4/21 10:50 AM, Mauro De Gennaro wrote:
> > Hi,
> >
> > First time reporting what seems to be a kernel bug, so I apologise if
> > I am not supposed to send bug reports to this mailing list as well.
> > The report was filed at Bugzilla:
>
> That's exactly the right place to report, not everyone monitor
> bugzilla, if any at all. Thanks for letting know
>
> > https://bugzilla.kernel.org/show_bug.cgi?id=213639
> >
> > It happens on 5.11 and I haven't tested the code yet on newer kernels.
>
> --
> Pavel Begunkov

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7527A3B2D0C
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 12:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhFXK6T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 06:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbhFXK6T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 06:58:19 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B7FC061574;
        Thu, 24 Jun 2021 03:56:00 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id j184so13299360qkd.6;
        Thu, 24 Jun 2021 03:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/e/qEaOn8AYiDoFE2tjtFv5KON/qdc3GwFf003F+wGQ=;
        b=m252wepPDnEzZvnX4Xf0lUdlfC7C08RVGhwrJ6CVaoG3ancv89qBpCT6lEPAZiVPaK
         niGmfj8DudFylYtNwdkjuxXwxmr1W/uzbZEaJyUTa5MXdxK9b2CthH//dlxorPRChp7/
         gtKjVvZ0F02kans264BuQgFe42hZNfAmO9x65rBLMa+5rhMX9NKZljJ7pOcXba7zhjsA
         aHLaa4NOZQY+Z2LOBYKsO1ij/NSE8JBH1O4VLpm661MsH8PgRM0rtIfJk9BgXvRJC2xX
         xweI7ZX9fQWwlLpZVJfkWQslBxwHvO98YRwCZUxBoDnhLuJ0Xw6WRBSUKv7paJT4/nPb
         YEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/e/qEaOn8AYiDoFE2tjtFv5KON/qdc3GwFf003F+wGQ=;
        b=RTOM6dWNHD+fo2e0cx+tmzQvag9rx1de7TLCd4foiiFL7SLKMRWuNEhxb/0jKFEG/d
         Eo7fvlO7JkBSTcKlPPCOHcPagG82gN74AlqLU4TC+86931rcVHIjP7GiJ9s2IUF/qX7O
         s8zwKnNWOxSJICo77mes2LDQd/vscCxZdi1eVFmGhCnDFP50pjNxpb9krVFAh0Vm6RFV
         EogMJBwC6P4noS7I0yIpEYQBj9c7zaDRPqReNzHWEbQVW3tPD/PHlETaovbC4f1wVr5I
         3mc3cNL6DhFqIc55Xg5eCxnZWA7FYu/aC7twrI1HwwFsTESMs9VNFRUWVv116EKQshBO
         zKZQ==
X-Gm-Message-State: AOAM530yA4W6MRm0F4QsdQ2Zkc+9VftczBhgmORAMMVP3a1w+FtN6/Og
        fWb32X2uloBUWsKbOG0R+AkRCh3vwHGNz+aePIA=
X-Google-Smtp-Source: ABdhPJwrUJe7wgwtACcT00yohgNAguLrhFGEvA1SeraQeOrVHfAsqx3lTal2NoO2i8TbFcw024bcIyghh2JwkMc/Wec=
X-Received: by 2002:a25:360d:: with SMTP id d13mr4063200yba.375.1624532159540;
 Thu, 24 Jun 2021 03:55:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210603051836.2614535-1-dkadashev@gmail.com> <ee7307f5-75f3-60d7-836e-830c701fe0e5@gmail.com>
 <0441443f-3f90-2d6c-20aa-92dc95a3f733@kernel.dk> <b41a9e48-e986-538e-4c21-0e2ad44ccb41@gmail.com>
 <53863cb2-8d58-27a1-a6a4-be41f6f5c606@kernel.dk> <CAOKbgA4POGxPdB02NsCac4p6MtC97q6M3pT09_FWWj41Uf3K2A@mail.gmail.com>
 <43b17e64-4c56-93d3-1724-2673d5b639f3@kernel.dk>
In-Reply-To: <43b17e64-4c56-93d3-1724-2673d5b639f3@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 24 Jun 2021 17:55:48 +0700
Message-ID: <CAOKbgA6Ofvf3FuTKUb6PNLZy_eyDxLCouGcqY2GfHfZa_dJuiw@mail.gmail.com>
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 24, 2021 at 9:37 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 6/22/21 11:49 PM, Dmitry Kadashev wrote:
> >
> > Jens, it seems that during this rebase you've accidentally squashed the
> > "fs: update do_*() helpers to return ints" and
> > "io_uring: add support for IORING_OP_SYMLINKAT" commits, so there is only the
> > former one in your tree, but it actually adds the SYMLINKAT opcode to io uring
> > (in addition to changing the helpers return types).
>
> Man, I wonder what happened there. I'll just drop the series, so when you
> resend this one (hopefully soon if it's for 5.14...), just make it
> against the current branch.

Sure, I'll send v6 shortly

-- 
Dmitry Kadashev

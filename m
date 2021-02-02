Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417DE30C57A
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 17:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236344AbhBBQYZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 11:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbhBBQWV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 11:22:21 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494F7C061223
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 08:18:12 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id y9so9239860ejp.10
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 08:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e41Chdr3RCmTRt8T8rqQSUmhrlk9J9m2dlC0qwMOX8E=;
        b=GzKQj0DipECC3+EEI1Ybw3Epe1sm7Me+RK29hVXNYa5oqD5KnYEYJZ54A4OxuslysQ
         dI2BPZl2heO8MFqJkLnrzeCOuYTBflAJibD+VGH6ZI3XoFUeOpw9DEqEQvxoFWg9Edhf
         RPtRXkfHMZF2RVEJsBkwMefY5MP/IK8vhqSlhVhh8Iq5PJhWGPBaBwh8n3wEWn1OfiXg
         g5O8WyAh4ml6xIO4y8IIz9leqvnqKGsAwqAheakunIgTQyIOEjD/HQMIpd0frNdbftnr
         9TaawEmaihAJm+wWcIU59LLTJXSV8T79NqwJsYMb0YemSXCmrjW7J4LaJd03mMAi6y7p
         KOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e41Chdr3RCmTRt8T8rqQSUmhrlk9J9m2dlC0qwMOX8E=;
        b=FjoFlp4PldsJKGTzHdxaauYlXL9sFzNMFCQyhl8CkdNoeLGDHpMs7txTsxu08XAKGa
         rlTbwnBmfUOhw0yMo1WIy8e4DMu+N8/mZWqqXCBW/50Sye29peLP+7m6INgrgbeUbXnH
         GxSs+hRXpkFPAZtvQMeIdcPByXwaL0f6Kp9kZsx29MZc8yG99JAuooaz275bWLw/9xFS
         b+n+nI4smPz7nDEEh9wsX0Ce5UHJ1Z2KmnFYTOe5rVAxSe2QYbk/2cOuiVZ+KTyIS4Jw
         7Ut2ccw/JIEPAHunWTPkh8wYYHXYjzw3uDqjG52jI4bsIFnXsJ38IHQnm2pbZoB7wDXZ
         azjA==
X-Gm-Message-State: AOAM533OpDbCtyNBma4WlHPnaGyfcMVtVGrkRHfflQfloGgFxEXIdIao
        QzStsVl5kMPy78sW41fy4MTLmOMlnFYdzTFUbsbNYw==
X-Google-Smtp-Source: ABdhPJynZho0yXRI5F7CPrlKyocCI0NpQzEBGlvzu7DRDXMvleGU6Ml+rRmFSFcbN6C2Q1iSYzyb8zjsgWESedjUwyE=
X-Received: by 2002:a17:907:767c:: with SMTP id kk28mr12193813ejc.98.1612282691074;
 Tue, 02 Feb 2021 08:18:11 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com> <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
In-Reply-To: <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
From:   Victor Stewart <v@nametag.social>
Date:   Tue, 2 Feb 2021 11:18:01 -0500
Message-ID: <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com>
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> > Please don't forget about checking error codes. At least fixed
> > files don't work for you because of
> >
> > int fds[10];
> > memset(fds, -1, 10); // 10 bytes, not 10 ints
> >
> > So io_uring_register_files() silently fails.

well i'm glad this one was my own careless error. fresh eyes are
everything. you're right, bad habit of ignoring return values lol.

> Also you forget to submit, all works with these 2 changes.
>
> When you don't do io_uring_submit(), apparently it gets live-locked
> in liburing's _io_uring_get_cqe(), that's a bug.

in the comments above io_uring_wait_cqe_timeout it says it submits for
you, that's why i didn't submit here. but i guess great if that
exposed the _io_uring_get_cqe bug.

thanks so much for taking a look at this Pavel

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F76C2DF1AE
	for <lists+io-uring@lfdr.de>; Sat, 19 Dec 2020 21:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgLSUxH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 15:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgLSUxH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 15:53:07 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510EFC0613CF
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 12:51:53 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id l7so2688529qvt.4
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 12:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V4gwFFVxgC1kbe66PaC9OeQzNbfIju+EFerISZFmgQM=;
        b=s+XAkDQOH26pvHvQAdkbbGbs5Zs2rbqJ2g6Q8LzqFRJ0itpYeCme2R5e/XkN3psd0e
         Se6sPSA6QobrRuqyOreYU9BY5bMfs/qTa1cCtG13jucnyifYirZ5b4V2JHviyL7hsrrj
         tbyeujlPSB1t+ZSIjuapm5IsUySr67D08rJA8YQDrV3qWDiofirpg+LHaBjjy9cBkucP
         NLuVhc26858p6x4llTRfAxkJwMHQ5x5E0sqytrDV5LG4+oEAwuX4aQjBhJVqLxQdcw+o
         W8yZ5R3wAyx/0tVeChlFxjX/hM4RvcrjjYBTXIlg9SYUfMrBUuOT+Zw3EQaYUren+0zH
         HeUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V4gwFFVxgC1kbe66PaC9OeQzNbfIju+EFerISZFmgQM=;
        b=nyXnHPFXoAh7ec66X7agy4Dk9RjO6jvu/8b0JMaKZeg0ijGCxTRBLebe2dBY9Szf2m
         1d4clh2Tr2/QSb7eaphCVjmnUrE81blgoxI+W0phRrv4vPpzhKsUM0gTGFant1+itp1V
         DoV/CFK8sRnH2NDqtVI8Gs1LurDG0H4nJwrCRmesrjVQuYNT4YN0TX1dkf/AdN1o4kOl
         XJ7sDHuulbztzQDwMK3W5j4X+Xum9jDSg2wf8PdHtOrOYXC5RGn4bH3oTmpQaN62hWMw
         A1F0EZWfzuCBbJnhCllf0T3vYs16xbjg4KMNN64SEXSXwWbqX/d2gFBSstTZT0wGAjxz
         IzxQ==
X-Gm-Message-State: AOAM530g311ZrBsdr1ReySrNRxODsgBaxNAv/8GzJr76z0ONVChiXifG
        oZFrf6ck7D9lw7QT7qe3f8a7OlT18fxbcpiZ0jo=
X-Google-Smtp-Source: ABdhPJwbhcuuAxh+3Z2SqFPqdA6rpCakU38QyDiFXiescpjGAQAxtMml2ixjSQYJiTXDG6PRjL9J/Ni1jeH+DUzW8HQ=
X-Received: by 2002:ad4:4ee3:: with SMTP id dv3mr11285964qvb.58.1608411112502;
 Sat, 19 Dec 2020 12:51:52 -0800 (PST)
MIME-Version: 1.0
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com> <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
In-Reply-To: <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Sat, 19 Dec 2020 21:51:41 +0100
Message-ID: <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Norman Maurer <norman.maurer@googlemail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> And even more so, it's IOSQE_ASYNC on the IORING_OP_READ on an eventfd
> file descriptor. You probably don't want/mean to do that as it's
> pollable, I guess it's done because you just set it on all reads for the
> test?

yes exactly, eventfd fd is blocking, so it actually makes no sense to
use IOSQE_ASYNC
I just tested eventfd without the IOSQE_ASYNC flag, it seems to work
in my tests, thanks a lot :)

> In any case, it should of course work. This is the leftover trace when
> we should be exiting, but an io-wq worker is still trying to get data
> from the eventfd:

interesting, btw what kind of tool do you use for kernel debugging?

-- 
Josef

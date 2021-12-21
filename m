Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FA447C4E4
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 18:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240338AbhLURWW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 12:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbhLURWV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 12:22:21 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C12C06173F
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 09:22:20 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y22so54958748edq.2
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 09:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RciAcnWyVHWI3EHz4UlmUBMKLfdlkLS3DXjlC5GePT0=;
        b=cjvZQXVO+yHzd3mZg0uoHHs2c8B3Ix1oGnL/jHK6ue6lmvuhiKGSQTA4n/z1XfEQls
         glhwCS7oNUlwMlYC3iPo1WclkyEYk3k+5AC7hQNooGKfMc7fFjTUzBbeosM7O16o14V6
         +AvQmIW+AKMtnS9LSu1l0C0SXGsmXH1qBws1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RciAcnWyVHWI3EHz4UlmUBMKLfdlkLS3DXjlC5GePT0=;
        b=Il2CR7QHh2mUftRP02ao/8MVpMe3L+yHTEMCzPd6pwjxdfZj6NV1n2psYpTBqr4RcL
         nCv2aT2/DUXApgWjnjvCsmMN42wIQGXZSnKzWNhkrfgLY7eA7/iOjpo6P/PVUJFQEln+
         4G3rImyIVRJsAHDXa+E9MuFnSlyp2AjROFe7oJ3yTAYJEWtr315ovYKa5lhD4bbIxkOv
         RhD+K0R20pQtryvztb0NRdpJrsqxvJL/92BLVBmr4IycjbKOohyltRG6ezLOp2yEkFG/
         dnf0JqRpluxlduHoU5kqYnjnUxYPvsRPfMPSKtS+9rKlr/vcZW7eQXoA75zhJ577YMh7
         uahA==
X-Gm-Message-State: AOAM530r72//iqtgNCBiLI1IDmJ01cWj9CP5xypjQLetZ4FPMcIPY9dU
        osHIlSXJQlWaatlFhGK+jswegbgpHiQF/Pj4fRA=
X-Google-Smtp-Source: ABdhPJwmJBWIr914q4icmhDJW+FuY5k5UOQoy7rbAF/0h7ZRSic9ka6gFLIHvWoIXp/Wjsfi2jNZDA==
X-Received: by 2002:a17:907:d8f:: with SMTP id go15mr3752827ejc.501.1640107338898;
        Tue, 21 Dec 2021 09:22:18 -0800 (PST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id bx6sm3202469edb.78.2021.12.21.09.22.18
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 09:22:18 -0800 (PST)
Received: by mail-wr1-f41.google.com with SMTP id q16so28365239wrg.7
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 09:22:18 -0800 (PST)
X-Received: by 2002:adf:d1a6:: with SMTP id w6mr3336062wrc.274.1640107337991;
 Tue, 21 Dec 2021 09:22:17 -0800 (PST)
MIME-Version: 1.0
References: <20211221164959.174480-1-shr@fb.com> <20211221164959.174480-4-shr@fb.com>
In-Reply-To: <20211221164959.174480-4-shr@fb.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 21 Dec 2021 09:22:01 -0800
X-Gmail-Original-Message-ID: <CAHk-=whChmLy02-degmLFC9sgwpdgmF=XoAjeF1bTdHcEc8bdQ@mail.gmail.com>
Message-ID: <CAHk-=whChmLy02-degmLFC9sgwpdgmF=XoAjeF1bTdHcEc8bdQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/5] fs: split off do_getxattr from getxattr
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 21, 2021 at 8:50 AM Stefan Roesch <shr@fb.com> wrote:
>
> This splits off do_getxattr function from the getxattr
> function. This will allow io_uring to call it from its
> io worker.

Hmm.

My reaction to this one is

 "Why isn't do_getxattr() using 'struct xattr_ctx' for its context?"

As far as I can tell, that's *exactly* what it wants, and it would be
logical to match up with the setxattr side.

Yeah, yeah, setxattr has a 'const void __user *value' while getxattr
obviously has just a 'void __user *value'. But if the cost of having a
unified interface is that you lose the 'const' part for the setxattr,
I think that's still a good thing.

Yes? No? Comments?

              Linus

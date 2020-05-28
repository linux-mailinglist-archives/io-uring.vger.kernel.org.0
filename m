Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD471E699D
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2020 20:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391451AbgE1Smu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 14:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391450AbgE1Smt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 14:42:49 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1EEC08C5C6
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 11:42:48 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id h3so1215599ilh.13
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 11:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lonelycoder.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vnb8FWmKkNgLEb+qcofOf2hg5Xo/Qk5YN7bYZJpXeLg=;
        b=RaYkaZwdIjiY3bhv5/xLykgyiQtFpNW4PDTm9gUw+FyMRU00sVx4fOAZjj1FGhZZcG
         dw2z/xGX3r56q7r+d4dw5PhCXGCjx3eT+0sWdMYl0LpuKG8UR0gdWL6GV9boLJImgsRT
         E69v76O2+PgoOvZjJfPP1T75CQFLi+Y6q/7nXgkRuIvCcgtW3nZ3lpWKxNO3coUAGBCS
         OERm4rdfcm+JJ/8FjDsg0dEsltlh9rZtXiGXFufyZGpSdHK/4BxVcYNItVDbvqf+QpYN
         Fs6E7lV5KBJMio6buk0cZTnNAgarf+X5iNKvlLuW162dghakr38r5YECfXlGElkT44gM
         Sk9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vnb8FWmKkNgLEb+qcofOf2hg5Xo/Qk5YN7bYZJpXeLg=;
        b=YJmdx90tluOxrHPeRvfCn32wosgSO6p626+XiULhTo/nM6jtvvHQeq5SkZI+6Vs4Xk
         Dp12cZsnpKc8pIM+wQGn8fSNrXqqiZXwapZkrxVSAN9m+sx+gZDkMMvfxwyNNcQ+72lg
         kauB0EV/5pFQus6FGcMI+cgtZVOEwJbAMp7fhS+CfJD8FstcE3vNCWkt0CsfwZEZl0dP
         jfPlXrzQq4wskt63UuCCWnbVmcTTCviHjLSEjgKfviMTP8h+OzWxbshA1TkgjVsQqHdp
         +Gyf2AGYPvMtYdcoT/fWwPYM7dcBDwKfTveXhjaDM1PXL22fR0F2mmHRUmlpNxP/VkaH
         MFow==
X-Gm-Message-State: AOAM531infX/2njC/BT+AvUu5czy+vIvRcNJO7vSjLY+1/dJM2c2f6lB
        9BuqxJ1yH6VOL8WK5YQkgMtaNFyffLVtSzaCmGLgyw==
X-Google-Smtp-Source: ABdhPJy1SdUB003wTECYwrhdYiDF86oJsTeGxs8hQ//tBO5E3O/jPhrue02+WSs3kl8bimxtFd+4ajkfQXVVW746ORw=
X-Received: by 2002:a92:d98a:: with SMTP id r10mr3852901iln.127.1590691368083;
 Thu, 28 May 2020 11:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAObFT-S27KXFGomqPZdXA8oJDe6QxmoT=T6CBgD9R9UHNmakUQ@mail.gmail.com>
 <f75d30ff-53ec-c3a1-19b2-956735d44088@kernel.dk> <CAG48ez32nkvLsWStjenGmZdLaSPKWEcSccPKqgPtJwme8ZxxuQ@mail.gmail.com>
 <bd37ec95-2b0b-40fc-8c86-43805e2990aa@kernel.dk> <45d7558a-d0c8-4d3f-c63a-33fd2fb073a5@kernel.dk>
 <CAG48ez0pHbz3qvjQ+N6r0HfAgSYdDnV1rGy3gCzcuyH6oiMhBQ@mail.gmail.com>
 <217dc782-161f-7aea-2d18-4e88526b8e1d@kernel.dk> <20200427201043.GA6292@infradead.org>
In-Reply-To: <20200427201043.GA6292@infradead.org>
From:   Andreas Smas <andreas@lonelycoder.com>
Date:   Thu, 28 May 2020 11:42:37 -0700
Message-ID: <CAObFT-Si8expiZg4t5ajHdBkSPL6q7kJ-m2dtAcR6QveOoZJgg@mail.gmail.com>
Subject: Re: io_uring, IORING_OP_RECVMSG and ancillary data
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 27, 2020 at 1:10 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> FYI, I have a series in the works to sort out the set_fs and
> casting to/from __user mess around msg_control.  It needs a little
> more work, but hopefully I can find some time the next days.

Hi,

Just wanted to check in on if these patches saw the light of day?

Thanks,
Andreas

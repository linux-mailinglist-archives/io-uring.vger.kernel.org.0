Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32F526242E
	for <lists+io-uring@lfdr.de>; Wed,  9 Sep 2020 02:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgIIAsv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 20:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgIIAsu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 20:48:50 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12435C061573
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 17:48:50 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id g3so725645qtq.10
        for <io-uring@vger.kernel.org>; Tue, 08 Sep 2020 17:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S0xrBV5qNnRZwXbj95IFXFnqhHAe6J2831DWeaSOGwI=;
        b=udNfd/T9HUFrb7RVZVj8Za/BiTkgBdQK35oCFQAFJEbsmaiBANODWoF6BBczD/nA2V
         TNYyHUSvShcNPnSXuRKFq1j596vUcf1Npqwddib7kNyyU2gJcvlCw+wzzy+bxD2m1Rhy
         E0l+0dyFFKdJKkxCuXQWk4EeBhwTdbu/1761mUvnKG5rM6GZXmOjMxtpNcEP41ORGqbJ
         6hRklGxlbggvW8koy2iEtj9JbxiotyjeH/pOa780RQG9ys/Bcl+nGEr7vMT3MH6Tt3qE
         W0fxBxOf7DehteFNZgHK8dIK1GkTDnQLsy8atMrj/HgyCkc5gmFm5CodYRhgDpkrQuig
         dkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S0xrBV5qNnRZwXbj95IFXFnqhHAe6J2831DWeaSOGwI=;
        b=gs0AgCxiQ511lG8blEazEpKh/TcaW3YsuPfXdmIztHb2Pw9fMPz0LzDX8MKCmpQlvA
         23mpgrVFDaZlHfpsMzTCp4ktpPqZlh0rXTpDx/Veuw880sbIWctly22rKqbk9xNiy0yq
         YrLK/nPVAP68z5oBu4iIOJyBynqWDUobtcgAA88VAWJ674oA0z30TCiouMTmYJQ+F3pu
         /X/cWWLEQffg2IAbDcqaIo5Wbvb8YWoAqF6kf6dQivGc35c/RFX14VUjtC4Bfxq1/LKu
         alnVMtr7m6f+OYT/4KvGwMwiwCssR6+Z628ZEMvvKoasr/hazQYtshvjSHB5ju4kU1W1
         J2vw==
X-Gm-Message-State: AOAM530+F0l6uC6iXN8vk618vE8tR10OYcatMaqsdCKLvaLeuNfS5E72
        HLGTXGIFW9HAsjW1wy7OAOhBK5GYXVn0k3MXUho=
X-Google-Smtp-Source: ABdhPJwZFi9F2tfbn+hWW3s4vraI1lVbJNqlNrF/OQlhPNEe/rNbZVxUTnei/KuOKlkn9ujxV57NKncgxAkx1fP9S0s=
X-Received: by 2002:aed:24c7:: with SMTP id u7mr1066170qtc.67.1599612529164;
 Tue, 08 Sep 2020 17:48:49 -0700 (PDT)
MIME-Version: 1.0
References: <b105ea32-3831-b3c5-3993-4b38cc966667@kernel.dk>
 <8f6871c4-1344-8556-25a7-5c875aebe4a5@gmail.com> <622649c5-e30d-bc3c-4709-bbe60729cca1@kernel.dk>
 <1c088b17-53bb-0d6d-6573-a1958db88426@kernel.dk>
In-Reply-To: <1c088b17-53bb-0d6d-6573-a1958db88426@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Wed, 9 Sep 2020 02:48:38 +0200
Message-ID: <CAAss7+qVpdBY8E72AewJx7pNCwqBoDDU7dCqvQ7T4qh4J=e2Zg@mail.gmail.com>
Subject: Re: [PATCH for-next] io_uring: ensure IOSQE_ASYNC file table grabbing
 works, with SQPOLL
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

BTW I can confirm this patch works for me, thanks a lot :)

---
Josef

On Wed, 9 Sep 2020 at 00:55, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/8/20 3:22 PM, Jens Axboe wrote:
> > On 9/8/20 2:58 PM, Pavel Begunkov wrote:
> >> On 08/09/2020 20:48, Jens Axboe wrote:
> >>> Fd instantiating commands like IORING_OP_ACCEPT now work with SQPOLL, but
> >>> we have an error in grabbing that if IOSQE_ASYNC is set. Ensure we assign
> >>> the ring fd/file appropriately so we can defer grab them.
> >>
> >> IIRC, for fcheck() in io_grab_files() to work it should be under fdget(),
> >> that isn't the case with SQPOLL threads. Am I mistaken?
> >>
> >> And it looks strange that the following snippet will effectively disable
> >> such requests.
> >>
> >> fd = dup(ring_fd)
> >> close(ring_fd)
> >> ring_fd = fd
> >
> > Not disagreeing with that, I think my initial posting made it clear
> > it was a hack. Just piled it in there for easier testing in terms
> > of functionality.
> >
> > But the next question is how to do this right...
>
> Looking at this a bit more, and I don't necessarily think there's a
> better option. If you dup+close, then it just won't work. We have no
> way of knowing if the 'fd' changed, but we can detect if it was closed
> and then we'll end up just EBADF'ing the requests.
>
> So right now the answer is that we can support this just fine with
> SQPOLL, but you better not dup and close the original fd. Which is not
> ideal, but better than NOT being able to support it.
>
> Only other option I see is to to provide an io_uring_register()
> command to update the fd/file associated with it. Which may be useful,
> it allows a process to indeed to this, if it absolutely has to.
>
> --
> Jens Axboe
>

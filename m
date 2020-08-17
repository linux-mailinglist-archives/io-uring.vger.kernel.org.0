Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35F524619A
	for <lists+io-uring@lfdr.de>; Mon, 17 Aug 2020 10:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgHQI6i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Aug 2020 04:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbgHQI6h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Aug 2020 04:58:37 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28571C061388
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 01:58:37 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b14so14317644qkn.4
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 01:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J/WnDFZB4mM3l9lrGZHPvb/K3FmXj/NfkEni+gXt/rI=;
        b=bKKlqENdJUkPJNIaUNmrvSQEJPKmZ4TVh7tmdQul/PMpJk9HgPj1PRpM8o9U0SYF3G
         soRZaBFb6ES57+6lyOsa5JmzPI/nn+lLjr4BJqVjPopzHwh/py2FK7vyUToTthvgOGmC
         BZO5kLjod+RtjgRjNv96o+HpBvJS4+5ZRsnFmXafFO7F38j66RvT675ouZt5JkWqqO12
         Hpo9G+2P7arD3Vnqm1CgbTqDAoj2SAg0oq7oUfzNtKjia0O4z/nMA2+Vc4dTNHInywik
         FRv06KbkrbQh8lja4w0aBQLi07myVlMSp+8IocX32AjF4eUHCx9cs2LvJQ7UUcr4aFzr
         w78A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J/WnDFZB4mM3l9lrGZHPvb/K3FmXj/NfkEni+gXt/rI=;
        b=YCv3tkAkV7rvhgzEn8/HB+EFXFGkLSocrtgK/2E1z6SAgfgnHudTP3mZ/sPjjD01Ig
         W5QSekL7/vgMHyUxKTqE8CX34Nk+DLRsDA+1H2XzqgnTdEAXFluX+0Jj9hRs41I7pxYw
         JrDN4czqYL1Fmww3jC7uU+ZXX3LpAFs5BQ7ZMBGdY0P5Bk1a61MuppWhn4h3m5l3kDUl
         HNd4lz9gMH+eegKSeHxy61kF1Ve/UjaVAdUFkHONfZCkv/QI3WAVfvjVUTL51Tf4je8x
         9TJtDvCsxu7zJa0JpQWi7XwgKq6qVVDkf36EikXbEUboAoXAioWdYK6/eAe2q2gNIqlP
         8zHQ==
X-Gm-Message-State: AOAM530DZpeFSRWu1aCxuoLEAsshSF94JBeTclHGMqN9umHsADO5AsiH
        uK8arSUPIGgQwzSviXyC/lH0Rh0r1dIhCjdybn8=
X-Google-Smtp-Source: ABdhPJxzfD/JB8HGqKisUxdMDyvUwb5ZNL4TBPEjOOLhEBu2TaemXSQOT0zBqjoOyuS9vwyMEhOB8GQB/bjqr7a1TRA=
X-Received: by 2002:a37:a187:: with SMTP id k129mr11615339qke.196.1597654716269;
 Mon, 17 Aug 2020 01:58:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com> <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com>
 <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com> <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
 <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com> <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk>
 <63024e23-2b71-937a-6759-17916743c16c@gmail.com> <CAAss7+qGqCpp8dWpDR2rVJERwtV7r=9vEajOMqbhkSQ8Y-yteQ@mail.gmail.com>
 <fa0c9555-d6bc-33a3-b6d1-6a95a744c69f@kernel.dk> <904b4d74-09ec-0bd3-030a-59b09fb1a7da@kernel.dk>
 <CAAss7+r8CZMVmxj0_mHTPUVbp3BzT4LGa2uEUjCK1NpXQnDkdw@mail.gmail.com>
 <390e6d95-040b-404e-58c4-d633d6d0041d@kernel.dk> <63b47134-ad9c-4305-3a19-8c5deb7da686@kernel.dk>
 <CAAss7+o+py+ui=nbW03V_RADxnTE6Dz9q229rnpn+YeWu5GP=w@mail.gmail.com>
 <689aa6e9-bfff-3353-fc09-d8dec49485bd@kernel.dk> <b35ac93e-cf5f-ee98-404d-358674d51075@kernel.dk>
 <CAAss7+qHUNSX7xxQE6L1Upc2jYj-jLPaGMH+O1e30oF2nrmjCw@mail.gmail.com> <e51a81ed-075c-d90f-96cc-995d89f15143@kernel.dk>
In-Reply-To: <e51a81ed-075c-d90f-96cc-995d89f15143@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Mon, 17 Aug 2020 10:58:24 +0200
Message-ID: <CAAss7+qkX1YkBaMSqdXGpZtaaEyfjBCH75saFc+soiiFXqw4mw@mail.gmail.com>
Subject: Re: io_uring process termination/killing is not working
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> BTW, something I think you're aware of, but wanted to bring up
> explicitly - if IORING_FEAT_FAST_POLL is available in the ring features,
> then you generally don't want/need to link potentially blocking requests
> on pollable files with a poll in front. io_uring will do this
> internally, and save you an sqe and completion event for each of these
> types of requests.
>
> Your test case is a perfect example of that, neither the accept nor the
> socket read would need a poll linked in front of them, as they are both
> pollable file types and will not trigger use of an async thread to wait
> for the event. Instead an internal poll is armed which will trigger the
> issue of that request, when the socket is ready

I am guessing if the socket(non blocking) is not writable as you said
it's a pollable file type, io_uring will first use an internal poll to
check if the socket is writable, right? so I don't explicitly need a
poll(POLLOUT)

https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.7/io_uring&id=d7718a9d25a61442da8ee8aeeff6a0097f0ccfd6
you didn't mentioned writeable non blocking sockets, that's why I'm
asking

--
Josef Grieb

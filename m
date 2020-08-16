Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8998F24599A
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 23:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgHPVJZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Aug 2020 17:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgHPVJZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Aug 2020 17:09:25 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E39C061786
        for <io-uring@vger.kernel.org>; Sun, 16 Aug 2020 14:09:24 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id s16so11018163qtn.7
        for <io-uring@vger.kernel.org>; Sun, 16 Aug 2020 14:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yhjJ0pMrwVO2qLTg3OG+WTyBApmohHyaQYDPam7BPrk=;
        b=kRxLBh/9LY5UeIt8070CUXHQPHx8cMUROcSXJcGm9hmdsCrpOlXHfLxFNqm764DOrH
         ZYmHf3A8mgKr7aXmp66xQjmQk2CjB8vg0jUUunTIkGhyA7o9CkELZbeGNRyoe/5HAFcz
         9ZNchnXR4Fhzoq7YT960uueQhkfBfX3cpcMx6FeuYeEj21AUhPUvp1S/DdRhlbyfeqON
         mCtRMSU8De51YlQO9We3rOtP1aXjLZOj56SOwIW+43Hwt+IiUxGEOFDjOWdBTdtWdfjx
         RFzrug/g+kv/d8L6XvPNAyr+P9UNa959xwHNYPAWinGRdPPy6XH1FfY0ykprelvUQKs1
         dhpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yhjJ0pMrwVO2qLTg3OG+WTyBApmohHyaQYDPam7BPrk=;
        b=Bz5NmAPZm/WLg9h+uiN5Qbf5wksGyaqb53io9X+rae/8ILBvEMMugs1omC1X7uUXiS
         /ZmXECCe4kF8PABlPAxkjMHw6jlRUKw4DqN2YKtpIrBpLVPpKEyMp8Dg1CSJP7HlsknT
         30PPQ61d1T1aOdeB+79d+W7OTfC7t0FvQxc/mFT+EHKBKPGWxz+P38SvKiMH1urNRtSJ
         H6AZQjmFquCSn2MfgxN2QQ0XE7ovaKUfj3fHYdDvbfo1nFP5ImUC2xKg2XsUxJ7yYhFB
         FoDR0v2u7MOIPaR0BNy9/HunkHz8D0cPk9sP0RuQDzUV8LE7GFlDeWA2MbiF8CBbU0WL
         KAtg==
X-Gm-Message-State: AOAM532qnk9S2M6oOEYnwEDGX8q2dLOgbrMezOca7JUrNXkcxAGfYzeM
        xYtcpshmDTPISiWpevYmYi+B711dcvLH6Y6sq2xqLQL5UQ9obFsd
X-Google-Smtp-Source: ABdhPJz0adx3LOkrCJby2B/a6fXUrmDUfTUpQGRx3hdkYuW02P+iNOh4cfh1timH07Kj7GLrjSEL7Ch84JnIgInoyaA=
X-Received: by 2002:ac8:70cd:: with SMTP id g13mr10985582qtp.53.1597612161802;
 Sun, 16 Aug 2020 14:09:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk> <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com> <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk> <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
 <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk> <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
 <CAAss7+qGqCpp8dWpDR2rVJERwtV7r=9vEajOMqbhkSQ8Y-yteQ@mail.gmail.com>
 <fa0c9555-d6bc-33a3-b6d1-6a95a744c69f@kernel.dk> <904b4d74-09ec-0bd3-030a-59b09fb1a7da@kernel.dk>
 <CAAss7+r8CZMVmxj0_mHTPUVbp3BzT4LGa2uEUjCK1NpXQnDkdw@mail.gmail.com>
 <390e6d95-040b-404e-58c4-d633d6d0041d@kernel.dk> <63b47134-ad9c-4305-3a19-8c5deb7da686@kernel.dk>
 <CAAss7+o+py+ui=nbW03V_RADxnTE6Dz9q229rnpn+YeWu5GP=w@mail.gmail.com>
 <689aa6e9-bfff-3353-fc09-d8dec49485bd@kernel.dk> <b35ac93e-cf5f-ee98-404d-358674d51075@kernel.dk>
In-Reply-To: <b35ac93e-cf5f-ee98-404d-358674d51075@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Sun, 16 Aug 2020 23:09:10 +0200
Message-ID: <CAAss7+qHUNSX7xxQE6L1Upc2jYj-jLPaGMH+O1e30oF2nrmjCw@mail.gmail.com>
Subject: Re: io_uring process termination/killing is not working
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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
> issue of that request, when the socket is ready.

I agree as well I don't need a poll linked in font of read event, but
not for the non blocking accept event because of this fix in Linux
5.8:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
h=3Dv5.8&id=3De697deed834de15d2322d0619d51893022c90ea2
I receive an immediate response to tell if there's ever any data
there, same behaviour like accept non blocking socket, that=E2=80=99s why I
use poll link to avoid that

--
Josef Grieb

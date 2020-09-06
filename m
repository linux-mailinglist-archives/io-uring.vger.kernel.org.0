Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1C725EF19
	for <lists+io-uring@lfdr.de>; Sun,  6 Sep 2020 18:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgIFQYq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Sep 2020 12:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgIFQYn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Sep 2020 12:24:43 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77723C061573
        for <io-uring@vger.kernel.org>; Sun,  6 Sep 2020 09:24:42 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id g3so8325846qtq.10
        for <io-uring@vger.kernel.org>; Sun, 06 Sep 2020 09:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=74Ujjs2wCMgPZHh6j5bvSMcb/OsrWD18a2/QuUPCsH4=;
        b=bUdOkkHeMDdN8ua72F1F5ppfAhIBm8oo6DKBiZ0u9vL1OJPuZehp/P/6+aSV7pBCkm
         uEHJ4gR6vq7eSSTH5k9LgT0ywbyhUnoUOq2WWHujGptQbm0YzUsP3lWztQxAjRYF2Y2O
         jOFl9I6A14KpdvVEo1J/EXFDOQlbJFNttyuWoHisa5LhorGhWgA+te6YVc3cp2hRja1v
         /2z09D2LexxRwgPzWWG4oD8vVPWiGdL0XUOw9fGEx33W8sWR/tWsIUcBKvpmfQfzxMuz
         knWFP+0+UaZin/gCehiAjp1NfPR9wpTqgoS5nYyb7W05POY1WmsoqIKBgTJvCAuf+CnP
         Ta7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=74Ujjs2wCMgPZHh6j5bvSMcb/OsrWD18a2/QuUPCsH4=;
        b=PdEwbQFg+rGFh5vOpJVPzIeGhyJIn6+FZ7aoy8TTsIIcLM2i87tPcoo3fryle6loph
         W0fPhMm4ek4MFBcSdwSyl5X0TxjGFzj3yffmm65UD9w6A2rnpxrXV/kjHN2bsqUikJr/
         jfNhCsqwuiN4xInhCD/t85MWDqM1YP3HoyXSDLEniJqU2Cnr7Qv33p7J9mDX5uDnLJDq
         y+4flHWCwcZuKjVvNwFDjGi16F7Hh/e04Lk4zzeDPGe9BXrN3/U2VsmoTMZ/brYPHudH
         cRyMJW7V4qxyuycPAR51kriKJjgudo4U2lKgq3mn9AtIhppIfyqRDZ/f6ZmzpCwrUqJW
         ErLQ==
X-Gm-Message-State: AOAM530XL0QbwO0Yaw2dAUaeDH373d5SqHQX2qkIZNSGdRpUlZ61/RcT
        keVkFNY+W0NrNH1tg7siAfDmjILFeefO1y9rGMB5yYEdfYN7RA==
X-Google-Smtp-Source: ABdhPJxS35rYUoGbr8szWXRn+F4NseBegfF6ImHI0zHH5v6OIFNUMspxs8pSico5+YN1Na5XkZbuA73LMVhIG/Mo+6Y=
X-Received: by 2002:ac8:72d6:: with SMTP id o22mr17602125qtp.53.1599409481429;
 Sun, 06 Sep 2020 09:24:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+p8iVOsP8Z7Yn2691-NU-OGrsvYd6VY9UM6qOgNwNF_1Q@mail.gmail.com>
 <68c62a2d-e110-94cc-f659-e8b34a244218@kernel.dk>
In-Reply-To: <68c62a2d-e110-94cc-f659-e8b34a244218@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Sun, 6 Sep 2020 18:24:30 +0200
Message-ID: <CAAss7+qjPqGMMLQAtdRDDpp_4s1RFexXtn7-5Sxo7SAdxHX3Zg@mail.gmail.com>
Subject: Re: SQPOLL question
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> You're using the 'fd' as the file descriptor, for registered files
> you want to use the index instead. Since it's the only fd you
> registered, the index would be 0 and that's what you should use.

oh..yeah it works, thanks :)

> It's worth mentioning that for 5.10 and on, SQPOLL will no longer
> require registered files.

that's awesome, it would be really handy as I just implemented a kind
of workaround in netty :)

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5D22AA9CF
	for <lists+io-uring@lfdr.de>; Sun,  8 Nov 2020 07:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgKHGur (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 Nov 2020 01:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgKHGur (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 Nov 2020 01:50:47 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3086C0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 22:50:46 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id y197so5180181qkb.7
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 22:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wa0pKIecnuT1jKZQ9gV99MBQG1r1zv1ugGjg2wt46M4=;
        b=me8LgAptJyghl40m2gYqJiGymy3W//O/KQK1B2gQelmWKt1lDhyqaY1oow4L3PZSSK
         NVI9cF/wBQMJe8ReVrFVz4AIBqChzpiLsqRQ2oud3dFwg5fXu/biLVUnGPpSV0Gp8iI/
         KBxET5X1RVOjtVQmzGcOIhFbPCh4aGNsvxyBZy0yiWX+nXqf/t99Ljli5gciTzzAUQXa
         UaeMV9imwJiI0j9kGTxrs9JPYk/Dz0dLl7yPwVHvG2Nds/+EyUQCAZkBj0nbu24ljTK1
         haSaLYrjnnKIthxsN4e0r+FkwHWGpIhEi35f0VeJvrl+AUfHWvWBK5aFKTUzWLGnu+Ef
         FTEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wa0pKIecnuT1jKZQ9gV99MBQG1r1zv1ugGjg2wt46M4=;
        b=X1VeYoCuPFZkl30RvSyPibYc7H/z8ReHhzwRhoEIENBFEMwu9DgpIC5JSjHdsIUMhR
         CVeHWlsyKO4U4ZLBmGQgmUfuR9IYjWVdJHSNlCPCeKyMSNwqRMwoaugOjfuLjsnRi5Q/
         PlQJp/9dvzP5BU9jX5m/9+KM1s2WmLp/FxzU2ssSACT79z5ZXY9/rWWmY50uBqU+b4H/
         PXpl8Ob3UzQPxX5wKqspScd8ce6WDPok0+SvLz2ZTe6fTQ8DAVgqb3BtF5LDiyMwd8VS
         HQ8z4fNU4VaKVe1vQlO7Vib4gWQpyj7Iu4M02XguzUCzdgrDYO+uFnM+vy3Ml1JZKkVf
         R51g==
X-Gm-Message-State: AOAM532n+Ne2pNdeGqcihlajzyjh/tmG1qQRNorqR92/jwv+cN1uqzS6
        1k75SS++DB5bbYBOeFHOlWOozBAGhksrxK5Ogxc=
X-Google-Smtp-Source: ABdhPJygeY7zomgfy2XJtx+VVYZ/ka5TbWnWbXpADlbd1uw8hHMMXug0kDHfW+DgpiT2NBjDLJ2vZj3NsUxmv0oR1eg=
X-Received: by 2002:a37:9942:: with SMTP id b63mr9217715qke.85.1604818245857;
 Sat, 07 Nov 2020 22:50:45 -0800 (PST)
MIME-Version: 1.0
References: <24446f4e23e80803d3ab1a4d27a6d1a605e37b32.1604783766.git.asml.silence@gmail.com>
 <39db5769-5aef-96f5-305c-2a3250d9ba73@gmail.com> <030c3ccb-8777-9c28-1835-5afbbb1c3eb1@gmail.com>
 <97fce91e-4ace-f98b-1e7e-d41d9c15cfb8@kernel.dk> <a8a4ac73-81f9-f703-2f91-a70ff97e5094@gmail.com>
 <3094f974-1b67-1550-a116-a1f1fca84df2@kernel.dk> <CAAss7+r+DFTBcLzZhRoJ_p839nro6GKawh=te1wHPkhK9Nw4hQ@mail.gmail.com>
In-Reply-To: <CAAss7+r+DFTBcLzZhRoJ_p839nro6GKawh=te1wHPkhK9Nw4hQ@mail.gmail.com>
From:   Josef <josef.grieb@gmail.com>
Date:   Sun, 8 Nov 2020 07:50:35 +0100
Message-ID: <CAAss7+oBjNfFXV8O5DaLB0ih6EvcmSE=4V9bB5g2RY0R1oXftw@mail.gmail.com>
Subject: Re: [PATCH 5.11] io_uring: NULL files dereference by SQPOLL
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Josef, could you try this one?

the null files dereference error no longer occurs, but after a certain
point in time the OP_READ operation always returns -EFAULT

BTW forgot to mention that the NULL files dereference error only
occurs when OP_READ returns a -EFAULT

On Sun, 8 Nov 2020 at 03:09, Josef <josef.grieb@gmail.com> wrote:
>
> > Josef, could you try this one?
>
> it's weird I couldn't apply this patch..did you pull
> for-5.11/io_uring? I'm gonna try manually
>
> ---
> Josef Grieb

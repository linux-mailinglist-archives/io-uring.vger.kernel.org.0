Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9DD25FC6F
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 16:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbgIGO6t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 10:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730097AbgIGO6g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 10:58:36 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F862C061573
        for <io-uring@vger.kernel.org>; Mon,  7 Sep 2020 07:58:15 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id t20so9939289qtr.8
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 07:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iOgZQ7xkTBYL0gKWgEE/Agic6CECHX9zdI+UCZAsQws=;
        b=nfmbVGdJJs9MTIzFM3TuItdyvJ7QUbIXr4IO+j2TqG67Gb2sKCVT7SNkiCfHdxlnnk
         IoVxIS/C3S7JqEqwuYhnvy6w0qmCGQEKb3hx0G6fAirQSCw66tbmyvuGdvCzXcy0FPLv
         XKqsfLutRa8ufKTqrzF3tttRen0cxSAn31HcCaMZsMyF8umQQpIYX4cF9ROSFdiBza5j
         /j+Dna9bYD7j8y+UhCYc57bf6UA71O4gKuTvZaAvRrME2N+Zybg10e73T2yCLTT2oZo1
         2ng+QJYjJG7E7uYeO9Sz4QDbCItlZQr4KsM6udWHCxbdYIVJVe74on4iTaTBwtxjkU8T
         B3cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iOgZQ7xkTBYL0gKWgEE/Agic6CECHX9zdI+UCZAsQws=;
        b=H4lqoqUI/2WPgvy/eCs+QXklHCB6mgtp4PyDtcsTtWrJ8Hp+4cmGKjDZCDya2Ku2CM
         lbK5CqIRkWl1IRqMEvScz2OBuJgD/G8ESNjpBa81JMKmHv67ueLdRjPMtwlvHATnsegv
         Y9UFTx08MRmm9rgoxBUPVTXYuVJFbxs6AYhmqI/YOyw0FZnuMeLB5sPo7yqnnIE1kYDP
         0Wu37P07VB1AHKzLCjsJ8QjNlGitko9945ELlOd9o26rB0AKsy64brqznEAaEb377WYP
         w0AgIVYN6fau4dYruRphQ2WZjtxoPNFx/dOOQvA6XzD5Fos2wG7FJKNTyD4nYVjNLGgi
         lT4w==
X-Gm-Message-State: AOAM531l/vLXxYqmDu68qnAHdN/ikNPScek+lV064UK2M6Xdss5ixGEA
        Ao8EetMiHHQJQEKqGHStTgkEciK0HYv7BoXHWiA=
X-Google-Smtp-Source: ABdhPJxlJGwZA2kZHeFa45c7jVMP0OOxkjm8wXSkIupO/Bbkac3wz59eCorwkr2ztNCwELP6b0V7sSfaPbCUTrAS/xk=
X-Received: by 2002:ac8:3713:: with SMTP id o19mr18446614qtb.256.1599490694272;
 Mon, 07 Sep 2020 07:58:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+p8iVOsP8Z7Yn2691-NU-OGrsvYd6VY9UM6qOgNwNF_1Q@mail.gmail.com>
 <68c62a2d-e110-94cc-f659-e8b34a244218@kernel.dk> <CAAss7+qjPqGMMLQAtdRDDpp_4s1RFexXtn7-5Sxo7SAdxHX3Zg@mail.gmail.com>
 <711545e2-4c07-9a16-3a1d-7704c901dd12@kernel.dk> <CAAss7+rgZ+9GsMq8rRN11FerWjMRosBgAv=Dokw+5QfBsUE4Uw@mail.gmail.com>
 <93e9b2a2-b4b4-3cde-b5a7-64c8c504848d@kernel.dk>
In-Reply-To: <93e9b2a2-b4b4-3cde-b5a7-64c8c504848d@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Mon, 7 Sep 2020 16:58:03 +0200
Message-ID: <CAAss7+oa=tyf00Kudp-4O=TiduDUFZueuYvwRQsAEWxLfWQc-g@mail.gmail.com>
Subject: Re: SQPOLL question
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Yes, that is known, you cannot open/close descriptors with the
> SQPOLL that requires fixed files, as that requires modifying the
> file descriptor. 5.10 should not have any limitations.

ok I got it, let me know when the implementation/testing is finished
for SQPOLL then I could test my netty implementation

---
Josef

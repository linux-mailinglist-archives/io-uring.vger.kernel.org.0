Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDEA260B32
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 08:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgIHGrZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 02:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727898AbgIHGrW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 02:47:22 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91871C061573
        for <io-uring@vger.kernel.org>; Mon,  7 Sep 2020 23:47:21 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id n10so11213657qtv.3
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 23:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mVp1Wxszeo3kp9cPNE8hyKupPbOsLn/kZzGG0lQChcE=;
        b=TlwbwT+5vgi1BZfNoOOdNbUpNiEHF0uU7N9SZNjt29nntIzo4ZV0fThyk70X7NhGke
         Y9rTfyY6wE37fyZoNnOfW9OXqko/w91er2iLJL9a5ACCdTZxvZgf+kpFTbSeTk1qQWb0
         4NwzsZRSdsOAkZtuxyalG7f6kz9NclZv5+SVQpUW6dB9HX8WcY/TBpwxepuMsBAxnK7S
         xIBTi/3WaV7AaK3V+Aak7/cPBJ/1QGrxx92sJ7To5kSyTr530Q9IuB72qoAOm8k132cX
         eq9fuM7mAixn2CZAajQ3HjrbohSZz/+8LDaxyuGzmH2MrAqHaIkqwlbdlPL4/j2GI+fV
         fqJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mVp1Wxszeo3kp9cPNE8hyKupPbOsLn/kZzGG0lQChcE=;
        b=fR7mFLvvIWhUBFtmX5cs6c4XgmwN6PuySCczzkPjCT4jSZFdr/TJy+m7yxcjFB8KRs
         iF8g4IxMLNpCptnBLNlzUGX2e53hN2jeycQ9MgMjiKQGLO2R+jQMM3QsT2mVxwlKQKvC
         BbTLd+9XjKfADs334sxzm4mSbmjPqTwGfp6QqP42ybxa3anbFSJfAwVyFeZfIK+iwkZN
         8Jox8UyuGOXtj7Ofhf/vguwygDIR9zH2kUcTZ6ex0GWB1KSGlSY+XWSpqdRoE6F91Kmm
         pZnoWP3wTBYjAF+35Tz2ZXQkMTq17H3xDzLQJOaOKEZStsHhBJfT3ORqvd3qF/Y8l0bQ
         X7cQ==
X-Gm-Message-State: AOAM5315bsSDVvJas3bDet+WUsXr81q6LbvlxNckFg3p8I+K3DsmSqN+
        7SO0jXjuvwwNotZAar8gSxhCNgmM56kuFASTwauhslCHcXvuyw==
X-Google-Smtp-Source: ABdhPJz8UxvOJW3mP7PyJFf/myBQ9+glfWrOK4n8ADnoNx2FNx+4GOCvPiVQyqe8uy4WDo5wk9Im9Ukd9eBJC70nEQE=
X-Received: by 2002:aed:24c7:: with SMTP id u7mr17853823qtc.67.1599547639863;
 Mon, 07 Sep 2020 23:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+p8iVOsP8Z7Yn2691-NU-OGrsvYd6VY9UM6qOgNwNF_1Q@mail.gmail.com>
 <68c62a2d-e110-94cc-f659-e8b34a244218@kernel.dk> <CAAss7+qjPqGMMLQAtdRDDpp_4s1RFexXtn7-5Sxo7SAdxHX3Zg@mail.gmail.com>
 <711545e2-4c07-9a16-3a1d-7704c901dd12@kernel.dk> <CAAss7+rgZ+9GsMq8rRN11FerWjMRosBgAv=Dokw+5QfBsUE4Uw@mail.gmail.com>
 <93e9b2a2-b4b4-3cde-b5a7-64c8c504848d@kernel.dk> <CAAss7+oa=tyf00Kudp-4O=TiduDUFZueuYvwRQsAEWxLfWQc-g@mail.gmail.com>
 <8f22db0e-e539-49b0-456a-fa74e2b56001@kernel.dk>
In-Reply-To: <8f22db0e-e539-49b0-456a-fa74e2b56001@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Tue, 8 Sep 2020 08:47:08 +0200
Message-ID: <CAAss7+pjbh2puVsQTOt7ymKSmbruBZbaOvB8tqfw0z-cMuhJYg@mail.gmail.com>
Subject: Re: SQPOLL question
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> If you're up for it, you could just clone my for-5.10/io_uring and base
> your SQPOLL testing on that. Should be finished, modulo bugs...

yeah did some benchmark tests and I'm quite impressed, however accept
op seems to fail with -EBADF when the flag IOSQE_ASYNC is set, is that
known?

---
Josef

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5EC2454DD
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 01:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgHOXVm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 19:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgHOXVm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 19:21:42 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A05C061786
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 16:21:40 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id g26so11862777qka.3
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 16:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lKEoy7GILc7HdCIBh8jXLNc2opR8m+8jt8THFwu1+TE=;
        b=TGxqmuzw8tk9UvmVYKzwps2arrA5MgvoS4fp8HvCQFDqr59wKvAjvz9qL38zuBbr+X
         B4CCMY+281PuSTgHtgZsvNtyp1vJ4FRveFMcU6AbPTmdmVNu9mpXfgNRzvJiCYqpkSnh
         /pZEt30vs8dVgKA5PNUhz57OyAi3oUAJr+sW0/HH+I8UUlPGPZisVf+1nR1lzfv7qISh
         +8ZHjWwLwx8VIEZws7R/ZsUZNjyC5hSlxLwtkd4nHHp690bkDiXJrINGpdv34ZaM6gO/
         wAgfmFErIAxvXAINCAo4V8WHa33mnO5Bf5BzwE4Ud2rjOo5Ud9np+zL/rgpALgkaYekV
         +nvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lKEoy7GILc7HdCIBh8jXLNc2opR8m+8jt8THFwu1+TE=;
        b=mmE1jEt5kaoGSaI8/uiNXS+9LHuwgVkZppUQwbb2s3EgaXezHfZ9S5grZlcqoJmidh
         4mgI3ckL0KC89416ES4+XS5awbKdaf29VPaGW5Gp9WORP0UtYH5r44pY2hkv4NUUHS4O
         UMlDWsoWhqBpQz7z3MtmkW+CMp7VUgrlzC9Na0U68UkhkOcNZwer6IAk7hhbGV7ufRhD
         bm/Ies8yEpOMOnkZN3z9Q45+IfXKVn76gPboL7rMysdkbq/NKHSVFRYmMxE+Ar92UhvC
         yRZ98YgFer43l4YbYcTGcMmdLBN3cF0hXREFHMoZdW+CUyYO0lTMWNIv3ZOZ5H5Wq3Bj
         VA9g==
X-Gm-Message-State: AOAM533hWxdSKkAAFs8kUHJ9ReG17NNp7+KYQuUfc6rOHM3BPuaVU6HO
        iAnK5IdDrt9AhOLTWc9xZ6IotJaNVIOr87z7HDk=
X-Google-Smtp-Source: ABdhPJxeViLbOTXzB/cfJGYxN0CWgOM5Hp70mzPEJzsk4FwYO1VLN8L6dkab+4ZgaevAx2vg7K08LTxG6hfn3GOk6Wc=
X-Received: by 2002:a37:9a46:: with SMTP id c67mr7839794qke.85.1597533699954;
 Sat, 15 Aug 2020 16:21:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk> <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com> <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk> <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
 <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk> <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
 <CAAss7+qGqCpp8dWpDR2rVJERwtV7r=9vEajOMqbhkSQ8Y-yteQ@mail.gmail.com> <fa0c9555-d6bc-33a3-b6d1-6a95a744c69f@kernel.dk>
In-Reply-To: <fa0c9555-d6bc-33a3-b6d1-6a95a744c69f@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Sun, 16 Aug 2020 01:21:28 +0200
Message-ID: <CAAss7+oi=xNKTNQOn2pA3N2-gGUpiOwr0QULXS0ry4OCnmxKRg@mail.gmail.com>
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

> I'll take a look. BTW, you seem to be using links in a funny way. You set the
> IOSQE_IO_LINK on the start of a link chain, and then the chain stops when
> you _don't_ have that flag set. You just set it on everything, then
> work-around it with a NOP?
>
> For this example, only the poll should have IOSQE_IO_LINK set, accept
> and read should not.

haha yeah...thanks that makes more sense, I should read the man page
more carefully!!

--
Josef Grieb

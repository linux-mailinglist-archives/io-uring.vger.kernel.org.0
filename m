Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458C4245588
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 05:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgHPDO0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 23:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgHPDO0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 23:14:26 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCB3C061786
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 20:14:26 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id v1so4372144qvn.3
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 20:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FTsZ+6pdVID1OXz1gsa14WrG3JYfeQhqi8MBo3J7hFI=;
        b=qiV1iNcM3stw5DUZGiomEh2MReluGNCLCo5RTC2fDlxN/XMF4Nrr121JVF96wgsAde
         tJkRO1lqJduIG5CKyl0isvN3xyuw5/P7qOVlI3GU29+OL3+vvS7UXaH4GZtVFZ4gOrJF
         854YgmwFu/Da/AP7k0baHFyR9Cp8pihzO7tGjQsSV9iH6hdgrQdVXgHa1bkA7l0+cgfJ
         ZF3yLFJ2YpSU1Y3AcKDtDYPn4XBYwet3QJFGOZ+Rfd7eIBAbNmtqJ+Woo0xDb6Xc8saD
         CW+qlEAkSwi3YQq6MYFAVfcOA5usNAfwS18I33cO69uLOcj51m0VVNOncd7Rq6Dk9m8k
         fshw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FTsZ+6pdVID1OXz1gsa14WrG3JYfeQhqi8MBo3J7hFI=;
        b=g9cuXoRlpRGo7n76LZWRSrh0h1lRu+fvN+VVvHvu6AT4umtdq8XXujugJkFFa8PD7D
         U4ZBcSD9PMUw7zFQUa2zAzd1yLwGpeGCfxSggWfUFw7lLKvq3ytJx8gY4+9PJat+nLkK
         X5DRbUykkDRKf/AI7PLVzo9FLA6GWy0s81mQd/xSPzMKzKpsgYiiq202hB6oBcwK6uV2
         ofEb9X2FiRg7fwsuxA72TXTXtsxXV1+lipm++Rw0I7TToECXsGKXnNCAqQMHt7bXONFv
         Mbb0gGp67eaM3q2IsiBHkUKmuTWPsqHC1/O7EY06r1etw3LTLKOt5Nwul/mq6YqlqX6I
         G7Tg==
X-Gm-Message-State: AOAM5324MukRBED9XAbk2WLZBkiKjJEef93ZX3xRzWkeRfdSwhybf8hY
        Nm/5RfaATaDTQFOuh5WQK1QZd7evaOpqne5pCTI=
X-Google-Smtp-Source: ABdhPJx6NhWxY+whfHITrvIcvHsDvKTRwZmyfY/vq/Eoep7uOtRfv+YPI1d4sDl1460G6O5WVseknbHsZuVr/1ulFIg=
X-Received: by 2002:a0c:fa0a:: with SMTP id q10mr9290730qvn.33.1597547662936;
 Sat, 15 Aug 2020 20:14:22 -0700 (PDT)
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
In-Reply-To: <63b47134-ad9c-4305-3a19-8c5deb7da686@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Sun, 16 Aug 2020 05:14:11 +0200
Message-ID: <CAAss7+o+py+ui=nbW03V_RADxnTE6Dz9q229rnpn+YeWu5GP=w@mail.gmail.com>
Subject: Re: io_uring process termination/killing is not working
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> > Hence it'd be helpful if you explain what your expectations are of
> > the program, and how that differs from how it behaves

yeah that's true, I'm sorry about that.

> > Are you sure your code is correct? I haven't looked too closely, but it
> > doesn't look very solid. There's no error checking, and you seem to be
> > setting up two rings (one overwriting the other). FWIW, I get the same
> > behavior on 5.7-stable and the above branch, except that the 5.7 hangs
> > on exit due to the other bug you found and that is fixed in the 5.9
> > branch.
> >
>
> Took a closer look, and made a few tweaks. Got rid of the extra links
> and the nop, and I added a poll+read resubmit when a read completes.
> Not sure how your program could work without that, if you expect it
> to continue to echo out what is written on the connection? Also killed
> that extra ring init.
>

sorry my bad.. I will ensure that the code is more self-explanatory
and better error checking next time. It was supposed to reproduce the
read event problem in C since I had the same issue in netty, basically
the idea was just to read the event once to keep it more simple

> After that, I made the following tweak to return short reads when
> the the file is non-blocking. Then it seems to work as expected
> for me

yeah I tested and it works in netty & my bad C example, thank you for
the super fast fix :)


--
Josef Grieb

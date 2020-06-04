Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E3C1EDB1B
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2020 04:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgFDCSR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 22:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgFDCSR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 22:18:17 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2478C03E96D
        for <io-uring@vger.kernel.org>; Wed,  3 Jun 2020 19:18:15 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id e16so4028140qtg.0
        for <io-uring@vger.kernel.org>; Wed, 03 Jun 2020 19:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=8GkucWqLv2ja7KBBJKe93WoF7XCOY5H53bULegFscFU=;
        b=hBksqpNJA+g0XWcmeJqH/02ohGtEGitF5KCKty5gT2x/UifMtxbjhtjbZWMvSFBCEO
         DGGnt3c1qtj322vmVXedPcxgEmxSQQ3AtfGfjp0k55t06e9NwcziAfaUu6hFMJgy6d0v
         FdXtB4uaf2t79nvcQ5pKjhXpth1fASOWsPEsaRo0mEJXYyQlC6TfXGA8S7kwSmW7mVra
         dn1hkG0UZaJZ86krUXqP2eWBM3k+7TEniHOOhtJUFJXzsgjWOAuglMlWw/u0PntrIe5m
         VqGfn21U2ez75Ct3sY6mqY2IbKEKOQmCeznO+aNUuQ4DsoWcIEjLmPIw8oCahkS3CqDN
         jgeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=8GkucWqLv2ja7KBBJKe93WoF7XCOY5H53bULegFscFU=;
        b=PLMa1gpJaQ6WXdmmENlb4aZI1zsmiKAWT2/oXSDhvDxQbUvn04t3bM6qGH/SKksOQ4
         wNAUWA26WZNIFpkt3P70wvczgYpjWkPGTcaLsmP/TGgpOB9ade1/l5wrOwjm6Qr+djSS
         tPeMbODLOoajSyDV6nC3t0l/WNDYRqS6upwvP6YiFq1OncYlYlDBTZubXsYn4WOztNPN
         HvwVSMV7O8Os8zEWIYap6lRfHm8BEmmoBmQJAeajz0QBM98QTqLJ7kUyvYdZ6j83QM1Y
         AARjNVkTmQpjZ8xI7OpK8Fzoy+0DVWWZCmN/NZ5OPucU1XgbdaJis7KqjtBwkMCJLhKq
         Eccg==
X-Gm-Message-State: AOAM532WX3DkG+knwo7x/XqvEYHa84bucBbmP251SB+ar6cLpwQcrtmg
        Jb6ot/r+y748yKAiWbV3a4CrLEjTXaj2PRMvxSQ3nUKLvpEceHE=
X-Google-Smtp-Source: ABdhPJxd8VyT0j90OvtuJAq0dtZLor4ARE0B3Bd9HH8OO/NwLPqnDhNb0zVU3X2qa2qhAg4AdDIQHTI3HQ4AdV/a6u4=
X-Received: by 2002:aed:33c1:: with SMTP id v59mr2391778qtd.250.1591237094742;
 Wed, 03 Jun 2020 19:18:14 -0700 (PDT)
MIME-Version: 1.0
From:   Dmitry Sychov <dmitry.sychov@gmail.com>
Date:   Thu, 4 Jun 2020 05:17:39 +0300
Message-ID: <CADPKF+cKmLBy-71e+KUEq8k4fEF=bpVVrKiO84SL26de=9f+xg@mail.gmail.com>
Subject: How good single uring scales across multiple cpu cores
To:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hey,

With the intro of uring there is finally a sane aio interface which
allows straight porting of Win IOCP-based apps to Linux - hooray.

The question though which I've raised in the prev. thread but was
kinda unanswered is how good
single uring submits+retrieves are at scaling across multiple active
user threads for socket io, still bound(to prevent excessive ctx
switches) by the overall number of system cores.

For IOCP I'am observing raw socket TPS increase with every added core
thread up to like 32..64 of them using single submit+completion queue
pair.

All uring benchmarks I've found lack specific context like the number
of running threads and there is no data on the gains from multicore
submits/retrieves against a single uring that make them kinda not to
the point...

Dmitry

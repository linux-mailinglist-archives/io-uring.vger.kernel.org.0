Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C296C144A02
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 03:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgAVCqG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 21:46:06 -0500
Received: from mail-qv1-f54.google.com ([209.85.219.54]:41418 "EHLO
        mail-qv1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbgAVCqF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 21:46:05 -0500
Received: by mail-qv1-f54.google.com with SMTP id x1so2544995qvr.8
        for <io-uring@vger.kernel.org>; Tue, 21 Jan 2020 18:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=JknNw6x0nyalZPy9mj7EOOqCjd/ZcwpHNQDRb6ZKg74=;
        b=g/maAtt2zsQJYHasZu/AxC7c6kWh3TfdlhUctFI5oGeJTH2b30JBMAwjnRz0a97qEC
         U6qdywL9Vx8DnfwujPNcd5jhKDeg/uxrw1SSxr3UUQD9YOzY5w0C8oJ94nMhTPJRfvxP
         J2f9j/An7wgtD3rH39yifGo1z1SqRMwvgPpcIIlqwbbFs+T5mRQ9EeEZzju2fP18JUkr
         /5cdkroXUniBcJqaCymY4BY0ePAtadh3WuMgVwiKmscO2gZAnkAmwzZPzzry7F6bYawB
         sWp+WImdxsOr4N6qxOo8pwrvMtivEy3/b9C1RxTPNuVY/ns+0xNOK5j/jPZhc3jd9jea
         hMDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JknNw6x0nyalZPy9mj7EOOqCjd/ZcwpHNQDRb6ZKg74=;
        b=MtCj3H1FxJB9cYHrBDV8UOwVKA8iyqa09XtSPo8HG+QyurgTDtQ2FoOgkoAZezxcJq
         ozLn7iz4Vx5XPpRvP/xesbDtXZUkYZj9S9bY5myUejVl64V1pV0T9FHKMwxTzkBZOzy2
         NJb6/Cg9soz16DLeBU0VXAebh4FMRCSpwBc3iZ1tlKGycjfpOWWgX9RFqVAWK/OIpihm
         IH09waAjcw4xr6ItpLVzMcBzHX2cTua1MdbAckvy2K5sgqt1tacGCLcOtGxLfubT0gPD
         eOJiKsZX/Gd/o/arBRgmG5iLaCRlXvTSciF9NRdmbqfrtGMJCy4yXVw2FKks4ppzhzJh
         WKLg==
X-Gm-Message-State: APjAAAVU7RBXDa8SgnqocRwkSqiuNm+lEu0pHtdA4mYnz/qgeUrrQlJ8
        dJJ756UC1AjKOE01I7DcUPyoPeLaBzuJ+9RBJo9rbWpw3WNFuLU=
X-Google-Smtp-Source: APXvYqwAyRkKFqAmk4DtPI3Tfwf3AEpCFil5a2V9TpxjmQz4oPTJ5+0CwcUqH0iN4zEvmtfWyDHz5lw5ZLZa1FEs668=
X-Received: by 2002:a05:6214:13ef:: with SMTP id ch15mr8217823qvb.183.1579661164813;
 Tue, 21 Jan 2020 18:46:04 -0800 (PST)
MIME-Version: 1.0
From:   Dmitry Sychov <dmitry.sychov@gmail.com>
Date:   Wed, 22 Jan 2020 05:45:34 +0300
Message-ID: <CADPKF+ew9UEcpmo-pwiVqiLS5SK2ZHd0ApOqhqG1+BfgBaK5MQ@mail.gmail.com>
Subject: Waiting for requests completions from multiple threads
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Really nice work, I have a question though.

It is possible to efficiently wait for request completions
from multiple threads?

Like, two threads are entering
" io_uring_enter" both with min_complete=1 while the completion ring
holds 2 events - will the first one goes to thread 1 and the second
one to thread 2?

I just do not understand exactly the best way to scale this api into
multiple threads... with IOCP for example is is perfectly clear.

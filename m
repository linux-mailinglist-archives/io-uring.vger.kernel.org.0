Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3043B278E4D
	for <lists+io-uring@lfdr.de>; Fri, 25 Sep 2020 18:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgIYQV5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Sep 2020 12:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728938AbgIYQV4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Sep 2020 12:21:56 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3853C0613CE
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 09:21:56 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id p15so1664125qvk.5
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 09:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=O22CE3M+C/kveLUiR027fYKJgbHLXjbHs5XINZDI2ak=;
        b=NMHyM/rOjfpgmpcb97B/EgX5ECuQ9B9VxZvLNjAEZsnOUpg9e+q8/bEVDiV1D1WzP2
         8doZwjia6tSdDXEuu3mT7bxfMdc5MkpxVVsoYDsSNVrWDYS/ydwxthz34LO2jfs/3+Qp
         E39o6PLHF65qs6LoVXB794oOOLT/1qPzqCVrAycRRy9+nhc2OeN9OFXGCdvGzIBI4fgP
         k6+VFRlOhlHKTZF+/jt92l6WG4jkYD7jItOLxGHe2WSRjtVyMRmDkhBxeap/vKTEGKrK
         6ywKOWMqsc+34/IxLLstx0XNWe0v/wiaLG7EY/KZoLfcSpi/bdPtx4+qQWZ6o0CAwz7j
         6B9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=O22CE3M+C/kveLUiR027fYKJgbHLXjbHs5XINZDI2ak=;
        b=QFsxLiO8C5qu1YeO2nhSITXWJAm38/1AdisseJLQ4UyVRgf4EpFvA0nkpSg9OQmRSv
         DxtTshC6rznyVHcFUqyego+QQlu6klavAHCuHYPLAjy/KDTuUYRDrDUyIY2LDXfhTXiQ
         058XNU0RgkB25ehD6fNrbDDwT786L1+yYle37y9MZQorSflQ+7MBh0zKA6mnCofamGFA
         lHmEX1eVSd+xWKKFkvpdD5UdMdgAmumNh+8/NW2S/hWFFNOxrzQMd9RccTv8/yP0s5vl
         7t5SFJYFUSY7Hb2HmO/wh4MQmVAormNQYdhO27QTz5nxfpuXfumpqbxoQiWX/VQQm6Mm
         3ZiQ==
X-Gm-Message-State: AOAM533CZ5m0Steo80oIM+sU0ZtAixWQOtWwLf8A/GhLWIL0Bc34vBL+
        gQNSxMTp5laLBMhLa3J/Kw5dS3XJiZet2/1W9jrfKY6JQ7VUQg==
X-Google-Smtp-Source: ABdhPJz5RqxWCpaKOznmST1FB2ZkM8Gg7lOkOODYoKWyjKkYIHqhgEPAC0VNdkB83bmoGNvJMdIbk/tJIDF0vXtoWxU=
X-Received: by 2002:ad4:42a5:: with SMTP id e5mr193936qvr.58.1601050914820;
 Fri, 25 Sep 2020 09:21:54 -0700 (PDT)
MIME-Version: 1.0
From:   Josef <josef.grieb@gmail.com>
Date:   Fri, 25 Sep 2020 18:21:43 +0200
Message-ID: <CAAss7+rWKd7QCLaizuWa0dFETzzVajWR4Dw7g+ToC0LLHcA08w@mail.gmail.com>
Subject: SQPOLL fd close(2) question
To:     io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I implemented SQPOLL in netty for 5.8/5.9, to close a fd I need to
delete the entry first, it seems to fail with error -EADDRINUSE when I
remove the fd entry, close(2) it and the same socket(with the same
address) is created again,, is that known?
I assume that io_uring still has some reference to this, however
io_uring_unregister_files works fine but the drawback would be that I
need to wait until the ring is idle

example:
https://gist.github.com/1Jo1/53d01c4c2172bb0762b5dbcf9ef9c623

---
Josef

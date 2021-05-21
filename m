Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F16038CD68
	for <lists+io-uring@lfdr.de>; Fri, 21 May 2021 20:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhEUS3y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 May 2021 14:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhEUS3x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 May 2021 14:29:53 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72181C061574
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 11:28:29 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id u133so11607533wmg.1
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 11:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=M0wCfPcnYdQ21hr1OwMI8Qlwrf1lX3IB0S6+6gsbjXA=;
        b=L02hlXS2r3ETK+9iEuN+zz9HUYjiMRpPTtASeZuU8KTwcqnFYqLt0oxNTQRVAq9xFJ
         KjqrEayPvbBqGSmzj8dTjxWyeO/xgBC1TsLNBJkgWO2sBOjG7j85PIQnylx/5Gc+/mKv
         J+MQrDrU773sBXL3tO2sPh79hRi8PyngwrmhYvsiZr02unetzoPJCOwa7Kod7pB7IWLL
         heMApbIUPivbFwXzxw9N+5I+cppcPzz8oTJMoBABnAccrpdygkzbtoosK00esz/8zHiW
         BKikGWnHUf2nlwDEFD0v8F5WjykdG4SKHIcaswFKxl/tLSrKwzZfL3H8cZ4dQmlFOq12
         vYxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=M0wCfPcnYdQ21hr1OwMI8Qlwrf1lX3IB0S6+6gsbjXA=;
        b=cyQ2TVaZbrg2FFMnVr9DfuuKpT/tOX+iuBrRuZlvZZyeO4rDnoEDGQ/nWviy9VvoHw
         t8H8V7mEnKXblCmjwYTBBbN41TusxwqhY87HBYbulogyh8ZFD1bzzrxKl55mP3ibr3pY
         oxO1sQ+L5GKFTVEplmNNeD+vGd/7i1YD5AVyEDYOYbhLm6z5ry5H4DfJ3NNoqRO+freM
         mctCFwqr9RnnoqVcWKFfk+bQqhQUYzTCCpCMDUgMMIVZY+9KlKWUc/LYJkNnWrx/LOPy
         XyGj2LEQnJ1miUEyJ5HJTX4adjZOWrZvPXp05EYbrB2Aptnghd1AOVw74NTFy/KcIUJM
         R6nw==
X-Gm-Message-State: AOAM532cY9TmPjxyaAJaxIQpMLogxAhUwozxF5IX4p7WKqHeHzIF9Rsb
        ShueB/eMVp12huw2+8elkMAqXgDMynNhighaZte92cIXKa7AV2d0
X-Google-Smtp-Source: ABdhPJy38Cap/CL5aW1+dkF3lfQNnNnpUz2RH6GUxj9i745JtnjbKoyfE/4c4stnsvvbn+OOWfcnzvNbeISdiDqxqHI=
X-Received: by 2002:a1c:ed03:: with SMTP id l3mr10071530wmh.130.1621621707519;
 Fri, 21 May 2021 11:28:27 -0700 (PDT)
MIME-Version: 1.0
From:   Daniele Salvatore Albano <d.albano@gmail.com>
Date:   Fri, 21 May 2021 21:28:01 +0300
Message-ID: <CAKq9yRiD+OjL7ZqZSQdbZVgb8NMFeWeH3eoxfW9CybNvfC875g@mail.gmail.com>
Subject: io_close_prep returns EBADF if REQ_F_FIXED_FILE
To:     io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Is there any specific reason for which io_close_prep returns EBADF if
using REQ_F_FIXED_FILE?

I discovered my software was failing to close sockets when using fixed
files a while ago but I put it to the side, initially thinking it was
a bug I introduced in my code.
In recent days I picked it up again and after investigating it, it
looks like that, instead, that's the expected behaviour.

From what I see, although the behaviour was slightly changed with a
couple of commits (ie. with
https://github.com/torvalds/linux/commit/cf3040ca55f2085b0a372a620ee2cb93ae19b686
) the io_close_prep have had this behaviour from the very beginning
https://github.com/torvalds/linux/commit/b5dba59e0cf7e2cc4d3b3b1ac5fe81ddf21959eb
.

@Jens during my researches I have also found
https://lkml.org/lkml/2020/5/7/1575 where there is a patch that
allows, at least from what it looks like at a first glance, fixed
files with io_close_prep but seems that the email thread died there.

Shouldn't the close op match the behaviour of the other I/O related
ops when it comes to fds?

If there aren't specific reasons, happy to look into it and write a patch.


Thanks,
Daniele

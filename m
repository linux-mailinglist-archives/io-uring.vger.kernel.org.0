Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30AA723E564
	for <lists+io-uring@lfdr.de>; Fri,  7 Aug 2020 03:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgHGBAr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Aug 2020 21:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgHGBAr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Aug 2020 21:00:47 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F70C061574
        for <io-uring@vger.kernel.org>; Thu,  6 Aug 2020 18:00:46 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id i10so395014ljn.2
        for <io-uring@vger.kernel.org>; Thu, 06 Aug 2020 18:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xlcgFJhNZ9/EKyqtVIg6l5Auc33voPfKTHPm9n79Xgk=;
        b=fihtTYWeRFsLnAPo2/8HSap1JRXc4kLy/SfcatMKPQuC0IoNiUp5d6luSQiGfssT9Y
         UYHIfEBhVtpKVXLFx5pfQVccJmmj9zcHF/V+sfsblEVWo+9ABOA3o3BcaKUxgJCKG9Nt
         NrFoF5yO2PGxmtcnauERIEreq4dU8qFvzf7JapTQR8za0v+XN1nJgucXL0ccee85+jqn
         mN+ewBveywZi/tThhKBtOHqncs2xZSwjlb5yOyTjSk3VOfBQRuVCvO74zAqZMHm91HNv
         zIQqVzakRHuS+LhlqB7E6XmLdZ4Id2mQJ+CKAjONNzsn6qhzIyTv0uCal6ZLXbxFsjtZ
         1XNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xlcgFJhNZ9/EKyqtVIg6l5Auc33voPfKTHPm9n79Xgk=;
        b=gGJOj3jdt8gG/2nIjf7TbpjAAtZKePffIYgF8Mo7SR8cFc3InX7/nHaOWkBYF3/K/Y
         wqejje0HnQFUkfefEX++/BSU36fDRKF898TZx/39OAlXl6jYpttgSA4yFHDyNW7Q3qL+
         oPecP//r0O10YQV2hoNNN4EoUJWWHstRfFr+OkJU63ro7zY+n5tc6pxqNwjyzTc6Fl4M
         302RUT+BspDz/cfJsR622g4sVib0BsEcEBQKwXL+9A+ejIwDF7YYPcz/18tn5Rk2WSaY
         IOLXxq/mzk20JD+QjHKzYYvtbEeE/8nnT28yQerdMtGaRUqPiJ7Zx2iagerDJPGxCUJJ
         SETQ==
X-Gm-Message-State: AOAM533uCTtopDjjSWfPLIJhyKQ7GNrluyWKmnemxhDzaB0ah8pdI77+
        nHmh/jId8UW55vVu8g2gLQ35yeLeTA6q0F0FlHrLlA==
X-Google-Smtp-Source: ABdhPJwF5seTjCe9i6h+1E/7y2WF0Sd5O/M/y4oJesMCaNYzE8srsZ8G4BZ6TsimXOZMA6EZfXkbGS/YqDqPrDPBC44=
X-Received: by 2002:a2e:302:: with SMTP id 2mr4614295ljd.156.1596762044328;
 Thu, 06 Aug 2020 18:00:44 -0700 (PDT)
MIME-Version: 1.0
References: <d6e647c8-5448-e496-10c0-3c319b0f4a03@kernel.dk>
In-Reply-To: <d6e647c8-5448-e496-10c0-3c319b0f4a03@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 7 Aug 2020 03:00:17 +0200
Message-ID: <CAG48ez0QE3+a1Gb8ovEv_54wG-HA=Ph7fM4MT8EU8Exti0c_SQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: use TWA_SIGNAL for task_work related to eventfd
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 7, 2020 at 1:57 AM Jens Axboe <axboe@kernel.dk> wrote:
> An earlier commit:
>
> b7db41c9e03b ("io_uring: fix regression with always ignoring signals in io_cqring_wait()")
>
> ensured that we didn't get stuck waiting for eventfd reads when it's
> registered with the io_uring ring for event notification, but that didn't
> cover the general case of waiting on eventfd and having that dependency
> between io_uring and eventfd.
>
> Ensure that we use signaled notification for anything related to eventfd.
[...]
> @@ -1720,7 +1720,7 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
>          */
>         if (ctx->flags & IORING_SETUP_SQPOLL)
>                 notify = 0;
> -       else if (ctx->cq_ev_fd)
> +       else if (ctx->cq_ev_fd || (req->file && eventfd_file(req->file)))
>                 notify = TWA_SIGNAL;

Is the idea here that you want "polling an eventfd" to have different
UAPI semantics compared to e.g. "polling a pipe"? Or is there
something in-kernel that makes eventfds special?

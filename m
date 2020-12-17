Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389092DCF98
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 11:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgLQKj1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Dec 2020 05:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgLQKj1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Dec 2020 05:39:27 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C952DC0617B0
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 02:38:46 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id p14so16747778qke.6
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 02:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DVhkOs+aW1dEduCtip4rp8EmtRtwNG8Mb5HjQN2btNE=;
        b=LPoMywsrBDJi08kc9nS/0LtlVgMpoOzYpRNNAdGeLPtVmZKb4QIfUYyA+vx/0sI4af
         bjfbEpVaVwzUZ8zZ+Ok1PeJA2qJT9VWJb/gK53crwthumyY3mVFx3IjcvDG2qA2bOEtt
         CPqBqAm7KmQbnZz1Zt1DbmPPTP0cxJU0lKOxDc5FBnZoggdP9Gu8noZSnE2Y39jSVkCf
         Y2U8e1qPETNKp1jK1nGtmzCDAYCgdZ7QSI4HeHp8ZRdQg+wlx02OM0MTSnNebhB2kaxq
         XRdKe4Rt7Dh5284tg6VRLzEWQNSmWusmh9KWcvkkECJlWZu35QL1WRBfdh/YQ8QX6V5/
         INTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DVhkOs+aW1dEduCtip4rp8EmtRtwNG8Mb5HjQN2btNE=;
        b=bp48qiURIgTNuGAmooSf0uOEtNVnPprV9PD3qfimFp4nGsBa2NjzboHbO1VDGZdzc1
         XFvXl/mwr1X79Vq3BA01aefgTk0uTjOswjlRk70E5xcR1Ie1Vld4kBRH7oV0dCv52z1B
         +W0KzowEhcuE/UCxaLF/9JZ1qIfzJnURmnCDdqDrAKmq5/rCX4IamRfBc7LERDf+i+v+
         ClA67umAIbo6xhQD7eJgmYfnXJx9qTX/XsgnbBdqNq3YQ5COsYqfyodrDRNQ3N7Ep1Iu
         JPXFFwV3v+pCsoKtWuRXgf7jyv+I87ogc1VYrWxPxt9r0y+xVjveeLKcxVyJlp3wmlpA
         GNQg==
X-Gm-Message-State: AOAM532DV4FgtexwePbBlFcT9d0CsFyUT3B3h9TwBnZU6gDqTxFFhKfD
        SpxZZNoG0dPTLXt/BsBlm02Fyb/U3qhxmud8R14=
X-Google-Smtp-Source: ABdhPJz+T+8dCtdpjmPg1CVCOB0r+VyQi53dCVlkVrJo+jctOKByjDSmAUHCy0XKAP4g1HrlrTgEXSb+O4q5RwFzS0E=
X-Received: by 2002:a37:7402:: with SMTP id p2mr48775846qkc.412.1608201525956;
 Thu, 17 Dec 2020 02:38:45 -0800 (PST)
MIME-Version: 1.0
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
 <8910B0D3-6C84-448E-8295-3F87CFFB2E77@googlemail.com> <CAOKbgA4V5aGLbotXz4Zn-7z8yOP5Jy_gTkpwk3jDSNyVTRCtkg@mail.gmail.com>
 <CAOKbgA5X7WWQ4LWN4hXt8Rc5qQOOG24tTyxsKos7KO1ybOeC1w@mail.gmail.com>
In-Reply-To: <CAOKbgA5X7WWQ4LWN4hXt8Rc5qQOOG24tTyxsKos7KO1ybOeC1w@mail.gmail.com>
From:   Josef <josef.grieb@gmail.com>
Date:   Thu, 17 Dec 2020 11:38:35 +0100
Message-ID: <CAAss7+owve47-D9SzLpzeCiPAOjKxhc5D2ZY-aQw5WOCvQA5wA@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> > That is curious. This ticket mentions Shmem though, and in our case it does
 > not look suspicious at all. E.g. on a box that has the problem at the moment:
 > Shmem:  41856 kB. The box has 256GB of RAM.
 >
 > But I'd (given my lack of knowledge) expect the issues to be related anyway.

what about mapped? mapped is pretty high 1GB on my machine, I'm still
reproduce that in C...however the user process is killed but not the
io_wq_worker kernel processes, that's also the reason why the server
socket still listening(even if the user process is killed), the bug
only occurs(in netty) with a high number of operations and using
eventfd_write to unblock io_uring_enter(IORING_ENTER_GETEVENTS)

(tested on kernel 5.9 and 5.10)

-- 
Josef

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1C747DDE0
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 03:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhLWCyl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Dec 2021 21:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhLWCyl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Dec 2021 21:54:41 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D8BC061574
        for <io-uring@vger.kernel.org>; Wed, 22 Dec 2021 18:54:41 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id t13so7434516uad.9
        for <io-uring@vger.kernel.org>; Wed, 22 Dec 2021 18:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9JjXTprqAk02JAfH0CXd5yn4iQepqJEyoV9b5W1dgbs=;
        b=gZ5p93/5P0fOtvH1lpr0Sw7VO3/txxqy+G+iKeKge+u7w4TjTOA1/pmCONJs+78G6e
         AoWsIp7u4kxEcpK0PMdyccriLgpKSpPSFn94zSkIU5t2RgWuWxb4l70ebn6Ke44PmRgg
         EkwVHJTEOB/6Csygr6YT9RsG+IoI3EHvCl6aSc24HOKU9tbtTLHjmTnaJAzf4LQMfZpy
         aUu2K/4TgGyd94PmWLqdqYdHTiy0CqqNMdendsCg20tXjcYg+gjAVSc5FpYnahtjDgJ+
         35xLPyVRoAOrbmy7T5IKx7/Qk+4+ellNx8O35SgcW0t6Yc9QWSGcTd0oD8vdhhaBfmV9
         z3KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9JjXTprqAk02JAfH0CXd5yn4iQepqJEyoV9b5W1dgbs=;
        b=H8ObNs7F/1f5QZNP1JSBhpS7T7i99/LH1R9dxFl9hvwzDr+anvFlYwPBz/2WeCU9i8
         IWcywhOtvk7yeDjN34iVg70S6lH5D/JBn/MS4GevliFYpAtuMUrKbuq083MiqFoXEdJL
         zZtpMHYp1pIRymZN0ytKJMqXTwSDJfRm7a5kPI3onsuJunRi2dRFfl8EhQ6v4rh04TAu
         1Mbf7oUjdc2DA91IYZHiS8YwfugeQIZPpKbyQzDS2leYSvjtPIya1K23yNXfnkTDYkPs
         QFGjUa6SOjMhJ5TvUpMkw+vvnxlRBb+AjEDdhy8OEi0nPQz/eQoRT5l2JeM19vuy205Z
         ZIJw==
X-Gm-Message-State: AOAM532pW3bdJdcZCfzLn9/drQveFhEfM03dwcWmcgBAG6jr5qjG3vNb
        NloyzPd0hUlNvIUbdIe1Ki9hvmFNGxN96oepyNMHDo28
X-Google-Smtp-Source: ABdhPJzCMoZmJ1SFc9fAxg6TqqWM4Pi3AgbKLoWJTlk1U5qjsKqHEvSO5jL+mTxV4FCQGs4p4GkVhfLAtP3CqiVjKtU=
X-Received: by 2002:a67:d207:: with SMTP id y7mr154373vsi.28.1640228080374;
 Wed, 22 Dec 2021 18:54:40 -0800 (PST)
MIME-Version: 1.0
References: <CANm61jem0rMt75PuaK_+-suX_WRi+jXPy3BqHZjAR95vzP73Jg@mail.gmail.com>
 <ffed412f-ab0a-aed5-925c-7364df3af95a@kernel.dk>
In-Reply-To: <ffed412f-ab0a-aed5-925c-7364df3af95a@kernel.dk>
From:   David Butler <croepha@gmail.com>
Date:   Wed, 22 Dec 2021 18:54:29 -0800
Message-ID: <CANm61jdL2uZcnR1YBY+j2oRBLX5fuRa-BQZazHeL8_JiMgVLnA@mail.gmail.com>
Subject: Re: Beginner question, user_data not getting filled in as expected
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

>
> You're doing a prep command after filling in the user_data, the former
> clears the sqe. Move the user_data assignment after
> io_uring_prep_readv().
>
> --
> Jens Axboe

Oh! Thanks!

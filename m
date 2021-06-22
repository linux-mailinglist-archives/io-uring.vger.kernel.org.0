Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88F43AFF3C
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 10:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhFVI3U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 04:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhFVI3T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 04:29:19 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05981C061574;
        Tue, 22 Jun 2021 01:27:03 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id f70so37291784qke.13;
        Tue, 22 Jun 2021 01:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sT2Cvv3I0Bzdmy45ZwysuiyqLCYkLgUgSzCyeBvjj4c=;
        b=pqOs9hMVFYyx40gUshhtOjjTrKe5OqNTDU0od8LzmIa/EPBrrpycsc4uGffvzK06qH
         hpiTTQ8BxuOZY7LRMejr/p42/Q0d1r4jQn6PDHo5fZiAnBOt0+c+ytvxOZsDR9GYkUMM
         hVkZ45eYlxS3djsCAMLssrUpQeNMvJUcVcJCK1OqeF8MFDZnbWkuIpBzUT+inQIaZbNF
         ORL2DjXybj94XTBVutXQv28TMzhR0R9AOiIpYuMdzO1LRuAQonY4qoGUFJ3MDVXHTFwI
         hOJJwj84xOXHyFb6Sdneb1LNQvEZXEy1C+9qsz9xljM/105oFGr+XQ809mXmcIMCGxwm
         le9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sT2Cvv3I0Bzdmy45ZwysuiyqLCYkLgUgSzCyeBvjj4c=;
        b=YOgDSz7IAfEFSs0v3E1wOYNR0snU8uHl+GAYYKwqjImtTJ4aUDRk8RC4IFmNPZY5Vo
         c9RZNOeQmup2otAMgS+oBHBuX0mhdlqkptBMTmofNVA6AELR+cT+kbsoRfBQp2PJf4jZ
         Q9e5TXc3tyvvM3xp0b59N9b3g2TxifrMWE31Vir5v1qDT5UTC53e9LDJrmUbBIkAZYQb
         4DBnmhFH6K0EzvoCqm55563ooLO3YeQifc9/XjmeKi+iYVioToXNv0pXvNLl3tSVrT92
         FiOgleCa6/o+oQ+PYfnfKttopfS3jnVFD7x3yegPd5cH60OJIRv5jfFlrAv99Fhd4EN3
         WKJQ==
X-Gm-Message-State: AOAM533VyhAIGghxOxetkXOqe1oET/M3GUfPLQY6Fv9ANkWzYkAf6YyV
        9QovloSWq9ork6TxdgnH9k1RCXBH7CWT2ZsgWJA=
X-Google-Smtp-Source: ABdhPJwGsv6Uh56dPxTCgPOlMuO45x4LfqDpAkjUZpSmfwqv/yuiy2TOobUVt05LJFdD8/4hyNxWJz3yaapirkaSA/s=
X-Received: by 2002:a5b:ac1:: with SMTP id a1mr3397432ybr.289.1624350422198;
 Tue, 22 Jun 2021 01:27:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210603051836.2614535-1-dkadashev@gmail.com> <CAOKbgA69B=nnNOaHH239vegj5_dRd=9Y-AcQBCD3viLxcH=LiQ@mail.gmail.com>
 <2c4d5933-965e-29b5-0c76-3f2e5f518fe8@kernel.dk> <a459abe3-b051-ea60-d8d9-412562a255d5@kernel.dk>
In-Reply-To: <a459abe3-b051-ea60-d8d9-412562a255d5@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Tue, 22 Jun 2021 15:26:51 +0700
Message-ID: <CAOKbgA7uk33+Odq46dO4Mzc0ew0Ui3B39+vtvHUWF+DvjCFMWg@mail.gmail.com>
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jun 21, 2021 at 10:21 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> I have tentatively queued this up.

Tentative "woohoo!"

-- 
Dmitry Kadashev

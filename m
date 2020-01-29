Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A46EB14CCDE
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 16:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgA2PAK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 10:00:10 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37391 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgA2PAK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 10:00:10 -0500
Received: by mail-oi1-f195.google.com with SMTP id q84so2361664oic.4
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 07:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=omvi006uoSkGNugxq2z5zaZnVOiQc2rMdlIWhLVZbwg=;
        b=PCK4W5lBe+iK4ppEQxlRAZj/UqpbfgT8kNikP+iSycDPX7yYxVzEZhPGhynvr3kqi6
         QKJu8m0UYZcgiNEQiDuET775mUzmZj3QJCA63EWnWMQyRljXwsVCR3tLtLA+JdjJYBe4
         ud+hrsnWfjDbFfgkXkA+6mOsIsGZ6DDxZzlqgkcSBei26vN1SjWp4i+FXfcQxfpzUkJA
         l5QdV72Enz3t4P9rBahlSsFKpR8/SQlDnYcZ0Gx2kig8ERTjgyFT4cqTdbL5uQeiof/l
         NBaKb1WAMzX29ljCQJtjf3IXU+88z2Eo5gJA5migSBIb5xt5jnlXCCQfGuutAByeYlqh
         e3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=omvi006uoSkGNugxq2z5zaZnVOiQc2rMdlIWhLVZbwg=;
        b=dagHVqRjTiIJncFLVYsiDXiTqGy9tZ5VD6tgzUciD0x0WEdovhBs90xW/cdtE5GfN1
         AWuQzK5ZyStOmdgMJ+ekt2eddT8wDE/B0xssROF8G+CD4myL/vRquvm0C7vqnDcw/UId
         dfArDJbXP7mXqAgFsm7dfOicnyygBBDMkygugmNBSyYZNcUTU6ujkZL3tUIBtwo2nPAY
         MHEK49Ec6DKFhvSfdgw3YNEbET53+SF/yMlC9Xj0hbN1LgqTJslRDWMnayg91VLVdyLK
         W3RjHQLIOimh2e7rssT4PYNF1uAis7ESXhPagZPHkwK0Qd6my0XnMCGMHE1hTro+kHpv
         H4mg==
X-Gm-Message-State: APjAAAWKcPTC3kpzffdTPfonaXkMj3KSlmPe86mQascwgWsq1mxWo+dC
        Us1DACN8scrPCTo38CJYM4zoaMlM4uIfIzEg3i9VezoAXs8=
X-Google-Smtp-Source: APXvYqzyNQVAmCfvPDXmRUybdNGIoHplNXgSnaYjfPNsQk7g41fDvA+v37GEmZ2Ar1n/f7nIvgS8+xYpQU+BdJnYWJY=
X-Received: by 2002:aca:b187:: with SMTP id a129mr6700000oif.175.1580310009446;
 Wed, 29 Jan 2020 07:00:09 -0800 (PST)
MIME-Version: 1.0
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk> <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk> <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk> <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
In-Reply-To: <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 29 Jan 2020 15:59:42 +0100
Message-ID: <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA@mail.gmail.com>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jan 28, 2020 at 8:42 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/28/20 11:04 AM, Jens Axboe wrote:
> > On 1/28/20 10:19 AM, Jens Axboe wrote:
[...]
> >> #1 adds support for registering the personality of the invoking task,
> >> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited to
> >> just having one link, it doesn't support a chain of them.
[...]
> I didn't like it becoming a bit too complicated, both in terms of
> implementation and use. And the fact that we'd have to jump through
> hoops to make this work for a full chain.
>
> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
> This makes it way easier to use. Same branch:
>
> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>
> I'd feel much better with this variant for 5.6.

Some general feedback from an inspectability/debuggability perspective:

At some point, it might be nice if you could add a .show_fdinfo
handler to the io_uring_fops that makes it possible to get a rough
overview over the state of the uring by reading /proc/$pid/fdinfo/$fd,
just like e.g. eventfd (see eventfd_show_fdinfo()). It might be
helpful for debugging to be able to see information about the fixed
files and buffers that have been registered. Same for the
personalities; that information might also be useful when someone is
trying to figure out what privileges a running process actually has.

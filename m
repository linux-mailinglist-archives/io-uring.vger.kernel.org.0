Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19E76925F7
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 20:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbjBJTCF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 14:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbjBJTCE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 14:02:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FFF65679
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 11:02:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45F3CB825AF
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 19:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18B6C433A7
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 19:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676055720;
        bh=E/qchUqCgMrqhO01lpil+Mub62mxWI4tbL+Ig99y+6M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HpodbIcQJGoRTOg6RbPJfi0gFwRkBnHyBYc1kEOAoAXo7rER7KaqCA5sbxVS8dSfw
         E/BLjVMXQhP/+4bq8iNuyDv17dCN5qE9p5ScpKseDseK/gZgksJC9ZqeWprVEVmfhA
         yMwWFZyFR+P1+jPraJVHnOobQtTKGYONtz4GpsOR06Xkccj0iKqlgncof31RFgruNQ
         ASc1vThVl9et2kCmuoHNYYCQLSPDUYfxdzDVDXDM+ZD2nuhxbnWjWqjtzItJ253v4w
         MKXHVHCwCAP6jJenz96jiXU2ViBYMMqgsHGgLDGlypGoilrQbnF+49xkrdFjupzPV+
         IyJ+mFDzIWIVA==
Received: by mail-ed1-f43.google.com with SMTP id fi26so5516709edb.7
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 11:01:59 -0800 (PST)
X-Gm-Message-State: AO0yUKX4uQZsQlI/oTJyH+omewplhIZ0StzIMFh7u2rIS8fiG3fq3gYZ
        z6bTiLQrSUGp5zV4DDe+WoDBYByGDenLDbD5kpyDdQ==
X-Google-Smtp-Source: AK7set9x9pw6hgD2dW1+GN20k1m5aEU1KvaMWkyLee7gBmQ0A5OhpixKJfIx8bgUWu+TViK+cwHUCyEdTDQ4IxJllj8=
X-Received: by 2002:a50:d595:0:b0:4ac:b481:2b7c with SMTP id
 v21-20020a50d595000000b004acb4812b7cmr201420edi.2.1676055718121; Fri, 10 Feb
 2023 11:01:58 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area> <20230210040626.GB2825702@dread.disaster.area>
 <Y+XLuYh+kC+4wTRi@casper.infradead.org> <20230210065747.GD2825702@dread.disaster.area>
 <CALCETrWjJisipSJA7tPu+h6B2gs3m+g0yPhZ4z+Atod+WOMkZg@mail.gmail.com>
 <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
 <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com> <CAHk-=wjQZWMeQ9OgXDNepf+TLijqj0Lm0dXWwWzDcbz6o7yy_g@mail.gmail.com>
In-Reply-To: <CAHk-=wjQZWMeQ9OgXDNepf+TLijqj0Lm0dXWwWzDcbz6o7yy_g@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 10 Feb 2023 11:01:46 -0800
X-Gmail-Original-Message-ID: <CALCETrWuRHWh5XFn8M8qx5z0FXAGHH=ysb+c6J+cqbYyTAHvhw@mail.gmail.com>
Message-ID: <CALCETrWuRHWh5XFn8M8qx5z0FXAGHH=ysb+c6J+cqbYyTAHvhw@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 10, 2023 at 10:37 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Feb 10, 2023 at 9:57 AM Andy Lutomirski <luto@kernel.org> wrote:
>
> I'm not convinced your suggestion of extending io_uring with new
> primitives is any better in practice, though.


I don't know if I'm really suggesting new primitives.  I think I'm
making two change suggestions that go together.

First, let splice() and IORING_OP_SPLICE copy (or zero-copy) data from
a file to a socket.

Second, either make splice more strict or add a new "strict splice"
variant.  Strict splice only completes when it can promise that writes
to the source that start after strict splice's completion won't change
what gets written to the destination.


I think that strict splice fixes Stefan's use case.  It's also easier
to reason about than regular splice.


The major caveat here is that zero-copy strict splice is fundamentally
a potentially long-running operation in a way that zero-copy splice()
isn't right now.  So the combination of O_NONBLOCK and strict splice()
(the syscall, not necessarily the io_uring operation) to something
like a TCP socket requires complicated locking or change tracking to
make sense.  This means that a splice() syscall providing strict
semantics to a TCP socket may just need to do a copy, at least in many
cases.  But maybe that's fine -- very-high-performance networking is
moving pretty aggressively to io_uring anyway.


And my possibly-quite-out-there claim is that, if Linux implements
strict splice, maybe non-strict splice could get replaced in a user
ABI-compatible manner with a much simpler non-zero-copy
implementation.  And strict splice from a file to a pipe could be
implemented as a copy -- high performance users can, if needed, start
strict-splicing from a file directly to a socket.

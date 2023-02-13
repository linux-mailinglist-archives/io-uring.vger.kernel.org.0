Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6718E694E99
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 19:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjBMSBv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 13:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjBMSBs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 13:01:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA30E20055
        for <io-uring@vger.kernel.org>; Mon, 13 Feb 2023 10:01:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70D3D61218
        for <io-uring@vger.kernel.org>; Mon, 13 Feb 2023 18:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76F1C433A1
        for <io-uring@vger.kernel.org>; Mon, 13 Feb 2023 18:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676311301;
        bh=hUhMtFd+L7kU2UfBGgkzPSaKO2S0M+fHeGGsoULquzs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mJhto6ulcvsXEIAxzLZBgi5DE3HQnOQsI6Gk46sWL0sVxD7q5fL0cJnuqYKwEOSwH
         QM7RwPx/lHR3+uyZ1gUqbKoMlYlXH4Q8JGioqsLnmew3IrN5fyl8Gquc8B9gwz+y0X
         sAQ2pQWGRj8Ir0w66U53uiit6AirOHpcMDPAxpBsp+cpWDUEmcmWjWo9j42RmX7L+U
         dq1XejB2AnDNpbQFriMv9O0m/hhta5a5/LG0l+CIw/O6jIVwa+0qCiSAKlrcv6LfA3
         k83v2zHTBSZO//0FhTyuF7H8NpwnOMTUrCA5KTVzGQZw21Me8uigMyWLNbBGJpQErq
         dhowz+ufACTIA==
Received: by mail-ed1-f52.google.com with SMTP id v13so14056222eda.11
        for <io-uring@vger.kernel.org>; Mon, 13 Feb 2023 10:01:41 -0800 (PST)
X-Gm-Message-State: AO0yUKWHfOhJm0GremEX7KEYQHGWSwenXrn0vZ3nH8zL7YgRY6UYPGgC
        i1MYRBjzNegKDBb9qAatMVQFE26leNVYX7gmRw0Tkg==
X-Google-Smtp-Source: AK7set9UjffZ8cIv9LXOfN7BXhlzgG3TlnmR1bNpfFvkCexf/s6su8bQqb/Qcrsj/09g6AsCSSy+hLqepFw/ZDipxP4=
X-Received: by 2002:a50:ba8d:0:b0:4ab:1c64:a9ed with SMTP id
 x13-20020a50ba8d000000b004ab1c64a9edmr5213538ede.2.1676311300124; Mon, 13 Feb
 2023 10:01:40 -0800 (PST)
MIME-Version: 1.0
References: <20230210061953.GC2825702@dread.disaster.area> <Y+oCBnz2nLtXrz7O@gondor.apana.org.au>
In-Reply-To: <Y+oCBnz2nLtXrz7O@gondor.apana.org.au>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 13 Feb 2023 10:01:27 -0800
X-Gmail-Original-Message-ID: <CALCETrXKkZw3ojpmTftur1_-dEi6BOo9Q0cems_jgabntNFYig@mail.gmail.com>
Message-ID: <CALCETrXKkZw3ojpmTftur1_-dEi6BOo9Q0cems_jgabntNFYig@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Dave Chinner <david@fromorbit.com>, torvalds@linux-foundation.org,
        metze@samba.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        samba-technical@lists.samba.org
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

On Mon, Feb 13, 2023 at 1:45 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Dave Chinner <david@fromorbit.com> wrote:
> >
> > IOWs, the application does not care if the data changes whilst they
> > are in transport attached to the pipe - it only cares that the
> > contents are stable once they have been delivered and are now wholly
> > owned by the network stack IO path so that the OTW encodings
> > (checksum, encryption, whatever) done within the network IO path
> > don't get compromised.
>
> Is this even a real problem? The network stack doesn't care at
> all if you modify the pages while it's being processed.  All the
> things you've mentioned (checksum, encryption, etc.) will be
> self-consistent on the wire.
>
> Even when actual hardware offload is involved it's hard to see how
> things could possibly go wrong unless the hardware was going out of
> its way to do the wrong thing by fetching from memory twice.
>

There's a difference between "kernel speaks TCP (or whatever)
correctly" and "kernel does what the application needs it to do".
When I write programs that send data on the network, I want the kernel
to send the data that I asked it to send.  As a silly but obvious
example, suppose I have two threads, and all I/O is blocking
(O_NONBLOCK is not set, etc):

char buffer[1024] = "A";

Thread A:
send(fd, buffer, 1, 0);

Thread B:
mb();
buffer[0] = 'B';
mb();


Obviously, there are three possible valid outcomes: Thread A can go
first (send returns before B changes the buffer), and 'A' gets sent.
Thread B can go first (the buffer is changed before send() starts),
and 'B' gets sent.  Or both can run concurrently, in which case the
data sent is indeterminate.

But it is not valid for send() to return, then the buffer to change,
and 'B' to get sent, just like:

char foo[] = "A";
send(fd, foo, 1, 0);
foo[0] = 'B';

must send 'A', not 'B'.

The trouble with splice() is that there is no clear point at which the
splice is complete and the data being sent is committed.  I don't
think user applications need the data committed particularly quickly,
but I do think it needs to be committed "eventually* and there needs
to be a point at which the application knows it's been committed.
Right now, if a user program does:

Write 'A' to a file
splice that file to a pipe
splice that pipe to a socket
... wait until when? ...
Write 'B' to a file

There is nothing the user program can wait for to make sure that 'A'
gets sent, but saying that the kernel speaks TCP correctly without
solving this problem doesn't actually solve the problem.

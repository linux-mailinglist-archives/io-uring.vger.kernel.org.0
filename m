Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F18E6802FC
	for <lists+io-uring@lfdr.de>; Mon, 30 Jan 2023 00:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjA2XiB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Jan 2023 18:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2XiA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Jan 2023 18:38:00 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622F67EE5
        for <io-uring@vger.kernel.org>; Sun, 29 Jan 2023 15:37:58 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so13800224pjq.0
        for <io-uring@vger.kernel.org>; Sun, 29 Jan 2023 15:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ii9FzGVPdJKeqmlVk6BfPihf+mnXJKtSNMOOo2LczXo=;
        b=TdgwbBC2khseugaXjKoePaiFnVk+3hmdfhoOgQhBmGp24IfmiXIB/zhxGUtbeiumye
         KD/8lQiZ4YKXlLpjiUVdOu/V+L76VEz5FsUjeSpl0roQ06tGt08zDJZ1qDk9LjL8BK3A
         S17nyOm8kfYvc29tifWLBmFROGdyKcn44vIu3q1QY4BO+eWmMsk6AGslSJXQqU7Z3HR6
         l2yN3byEwuqPLTTLGbV37kYcvb/Fv97d/2PEHxgwcvkLWLu/A5VlYw6I9IkS+v4s7/Ji
         FAGlNPG2Rl8M2j6ROepL2M2yIjaQWttTHXnp31FtgS4HvXAzXL2itgTd2Oyo1UP4EvcB
         b/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ii9FzGVPdJKeqmlVk6BfPihf+mnXJKtSNMOOo2LczXo=;
        b=ksJ9lsFGnopmV8/jD2wiOr9yh1mi6bdIz1kjCsDjH3kvyUvSUD5n8KaO0/vOKgUpgF
         UM4tJN8qElfgQZVAzniKPhSXh5QEIMenYs/dXU4kW1yCsLTX9uvEyetWYbicr7R84/Bh
         3POgjxaWtMTV3yOyqJ34Nak8rgRUgw56JOfXmODtMER8bb16UtrFLN4lUGR9F2ovmrNr
         3lqqAH3vikPDETK08Cuzyd7TZnfWj7hqQgos9fAaE7lgyUBfiqQkXIpLBZoYBN+m49u5
         TJWr9fO7cdjW2/ts1wGJzNGrT6WoLfpvrfw5JG1hPo0f8LuOgvI3QBf3yCBTC1Boj3SI
         4WrQ==
X-Gm-Message-State: AO0yUKUJyJm2JTIhxvkP1li+77lwVrsQkOCFDtZ3UVM91m26JiK12w8a
        cdQdZzRTwqTeQUBemWB/FqJkl7t4YrtgTx3UQZqw
X-Google-Smtp-Source: AK7set9i6kPMbxYMLoRoKdYNnrxmH+/Q1k10jefV7aKr2PmLgJDp7B1Q7hjCwqAcpxG54WssPx5U8ncUkGb/WCFxaLA=
X-Received: by 2002:a17:90a:19c8:b0:22c:b70b:15ba with SMTP id
 8-20020a17090a19c800b0022cb70b15bamr13988pjj.193.1675035477513; Sun, 29 Jan
 2023 15:37:57 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674682056.git.rgb@redhat.com> <f602429ce0f419c2abc3ae5a0e705e1368ac5650.1674682056.git.rgb@redhat.com>
 <CAHC9VhQiy9vP7BdQk+SXG7gQKAqOAqbYtU+c9R0_ym0h4bgG7g@mail.gmail.com> <13202484.uLZWGnKmhe@x2>
In-Reply-To: <13202484.uLZWGnKmhe@x2>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 29 Jan 2023 18:37:46 -0500
Message-ID: <CAHC9VhRXUe_RiTT1VqkA_Jv08MFCMvYytZkjKcf77EqyVLi-Tw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] io_uring,audit: do not log IORING_OP_*GETXATTR
To:     Steve Grubb <sgrubb@redhat.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 28, 2023 at 12:26 PM Steve Grubb <sgrubb@redhat.com> wrote:
> On Friday, January 27, 2023 5:43:02 PM EST Paul Moore wrote:
> > On Fri, Jan 27, 2023 at 12:24 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Getting XATTRs is not particularly interesting security-wise.
> > >
> > > Suggested-by: Steve Grubb <sgrubb@redhat.com>
> > > Fixes: a56834e0fafe ("io_uring: add fgetxattr and getxattr support")
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > > io_uring/opdef.c | 2 ++
> > > 1 file changed, 2 insertions(+)
> >
> > Depending on your security policy, fetching file data, including
> > xattrs, can be interesting from a security perspective.  As an
> > example, look at the SELinux file/getattr permission.
> >
> > https://github.com/SELinuxProject/selinux-notebook/blob/main/src/object_cla
> > sses_permissions.md#common-file-permissions
>
> We're mostly interested in setting attributes because that changes policy.
> Reading them is not interesting unless the access fails with EPERM.

See my earlier comments, SELinux does have provisions for caring about
reading xattrs, and now that I look at the rest of the LSMs it looks
like Smack cares about reading xattrs too.  Regardless of whether a
given security policy cares about xattr access, the LSMs support
enforcing access on reading xattrs so we need to ensure the audit is
setup properly in these cases.

> I was updating the user space piece recently and saw there was a bunch of
> "new" operations. I was commenting that we need to audit 5 or 6 of the "new"
> operations such as IORING_OP_MKDIRATor IORING_OP_SETXATTR. But now that I see
> the patch, it looks like they are auditable and we can just let a couple be
> skipped. IORING_OP_MADVISE is not interesting as it just gives hiints about
> the expected access patterns of memory. If there were an equivalent of
> mprotect, that would be of interest, but not madvise.

Once again, as discussed previously, it is likely that skipping
auditing for IORING_OP_MADVISE is okay, but given that several of the
changes in this patchset were incorrect, I'd like a little more
thorough investigation before we skip auditing on madvise.

> There are some I'm not sure about such as IORING_OP_MSG_RING and
> IORING_OP_URING_CMD. What do they do?

Look at 4f57f06ce218 ("io_uring: add support for IORING_OP_MSG_RING
command") for the patch which added IORING_OP_MSG_RING as it has a
decent commit description.  As for IORING_OP_URING_CMD, there were
lengthy discussions about it on the mailing lists (including audit)
back in March 2022 and then later in August on the LSM, SELinux, etc.
mailing lists when we landed some patches for it (there were no audit
changes).  I also covered the IORING_OP_URING_CMD, albeit briefly, in
a presentation at LSS-EU last year:

https://www.youtube.com/watch?v=AaaH6skUEI8
https://www.paul-moore.com/docs/2022-lss_eu-iouring_lsm-pcmoore-r3.pdf

--
paul-moore.com

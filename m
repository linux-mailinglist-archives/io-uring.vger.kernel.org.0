Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1A769B659
	for <lists+io-uring@lfdr.de>; Sat, 18 Feb 2023 00:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjBQXO4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Feb 2023 18:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjBQXOy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Feb 2023 18:14:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5DC68E67
        for <io-uring@vger.kernel.org>; Fri, 17 Feb 2023 15:14:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 490D962081
        for <io-uring@vger.kernel.org>; Fri, 17 Feb 2023 23:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6A9C433AC
        for <io-uring@vger.kernel.org>; Fri, 17 Feb 2023 23:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676675608;
        bh=007Ju5hmo469I+GLbhKmQyFOblRRKqP7+IKJhGVg3Bc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FVQuLHu9su+8MtuqreGX0M6eUP2draqAXJj4M0+8pCp7wP3cq/lR7ACHIf24dTWkq
         b+prnybkvEZUYcirmWUlld+/8oqr6Nlbu01GGr+WwVByKApBo1afHnsziIFQI2erWf
         EGwGBTF+S6LSfMq241TKKmHuZRPX6qF35zA6vNp9ovpCBLGLSuQb95HK4Pn/rKOk+N
         Q29erYenPL3+a3yt35AFu9AbVpoMWykSXPezSdlvTG0r5dcYRXTe3mPJC9QqOkNZ6+
         ArzBr6bVo48aEYAhQoN4OGqbh5dK+dGwwlaEtAELclY4hqR6CWmZhFUEuGC2Xr7W+S
         OAFm4QbGrDmsw==
Received: by mail-ed1-f48.google.com with SMTP id i28so9466067eda.8
        for <io-uring@vger.kernel.org>; Fri, 17 Feb 2023 15:13:28 -0800 (PST)
X-Gm-Message-State: AO0yUKWWGPmTR/+M5nkiMeE0K1Z66gTajUdXedfiZpKup76s1EMCXZ9A
        X8lFOWk/ouMcKSNoAE70mNMjTCPzaspFgfjVOa/fgw==
X-Google-Smtp-Source: AK7set8/bNsrYafbYm0zAE3nFVOlai7VLZ8imlSdGrFod1cdz9z2k4ibd74H3rjwb0A7aOD2eNsBGzV5MLYpkJRFYLE=
X-Received: by 2002:a17:907:6c14:b0:8ae:cb48:3c80 with SMTP id
 rl20-20020a1709076c1400b008aecb483c80mr5175474ejc.7.1676675606807; Fri, 17
 Feb 2023 15:13:26 -0800 (PST)
MIME-Version: 1.0
References: <20230210061953.GC2825702@dread.disaster.area> <Y+oCBnz2nLtXrz7O@gondor.apana.org.au>
 <CALCETrXKkZw3ojpmTftur1_-dEi6BOo9Q0cems_jgabntNFYig@mail.gmail.com> <Y+riPviz0em9L9BQ@gondor.apana.org.au>
In-Reply-To: <Y+riPviz0em9L9BQ@gondor.apana.org.au>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 17 Feb 2023 15:13:14 -0800
X-Gmail-Original-Message-ID: <CALCETrXr8vRPqEjhSg7=adQcM7OfWs_+fn2xP5OQeLXAaLzHHQ@mail.gmail.com>
Message-ID: <CALCETrXr8vRPqEjhSg7=adQcM7OfWs_+fn2xP5OQeLXAaLzHHQ@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        torvalds@linux-foundation.org, metze@samba.org, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On Feb 13, 2023, at 5:22 PM, Herbert Xu <herbert@gondor.apana.org.au> wro=
te:
>
> =EF=BB=BFOn Mon, Feb 13, 2023 at 10:01:27AM -0800, Andy Lutomirski wrote:
>>
>> There's a difference between "kernel speaks TCP (or whatever)
>> correctly" and "kernel does what the application needs it to do".
>
> Sure I get where you are coming from.  It's just that the other
> participants in the discussion were thinking of stability for the
> sake of TCP (or TLS or some other protocol the kernel implements)
> and that simply is a non-issue.

I can certainly imagine TLS or similar protocols breaking if data
changes if the implementation is too clever and retransmission
happens.  Suppose 2000 bytes are sent via splice using in-kernel TLS,
and it goes out on the wire as two TCP segments.  The first segment is
dropped but the second is received.  The kernel resends the first
segment using different data.  This really ought to cause an integrity
check at the far end to fail.

I don't know if any existing kTLS is clever enough to regenerate
outgoing data when it needs to retransmit a segment, but it would be
an interesting optimization for serving static content over TLS.



>
> Having a better way to communicate completion to the user would be
> nice.  The only way to do it right now seems to be polling with
> SIOCOUTQ.
>
>

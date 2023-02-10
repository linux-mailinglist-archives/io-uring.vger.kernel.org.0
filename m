Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D6C69253D
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 19:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbjBJSUL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 13:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbjBJSUJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 13:20:09 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF526A730;
        Fri, 10 Feb 2023 10:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=PtdWmRFylJvBmX2IAcm65PdjtLIX5BPy4K+OpONMbJI=; b=2AT85G2ey0JjUTr9HJI84ayqma
        4XZmHUCPZg3Fl2G+wtQB+Icbc6Jt2jaZ3sLoRS2b5w4Zl1sGz9YxmXnMDTyq+dIUq/TjI8H/xTIVE
        Sg6czi6ZZNv5uqjyghLWMGc5kA/3DS1lu8szeIFtPyOZTWFYJdfOH5HZ0aHQf2BSQh1L7Es9UF4rK
        Rhu1HCt8YaBXwGz1UVGjotJicaZXgiPb+9Gv21BQcvX73U7I0xe5RGKzI/rsiPgcnVOeuqpIh3FZE
        1XggXKiOnmf02qVQ41UJSoJqu43WulRNZbPuUt/C0U69EVz+hFDeNaOKEQx6nmjz+DAA6a9s7SE2U
        yK7KaKXf8Ahgv5Rx0r8MR5pxHTFAMFtOE0wyQCcAlwROCAjK/Swx4nGMbJpxyOSjuBKdoQzoR/N1q
        an6gQJbeDcUCp/lBRzvcHBW/iQCN8XxugIC3v79XOEU1OeAnQS3VgZgIVXS+4wyvvdMHGSwgFrmBD
        +zOLdhDh4PI49Jil5d5y08HQ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pQXzo-00D2jz-UF; Fri, 10 Feb 2023 18:19:41 +0000
Date:   Fri, 10 Feb 2023 10:19:36 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: copy on write for splice() from file to pipe?
Message-ID: <Y+aKuC1PuvX4STEI@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area>
 <20230210040626.GB2825702@dread.disaster.area>
 <Y+XLuYh+kC+4wTRi@casper.infradead.org>
 <20230210065747.GD2825702@dread.disaster.area>
 <CALCETrWjJisipSJA7tPu+h6B2gs3m+g0yPhZ4z+Atod+WOMkZg@mail.gmail.com>
 <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
 <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 10, 2023 at 09:57:20AM -0800, Andy Lutomirski via samba-technical wrote:
>
>(And if Samba needs to make sure that future writes don't change the
>outgoing data even two seconds later when the data has been sent but
>not acked, then maybe a fancy API could be added to help, or maybe
>Samba shouldn't be using zero copy IO in the first place!)

Samba doesn't need any of this. The simplest thing to do is
to restrict splice-based zero-copy IO to files leased by
a single client, where exclusive access to changes is controled
by the client redirector.

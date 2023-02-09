Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540FD691220
	for <lists+io-uring@lfdr.de>; Thu,  9 Feb 2023 21:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjBIUdL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 15:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBIUdL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 15:33:11 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCA62D156;
        Thu,  9 Feb 2023 12:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=8lKrEZV9yEJIi0kn0dn+QeXatghJ23bQPCt58aXU5vk=; b=Z0gY7l7FeI7MJx19vhNl6NnbDu
        8xSDF8e5b9YUCAK3UUK8QxLZecE0pnvOvxwtqwJFCqoL5n4/QOgDaxH/g0z0Lvm4pLDD7nPTmp70E
        LgTLVc0mjTeFBy41EZK6oxCrkDx2BrN4y1v+Xi807y3QLOTcFM130sdSD9Ic+uyoeh+8ayqGKSZGI
        0SU3ycY+SWwXkIuQJDsnpwqO9wSmQ0vxoT04q2dBeyOMptdo3dTXddhJ96BSQXVhZGpGAMUBgTiwu
        GCzlwCCC59bwKGaMcI6YciLBEHKKOucH2zTdzeaO5BMeZ0PEK6JYTr917AkEkWjl9BBpNTqxfEHhe
        NAJjwlngIEA9L2pEpt7WU+OshjR/7EfRRqs+ZUTEbROgH9ynob+3bB9oYICMSR9J9wqISR9oh4xvf
        rL87QFt8m+WLjNQfd5aTlabU/MQt7NCu9J5FOQVvw6aVOL+kvbWTX1uezc2//GiplGcL4/yVWzXwQ
        N1BFCjs14bjZ0GX/JlSygJZb;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pQDbM-00CsAc-96; Thu, 09 Feb 2023 20:33:04 +0000
Date:   Thu, 9 Feb 2023 12:33:00 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: copy on write for splice() from file to pipe?
Message-ID: <Y+VYfHcNdvez6M2a@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <f6c6d42e-337a-bbab-0d36-cfcc915d26c6@samba.org>
 <CAHk-=widtNT9y-9uGMnAgyR0kzyo0XjTkExSMoGpbZgeU=+vng@mail.gmail.com>
 <CAHk-=whprvcY=KRh15uqtmVqR2rL-H1yN6RaswHiWPsGHDqsSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHk-=whprvcY=KRh15uqtmVqR2rL-H1yN6RaswHiWPsGHDqsSQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 09, 2023 at 11:48:35AM -0800, Linus Torvalds via samba-technical wrote:
>
>So this is exactly *why* splicing from a file all the way to the
>network will then show any file changes that have happened in between
>that "splice started" and "network card got the data". You're supposed
>to use splice only when you can guarantee the data stability (or,
>alternatively, when you simply don't care about the data stability,
>and getting the changed data is perfectly fine).

Metze, correct me if I'm wrong but isn't this exactly the "file
is leased in SMB3" case ?

We already know if a file is leased, and so only use the splice calls
for I/O in that case, and fall back to the slower calls in the
non-leased case.

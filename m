Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF1C337059
	for <lists+io-uring@lfdr.de>; Thu, 11 Mar 2021 11:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbhCKKnp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 05:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbhCKKnR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 05:43:17 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D85C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 02:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=uw2e3YQ2NOEf5iE6HaBQEUnF9u8t92q1MumYwg76K8Q=; b=hJwQfxHuJszQs+tUNdFmO0u344
        TLpd1EIV9w9qi14vpgnfqiot2Gq2rSDT7VNrzi1nZoRsACVbeSGQ7mqQ+SH/r60GWocIIGIAVZdKH
        FxXncWZIjtcJ0JVgnHWICH2PO2rekGitQrRaszfz02fffu+jHotpyJtNddCYfPc36e5+KShkVyW8O
        sycFrb7Sej5yG6QyHfItjE04yLCW6cnUKaPSBqh3ZLWKcfMXbPei3pFq+S+nyIVxZnDJ2twMR01AS
        95iVrJBn5f7cQfiYCMVfHjiNsky4jQbsuv0rdZo1LIpzR7ANUVPErVr1AhUFpSF+U1jGctDBg05Y2
        vhbxHrga9Hpnf3ex5NuSrvL2NCEokeWKlnrdTam1zzh7mfsSY+4lhjIrjZmHPrvmz2orLJssRdHUg
        4qtZaYhfSN65F+wu+7Sqe1lgddSrPt0b3Mu5i1lYJv8s1cYpykegSAdMauP+3NsMFANJOKTrbMCBH
        8IY4Kmx6u5mGcREDT/5tq7Ak;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lKIme-0001tl-QJ; Thu, 11 Mar 2021 10:43:12 +0000
Subject: Backporting to stable... Re: [GIT PULL] io_uring thread worker change
To:     Jens Axboe <axboe@kernel.dk>, torvalds@linux-foundation.org
Cc:     io-uring@vger.kernel.org
References: <0c142458-9473-9df3-535f-34c06957d464@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <adb0cce8-0533-b7b0-d12c-9beb9e28f81a@samba.org>
Date:   Thu, 11 Mar 2021 11:43:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <0c142458-9473-9df3-535f-34c06957d464@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

> I'm sure we're going to find little things to patch up after this
> series, but testing has been pretty thorough, from the usual regression
> suite to production. Any issue that may crop up should be manageable.
> There's also a nice series of further reductions we can do on top of
> this, but I wanted to get the meat of it out sooner rather than later.
> The general worry here isn't that it's fundamentally broken. Most of the
> little issues we've found over the last week have been related to just
> changes in how thread startup/exit is done, since that's the main
> difference between using kthreads and these kinds of threads. In fact,
> if all goes according to plan, I want to get this into the 5.10 and 5.11
> stable branches as well.

That would mean that IORING_FEAT_SQPOLL_NONFIXED would be implicitly be backported
from 5.11 to 5.10, correct?

I'm wondering if I can advice people to move to 5.10 (as it's an lts release)
in order to get a kernel that is most likely very useful to use in combination
with Samba's drafted usage of io_uring, where I'd like to use IORING_FEAT_SQPOLL_NONFIXED
and IORING_FEAT_NATIVE_WORKERS in order to use SENDMSG/RECVMSG with msg_control buffers (where
the control buffers may reference file descriptors).

Thanks!
metze


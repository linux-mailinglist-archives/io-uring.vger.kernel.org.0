Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2E6693283
	for <lists+io-uring@lfdr.de>; Sat, 11 Feb 2023 17:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjBKQg6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 11:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjBKQg4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 11:36:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A535613535;
        Sat, 11 Feb 2023 08:36:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7161FCE02C7;
        Sat, 11 Feb 2023 16:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963D6C433EF;
        Sat, 11 Feb 2023 16:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676133410;
        bh=GE2rigzIx2DjQ8O+jrd3+B734zaDnbN6WgDv4gJ5k2g=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=NjaXE8ie7K93I3+rPEAmtn704ih65qNievx7OSVmX41+zPGQhtQE4qfYz7DP2DGFq
         sd9mgfbt2441+L0tYRKZMPYyoZQoJwBhQMtwYlRdcwyFRNVCkQRNR3Kr7mKTK4sgh9
         2k5mpFVjbD7SF+zZ9IgYb7tmvg9Mdwn7XZxA5tSPmBAQ7lMyqnc1lnK+VK/SRHaNBG
         jtVj0Oeg5Z2z4E19cKtAwfsiw3MPqAEjzmteKjfNms2eW8lBzeoRXc8MqqNYft1b+V
         8x1FWOj8QvkILsIYzQbTcXI3YEHVwYTAsKX3iKcDvizkKlPcuFPOHPLrzz4BRKTerG
         sf0l/ArpUTqFw==
Date:   Sat, 11 Feb 2023 08:36:50 -0800
From:   Kees Cook <kees@kernel.org>
To:     syzbot <syzbot+cdd9922704fc75e03ffc@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, keescook@chromium.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, syzkaller-bugs@googlegroups.com,
        io-uring@vger.kernel.org
Subject: Re: [syzbot] BUG: bad usercopy in io_openat2_prep
User-Agent: K-9 Mail for Android
In-Reply-To: <00000000000088b3d905f46ed421@google.com>
References: <00000000000088b3d905f46ed421@google.com>
Message-ID: <B83C9F6F-569B-4DCB-9FFE-45D9B1E32B21@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On February 11, 2023 8:08:52 AM PST, syzbot <syzbot+cdd9922704fc75e03ffc@sy=
zkaller=2Eappspotmail=2Ecom> wrote:
>Hello,
>
>syzbot found the following issue on:
>
>HEAD commit:    ca72d58361ee Merge branch 'for-next/core' into for-kernel=
ci
>git tree:       git://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/arm64/l=
inux=2Egit for-kernelci
>console output: https://syzkaller=2Eappspot=2Ecom/x/log=2Etxt?x=3D14a882f=
3480000
>kernel config:  https://syzkaller=2Eappspot=2Ecom/x/=2Econfig?x=3Df3e7823=
2c1ed2b43
>dashboard link: https://syzkaller=2Eappspot=2Ecom/bug?extid=3Dcdd9922704f=
c75e03ffc
>compiler:       Debian clang version 15=2E0=2E7, GNU ld (GNU Binutils for=
 Debian) 2=2E35=2E2
>userspace arch: arm64
>syz repro:      https://syzkaller=2Eappspot=2Ecom/x/repro=2Esyz?x=3D12037=
77b480000
>C reproducer:   https://syzkaller=2Eappspot=2Ecom/x/repro=2Ec?x=3D124c1ea=
3480000
>
>Downloadable assets:
>disk image: https://storage=2Egoogleapis=2Ecom/syzbot-assets/e2c91688b4cd=
/disk-ca72d583=2Eraw=2Exz
>vmlinux: https://storage=2Egoogleapis=2Ecom/syzbot-assets/af105438bee6/vm=
linux-ca72d583=2Exz
>kernel image: https://storage=2Egoogleapis=2Ecom/syzbot-assets/4a28ec4f8f=
7e/Image-ca72d583=2Egz=2Exz
>
>IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
>Reported-by: syzbot+cdd9922704fc75e03ffc@syzkaller=2Eappspotmail=2Ecom
>
>usercopy: Kernel memory overwrite attempt detected to SLUB object 'pid' (=
offset 24, size 24)!

This looks like some serious memory corruption=2E The pid slab is 24 bytes=
 in size, but struct io_open is larger=2E=2E=2E Possible UAF after the memo=
ry being reallocated to a new slab??

-Kees

> [=2E=2E=2E]
>Call trace:
> usercopy_abort+0x90/0x94
> __check_heap_object+0xa8/0x100
> __check_object_size+0x208/0x6b8
> io_openat2_prep+0xcc/0x2b8
> io_submit_sqes+0x338/0xbb8
> __arm64_sys_io_uring_enter+0x168/0x1308
> invoke_syscall+0x64/0x178
> el0_svc_common+0xbc/0x180
> do_el0_svc+0x48/0x110
> el0_svc+0x58/0x14c
> el0t_64_sync_handler+0x84/0xf0
> el0t_64_sync+0x190/0x194



--=20
Kees Cook

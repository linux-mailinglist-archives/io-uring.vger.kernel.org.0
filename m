Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4823E4EE0
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 00:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbhHIWBw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 18:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbhHIWBv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 18:01:51 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6C3C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 15:01:30 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gz13-20020a17090b0ecdb0290178c0e0ce8bso1075463pjb.1
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 15:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=7NB14qEIRTMd0rHmjj6plGSGJlsRbVcEpP0iyx0B0xI=;
        b=ccPYKbr73Vg1BIAQOm9xo6J9wyzogWJXw3XNbZNSyLiv8kHBkQkNRz3TUPA6aMqgKZ
         rlg21LGrpO//2Dw5143XwsgJw2YEC+dIL4pK49Nw4+Rx5uw6NPYmMhBnJxXdY0aPs8xI
         BRK8QEOK3q3zajF3ZXvuQDTv+23oRBfy/nLAnhXwdM3qoJnBr15IIWURYjhAx8XRTqjd
         E/aMBiJ06b9gTZk4Hqodx6XDHwjmmCrBYQxUeh1Wtjm+YyQNjD68AFYVbe8uLkRoNdkH
         LlZzR9Kte2fDpgG0VmEnkzfT/x6w3WCqGoyYN0G/7LhxaGldXEZcSQYVRbglbxCCSU6/
         xeag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=7NB14qEIRTMd0rHmjj6plGSGJlsRbVcEpP0iyx0B0xI=;
        b=SLu9JPGirYOxqRhGjX7zpikjVFSRchiA9hlP4imgaYY+q1Mj9QcvAgsUAX92JyN8UM
         EEXZM8g8g5L0IJQL6ju43jNpOWz94DQ+/paoIn37YWktPJ4N89v2SrkYWTyXDI+bXzNp
         +xWyj3WIwd22cWEHgXsuuT5yuI78rUINd83k91eLEUnTSOR2MLRTcwei0EI+DMpnklTI
         4vxjnAHOpx2QdfcsMmNLvTA7W8e+jJW+EimmSMyZjmn5cY96vYP3W2Fyr3g9OoN7az5p
         Z5wTZFHBkOo9E/dEzkWNAACyPUsVbgsGJxfqOkLYBGabA5IcaFEXCKxtDJOe1r7Ggfmq
         AsGA==
X-Gm-Message-State: AOAM530Cu9ogI1CRCvaKyeEZBMSkrTz+LuuSO7oTlFrt1XhCVPNDOJuV
        6qogc/erm7UvEnKiWoshnd8=
X-Google-Smtp-Source: ABdhPJzqBlttLiuZZXiFACNeIr+wMtRUoFg8GCYEKPYzFHA2aAQmelt+GxeCpJRfPrw202+i7SJWKg==
X-Received: by 2002:a62:b604:0:b029:39a:c5d6:58 with SMTP id j4-20020a62b6040000b029039ac5d60058mr26511879pff.51.1628546490150;
        Mon, 09 Aug 2021 15:01:30 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id c206sm21276780pfb.160.2021.08.09.15.01.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 15:01:29 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: iouring locking issue in io_req_complete_post() /
 io_rsrc_node_ref_zero()
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <3f2529b9-7815-3562-9978-ee29bf7692e5@kernel.dk>
Date:   Mon, 9 Aug 2021 15:01:27 -0700
Cc:     io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <633EF027-6473-466B-8683-E5CBC10B0F5F@gmail.com>
References: <C187C836-E78B-4A31-B24C-D16919ACA093@gmail.com>
 <3f2529b9-7815-3562-9978-ee29bf7692e5@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


> On Aug 9, 2021, at 6:49 AM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> On 8/8/21 10:36 PM, Nadav Amit wrote:
>> Jens, others,
>>=20
>> Sorry for bothering again, but I encountered a lockdep assertion =
failure:
>>=20
>> [  106.009878] ------------[ cut here ]------------
>> [  106.012487] WARNING: CPU: 2 PID: 1777 at kernel/softirq.c:364 =
__local_bh_enable_ip+0xaa/0xe0
>> [  106.014524] Modules linked in:
>> [  106.015174] CPU: 2 PID: 1777 Comm: umem Not tainted 5.13.1+ #161
>> [  106.016653] Hardware name: VMware, Inc. VMware Virtual =
Platform/440BX Desktop Reference Platform, BIOS 6.00 07/22/2020
>> [  106.018959] RIP: 0010:__local_bh_enable_ip+0xaa/0xe0
>> [  106.020344] Code: a9 00 ff ff 00 74 38 65 ff 0d a2 21 8c 7a e8 ed =
1a 20 00 fb 66 0f 1f 44 00 00 5b 41 5c 5d c3 65 8b 05 e6 2d 8c 7a 85 c0 =
75 9a <0f> 0b eb 96 e8 2d 1f 20 00 eb a5 4c 89 e7 e8 73 4f 0c 00 eb ae =
65
>> [  106.026258] RSP: 0018:ffff88812e58fcc8 EFLAGS: 00010046
>> [  106.028143] RAX: 0000000000000000 RBX: 0000000000000201 RCX: =
dffffc0000000000
>> [  106.029626] RDX: 0000000000000007 RSI: 0000000000000201 RDI: =
ffffffff8898c5ac
>> [  106.031340] RBP: ffff88812e58fcd8 R08: ffffffff8575dbbf R09: =
ffffed1028ef14f9
>> [  106.032938] R10: ffff88814778a7c3 R11: ffffed1028ef14f8 R12: =
ffffffff85c9e9ae
>> [  106.034363] R13: ffff88814778a000 R14: ffff88814778a7b0 R15: =
ffff8881086db890
>> [  106.036115] FS:  00007fbcfee17700(0000) GS:ffff8881e0300000(0000) =
knlGS:0000000000000000
>> [  106.037855] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  106.039010] CR2: 000000c0402a5008 CR3: 000000011c1ac003 CR4: =
00000000003706e0
>> [  106.040453] Call Trace:
>> [  106.041245]  _raw_spin_unlock_bh+0x31/0x40
>> [  106.042543]  io_rsrc_node_ref_zero+0x13e/0x190
>> [  106.043471]  io_dismantle_req+0x215/0x220
>> [  106.044297]  io_req_complete_post+0x1b8/0x720
>> [  106.045456]  __io_complete_rw.isra.0+0x16b/0x1f0
>> [  106.046593]  io_complete_rw+0x10/0x20
>>=20
>> [ .... The rest of the call-stack is my stuff ]=20
>>=20
>>=20
>> Apparently, io_req_complete_post() disables IRQs and this code-path =
seems
>> valid (IOW: I did not somehow cause this failure). I am not familiar =
with
>> this code, so some feedback would be appreciated.
>=20
> Can you try with this patch?

Thanks! I might have hit another issue, but apparently even if it is
real, it is unrelated.

Tested-by: Nadav Amit <nadav.amit@gmail.com>


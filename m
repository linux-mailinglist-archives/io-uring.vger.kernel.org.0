Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1006603D0
	for <lists+io-uring@lfdr.de>; Fri,  6 Jan 2023 17:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbjAFQAX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Jan 2023 11:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbjAFQAN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Jan 2023 11:00:13 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6980054D94
        for <io-uring@vger.kernel.org>; Fri,  6 Jan 2023 08:00:11 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
        by gnuweeb.org (Postfix) with ESMTPSA id 336CB7E552
        for <io-uring@vger.kernel.org>; Fri,  6 Jan 2023 16:00:11 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673020811;
        bh=cQatdWmMG0sGd67JA8N1SWncNYJiAn/XaMuh4drZ2H8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CK02iYJst3j6PNYyV8EZVV3HwswUyavnYusU9HKYO+n1DKpN2xooVcENjtsfKeMoQ
         EnFaffqGD9P8sG7cM3t4gIjUblMshYLX7n5ETTejrVwgW0UFXOoHCrYFb3As9HGQIf
         XZJeG+0P3HZdCetec7hikwBXDRD3YE6Vkp/GQ7tHAyPX7Q0sXNBXjeLJjG4MzkOiZr
         2wiY0WxO6ZxYOaBbXv0A2lyabNl7wBizqEu6yV2Osb4kpD4a91VabRIjcKSGUr6ZZN
         xJjbv8szr1wHawMRk7baeTXyasXoCiqhM2fI9kl0z7CPFXNksqjBnq6w7a1fu9s3+c
         J6GyLxAnCw+sg==
Received: by mail-lj1-f182.google.com with SMTP id g14so1843217ljh.10
        for <io-uring@vger.kernel.org>; Fri, 06 Jan 2023 08:00:11 -0800 (PST)
X-Gm-Message-State: AFqh2kpCun3WdlRy5VdDbjBE526Xq94UhyiJuwmr28tRJZFE6xt4HInM
        5m6HyKq+VN91N/wlNSVB++rqSLBU5rmsS+uCHzU=
X-Google-Smtp-Source: AMrXdXvGlt+89P/4w16V62O+v8qXipr40Jc3uY7SEnzMWJrJ0bZrezVik3/B/Pf89vq6KFYzmn8oJsTtc5myq0kIPoE=
X-Received: by 2002:a2e:bd01:0:b0:27f:c69a:11b7 with SMTP id
 n1-20020a2ebd01000000b0027fc69a11b7mr3060574ljq.111.1673020809362; Fri, 06
 Jan 2023 08:00:09 -0800 (PST)
MIME-Version: 1.0
References: <20230106154259.556542-1-ammar.faizi@intel.com> <20230106154259.556542-3-ammar.faizi@intel.com>
In-Reply-To: <20230106154259.556542-3-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Fri, 6 Jan 2023 22:59:58 +0700
X-Gmail-Original-Message-ID: <CAOG64qOJTRQbEEUMPZoPYzMrPAxN=9=jD+E25KuH7o0yVFa1Jw@mail.gmail.com>
Message-ID: <CAOG64qOJTRQbEEUMPZoPYzMrPAxN=9=jD+E25KuH7o0yVFa1Jw@mail.gmail.com>
Subject: Re: [PATCH liburing v1 2/2] register: Simplify `io_uring_register_file_alloc_range()`
 function
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 6, 2023 at 10:43 PM Ammar Faizi wrote:
> Use a struct initializer instead of memset(). It simplifies the C code
> plus effectively reduces the code size.
>
> Extra bonus on x86-64. It reduces the stack allocation because it
> doesn't need to allocate stack for the local variable @range. It can
> just use 128 bytes of redzone below the `%rsp` (redzone is only
> available in a leaf function).
>
> Before this patch:
>
> ```
>   0000000000003910 <io_uring_register_file_alloc_range>:
>     3910:  push   %rbp
>     3911:  push   %r15
>     3913:  push   %r14
>     3915:  push   %rbx
>     3916:  sub    $0x18,%rsp
>     391a:  mov    %edx,%r14d
>     391d:  mov    %esi,%ebp
>     391f:  mov    %rdi,%rbx
>     3922:  lea    0x8(%rsp),%r15
>     3927:  mov    $0x10,%edx
>     392c:  mov    %r15,%rdi
>     392f:  xor    %esi,%esi
>     3931:  call   3a00 <__uring_memset>
>     3936:  mov    %ebp,0x8(%rsp)
>     393a:  mov    %r14d,0xc(%rsp)
>     393f:  mov    0xc4(%rbx),%edi
>     3945:  mov    $0x1ab,%eax
>     394a:  mov    $0x19,%esi
>     394f:  mov    %r15,%rdx
>     3952:  xor    %r10d,%r10d
>     3955:  syscall
>     3957:  add    $0x18,%rsp
>     395b:  pop    %rbx
>     395c:  pop    %r14
>     395e:  pop    %r15
>     3960:  pop    %rbp
>     3961:  ret
>     3962:  cs nopw 0x0(%rax,%rax,1)
>     396c:  nopl   0x0(%rax)
> ```
>
> After this patch:
>
> ```
>   0000000000003910 <io_uring_register_file_alloc_range>:
>     3910:  mov    %esi,-0x10(%rsp) # set range.off
>     3914:  mov    %edx,-0xc(%rsp)  # set range.len
>     3918:  movq   $0x0,-0x8(%rsp)  # zero the resv
>     3921:  mov    0xc4(%rdi),%edi
>     3927:  lea    -0x10(%rsp),%rdx
>     392c:  mov    $0x1ab,%eax
>     3931:  mov    $0x19,%esi
>     3936:  xor    %r10d,%r10d
>     3939:  syscall
>     393b:  ret
> ```
>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

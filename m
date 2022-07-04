Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAF3565D62
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 20:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiGDSMR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 14:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGDSMQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 14:12:16 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A630636A
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 11:12:16 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
        by gnuweeb.org (Postfix) with ESMTPSA id ABA1080271
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656958335;
        bh=QXOb3Cu4gBYLLsUYXtUaMW7jFCn+NloKWknMDdNAhJ4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aG3QS0cJj0+jPr6C/fKq3S0CpqGCn0lhpAYviYqIIKet/vmyBRibTSzFUQh5uhwzp
         j5ugPr535dQiT+azKmk8LtpTp8mLOgFrHT+J41FRpHOaxXHeT/ma48O74WuOQj6Ya/
         Qj+jtCN80ru9+Rx8VmxgpG/8P57oM9KVYHMS/j/fqCQpIOiB1OVD4abdPwIvLW7iGW
         cWGtSrBu4utysZpXAACLMbh3nwOTw+aOg/z4J3VqYWxAdDCljx2SCA9nMVkZbU0kHs
         O1ASi6avcXM+L9+MDHGEVUqg4Mip2n4NAo3R4fdFB2IIjnh3SFquy7RWGACSXLgMH8
         5jRT/nP5J4Z9A==
Received: by mail-lf1-f44.google.com with SMTP id j21so17007355lfe.1
        for <io-uring@vger.kernel.org>; Mon, 04 Jul 2022 11:12:15 -0700 (PDT)
X-Gm-Message-State: AJIora8Pew0OS+xuvNMxta8GCm0UVZAFMVeRCIyne5/9ZBxp7IuI64ny
        ocGnmXjrw7H3nJCDebyUtYRVcxZjs25IjBGUF2w=
X-Google-Smtp-Source: AGRyM1s/WYfR/ZGgzXGNtk0uwGLMNrv/gvGbcp0BQ8M7mebKB1q3a+wEJM91Sc3drdnYHmhycEm3GGhRuYvVQ1nGocA=
X-Received: by 2002:a05:6512:224b:b0:47f:68cf:e697 with SMTP id
 i11-20020a056512224b00b0047f68cfe697mr21234562lfu.233.1656958333741; Mon, 04
 Jul 2022 11:12:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220704174858.329326-1-ammar.faizi@intel.com> <20220704174858.329326-4-ammar.faizi@intel.com>
In-Reply-To: <20220704174858.329326-4-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Tue, 5 Jul 2022 01:12:02 +0700
X-Gmail-Original-Message-ID: <CAOG64qOvMW_UoSvHeMkwWJQST_CA7OAvP5ARJs12JjcQ8bCAPg@mail.gmail.com>
Message-ID: <CAOG64qOvMW_UoSvHeMkwWJQST_CA7OAvP5ARJs12JjcQ8bCAPg@mail.gmail.com>
Subject: Re: [PATCH liburing v3 03/10] arch: syscall: Add `__sys_read()` syscall
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Fernanda Ma'rouf" <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 5, 2022 at 12:54 AM Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>
> A prep patch to support aarch64 nolibc. We will use this to get the
> page size by reading /proc/self/auxv.
>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
[...]
> +static inline int __sys_read(int fd, void *buffer, size_t size)
> +{
> +       return (int) __do_syscall3(__NR_read, fd, buffer, size);
> +}

__sys_read should return ssize_t and the cast should also (ssize_t).

With that fixed:

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

tq

-- Viro

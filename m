Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4FFC74EFD8
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 15:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjGKNGz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 09:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbjGKNC5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 09:02:57 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E3C19B9;
        Tue, 11 Jul 2023 06:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1689080551;
        bh=DJLSw5mNRMltwQN4+u30gLJrbrTFZudgTHqkjAFPmqA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=WPj/dwD8JPgsheFGb+srwBd8VmstObSr9A5jftiE74UaOcXfPXIuWNJAHxk5NWXkW
         XlLaA0jBhDNh5dtQJwniMJFPT7/tq0Z6wG732S0u+SAS75pSjszqKFlf73lAB+HGRC
         traz219qv7tIfjNMCtcNozigbJOgSMP2/9drJx95mOaQPqZ8iK77ngwepJheBRvpaD
         D3DiWlOvVLu9ArKQCRkvm+ygy0iI5o2PdFN1KGzkxEhl7fIhfV0Hwc2Yn1xwHQe+Ia
         PgP97/aI5JB6rG8IqvoTBi2EV3fhuLxWyT6+uMY7j3qVsX+RGo5Qr1rtco2FBLqSAH
         mFF+1xEaR9PCQ==
Received: from biznet-home.integral.gnuweeb.org (unknown [182.253.126.105])
        by gnuweeb.org (Postfix) with ESMTPSA id DA89324A9C7;
        Tue, 11 Jul 2023 20:02:26 +0700 (WIB)
Date:   Tue, 11 Jul 2023 20:02:22 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Fsdevel Mailing List <linux-fsdevel@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 1/3] fs: split off vfs_getdents function of getdents64
 syscall
Message-ID: <ZK1S3s/hOLOq0Ym+@biznet-home.integral.gnuweeb.org>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <20230711114027.59945-2-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711114027.59945-2-hao.xu@linux.dev>
X-Bpl:  hUx9VaHkTWcLO7S8CQCslj6OzqBx2hfLChRz45nPESx5VSB/xuJQVOKOB1zSXE3yc9ntP27bV1M1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023 at 07:40:25PM +0800, Hao Xu wrote:
> This splits off the vfs_getdents function from the getdents64 system
> call.
> This will allow io_uring to call the vfs_getdents function.
> 
> Co-developed-by: Stefan Roesch <shr@fb.com>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> ---

Since you took this, it needs your Signed-off-by.

-- 
Ammar Faizi


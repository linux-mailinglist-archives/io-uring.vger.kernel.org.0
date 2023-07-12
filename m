Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5486750A1F
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 15:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbjGLNzQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 09:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjGLNzP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 09:55:15 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5035FEA;
        Wed, 12 Jul 2023 06:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1689170111;
        bh=HJopHCxgdC/P9Az81VBbwel01VSXYlHpTRZwX3QQzRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=JNIs4QJs1nUkZfcgV5CEHh1Daaw6piuGzTl9+EJxscY8+s/7AkdIFa+ZhSxWcXJGP
         RKSlXZThzH0l4lDMe9zwQxOEMHV+vS6/jHjSKLOVb++fXtM9pHsyk3HdUJ6lLV6wBV
         gsCLe1+JAMJOHLlHBCjT7bI+UEtmgh5MkKhoIOGCJLlkWKm/XuJh3jbQuXSJ0AH3k4
         y/JKbhf5K2gzCGE8kySxFOZT4IZL11JdLhQ4ihONjOdkuWu3150f9PiCv4VaYAQYls
         iASfLD//SL6HqcD9l33iBUZACF9O+1GL/jiRDNEbdgXWxQTN9TmCQxbWUubtwfQKuF
         xqy74p9VXX+pA==
Received: from biznet-home.integral.gnuweeb.org (unknown [182.253.126.105])
        by gnuweeb.org (Postfix) with ESMTPSA id 940DD24AA80;
        Wed, 12 Jul 2023 20:55:06 +0700 (WIB)
Date:   Wed, 12 Jul 2023 20:55:01 +0700
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
Message-ID: <ZK6wtZrwCRKoa3X8@biznet-home.integral.gnuweeb.org>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <20230711114027.59945-2-hao.xu@linux.dev>
 <ZK1S3s/hOLOq0Ym+@biznet-home.integral.gnuweeb.org>
 <d7c071e7-8ee1-a236-77d6-88b1b3937a98@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7c071e7-8ee1-a236-77d6-88b1b3937a98@linux.dev>
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

On Wed, Jul 12, 2023 at 04:03:41PM +0800, Hao Xu wrote:
> On 7/11/23 21:02, Ammar Faizi wrote:
> > On Tue, Jul 11, 2023 at 07:40:25PM +0800, Hao Xu wrote:
> > > Co-developed-by: Stefan Roesch <shr@fb.com>
> > > Signed-off-by: Stefan Roesch <shr@fb.com>
> > > Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> > > ---
> > 
> > Since you took this, it needs your Signed-off-by.
> > 
> 
> Hi Ammar,
> I just add this signed-off-by of Stefan to resolve the checkpatch complain,
> no code change.

Both, you and Stefan are required to sign-off. The submitter is also
required to sign-off even if the submitter makes no code change.

See https://www.kernel.org/doc/html/latest/process/submitting-patches.html:
"""
Any further SoBs (Signed-off-by:'s) following the author's SoB are from
people handling and transporting the patch, but were not involved in its
development. SoB chains should reflect the real route a patch took as it
was propagated to the maintainers and ultimately to Linus, with the
first SoB entry signalling primary authorship of a single author.
"""

It also applies to the maintainer when they apply your patches.

-- 
Ammar Faizi


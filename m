Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4CA53DF9F
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 04:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349084AbiFFCPn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Jun 2022 22:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiFFCPm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Jun 2022 22:15:42 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2332D366A4;
        Sun,  5 Jun 2022 19:15:39 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VFPsTeZ_1654481735;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VFPsTeZ_1654481735)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 06 Jun 2022 10:15:37 +0800
Date:   Mon, 6 Jun 2022 10:15:35 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Pavel Machek <pavel@ucw.cz>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Re: [RFC PATCH] ubd: add io_uring based userspace block driver
Message-ID: <Yp1jRw6kiUf5jCrW@B-P7TQMD6M-0146.local>
Mail-Followup-To: Ming Lei <ming.lei@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <20220509092312.254354-1-ming.lei@redhat.com>
 <20220530070700.GF1363@bug>
 <YpgsTojc4mVKghZA@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YpgsTojc4mVKghZA@T590>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 02, 2022 at 11:19:42AM +0800, Ming Lei wrote:
> Hello Pavel,
> 
> On Mon, May 30, 2022 at 09:07:00AM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > This is the driver part of userspace block driver(ubd driver), the other
> > > part is userspace daemon part(ubdsrv)[1].
> > 
> > > @@ -0,0 +1,1193 @@
> > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > +/*
> > > + * Userspace block device - block device which IO is handled from userspace
> > > + *
> > > + * Take full use of io_uring passthrough command for communicating with
> > > + * ubd userspace daemon(ubdsrvd) for handling basic IO request.
> > 
> > > +
> > > +static inline unsigned int ubd_req_build_flags(struct request *req)
> > > +{
> > ...
> > > +	if (req->cmd_flags & REQ_SWAP)
> > > +		flags |= UBD_IO_F_SWAP;
> > > +
> > > +	return flags;
> > > +}
> > 
> > Does it work? How do you guarantee operation will be deadlock-free with swapping and
> > writebacks going on?
> 
> The above is just for providing command flags to user side, so that the
> user side can understand/handle the request better.
> 
> prtrl(PR_SET_IO_FLUSHER) has been merged for avoiding the deadlock.
>

I've pointed out a case before that (I think) PR_SET_IO_FLUSHER doesn't work:
https://lore.kernel.org/all/YhbYOeMUv5+U1XdQ@B-P7TQMD6M-0146.local

I don't think handling writeback in the userspace under the direct reclaim
context is _safe_ honestly. Because userspace program can call any system
call under direct reclaim, which can interconnect to another process context
and wait for it. yet I don't look into ubd implementation.

Thanks,
Gao Xiang

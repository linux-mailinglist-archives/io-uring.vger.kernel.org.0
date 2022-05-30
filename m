Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1405374E8
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 09:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiE3HHM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 03:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbiE3HHL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 03:07:11 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0DF62E7;
        Mon, 30 May 2022 00:07:02 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7C4DF1C0B8A; Mon, 30 May 2022 09:07:01 +0200 (CEST)
Date:   Mon, 30 May 2022 09:07:00 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Re: [RFC PATCH] ubd: add io_uring based userspace block driver
Message-ID: <20220530070700.GF1363@bug>
References: <20220509092312.254354-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509092312.254354-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi!

> This is the driver part of userspace block driver(ubd driver), the other
> part is userspace daemon part(ubdsrv)[1].

> @@ -0,0 +1,1193 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Userspace block device - block device which IO is handled from userspace
> + *
> + * Take full use of io_uring passthrough command for communicating with
> + * ubd userspace daemon(ubdsrvd) for handling basic IO request.

> +
> +static inline unsigned int ubd_req_build_flags(struct request *req)
> +{
...
> +	if (req->cmd_flags & REQ_SWAP)
> +		flags |= UBD_IO_F_SWAP;
> +
> +	return flags;
> +}

Does it work? How do you guarantee operation will be deadlock-free with swapping and
writebacks going on?

What are restriction on ubdsrv? What happens when it needs to allocate memory, or is
swapped out?

Have mm people seen this?

Best regards,
										Pavel

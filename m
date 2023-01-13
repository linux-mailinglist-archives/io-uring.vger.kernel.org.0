Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C830E6693D3
	for <lists+io-uring@lfdr.de>; Fri, 13 Jan 2023 11:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbjAMKNQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Jan 2023 05:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbjAMKNP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Jan 2023 05:13:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA07A57932
        for <io-uring@vger.kernel.org>; Fri, 13 Jan 2023 02:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673604759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MAPO8Oev0sum4QOl5ZTpjFVe1uFrND2X6U3G+Jf9t8s=;
        b=TkuZQIYVf/iGh+qufXuZkE90OcxAXeX4fZIUrUTqsiHSDc28XrJ2PLdUOjU4t1oITghZEs
        OosdevoGd5tW2NkIKg14dmvgJrWSO+ibYR2ZM3KF6tv0Nc64WhgXYTpmP+/5yDjEyGC/MV
        iyxBFrqOaxZ215F6+0sIx356UoL/iGc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-pdVyZ750PKi2_3-3clpBKQ-1; Fri, 13 Jan 2023 05:12:35 -0500
X-MC-Unique: pdVyZ750PKi2_3-3clpBKQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39EC6101A52E;
        Fri, 13 Jan 2023 10:12:35 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9746551EF;
        Fri, 13 Jan 2023 10:12:27 +0000 (UTC)
Date:   Fri, 13 Jan 2023 18:12:22 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Ahern <dsahern@gmail.com>, ming.lei@redhat.com
Subject: Re: IOSQE_IO_LINK vs. short send of SOCK_STREAM
Message-ID: <Y8EuhoodlKFGh/55@T590>
References: <Y77VIB1s6LurAvBd@T590>
 <b8011ec8-8d43-9b9b-4dcc-53b6cb272354@samba.org>
 <Y79+P4EyU1O0bJPh@T590>
 <24a5eb97-92be-2441-13a2-9ebf098caf55@kernel.dk>
 <9eca9d42-e8ab-3e2b-888a-cd41722cce7a@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9eca9d42-e8ab-3e2b-888a-cd41722cce7a@samba.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

On Thu, Jan 12, 2023 at 08:35:36AM +0100, Stefan Metzmacher wrote:
> Am 12.01.23 um 04:40 schrieb Jens Axboe:
> > On 1/11/23 8:27?PM, Ming Lei wrote:
> > > Hi Stefan and Jens,
> > > 
> > > Thanks for the help.
> > > 
> > > BTW, the issue is observed when I write ublk-nbd:
> > > 
> > > https://github.com/ming1/ubdsrv/commits/nbd
> > > 
> > > and it isn't completed yet(multiple send sqe chains not serialized
> > > yet), the issue is triggered when writing big chunk data to ublk-nbd.
> > 
> > Gotcha
> > 
> > > On Wed, Jan 11, 2023 at 05:32:00PM +0100, Stefan Metzmacher wrote:
> > > > Hi Ming,
> > > > 
> > > > > Per my understanding, a short send on SOCK_STREAM should terminate the
> > > > > remainder of the SQE chain built by IOSQE_IO_LINK.
> > > > > 
> > > > > But from my observation, this point isn't true when using io_sendmsg or
> > > > > io_sendmsg_zc on TCP socket, and the other remainder of the chain still
> > > > > can be completed after one short send is found. MSG_WAITALL is off.
> > > > 
> > > > This is due to legacy reasons, you need pass MSG_WAITALL explicitly
> > > > in order to a retry or an error on a short write...
> > > > It should work for send, sendmsg, sendmsg_zc, recv and recvmsg.
> > > 
> > > Turns out there is another application bug in which recv sqe may cut in the
> > > send sqe chain.
> > > 
> > > After the issue is fixed, if MSG_WAITALL is set, short send can't be
> > > observed any more. But if MSG_WAITALL isn't set, short send can be
> > > observed and the send io chain still won't be terminated.
> > 
> > Right, if MSG_WAITALL is set, then the whole thing will be written. If
> > we get a short send, it's retried appropriately. Unless an error occurs,
> > it should send the whole thing.
> >
> > > So if MSG_WAITALL is set, will io_uring be responsible for retry in case
> > > of short send, and application needn't to take care of it?
> 
> With new kernels yes, but the application should be prepared to have retry
> logic in order to be compatible with older kernels.

Now ublk-nbd can be played, mkfs/mount and fio starts to work.

But short send still can be observed sometimes when sending nbd write
request, which is done by sendmsg(), and the message includes two vectors,
(the 1st is the nbd_request, another one is the data to be written to disk).

Short send is reported by cqe in which cqe->res is always 28, which is
size of 'struct nbd_request', also the length of the 1st io vec. And not
see send cqe failure message.

And MSG_WAITALL is set for all ublk-nbd io actually.

Follows the steps:

1) install liburing 2.0+

2) build ublk & reproduce the issue:

- git clone https://github.com/ming1/ubdsrv.git -b nbd

- cd ubdsrv

- vim build_with_liburing_src && set LIBURING_DIR to your liburing dir

- ./build_with_liburing_src&& make -j4

3) run the nbd test
- cd ubdsrv
- make test T=nbd

Sometimes the test hangs, and the following log can be observed
in syslog:

nbd_send_req_done: short send/receive tag 2 op 1 8000000000800002, len 524316 written 28 cqe flags 0
...

Thanks,
Ming


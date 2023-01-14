Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6387966A867
	for <lists+io-uring@lfdr.de>; Sat, 14 Jan 2023 02:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjANBkM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Jan 2023 20:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjANBkK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Jan 2023 20:40:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F054B1101
        for <io-uring@vger.kernel.org>; Fri, 13 Jan 2023 17:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673660365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OVk6yr0/whsSh2GoSvUcbh+RJxv3TjGaI2mDAGxfAWo=;
        b=X7R1kmg3tnX+sT6W6YMWGwgRhiWqh2nvMLpHZrl+y2hPKRxzNRa07JSPLKyUN+rVR8sZDs
        xd4os6X8yP9AlS0gT/pphFGht9xaYGd3YyYVhnEnEuL9xJN+xEIFJTqhHQbL3pYFhUGac1
        BhuUThZoK+bZlKixrjVtvkW0czd7+IQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-Se8Xw31kOlKc9m6CpPAKBw-1; Fri, 13 Jan 2023 20:39:20 -0500
X-MC-Unique: Se8Xw31kOlKc9m6CpPAKBw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A56B829AA38F;
        Sat, 14 Jan 2023 01:39:19 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BC92C2166B26;
        Sat, 14 Jan 2023 01:39:15 +0000 (UTC)
Date:   Sat, 14 Jan 2023 09:39:10 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: IOSQE_IO_LINK vs. short send of SOCK_STREAM
Message-ID: <Y8IHvou+JKDJGdyE@T590>
References: <Y77VIB1s6LurAvBd@T590>
 <b8011ec8-8d43-9b9b-4dcc-53b6cb272354@samba.org>
 <Y79+P4EyU1O0bJPh@T590>
 <24a5eb97-92be-2441-13a2-9ebf098caf55@kernel.dk>
 <9eca9d42-e8ab-3e2b-888a-cd41722cce7a@samba.org>
 <Y8EuhoodlKFGh/55@T590>
 <e222ff73-9f0d-649b-a0a4-211d7cbb5514@kernel.dk>
 <6e237718-e09b-03ca-bd23-de94cdefa7fc@kernel.dk>
 <Y8H2+RaejnVtiMQY@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y8H2+RaejnVtiMQY@T590>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 14, 2023 at 08:27:37AM +0800, Ming Lei wrote:
> On Fri, Jan 13, 2023 at 11:01:51AM -0700, Jens Axboe wrote:
> > On 1/13/23 10:51 AM, Jens Axboe wrote:
> > > On 1/13/23 3:12 AM, Ming Lei wrote:
> > >> Hello,
> > >>
> > >> On Thu, Jan 12, 2023 at 08:35:36AM +0100, Stefan Metzmacher wrote:
> > >>> Am 12.01.23 um 04:40 schrieb Jens Axboe:
> > >>>> On 1/11/23 8:27?PM, Ming Lei wrote:
> > >>>>> Hi Stefan and Jens,
> > >>>>>
> > >>>>> Thanks for the help.
> > >>>>>
> > >>>>> BTW, the issue is observed when I write ublk-nbd:
> > >>>>>
> > >>>>> https://github.com/ming1/ubdsrv/commits/nbd
> > >>>>>
> > >>>>> and it isn't completed yet(multiple send sqe chains not serialized
> > >>>>> yet), the issue is triggered when writing big chunk data to ublk-nbd.
> > >>>>
> > >>>> Gotcha
> > >>>>
> > >>>>> On Wed, Jan 11, 2023 at 05:32:00PM +0100, Stefan Metzmacher wrote:
> > >>>>>> Hi Ming,
> > >>>>>>
> > >>>>>>> Per my understanding, a short send on SOCK_STREAM should terminate the
> > >>>>>>> remainder of the SQE chain built by IOSQE_IO_LINK.
> > >>>>>>>
> > >>>>>>> But from my observation, this point isn't true when using io_sendmsg or
> > >>>>>>> io_sendmsg_zc on TCP socket, and the other remainder of the chain still
> > >>>>>>> can be completed after one short send is found. MSG_WAITALL is off.
> > >>>>>>
> > >>>>>> This is due to legacy reasons, you need pass MSG_WAITALL explicitly
> > >>>>>> in order to a retry or an error on a short write...
> > >>>>>> It should work for send, sendmsg, sendmsg_zc, recv and recvmsg.
> > >>>>>
> > >>>>> Turns out there is another application bug in which recv sqe may cut in the
> > >>>>> send sqe chain.
> > >>>>>
> > >>>>> After the issue is fixed, if MSG_WAITALL is set, short send can't be
> > >>>>> observed any more. But if MSG_WAITALL isn't set, short send can be
> > >>>>> observed and the send io chain still won't be terminated.
> > >>>>
> > >>>> Right, if MSG_WAITALL is set, then the whole thing will be written. If
> > >>>> we get a short send, it's retried appropriately. Unless an error occurs,
> > >>>> it should send the whole thing.
> > >>>>
> > >>>>> So if MSG_WAITALL is set, will io_uring be responsible for retry in case
> > >>>>> of short send, and application needn't to take care of it?
> > >>>
> > >>> With new kernels yes, but the application should be prepared to have retry
> > >>> logic in order to be compatible with older kernels.
> > >>
> > >> Now ublk-nbd can be played, mkfs/mount and fio starts to work.
> > >>
> > >> But short send still can be observed sometimes when sending nbd write
> > >> request, which is done by sendmsg(), and the message includes two vectors,
> > >> (the 1st is the nbd_request, another one is the data to be written to disk).
> > >>
> > >> Short send is reported by cqe in which cqe->res is always 28, which is
> > >> size of 'struct nbd_request', also the length of the 1st io vec. And not
> > >> see send cqe failure message.
> > >>
> > >> And MSG_WAITALL is set for all ublk-nbd io actually.
> > >>
> > >> Follows the steps:
> > >>
> > >> 1) install liburing 2.0+
> > >>
> > >> 2) build ublk & reproduce the issue:
> > >>
> > >> - git clone https://github.com/ming1/ubdsrv.git -b nbd
> > >>
> > >> - cd ubdsrv
> > >>
> > >> - vim build_with_liburing_src && set LIBURING_DIR to your liburing dir
> > >>
> > >> - ./build_with_liburing_src&& make -j4
> > >>
> > >> 3) run the nbd test
> > >> - cd ubdsrv
> > >> - make test T=nbd
> > >>
> > >> Sometimes the test hangs, and the following log can be observed
> > >> in syslog:
> > >>
> > >> nbd_send_req_done: short send/receive tag 2 op 1 8000000000800002, len 524316 written 28 cqe flags 0
> > >> ...
> > >>
> > > 
> > > I can reproduce this, but it's a SEND that ends up being triggered,
> > > not a SENDMSG. Should the payload carrying op not be a SENDMSG? I'm
> > > assuming two vecs for that one.
> > 
> > Added some debug and it looks like the request was indeed send up
> > and is using IORING_OP_SEND and that the 28 is what was requested.
> > But the completion side seems to think it's a SENDMSG and we should've
> > received more?
> > 
> > I think this needs a bit of debugging on the userspace side first.
> 
> Yeah, turns out it is indeed one userspace bug, IOSQE_IO_LINK is cleared
> wrong, and now the issue can't be triggered with the following fix:
> 
> https://github.com/ming1/ubdsrv/commit/175ffd14ae2f8fa562134edfd4ac949f8050c108

Turns out the two are different issues, it is understandable that the
above commit fixes io hang.

But just checked syslog, the short send warning is still logged, will
investigate further.


thanks,
Ming


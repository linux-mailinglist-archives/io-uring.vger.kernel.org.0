Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEC67BFEF9
	for <lists+io-uring@lfdr.de>; Tue, 10 Oct 2023 16:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbjJJOTl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Oct 2023 10:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbjJJOTk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Oct 2023 10:19:40 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5272E9E
        for <io-uring@vger.kernel.org>; Tue, 10 Oct 2023 07:19:38 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1qqDa8-0005FO-NP; Tue, 10 Oct 2023 16:19:32 +0200
Received: from [2a0a:edc0:2:b01:1d::c0] (helo=ptx.whiteo.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1qqDa8-000gWG-7a; Tue, 10 Oct 2023 16:19:32 +0200
Received: from sha by ptx.whiteo.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1qqDa8-00Dktd-3i; Tue, 10 Oct 2023 16:19:32 +0200
Date:   Tue, 10 Oct 2023 16:19:32 +0200
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Problem with io_uring splice and KTLS
Message-ID: <20231010141932.GD3114228@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
From:   Sascha Hauer <sha@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: io-uring@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I am working with a webserver using io_uring in conjunction with KTLS. The
webserver basically splices static file data from a pipe to a socket which uses
KTLS for encryption. When splice is done the socket is closed. This works fine
when using software encryption in KTLS. Things go awry though when the software
encryption is replaced with the CAAM driver which replaces the synchronous
encryption with a asynchronous queue/interrupt/completion flow.

So far I have traced it down to tls_push_sg() calling tcp_sendmsg_locked() to
send the completed encrypted messages. tcp_sendmsg_locked() sometimes waits for
more memory on the socket by calling sk_stream_wait_memory(). This in turn
returns -ERESTARTSYS due to:

        if (signal_pending(current))
                goto do_interrupted;

The current task has the TIF_NOTIFY_SIGNAL set due to:

io_req_normal_work_add()
{
        ...
        /* This interrupts sk_stream_wait_memory() (notify_method == TWA_SIGNAL) */
        task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
}

The call stack when sk_stream_wait_memory() fails is as follows:

[ 1385.428816]  dump_backtrace+0xa0/0x128
[ 1385.432568]  show_stack+0x20/0x38
[ 1385.435878]  dump_stack_lvl+0x48/0x60
[ 1385.439539]  dump_stack+0x18/0x28
[ 1385.442850]  tls_push_sg+0x100/0x238
[ 1385.446424]  tls_tx_records+0x118/0x1d8
[ 1385.450257]  tls_sw_release_resources_tx+0x74/0x1a0
[ 1385.455135]  tls_sk_proto_close+0x2f8/0x3f0
[ 1385.459315]  inet_release+0x58/0xb8
[ 1385.462802]  inet6_release+0x3c/0x60
[ 1385.466374]  __sock_release+0x48/0xc8
[ 1385.470035]  sock_close+0x20/0x38
[ 1385.473347]  __fput+0xbc/0x280
[ 1385.476399]  ____fput+0x18/0x30
[ 1385.479537]  task_work_run+0x80/0xe0
[ 1385.483108]  io_run_task_work+0x40/0x108
[ 1385.487029]  __arm64_sys_io_uring_enter+0x164/0xad8
[ 1385.491907]  invoke_syscall+0x50/0x128
[ 1385.495655]  el0_svc_common.constprop.0+0x48/0xf0
[ 1385.500359]  do_el0_svc_compat+0x24/0x40
[ 1385.504279]  el0_svc_compat+0x38/0x108
[ 1385.508026]  el0t_32_sync_handler+0x98/0x140
[ 1385.512294]  el0t_32_sync+0x194/0x198

So the socket is being closed and KTLS tries to send out the remaining
completed messages.  From a splice point of view everything has been sent
successfully, but not everything made it through KTLS to the socket and the
remaining data is sent while closing the socket.

I vaguely understand what's going on here, but I haven't got the slightest idea
what to do about this. Any ideas?

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

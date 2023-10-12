Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8347C6F4D
	for <lists+io-uring@lfdr.de>; Thu, 12 Oct 2023 15:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343875AbjJLNeR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Oct 2023 09:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343724AbjJLNeR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Oct 2023 09:34:17 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C3C91
        for <io-uring@vger.kernel.org>; Thu, 12 Oct 2023 06:34:12 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1qqvpI-0005HV-3X; Thu, 12 Oct 2023 15:34:08 +0200
Received: from [2a0a:edc0:2:b01:1d::c0] (helo=ptx.whiteo.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1qqvpH-001AAm-6a; Thu, 12 Oct 2023 15:34:07 +0200
Received: from sha by ptx.whiteo.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1qqvpH-00E72q-3z; Thu, 12 Oct 2023 15:34:07 +0200
Date:   Thu, 12 Oct 2023 15:34:07 +0200
From:   Sascha Hauer <sha@pengutronix.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: Problem with io_uring splice and KTLS
Message-ID: <20231012133407.GA3359458@pengutronix.de>
References: <20231010141932.GD3114228@pengutronix.de>
 <d729781a-3d12-423b-973e-c16fdbcbb60b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d729781a-3d12-423b-973e-c16fdbcbb60b@kernel.dk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: io-uring@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Oct 10, 2023 at 08:28:13AM -0600, Jens Axboe wrote:
> On 10/10/23 8:19 AM, Sascha Hauer wrote:
> > Hi,
> > 
> > I am working with a webserver using io_uring in conjunction with KTLS. The
> > webserver basically splices static file data from a pipe to a socket which uses
> > KTLS for encryption. When splice is done the socket is closed. This works fine
> > when using software encryption in KTLS. Things go awry though when the software
> > encryption is replaced with the CAAM driver which replaces the synchronous
> > encryption with a asynchronous queue/interrupt/completion flow.
> > 
> > So far I have traced it down to tls_push_sg() calling tcp_sendmsg_locked() to
> > send the completed encrypted messages. tcp_sendmsg_locked() sometimes waits for
> > more memory on the socket by calling sk_stream_wait_memory(). This in turn
> > returns -ERESTARTSYS due to:
> > 
> >         if (signal_pending(current))
> >                 goto do_interrupted;
> > 
> > The current task has the TIF_NOTIFY_SIGNAL set due to:
> > 
> > io_req_normal_work_add()
> > {
> >         ...
> >         /* This interrupts sk_stream_wait_memory() (notify_method == TWA_SIGNAL) */
> >         task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
> > }
> > 
> > The call stack when sk_stream_wait_memory() fails is as follows:
> > 
> > [ 1385.428816]  dump_backtrace+0xa0/0x128
> > [ 1385.432568]  show_stack+0x20/0x38
> > [ 1385.435878]  dump_stack_lvl+0x48/0x60
> > [ 1385.439539]  dump_stack+0x18/0x28
> > [ 1385.442850]  tls_push_sg+0x100/0x238
> > [ 1385.446424]  tls_tx_records+0x118/0x1d8
> > [ 1385.450257]  tls_sw_release_resources_tx+0x74/0x1a0
> > [ 1385.455135]  tls_sk_proto_close+0x2f8/0x3f0
> > [ 1385.459315]  inet_release+0x58/0xb8
> > [ 1385.462802]  inet6_release+0x3c/0x60
> > [ 1385.466374]  __sock_release+0x48/0xc8
> > [ 1385.470035]  sock_close+0x20/0x38
> > [ 1385.473347]  __fput+0xbc/0x280
> > [ 1385.476399]  ____fput+0x18/0x30
> > [ 1385.479537]  task_work_run+0x80/0xe0
> > [ 1385.483108]  io_run_task_work+0x40/0x108
> > [ 1385.487029]  __arm64_sys_io_uring_enter+0x164/0xad8
> > [ 1385.491907]  invoke_syscall+0x50/0x128
> > [ 1385.495655]  el0_svc_common.constprop.0+0x48/0xf0
> > [ 1385.500359]  do_el0_svc_compat+0x24/0x40
> > [ 1385.504279]  el0_svc_compat+0x38/0x108
> > [ 1385.508026]  el0t_32_sync_handler+0x98/0x140
> > [ 1385.512294]  el0t_32_sync+0x194/0x198
> > 
> > So the socket is being closed and KTLS tries to send out the remaining
> > completed messages.  From a splice point of view everything has been sent
> > successfully, but not everything made it through KTLS to the socket and the
> > remaining data is sent while closing the socket.
> > 
> > I vaguely understand what's going on here, but I haven't got the
> > slightest idea what to do about this. Any ideas?
> 
> Two things to try:
> 
> 1) Depending on how you use the ring, set it up with
> IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN. The latter will
> avoid using signal based task_work notifications, which may be messing
> you up here.
> 
> 2) io_uring will hold a reference to the file/socket. I'm unsure if this
> is a problem in the above case, but sometimes it'll prevent the final
> flush.
> 
> Do you have a reproducer that could be run to test? Sometimes easier to
> see what's going on when you can experiment, it'll save some time.

Okay, here is a reproducer:

https://github.com/saschahauer/webserver-uring-test.git

Execute ./prepare.sh in that repository, it will compile the webserver,
generate cert.pem/key.pem and generate some testfile to download. If the
meson build doesn't work for you then you can compile the program by
hand with something like:

gcc -O3 -Wall -o webserver webserver_liburing.c -lcrypto -lssl -luring

When the webserver is started you can get a file from it with:

curl -k https://<ipaddr>:8443/foo -o foo

or:

while true; do curl -k https://<ipaddr>:8443/foo -o foo; if [ $? != 0 ]; then break; fi; done

This should run without problems as by default likely the encryption
requests are running synchronously.

In case you don't have encryption hardware you can create an
asynchronous encryption module using cryptd. Compile a kernel with
CONFIG_CRYPTO_USER_API_AEAD and CONFIG_CRYPTO_CRYPTD and start the
webserver with the '-c' option. /proc/crypto should then contain an
entry with:

 name         : gcm(aes)
 driver       : cryptd(gcm_base(ctr(aes-generic),ghash-generic))
 module       : kernel
 priority     : 150

Make sure there is no other module providing gcm(aes) with a priority higher
than 150 so that this one is actually used.

With that the while true loop above should break out with a short read
fairly fast. Passing IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN
to io_uring_queue_init() makes it harder to reproduce for me. With that
I need multiple shells in parallel running the above loop.

The repository also contains a kernel patch which will provide you a
stack dump when KTLS gets an error from tcp_sendmsg_locked().

Now I hope I haven't done anything silly in the webserver ;)

Sascha


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

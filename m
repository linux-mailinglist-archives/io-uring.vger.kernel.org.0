Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132F73B593A
	for <lists+io-uring@lfdr.de>; Mon, 28 Jun 2021 08:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhF1Gp0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Jun 2021 02:45:26 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:44328 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhF1Gp0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Jun 2021 02:45:26 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:33996 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lxkyy-0002pP-Bf; Mon, 28 Jun 2021 02:43:00 -0400
Message-ID: <f51af209b1a7fc17d8416f32f18368e1835ac2e6.camel@trillion01.com>
Subject: Re: [PATCH v4] io_uring: reduce latency by reissueing the operation
From:   Olivier Langlois <olivier@trillion01.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Jens Axboe' <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Mon, 28 Jun 2021 02:42:59 -0400
In-Reply-To: <c85e28df251d4c66a511dc157b795b13@AcuMS.aculab.com>
References: <9e8441419bb1b8f3c3fcc607b2713efecdef2136.1624364038.git.olivier@trillion01.com>
         <16c91f57-9b6f-8837-94af-f096d697f5fb@kernel.dk>
         <c85e28df251d4c66a511dc157b795b13@AcuMS.aculab.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 2021-06-25 at 08:15 +0000, David Laight wrote:
> From: Jens Axboe
> > Sent: 25 June 2021 01:45
> > 
> > On 6/22/21 6:17 AM, Olivier Langlois wrote:
> > > It is quite frequent that when an operation fails and returns
> > > EAGAIN,
> > > the data becomes available between that failure and the call to
> > > vfs_poll() done by io_arm_poll_handler().
> > > 
> > > Detecting the situation and reissuing the operation is much
> > > faster
> > > than going ahead and push the operation to the io-wq.
> > > 
> > > Performance improvement testing has been performed with:
> > > Single thread, 1 TCP connection receiving a 5 Mbps stream, no
> > > sqpoll.
> > > 
> > > 4 measurements have been taken:
> > > 1. The time it takes to process a read request when data is
> > > already available
> > > 2. The time it takes to process by calling twice io_issue_sqe()
> > > after vfs_poll() indicated that data
> > was available
> > > 3. The time it takes to execute io_queue_async_work()
> > > 4. The time it takes to complete a read request asynchronously
> > > 
> > > 2.25% of all the read operations did use the new path.
> 
> How much slower is it when the data to complete the read isn't
> available?
> 
> I suspect there are different workflows where that is almost
> always true.
> 
David,

in the case that the data to complete isn't available, the request will
be processed exactly as it was before the patch.

Ideally through io_uring fast polling feature. If not possible because
arming the poll has been aborted, the request will be punted to the io-
wq.

Greetings,



Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5256B375103
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 10:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbhEFInK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 04:43:10 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:38382 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbhEFInK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 May 2021 04:43:10 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:40686 helo=[192.168.1.177])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1leZaE-0001XM-T1; Thu, 06 May 2021 04:42:10 -0400
Message-ID: <7fa90154d1fbe1969383261539b7fbee20caad43.camel@trillion01.com>
Subject: Re: IORING_OP_POLL_ADD/IORING_OP_POLL_REMOVE questions
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Date:   Thu, 06 May 2021 04:42:10 -0400
In-Reply-To: <0a12170604cfcbce61259661f579fe5640cc7ffb.camel@trillion01.com>
References: <8992f5f989808798ad2666b0a3ef8ae8d777b7de.camel@trillion01.com>
         <db4d01cc-9f58-c04d-d1b6-1208f8fb7220@gmail.com>
         <0a12170604cfcbce61259661f579fe5640cc7ffb.camel@trillion01.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

On Wed, 2021-05-05 at 23:17 -0400, Olivier Langlois wrote:
> Note that the poll remove sqe and the following poll add sqe don't have
> exactly the same user_data.
> 
> I have this statement in between:
> /* increment generation counter to avoid handling old events */
>           ++anfds [fd].egen;
> 
> poll remove cancel the previous poll add having gen 1 in its user data.
> the next poll add has it user_data storing gen var set to 2:
> 
> 1 3 remove 85 1
> 1 3 add 85 2
> 
> 85 gen 1 res -125
> 85 gen 1 res 4
> 
Good news!

I have used the io_uring tracepoints and they confirm that io_uring
works as expected:

For the above printfs, I get the following perf traces:

 11940.259 Execution SVC/134675 io_uring:io_uring_submit_sqe(ctx:
0xffff9d3c4368c000, opcode: 7, force_nonblock: 1)
 11940.270 Execution SVC/134675 io_uring:io_uring_complete(ctx:
0xffff9d3c4368c000, user_data: 4294967382, res: -125)
 11940.272 Execution SVC/134675 io_uring:io_uring_complete(ctx:
0xffff9d3c4368c000)
 11940.275 Execution SVC/134675 io_uring:io_uring_file_get(ctx:
0xffff9d3c4368c000, fd: 86)
 11940.277 Execution SVC/134675 io_uring:io_uring_submit_sqe(ctx:
0xffff9d3c4368c000, opcode: 6, user_data: 4294967382, force_nonblock:
1)
 11940.279 Execution SVC/134675 io_uring:io_uring_complete(ctx:
0xffff9d3c4368c000, user_data: 4294967382, res: 4)

So, it seems the compiler is playing games on me. It prints the correct
gen 2 value but is passing 1 to io_uring_sqe_set_data()...

I'll try to turn optimization off to see if it helps.

thx a lot again for your exceptional work!



Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D684E46A6D7
	for <lists+io-uring@lfdr.de>; Mon,  6 Dec 2021 21:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349507AbhLFU1p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Dec 2021 15:27:45 -0500
Received: from cloud48395.mywhc.ca ([173.209.37.211]:40056 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349484AbhLFU1o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Dec 2021 15:27:44 -0500
X-Greylist: delayed 2103 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Dec 2021 15:27:44 EST
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:37826 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@olivierlanglois.net>)
        id 1muJz5-0000EI-V1; Mon, 06 Dec 2021 14:49:11 -0500
Message-ID: <5a7ddacb6729a401f99bc7da17b3131ad5217c4a.camel@olivierlanglois.net>
Subject: Re: [PATCH v2 0/4] allow to skip CQE posting
From:   Olivier Langlois <olivier@olivierlanglois.net>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Date:   Mon, 06 Dec 2021 14:49:11 -0500
In-Reply-To: <163777789036.479228.12615656445425738291.b4-ty@kernel.dk>
References: <cover.1636559119.git.asml.silence@gmail.com>
         <163777789036.479228.12615656445425738291.b4-ty@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.42.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - olivierlanglois.net
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@olivierlanglois.net
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@olivierlanglois.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 2021-11-24 at 11:18 -0700, Jens Axboe wrote:
> On Wed, 10 Nov 2021 15:49:30 +0000, Pavel Begunkov wrote:
> > It's expensive enough to post an CQE, and there are other
> > reasons to want to ignore them, e.g. for link handling and
> > it may just be more convenient for the userspace.
> > 
> > Try to cover most of the use cases with one flag. The overhead
> > is one "if (cqe->flags & IOSQE_CQE_SKIP_SUCCESS)" check per
> > requests and a bit bloated req_set_fail(), should be bearable.
> > 
> > [...]
> 
> Applied, thanks!
> 
> [1/4] io_uring: clean cqe filling functions
>       commit: 913a571affedd17239c4d4ea90c8874b32fc2191
> [2/4] io_uring: add option to skip CQE posting
>       commit: 04c76b41ca974b508522831441dd7e5b1b59cbb0
> [3/4] io_uring: don't spinlock when not posting CQEs
>       commit: 3d4aeb9f98058c3bdfef5286e240cf18c50fee89
> [4/4] io_uring: disable drain with cqe skip
>       commit: 5562a8d71aa32ea27133d8b10406b3dcd57c01a5
> 
> Best regards,

Awesome!

that set of patches was on my radar and I am very interested in it.

If 5.15 or the soon to be released 5.16 is patchable with it, I'll give
it a try in my app and I will report back the benefits it got from
it...

Greetings,


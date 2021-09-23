Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D17E416085
	for <lists+io-uring@lfdr.de>; Thu, 23 Sep 2021 16:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241604AbhIWOH3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Sep 2021 10:07:29 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:50538 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241554AbhIWOH1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Sep 2021 10:07:27 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:53332 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1mTPMG-0000Sp-Gb; Thu, 23 Sep 2021 10:05:52 -0400
Message-ID: <a9f88c7d9b7ac119431a343bda10da251ef7f57e.camel@trillion01.com>
Subject: Re: [5.15-rc1 regression] io_uring: fsstress hangs in do_coredump()
 on exit
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>, Dave Chinner <david@fromorbit.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date:   Thu, 23 Sep 2021 10:05:51 -0400
In-Reply-To: <6d46951b-a7b3-0feb-3af0-aaa8ec87b87a@kernel.dk>
References: <20210921064032.GW2361455@dread.disaster.area>
         <d9d2255c-fbac-3259-243a-2934b7ed0293@kernel.dk>
         <c97707cf-c543-52cd-5066-76b639f4f087@kernel.dk>
         <20210921213552.GZ2361455@dread.disaster.area>
         <6d46951b-a7b3-0feb-3af0-aaa8ec87b87a@kernel.dk>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4 
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

On Tue, 2021-09-21 at 15:41 -0600, Jens Axboe wrote:
> > 
> > Cleaned up so it compiles and the tests run properly again. But
> > playing whack-a-mole with signals seems kinda fragile. I was
> > pointed
> > to this patchset by another dev on #xfs overnight who saw the same
> > hangs that also fixed the hang:
> 
> It seems sane to me - exit if there's a fatal signal, or doing core
> dump. Don't think there should be other conditions.
> 
> > https://lore.kernel.org/lkml/cover.1629655338.git.olivier@trillion0
> > 1.com/
> > 
> > It was posted about a month ago and I don't see any response to it
> > on the lists...
> 
> That's been a long discussion, but it's a different topic really. Yes
> it's signals, but it's not this particular issue. It'll happen to
> work
> around this issue, as it cancels everything post core dumping.
> 
I am glad to see that my patch is still on your radar.

I was starting to wonder if it did somehow slip in a floor crack or if
I did omit to do something justifying that noone is reviewing it.

I guess that everyone has been crazy busy like mad men in the last few
weeks...



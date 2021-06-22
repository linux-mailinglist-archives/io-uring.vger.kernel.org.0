Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2BA3B0D75
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 21:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhFVTKQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 15:10:16 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:59542 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbhFVTKN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 15:10:13 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:33444 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lvlka-0003JN-8N; Tue, 22 Jun 2021 15:07:56 -0400
Message-ID: <cb33d013afae9cd3e2c245230cdbc39ba4679b13.camel@trillion01.com>
Subject: Re: [PATCH 1/2] io_uring: Fix race condition when sqp thread goes
 to sleep
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 22 Jun 2021 15:07:55 -0400
In-Reply-To: <d9d9527c-6d2e-b840-15dd-057618de7864@gmail.com>
References: <cover.1624387080.git.olivier@trillion01.com>
         <67c806d0bcf2e096c1b0c7e87bd5926c37231b87.1624387080.git.olivier@trillion01.com>
         <b056b26aec5abad8e4e06aae84bd9a5bfe5f43da.camel@trillion01.com>
         <d9d9527c-6d2e-b840-15dd-057618de7864@gmail.com>
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

On Tue, 2021-06-22 at 19:55 +0100, Pavel Begunkov wrote:
> On 6/22/21 7:53 PM, Olivier Langlois wrote:
> > On Tue, 2021-06-22 at 11:45 -0700, Olivier Langlois wrote:
> > > If an asynchronous completion happens before the task is
> > > preparing
> > > itself to wait and set its state to TASK_INTERRUPTABLE, the
> > > completion
> > > will not wake up the sqp thread.
> > > 
> > I have just noticed that I made a typo in the description. I will
> > send
> > a v2 of that patch.
> > 
> > Sorry about that. I was too excited to share my discovery...
> 
> git format-patch --cover-letter --thread=shallow ...
> 
> would be even better, but the fix looks right
> 
You are too good... I thought that I could get away from hacking
manually the patch file for such a minor change...

It seems that I got caught...

Let me know if you need me to redo it the right way...



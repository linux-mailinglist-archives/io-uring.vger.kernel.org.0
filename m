Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC283AD466
	for <lists+io-uring@lfdr.de>; Fri, 18 Jun 2021 23:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhFRV2Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 17:28:25 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:36514 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhFRV2Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 17:28:24 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:33080 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1luM0E-0002qd-4h; Fri, 18 Jun 2021 17:26:14 -0400
Message-ID: <f6aafad1fcc1f14ffb8a5753879b727b279896f9.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: store back buffer in case of failure
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 18 Jun 2021 17:26:13 -0400
In-Reply-To: <5007a641-23cf-195d-87ee-de193e19dc20@gmail.com>
References: <60c83c12.1c69fb81.e3bea.0806SMTPIN_ADDED_MISSING@mx.google.com>
         <93256513-08d8-5b15-aa98-c1e83af60b54@gmail.com>
         <b5b37477-985e-54da-fc34-4de389112365@kernel.dk>
         <4f32f06306eac4dd7780ed28c06815e3d15b43ad.camel@trillion01.com>
         <af2f7aa0-271f-ba70-8c6b-f6c6118e6f1f@gmail.com>
         <6bf916b4-ba6f-c401-9e8b-341f9a7b88f7@kernel.dk>
         <5007a641-23cf-195d-87ee-de193e19dc20@gmail.com>
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

On Wed, 2021-06-16 at 16:37 +0100, Pavel Begunkov wrote:
> On 6/16/21 3:44 PM, Jens Axboe wrote:
> > On 6/16/21 8:01 AM, Pavel Begunkov wrote:
> > > On 6/16/21 2:42 PM, Olivier Langlois wrote:
> > > > On Tue, 2021-06-15 at 15:51 -0600, Jens Axboe wrote:
> > > > > Ditto for this one, don't see it in my email nor on the list.
> > > > > 
> > > > I can resend you a private copy of this one but as Pavel
> > > > pointed out,
> > > > it contains fatal flaws.
> > > > 
> > > > So unless someone can tell me that the idea is interesting and
> > > > has
> > > > potential and can give me some a hint or 2 about how to address
> > > > the
> > > > challenges to fix the current flaws, it is pretty much a show
> > > > stopper
> > > > to me and I think that I am going to let it go...
> > > 
> > > It'd need to go through some other context, e.g. task context.
> > > task_work_add() + custom handler would work, either buf-select
> > > synchronisation can be reworked, but both would rather be
> > > bulky and not great.
> > 
> > Indeed - that'd solve both the passing around of locking state
> > which
> > I really don't like, and make it much simpler. Just use task work
> > for
> > the re-insert, and you can grab the ring lock unconditionally from
> > there.
> 
> Hmm, it might be much simpler than I thought if we allocate
> a separate struct callback_head, i.e. task_work, queued it
> with exactly task_work_add() but not io_req_task_work_add(),
> and continue with the request handler. 
> 
ok thx a lot for the excellent suggestions! I think that you have
provided me everything that I need to give a shot for a second version
of this patch.



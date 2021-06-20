Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C021F3AE075
	for <lists+io-uring@lfdr.de>; Sun, 20 Jun 2021 22:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhFTU46 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Jun 2021 16:56:58 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:59186 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhFTU46 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Jun 2021 16:56:58 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:33262 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lv4So-0000CS-DS; Sun, 20 Jun 2021 16:54:42 -0400
Message-ID: <3c6e168b40ebf4e8fd2aa9c9cf1785cdd8b5e6c1.camel@trillion01.com>
Subject: Re: [PATCH v2] io_uring: reduce latency by reissueing the operation
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 20 Jun 2021 16:54:38 -0400
In-Reply-To: <7ad30cb0-3322-6c40-2a1b-27308aa757d8@gmail.com>
References: <e4614f9442d971016f47d69fbcba226f758377a8.1624215754.git.olivier@trillion01.com>
         <c5394ace-d003-df18-c816-2592fc40bf08@infradead.org>
         <b0c5175177af0bfd216d45da361e114870f07aad.camel@trillion01.com>
         <4578f817-c920-85f1-91af-923d792fc912@infradead.org>
         <7ad30cb0-3322-6c40-2a1b-27308aa757d8@gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.2 
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

On Sun, 2021-06-20 at 21:08 +0100, Pavel Begunkov wrote:
> On 6/20/21 9:01 PM, Randy Dunlap wrote:
> > On 6/20/21 12:28 PM, Olivier Langlois wrote:
> > > On Sun, 2021-06-20 at 12:07 -0700, Randy Dunlap wrote:
> > > > On 6/20/21 12:05 PM, Olivier Langlois wrote:
> > > > > -               return false;
> > > > > +               return ret?IO_ARM_POLL_READY:IO_ARM_POLL_ERR;
> > > > 
> > > > Hi,
> > > > Please make that return expression more readable.
> > > > 
> > > > 
> > > How exactly?
> > > 
> > > by adding spaces?
> > > Changing the define names??
> > 
> > Adding spaces would be sufficient IMO (like Pavel suggested also).
> 
> Agree. That should be in the code style somewhere
> 
Sure no problem.

This hasn't been reported by checkpatch.pl but I have just discovered
codespell... Maybe this addon reports more issues than vanilla
checkpatch



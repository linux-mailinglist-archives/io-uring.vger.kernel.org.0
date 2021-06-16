Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603633A9C52
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 15:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhFPNoz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Jun 2021 09:44:55 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:56044 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbhFPNoy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Jun 2021 09:44:54 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:32854 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1ltVoc-0005pO-5A; Wed, 16 Jun 2021 09:42:46 -0400
Message-ID: <4f32f06306eac4dd7780ed28c06815e3d15b43ad.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: store back buffer in case of failure
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 16 Jun 2021 09:42:45 -0400
In-Reply-To: <b5b37477-985e-54da-fc34-4de389112365@kernel.dk>
References: <60c83c12.1c69fb81.e3bea.0806SMTPIN_ADDED_MISSING@mx.google.com>
         <93256513-08d8-5b15-aa98-c1e83af60b54@gmail.com>
         <b5b37477-985e-54da-fc34-4de389112365@kernel.dk>
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

On Tue, 2021-06-15 at 15:51 -0600, Jens Axboe wrote:
> Ditto for this one, don't see it in my email nor on the list.
> 
I can resend you a private copy of this one but as Pavel pointed out,
it contains fatal flaws.

So unless someone can tell me that the idea is interesting and has
potential and can give me some a hint or 2 about how to address the
challenges to fix the current flaws, it is pretty much a show stopper
to me and I think that I am going to let it go...



Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476953AE07E
	for <lists+io-uring@lfdr.de>; Sun, 20 Jun 2021 22:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhFTU6q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Jun 2021 16:58:46 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:34076 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhFTU6q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Jun 2021 16:58:46 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:33264 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lv4Ua-0000HV-Jt; Sun, 20 Jun 2021 16:56:32 -0400
Message-ID: <b1bc3ada5f78fd34a9827677092d4e981f669cd5.camel@trillion01.com>
Subject: Re: [PATCH v2] io_uring: reduce latency by reissueing the operation
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 20 Jun 2021 16:56:31 -0400
In-Reply-To: <7ed2ecd3-6335-7c47-5915-054b811f92e5@gmail.com>
References: <e4614f9442d971016f47d69fbcba226f758377a8.1624215754.git.olivier@trillion01.com>
         <61668060-6401-ccc0-06e8-29d6320b720a@gmail.com>
         <7ed2ecd3-6335-7c47-5915-054b811f92e5@gmail.com>
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

On Sun, 2021-06-20 at 21:03 +0100, Pavel Begunkov wrote:
> On 6/20/21 8:56 PM, Pavel Begunkov wrote:
> > On 6/20/21 8:05 PM, Olivier Langlois wrote:
> > > 
> > 
> > It's not really an error. Maybe IO_APOLL_ABORTED or so?
> 
> fwiw, I mean totally replacing *_ERR, not only this return
> 
this is how I understood the remark. I will change it as you suggested




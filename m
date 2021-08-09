Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9860E3E4E61
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 23:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbhHIVYj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 17:24:39 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:37728 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbhHIVYi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 17:24:38 -0400
X-Greylist: delayed 3916 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Aug 2021 17:24:38 EDT
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:54428 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@olivierlanglois.net>)
        id 1mDBjg-0002K4-PT; Mon, 09 Aug 2021 16:19:00 -0400
Message-ID: <a7a07d78e8a24612c7afd4ada4a05d462798fb8b.camel@olivierlanglois.net>
Subject: Re: [PATCH 2/3] io-wq: fix no lock protection of acct->nr_worker
From:   Olivier Langlois <olivier@olivierlanglois.net>
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Date:   Mon, 09 Aug 2021 16:19:00 -0400
In-Reply-To: <5f4b7861-de78-8b45-644f-3a9efe3af964@kernel.dk>
References: <20210805100538.127891-1-haoxu@linux.alibaba.com>
         <20210805100538.127891-3-haoxu@linux.alibaba.com>
         <cc9e61da-6591-c257-6899-d2afa037b2ad@kernel.dk>
         <1f795e93-c137-439e-b02c-b460cb38bb14@linux.alibaba.com>
         <5f4b7861-de78-8b45-644f-3a9efe3af964@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
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

On Sat, 2021-08-07 at 07:51 -0600, Jens Axboe wrote:
> 
> Please do - and please always run the full set of tests before
> sending
> out changes like this, you would have seen the slower runs and/or
> timeouts from the regression suite. I ended up wasting time on this
> thinking it was a change I made that broke it, before then debugging
> this one.
> 
Jens,

for my personal info, where is the regression suite?



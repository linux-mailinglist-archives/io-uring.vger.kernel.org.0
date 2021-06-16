Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5103AA3B0
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 21:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhFPTDF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Jun 2021 15:03:05 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:36468 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhFPTDF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Jun 2021 15:03:05 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:32878 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1ltamW-0000Bl-PV; Wed, 16 Jun 2021 15:00:56 -0400
Message-ID: <3f5447bf02453a034f4eb71f092dd1d1455ec7ad.camel@trillion01.com>
Subject: Re: [PATCH v2 2/3] io_uring: minor clean up in trace events
 definition
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 16 Jun 2021 15:00:55 -0400
In-Reply-To: <2ba15b09-2228-9a2a-3ac3-c471dd3fc912@kernel.dk>
References: <60be7e31.1c69fb81.a8bfb.2e54SMTPIN_ADDED_MISSING@mx.google.com>
         <2752dcc1-9e56-ba31-54ea-d2363ecb6c93@gmail.com>
         <def5421f-a3ae-12fd-87a2-6e584f753127@kernel.dk>
         <20210615193532.6d7916d4@gandalf.local.home>
         <2ba15b09-2228-9a2a-3ac3-c471dd3fc912@kernel.dk>
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

On Wed, 2021-06-16 at 06:49 -0600, Jens Axboe wrote:
> 
> Indeed, that is what is causing the situation, and I do have them
> here.
> Olivier, you definitely want to fix your mail setup. It confuses both
> MUAs, but it also actively prevents using the regular tooling to pull
> these patches off lore for example.
> 
Ok, I will... It seems that only my patch emails are having this issue.
I am pretty sure that I can find instances of non patch emails going
making it to the lists...



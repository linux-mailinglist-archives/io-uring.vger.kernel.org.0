Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82826391DBA
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 19:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbhEZRVD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 13:21:03 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:54900 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234048AbhEZRVD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 13:21:03 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:53002 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1llxBp-0005Rh-26; Wed, 26 May 2021 13:19:29 -0400
Message-ID: <2285bf713be951917f9bec40f9cc45045990cc71.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: Add to traces the req pointer when available
From:   Olivier Langlois <olivier@trillion01.com>
To:     Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 26 May 2021 13:19:27 -0400
In-Reply-To: <9505850ae4c203f6b8f056265eddbffaae501806.camel@trillion01.com>
References: <60ac946e.1c69fb81.5efc2.65deSMTPIN_ADDED_MISSING@mx.google.com>
         <439a2ab8-765d-9a77-5dfd-dde2bd6884c4@gmail.com>
         <9a8abcc9-8f7a-8350-cf34-f86e4ac13f5c@samba.org>
         <9505850ae4c203f6b8f056265eddbffaae501806.camel@trillion01.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.1 
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

On Wed, 2021-05-26 at 12:18 -0400, Olivier Langlois wrote:
> > 
> > If that gets changed, could be also include the personality id and
> > flags here,
> > and maybe also translated the opcode and flags to human readable
> > strings?
> > 
> If Jens and Pavel agrees that they would like to see this info in the
> traces, I have no objection adding it.
> 
I need to learn to think longer before replying...

opcode in readable string:
If Jens and Pavel agrees to it, easy to add

flags:
You have my support that it is indeed a very useful info to have in the
submit_sqe trace when debugging with traces

flags in readable string:
After thinking about it, I wouldn't do it. Converting a bitmask of
flags into a string isn't that complex but it isn't trivial neither.
This certainly adds a maintenance burden every time the flags would be
updated. I wouldn't want that burden on my shoulders.



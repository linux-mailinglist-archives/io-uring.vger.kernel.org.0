Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7BA3ADFDD
	for <lists+io-uring@lfdr.de>; Sun, 20 Jun 2021 21:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFTTSE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Jun 2021 15:18:04 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:48546 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhFTTSD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Jun 2021 15:18:03 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:33252 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lv2v7-0004d7-PD; Sun, 20 Jun 2021 15:15:49 -0400
Message-ID: <473dbbd3376a085df4672a30f86fe8faf8f8254a.camel@trillion01.com>
Subject: Re: [PATCH v2 2/3] io_uring: minor clean up in trace events
 definition
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 20 Jun 2021 15:15:48 -0400
In-Reply-To: <902fdad6-4011-07fc-ea0e-5bac4e34d7bc@kernel.dk>
References: <60be7e31.1c69fb81.a8bfb.2e54SMTPIN_ADDED_MISSING@mx.google.com>
         <2752dcc1-9e56-ba31-54ea-d2363ecb6c93@gmail.com>
         <def5421f-a3ae-12fd-87a2-6e584f753127@kernel.dk>
         <20210615193532.6d7916d4@gandalf.local.home>
         <2ba15b09-2228-9a2a-3ac3-c471dd3fc912@kernel.dk>
         <3f5447bf02453a034f4eb71f092dd1d1455ec7ad.camel@trillion01.com>
         <237f71d5-ee6e-247c-c185-e4e6afbd317c@kernel.dk>
         <1cf91b2f760686678acfbefcc66309cd061986d5.camel@trillion01.com>
         <902fdad6-4011-07fc-ea0e-5bac4e34d7bc@kernel.dk>
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

On Wed, 2021-06-16 at 15:33 -0600, Jens Axboe wrote:
> On 6/16/21 3:30 PM, Olivier Langlois wrote:
> > 
> 
> > My take away from all this is that it is very important that my
> > patches
> > do reach the lists and I commit to put the necessary efforts to
> > make
> > that happen.
> 
> Yes. Both for tooling, but also so that non-cc'ed people see it and
> can
> reply.
> 
> > My last email was simply myself starting diagnose where my problem
> > could be outloud.
> > 
> > Steven did mention that he wasn't seeing the Message-Id field in my
> > patch emails. I'm very grateful for this clue!
> > 
> > My main email client is Gnome Evolution (when Message-Id is present
> > in
> > my mails) and I do the following to send out patches:
> > 
> > 1. git format-patch -o ~/patches HEAD^
> > 2. Edit patch file by adding recipients listed by
> > scripts/get_maintainer.pl
> > 3. cat patch_file | msmtp -t -a default
> 
> Why not just use git send-email? That's literally what that is for.
> It's
> what I use to send out patches.
> 
> 
> 
I found my problem. I had to add the option --thread to git format-
patch

as in:
$ git format-patch --thread -o ~/patches HEAD^



Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B4A3A9C0C
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 15:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhFPNf3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Jun 2021 09:35:29 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:42712 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhFPNf2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Jun 2021 09:35:28 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:32852 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1ltVfT-0005SL-R5; Wed, 16 Jun 2021 09:33:19 -0400
Message-ID: <f3cf3dc047dcee400423f526c1fe31510c5bcf61.camel@trillion01.com>
Subject: Re: [PATCH v2 2/3] io_uring: minor clean up in trace events
 definition
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 16 Jun 2021 09:33:18 -0400
In-Reply-To: <def5421f-a3ae-12fd-87a2-6e584f753127@kernel.dk>
References: <60be7e31.1c69fb81.a8bfb.2e54SMTPIN_ADDED_MISSING@mx.google.com>
         <2752dcc1-9e56-ba31-54ea-d2363ecb6c93@gmail.com>
         <def5421f-a3ae-12fd-87a2-6e584f753127@kernel.dk>
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

On Tue, 2021-06-15 at 15:50 -0600, Jens Axboe wrote:
> On 6/15/21 3:48 AM, Pavel Begunkov wrote:
> > On 5/31/21 7:54 AM, Olivier Langlois wrote:
> > > Fix tabulation to make nice columns
> > 
> > Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> I don't have any of the original 1-3 patches, and don't see them on the
> list either. I'd love to apply for 5.14, but...
> 
> Olivier, are you getting any errors sending these out?Usually I'd
> expect
> them in my inbox as well outside of the list, but they don't seem to
> have
> arrived there either.
> 
> In any case, please resend. As Pavel mentioned, a cover letter is
> always
> a good idea for a series of more than one patch.
> 
I do not get any errors but I have noticed too that my emails weren't
accepted by the lists.

They will accept replies in already existing threads but they won't let
me create new ones. ie: accepting my patches.

I'll learn how create a cover email and I will resend the series of
patches later today.

one thing that I can tell, it is that Pavel and you are always
recipients along with the lists for my patches... So you should have a
private copy somewhere in your mailbox...

The other day, I even got this:
-------- Forwarded Message --------
From: Mail Delivery System <Mailer-Daemon@cloud48395.mywhc.ca>
To: olivier@trillion01.com
Subject: Mail delivery failed: returning message to sender
Date: Thu, 10 Jun 2021 11:38:51 -0400

This message was created automatically by mail delivery software.

A message that you sent could not be delivered to one or more of its
recipients. This is a permanent error. The following address(es)
failed:

  linux-kernel@vger.kernel.org
    host vger.kernel.org [23.128.96.18]
    SMTP error from remote mail server after end of data:
    550 5.7.1 Content-Policy accept-into-freezer-1 msg:
    Bayes Statistical Bogofilter considers this message SPAM.  BF:<S
0.9924>  In case you disagree, send the ENTIRE message plus this error
message to <postmaster@vger.kernel.org> ; S230153AbhFJPkq
  io-uring@vger.kernel.org
    host vger.kernel.org [23.128.96.18]
    SMTP error from remote mail server after end of data:
    550 5.7.1 Content-Policy accept-into-freezer-1 msg:
    Bayes Statistical Bogofilter considers this message SPAM.  BF:<S
0.9924>  In case you disagree, send the ENTIRE message plus this error
message to <postmaster@vger.kernel.org> ; S230153AbhFJPkq

There is definitely something that the list software doesn't like in my
emails but I don't know what...

I did send an email to postmaster@vger.kernel.org to tell them about
the problem but I didn't hear back anything from the postmaster... (My
email probably went to the SPAM folder as well!)



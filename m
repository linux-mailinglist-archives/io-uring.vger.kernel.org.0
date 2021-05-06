Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC62374DDC
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 05:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhEFDSS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 23:18:18 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:47480 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhEFDSS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 23:18:18 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:37954 helo=[192.168.1.177])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1leUVs-0000iF-2s; Wed, 05 May 2021 23:17:20 -0400
Message-ID: <0a12170604cfcbce61259661f579fe5640cc7ffb.camel@trillion01.com>
Subject: Re: IORING_OP_POLL_ADD/IORING_OP_POLL_REMOVE questions
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Date:   Wed, 05 May 2021 23:17:19 -0400
In-Reply-To: <db4d01cc-9f58-c04d-d1b6-1208f8fb7220@gmail.com>
References: <8992f5f989808798ad2666b0a3ef8ae8d777b7de.camel@trillion01.com>
         <db4d01cc-9f58-c04d-d1b6-1208f8fb7220@gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.4 
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

Hi Pavel,

On Wed, 2021-05-05 at 18:56 +0100, Pavel Begunkov wrote:
> On 5/4/21 7:06 PM, Olivier Langlois wrote:
> > 
> > 
> > 2. I don't understand what I am looking at. Why am I receiving a
> > completion notification for a POLL request that has just been
> > cancelled? What is the logic behind silently discarding a
> > IORING_OP_POLL_ADD sqe meant to replace an existing one?
> 
> I'm lost in your message, so let's start with simple reasons. All
> requests post one CQE (almost true), including poll_remove requests.
> 
> io_uring_prep_poll_remove(sqe, iouring_build_user_data(IOURING_POLL,
> fd, anfds [fd].egen));
> // io_uring_sqe_set_data(sqe, iouring_build_user_data(IOURING_POLL, fd,
> anfds [fd].egen));
> 
> If poll remove and poll requests have identical user_data, as in
> the second (commented?) line you'll get two CQEs with that user_data.
> 
> Did you check return value (in CQE) of poll remove? I'd recommend
> set its user_data to something unique. Did you consider that it
> may fail?

Your comments does help me to see clearer!

You are correct that setting the poll remove user_data is not done.
(hence the commented out statement for that purpose but I must have
entertain the idea to set it at some point to see what good it would
do)

The reason being that I do not care about whether or not it succeeds
because the very next thing that I do is to rearm the poll for the same
fd with a different event mask.

Beside, the removed poll original sqe is reported back as ECANCELED (-
125):
85 gen 1 res -125

This appear to be the code returned in io_poll_remove_one()

Does the poll remove operation generates 2 cqes?
1 for the canceled sqe and and 1 for the poll remove sqe itself?

I am not too sure what good setting a distinct user_data to the poll
remove sqe could do but I will definitely give it a shot to perhaps see
clearer.

Note that the poll remove sqe and the following poll add sqe don't have
exactly the same user_data.

I have this statement in between:
/* increment generation counter to avoid handling old events */
          ++anfds [fd].egen;

poll remove cancel the previous poll add having gen 1 in its user data.
the next poll add has it user_data storing gen var set to 2:

1 3 remove 85 1
1 3 add 85 2

85 gen 1 res -125
85 gen 1 res 4

I'll try to be more succinct this time.

If the poll add sqe having gen 1 in its user_data is cancelled, how can
its completion can be reported in the very next cqe?

and I never hear back about the poll add gen 2 sqe...

I'll try to get more familiar with the fs/io_uring.c code but it feels
like it could be some optimization done where because the cancelled
poll result is available while inside io_uring_enter(), instead of
discarding it to immediately rearm it for the new poll add request,
io_uring_enter() instead decide to return it back to reply to the gen 2
request but it forgets to update the user_data field before doing so...

Maybe what is confusing is that the heading "1 3" in my traces is the
EV_READ EV_WRITE bitmask which values are:

EV_READ  = 1
EV_WRITE = 2

while

POLLIN  = 1
POLLOUT = 4

So my poll add gen 1 request was for be notified for POLLIN. This is
what I got with the question #1 "195" result.

Therefore the:
85 gen 1 res 4

can only be for my poll add gen 2 requesting for POLLIN|POLLOUT. Yet,
it is reported with the previous request user_data...

I feel the mystery is almost solved with your help... I'll continue my
investigation and I'll report back if I finally solve the mystery.
>  
> > 3. As I am writing this email, I have just noticed that it was
> > possible
> > to update an existing POLL entry with IORING_OP_POLL_REMOVE through
> > io_uring_prep_poll_update(). Is this what I should do to eliminate my
> > problems? What are the possible race conditions scenarios that I
> > should
> > be prepared to handle by using io_uring_prep_poll_update() (ie:
> > completion of the poll entry to update while my process is inside
> > io_uring_enter() to update it...)?
> 
> Update is preferable, but it's Linux kernel 5.13.
> Both remove and update may fail. e.g. with -EALREADY
> 
I am just about to install 5.12 on my system and this and the new
multishot poll feature makes me already crave 5.13!

Greetings,
Olivier



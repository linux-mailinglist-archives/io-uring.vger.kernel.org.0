Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2355E3A8CA1
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 01:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhFOXhj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 19:37:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230039AbhFOXhj (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 15 Jun 2021 19:37:39 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F24E61356;
        Tue, 15 Jun 2021 23:35:34 +0000 (UTC)
Date:   Tue, 15 Jun 2021 19:35:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] io_uring: minor clean up in trace events
 definition
Message-ID: <20210615193532.6d7916d4@gandalf.local.home>
In-Reply-To: <def5421f-a3ae-12fd-87a2-6e584f753127@kernel.dk>
References: <60be7e31.1c69fb81.a8bfb.2e54SMTPIN_ADDED_MISSING@mx.google.com>
        <2752dcc1-9e56-ba31-54ea-d2363ecb6c93@gmail.com>
        <def5421f-a3ae-12fd-87a2-6e584f753127@kernel.dk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 15 Jun 2021 15:50:29 -0600
Jens Axboe <axboe@kernel.dk> wrote:

> On 6/15/21 3:48 AM, Pavel Begunkov wrote:
> > On 5/31/21 7:54 AM, Olivier Langlois wrote:  
> >> Fix tabulation to make nice columns  
> > 
> > Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>  
> 
> I don't have any of the original 1-3 patches, and don't see them on the
> list either. I'd love to apply for 5.14, but...
> 
> Olivier, are you getting any errors sending these out? Usually I'd expect
> them in my inbox as well outside of the list, but they don't seem to have
> arrived there either.
> 
> In any case, please resend. As Pavel mentioned, a cover letter is always
> a good idea for a series of more than one patch.
> 

I found them in my inbox, but for some reason, none of them have a
Message-id tag, which explains why the replies don't follow them nor can
you find them in any mailing list.

-- Steve

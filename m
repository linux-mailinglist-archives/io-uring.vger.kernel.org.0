Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92ECC372B23
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 15:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhEDNgr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 May 2021 09:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231159AbhEDNgq (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 4 May 2021 09:36:46 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8029610A7;
        Tue,  4 May 2021 13:35:51 +0000 (UTC)
Date:   Tue, 4 May 2021 09:35:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: Tracing busy processes/threads freezes/stalls the whole machine
Message-ID: <20210504093550.5719d4bd@gandalf.local.home>
In-Reply-To: <f590b26d-c027-cc5a-bcbd-1dc734f72e7e@samba.org>
References: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
        <20210504092404.6b12aba4@gandalf.local.home>
        <f590b26d-c027-cc5a-bcbd-1dc734f72e7e@samba.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 4 May 2021 15:28:12 +0200
Stefan Metzmacher <metze@samba.org> wrote:

> Am 04.05.21 um 15:24 schrieb Steven Rostedt:
> > On Thu, 22 Apr 2021 16:26:57 +0200
> > Stefan Metzmacher <metze@samba.org> wrote:
> >   
> >> Hi Steven, hi Ingo,
> >>  
> > 
> > Sorry, somehow I missed this.
> >   
> >> # But
> >> # trace-cmd record -e all -P 7  

Perhaps you could try something like this:

 # trace-cmd list -s |
    while read e ; do
      echo "testing $e";
      trace-cmd record -P 7 -e $e sleep 1;
    done

Which will enable each system at a time, and see if we can pin point what
is causing the lock up. Narrow it down to a tracing system.

-- Steve

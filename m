Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB472372B17
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 15:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhEDNdk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 May 2021 09:33:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231175AbhEDNdk (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 4 May 2021 09:33:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03953610A7;
        Tue,  4 May 2021 13:32:44 +0000 (UTC)
Date:   Tue, 4 May 2021 09:32:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: Tracing busy processes/threads freezes/stalls the whole machine
Message-ID: <20210504093243.4d664594@gandalf.local.home>
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
> > 
> > I'm curious. 
> > 
> > What is the clock set to? What does:
> > 
> >  # trace-cmd list -C
> > 
> > show?  
> 
> On both machine (physical and VM):
> trace-cmd list -C
> [local] global counter uptime perf mono mono_raw boot x86-tsc
> 
> Thanks for looking at it!

Bah, I was hoping it would show "[global]" as we just discovered a bug
because the global clock took a spin lock and a recent change allowed it to
recurse once (causing a deadlock if it happened). But the "[local]" clock
has no such issue. Which means I need to do a bit more digging into this
cause :-(

-- Steve


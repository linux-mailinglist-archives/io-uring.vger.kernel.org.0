Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7A6372ADF
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 15:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhEDNZB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 May 2021 09:25:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230413AbhEDNZB (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 4 May 2021 09:25:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1A67611AE;
        Tue,  4 May 2021 13:24:05 +0000 (UTC)
Date:   Tue, 4 May 2021 09:24:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: Tracing busy processes/threads freezes/stalls the whole machine
Message-ID: <20210504092404.6b12aba4@gandalf.local.home>
In-Reply-To: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
References: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 22 Apr 2021 16:26:57 +0200
Stefan Metzmacher <metze@samba.org> wrote:

> Hi Steven, hi Ingo,
> 

Sorry, somehow I missed this.

> # But
> # trace-cmd record -e all -P 7

I'm curious. 

What is the clock set to? What does:

 # trace-cmd list -C

show?

-- Steve

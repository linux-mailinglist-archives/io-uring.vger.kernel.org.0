Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D899394D94
	for <lists+io-uring@lfdr.de>; Sat, 29 May 2021 19:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhE2R5i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 May 2021 13:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229716AbhE2R5h (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 29 May 2021 13:57:37 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3D7C61059;
        Sat, 29 May 2021 17:55:59 +0000 (UTC)
Date:   Sat, 29 May 2021 13:55:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@redhat.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io_uring: Add to traces the req pointer when available
Message-ID: <20210529135558.7ec54cb7@oasis.local.home>
In-Reply-To: <6fd74635-d3a8-7319-bcc6-c2c1de9c87ee@gmail.com>
References: <60ac946e.1c69fb81.5efc2.65deSMTPIN_ADDED_MISSING@mx.google.com>
        <439a2ab8-765d-9a77-5dfd-dde2bd6884c4@gmail.com>
        <9a8abcc9-8f7a-8350-cf34-f86e4ac13f5c@samba.org>
        <9505850ae4c203f6b8f056265eddbffaae501806.camel@trillion01.com>
        <20210528184248.46926090@gandalf.local.home>
        <6fd74635-d3a8-7319-bcc6-c2c1de9c87ee@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 29 May 2021 13:30:31 +0100
Pavel Begunkov <asml.silence@gmail.com> wrote:

> io_uring offers all different operations and has internal request/memory
> recycling, so it may be an easy vector of attack in case of some
> vulnerabilities found, but nothing special. As that's the status quo,
> I wouldn't care, let's put aside my concerns and print them raw.

There's a lot of information that the tracing subsystem gives that would
help several vectors of attack without the need for pointers. That's
why there's a lockdown method to disable all tracing. But the tracing
system is also good at finding out if your system has been compromised ;-)

-- Steve

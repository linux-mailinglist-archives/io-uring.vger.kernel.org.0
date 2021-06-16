Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5640F3A9C60
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 15:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbhFPNpf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Jun 2021 09:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233544AbhFPNpa (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 16 Jun 2021 09:45:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67D2E611EE;
        Wed, 16 Jun 2021 13:43:23 +0000 (UTC)
Date:   Wed, 16 Jun 2021 09:43:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Olivier Langlois <olivier@trillion01.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] io_uring: minor clean up in trace events
 definition
Message-ID: <20210616094321.671b82dc@gandalf.local.home>
In-Reply-To: <f3cf3dc047dcee400423f526c1fe31510c5bcf61.camel@trillion01.com>
References: <60be7e31.1c69fb81.a8bfb.2e54SMTPIN_ADDED_MISSING@mx.google.com>
        <2752dcc1-9e56-ba31-54ea-d2363ecb6c93@gmail.com>
        <def5421f-a3ae-12fd-87a2-6e584f753127@kernel.dk>
        <f3cf3dc047dcee400423f526c1fe31510c5bcf61.camel@trillion01.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 16 Jun 2021 09:33:18 -0400
Olivier Langlois <olivier@trillion01.com> wrote:

> I do not get any errors but I have noticed too that my emails weren't
> accepted by the lists.
> 
> They will accept replies in already existing threads but they won't let
> me create new ones. ie: accepting my patches.

How are you sending your patches? The patches that were rejected, did not
have the "Message-ID:" tag in the header. If you look at my email (and
yours that I'm replying to now) you'll see something like this:

 Message-ID: <f3cf3dc047dcee400423f526c1fe31510c5bcf61.camel@trillion01.com>

(that's from the email I'm replying to).

All emails are suppose to have this tag. This is what is used to map
replies in a way that your email client can see what email is replying to
which email. Again, from your email:

 In-Reply-To: <def5421f-a3ae-12fd-87a2-6e584f753127@kernel.dk>

That's because the email you replied to had:

 Message-ID: <def5421f-a3ae-12fd-87a2-6e584f753127@kernel.dk>

This is also used for mail archives, as message ids are used to
differentiate emails from each other. But if the Message-ID is missing, the
archives have no idea to map it.

I'm guessing that the mailing lists also flag any email that is missing a
Message-ID as spam.

Thus, you should find out what is wrong with your client software that is
sending out the patches, and see why it's not including the Message-ID.

-- Steve

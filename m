Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BE62A35B6
	for <lists+io-uring@lfdr.de>; Mon,  2 Nov 2020 22:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgKBVAr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Nov 2020 16:00:47 -0500
Received: from shells.gnugeneration.com ([66.240.222.126]:51274 "EHLO
        shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgKBVAq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Nov 2020 16:00:46 -0500
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Nov 2020 16:00:46 EST
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id 90DB21A4035B; Mon,  2 Nov 2020 12:52:59 -0800 (PST)
Date:   Mon, 2 Nov 2020 12:52:59 -0800
From:   Vito Caputo <vcaputo@pengaru.com>
To:     io-uring@vger.kernel.org
Subject: relative openat dirfd reference on submit
Message-ID: <20201102205259.qsbp6yea3zfrqwuk@shells.gnugeneration.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello list,

I've been tinkering a bit with some async continuation passing style
IO-oriented code employing liburing.  This exposed a kind of awkward
behavior I suspect could be better from an ergonomics perspective.

Imagine a bunch of OPENAT SQEs have been prepared, and they're all
relative to a common dirfd.  Once io_uring_submit() has consumed all
these SQEs across the syscall boundary, logically it seems the dirfd
should be safe to close, since these dirfd-dependent operations have
all been submitted to the kernel.

But when I attempted this, the subsequent OPENAT CQE results were all
-EBADFD errors.  It appeared the submit didn't add any references to
the dependent dirfd.

To work around this, I resorted to stowing the dirfd and maintaining a
shared refcount in the closures associated with these SQEs and
executed on their CQEs.  This effectively forced replicating the
batched relationship implicit in the shared parent dirfd, where I
otherwise had zero need to.  Just so I could defer closing the dirfd
until once all these closures had run on their respective CQE arrivals
and the refcount for the batch had reached zero.

It doesn't seem right.  If I ensure sufficient queue depth and
explicitly flush all the dependent SQEs beforehand
w/io_uring_submit(), it seems like I should be able to immediately
close(dirfd) and have the close be automagically deferred until the
last dependent CQE removes its reference from the kernel side.

Regards,
Vito Caputo

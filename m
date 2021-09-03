Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23D24007A4
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 23:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348976AbhICV62 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 17:58:28 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:52336 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344767AbhICV61 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 17:58:27 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mMH9W-000tKw-R0; Fri, 03 Sep 2021 21:55:14 +0000
Date:   Fri, 3 Sep 2021 21:55:14 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Palash Oswal <oswalpalash@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel@vger.kernel.org,
        syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
Subject: Re: [PATCH v3 0/2] iter revert problems
Message-ID: <YTKZwuUtJJDQb8F+@zeniv-ca.linux.org.uk>
References: <cover.1629713020.git.asml.silence@gmail.com>
 <65d27d2d-30f1-ccca-1755-fcf2add63c44@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65d27d2d-30f1-ccca-1755-fcf2add63c44@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 03, 2021 at 02:55:26PM -0600, Jens Axboe wrote:
> On 8/23/21 4:18 AM, Pavel Begunkov wrote:
> > iov_iter_revert() doesn't go well with iov_iter_truncate() in all
> > cases, see 2/2 for the bug description. As mentioned there the current
> > problems is because of generic_write_checks(), but there was also a
> > similar case fixed in 5.12, which should have been triggerable by normal
> > write(2)/read(2) and others.
> > 
> > It may be better to enforce reexpands as a long term solution, but for
> > now this patchset is quickier and easier to backport.
> > 
> > v2: don't fail if it was justly fully reverted
> > v3: use truncated size + reexapand based approach
> 
> Al, let's get this upstream. How do you want to handle it? I can take
> it through the io_uring tree, or it can go through your tree. I really
> don't care which route it takes, but we should get this upstream as
> it solves a real problem.

Grabbed, will test and send a pull request...

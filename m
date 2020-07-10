Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1682B21B891
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 16:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgGJOZG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 10:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbgGJOZG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 10:25:06 -0400
Received: from sym2.noone.org (sym2.noone.org [IPv6:2a01:4f8:120:4161::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3088C08C5CE
        for <io-uring@vger.kernel.org>; Fri, 10 Jul 2020 07:25:05 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4B3FgM35QBzvjdR; Fri, 10 Jul 2020 16:25:03 +0200 (CEST)
Date:   Fri, 10 Jul 2020 16:25:03 +0200
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH] test/statx: verify against statx(2) on all archs
Message-ID: <20200710142501.jrj5cnwmpiyq5ign@distanz.ch>
References: <20200709213452.21290-1-tklauser@distanz.ch>
 <304e4cdb-f090-ef90-18e1-d677d659918a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <304e4cdb-f090-ef90-18e1-d677d659918a@kernel.dk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020-07-10 at 15:55:24 +0200, Jens Axboe <axboe@kernel.dk> wrote:
> On 7/9/20 3:34 PM, Tobias Klauser wrote:
> > Use __NR_statx in do_statx and unconditionally use it to check the
> > result on all architectures, not just x86_64. This relies on the
> > fact that __NR_statx should be defined if struct statx and STATX_ALL are
> > available as well.
> > 
> > Don't fail the test if the statx syscall returns EOPNOTSUPP though.
> 
> Applied, thanks.

And thanks for your follow-up fix! Looking at it I noticed that
statx_syscall_supported introduced by this change should check for
ENOSYS, not EOPNOTSUPP. Will send another follow-up.

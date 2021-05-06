Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DA8375A77
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 20:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbhEFS4O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 14:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbhEFS4O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 May 2021 14:56:14 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8415C061574;
        Thu,  6 May 2021 11:55:15 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lej9R-00Bx5D-Ud; Thu, 06 May 2021 18:55:10 +0000
Date:   Thu, 6 May 2021 18:55:09 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        yangerkun <yangerkun@huawei.com>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] block: reexpand iov_iter after read/write
Message-ID: <YJQ7jf7Twxexx31T@zeniv-ca.linux.org.uk>
References: <20210401071807.3328235-1-yangerkun@huawei.com>
 <a2e97190-936d-ebe0-2adc-748328076f31@gmail.com>
 <7ff7d1b7-8b6d-a684-1740-6a62565f77b6@gmail.com>
 <3368729f-e61d-d4b6-f2ae-e17ebe59280e@gmail.com>
 <3d6904c0-9719-8569-2ae8-dd9694da046b@huawei.com>
 <05803db5-c6de-e115-3db2-476454b20668@gmail.com>
 <YIwVzWEU97BylYK1@zeniv-ca.linux.org.uk>
 <2ee68ca3-e466-24d4-3766-8c627d94d71e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ee68ca3-e466-24d4-3766-8c627d94d71e@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 06, 2021 at 11:19:03AM -0600, Jens Axboe wrote:

> Doing a quick profile, on the latter run with ->write_iter() we're
> spending 8% of the time in _copy_from_iter(), and 4% in
> new_sync_write(). That's obviously not there at all for the first case.
> Both have about 4% in eventfd_write(). Non-iter case spends 1% in
> copy_from_user().
> 
> Finally with your branch pulled in as well, iow using ->write_iter() for
> eventfd and your iov changes:
> 
> Executed in  485.26 millis    fish           external
>    usr time  103.09 millis   70.00 micros  103.03 millis
>    sys time  382.18 millis   83.00 micros  382.09 millis
> 
> Executed in  485.16 millis    fish           external
>    usr time  104.07 millis   69.00 micros  104.00 millis
>    sys time  381.09 millis   94.00 micros  381.00 millis
> 
> and there's no real difference there. We're spending less time in
> _copy_from_iter() (8% -> 6%) and less time in new_sync_write(), but
> doesn't seem to manifest itself in reduced runtime.

Interesting... do you have instruction-level profiles for _copy_from_iter()
and new_sync_write() on the last of those trees?

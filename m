Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66E3375C9D
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 23:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhEFVJz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 17:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbhEFVJy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 May 2021 17:09:54 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670C6C061574;
        Thu,  6 May 2021 14:08:55 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lelEo-00Bzxy-Ud; Thu, 06 May 2021 21:08:51 +0000
Date:   Thu, 6 May 2021 21:08:50 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        yangerkun <yangerkun@huawei.com>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] block: reexpand iov_iter after read/write
Message-ID: <YJRa4gQSWl3/eMXV@zeniv-ca.linux.org.uk>
References: <20210401071807.3328235-1-yangerkun@huawei.com>
 <a2e97190-936d-ebe0-2adc-748328076f31@gmail.com>
 <7ff7d1b7-8b6d-a684-1740-6a62565f77b6@gmail.com>
 <3368729f-e61d-d4b6-f2ae-e17ebe59280e@gmail.com>
 <3d6904c0-9719-8569-2ae8-dd9694da046b@huawei.com>
 <05803db5-c6de-e115-3db2-476454b20668@gmail.com>
 <YIwVzWEU97BylYK1@zeniv-ca.linux.org.uk>
 <2ee68ca3-e466-24d4-3766-8c627d94d71e@kernel.dk>
 <YJQ7jf7Twxexx31T@zeniv-ca.linux.org.uk>
 <b4fe4a3d-06ab-31e3-e1a2-46c23307b32a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4fe4a3d-06ab-31e3-e1a2-46c23307b32a@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 06, 2021 at 01:15:01PM -0600, Jens Axboe wrote:

> Attached output of perf annotate <func> for that last run.

Heh...  I wonder if keeping the value of iocb_flags(file) in
struct file itself would have a visible effect...

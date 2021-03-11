Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46B833707B
	for <lists+io-uring@lfdr.de>; Thu, 11 Mar 2021 11:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhCKKuJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 05:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbhCKKtx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 05:49:53 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ED4C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 02:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:To:From:CC;
        bh=7yAhU8WkbUT2hPMVW5Yvw4g0612iY2+6g/ftqXyuEoQ=; b=h6eF/qLexhKFVtlyBN3MDsuK0y
        7sX8CiSODnc1QI8oLTduWQhI3XuOh7dVqWjsY4CvhKejRlCgMbP9uHcDTUeKnLeztnKWFysuRb667
        mEkPYahY4d9+INjYG3Ax/UpCmpJBtw1lhaJBOfRVyvcVbyyOvAi4wDNO1B7YJs45IafEHK2U4eXym
        Un/BCb8mctpAaUQ1955/KQNnAQqDR1S164KlQrRvIOeEEkHMcAD8YN37VMleqTXJdONRKyNhd+nhe
        IoSG8Eg69sp29C4B7JFjUS9RD3V1Jkn2VUfObbvLltV+72sHeSPCsQpXeGWuUuufgncnPCE8Qmzjw
        zWpVJ9gLSF1Tov2h//6Wygwa87oSne7v8FTJGXViP6ZBHlO7Jfq7L9YjIN6E/+0KWJCUyibhh6ijC
        67cjQ5518y5LpDE3sxQmV3llNKqwdjw6z2+oopuLqf7ixgJCaHujqqr/tdi2RoMG2qBVTLQZabiKE
        VcK94T8jzi0lax4cpeJR6+cg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lKIt5-0001wR-4G; Thu, 11 Mar 2021 10:49:51 +0000
Subject: Re: [PATCH 1/3] io_uring: fix invalid ctx->sq_thread_idle
From:   Stefan Metzmacher <metze@samba.org>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1615381765.git.asml.silence@gmail.com>
 <fd8edef7aecde8d776d703350b3f6c0ec3154ed3.1615381765.git.asml.silence@gmail.com>
 <a25f115b-830c-e0f6-6d61-ff171412ea8b@samba.org>
Message-ID: <0168827e-6a34-69d2-3d75-1894ab3289e6@samba.org>
Date:   Thu, 11 Mar 2021 11:49:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <a25f115b-830c-e0f6-6d61-ff171412ea8b@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> I wondered about the exact same change this morning, while researching
> the IORING_SETUP_ATTACH_WQ behavior :-)
> 
> It still seems to me that IORING_SETUP_ATTACH_WQ changed over time.
> As you introduced that flag, can you summaries it's behavior (and changes)
> over time (over the releases).
> 
> I'm wondering if ctx->sq_creds is really the only thing we need to take care of.
> 
> Do we know about existing users of IORING_SETUP_ATTACH_WQ and their use case?
> As mm, files and other things may differ now between sqe producer and the sq_thread.

I'll start a new thread for this...

metze


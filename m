Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B11447E1D6
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 11:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347764AbhLWK5O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 05:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239583AbhLWK5M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 05:57:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921D8C061401;
        Thu, 23 Dec 2021 02:57:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58B4AB81FC9;
        Thu, 23 Dec 2021 10:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D777C36AE9;
        Thu, 23 Dec 2021 10:57:08 +0000 (UTC)
Date:   Thu, 23 Dec 2021 11:57:05 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org
Subject: Re: [PATCH v6 3/5] fs: split off do_getxattr from getxattr
Message-ID: <20211223105705.pzeifvpvhwuektvx@wittgenstein>
References: <20211222210127.958902-1-shr@fb.com>
 <20211222210127.958902-4-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211222210127.958902-4-shr@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 22, 2021 at 01:01:25PM -0800, Stefan Roesch wrote:
> This splits off do_getxattr function from the getxattr
> function. This will allow io_uring to call it from its
> io worker.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---

Looks good.
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

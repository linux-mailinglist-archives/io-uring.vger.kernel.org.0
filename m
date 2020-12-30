Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E3B2E79EB
	for <lists+io-uring@lfdr.de>; Wed, 30 Dec 2020 15:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgL3OSh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Dec 2020 09:18:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35877 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgL3OSg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Dec 2020 09:18:36 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1kucIV-0001NV-5u; Wed, 30 Dec 2020 14:17:55 +0000
Date:   Wed, 30 Dec 2020 15:17:53 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring: don't assume mm is constant across submits
Message-ID: <20201230141753.hakwbf6c6xw2ohts@wittgenstein>
References: <7224e4df-50e9-ffd1-5453-391802fcded7@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7224e4df-50e9-ffd1-5453-391802fcded7@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 29, 2020 at 10:53:21AM -0700, Jens Axboe wrote:
> If we COW the identity, we assume that ->mm never changes. But this
> isn't true of multiple processes end up sharing the ring. Hence treat
> id->mm like like any other process compontent when it comes to the
> identity mapping.
> 
> Reported-by: Christian Brauner <christian.brauner@ubuntu.com>:
> Tested-by: Christian Brauner <christian.brauner@ubuntu.com>:
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---

Thanks for fixing this! Fwiw, tested again just now.

Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>

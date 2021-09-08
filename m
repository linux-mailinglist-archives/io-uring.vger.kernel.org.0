Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6BC4037CF
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 12:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346391AbhIHK0r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 06:26:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234958AbhIHK0q (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 8 Sep 2021 06:26:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5BE56113A;
        Wed,  8 Sep 2021 10:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631096739;
        bh=NiCfI13R4LrvaT+owBE7g+4UJWIO/e9R5b5MoX02Png=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gas+Gt4RivH1IpU96+UkUeQZJJ74+BIM5F6tA36+SvsipUXg44ungmeVaSPR0N37d
         WHog008RdrlsReaMXEyNzOUhjPEUew0gFSLtz6EsR/p8sv6g5kzRD3Tmm2S85M+WGz
         gRbT1y/EmznblAlZN9EAYaX6UW8vsBOtEEZGp4H0=
Date:   Wed, 8 Sep 2021 12:25:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] /dev/mem: nowait zero/null ops
Message-ID: <YTiPoKc9GiG52DNd@kroah.com>
References: <16c78d25f507b571df7eb852a571141a0fdc73fd.1631095567.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16c78d25f507b571df7eb852a571141a0fdc73fd.1631095567.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Sep 08, 2021 at 11:06:51AM +0100, Pavel Begunkov wrote:
> Make read_iter_zero() to honor IOCB_NOWAIT, so /dev/zero can be
> advertised as FMODE_NOWAIT. This helps subsystems like io_uring to use
> it more effectively. Set FMODE_NOWAIT for /dev/null as well, it never
> waits and therefore trivially meets the criteria.

I do not understand, why would io_uring need to use /dev/zero and how is
this going to help anything?

What workload does this help with?

thanks,

greg k-h

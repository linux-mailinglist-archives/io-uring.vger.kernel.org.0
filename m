Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B2A33DA78
	for <lists+io-uring@lfdr.de>; Tue, 16 Mar 2021 18:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237706AbhCPRQd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Mar 2021 13:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237835AbhCPRQc (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 16 Mar 2021 13:16:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02AE165087;
        Tue, 16 Mar 2021 17:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615914991;
        bh=fdcmLeCKntdm771dazuCVoEbNhFZVVC6Ghj+TWf/STk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CCDR/xpjvR4QU7lzoqi/3tosKKyd7W5ENo4MsTOL1gmsrGkGvfcqH54Bqrc+7BRa4
         UwovXz7O2fLYr8Miki19T7vkIiAbntxwqnKYDzdL3ZtE/UIdKAMxZ7UkGJuQv0ESdl
         uGBDgVJB4qcjS0I6p30h2lTUj845V0AS+s7ipAKxfTiQebursMB0wDOxDB9K79szTg
         OnYtAEUft1o93r6faS0Hg+6qRYLpJyHsOdPQueRPPogT8QUmfhgd1cU/iLOZpOv4pL
         MQw8TKtTtXLbZ7l0tCY9ssBXsxJ+y9ddnccOEBSP0Euw2TwyBjSF4iJHO+0FJokpti
         kyW7XzEStEuwQ==
Date:   Tue, 16 Mar 2021 10:16:28 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, chaitanya.kulkarni@wdc.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com,
        nj.shetty@samsung.com, selvakuma.s1@samsung.com
Subject: Re: [RFC PATCH v3 2/3] nvme: keep nvme_command instead of pointer to
 it
Message-ID: <20210316171628.GA4161119@dhcp-10-100-145-180.wdc.com>
References: <20210316140126.24900-1-joshi.k@samsung.com>
 <CGME20210316140236epcas5p4de087ee51a862402146fbbc621d4d4c6@epcas5p4.samsung.com>
 <20210316140126.24900-3-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316140126.24900-3-joshi.k@samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 16, 2021 at 07:31:25PM +0530, Kanchan Joshi wrote:
> nvme_req structure originally contained a pointer to nvme_command.
> Change nvme_req structure to keep the command itself.
> This helps in avoiding hot-path memory-allocation for async-passthrough.

I have a slightly different take on how to handle pre-allocated
passthrough commands. Every transport except PCI already preallocates a
'struct nvme_command' within the pdu, so allocating another one looks
redundant. Also, it does consume quite a bit of memory for something
that is used only for the passthrough case.

I think we can solve both concerns by always using the PDU nvme_command
rather than have the transport drivers provide it. I just sent the patch
here if you can take a look. It tested fine on PCI and loop (haven't
tested any other transports).

 http://lists.infradead.org/pipermail/linux-nvme/2021-March/023711.html

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277643EA980
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 19:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbhHLRcO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 13:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235992AbhHLRcM (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 12 Aug 2021 13:32:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5099061019;
        Thu, 12 Aug 2021 17:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628789506;
        bh=zLJtf8RndgZCwd1MqcQhVgLu9czEEZTCIBM263Gh9Y8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rfz9vCXOQXS1zqid1XHR0gfD8etoGGu+p63GyfOzEQaFyZhKzC504cKr93GK7JdUq
         ZzGQ3FkGkMEylRORh5K6s0W/QWuQqVlISqqHqy41JSfMX9sgWQwldBLPz5AYrNv/uP
         rtvH0qbD1s84icS9bo2D+iyl2f5rw5ASHqdOYmZSHOkniW0t9awJFUSj4R9KE5BE+y
         WiSlZsaQQxPd1R1b3aOPwom5V+vtorUnc2acdg8IgAJ4yO6jN/eCaKuHeafVNu+ZaT
         oSHcxgdkFntIHboPuGARJqgDM+16DKwfTcY+8+a7ZsGjbqrPjkc0d74Q6tRkUzwaIa
         +nh5Z9oh050Dw==
Date:   Thu, 12 Aug 2021 10:31:43 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 4/6] block: clear BIO_PERCPU_CACHE flag if polling isn't
 supported
Message-ID: <20210812173143.GA3138953@dhcp-10-100-145-180.wdc.com>
References: <20210812154149.1061502-1-axboe@kernel.dk>
 <20210812154149.1061502-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812154149.1061502-5-axboe@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 12, 2021 at 09:41:47AM -0600, Jens Axboe wrote:
> -	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> +	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags)) {
> +		/* can't support alloc cache if we turn off polling */
> +		bio_clear_flag(bio, BIO_PERCPU_CACHE);
>  		bio->bi_opf &= ~REQ_HIPRI;
> +	}

It looks like you should also clear BIO_PERCPU_CACHE if this bio gets
split in blk_bio_segment_split().

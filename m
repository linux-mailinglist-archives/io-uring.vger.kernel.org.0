Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E702E33F5FD
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 17:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbhCQQqG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 12:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232833AbhCQQpz (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 17 Mar 2021 12:45:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 407B764F3E;
        Wed, 17 Mar 2021 16:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615999554;
        bh=OceBWOdyv6zBcY5gO2hevchCnwcOyefFaOPT/whYD8s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PThgmE4AoCFXNi2ZqOPyv0UxPd1tK8LT0AY0VXzQGAyRY3whkfsN1IoH5KqZW18yN
         Ik/OBktasXRCDKAEcMSi+WCP8I4siYcyL8zOhjmqSRcgxRHRYwuMZebCowCbBQEx/x
         ZywohqoruxcIHSdQDg6C44dmRdiEuvhj25STMgIHi0tN8B554UYu7nRLCmdlfpersy
         UUn9cFiu5eHfJvqpoq2ElIIWkSQNzkwk2awe7nozyo+H7vg5KgBMtAbdVg32LFAz2P
         LCvTmDiiS9R2uDFZdp3KZJjgap71p7lHIrKlNKviKmPd6wwK+r1WK4WV69ViKfwsVA
         guyzgcy3DEcwQ==
Date:   Wed, 17 Mar 2021 09:45:50 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, chaitanya.kulkarni@wdc.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com,
        nj.shetty@samsung.com, selvakuma.s1@samsung.com
Subject: Re: [RFC PATCH v3 3/3] nvme: wire up support for async passthrough
Message-ID: <20210317164550.GA4162742@dhcp-10-100-145-180.wdc.com>
References: <20210316140126.24900-1-joshi.k@samsung.com>
 <CGME20210316140240epcas5p3e71bfe2afecd728c5af60056f21cc9b7@epcas5p3.samsung.com>
 <20210316140126.24900-4-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316140126.24900-4-joshi.k@samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 16, 2021 at 07:31:26PM +0530, Kanchan Joshi wrote:
> @@ -1179,6 +1278,20 @@ static int nvme_submit_user_cmd(struct request_queue *q,
>  			req->cmd_flags |= REQ_INTEGRITY;
>  		}
>  	}
> +	if (ioucmd) { /* async handling */
> +		u32 effects;
> +
> +		effects = nvme_command_effects(ns->ctrl, ns, cmd->common.opcode);
> +		/* filter commands with non-zero effects, keep it simple for now*/

You shouldn't need to be concerned with this. You've wired up the ioucmd
only to the NVME_IOCTL_IO_CMD, and nvme_command_effects() can only
return 0 for that.

It would be worth adding support for NVME_IOCTL_IO_CMD64 too, though,
and that doesn't change the effects handling either.

> +		if (effects) {
> +			ret = -EOPNOTSUPP;
> +			goto out_unmap;
> +		}
> +		nvme_setup_uring_cmd_data(req, ioucmd, meta, write);
> +		blk_execute_rq_nowait(ns ? ns->disk : NULL, req, 0,
> +					nvme_end_async_pt);
> +		return 0;
> +	}

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF0A5EABEF
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 18:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbiIZQDe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 12:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbiIZQCo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 12:02:44 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6ED72EE5;
        Mon, 26 Sep 2022 07:52:02 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 14ACD68AFE; Mon, 26 Sep 2022 16:52:00 +0200 (CEST)
Date:   Mon, 26 Sep 2022 16:51:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
Subject: Re: [PATCH for-next v8 3/5] nvme: refactor nvme_alloc_user_request
Message-ID: <20220926145159.GB20424@lst.de>
References: <20220923092854.5116-1-joshi.k@samsung.com> <CGME20220923093916epcas5p387fdd905413f6d90babecf5d14da5b67@epcas5p3.samsung.com> <20220923092854.5116-4-joshi.k@samsung.com> <20220923153819.GC21275@lst.de> <20220925194354.GA29911@test-zns>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220925194354.GA29911@test-zns>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 26, 2022 at 01:13:54AM +0530, Kanchan Joshi wrote:
>>> +	if (ret)
>>> +		goto out;
>>> +	bio = req->bio;
>>
>> I think we can also do away with this bio local variable now.
>>
>>> +	if (bdev)
>>> +		bio_set_dev(bio, bdev);
>>
>> We don't need the bio_set_dev here as mentioned last time, so I think
>> we should remove it in a prep patch.
>
> we miss completing polled io with this change.
> bdev needs to be put in bio to complete polled passthrough IO.
> nvme_ns_chr_uring_cmd_iopoll uses bio_poll and that in turn makes use of
> this.

Oh, indeed - polling is another and someone unexpected user in
addition to the I/O accounting that does not apply to passthrough
requests.  That also means we can't poll admin commands at all.

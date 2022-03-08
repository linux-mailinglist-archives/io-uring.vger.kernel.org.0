Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C76A4D1E28
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 18:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiCHRJ7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 12:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347882AbiCHRJ6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 12:09:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE5D377F6;
        Tue,  8 Mar 2022 09:09:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC5F460B17;
        Tue,  8 Mar 2022 17:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AACC340EB;
        Tue,  8 Mar 2022 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646759341;
        bh=QEoTqlQMyV5a1Evgn26+23k5reWWaIWsdBlmmLO0qcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cnzRKaDf0SQyj0s0PyVUJGhE0/lzCpZORFfllupHtqBvbOftgphNMzZ48rL930vz0
         SXQRkGutK2xT/kQvQt6bPq/sElirtmDJX6qiuEukHkccDyCmfw2cQCxy2p+VksgVLM
         CkixIiC97BWzeI+KZ3nadrS2YXElVlKkAUyYn01V0KRDqdxjwx36ATSxcNSAOIN6sQ
         5CB8G2vvJqZ16U97gG2LBZ40055RPM62a/Gd97RjLYZT4bq/N2Avfn81JIh0sDSyJS
         2Z+zRJq3eZ2qAejZE42D7CVwlXRvgPSbe10EdTKGbRkpU9coP2L2nruqpTTRufCPyn
         1bjxymrLGbW7w==
Date:   Tue, 8 Mar 2022 09:08:57 -0800
From:   Keith Busch <kbusch@kernel.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: Re: [PATCH 13/17] nvme: allow user passthrough commands to poll
Message-ID: <20220308170857.GA3501708@dhcp-10-100-145-180.wdc.com>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152720epcas5p19653942458e160714444942ddb8b8579@epcas5p1.samsung.com>
 <20220308152105.309618-14-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308152105.309618-14-joshi.k@samsung.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 08, 2022 at 08:51:01PM +0530, Kanchan Joshi wrote:
>  	if (copy_from_user(&io, uio, sizeof(io)))
>  		return -EFAULT;
> -	if (io.flags)
> -		return -EINVAL;
> +	if (io.flags & NVME_HIPRI)
> +		rq_flags |= REQ_POLLED;

I'm pretty sure we can repurpose this previously reserved field for this
kind of special handling without an issue now, but we should continue
returning EINVAL if any unknown flags are set. I have no idea what, if
any, new flags may be defined later, so we shouldn't let a future
application think an older driver honored something we are not handling.

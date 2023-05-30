Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E10716F06
	for <lists+io-uring@lfdr.de>; Tue, 30 May 2023 22:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjE3Up7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 May 2023 16:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjE3Up6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 May 2023 16:45:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0BF8E;
        Tue, 30 May 2023 13:45:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B49861E0E;
        Tue, 30 May 2023 20:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53964C4339E;
        Tue, 30 May 2023 20:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685479556;
        bh=0rs4l6EiZWWcV+qbnz0S8Uf9TCLDxJo8SS3Wi0i7KZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fAEG3zLEpvTRPZD3bfZp0F+TIbJpacFxDteorp4nvTqVtbyR9oogd9J2JxljWeRY5
         PRogqhUtntbsu1FylwTND92/ht1939XRUJ8lRgKnt1GR0Vk6VUS45mg9grMsNjbgEX
         zVYxfzBAnhjbWQscWXNE4OPaEVcydV2qe3Ik66/cFWthwMHLi8Qh+VdTXw9mXAO/mE
         5U2UCItI/taf7/va50i7usHKStQAWAeP6m99d6+hFR8WIWC0h6/dwd9f7QD/qolOku
         AVzUE/EZk6WcI6EeWRUC/ZK7xwTegygs+v2rklLujM7AB6zDHPRlbiD0VFJWc5nTcx
         K6K0njRe7mmmQ==
Date:   Tue, 30 May 2023 14:45:54 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Keith Busch <kbusch@meta.com>
Cc:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] io_uring: set plug tags for same file
Message-ID: <ZHZggvjNnhl/69s/@kbusch-mbp.dhcp.thefacebook.com>
References: <20230504162427.1099469-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504162427.1099469-1-kbusch@meta.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 04, 2023 at 09:24:27AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> io_uring tries to optimize allocating tags by hinting to the plug how
> many it expects to need for a batch instead of allocating each tag
> individually. But io_uring submission queueus may have a mix of many
> devices for io, so the number of io's counted may be overestimated. This
> can lead to allocating too many tags, which adds overhead to finding
> that many contiguous tags, freeing up the ones we didn't use, and may
> starve out other users that can actually use them.

When running batched IO to multiple nvme drives, like with t/io_uring,
this shows a tiny improvement in CPU utilization from avoiding the
unlikely clean up condition in __blk_flush_plug() shown below:

        if (unlikely(!rq_list_empty(plug->cached_rq)))
                blk_mq_free_plug_rqs(plug);

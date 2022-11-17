Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3207962E623
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 21:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbiKQUvw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 15:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiKQUvv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 15:51:51 -0500
Received: from smtp1.emailarray.com (smtp1.emailarray.com [65.39.216.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34852727
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 12:51:49 -0800 (PST)
Received: (qmail 91568 invoked by uid 89); 17 Nov 2022 20:51:48 -0000
Received: from unknown (HELO ?192.168.137.22?) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzMS44MA==) (POLARISLOCAL)  
  by smtp1.emailarray.com with ESMTPS (AES256-GCM-SHA384 encrypted); 17 Nov 2022 20:51:48 -0000
From:   Jonathan Lemon <jlemon@flugsvamp.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v1 07/15] io_uring: Allocate zctap device buffers and dma
 map them.
Date:   Thu, 17 Nov 2022 12:51:46 -0800
X-Mailer: MailMate (1.14r5918)
Message-ID: <F113C5BA-A1B0-409C-BCD2-E12FB15A3704@flugsvamp.com>
In-Reply-To: <Y3ScCh6P1kC5vifs@infradead.org>
References: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
 <20221108050521.3198458-8-jonathan.lemon@gmail.com>
 <Y3ScCh6P1kC5vifs@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 16 Nov 2022, at 0:15, Christoph Hellwig wrote:

>> +		dma_unmap_page_attrs(device, buf->dma, PAGE_SIZE,
>> +				     DMA_BIDIRECTIONAL,
>> +				     DMA_ATTR_SKIP_CPU_SYNC);
>
>> +		addr = dma_map_page_attrs(device, page, 0, PAGE_SIZE,
>> +					  DMA_BIDIRECTIONAL,
>> +					  DMA_ATTR_SKIP_CPU_SYNC);
>
> You can't just magically skip cpu syncs.  The flag is only valid
> for mappings of already mapped memory when following a very careful
> protocol.  I can't see any indications of that beeing true here,
> but maybe I'm just missing something.

This was copied from page_pool_dma_map().  The same logic applies -
io_uring pins the memory, zctap creates a pool that is dma mapped, and
the driver performs dma_sync_single_*() when receiving the packet.
—
Jonathan

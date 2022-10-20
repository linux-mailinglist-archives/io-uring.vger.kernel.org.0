Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91306059B2
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 10:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiJTI0m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 04:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiJTI0l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 04:26:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDE4188A85;
        Thu, 20 Oct 2022 01:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nzKugFjin02AsmVSO2SO0VwhTWFBPSTkNTSFyYe251I=; b=giFg8cmWtAJ+oOhF6XZcXqFAPi
        jZ/26cqTs4SRs/bBLLzAIglFyvHeG1I/OG+TVy1zvB1DTnenH+rJQBm41hPJZxzV1yCvCms87Q1x6
        ATqWDUE3mwDLrZvVCF9+2U4Kh3hL3H1lXjce7om1NWsEeRCgegLpZooIQVUC9YDmFbjZxU5mqz7+z
        79DHJD2eHUKtEj8V/EnOBvCH7apHoICpdmevMPSDBRfFZfpqJRPz2ciiVw56pL7IGHs2WmVbheyOu
        8xF7aRZF7jLWy5LctIP/N4LGJ0O7AWxdW2YLSTIAmygSn6oyPM6GxEodfZVIxguCUiuTmBACU6fOm
        Kf05jfww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1olQsx-00CBhc-8o; Thu, 20 Oct 2022 08:26:39 +0000
Date:   Thu, 20 Oct 2022 01:26:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC for-next v2 1/4] bio: safeguard REQ_ALLOC_CACHE bio put
Message-ID: <Y1EGP30UotgnCc6a@infradead.org>
References: <cover.1666122465.git.asml.silence@gmail.com>
 <558d78313476c4e9c233902efa0092644c3d420a.1666122465.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <558d78313476c4e9c233902efa0092644c3d420a.1666122465.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Oct 18, 2022 at 08:50:55PM +0100, Pavel Begunkov wrote:
> bio_put() with REQ_ALLOC_CACHE assumes that it's executed not from
> an irq context. Let's add a warning if the invariant is not respected,
> especially since there is a couple of places removing REQ_POLLED by hand
> without also clearing REQ_ALLOC_CACHE.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

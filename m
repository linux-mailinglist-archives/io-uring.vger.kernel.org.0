Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475F3620A90
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 08:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbiKHHn6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 02:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbiKHHnf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 02:43:35 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5F5286C2;
        Mon,  7 Nov 2022 23:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iNVXZRDHkYD8+0UZ8oa2Zsbknb/YrKzGV1SBk9BjN5E=; b=4lf+THRQvsw0X8PVy3UXbuUfHx
        4RS8rnVD56hI0Plh246E2OqrTAiXt4q+1vDircwLluVrNELDHqgx81rHWugb9VlkCAZqxkQVxSRxG
        hLPFb1jZPvMg9EhQnTq41iudat9WDd4N/7yhv6pSHd050Md6CzdCTj6ZVmxIq+Ic5hL5PZjGV/pCC
        iWzyruvewaS8QbKgtNESN8pUboaViJsIeNKZfXLaz87l1B4jcssDTmibMLT4kGLVphoVwGchRIOax
        vx0deRdMvLwAM2aZvBUhsoRRiOexab7y85vQvasQngu0DwVSbbSB0+/SzsgWZ97ndsL3e0xqf+jDG
        0OpCoTLA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1osJFq-003THN-Mn; Tue, 08 Nov 2022 07:42:42 +0000
Date:   Mon, 7 Nov 2022 23:42:42 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>
Subject: Re: [RFC PATCH 1/4] io_uring/splice: support do_splice_direct
Message-ID: <Y2oIcpXINyU2MDL3@infradead.org>
References: <20221103085004.1029763-1-ming.lei@redhat.com>
 <20221103085004.1029763-2-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103085004.1029763-2-ming.lei@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Nov 03, 2022 at 04:50:01PM +0800, Ming Lei wrote:
> do_splice_direct() has at least two advantages:
> 
> 1) the extra pipe isn't required from user viewpoint, so userspace
> code can be simplified, meantime easy to relax current pipe
> limit since curret->splice_pipe is used for direct splice
> 
> 2) in some situation, it isn't good to expose file data via
> ->splice_read() to userspace, such as the coming ublk driver's
> zero copy support, request pages will be spliced to pipe for
> supporting zero copy, and if it is READ, userspace may read
> data of kernel pages, and direct splice can avoid this kind
> of info leaks

Please make this a separate opcode instead of overloading the splice
op with a flag that causes very different behavior and isn't supported
for the regular splice syscall.

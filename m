Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A94D620A9E
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 08:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbiKHHp3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 02:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbiKHHpK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 02:45:10 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B72E3B;
        Mon,  7 Nov 2022 23:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6ewPgwNxHVRc6WKIxHPyiXBqFyHds+o1ahLHZvZE1xg=; b=ifVK8+CAykZj3L4fdfuhXMDk2i
        v1DlvRxgQKCMYF8PWsCgD5n9arpFiI+a8YIMXBTWvS8iqgGICv8s7OcKsxleKbDs4JstwO5GMHhTy
        pfFncrihrqM5/qQduqLlG1SIgE/iRS8cTi4DJ66bKOMPOYEx2xuVwzrC0KxUZBKbx2O1p8SXuEQ35
        VdTHpeUF4y3TBoT0j/s+phPUoQDpvCKqg8iuVU1brcw55tqq1GgxBZ0OYDe038SODTVfvGnCGLsAn
        WbRFFUtdAPutJIfEioEVNh7bgueMnNVKKfJNkLaGCPrzp6fMyVENpT7LMUcEKp/HZ4Fl15/Us5pcX
        t1avbwjg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1osJIA-003TRU-CB; Tue, 08 Nov 2022 07:45:06 +0000
Date:   Mon, 7 Nov 2022 23:45:06 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>
Subject: Re: [RFC PATCH 3/4] io_uring/splice: support splice from
 ->splice_read to ->splice_read
Message-ID: <Y2oJAlV3xwqmJK0o@infradead.org>
References: <20221103085004.1029763-1-ming.lei@redhat.com>
 <20221103085004.1029763-4-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103085004.1029763-4-ming.lei@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Nov 03, 2022 at 04:50:03PM +0800, Ming Lei wrote:
> The 1st ->splice_read produces buffer to the pipe of
> current->splice_pipe, and the 2nd ->splice_read consumes the buffer
> in this pipe.

This looks really ugly.  I think you want Linus and Al to look over
it at very least.

Also, what is going to happen if your ->splice_read instance does not
support the flag to magically do something entirely different?

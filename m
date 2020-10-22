Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C5A296134
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 16:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503652AbgJVOzn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 10:55:43 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:39652 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2504243AbgJVOzm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 10:55:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UCr-fjM_1603378536;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UCr-fjM_1603378536)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 22 Oct 2020 22:55:37 +0800
Subject: Re: [PATCH RFC] mm: fix the sync buffered read to the old way
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1603375114-58419-1-git-send-email-haoxu@linux.alibaba.com>
 <20201022141037.GS20115@casper.infradead.org>
From:   Hao_Xu <haoxu@linux.alibaba.com>
Message-ID: <a583f28c-2066-76db-c6c8-7b2a49cc5e4d@linux.alibaba.com>
Date:   Thu, 22 Oct 2020 22:55:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201022141037.GS20115@casper.infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ÔÚ 2020/10/22 ÏÂÎç10:10, Matthew Wilcox Ð´µÀ:
> On Thu, Oct 22, 2020 at 09:58:34PM +0800, Hao Xu wrote:
>> The commit 324bcf54c449 changed the code path of async buffered reads
>> to go with the page_cache_sync_readahead() way when readahead is
>> disabled, meanwhile the sync buffered reads are forced to do IO in the
>> above way as well, which makes it go to a more complex code path.
> 
> But ->readpage is (increasingly) synchronous while readahead should be
> used to start async I/Os.  I'm pretty sure Jens meant to do exactly what
> he did.
Yes, we should start async I/Os with readahead, but why should we do the 
sync I/O like syscall read() in this way too when ra->ra_pages is 0?
> 

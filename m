Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1A378BF8F
	for <lists+io-uring@lfdr.de>; Tue, 29 Aug 2023 09:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbjH2Hqy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Aug 2023 03:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbjH2Hqh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Aug 2023 03:46:37 -0400
Received: from out-251.mta1.migadu.com (out-251.mta1.migadu.com [IPv6:2001:41d0:203:375::fb])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B788194;
        Tue, 29 Aug 2023 00:46:34 -0700 (PDT)
Message-ID: <c728bf3f-d9db-4865-8473-058b26c11c06@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1693295192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WP3nN15JcnIGn7wEIePFcf6LVOuPCzTP32Hu73YPviw=;
        b=ngCnTfY2JVdB7UbTvhBxaE99SXYf68v1UOzv1oD4Q4J5vfDrhRAI+RinhUow/HJ/SENsM3
        ljkpELTTwPgx4fdS1Wsi0U6qZJzH3KEWBSpgNNnZhZo9Ah7qcNPQhnBWxHwyd9Ba5JlzW/
        R7n89/DPeOOyD3xIKShExED+0gXsmv8=
Date:   Tue, 29 Aug 2023 15:46:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 07/11] vfs: add nowait parameter for file_accessed()
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-cachefs@redhat.com,
        ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org,
        devel@lists.orangefs.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mtd@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-8-hao.xu@linux.dev>
 <ZOvA5DJDZN0FRymp@casper.infradead.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZOvA5DJDZN0FRymp@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/28/23 05:32, Matthew Wilcox wrote:
> On Sun, Aug 27, 2023 at 09:28:31PM +0800, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> Add a boolean parameter for file_accessed() to support nowait semantics.
>> Currently it is true only with io_uring as its initial caller.
> 
> So why do we need to do this as part of this series?  Apparently it
> hasn't caused any problems for filemap_read().
> 

We need this parameter to indicate if nowait semantics should be 
enforced in touch_atime(), There are locks and maybe IOs in it.


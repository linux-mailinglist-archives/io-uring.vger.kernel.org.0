Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E5278D32B
	for <lists+io-uring@lfdr.de>; Wed, 30 Aug 2023 08:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240106AbjH3GMh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Aug 2023 02:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239829AbjH3GMM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Aug 2023 02:12:12 -0400
Received: from out-245.mta0.migadu.com (out-245.mta0.migadu.com [IPv6:2001:41d0:1004:224b::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE025CDC;
        Tue, 29 Aug 2023 23:12:01 -0700 (PDT)
Message-ID: <642de4e6-801d-fcad-a7ce-bfc6dec3b6e5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1693375918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JMzOvVHk770qYz+7D4bRM3eiaC0WBb12Z/fuZleaQ2g=;
        b=n8qZNKHDJ8ZkQN8s6YCFhUc5vlrIehXvAzssrfT4lOFAEgM70y7j9ccF+kTN544/il9mhv
        /Qwyv0zoAHdwAPeCdmanHqcxV7A/7XcL4G5u9c/o5+tWUqR2xZIKUSlHotdEAwwwHhjWvg
        KLK2CGyPGmGk32bcLUct3rbhOUMJhk8=
Date:   Wed, 30 Aug 2023 14:11:31 +0800
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
 <c728bf3f-d9db-4865-8473-058b26c11c06@linux.dev>
 <ZO3cI+DkotHQo3md@casper.infradead.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZO3cI+DkotHQo3md@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/29/23 19:53, Matthew Wilcox wrote:
> On Tue, Aug 29, 2023 at 03:46:13PM +0800, Hao Xu wrote:
>> On 8/28/23 05:32, Matthew Wilcox wrote:
>>> On Sun, Aug 27, 2023 at 09:28:31PM +0800, Hao Xu wrote:
>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>
>>>> Add a boolean parameter for file_accessed() to support nowait semantics.
>>>> Currently it is true only with io_uring as its initial caller.
>>>
>>> So why do we need to do this as part of this series?  Apparently it
>>> hasn't caused any problems for filemap_read().
>>>
>>
>> We need this parameter to indicate if nowait semantics should be enforced in
>> touch_atime(), There are locks and maybe IOs in it.
> 
> That's not my point.  We currently call file_accessed() and
> touch_atime() for nowait reads and nowait writes.  You haven't done
> anything to fix those.
> 
> I suspect you can trim this patchset down significantly by avoiding
> fixing the file_accessed() problem.  And then come back with a later
> patchset that fixes it for all nowait i/o.  Or do a separate prep series

I'm ok to do that.

> first that fixes it for the existing nowait users, and then a second
> series to do all the directory stuff.
> 
> I'd do the first thing.  Just ignore the problem.  Directory atime
> updates cause I/O so rarely that you can afford to ignore it.  Almost
> everyone uses relatime or nodiratime.

Hi Matthew,
The previous discussion shows this does cause issues in real
producations: 
https://lore.kernel.org/io-uring/2785f009-2ebb-028d-8250-d5f3a30510f0@gmail.com/#:~:text=fwiw%2C%20we%27ve%20just%20recently%20had%20similar%20problems%20with%20io_uring%20read/write





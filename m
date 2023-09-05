Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780ED793234
	for <lists+io-uring@lfdr.de>; Wed,  6 Sep 2023 00:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjIEW52 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Sep 2023 18:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbjIEW52 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Sep 2023 18:57:28 -0400
X-Greylist: delayed 452 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Sep 2023 15:57:24 PDT
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3078EB
        for <io-uring@vger.kernel.org>; Tue,  5 Sep 2023 15:57:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC5FC433C7;
        Tue,  5 Sep 2023 22:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693954192;
        bh=rXRSGShzmvnqZZ2Us9gU41YxRXaVN1aed92JhI/FfjE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XnSjkZ0sIIrm0rfhStmWwCL+27qYJ0IORFJAx1aCgF+TED5iZRwoewOQFFgEM4qV3
         kGACvUWhZe9XwEHab/QGYd9m+qiObgGJw9uvPSKxV3qzS78jAbeANSAAyoY+BlFc3d
         ntfQLd/mT3KgLCRYAdpG0mb2oLzhNgjQe8qgs9nVNXUE4DExGIXMZZv3WUyc1wLL99
         l8bSzu7zzIknHBwS6yLcO6wq+56Ty0/7AD+za95Zw4+UMwRIyeBTG3tM96tYfcBJcu
         JeeHDFMlDCkb4ghiFmSDsUPr/nA498fc4vAPBzOt4rdXQJQfQBBXy6xJboCsBB1ttQ
         B3n5aIwNrF14Q==
Date:   Tue, 5 Sep 2023 15:49:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Breno Leitao <leitao@debian.org>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        krisman@suse.de, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v4 00/10] io_uring: Initial support for {s,g}etsockopt
 commands
Message-ID: <20230905154951.0d0d3962@kernel.org>
In-Reply-To: <20230904162504.1356068-1-leitao@debian.org>
References: <20230904162504.1356068-1-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon,  4 Sep 2023 09:24:53 -0700 Breno Leitao wrote:
> Patches 1-2: Modify the BPF hooks to support sockptr_t, so, these functions
> become flexible enough to accept user or kernel pointers for optval/optlen.

Have you seen:

https://lore.kernel.org/all/CAHk-=wgGV61xrG=gO0=dXH64o2TDWWrXn1mx-CX885JZ7h84Og@mail.gmail.com/

? I wasn't aware that Linus felt this way, now I wonder if having
sockptr_t spread will raise any red flags as this code flows back
to him.

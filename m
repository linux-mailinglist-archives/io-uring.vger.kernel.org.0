Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BBB5673EB
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 18:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbiGEQLj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 12:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiGEQLi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 12:11:38 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A821A3A5;
        Tue,  5 Jul 2022 09:11:37 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D46A367373; Tue,  5 Jul 2022 18:11:32 +0200 (CEST)
Date:   Tue, 5 Jul 2022 18:11:32 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Stefan Roesch <shr@fb.com>,
        io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>, rgoldwyn@suse.com
Subject: Re: [PATCH v7 15/15] xfs: Add async buffered write support
Message-ID: <20220705161132.GA13721@lst.de>
References: <20220601210141.3773402-1-shr@fb.com> <20220601210141.3773402-16-shr@fb.com> <Yr56ci/IZmN0S9J6@ZenIV> <0a75a0c4-e2e5-b403-27bc-e43872fecdc1@kernel.dk> <ef7c1154-b5ba-4017-f9fd-dea936a837fc@kernel.dk> <ca60a7dc-b16d-d8ce-f56c-547b449da8c9@kernel.dk> <Yr83aD0yuEwvJ7tL@magnolia> <47dd9e6a-4e08-e562-12ff-5450fc42da77@kernel.dk> <YsRA7TGWA7ovZjrF@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsRA7TGWA7ovZjrF@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 05, 2022 at 09:47:25AM -0400, Josef Bacik wrote:
> This appears to be just a confusion about what we think NOWAIT should mean.
> Looking at the btrfs code it seems like Goldwyn took it as literally as possible
> so we wouldn't do any NOWAIT IO's unless it was into a NOCOW area, meaning we
> literally wouldn't do anything other than wrap the bio up and fire it off.

It means don't do anything that would block.  And I suspect in btrfs
the above is about as much as you can do without blocking.

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42EF5BE5CC
	for <lists+io-uring@lfdr.de>; Tue, 20 Sep 2022 14:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiITMbP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Sep 2022 08:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiITMbO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Sep 2022 08:31:14 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886E75C371;
        Tue, 20 Sep 2022 05:31:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9812E1F388;
        Tue, 20 Sep 2022 12:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1663677071;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2bgwVlc2BkS8D3uLS4rTtGU5/zoc+8gMQg61kDwgsDc=;
        b=g0bRe7BNpMa58aMEDDvC4k26Rb2K9qG08IMSfkDViwdEcsZ0Y68f1DTFtbGCbfCKtsNt/b
        qiSHicPF/GJWUFY8e1BbmrvXnEfDk6ker/+9sNWSmptaaHhPSnwG2gb1GALZY3vSd5BWuF
        t+46lF/a+422QvdiBp5dZlza1stp4cU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1663677071;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2bgwVlc2BkS8D3uLS4rTtGU5/zoc+8gMQg61kDwgsDc=;
        b=4pZqqZIlDzwdzk5g19i+fqVpOgtmoubnTEFilxEvrQzT5ovOtfV2ImqDiXc/+D3umWM/+J
        kA2qJgaWAZVfzxDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 667D813ABB;
        Tue, 20 Sep 2022 12:31:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HulmF4+yKWPyWQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 20 Sep 2022 12:31:11 +0000
Date:   Tue, 20 Sep 2022 14:25:40 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org, axboe@kernel.dk,
        josef@toxicpanda.com, fdmanana@gmail.com
Subject: Re: [PATCH v3 00/12] io-uring/btrfs: support async buffered writes
Message-ID: <20220920122540.GY32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20220912192752.3785061-1-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912192752.3785061-1-shr@fb.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 12, 2022 at 12:27:40PM -0700, Stefan Roesch wrote:
> This patch series adds support for async buffered writes when using both
> btrfs and io-uring. Currently io-uring only supports buffered writes (for btrfs)
> in the slow path, by processing them in the io workers. With this patch series
> it is now possible to support buffered writes in the fast path. To be able to use
> the fast path, the required pages must be in the page cache, the required locks
> in btrfs can be granted immediately and no additional blocks need to be read
> form disk.
> 
> This patch series makes use of the changes that have been introduced by a
> previous patch series: "io-uring/xfs: support async buffered writes"
> 
> Performance results:
> 
> The new patch improves throughput by over two times (compared to the exiting
> behavior, where buffered writes are processed by an io-worker process) and also
> the latency is considerably reduced. Detailled results are part of the changelog
> of the first commit.

Thanks. It's late for including this patches to 6.1 queue but it's now
in for-next and will be added to misc-next after rc1, targeting merge to
6.2. I did some minor fixups, so please don't resend full series unless
there's a significant change. Incremental changes are fine if needed.

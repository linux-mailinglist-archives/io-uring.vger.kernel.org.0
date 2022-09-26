Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B606D5EA607
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 14:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239526AbiIZM2E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 08:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237648AbiIZM1O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 08:27:14 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E032FB02A3;
        Mon, 26 Sep 2022 04:07:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A9ABC1FA8E;
        Mon, 26 Sep 2022 11:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1664190081;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GsrU7R0Neiutx0vrcQjSmf96eIp4jSzoF7nSu2fXz8s=;
        b=U2kAuFUfAo6zSL7w2/6rS0OPmVHP2rXdlWmlkB64DmgadIIzK5/WcmP+o3Xjv+vZAgg4+i
        PZpeBHWxk8fWArBK53DHolp41lQCVe4dus1vTGGGjKsQnliZutBAswhDjzQP3f8Y7d01XK
        Z2L+xQiGGKi9yIgir0PzYafndejxhag=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1664190081;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GsrU7R0Neiutx0vrcQjSmf96eIp4jSzoF7nSu2fXz8s=;
        b=MNje5hx1weIb0YV/PEO6rWlPUrc9MbO49pJcPvUs1KHyExLmhDjTNKFIYuiuGIANlvgpKM
        G4qUmg9c7pk8l8CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 571B813486;
        Mon, 26 Sep 2022 11:01:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id G1gaFIGGMWMrJgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 26 Sep 2022 11:01:21 +0000
Date:   Mon, 26 Sep 2022 12:55:46 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Stefan Roesch <shr@fb.com>, kernel-team@fb.com,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-mm@kvack.org, axboe@kernel.dk, josef@toxicpanda.com,
        fdmanana@gmail.com
Subject: Re: [PATCH v3 02/12] btrfs: implement a nowait option for tree
 searches
Message-ID: <20220926105546.GS32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20220912192752.3785061-1-shr@fb.com>
 <20220912192752.3785061-3-shr@fb.com>
 <20220926091440.GA1198392@falcondesktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926091440.GA1198392@falcondesktop>
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

On Mon, Sep 26, 2022 at 10:14:40AM +0100, Filipe Manana wrote:
> On Mon, Sep 12, 2022 at 12:27:42PM -0700, Stefan Roesch wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> > +{
> > +	struct extent_buffer *eb;
> > +
> > +	while (1) {
> > +		eb = btrfs_root_node(root);
> > +		if (!btrfs_try_tree_read_lock(eb))
> > +			return ERR_PTR(-EAGAIN);
> 
> There's a leak of the extent buffer here.
> This fixes it up:
> 
> diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
> index 9d53bcfb6d9b..0eab3cb274a1 100644
> --- a/fs/btrfs/locking.c
> +++ b/fs/btrfs/locking.c
> @@ -298,8 +298,10 @@ struct extent_buffer *btrfs_try_read_lock_root_node(struct btrfs_root *root)
>  
>         while (1) {
>                 eb = btrfs_root_node(root);
> -               if (!btrfs_try_tree_read_lock(eb))
> +               if (!btrfs_try_tree_read_lock(eb)) {
> +                       free_extent_buffer(eb);
>                         return ERR_PTR(-EAGAIN);
> +               }
>                 if (eb == root->node)
>                         break;
>                 btrfs_tree_read_unlock(eb);

Folded to the commit, thanks.
